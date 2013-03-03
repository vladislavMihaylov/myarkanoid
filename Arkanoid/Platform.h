//
//  Platform.h
//  Arkanoid
//
//  Created by Vlad on 28.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Platform: CCNode
{
    CCSprite *platformSprite;
    
    CCSprite *gunOne;
    CCSprite *gunTwo;
}

+ (Platform *) create;

- (void) doDoubleWidth;
- (void) doUsuallyWidth;

- (void) activateGuns;
- (void) removeGuns;

@end
