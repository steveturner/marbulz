//
//  ObjectDefs.m
//
//  Created by Steffen Itterheim on 08.04.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "ObjectDefs.h"

#import "MovingObject.h"


@interface ObjectDefs (Private)
-(void) initAllObjects;
@end

@implementation ObjectDefs

static ObjectDefs *instanceOfObjectDefs;

-(ObjectDefs*) init
{
	if ((self = [super init]))
	{
		[self initAllObjects];
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	instanceOfObjectDefs = nil;

}

#pragma mark ObjectDefs - initAllObjects

-(void) initAllObjects
{
	for (ObjectTypes type = 0; type < ObjectTypes_MAX; type++)
	{
		// the switch statement is useful because together with the compiler warning "Check Switch Statements"
		// the compiler will let us know if we forgot to add a new type to the ObjectTypes enum
		// Note: the current parameters are not perfectly balanced ...
		switch (type)
		{
			case ObjectTypeHelicopter:
			{
#ifdef TARGET_IPAD
				int speed = 20;
				float rotationSpeed = 0.4f;
				int touchRadius = 48;
				int collRadius = 32;
#else
				int speed = 14;
				float rotationSpeed = 0.25f;
				int touchRadius = 32;
				int collRadius = 16;
#endif
				objectTypes[type] = ObjectDefMake(type, @"helicopter.png", @"proximitywarning.png", ImageOrientationLeft, speed, rotationSpeed, touchRadius, collRadius);
				break;
			}

			case ObjectTypeAirplane:
			{
#ifdef TARGET_IPAD
				int speed = 35;
				float rotationSpeed = 0.5f;
				int touchRadius = 48;
				int collRadius = 32;
#else
				int speed = 22;
				float rotationSpeed = 0.3f;
				int touchRadius = 32;
				int collRadius = 16;
#endif
				objectTypes[type] = ObjectDefMake(type, @"airplane.png", @"proximitywarning.png", ImageOrientationLeft, speed, rotationSpeed, touchRadius, collRadius);
				break;
			}
				
				// and so on ...
				
				// compiler warning requires us to add this:
			case ObjectTypes_MAX:
				NSAssert(false, @"ObjectDefs - initAllObjects: type is ObjectTypes_MAX");
				break;
		}
	}
}

-(ObjectDef*) getObjectDefByType:(ObjectTypes)type
{
	NSAssert(type >= 0 && type < ObjectTypes_MAX, @"ObjectDefs - getObjectByType: type is out of range!");
	return objectTypes[type];
}

-(MovingObject*) createMovingObjectOfType:(ObjectTypes)type
{
	ObjectDef* objectDef = [self getObjectDefByType:type];
	return [MovingObject movingObjectWithDef:objectDef];
}


// Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfObjectDefs == nil, @"Attempted to allocate a second instance of the singleton: ObjectDefs");
		instanceOfObjectDefs = [super alloc];
		return instanceOfObjectDefs;
	}
	
	// to avoid compiler warning
	return nil;
}

+(ObjectDefs*) sharedObjectDefs
{
	@synchronized(self)
	{
		if (instanceOfObjectDefs == nil)
		{
			instanceOfObjectDefs = [[ObjectDefs alloc] init];
		}
		
		return instanceOfObjectDefs;
	}
	
	// to avoid compiler warning
	return nil;
}

@end
