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
    @private
        CCSprite *platformSprite;
        CCSprite *gunOne;
        CCSprite *gunTwo;
}

+ (Platform *) create;

- (void) makeDoubleWidth;
- (void) makeUsuallyWidth;

- (void) activateGuns;
- (void) hideGuns;

@end
