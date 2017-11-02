//
//  StoreGodsModel.h
//  Jump
//
//  Created by xueyognwei on 2017/7/27.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WealthManager.h"
typedef NS_ENUM(NSInteger,GoodsType) {
    GoodsTypeProp,
    GoodsTypeGolds,
    GoodsTypeDiamond
};

@interface StoreGodsModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *payAmount;
@property (nonatomic,assign) NSInteger getCoinAmount;
@property (nonatomic,assign) SkillType getSkillType;
@property (nonatomic,assign) GoodsType goodType;
+(instancetype) godWithTitle:(NSString *)title ImgName:(NSString *)imgName Paymount:(NSString *)payMount godType:(GoodsType)godType;
@end
