//
//  SettingModel.h
//  Jump
//
//  Created by xueyognwei on 2017/8/1.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *selName;
+(instancetype)settingModelWithTitle:(NSString *)title ImgName:(NSString *)imgName;
@end
