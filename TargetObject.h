//
//  TargetObject.h
//
//  Created by Steffen Itterheim on 30.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"

/** Defines the position, radius and type of places where your objects can land, dock, etc.
 Extend as needed. */
@interface TargetObject : CCNode
{
	float radius_;
}

@property (nonatomic) float radius;

/** initializes TargetObject class and returns an autoreleased instance of the class */
+(id) targetObjectWithRadius:(float)radius;
/** initializes TargetObject class and returns an instance of the class, you must take care of allocating the object yourself */
-(id) initWithRadius:(float)radius;

@end
