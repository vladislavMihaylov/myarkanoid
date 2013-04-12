//
//  Block.h
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Block: CCNode
{
    CCSprite *blockSprite;
    
    NSInteger health;
}

+ (Block *) create;
- (void) updateSprite: (NSInteger) type;

@property (nonatomic, assign) NSInteger health;

@end
