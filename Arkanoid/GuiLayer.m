//
//  GuiLayer.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GuiLayer.h"
#import "GameLayer.h"
#import "SelectLevelLayer.h"

@implementation GuiLayer

@synthesize gameLayer;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        CCSprite *guiBg = [CCSprite spriteWithFile: @"GuiBg.png"];
        guiBg.position = ccp(GameCenterX, kGameHeight - 15);
        [self addChild: guiBg];
        
        scoreLabel = [CCLabelTTF labelWithString: @"Score: 0"
                                        fontName: @"Arial"
                                        fontSize: 16
                      ];
        
        scoreLabel.anchorPoint = ccp(0, 0.5);
        scoreLabel.position = ccp(5, kGameHeight - 15);
        [self addChild: scoreLabel];
        
        livesLabel = [CCLabelTTF labelWithString: @"Lives: 3"
                                        fontName: @"Arial"
                                        fontSize: 16
                      ];
        
        livesLabel.anchorPoint = ccp(0, 0.5);
        livesLabel.position = ccp(GameCenterX, kGameHeight - 15);
        [self addChild: livesLabel];
        
        CCMenuItemImage *pauseBtn = [CCMenuItemImage itemWithNormalImage: @"pauseBtn.png"
                                                           selectedImage: @"pauseBtn.png"
                                                                  target: self
                                                                selector: @selector(showPauseMenu)
                                     ];
        
        pauseBtn.position = ccp(kGameWidth - 15, kGameHeight - 15);
        
        CCMenu *guiMenu = [CCMenu menuWithItems: pauseBtn, nil];
        guiMenu.position = ccp(0, 0);
        [self addChild: guiMenu];
    }
    
    return self;
}

#pragma mark pauseMenu

- (void) showPauseMenu
{
    [gameLayer pause];
    
    CCMenuItemImage *playBtn = [CCMenuItemImage itemWithNormalImage: @"playBtnForMenu.png"
                                                       selectedImage: @"playBtnForMenu.png"
                                                              target: self
                                                            selector: @selector(continuePlay)
                                 ];
    
    CCMenuItemImage *exitBtn = [CCMenuItemImage itemWithNormalImage: @"exitBtnForMenu.png"
                                                      selectedImage: @"exitBtnForMenu.png"
                                                             target: self
                                                           selector: @selector(exitToSelectLevelLayer)
                             ];
    
    CCMenuItemImage *nextBtn = [CCMenuItemImage itemWithNormalImage: @"newLevelBtnForMenu.png"
                                                   selectedImage: @"newLevelBtnForMenu.png"
                                                          target: self
                                                        selector: @selector(goToNextLevel)
                             ];
    
    exitBtn.position = ccp(GameCenterX - 60, GameCenterY);
    playBtn.position = ccp(GameCenterX, GameCenterY);
    nextBtn.position = ccp(GameCenterX + 60, GameCenterY);
    
    CCMenu *pauseMenu = [CCMenu menuWithItems: playBtn, exitBtn, nextBtn, nil];
    pauseMenu.position = ccp(0, 0);
    [self addChild: pauseMenu z:10 tag: pauseMenuTag];
}

#pragma mark methodsOfMenus

- (void) goToNextLevel
{
    [gameLayer nextLevel];
    
    [self removeChildByTag: pauseMenuTag cleanup: YES];
}

- (void) exitToSelectLevelLayer
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: [SelectLevelLayer scene]]];
}

- (void) continuePlay
{
    [gameLayer unPause];
    
    [self removeChildByTag: pauseMenuTag cleanup: YES];
}

#pragma mark UpdateLabels

- (void) updateScoreLabel: (NSInteger) score
{
    scoreLabel.string = [NSString stringWithFormat: @"Score: %i", score];
}

- (void) updateLivesLabel: (NSInteger) lives
{
    livesLabel.string = [NSString stringWithFormat: @"Lives: %i", lives];
}

@end
