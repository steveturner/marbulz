//
//  TargetObject.m
//
//  Created by Steffen Itterheim on 30.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "TargetObject.h"


@interface TargetObject (Private)
@end

@implementation TargetObject

@synthesize radius = radius_;

+(id) targetObjectWithRadius:(float)radius
{
	return [[self alloc] initWithRadius:radius];
}

-(id) initWithRadius:(float)radius
{
	if ((self = [super init]))
	{
		radius_ = radius;
	}

	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
}

-(void) draw
{
#if DEBUG
	// debug drawing helps placing the targets when you can see where they are and how big they are
	// btw, if you wonder why we draw the circle at CGPointZero, that's because the circle is drawn
	// relative to the node's position, and thus if we were to use the node's position as the circle's center
	// the circle would be drawn offset by the position ... meaning it's already correctly positioned, 
	// so the circle's position needs to be at 0,0
	ccDrawColor4F(1, 0, 1, 1);
	ccDrawCircle(CGPointZero, radius_, rotation_, 12, YES);
#endif
}

@end
