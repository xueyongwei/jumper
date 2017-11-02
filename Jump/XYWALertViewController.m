//
//  XYWALertViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/8/24.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "XYWALertViewController.h"

@interface XYWALertViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentSpView;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (nonatomic,copy) LeftBtnBlock leftCickBlock;
@property (nonatomic,copy) RightBtnBlock rightCickBlock;

@end

@implementation XYWALertViewController
+(XYWALertViewController *)showContentOnWkVC:(UIViewController *)wkVC addContentView:(AddContentBlock )contentSpView withLeftBtnCLick:(LeftBtnBlock)leftCickBlock RightBtnClick:(RightBtnBlock)rightCickBlock
{
    __strong typeof(wkVC) vc = wkVC;
    XYWALertViewController *alv = [[XYWALertViewController alloc]initWithNibName:@"XYWALertViewController" bundle:nil];
    alv.view.frame = CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height);
    contentSpView(alv.contentSpView);
    alv.leftCickBlock = leftCickBlock;
    alv.rightCickBlock = rightCickBlock;
    if (leftCickBlock&&rightCickBlock) {//两个按钮
        alv.leftBtn.hidden = NO;
        alv.rightBtn.hidden = NO;
        alv.centerbtn.hidden = YES;
    }else{//一个按钮
        alv.leftBtn.hidden = YES;
        alv.rightBtn.hidden = YES;
        alv.centerbtn.hidden = NO;
    }
    
    [vc addChildViewController:alv];
    [vc.view addSubview:alv.view];
    
    return alv;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.bodyView.alpha = 1;
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bodyView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.contentSpView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}
-(void)removeAlert:(void (^)(void))complete{
//    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.bodyView.transform = CGAffineTransformMakeScale(0.0, 0.0);
//    } completion:^(BOOL finished) {
//        
//    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            if (complete) {
                complete();
            }
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bodyView.alpha = 0;
    self.contentSpView.alpha = 0;
    self.bodyView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.bodyView.layer.cornerRadius = 8;
    self.bodyView.clipsToBounds = YES;
    
    [self customUI];
    
}
-(void)customUI{
    [self.leftBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [self.rightBtn setTitle:NSLocalizedString(@"Yes", nil) forState:UIControlStateNormal];
    [self.centerbtn setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
    self.leftBtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:18];
    self.rightBtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:18];
    self.centerbtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:18];
}
- (IBAction)leftBtnClick:(UIButton *)sender {
    __weak typeof(self) wkself = self;
    [self removeAlert:^{
        if (wkself.leftCickBlock) {
            wkself.leftCickBlock(sender);
        }
    }];
}
- (IBAction)rightBtnClick:(UIButton *)sender {
    __weak typeof(self) wkself = self;
    [self removeAlert:^{
        if (wkself.rightCickBlock) {
            wkself.rightCickBlock(sender);
        }
    }];
    
}

/**
 需要转给其他按钮的点击时间

 @param sender 按钮
 */
- (IBAction)centerBtnClick:(UIButton *)sender {
    [self removeAlert:^{
        if (self.leftCickBlock) {
            self.leftCickBlock(self.leftBtn);
        }else if (self.rightCickBlock){
            self.rightCickBlock(self.rightBtn);
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
