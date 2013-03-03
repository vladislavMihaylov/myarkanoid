//
//  GuiLayer.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GuiLayer.h"
#import "GameLayer.h"
#import "GameConfig.h"
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
        //[self addChild: guiBg];
        
        scoreLabel = [CCLabelTTF labelWithString: @"Score: 0" fontName: @"Arial" fontSize: 16];
        scoreLabel.anchorPoint = ccp(0, 0.5);
        scoreLabel.position = ccp(5, kGameHeight - 15);
        [self addChild: scoreLabel];
        
        livesLabel = [CCLabelTTF labelWithString: @"Lives: 3" fontName: @"Arial" fontSize: 16];
        livesLabel.anchorPoint = ccp(0, 0.5);
        livesLabel.position = ccp(GameCenterX, kGameHeight - 15);
        [self addChild: livesLabel];
        
        CCMenuItemImage *pauseBtn = [CCMenuItemImage itemWithNormalImage: @"pauseBtn.png" selectedImage: @"pauseBtn.png" target: self selector: @selector(showPauseMenu)];
        pauseBtn.position = ccp(kGameWidth - 15, kGameHeight - 15);
        
        CCMenu *guiMenu = [CCMenu menuWithItems: pauseBtn, nil];
        guiMenu.position = ccp(0, 0);
        [self addChild: guiMenu];
    }
    
    return self;
}

- (void) showPauseMenu
{
    [gameLayer pause];
    
    CCMenuItemImage *pauseBtn = [CCMenuItemImage itemWithNormalImage: @"pauseBtn.png" selectedImage: @"pauseBtn.png" target: self selector: @selector(hidePauseMenu)];
    pauseBtn.position = ccp(GameCenterX, GameCenterY);
    
    CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage: @"backBtn.png"
                                                   selectedImage: @"backBtnOn.png"
                             target: self selector: @selector(back)];
    back.position = ccp(GameCenterX - 60, GameCenterY);
    
    CCMenu *pauseMenu = [CCMenu menuWithItems: pauseBtn, back, nil];
    pauseMenu.position = ccp(0, 0);
    [self addChild: pauseMenu z:10 tag: 1];
}

- (void) back
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: [SelectLevelLayer scene]]];
}

- (void) hidePauseMenu
{
    [gameLayer unPause];
    
    [self removeChildByTag: 1 cleanup: YES];
}

- (void) updateScoreLabel: (NSInteger) score
{
    scoreLabel.string = [NSString stringWithFormat: @"Score: %i", score];
}

- (void) updateLivesLabel: (NSInteger) lives
{
    livesLabel.string = [NSString stringWithFormat: @"Lives: %i", lives];
}

@end
