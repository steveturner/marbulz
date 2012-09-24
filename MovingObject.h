//
//  MovingObject.h
//
//  Created by Steffen Itterheim on 08.04.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"

#import "ObjectDef.h"

/** defines different game states for the object */
typedef enum
{
	/** default state */
	kStateNormal = 0,
	/** is currently following a path */
	kStateFollowingPath,
	/** can not be interacted with, may just have landed or got killed */
	kStateInactive,
	
	MAX_ObjectStates,
} EObjectStates;

@class Path;

/** Moving objects are the objects the player can touch to draw a Path for them. They have common attributes like movement speed, rotation speed,
 collision radius and bounding box (a CGRect) which are mostly determined by using a specific ObjectDef. MovingObject can also have children like
 the collision warning sprites, touch highlights and it plays sounds as appropriate. */
@interface MovingObject : CCSprite
{
	ObjectDef* __unsafe_unretained def;
	
	/** holds the pointer to a Path object as long as the object is following that path */
	Path* path;
	
	CCSprite* proximityWarning;
	
	CGPoint prevPosition;
	
	/** an object can only be in one state at a time (StateMachine concept) */
	EObjectStates state;
}

/** give access to this object's ObjectDef which defines the object's type and other parameters */
@property (unsafe_unretained, nonatomic, readonly) ObjectDef* def;
/** returns the current object state */
@property (nonatomic, readonly) EObjectStates state;


/** initializes class and returns an autoreleased instance of the class */
+(id) movingObjectWithDef:(ObjectDef*)objectDef;
/** initializes class and returns an instance of the class, you must take care of allocating the object yourself */
-(id) initMovingObjectWithDef:(ObjectDef*)objectDef;

/** returns true if the object can collide with others, otherwise false */
-(bool) canCollide;
/** returns false if the object for whatever reason is out of the game, eg. it crashed, left the screen, or landed */
-(bool) canFollowPath;
/** returns true for the duration that the object is assigned to a path as pathFollowObject */
-(bool) isFollowingPath;
/** assigns this object a path that it will follow from now on */
-(void) startPathFollow:(Path*)followPath;

/** move the object to a certain location and fixed speed, will perform selector when it arrived */
-(void) moveTo:(CGPoint)location target:(id)target selector:(SEL)selector;
/** move the object to a certain location and fixed speed */
-(void) moveTo:(CGPoint)location;
/** object will move to the nearest screenborder in the given direction */
-(void) moveToScreenBorder:(float)direction;
/** called when object is spawned outside screen to have it move into the screen area */
-(float) moveIntoScreen;

/** signals the object that it has been touched (selected), usesful to play a sound or animation or change state. */
-(void) onTouch;
/** signals the object that another path point has been added, may trigger it to start moving */
-(void) onPathPointAdded;

/** enables or disables the proximity warning image and plays sound */
-(void) setProximityWarningEnabled:(bool)enabled;

/** enables the proximity warning and keeps it visible for longer */
-(void) setCrashWarning;

/** sets the ObjectState of the object unless the object is already set to kStateInactive */
-(void) setState:(EObjectStates)newState;

@end
