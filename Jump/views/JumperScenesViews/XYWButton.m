//
//  XYWButton.m
//  XYW
//
//  Created by xueyognwei on 2017/6/2.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "XYWButton.h"

@implementation XYWButton
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize imgSize = self.currentBackgroundImage.size;
    UIImage *image = [self.currentBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(imgSize.height*0.5, imgSize.width*0.4, imgSize.height*0.5, imgSize.width*0.4) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

/**
 设置背景图片，保护边角

 @param image iamge
 @param state state
 */
//-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
//{
//    
//    [super setBackgroundImage:image forState:state];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
