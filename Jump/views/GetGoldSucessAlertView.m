//
//  TwoItemAlertView.m
//  Jump
//
//  Created by xueyognwei on 2017/8/7.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GetGoldSucessAlertView.h"

@implementation GetGoldSucessAlertView

- (IBAction)onOkClose:(UIButton *)sender {
    __weak typeof(self) wkSelf = self;
    [self animateDissmissFinishBlock:^{
        if (wkSelf.closeBlock) {
            wkSelf.closeBlock();
        }
    }];
}
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
-(void)animateDissmissFinishBlock:(void(^)(void))finishBlock{
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
                            
                            finishBlock();
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
