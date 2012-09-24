//
//  ObjectDefs.h
//
//  Created by Steffen Itterheim on 08.04.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "ObjectDef.h"


@class MovingObject;

/** Singleton that gives you access to all Object Definitions and is the central class for creating MovingObject types. It doubles as a factory
 for creating MovingObject instances by calling createMovingObjectOfType: - you should not create MovingObject objects yourself but route it
 through this class instead by extending it as needed. That way you keep definitions central as well as error handling. */
@interface ObjectDefs : NSObject
{
	ObjectDef* objectTypes[ObjectTypes_MAX];
}

/** returns the singleton object, like this: [ObjectDefs sharedObjectDefs] */
+(ObjectDefs*) sharedObjectDefs;

/** returns a new autorelease MovingObject instance which has ObjectDef set to the given type */
-(MovingObject*) createMovingObjectOfType:(ObjectTypes)type;

/** returns the ObjectDef for a given ObjectTypes type */
-(ObjectDef*) getObjectDefByType:(ObjectTypes)type;

@end
