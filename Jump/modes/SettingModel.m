//
//  SettingModel.m
//  Jump
//
//  Created by xueyognwei on 2017/8/1.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel
+(instancetype)settingModelWithTitle:(NSString *)title ImgName:(NSString *)imgName{
    SettingModel *model = [[SettingModel alloc]init];
    model.title = title;
    model.imgName = imgName;
    return model;
}
@end
