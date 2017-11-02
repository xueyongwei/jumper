//
//  SettingView.h
//  Jump
//
//  Created by xueyognwei on 2017/7/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView
@property (weak, nonatomic) IBOutlet UIView *alertBody;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,strong) void(^closeBlock)(void);
-(void)animateShow;
@end
