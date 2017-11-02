//
//  SettingTableViewCell.m
//  Jump
//
//  Created by xueyognwei on 2017/8/9.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"changchengtecuyuan" size:15];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
