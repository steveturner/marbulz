//
//  MovingObject.m
//
//  Created by Steffen Itterheim on 08.04.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "MovingObject.h"

#import "ActionTags.h"
#import "GameHUD.h"
#import "MathHelper.h"
#import "Motivationals.h"
#import "Path.h"


@interface MovingObject (Private)
-(void) onArrivedAtPathPoint;
-(void) onFadeOutDone;
-(void) onProximityWarningTimeOut;
-(void) onArrivedAtTarget;
-(void) update:(ccTime)delta;
-(void) setState:(EObjectStates)newState;
-(void) setStateInactive;
-(bool) canShowProximityWarning;
@end

@implementation MovingObject

@synthesize def;
@synthesize state;

+(id) movingObjectWithDef:(ObjectDef*)objectDef
{
	return [[self alloc] initMovingObjectWithDef:objectDef];
}

-(id) initMovingObjectWithDef:(ObjectDef*)objectDef
{
	if ((self = [super initWithFile:objectDef.imageFileName]))
	{
		def = objectDef;

		state = kStateNormal;
		
		switch (def.type)
		{
			case ObjectTypeHelicopter:
			{
				self.color = ccBLUE;
				CCSprite* rotor = [CCSprite spriteWithFile:[AssetHelper getDeviceSpecificFileNameFor:@"rotorblades_moving.png"]];
				rotor.position = self.anchorPointInPoints;
				rotor.opacity = 160;
				rotor.color = ccGRAY;
				[self addChild:rotor z:1];
				CCRotateBy* rotate = [CCRotateBy actionWithDuration:1.0f angle:720];
				CCRepeatForever* repeat = [CCRepeatForever actionWithAction:rotate];
				[rotor runAction:repeat];
				break;
			}
			case ObjectTypeAirplane:
				self.color = ccRED;
				break;
			default:
				break;
		}
		
		proximityWarning = [CCSprite spriteWithFile:def.proximityWarningFileName];
		proximityWarning.visible = NO;
		proximityWarning.opacity = 144;
		proximityWarning.position = CGPointMake(contentSize_.width / 2, contentSize_.height / 2);
		[self addChild:proximityWarning z:-1];
		
		[self schedule:@selector(update:)];
	}

	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
}

#pragma mark MovingObject - Movement

-(void) moveTo:(CGPoint)location target:(id)target selector:(SEL)selector
{
	float fixedSpeedDuration = [MathHelper getFixedSpeedDurationBetweenPoint:position_ andPoint:location forSpeed:def.speed];

	// stopAllActions seems to be the only thing that can stop a sequence from calling the callfunc it contains
	// the downside is that moving objects can't run any other actions while following a path
	if ([self isFollowingPath])
	{
		[self stopAllActions];
	}
	
	CCMoveTo* move = [CCMoveTo actionWithDuration:fixedSpeedDuration position:location];
	move.tag = ActionTagObjectMoveToLocation;
	
	if (target == nil)
	{
		[self runAction:move];
	}
	else
	{
		CCLOG(@"CCCallFunc target: %@ -- self: %@", target, self);
		CCCallFunc* callback = [CCCallFunc actionWithTarget:target selector:selector];
		CCLOG(@"callback action: %@", callback);
		callback.tag = ActionTagObjectMoveToLocationCallback;
		CCSequence* sequence = [CCSequence actions:move, callback, nil];
		sequence.tag = ActionTagObjectMoveToLocationSequence;
		[self runAction:sequence];
	}
	
	float direction = def.imageOrientation + [MathHelper getDirectionFromPoint:position_ toPoint:location];
	CCRotateTo* rotate = [CCRotateTo actionWithDuration:def.rotationSpeed angle:-direction];
	rotate.tag = ActionTagObjectRotateToAngle;

	[self stopActionByTag:ActionTagObjectRotateToAngle];
	[self runAction:rotate];

	prevPosition = position_;
	
	CCLOG(@"moveTo             - rot: %.3f, dir: %.3f (%.3f) -- pos: (%.0f, %.0f) --> pos: (%.0f, %.0f)", 
		  rotation_, direction, CC_DEGREES_TO_RADIANS(direction), position_.x, position_.y, location.x, location.y);
}

