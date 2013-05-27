//
//  Platform.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"
#import "GameConfig.h"

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
        
        platformSprite = [CCSprite spriteWithFile: @"newPlatform.png"];
        
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
        
        // Eyes
        
        leftEye = [CCSprite spriteWithFile: @"eye.png"];
        rightEye = [CCSprite spriteWithFile: @"eye.png"];
        
        leftEye.position = ccp(-self.contentSize.width / 2.8 , self.contentSize.height * 0.6);
        rightEye.position = ccp(self.contentSize.width / 2.8 , self.contentSize.height * 0.6);
        
        [self addChild: leftEye z: 3];
        [self addChild: rightEye z: 3];
        
        // Pipuls
        
        leftPipul = [CCSprite spriteWithFile: @"appleOfEye.png"];
        rightPipul = [CCSprite spriteWithFile: @"appleOfEye.png"];
        
        leftPipul.position = ccp(leftEye.contentSize.width / 2, leftEye.contentSize.height / 2);
        rightPipul.position = ccp(rightEye.contentSize.width / 2, rightEye.contentSize.height / 2);
        
        [leftEye addChild: leftPipul z: 4];
        [rightEye addChild: rightPipul z: 4];
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
    
    platformSprite = [CCSprite spriteWithFile: @"newPlatform.png"];
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

# pragma mark showCoordinatsOfBall

- (void) showCoordinats: (CGPoint) pointOfBall
{
    //CCLOG(@"X: %f", kGameWidth/);
    
    float differentBallPlatformXleft = self.position.x - self.contentSize.width / 2.8 - pointOfBall.x;
    float differentBallPlatformXright = self.position.x + self.contentSize.width / 2.8 - pointOfBall.x;
    
    float differentBallPlatformY = pointOfBall.y - self.position.y;
    //CCLOG(@"%f", differentBallPlatformX);
    
    leftPipul.position = ccp(-differentBallPlatformXleft * 0.025 + leftEye.contentSize.width / 2,
                             leftEye.contentSize.height / 2 + differentBallPlatformY * 0.025);
    
    rightPipul.position = ccp(-differentBallPlatformXright * 0.025 + rightEye.contentSize.width / 2,
                              rightEye.contentSize.height / 2 + differentBallPlatformY * 0.025);
}

@end
