//
//  ReliveViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/8/10.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "ReliveViewController.h"
#import "NSTimerManager.h"
@interface ReliveViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnBottonConst;
@property (weak, nonatomic) IBOutlet UIImageView *secImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;


@property (nonatomic,assign) NSInteger supSec;
@property (nonatomic,assign) BOOL paused;
@end

@implementation ReliveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0;
    self.supSec = 5;
    self.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:25];
    self.freeLabel.font =[UIFont fontWithName:@"changchengteyuanti" size:14];
    self.dimondLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:14];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
-(void)updateTiemLabel{
    if (_paused ) {
        return;
    }
    _supSec -- ;
    if (_supSec<0) {
        [self closeAlertVC:^{
            if (self.closeBlock) {
                self.closeBlock();
            }
        }];
        return;
    }
    NSString *imgName = [NSString stringWithFormat:@"alert%ld",(long)_supSec];
    self.secImageView.image = [UIImage imageNamed:imgName];
    [UIView animateWithDuration:0.2 animations:^{
        self.secImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.secImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}
-(void)pauseCutDown{
    _paused = YES;
}
-(void)reStartCutDown{
    self.supSec = 5;
    _paused = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1;
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.closeBtnBottonConst.constant = 60;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTiemLabel) name:kGlobleTimerNoti object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (IBAction)onFreeClck:(UIButton *)sender {
    if (self.forFreeBlock) {
        self.forFreeBlock();
    }
}
- (IBAction)onPayClick:(UIButton *)sender {
    if (self.paymentBlock) {
        self.paymentBlock();
    }
}

- (IBAction)onCLoseCLick:(UIButton *)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
//    self.closeBtnBottonConst.constant = -100;
//    [self.view setNeedsLayout];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        if (finished) {
//            if (self.willCloseBlock) {
//                self.willCloseBlock();
//            }
//            [UIView animateWithDuration:0.3 animations:^{
//                self.view.alpha = 0;
//            } completion:^(BOOL finished) {
//                if (finished) {
//                    if (self.closeBlock) {
//                        self.closeBlock();
//                    }
//                }
//            }];
//        }
//    }];
    
}
-(void)closeAlertVC:(void(^)(void))finishBlock{
    self.closeBtnBottonConst.constant = -100;
    [self.view setNeedsLayout];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.willCloseBlock) {
                self.willCloseBlock();
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.view.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    if (finishBlock) {
                        finishBlock();
                    }
                }
            }];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
