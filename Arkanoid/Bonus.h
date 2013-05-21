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
    @private
        CCSprite *bonusSprite;
    @public
        BonusType type;
}

+ (Bonus *) create;

@property (nonatomic,assign) BonusType type;

@end
