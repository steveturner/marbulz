//
//  ObjectDef.h
//  line-drawing-game
//
//  Created by Steffen Itterheim on 09.04.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "AssetHelper.h"

/** list of all ObjectTypes that are defined */
typedef enum
{
	ObjectTypeHelicopter,
	ObjectTypeAirplane,
	
	/** this many ObjectTypes are defined */
	ObjectTypes_MAX,
} ObjectTypes;

/** since images can be drawn in various rotations and there is no standard approach these identifiers are used
 to determine if an object's image is drawn with the object facing right, up, left or down. The identifiers equal
 direction offsets so that the image is correctly rotated and always faces forward. If your images follow the path
 sideways or backwards change the image orientation in the ObjectDefMake call. */
typedef enum
{
	ImageOrientationRight = 0,
	ImageOrientationUp = -90,
	ImageOrientationLeft = -180,
	ImageOrientationDown = -270,
} ImageOrientations;

/** Contains all configurable gameplay parameters of any MovingObject. */
@interface ObjectDef : NSObject
	/** the type of the object, one of the ObjectTypes enum values */
@property	ObjectTypes type;
	/** the image file for this object */
@property (copy)	NSString* imageFileName;
	/** the image file for the proximity warning used by this object */
@property (copy)	NSString* proximityWarningFileName;
	/** define how the image is oriented, Right means the sprite image is oriented to the right, Up to top, etc. 
	 If you notice that your images are rotated at 90 degrees or backwards compared to the movement direction then you need to adjust
	 this property and set the correct orientation for your images. I assume most images are drawn pointing upwards so the most commonly
	 used value will be ImageOrientationUp. */
@property	ImageOrientations imageOrientation;
	/** how fast the object moves, good values are in range 5-40 */
@property	float speed;
	/** how fast the object will rotate to face the direction it is moving to, it's in fractions of a second, a good value is 0.5f */
@property	float rotationSpeed;
	/** how big the touch area of the object is where it recognizes a touch, typically twice the size of the collision radius */
@property	float touchRadius;
	/** how big the collision radius is, if anything gets closer than collisionRadius pixels the object will collide (crash) */
@property	float collisionRadius;
	// feel free to add more here as needed ...
@end

/** Convenience method to create and initialize an ObjectDef struct. Used to define properties of individual MovingObjects. 
 Don't forget to extend this method whenever you make changes to the ObjectDef struct! */
static __inline__ ObjectDef* ObjectDefMake(ObjectTypes type, NSString* imageFileName, NSString* proximityWarningFileName, ImageOrientations imageOrientation, float speed, float rotationSpeed, float touchRadius, float collisionRadius)
{
	ObjectDef* def = [[ObjectDef alloc] init];
	def.type = type;
	def.imageFileName = [[AssetHelper getDeviceSpecificFileNameFor:imageFileName] copy];
	def.proximityWarningFileName = [[AssetHelper getDeviceSpecificFileNameFor:proximityWarningFileName] copy];
	def.imageOrientation = imageOrientation;
	def.speed = speed;
	def.rotationSpeed = rotationSpeed;
	def.touchRadius = touchRadius;
	def.collisionRadius = collisionRadius;
	return def;
}
