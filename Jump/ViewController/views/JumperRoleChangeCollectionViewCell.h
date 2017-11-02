//
//  JumperRoleChangeCollectionViewCell.h
//  Jump
//
//  Created by xueyognwei on 2017/9/15.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JumperRoleModel.h"
@interface JumperRoleChangeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,strong) JumperRoleModel *roleModel;
@property (nonatomic,strong) NSIndexPath *indexPath;

/**
 设置数据

 @param roleModel 数据
 @param indexPath 索引
 */
-(void)setRoleModel:(JumperRoleModel *)roleModel atIndexPath:(NSIndexPath *)indexPath;
@end
