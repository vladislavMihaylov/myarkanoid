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

@class BoomBoom;
@class Platform;
@class Ball;

@interface GameLayer: CCLayer
{
    @private
        Ball *ball;
        Ball *newBall;
        Platform *platform;
        
        CCSprite *background;
        CCSprite *portal;
        
        NSInteger score;
        NSInteger lives;
        
        NSMutableArray *ballsArray;
        NSMutableArray *blocksArray;
        NSMutableArray *bonusesArray;
        NSMutableArray *bulletsArray;
        NSMutableArray *enemiesArray;
        NSMutableArray *boomsArray;
    
    @public
        GuiLayer *gui;
}

- (void) pause;
- (void) unPause;

- (void) nextLevel;
- (void) removeBoom: (BoomBoom *) boom;

@property (nonatomic, retain) GuiLayer *guiLayer;

+(CCScene *) scene;

@end
