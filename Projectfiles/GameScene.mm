#import "GameScene.h"
<<<<<<< HEAD
#import "SimpleAudioEngine.h"
#import "Box2DDebugLayer.h"
#import "GameBackground.h"
=======
#import "Ball.h"
#import "Hole.h"
#import "Helper.h"
#import "CCMask.h"
//#import "EndGameScene.h"
>>>>>>> Moving files around and fixing fixes implementation.

@interface GameScene (PrivateMethods)
-(void)initBox2dWorld;
-(void) enableBox2dDebugDrawing;
@end

@implementation GameScene

static GameScene* instanceOfGameScene;

+(GameScene*) sharedGameScene
{
	NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameScene;
}

+(id) scene
{
	CCScene* scene = [CCScene node];
	GameScene* layer = [GameScene node];
	[scene addChild:layer z:0 tag:GameSceneLayerTagGame];
	return scene;
}

-(id) init
{
	if (( self = [super init])) {
		instanceOfGameScene = self;
		
		self.isAccelerometerEnabled = YES;
		
<<<<<<< HEAD
		background = [GameBackground background];
		[self addChild:background z:0];
		// init the box2d world
		b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
		world = new b2World(gravity);
		world->SetAllowSleeping(YES);
		
		CCMenuItem *starMenuItem = [CCMenuItemImage
									itemFromNormalImage:@"Ball_6.png" selectedImage:@"Ball_5.png"
									target:self selector:@selector(starButtonTapped:)];
		starMenuItem.position = ccp(60, 60);
		CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
		starMenu.position = CGPointZero;
		[self addChild:starMenu];
		
		
		CCSprite* sprite = [CCSprite spriteWithFile:@"Ball_6.png"];
		sprite.position = director.screenCenter;
		sprite.scale = 0;
		[self addChild:sprite];
=======
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		[self initBox2dWorld];
		
	/*	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameSprites.plist"];
>>>>>>> Moving files around and fixing fixes implementation.
		
		CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"GameSprites.png"];
		[self addChild:batch z:1 tag:GameSceneNodeTagBatch];
	*/	
		CCSprite* background = [CCSprite spriteWithFile:@"WoodDeck_1280x1024.png"];
		background.position = ccp(screenSize.width/2, screenSize.height/2);
		background.scaleX = 2;
		background.scaleY = 2;
		[self addChild:background z:0];
		
		Ball* ball = [Ball newBallInWorld:world withPos:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:ball z:3 tag:GameSceneNodeTagBall];
		
		Hole* hole1 = [Hole newHoleInWorld:world withPos:ccp(screenSize.width/2, screenSize.height*0.1)];
		[self addChild:hole1 z:2 tag:GameSceneNodeTagHole];
		
		// Ask director the the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
		
        // Create an object and a mask
        CCSprite* object = [CCSprite spriteWithFile:@"Hole.png"];
        CCSprite* mask = [CCSprite spriteWithFile:@"Ball_6.png"];
		
        // Set their positions
        object.position = ccp(size.width * 0.5f, size.height * 0.5f + 310);
        mask.position = ccp(size.width * 0.5f, size.height * 0.5f + 310);
		
        // Create a masked image based on the object and the mask and add it to the screen
        CCMask *masked = [CCMask createMaskForObject: object withMask: mask];
        [self addChild: masked];
		
       
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	
	delete debugDraw;
	debugDraw = NULL;
	
	instanceOfGameScene = nil;
	
	
	
	delete world;
	world = NULL;
}

-(void) initBox2dWorld
{
	// Construct a world object, which will hold and simulate the rigid bodies.
	b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
	bool allowBodiesToSleep = false;
	world = new b2World(gravity);
	world->SetAllowSleeping(allowBodiesToSleep);
	
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);
	
	// Define the static container body, which will provide the collisions at screen borders.
	b2BodyDef containerBodyDef;
	b2Body* containerBody = world->CreateBody(&containerBodyDef);
	
	// for the ground body we'll need these values
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	float widthInMeters = screenSize.width / PTM_RATIO;
	float heightInMeters = screenSize.height / PTM_RATIO;
	b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
	b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
	b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
	b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
	
	// Create the screen box' sides by using a polygon assigning each side individually.
	b2EdgeShape screenBoxShape;
	int density = 0;
	
	// left side
	screenBoxShape.Set(upperLeftCorner, lowerLeftCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
	// right side
	screenBoxShape.Set(upperRightCorner, lowerRightCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
	// bottom
	screenBoxShape.Set(lowerLeftCorner, lowerRightCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
	// top
	screenBoxShape.Set(upperLeftCorner, upperRightCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	b2Vec2 gravity(accelX * 10 * CC_CONTENT_SCALE_FACTOR(), accelY * 10 * CC_CONTENT_SCALE_FACTOR());
	
	world->SetGravity( gravity );
}

-(void) enableBox2dDebugDrawing
{
	float debugDrawScaleFactor = 1.0f;
#if KK_PLATFORM_IOS
	debugDrawScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
#endif
	debugDrawScaleFactor *= PTM_RATIO;
	
	debugDraw = new GLESDebugDraw(debugDrawScaleFactor);
	
	if (debugDraw)
	{
		UInt32 debugDrawFlags = 0;
		debugDrawFlags += b2Draw::e_shapeBit;
		debugDrawFlags += b2Draw::e_jointBit;
		//debugDrawFlags += b2Draw::e_aabbBit;
		//debugDrawFlags += b2Draw::e_pairBit;
		//debugDrawFlags += b2Draw::e_centerOfMassBit;
		
		debugDraw->SetFlags(debugDrawFlags);
		world->SetDebugDraw(debugDraw);
	}

}





-(void) update:(ccTime)delta
{
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	static int32 counter = 0;
	
	world->Step(timeStep, velocityIterations, positionIterations);
	
	CCDirector* director = [CCDirector sharedDirector];
	if (director.currentPlatformIsIOS)
	{
		KKInput* input = [KKInput sharedInput];
		if (director.currentDeviceIsSimulator == NO)
		{
			KKAcceleration* acceleration = input.acceleration;
			//CCLOG(@"acceleration: %f, %f", acceleration.rawX, acceleration.rawY);
			b2Vec2 gravity = 10.0f * b2Vec2(acceleration.rawX, acceleration.rawY);
			//world->SetGravity(gravity);
		}
		
		if (input.anyTouchEndedThisFrame)
		{
			
		}
	}
	
	
	// for each body, get its assigned BodyNode and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
		BodyNode* bodyNode = (__bridge BodyNode*)body->GetUserData();
		if (bodyNode != NULL && bodyNode.sprite != nil)
		{
			// update the sprite's position to where their physics bodies are
			bodyNode.sprite.position = [Helper toPixels:body->GetPosition()];
			float angle = body->GetAngle();
			bodyNode.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));
		}
	}
	CGSize screenSize = [[CCDirector sharedDirector] winSize];

	if(counter%100==0)
	{
		Ball* ball = [Ball newBallInWorld:world withPos:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:ball z:3 tag:GameSceneNodeTagBall];
	}
	
	counter++;
	
}

-(CCSpriteBatchNode*) getSpriteBatch
{
	return (CCSpriteBatchNode*)[self getChildByTag:GameSceneNodeTagBatch];
}

-(void) gameOver
{
	
	CCLOG(@"GAMEOVER!");
	//[[CCDirector sharedDirector] replaceScene:[EndGameScene scene]];
}

#ifdef DEBUG
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	//glDisable(GL_TEXTURE_2D);
	//glDisableClientState(GL_COLOR_ARRAY);
	//glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
//	world->DrawDebugData();
	
	// restore default GL states
//	glEnable(GL_TEXTURE_2D);
	//glEnableClientState(GL_COLOR_ARRAY);
	//glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}
#endif

@end
