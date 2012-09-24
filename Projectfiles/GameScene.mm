//
//  GameScene.m
//  Marbulz
//
//  Created by Steven Turner on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "Box2DDebugLayer.h"
#import "GameBackground.h"

@interface GameScene (PrivateMethods)
@end

@implementation GameScene

@synthesize helloWorldString, helloWorldFontName;
@synthesize helloWorldFontSize;

+(id) scene
{
	CCScene* s = [CCScene node];
	id node = [GameScene node];
	[s addChild:node];
	return s;
}


-(id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"%@ init", NSStringFromClass([self class]));
		
		CCDirector* director = [CCDirector sharedDirector];
		
		background = [GameBackground background];
		[self addChild:background z:0];
		// init the box2d world
		b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
		world = new b2World(gravity);
		world->SetAllowSleeping(YES);
		
		CCMenuItem *starMenuItem = [CCMenuItemImage
									itemFromNormalImage:@"Ball_6.png" selectedImage:@"Ball_5.png"
									target:self selector:@selector(starButtonTapped:)];
		starMenuItem.position = ccp(60, 60);
		CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
		starMenu.position = CGPointZero;
		[self addChild:starMenu];
		
		
		CCSprite* sprite = [CCSprite spriteWithFile:@"Ball_6.png"];
		sprite.position = director.screenCenter;
		sprite.scale = 0;
		[self addChild:sprite];
		
		id scale = [CCScaleTo actionWithDuration:1.0f scale:1.6f];
		[sprite runAction:scale];
		id move = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0, -120)];
		[sprite runAction:move];

		// get the hello world string from the config.lua file
		[KKConfig injectPropertiesFromKeyPath:@"HelloWorldSettings" target:self];
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:helloWorldString 
											   fontName:helloWorldFontName 
											   fontSize:helloWorldFontSize];
		label.position = director.screenCenter;
		label.color = ccGREEN;
		[self addChild:label];

		// print out which platform we're on
		NSString* platform = @"(unknown platform)";
		
		if (director.currentPlatformIsIOS)
		{
			// add code 
			platform = @"iPhone/iPod Touch";
			
			if (director.currentDeviceIsIPad)
				platform = @"iPad";

			if (director.currentDeviceIsSimulator)
				platform = [NSString stringWithFormat:@"%@ Simulator", platform];
		}
		else if (director.currentPlatformIsMac)
		{
			platform = @"Mac OS X";
		}
		
		CCLabelTTF* platformLabel = nil;
		if (director.currentPlatformIsIOS) 
		{
			// how to add custom ttf fonts to your app is described here:
			// http://tetontech.wordpress.com/2010/09/03/using-custom-fonts-in-your-ios-application/
			float fontSize = (director.currentDeviceIsIPad) ? 48 : 28;
			platformLabel = [CCLabelTTF labelWithString:platform 
											   fontName:@"Ubuntu Condensed"
											   fontSize:fontSize];
		}
		else if (director.currentPlatformIsMac)
		{
			// Mac builds have to rely on fonts installed on the system.
			platformLabel = [CCLabelTTF labelWithString:platform 
											   fontName:@"Zapfino" 
											   fontSize:32];
		}

		platformLabel.position = director.screenCenter;
		platformLabel.color = ccYELLOW;
		[self addChild:platformLabel];
		
		id movePlatform = [CCMoveBy actionWithDuration:0.2f 
											  position:CGPointMake(0, 50)];
		[platformLabel runAction:movePlatform];

		glClearColor(0.2f, 0.2f, 0.4f, 1.0f);

		// play sound with CocosDenshion's SimpleAudioEngine
		[[SimpleAudioEngine sharedEngine] playEffect:@"Pow.caf"];
		
		[self scheduleUpdate];
		
	}

	return self;
}

-(void) update:(ccTime)delta
{
	KKInput* input = [KKInput sharedInput];
	if (input.touchesAvailable)
	{
		NSUInteger color = 0;
		KKTouch* touch;
		CCARRAY_FOREACH(input.touches, touch)
		{
			CCLOG(@"Touch: mov=%d ",[touch phase]);
		}
	}
		
	if ([input isAnyTouchOnNode:self touchPhase:KKTouchPhaseAny])
	{
		CCLOG(@"Touch: beg=%d mov=%d sta=%d end=%d can=%d",
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseBegan],
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseMoved],
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseStationary],
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseEnded],
			  [input isAnyTouchOnNode:self touchPhase:KKTouchPhaseCancelled]);
	}
}

@end
