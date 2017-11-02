//
//  PauseViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/8/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *goOnBtn;

@end

@implementation PauseViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.goHomeBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
                self.goOnBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.goHomeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        self.goOnBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }
            }];
        }
    }];
}
-(void)zoomBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goHomeClick:(UIButton *)sender {
    [self zoomBtn:sender];
    if (self.goHomeBlock) {
        __weak typeof(self) wkSelf = self;
        [self closeAlertVC:^{
            wkSelf.goHomeBlock();
        }];
    }
}
- (IBAction)goOnClick:(UIButton *)sender {
    [self zoomBtn:sender];
    if (self.goOnBlock) {
        __weak typeof(self) wkSelf = self;
        [self closeAlertVC:^{
            wkSelf.goOnBlock();
        }];
    }
}
-(void)closeAlertVC:(void(^)(void))finishBlock{
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
