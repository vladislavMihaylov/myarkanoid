//
//  BoomBoom.h
//  Arkanoid
//
//  Created by Vlad on 14.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface BoomBoom: CCNode
{
    CCSprite *s_boom;
}

+ (BoomBoom *) create;

- (void) bang;

@property (nonatomic, retain) GameLayer *gameLayer;

@end
