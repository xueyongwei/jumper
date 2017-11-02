//
//  UserDefaultManager.m
//  Jump
//
//  Created by xueyognwei on 2017/6/29.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

/**
 设置本地最高分

 @param score 最高分
 */
+(void)setScore:(NSInteger)score{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setInteger:score forKey:@"localMaxScore"];
}

/**
 获取本地最高分

 @return 最高分
 */
+(NSInteger)maxScore{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf integerForKey:@"localMaxScore"];
}
@end
