//
//  BoomBoom.m
//  Arkanoid
//
//  Created by Vlad on 14.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BoomBoom.h"

#import "GameLayer.h"

#import "Common.h"

@implementation BoomBoom

@synthesize gameLayer;

+ (BoomBoom *) create
{
    BoomBoom *boom = [[[BoomBoom alloc] init] autorelease];
    
    return boom;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        s_boom = [CCSprite spriteWithFile: @"block0.png"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"boomAnim.plist"];
        
        [Common loadAnimationWithPlist: @"boomAnimation" andName: @"boom_"];
        
        [self addChild: s_boom];
    }
    
    return self;
}

- (void) bang
{
    [s_boom runAction:
                    [CCAnimate actionWithAnimation:
                        [[CCAnimationCache sharedAnimationCache] animationByName: @"boom_"]
                    ]
    ];    
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.9],
                      [CCCallBlock actionWithBlock:^(void){[gameLayer removeBoom: self];}], nil]];
}

@end
