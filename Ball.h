//
//  Ball.h
//  Marbulz
//
//  Created by Steven Turner on 9/23/12.
//
//

#import "BodyNode.h"
@interface Ball : BodyNode {
	
}
+(id) newBallInWorld:(b2World*)world withPos:(CGPoint)pos;

@end