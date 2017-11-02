//
//  ReLiveAlertView.m
//  Jump
//
//  Created by xueyognwei on 2017/7/10.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "ReLiveAlertView.h"

@implementation ReLiveAlertView
{
    NSInteger _sec ;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.alertBody.alpha = 0;
    self.alpha = 0;
    _sec = 5;
}
-(void)didMoveToSuperview
{
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
//        [self watiToClose:5];
        if (finished) {
            
            [self watiToClose];
            
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.closeBtn.hidden = NO;
        self.closeBtnBottomConst.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.closeBtn.hidden = NO;
//    });
//    self.closeBtnBottomConst.constant = 0;
//    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
}

/**
 自动关闭弹窗

 @param sec 秒数
 */
-(void)watiToClose:(NSInteger)sec{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.secLabel.text = [NSString stringWithFormat:@"%ld",(long)sec];
    });
    if (sec<0) {//作废
        return;
    }
    if (sec==0) {
        [self onClose:self.closeBtn];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self watiToClose:sec-1];
        });
    }
}
-(void)setReliveTimes:(NSInteger)reliveTimes
{
    _reliveTimes = reliveTimes;
    if (reliveTimes==2) {
        self.freeBtn.enabled = NO;
    }
}
-(void)adLoadingdidSrard{
//    [self.loadingActivity startAnimating];
//    self.secLabel.font = [UIFont systemFontOfSize:15];
//    self.secLabel.text = @"loading reward video..";
}
-(void)adLoadingdidFaildd{
    [self.loadingActivity stopAnimating];
    self.secLabel.font = [UIFont systemFontOfSize:15];
    self.secLabel.text = @"reward video load faild!";
}
-(void)pauseCutDown{
    _sec = -1;
}
-(void)reStartCutDown{
    _sec = 3;
    [self watiToClose];
}
/**
 自动关闭弹窗
 */
-(void)watiToClose{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_sec>-1) {
            self.secLabel.font = [UIFont systemFontOfSize:60];
            self.secLabel.text = [NSString stringWithFormat:@"%ld",(long)_sec];
        }else{
            [self adLoadingdidSrard];
        }
        
    });
    if (_sec<0) {//作废
        return;
    }
    if (_sec==0) {
        [self onClose:self.closeBtn];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _sec -= 1;
            [self watiToClose];
        });
    }
}
- (IBAction)onClose:(UIButton *)sender {
    __weak typeof(self) wkSelf = self;
    
    [self animateDissmissFinishBlock:^{
        if (wkSelf.closeBlock) {
            wkSelf.closeBlock();
        }
    }];
//    [UIView animateWithDuration:0.2 animations:^{
//        
//    }];
    
}

- (IBAction)onFreeClick:(UIButton *)sender {
    [self adLoadingdidSrard];
    if (self.forFreeBlock) {
        self.forFreeBlock();
    }
//    __weak typeof(self) wkSelf = self;
//    [self animateDissmissFinishBlock:^{
//        if (wkSelf.forFreeBlock) {
//            wkSelf.forFreeBlock();
//        }
//    }];
}
-(void)setCanClose:(BOOL)canClose{
    self.closeBtn.enabled = canClose;
    self.freeBtn.enabled = canClose;
    self.payBtn.enabled = canClose;
}
-(void)dissmiss:(void(^)(void))closeBlock
{
    [self animateDissmissFinishBlock:^{
        if (closeBlock) {
            closeBlock();
        }
    }];
}
- (IBAction)onPayClick:(UIButton *)sender {
    if (self.paymentBlock) {
        self.paymentBlock();
    }
//    __weak typeof(self) wkSelf = self;
//    [self animateDissmissFinishBlock:^{
//        if (wkSelf.paymentBlock) {
//            wkSelf.paymentBlock();
//        }
//    }];
}
/**
 以动画隐藏
 */
-(void)animateDissmissFinishBlock:(void(^)(void))finishBlock{
    self.closeBtnBottomConst.constant = -50;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.closeBtn.hidden = YES;
        }
    }];
    
    [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:1 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseOut animations:^{
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
