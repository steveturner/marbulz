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

@interface GameScene : CCLayer
{
	NSString* helloWorldString;
	NSString* helloWorldFontName;
	int helloWorldFontSize;
	
	
	b2World* world;
	ContactListener* contactListener;
	
	GLESDebugDraw* debugDraw;
	
	
	// in z order:
	GameBackground* background;

	
	
	
}

@property (nonatomic, copy) NSString* helloWorldString;
@property (nonatomic, copy) NSString* helloWorldFontName;
@property (nonatomic) int helloWorldFontSize;

/** creates the scene, returns an autoreleased object */
+(id) scene;

/** should not be called by you - use [GameScene scene] instead! */
-(id) init;

/** instance of GameScene, only valid as long as the scene is running (caution: it's not a proper Singleton!). It's meant for quick access to it from child nodes. */
+(GameScene*) instance;

/** returns true if the game is running, false if it is paused either because of the pause menu being shown or the game being over */
-(bool) isPlaying;

/** pauses the game, also called when AppDelegate receives incoming call etc. */
-(void) onPauseGame;

/** resumes the game when it is paused, otherwise does nothing */
-(void) onResumeGame;

/** pauses the scene for a moment, then resets */
-(void) onCrash;


@end
