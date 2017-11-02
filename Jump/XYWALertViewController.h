//
//  XYWALertViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/8/24.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddContentBlock) (UIView *contentView);
typedef void(^LeftBtnBlock) (UIButton *leftBtn);
typedef void(^RightBtnBlock) (UIButton *rightBtn);
@interface XYWALertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerbtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyHeightConst;
+(XYWALertViewController *)showContentOnWkVC:(UIViewController *)wkVC addContentView:(AddContentBlock )contentSpView withLeftBtnCLick:(LeftBtnBlock)leftCickBlock RightBtnClick:(RightBtnBlock)rightCickBlock;
-(void)removeAlert:(void(^)(void))complete;
@end
