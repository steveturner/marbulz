//
//  Hole.m
//  Marbulz
//
//  Created by Steven Turner on 9/23/12.
//
//

#import "Hole.h"
#import "Helper.h"
#import "Constants.h"

@interface Hole (PrivateMethods)
-(void) createHoleInWorld:(b2World*)world withPos:(CGPoint)pos;
@end

@implementation Hole

-(id) initWithWorld:(b2World*)world withPos:(CGPoint)pos
{
	if ((self = [super init])) {
		[self createHoleInWorld:world withPos:pos];
	}
	return self;
}

+(id) newHoleInWorld:(b2World*)world withPos:(CGPoint)pos
{
	return [[self alloc] initWithWorld:world withPos:pos];
}

-(void) createHoleInWorld:(b2World*)world withPos:(CGPoint)pos
{
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
	bodyDef.position = [Helper toMeters:pos];
	bodyDef.angularDamping = 0.9;
	
	NSString* spriteFramName = @"Hole.png";
	CCSprite* tempSprite = [CCSprite spriteWithFile:spriteFramName];
	
	b2CircleShape shape;
	float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.05f;
	shape.m_radius = radiusInMeters;
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f*CC_CONTENT_SCALE_FACTOR();
	fixtureDef.friction = 0.0f;
	fixtureDef.restitution = 0.0f;
	fixtureDef.isSensor = true;
	
	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteName:spriteFramName];
}

@end
