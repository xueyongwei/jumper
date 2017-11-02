//
//  SettingAboutHeaderFooterView.m
//  Jump
//
//  Created by xueyognwei on 18/10/2017.
//  Copyright © 2017 xueyognwei. All rights reserved.
//

#import "SettingAboutHeaderFooterView.h"

@implementation SettingAboutHeaderFooterView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",[UIApplication sharedApplication].appVersion];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
