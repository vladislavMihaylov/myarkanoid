//
//  MainMenu.m
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameConfig.h"

#import "SelectLevelLayer.h"

@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	MainMenuLayer *layer = [MainMenuLayer node];
	
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
        CCMenuItemImage *playBtn = [CCMenuItemImage itemWithNormalImage: @"playBtn.png"
                                                          selectedImage: @"playBtnOn.png"
                                                                 target: self
                                                               selector: @selector(pressedPlay)
                                    ];
        
        playBtn.position = ccp(GameCenterX, GameCenterY);
        
        CCMenu *mainMenu = [CCMenu menuWithItems: playBtn, nil];
        mainMenu.position = ccp(0, 0);
        [self addChild: mainMenu];
    }
    
	return self;
}

- (void) pressedPlay
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.2 scene: [SelectLevelLayer scene]]];
}

@end
