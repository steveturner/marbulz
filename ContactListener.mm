/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "ContactListener.h"
#import "cocos2d.h"
#import "BodyNode.h"
#import "GameScene.h"
#import "Ball.h"

void ContactListener::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
	{
		BodyNode* bNodeA = (__bridge BodyNode*)bodyA->GetUserData();
		BodyNode* bNodeB = (__bridge BodyNode*)bodyB->GetUserData();
		
		if ((bNodeA.tag == GameSceneNodeTagBall && bNodeB.tag == GameSceneNodeTagHole) ||
			(bNodeA.tag == GameSceneNodeTagHole && bNodeB.tag == GameSceneNodeTagBall))
		{
			switch (bNodeA.tag) {
				case GameSceneNodeTagBall:
					if ([bNodeA isKindOfClass:[Ball class]]) {
						Ball* ball = (Ball*)bNodeA;
						ball.sprite.visible = NO;
						//run action to shrink/drop ball TODO
						[[GameScene sharedGameScene] gameOver];
					}
					break;
				case GameSceneNodeTagHole:
					if ([bNodeB isKindOfClass:[Ball class]]) {
						Ball* ball = (Ball*)bNodeB;
						ball.sprite.visible = NO;
						//run action to shrink/drop ball TODO
						[[GameScene sharedGameScene] gameOver];
					}
					break;
					
				default:
					break;
			}
		}
	}
}

void ContactListener::EndContact(b2Contact* contact)
{
	
}