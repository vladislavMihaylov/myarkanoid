//
//  Enemy.h
//  Arkanoid
//
//  Created by Vlad on 12.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy: CCNode
{
    NSInteger health;
    
    float leftBorder;
    float rightBorder;
    
    BOOL directionIsRight;
    
    float typeOfBullet;
}

- (void) moveWithSpeed: (float) speed;
- (void) shot;

+ (Enemy *) createWithBorders: (float) left angRight: (float) right;

@property (nonatomic, assign) NSInteger health;
@property (nonatomic, assign) BOOL directionIsRight;

@end
