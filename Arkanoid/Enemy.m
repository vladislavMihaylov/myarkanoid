//
//  Enemy.m
//  Arkanoid
//
//  Created by Vlad on 12.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy

@synthesize health;
@synthesize directionIsRight;

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithBorders: (float) left angRight: (float) right
{
    if(self = [super init])
    {
        CCSprite *bodySprite = [CCSprite spriteWithFile: @"block0.png"];
        
        [self addChild: bodySprite];
        
        leftBorder = left;
        rightBorder = right;
        
        health = 1;
        
        CGSize spriteSize = bodySprite.contentSize;
        self.contentSize = spriteSize;
        
    }
    
    return self;
}

+ (Enemy *) createWithBorders: (float) left angRight: (float) right
{
    Enemy *enemy = [[[Enemy alloc] initWithBorders: left angRight: right] autorelease];
    
    return  enemy;
}

- (void) moveWithSpeed: (float) speedOfEnemy
{
    float startX;
    float finishX;
    
    if(directionIsRight)
    {
        startX = rightBorder;
        finishX = leftBorder;
    }
    else
    {
        startX = leftBorder;
        finishX = rightBorder;
    }
    
    [self runAction:
            [CCRepeatForever actionWithAction:
                    [CCSequence actions: [CCMoveTo actionWithDuration: speedOfEnemy position: ccp(startX, self.position.y)],
                                         [CCMoveTo actionWithDuration: speedOfEnemy position: ccp(finishX, self.position.y)],
                     nil]
             ]
     ];
}

- (void) shot
{

}

@end