-(void) moveTo:(CGPoint)location
{
	[self moveTo:location target:nil selector:nil];
}

-(void) moveToScreenBorder:(float)direction
{
	CGPoint location = [MathHelper getDistantPointInDirection:direction fromLocation:position_];
	//CCLOG(@"moveToScreenBorder - rot: %.3f, dir: %.3f (%.3f) -- pos: (%.0f, %.0f) --> pos: (%.0f, %.0f)", rotation_, direction, CC_DEGREES_TO_RADIANS(direction), position_.x, position_.y, location.x, location.y);
	[self moveTo:location];
}

-(void) moveInDirectionOfLocation:(CGPoint)location
{
	float newDirection = [MathHelper getDirectionFromPoint:position_ toPoint:location];
	CGPoint newMoveToLocation = [MathHelper getDistantPointInDirection:newDirection fromLocation:location];
	[self moveTo:newMoveToLocation];
}

-(void) continueMovingInSameDirection
{
	CCLOG(@"continueMovingInSameDirection: prevPosition: (%.1f, %.1f) - currentPosition: (%.1f, %.1f)", prevPosition.x, prevPosition.y, position_.x, position_.y);
	// just move in same direction just very far out
	CGPoint location = ccpMult(ccpSub(position_, prevPosition), 2000.0f);
	[self moveTo:location];
}

-(float) moveIntoScreen
{
	// let's make it simple and just move towards screen center
	// it should be easy to extend this with a fixed angle (careful: make sure your objects always enter the screen area at some point)
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = CGPointMake(screenSize.width / 2, screenSize.height / 2);
	[self moveInDirectionOfLocation:center];

	float direction = [MathHelper getDirectionFromPoint:position_ toPoint:center];
	return direction;
}

#pragma mark Pathing

-(void) stopPathFollow
{
	[path removePath];
	path = nil;

	[self setState:kStateNormal];
}

-(void) startPathFollow:(Path*)followPath
{
	[self stopPathFollow];
	
	path = followPath;
	[self setState:kStateFollowingPath];
}

-(void) moveToNextPathPoint
{
	PathPoint pathPoint = [path getFirstPathPoint];
	[self moveTo:pathPoint.location target:self selector:@selector(onArrivedAtPathPoint)];
}

-(void) onArrivedAtPathPoint
{
	CCLOG(@"onArrivedAtPoint");
	// remove the first point, we don't need it anymore and we also don't want it to be drawn anymore
	if ([path getNumPoints] > 0)
	{
		// check if it was an endpoint
		PathPoint firstPoint = [path getFirstPathPoint];
		if (firstPoint.isEndPoint)
		{
			[self onArrivedAtTarget];
			[path removeAllPoints];
		}
		else
		{
			[path removeFirstPoint];
		}
	}
	
	// if we still have points left move to the next
	if ([path getNumPoints] > 0)
	{
		[self moveToNextPathPoint];
	}
	else if (path.isUserStillDrawingThisPath == false)
	{
		// path ended here, we're free to move again
		[self stopPathFollow];
		[self continueMovingInSameDirection];
	}
}

-(void) onPathPointAdded
{
	// start following the path as soon as there are points available
	// note that the number may drop to zero and then go up again, 
	// if the player draws, stops and the object catches up with his finger
	if ([path getNumPoints] == 1)
	{
		[self moveToNextPathPoint];
	}
}

