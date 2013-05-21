//
//  Bonus.m
//  Arkanoid
//
//  Created by Vlad on 01.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
//  

#import "Bonus.h"

@implementation Bonus

@synthesize type;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        self.type = arc4random() % 6;
        
        bonusSprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"bonus_%i.png", self.type]];
        [self addChild: bonusSprite];
        
        CGSize spriteSize = [bonusSprite contentSize];
        self.contentSize = spriteSize;
    }
    
    return self;
}

+ (Bonus *) create
{
    Bonus *bonus = [[[Bonus alloc] init] autorelease];
    
    return  bonus;
}

@end
