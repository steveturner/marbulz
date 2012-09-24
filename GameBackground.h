

#import "cocos2d.h"


/** Provides the background image/animations of the scene. Why is this a seperate class? For one, you might want to animate certain parts of the 
 background. A seperate class that handles all the background animations makes it easier to do that. Then you might want to change the background 
 depending on the game state or if certain events happen. Finally, you might want to have several overlapping backgrounds with transparent areas. 
 That is also easier to do if you have your own class for that. Background is drawn at, well, the background level at the very "bottom". */
@interface GameBackground : CCNode
{

}

/** initializes class and returns an autoreleased instance of the class */
+(id) background;

/** initializes class and returns an instance of the class, you must take care of allocating the object yourself */
-(id) init;

@end
