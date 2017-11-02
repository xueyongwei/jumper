//
//  SKBaseScene.m
//  Jump
//
//  Created by xueyognwei on 2017/7/6.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKBaseScene.h"

@implementation SKBaseScene
- (UIViewController *)viewController {
    for (UIView *view = self.view; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
