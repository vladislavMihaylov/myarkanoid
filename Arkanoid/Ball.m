//
//  Ball.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"

@implementation Ball

@synthesize multiplierX;
@synthesize multiplierY;

@synthesize IsBallRuned;
@synthesize differenceX;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        ballSprite = [CCSprite spriteWithFile: @"ballSprite.png"];
        
        CGSize spriteSize = [ballSprite contentSize];
        self.contentSize = spriteSize;
        
        [self addChild: ballSprite];
        
        multiplierX = 1;
        multiplierY = 1;
        
        IsBallRuned = NO;
        
        differenceX = 0;
    }
    
    return self;
}

+ (Ball *) create
{
    Ball *ball = [[[Ball alloc] init] autorelease];
    
    return  ball;
}

@end
