//
//  Hole.h
//  Marbulz
//
//  Created by Steven Turner on 9/23/12.
//
//


#import "BodyNode.h"


@interface Hole : BodyNode {
	
}

+(id) newHoleInWorld:(b2World*)world withPos:(CGPoint)pos;

@end