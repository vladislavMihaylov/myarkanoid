//
//  Bonus.h
//  Arkanoid
//
//  Created by Vlad on 01.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    expand,
    divide,
    laser,
    slow,
    catchBall,
    player
} BonusType;

@interface Bonus: CCNode
{
    BonusType type;
    
    CCSprite *bonusSprite;
}

+ (Bonus *) create;

@property (nonatomic,assign) BonusType type;

@end
