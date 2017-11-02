//
//  GuideViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/9/13.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *leftTextLabel;


@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *rightTextLabel;

@property (weak, nonatomic) IBOutlet UIView *msgView;

@property (nonatomic,strong) void(^tapLeftBlock)(void);
@property (nonatomic,strong) void(^tapRightBlock)(void);
@property (nonatomic,strong) void(^tapSkill3Block)(void);

@property (nonatomic,strong) void(^showSkillItmsBlock)(void);

@property (nonatomic,strong) void(^closeVCBlock)(void);

-(void)animiateHiddenLeft;

-(void)animiateShowRight;
-(void)animiateShowLeft;
@end
