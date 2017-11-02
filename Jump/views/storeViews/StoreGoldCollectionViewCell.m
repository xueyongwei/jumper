//
//  StoreGoldCollectionViewCell.m
//  Jump
//
//  Created by xueyognwei on 2017/7/18.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "StoreGoldCollectionViewCell.h"

@implementation StoreGoldCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:12];
    self.priceLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:14];
    // Initialization code
}
-(void)customCellWithModel:(StoreGodsModel *)model AtIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _indexPath = indexPath;
    self.titleLabel.text = model.title;
    self.priceLabel.text = model.payAmount;
    self.showImageView.image = [UIImage imageNamed:model.imgName];
    
    if (model.goodType == GoodsTypeGolds) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"fbb31e"];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"f76148"];
        self.priceIconImageView.image = [UIImage imageNamed:@"商店钻石icon"];
    }else if (model.goodType == GoodsTypeProp){
        
        NSArray *colorNames = @[@"f29b16",@"40b8e6",@"ff3c76"];
        self.titleLabel.textColor = [UIColor colorWithHexString:colorNames[indexPath.item]];
        self.countLabel.backgroundColor = [UIColor colorWithHexString:colorNames[indexPath.item]];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"fbb31e"];
        
        self.priceIconImageView.image = [UIImage imageNamed:@"商店金币icon"];
        if (indexPath.item ==0) {
            self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].skillCleanSubAmount];
        }else if (indexPath.item ==1){
            self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].skillSprintAmount];
        }else if (indexPath.item ==2){
            self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].skillProtectAmount];
        }
    }else if (model.goodType == GoodsTypeDiamond){
        self.titleLabel.textColor = [UIColor colorWithHexString:@"f76148"];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.priceIconImageView.image = nil;
    }
}

@end
