//
//  Ball.m
//  Marbulz
//
//  Created by Steven Turner on 9/23/12.
//
//

#import "Ball.h"
#import "Helper.h"
#import "Constants.h"

@interface Ball (PrivateMethods)
-(void) createBallInWorld:(b2World*)world withPos:(CGPoint)pos;
@end

@implementation Ball
-(id) initWithWorld:(b2World*)world withPos:(CGPoint)pos
{
	if ((self = [super init])) {
		[self createBallInWorld:world withPos:pos];
	}
	return self;
}

+(id) newBallInWorld:(b2World*)world withPos:(CGPoint)pos
{
	return [[self alloc] initWithWorld:world withPos:pos] ;
}

-(void) createBallInWorld:(b2World*)world withPos:(CGPoint)pos
{
	//CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:pos];
	bodyDef.angularDamping = 0.9;
	
	NSString* spriteFramName = @"Ball_6.png";
	CCSprite* tempSprite = [CCSprite spriteWithFile:spriteFramName];
	
	b2CircleShape shape;
	float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
	shape.m_radius = radiusInMeters;
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 5.0f*CC_CONTENT_SCALE_FACTOR();
	fixtureDef.friction = 0.0f;
	fixtureDef.restitution = 0.4f;
	
	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteName:spriteFramName];
}

@end
