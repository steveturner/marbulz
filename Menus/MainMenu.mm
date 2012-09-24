//
//  MainMenu.m
//  Marbulz
//
//  Created by Steven Turner on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"

#import "GameScene.h"

@interface MainMenu (Private)
-(void) nextScene:(ccTime)delta;
@end

@implementation MainMenu

+(id) scene
{
	CCScene *s = [CCScene node];
	id node = [MainMenu node];
	[s addChild:node];
	return s;
}

-(id) init
{
	if ((self = [super init]))
	{
		
		// the main menu is just a placeholder to stuff in all your menu needs, it is for you to extend
		// for now it simply advances to the GameScene
		
		
		
		[self schedule:@selector(nextScene:) interval:0.2f];
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
}

-(void) nextScene:(ccTime)delta
{
	[self unschedule:_cmd];
	
	
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[GameScene scene] withColor:ccBLACK]];
}

@end
