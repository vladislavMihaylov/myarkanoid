//
//  SelectLevelLayer.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SelectLevelLayer.h"
#import "GameLayer.h"
#import "MainMenuLayer.h"
#import "GameConfig.h"

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
        CCMenu *selectLevelMenu = [CCMenu menuWithItems: nil];
        selectLevelMenu.position = ccp(160, 260);
        [self addChild: selectLevelMenu];
        
        for (int i = 0; i < 15; i++)
        {
            CCMenuItemImage *curItem = [CCMenuItemImage itemWithNormalImage: @"levelNumBg.png"
                                                              selectedImage: @"levelNumBgOn.png"
                                                              target: self
                                                            selector: @selector(playLevel:)
                                      ];
            
            curItem.tag = i + 1;
            [selectLevelMenu addChild: curItem];
            
            CCLabelTTF *levelNum = [CCLabelTTF labelWithString: [NSString stringWithFormat: @"%i", i+1] fontName: @"Arial" fontSize: 16];
            levelNum.position = ccp(curItem.contentSize.width/2, curItem.contentSize.height/2);
            [curItem addChild: levelNum];
        }
        
        NSNumber *countColumns = [NSNumber numberWithInt: 3];
        
        [selectLevelMenu alignItemsInColumns: countColumns, countColumns, countColumns, countColumns, countColumns, nil];
        
        CCMenuItemImage *backBtn = [CCMenuItemImage itemWithNormalImage: @"backBtn.png"
                                                          selectedImage: @"backBtnOn.png"
                                                                 target: self
                                                               selector: @selector(back)
                                    ];
        
        backBtn.position = ccp(55, 45);
        
        CCMenu *menu = [CCMenu menuWithItems: backBtn, nil];
        menu.position = ccp(0, 0);
        [self addChild: menu];
    }
    
	return self;
}

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
