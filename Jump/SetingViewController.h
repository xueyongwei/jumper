//
//  SetingViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/8/1.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetingViewController : UIViewController
@property (nonatomic,copy) void(^closeBlick)(void);
@property (nonatomic,copy) void(^effectClickBlock)(void);
@end
