//
//  StoreGodsModel.m
//  Jump
//
//  Created by xueyognwei on 2017/7/27.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "StoreGodsModel.h"

@implementation StoreGodsModel
+(instancetype) godWithTitle:(NSString *)title ImgName:(NSString *)imgName Paymount:(NSString *)payMount godType:(GoodsType)godType
{
    StoreGodsModel *model = [[StoreGodsModel alloc]init];
    model.title = title;
    model.imgName = imgName;
    model.payAmount = payMount;
    model.goodType = godType;
    
    return model;
}
@end
