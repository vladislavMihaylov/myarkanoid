//
//  HelloWorldLayer.h
//  Arkanoid
//
//  Created by Vlad on 27.02.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "GuiLayer.h"

@class Platform;
@class Ball;

@interface GameLayer: CCLayer
{
    GuiLayer *gui;
    
    Ball *ball;
    Ball *newBall;
    Platform *platform;
    
    CCSprite *bg;
    
    NSInteger score;
    NSInteger lives;
    
    NSMutableArray *ballsArray;
    NSMutableArray *blocksArray;
    NSMutableArray *bonusesArray;
    NSMutableArray *bulletsArray;
}

- (void) pause;
- (void) unPause;

@property (nonatomic, assign) GuiLayer *guiLayer;

+(CCScene *) scene;

@end
