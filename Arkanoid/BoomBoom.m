//
//  BoomBoom.m
//  Arkanoid
//
//  Created by Vlad on 14.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BoomBoom.h"


@implementation BoomBoom

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
        CCSprite *boom = [CCSprite spriteWithFile: @"block0.png"];
        
        [self addChild: boom];
    }
    
    return self;
}

- (void) bang
{
    [self runAction: [CCRotateTo actionWithDuration: 0.5 angle: 720]];
    [self runAction: [CCSequence actions: [CCScaleTo actionWithDuration: 0.25 scale: 2.5], [CCScaleTo actionWithDuration: 0.25 scale: 0], nil]];
}

@end
