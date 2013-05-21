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
    @private
        CCSprite *ballSprite;
    @public
        float multiplierX;
        float multiplierY;
        float differenceX; // Difference between positionX of ball & position X of platform
    
        BOOL IsBallRuned;
}

+ (Ball *) create;

@property (nonatomic, assign) float multiplierX;
@property (nonatomic, assign) float multiplierY;
@property (nonatomic, assign) float differenceX;

@property (nonatomic, assign) BOOL IsBallRuned;

@end
