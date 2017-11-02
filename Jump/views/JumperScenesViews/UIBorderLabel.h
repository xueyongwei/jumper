//
//  UIBorderLabel.h
//  Jump
//
//  Created by xueyognwei on 2017/7/26.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBorderLabel : UILabel
/** 描多粗的边*/

@property (nonatomic, assign)IBInspectable NSInteger outLineWidth;

/** 外轮颜色*/

@property (nonatomic, strong)IBInspectable UIColor *outLinetextColor;

/** 里面字体默认颜色*/

@property (nonatomic, strong)IBInspectable UIColor *labelTextColor;
@end
