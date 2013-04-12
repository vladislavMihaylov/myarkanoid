//
//  Block.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Block.h"

@implementation Block

@synthesize health;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        health = 1;
        
        blockSprite = [CCSprite spriteWithFile: @"block1.png"];
        
        CGSize spriteSize = [blockSprite contentSize];
        self.contentSize = spriteSize;
        
        [self addChild: blockSprite];
    }
    
    return self;
}

- (void) updateSprite: (NSInteger) type
{
    [self removeChild: blockSprite cleanup: YES];
    
    blockSprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"block%i.png", type]];
    
    [self addChild: blockSprite];
}

+ (Block *) create
{
    Block *block = [[Block alloc] init];
    
    return block;
}

@end
