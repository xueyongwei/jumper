//
//  GetDimodAlertView.m
//  Jump
//
//  Created by xueyognwei on 2017/8/24.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GetDimodAlertView.h"
@interface GetDimodAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation GetDimodAlertView
-(void)setDimondCount:(NSInteger)dimondCount
{
    _dimondCount = dimondCount;
    
    NSString *resultStr = [self.countLabel.text stringByAppendingFormat:@"%ld",(long)dimondCount];
    self.countLabel.text = resultStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
