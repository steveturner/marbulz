//
//  GameScene.h
//  Marbulz
//
//  Created by Steven Turner on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"


// class forwards to avoid #import at header level (speeds up compilation)
@class GameBackground;
@class GameHUD;
@class GameObjects;
@class GamePaths;
@class GameUI;
@class TargetObjects;



typedef enum
{
	GameSceneLayerTagGame =1,
} GameSceneLayerTags;

typedef enum
{
	GameSceneNodeTagBall = 1,
	GameSceneNodeTagHole,
	GameSceneNodeTagBatch
} GameSceneNodeTags;

@interface GameScene : CCLayer {
	b2World* world;
	ContactListener* contactListener;
	GLESDebugDraw* debugDraw;
<<<<<<< HEAD
	
	
	// in z order:
	GameBackground* background;

	
	
	
=======
>>>>>>> Moving files around and fixing fixes implementation.
}

+(id) scene;
+(GameScene*) sharedGameScene;
-(CCSpriteBatchNode*) getSpriteBatch;
-(void) gameOver;

@end

