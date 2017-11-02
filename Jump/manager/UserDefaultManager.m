//
//  UserDefaultManager.m
//  Jump
//
//  Created by xueyognwei on 2017/6/29.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "UserDefaultManager.h"
#import "XYWVersonManager.h"
@implementation LocalScoreModel

@end
@implementation UserDefaultManager
+(void)setUp{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"gameStartTimes"];
}
#pragma mark -- 最高分纪录
/**
 更新最新的分数,只记录最高分数
 
 @param score 最新的分数
 */
+(void)updataNewScore:(NSInteger)score{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSInteger maxScore = [UserDefaultManager maxScore];
    NSInteger localScore = [usf integerForKey:@"totalScore"];
    [usf setInteger:localScore+score forKey:@"totalScore"];
    if (score>maxScore) {
        [usf setInteger:score forKey:@"localMaxScore"];
        [usf setObject:[NSDate date] forKey:@"localMaxScoreDate"];
    }
}

/**
 总分

 @return 总分
 */
+(NSInteger)totalScore
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf integerForKey:@"totalScore"];
}
/**
 获取本地最高分
 
 @return 最高分
 */
+(NSInteger)maxScore{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf integerForKey:@"localMaxScore"];
}

/**
 最高分获得时间
 
 @return 时间
 */
+(NSDate*)maxScoreDate{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf objectForKey:@"localMaxScoreDate"];
}

#pragma mark -- 游戏及复活次数


/**
 已经死了几次了

 @return 次数
 */
+(NSInteger)diedTimeThisPlay{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf integerForKey:@"playTimesThisPlay"];
}
+(NSInteger)startGameTime{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf integerForKey:@"gameStartTimes"];
}
/**
 游戏开始，设置本次复活次数为0，玩的次数加1
 */
+(void)gameStart
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setInteger:0 forKey:@"playTimesThisPlay"];
    NSInteger playTimes = [usf integerForKey:@"gameStartTimes"];
    [usf setInteger:playTimes+1 forKey:@"gameStartTimes"];
    [usf synchronize];
}


+(BOOL)canResultShowAD{
    NSInteger times = [self startGameTime];
    if (times%4==0&&times!=0) {
        return YES;
    }
    return NO;
}
+(void)reLiceOnce{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSInteger times = [self diedTimeThisPlay];
    [usf setInteger:times+1 forKey:@"playTimesThisPlay"];
    [usf synchronize];
}

+(void)setBgmClose:(BOOL)Close{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setBool:Close forKey:@"setBgmClose"];
    [usf synchronize];
}
+(BOOL)isBgmClose{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf boolForKey:@"setBgmClose"];
}

+(void)setSoundEffectClose:(BOOL)Close{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setBool:Close forKey:@"setSoundEffectClose"];
    [usf synchronize];
}
+(BOOL)isSoundEffectClose{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf boolForKey:@"setSoundEffectClose"];
}
+(BOOL)shouldGuid{
    if ([XYWVersonManager shareManager].lunchType != XYWVersonManagerLunchTypeNormal) {
        CGFloat thisVersion = [XYWVersonManager shareManager].currentVersion;
        
        NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"%f",thisVersion];
        BOOL haveGuied = [usf boolForKey:key];
        return !haveGuied;
    }else{
        return NO;
    }
}
+(void)didGuid{
    CGFloat thisVersion = [XYWVersonManager shareManager].currentVersion;
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%f",thisVersion];
    [usf setBool:YES forKey:key];
    [usf synchronize];
}

+(BOOL)shouldGuidChangeRole{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    BOOL haveGuied = [usf boolForKey:@"shouldGuidChangeRole"];
    return !haveGuied;
}
+(void)didGuidChangeRole{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setBool:YES forKey:@"shouldGuidChangeRole"];
}

@end
