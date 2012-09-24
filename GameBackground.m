//
//  GameBackground.m
//
//  Created by Steffen Itterheim on 09.04.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "GameBackground.h"



@interface GameBackground (Private)
@end

@implementation GameBackground

+(id) background
{
	return [[self alloc] init];
}

-(id) init
{
	if ((self = [super init]))
	{
		// just one simple, static background here ... but there's room for more, eg background animations
		CCSprite* background = [CCSprite spriteWithFile:@"WoodDeck_1280x1024.png"];
<<<<<<< HEAD
		background.anchorPoint = CGPointZero;
=======
		background.anchorPoint = ccp(0,0);
        background.position = ccp(0,0);
		
		//background.anchorPoint = CGPointZero;
>>>>>>> Moving files around and fixing fixes implementation.
		[self addChild:background];
	}

	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
}

@end
