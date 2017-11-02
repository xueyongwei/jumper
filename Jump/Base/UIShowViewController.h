//
//  UIShowViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/8/22.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIShowViewController : UIViewController

/**
 关闭的动画
 */
@property (nonatomic,copy) void(^closeBlick)(void);

/**
 移除这个viewController，包括一下操作
 1.[self.view removeFromSuperview];
 2.[self removeFromParentViewController];
 @param completion 移除完成
 */
-(void)removeViewController:(void (^)(void))completion;
@end
