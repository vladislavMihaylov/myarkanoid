//
//  Ball.h
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Ball: CCNode
{
    CCSprite *ballSprite;
    
    float multiplierX;
    float multiplierY;
    
    BOOL IsBallRuned;
    
    float differenceX;
}

+ (Ball *) create;

@property (nonatomic, assign) float multiplierX;
@property (nonatomic, assign) float multiplierY;

@property (nonatomic, assign) BOOL IsBallRuned;

@property (nonatomic, assign) float differenceX;

@end
