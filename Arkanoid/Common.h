
#ifndef COMMON_H
#define COMMON_H

#import "cocos2d.h"

@interface Common: NSObject
{
    
}

+ (CCAnimation *) loadAnimationWithPlist: (NSString *) file andName: (NSString *) name;

@end

#endif