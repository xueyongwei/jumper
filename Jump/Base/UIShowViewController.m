//
//  UIShowViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/8/22.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "UIShowViewController.h"

@interface UIShowViewController ()

@end

@implementation UIShowViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0;
    // Do any additional setup after loading the view.
}

/**
 移除这个viewController，包括一下操作
 1.[self.view removeFromSuperview];
 2.[self removeFromParentViewController];
 @param completion 移除完成
 */
-(void)removeViewController:(void (^)(void))completion{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            if (completion) {
                completion();
            }
        }
    }];
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    
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
