//
//  GuiLayer.h
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface GuiLayer: CCLayer
{
    GameLayer *gameLayer;
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *livesLabel;
}

- (void) updateScoreLabel: (NSInteger) score;
- (void) updateLivesLabel: (NSInteger) lives;

@property (nonatomic, assign) GameLayer *gameLayer;

@end
