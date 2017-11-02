//
//  GuideViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/9/13.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GuideViewController.h"
#import "CutOutClearView.h"

@interface GuideViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *leftHandImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightHandImgView;
@property (weak, nonatomic) IBOutlet UILabel *rightProtectMsgLabel;


@property (weak, nonatomic) IBOutlet UIImageView *protectIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *protectArrowImgView;
@property (weak, nonatomic) IBOutlet UILabel *protectTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *msgIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *msgTextLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protectCenterXConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protectBottomConst;

@property (weak, nonatomic) IBOutlet UIButton *msgOKBtn;

@property (nonatomic,assign) NSInteger guideIndex;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftView:)];
    
    [self.leftView addGestureRecognizer:tapLeft];
    
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightView:)];
    [self.rightView addGestureRecognizer:tapRight];
    
    UITapGestureRecognizer *tapProtectIcon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapProtectIcon:)];
    [self.protectIconImgView addGestureRecognizer:tapProtectIcon];
    
    self.guideIndex = 0;
    
    [self moveUpAndDown:self.leftHandImgView];
    [self moveUpAndDown:self.rightHandImgView];
    [self zoomView:self.protectIconImgView];
    
    self.leftTextLabel.text = NSLocalizedString(@"Left\n1\nJump", nil);
    self.rightTextLabel.text = NSLocalizedString(@"Right\n2\nJump", nil);
    [self.msgOKBtn setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
//    self.protectTextLabel.text = NSLocalizedString(@"Use\"Wings Protection\", get a chance to resurrect.", nil);
    [self setText:NSLocalizedString(@"Use\"Wings Protection\", get a chance to resurrect.", nil) ForLabel:self.protectTextLabel WithSpace:8];
    // Do any additional setup after loading the view from its nib.
    CGFloat x = (YYScreenSize().width/2-30)/3*2;
    CGFloat rightCenterX = YYScreenSize().width/4;
    self.protectCenterXConst.constant = x-rightCenterX;
    self.protectBottomConst.constant = YYScreenSize().width*0.08;
//
//    CGFloat each = (self.size.width-60)/3;
//    
//    skill.position = CGPointMake(30+i*each + each/2,positionY);
    
}

- (void)setText:(NSString *)labelText ForLabel:(UILabel *)label WithSpace:(float)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
}

#pragma mark -- 点击引导的左右侧
-(void)tapLeftView:(UITapGestureRecognizer *)recognizer{
    if (self.leftTextLabel.hidden) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.rightView.backgroundColor = [UIColor clearColor];
        self.leftTextLabel.hidden = YES;
        self.leftHandImgView.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.tapLeftBlock) {
                self.tapLeftBlock();
            }
            self.guideIndex ++;
            if (self.guideIndex ==1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self animiateShowRight];
                });
//                [self showMsgViewWithType:1];
            }else if (self.guideIndex ==3) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showMsgViewWithType:1];
                });
            }else if (self.guideIndex ==4) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showMsgViewWithType:2];
                });
            }
        }
    }];
}

-(void)tapRightView:(UITapGestureRecognizer *)recognizer{
    if (self.rightTextLabel.hidden) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.backgroundColor = [UIColor clearColor];
        self.rightTextLabel.hidden = YES;
        self.rightHandImgView.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.tapRightBlock) {
                self.tapRightBlock();
            }
            self.guideIndex ++;
            if (self.guideIndex ==2) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self animiateShowLeft];
                });
            }else if (self.guideIndex ==4) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showMsgViewWithType:2];
                });
            }
        }
    }];
    
}

-(void)tapProtectIcon:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.backgroundColor = [UIColor clearColor];
        self.leftView.backgroundColor = [UIColor clearColor];
        self.protectTextLabel.alpha = 0;
        self.protectIconImgView.alpha = 0;
        self.protectArrowImgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.tapSkill3Block) {
                self.tapSkill3Block();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self animateHiddenProtect];
                [self animiateShowRight];
            });
        }
    }];
    
    
}
#pragma mark -- animiateHidden
-(void)animiateHiddenLeft{
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)animiateHiddenRight{
    [UIView animateWithDuration:0.5 animations:^{
        self.rightView.alpha = 0;
    } completion:^(BOOL finished) {
        self.rightView.hidden = YES;
    }];
}
-(void)animateHiddenProtect{
    [UIView animateWithDuration:0.2 animations:^{
        self.protectTextLabel.alpha = 0;
        self.protectIconImgView.alpha = 0;
        self.protectArrowImgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.protectIconImgView.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.rightView.backgroundColor = [UIColor clearColor];
                self.leftView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                if (finished) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self animiateShowRight];
                    });
                    
                }
            }];
        }
    }];
}