-(void) onArrivedAtTarget
{
	// TODO: play sound & FX
	[Motivationals showLabelAt:position_];
	[self setStateInactive];
	CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:0.5f];
	CCCallFunc* callFunc = [CCCallFunc actionWithTarget:self selector:@selector(onFadeOutDone)];
	CCSequence* sequence = [CCSequence actions:fadeOut, callFunc, nil];
	[self runAction:sequence];
	[self setProximityWarningEnabled:NO];
	
	[GameHUD increaseScore];
}

-(void) onFadeOutDone
{
	[[self parent] removeChild:self cleanup:YES];
}


#pragma mark Events

-(void) onTouch
{
	// TODO: play sound here and/or flash object when touched
}

/** checks if the object is too close to the screen border and if so, it will turn the object around (it bounces back) */
-(void) turnAroundAtScreenBorder
{
	/*
	 a better, more general solution
	 http://stackoverflow.com/questions/573084/how-to-calculate-bounce-angle
	*/

	float minBorderDistance = def.collisionRadius * 0.5f;
	CGSize border = [[CCDirector sharedDirector] winSize];
	border.width -= minBorderDistance;
	border.height -= minBorderDistance;

	CGPoint movementVector = ccpSub(prevPosition, position_);
	
	if (position_.x <= minBorderDistance || position_.x >= border.width)
	{
		CGPoint newMoveToLocation = CGPointMake(prevPosition.x, prevPosition.y - (movementVector.y * 2));

		// turn around only if we're actually moving towards the screen border, otherwise we might get "stuck" (repeated turn-arounds)
		if ((position_.x < minBorderDistance && newMoveToLocation.x > position_.x) || (position_.x > border.width && newMoveToLocation.x < position_.x))
		{
			[self moveInDirectionOfLocation:newMoveToLocation];
		}
	}
	else if (position_.y <= minBorderDistance || position_.y >= border.height)
	{
		CGPoint newMoveToLocation = CGPointMake(prevPosition.x - (movementVector.x * 2), prevPosition.y);

		// turn around only if we're actually moving towards the screen border, otherwise we might get "stuck" (repeated turn-arounds)
		if ((position_.y < minBorderDistance && newMoveToLocation.y > position_.y) || (position_.y > border.height && newMoveToLocation.y < position_.y))
		{
			[self moveInDirectionOfLocation:newMoveToLocation];
		}
	}
}

-(void) update:(ccTime)delta
{
	if ([self isFollowingPath])
	{
		// let path know where we are
		path.objectPosition = position_;
	}
	else
	{
		[self turnAroundAtScreenBorder];
	}
}

-(void) onProximityWarningTimeOut
{
	[self unschedule:_cmd];
	
	proximityWarning.visible = NO;
}

-(void) setProximityWarningEnabled:(bool)enabled
{
	if ([self canShowProximityWarning])
	{
		if (proximityWarning.visible == NO && enabled)
		{
			[self schedule:@selector(onProximityWarningTimeOut) interval:0.2f];
			// TODO: play sound here
		}
		else if (proximityWarning.visible == YES && enabled)
		{
			// increase time proximity warning is displayed
			[self unschedule:@selector(onProximityWarningTimeOut)];
			[self schedule:@selector(onProximityWarningTimeOut) interval:0.2f];
		}
		
		proximityWarning.visible = enabled;
	}
}

-(void) setCrashWarning
{
	[self unschedule:@selector(onProximityWarningTimeOut)];
	[self schedule:@selector(onProximityWarningTimeOut) interval:4.0f];
	proximityWarning.visible = YES;
}

-(void) setState:(EObjectStates)newState
{
	// protect the inactive state against unvoluntary change
	if (state != kStateInactive)
	{
		state = newState;
	}
}

-(void) setStateInactive
{
	state = kStateInactive;
}

-(bool) canShowProximityWarning
{
	return (state != kStateInactive);
}

-(bool) canFollowPath
{
	return (state == kStateNormal || state == kStateFollowingPath);
}

-(bool) canCollide
{
	return (state != kStateInactive);
}

-(bool) isFollowingPath
{
	return (state == kStateFollowingPath);
}

@end
