//
//  CutOutClearView.m
//  Jump
//
//  Created by xueyognwei on 2017/9/13.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "CutOutClearView.h"

@implementation CutOutClearView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.fillColor       = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.opaque          = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    [self.fillColor setFill];
    UIRectFill(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIBezierPath *path in self.paths) {
        
        CGContextAddPath(context, path.CGPath);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextFillPath(context);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
