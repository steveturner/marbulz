//
//  BodyNode.h
//  Marbulz
//
//  Created by Steven Turner on 9/23/12.
//
//


#import "cocos2d.h"
#import "Box2D.h"

@interface BodyNode : CCNode {
	b2Body* body;
	CCSprite* sprite;
}

@property (readonly, nonatomic) b2Body* body;
@property (readonly, nonatomic) CCSprite* sprite;

-(void) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteName:(NSString*)spriteName;

-(void) removeSprite;
-(void) removeBody;

@end