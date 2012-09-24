/*
 *  ActionTags.h
 *  line-drawing-game
 *
 *  Created by Steffen Itterheim on 09.04.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 */

/** ActionTags is a global enum to ensure that no tags used with actions can be duplicate */
typedef enum
{
	// used by actions of MovingObject
	ActionTagObjectRotateToAngle = 1,
	ActionTagObjectMoveToLocation,
	ActionTagObjectMoveToLocationCallback,
	ActionTagObjectMoveToLocationSequence,
	
	ActionTags_MAX,
} ActionTags;
