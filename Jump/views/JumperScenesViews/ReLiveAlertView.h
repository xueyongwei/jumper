//
//  ReLiveAlertView.h
//  Jump
//
//  Created by xueyognwei on 2017/7/10.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReLiveAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *alertBody;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnBottomConst;
@property (weak, nonatomic) IBOutlet UIButton *freeBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic,assign) NSInteger reliveTimes;
@property (nonatomic,strong) void(^closeBlock)(void);
@property (nonatomic,strong) void(^forFreeBlock)(void);
@property (nonatomic,strong) void(^paymentBlock)(void);
-(void)pauseCutDown;
-(void)reStartCutDown;
-(void)animateShow;
-(void)dissmiss:(void(^)(void))closeBlock;

-(void)adLoadingdidSrard;
-(void)adLoadingdidFaildd;
-(void)setCanClose:(BOOL)canClose;
@end
