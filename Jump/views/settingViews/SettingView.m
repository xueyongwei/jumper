//
//  SettingView.m
//  Jump
//
//  Created by xueyognwei on 2017/7/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SettingView.h"
#import "LocalNotificationManager.h"
@implementation SettingView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.alertBody.alpha = 0;
    self.alpha = 0;
    self.alertBody.layer.cornerRadius = 8;
    self.alertBody.clipsToBounds = YES;
}
-(void)didMoveToSuperview
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
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
- (IBAction)onClose:(UIButton *)sender {
   
}
- (IBAction)onOpenNoticaticationClick:(UIButton *)sender {
    [self openLNF];
}

-(void)openLNF{
    [[LocalNotificationManager defaultManager] setupManager];
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
        DDLogWarn(@"通知未开启！");
    }
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
                            if (self.closeBlock) {
                                self.closeBlock();
                            }
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
