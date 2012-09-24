//
//  BodyNode.m
//  Marbulz
//
//  Created by Steven Turner on 9/23/12.
//
//

#import "BodyNode.h"
#import "GameScene.h"

@implementation BodyNode

@synthesize body;
@synthesize sprite;

-(void) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteName:(NSString*)spriteName
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteName != nil, @"spriteName is nil!");
	
	[self removeSprite];
	[self removeBody];
	
	sprite = [CCSprite spriteWithFile:spriteName];
	[self addChild:sprite];
	
	body = world->CreateBody(bodyDef);
	body->SetUserData((__bridge void*)self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}
}

-(void) removeSprite
{
	if (sprite != nil)
	{
		[self removeChild:sprite cleanup:YES];
		sprite = nil;
	}
}

-(void) removeBody
{
	if (body != NULL)
	{
		body->GetWorld()->DestroyBody(body);
		body = NULL;
	}
}

-(void) dealloc
{
	[self removeSprite];
	[self removeBody];
	
	
}

@end