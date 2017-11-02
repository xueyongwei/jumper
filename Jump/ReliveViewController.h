//
//  ReliveViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/8/10.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReliveViewController : UIViewController
@property (nonatomic,copy) void(^closeBlock)(void);
@property (nonatomic,copy) void(^willCloseBlock)(void);
@property (nonatomic,copy) void(^forFreeBlock)(void);
@property (nonatomic,copy) void(^paymentBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *freeBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *dimondLabel;
-(void)pauseCutDown;
-(void)reStartCutDown;
-(void)closeAlertVC:(void(^)(void))finishBlock;
@end
