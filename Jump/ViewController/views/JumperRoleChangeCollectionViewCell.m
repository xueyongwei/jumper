//
//  JumperRoleChangeCollectionViewCell.m
//  Jump
//
//  Created by xueyognwei on 2017/9/15.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumperRoleChangeCollectionViewCell.h"

@implementation JumperRoleChangeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 设置数据
 
 @param roleModel 数据
 @param indexPath 索引
 */
-(void)setRoleModel:(JumperRoleModel *)roleModel atIndexPath:(NSIndexPath *)indexPath{
    _roleModel = roleModel;
    indexPath = indexPath;
    NSString *imgName = roleModel.isUnlocked?roleModel.jumperPic:[roleModel.jumperPic stringByAppendingString:@"_黑"];
    self.imgView.image = [UIImage imageNamed:imgName];
}
@end