#pragma mark -- 动画
-(void)moveUpAndDown:(UIView *)view{
    CGPoint center = view.center;
    if (view.tag==0) {
        view.tag=1;
        center.y += 10;
    }else{
        view.tag=0;
        center.y -= 10;
    }
    [UIView animateWithDuration:0.3 animations:^{
        view.center = center;
    } completion:^(BOOL finished) {
        if (finished) {
            [self moveUpAndDown:view];
        }
    }];
    
}
-(void)zoomView:(UIView *)view{
    CGFloat scale = 1;
    if (view.tag==0) {
        view.tag=1;
        scale = 1.1;
    }else{
        view.tag=0;
        scale = 1.0;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        if (finished) {
            [self zoomView:view];
        }
    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
}
#pragma mark -- animiateShow
-(void)animiateShowLeft{
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.backgroundColor = [UIColor clearColor];
        self.rightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.leftTextLabel.hidden = NO;
        self.leftHandImgView.hidden = NO;
    }completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}


-(void)animiateShowRight{
    [UIView animateWithDuration:0.5 animations:^{
        self.rightView.backgroundColor = [UIColor clearColor];
        self.leftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.rightTextLabel.hidden = NO;
        self.rightHandImgView.hidden = NO;
    }completion:^(BOOL finished) {
        
    }];
}
-(void)animiateshowSkill3{
    [UIView animateWithDuration:0.5 animations:^{
        self.rightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.leftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } completion:^(BOOL finished) {
        if (finished) {
            CGFloat Rightwidth = YYScreenSize().width/2;
            
            UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, YYScreenSize().height-100, Rightwidth-40, 100) cornerRadius:8];
            CutOutClearView *cutOutView = [[CutOutClearView alloc] initWithFrame:CGRectMake(0, 0, YYScreenSize().width/2, YYScreenSize().height)];
            cutOutView.fillColor        = [UIColor redColor];
            cutOutView.paths            = @[bezierPath];
            //    [self.view addSubview:cutOutView];
            self.rightView.maskView = cutOutView;
        }
    }];
    
}

-(void)animateShowProtect{
    [UIView animateWithDuration:0.2 animations:^{
        self.protectTextLabel.alpha = 1;
        self.protectIconImgView.alpha = 1;
        self.protectArrowImgView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            self.protectIconImgView.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark --点击提示弹窗的OK

- (IBAction)onMsgOkClick:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.msgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.msgView.hidden = YES;
            [self.view insertSubview:self.msgView atIndex:0];
            if (self.guideIndex ==3){
                if (self.showSkillItmsBlock) {
                    self.showSkillItmsBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        self.rightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                        self.leftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                    }completion:^(BOOL finished) {
                        [self animateShowProtect];
                    }];
//                    [self animiateshowSkill3];
                    
                });
                
            }else if (self.guideIndex ==4){
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.alpha = 0;
                } completion:^(BOOL finished) {
                    if (self.closeVCBlock) {
                        self.closeVCBlock();
                    }
                }];
            }
        }
    }];
    
    
}


-(void)showMsgViewWithType:(NSInteger)type{
    [self.view bringSubviewToFront:self.msgView];
    self.msgView.hidden = NO;
    if (type == 1) {
        self.msgIconImgView.image = [UIImage imageNamed:@"guid香蕉先生"];
        [self setText:NSLocalizedString(@"Naughty Mr.Banana will let you slip", nil) ForLabel:self.msgTextLabel WithSpace:8];
//        self.msgTextLabel.text = NSLocalizedString(@"Naughty Mr.Banana will let you slip", nil);
    }else{
        self.msgIconImgView.image = [UIImage imageNamed:@"guid怪兽先生"];
        [self setText:NSLocalizedString(@"Watch out！\nAvoid encounter Mr.Monster, otherwise the game is over！", nil) ForLabel:self.msgTextLabel WithSpace:8];
//        self.msgTextLabel.text = NSLocalizedString(@"Watch out！Avoid encounter Mr.Monster, otherwise the game is over！", nil);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.msgView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
}
#pragma mark -- 点击了屏幕
/*
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.guideIndex == 3 && self.rightTextLabel.hidden) {
        UITouch *touch = touches.anyObject;
        CGPoint touchPoint = [touch locationInView:self.rightView];
        if (CGRectContainsPoint(CGRectMake(20, YYScreenSize().height-100, YYScreenSize().width/2-40, 100), touchPoint)) {
            NSLog(@"点击了技能");
            if (self.tapSkill3Block) {
                self.tapSkill3Block();
            }
//            CGFloat Rightwidth = YYScreenSize().width/2;
            
//            UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(YYScreenSize().height/2-50, YYScreenSize().height/2, 50, 50) cornerRadius:8];
//            CutOutClearView *cutOutView = [[CutOutClearView alloc] initWithFrame:CGRectMake(0, 0, YYScreenSize().width/2, YYScreenSize().height)];
//            cutOutView.fillColor        = [UIColor redColor];
//            cutOutView.paths            = @[bezierPath];
//            //    [self.view addSubview:cutOutView];
//            self.leftView.maskView = cutOutView;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self animiateShowRight];
            });
            
        }
        
    }
}
 */
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
