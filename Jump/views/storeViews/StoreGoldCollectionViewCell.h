//
//  StoreGoldCollectionViewCell.h
//  Jump
//
//  Created by xueyognwei on 2017/7/18.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGodsModel.h"
@interface StoreGoldCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *priceIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConst;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong)StoreGodsModel *model;
-(void)customCellWithModel:(StoreGodsModel *)model AtIndexPath:(NSIndexPath *)indexPath;
@end
