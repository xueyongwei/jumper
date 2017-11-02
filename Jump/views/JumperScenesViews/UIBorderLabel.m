//
//  UIBorderLabel.m
//  Jump
//
//  Created by xueyognwei on 2017/7/26.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "UIBorderLabel.h"

@implementation UIBorderLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(c, self.outLineWidth?self.outLineWidth:1);
    
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    
    self.textColor = self.outLinetextColor?self.outLinetextColor:[UIColor colorWithHexString:@"00acc2"];
    
    [super drawTextInRect:rect];
    
    self.textColor = self.labelTextColor?self.labelTextColor:[UIColor whiteColor];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    
    [super drawTextInRect:rect];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
