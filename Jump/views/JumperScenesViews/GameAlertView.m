//
//  GameAlertView.m
//  Jump
//
//  Created by xueyognwei on 2017/7/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GameAlertView.h"

@implementation GameAlertView

/**
 用一个alert体初始化一个弹窗

 @param bodyView 弹窗
 @return alert
 */
-(id)initWithAlertBodyView:(UIView *)bodyView{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        _alertBody = bodyView;
    }
    return self;
}
-(void)didMoveToSuperview
{
    if (_alertBody) {
        
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

/**
 动画显示弹窗
 */
-(void)animateShow{
    self.alertBody.transform = CGAffineTransformMakeScale(0.5, 0.6);
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:1 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertBody.alpha = 1;
        self.alertBody.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 以动画隐藏
 */
-(void)animateDissmiss{
    [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertBody.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alertBody.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.alertBody.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self removeFromSuperview];
                        }
                    }];
                }
            }];
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
