//
//  SettingCollectionViewCell.h
//  Jump
//
//  Created by xueyognwei on 2017/8/1.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"
@interface SettingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconImageBTn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) SettingModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) void (^clickBtnBlock)(NSIndexPath *cellIndexPath);
-(void)setModel:(SettingModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end
