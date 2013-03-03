//
//  Block.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Block.h"

@implementation Block

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        blockSprite = [CCSprite spriteWithFile: @"block.png"];
        
        CGSize spriteSize = [blockSprite contentSize];
        self.contentSize = spriteSize;
        
        [self addChild: blockSprite];
    }
    
    return self;
}

+ (Block *) create
{
    Block *block = [[Block alloc] init];
    
    return block;
}

@end
