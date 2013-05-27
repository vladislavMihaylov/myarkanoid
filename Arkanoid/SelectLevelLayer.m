//
//  SelectLevelLayer.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "SelectLevelLayer.h"
#import "MainMenuLayer.h"
#import "GameLayer.h"

@implementation SelectLevelLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	SelectLevelLayer *layer = [SelectLevelLayer node];
	[scene addChild: layer];
	
	return scene;
}

- (void) dealloc
{
	[super dealloc];
}

-(id) init
{
	if( (self=[super init]) )
    {
        CCSprite *gameBg = [CCSprite spriteWithFile: @"bg2.png"];
        gameBg.position = ccp(GameCenterX, GameCenterY);
        [self addChild: gameBg];
        
        CCLabelBMFont *selectLevelLabel = [CCLabelBMFont labelWithString: @"Select level" fntFile: @"pixelFont48.fnt"];
        selectLevelLabel.position = ccp(GameCenterX, kGameHeight - selectLevelLabel.contentSize.height * 1.5);
        selectLevelLabel.color = ccc3(255, 255, 255);
        [self addChild: selectLevelLabel];
        
        [self showMenuOfLevels];
    }
    
	return self;
}

#pragma mark Menu

- (void) showMenuOfLevels
{
    [self addItemsInTheLevelsMenu];
    
    [self alignItemsInColumns];
    
    [self addNavigationMenu];
}

- (void) addItemsInTheLevelsMenu
{
    selectLevelMenu = [CCMenu menuWithItems: nil];
    selectLevelMenu.position = ccp(GameCenterX, GameCenterY * kMultiplierForSelectLevelPosY);
    [self addChild: selectLevelMenu];
    
    for (int i = 0; i < kCountItemsInTheLevelsMenu; i++)
    {
        CCMenuItemImage *curItem = [CCMenuItemImage itemWithNormalImage: @"levelNumBg.png"
                                                          selectedImage: @"levelNumBgOn.png"
                                                                 target: self
                                                               selector: @selector(playLevel:)
                                    ];
        
        curItem.tag = i + 1;
        
        
        CCLabelBMFont *levelNumLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%i", i + 1]
                                                              fntFile: @"pixelFont36.fnt"];
        
        levelNumLabel.color = ccc3(0, 0, 0);
        levelNumLabel.position = ccp(curItem.contentSize.width/2, curItem.contentSize.height/2);
        
        [selectLevelMenu addChild: curItem];
        [curItem addChild: levelNumLabel];
    }
}

- (void) alignItemsInColumns
{
    NSNumber *countColumns = [NSNumber numberWithInt: kCountOfColumnsInTheLevelsMenu];
    
    [selectLevelMenu alignItemsInColumns: countColumns, countColumns, countColumns, countColumns, countColumns, nil];
}

- (void) addNavigationMenu
{
    CCMenuItemImage *backBtn = [CCMenuItemImage itemWithNormalImage: @"backBtn.png"
                                                      selectedImage: @"backBtnOn.png"
                                                             target: self
                                                           selector: @selector(back)
                                ];
    
    backBtn.position = kPosForBackBtn;
    
    CCMenu *menu = [CCMenu menuWithItems: backBtn, nil];
    menu.position = ccp(0, 0);
    [self addChild: menu];
}

# pragma mark Navigation

- (void) playLevel: (CCMenuItem *) sender
{
    currentLevel = sender.tag;
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.2 scene: [GameLayer scene]]];
}

- (void) back
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.2 scene: [MainMenuLayer scene]]];
}

@end
