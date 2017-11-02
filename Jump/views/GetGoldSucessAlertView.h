//
//  TwoItemAlertView.h
//  Jump
//
//  Created by xueyognwei on 2017/8/7.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetGoldSucessAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *alertBody;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getGoldAmountLabel;
@property (nonatomic,strong) void(^closeBlock)(void);
-(void)animateShow;
@end
