//
//  GuideView.h
//  Jump
//
//  Created by xueyognwei on 2017/7/14.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView
@property (weak, nonatomic) IBOutlet UIView *alertBody;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,strong) void(^closeBlock)(void);

/**
 动画显示弹窗
 */
-(void)animateShow;
@end
