//
//  Platform.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"

@implementation Platform

+ (Platform *) create
{
    Platform *platform = [[[Platform alloc] init] autorelease];
    
    return  platform;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        // Platform
        
        platformSprite = [CCSprite spriteWithFile: @"platform.png"];
        
        CGSize platformSpriteSize = [platformSprite contentSize];
        self.contentSize = platformSpriteSize;
        
        [self addChild: platformSprite z: 1];
        
        // Guns
        
        gunOne = [CCSprite spriteWithFile: @"gun.png"];
        gunTwo = [CCSprite spriteWithFile: @"gun.png"];
        
        gunOne.visible = NO;
        gunTwo.visible = NO;
        
        gunTwo.scaleX = -1;
        
        gunOne.position = ccp(self.contentSize.width / 2 - (gunOne.contentSize.width / 2), 5);
        gunTwo.position = ccp(-self.contentSize.width / 2 + (gunTwo.contentSize.width / 2), 5);
        
        [self addChild: gunOne z: 2];
        [self addChild: gunTwo z: 2];
    }
    
    return self;
}

# pragma mark ControlOfWidth

- (void) makeDoubleWidth
{
    [self removeChild: platformSprite cleanup: YES];
    
    platformSprite = [CCSprite spriteWithFile: @"platform2x.png"];
    [self addChild: platformSprite z: 1];
    
    CGSize spriteSize = [platformSprite contentSize];
    self.contentSize = spriteSize;
    
    gunOne.position = ccp(self.contentSize.width / 2  - gunOne.contentSize.width / 2, 5);
    gunTwo.position = ccp(-self.contentSize.width / 2 + gunOne.contentSize.width / 2, 5);
}

- (void) makeUsuallyWidth
{
    [self removeChild: platformSprite cleanup: YES];
    
    platformSprite = [CCSprite spriteWithFile: @"platform.png"];
    [self addChild: platformSprite z: 1];
    
    CGSize spriteSize = [platformSprite contentSize];
    self.contentSize = spriteSize;
    
    gunOne.position = ccp(self.contentSize.width / 2 - gunOne.contentSize.width / 2, 5);
    gunTwo.position = ccp(-self.contentSize.width / 2 + gunOne.contentSize.width / 2, 5);
}

# pragma mark ControlOfGuns

- (void) activateGuns
{
    gunOne.visible = YES;
    gunTwo.visible = YES;
}

- (void) hideGuns
{
    gunOne.visible = NO;
    gunTwo.visible = NO;
}

@end
