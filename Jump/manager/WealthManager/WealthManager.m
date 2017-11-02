//
//  WealthManager.m
//  Jump
//
//  Created by xueyognwei on 2017/7/25.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "WealthManager.h"
#import "LocalNotificationManager.h"
//static NSString *const kWealthKey = @"kWealthNSUserDefaultsKey";
//static NSString *const kGodCionKey = @"kGodCionKeyNSUserDefaultsKey";
//static NSString *const kDiamondKey = @"kDiamondKeyNSUserDefaultsKey";
//
//static NSString *const kSkillCleanSubKey = @"kSkillCleanSubKeyNSUserDefaultsKey";
//static NSString *const kSkillNoDieKey = @"kSkillNoDieKeyNSUserDefaultsKey";
//static NSString *const kSkillSprintsKey = @"kSkillSprintsKeyNSUserDefaultsKey";
static NSString *const kRemovedADKey = @"kRemovedADKeyNSUserDefaultsKey";

static NSString *const kGodCionCountKey = @"wealth_GoldCoinCount";
static NSString *const kDiamondCountKey = @"wealth_DiamondCount";
static NSString *const kSkillCleanSubCountKey = @"wealth_SkillCleanSubCount";
static NSString *const kSkillSprintCountKey = @"wealth_SkillSprintCount";
static NSString *const kSkillProtectCountKey = @"wealth_SkillProtectCount";

static NSString *const kRceiceDailyRewardTimesKey = @"wealth_RceiceDailyRewardTimes";
static NSString *const kRceiceDailyRewardDateKey = @"wealth_RceiceDailyRewardDate";

static NSString *const kRceiceShareRewardDateKey = @"wealth_RceiceShareRewardDateKey";

@interface WealthManager()
/**
 上次领取奖励的日期
 */
@property (nonatomic,strong) NSDate *lastReceiveDailyrewardDate;

/**
 领取每日奖励的次数
 */
@property (nonatomic,assign) NSInteger receiveDailyrewardTimes;


/**
 距离上一次领奖过去的时间
 */
@property (nonatomic,assign) NSTimeInterval SurplusSec;
@end


@implementation WealthManager
+(instancetype)defaultManager
{
    static WealthManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WealthManager alloc]init];
    });
    return manager;
}


/**
 初始化，读取本地数据赋值
 */
-(void)setupManager{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    self.goldCoinAmount = [usf integerForKey:kGodCionCountKey];
    self.diamondAmount = [usf integerForKey:kDiamondCountKey];
    self.skillCleanSubAmount = [usf integerForKey:kSkillCleanSubCountKey];
    self.skillSprintAmount = [usf integerForKey:kSkillSprintCountKey];
    self.skillProtectAmount = [usf integerForKey:kSkillProtectCountKey];
    
    self.removedAD = [usf boolForKey:kRemovedADKey];
    
    self.receiveDailyrewardTimes = [usf integerForKey:kRceiceDailyRewardTimesKey];
    self.lastReceiveDailyrewardDate = [usf objectForKey:kRceiceDailyRewardDateKey];
    self.rcvShareRewardDate = [usf objectForKey:kRceiceShareRewardDateKey];
    [self updateDailyRewardState];
}

#pragma mark -- 💎钻石账户
/**
 更新钻石账户数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param diamondAmount 钻石余额数量
 */
-(void)setDiamondAmount:(NSInteger)diamondAmount
{
    _diamondAmount = diamondAmount;
    [[NSUserDefaults standardUserDefaults]setInteger:diamondAmount forKey:kDiamondCountKey];
}

//总支出金币
-(NSInteger)totalGoldCoinPayed{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf integerForKey:@"totalGoldCoinPayed"];
}

-(void)payGoldCoinWithCount:(NSInteger)count{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSInteger localCount = [usf integerForKey:@"totalGoldCoinPayed"];
    [usf setInteger:localCount+count forKey:@"totalGoldCoinPayed"];
    
}
/**
 跟新领取分享奖励的日期

 @param rcvShareRewardDate 领取分享奖励的日期
 */
-(void)setRcvShareRewardDate:(NSDate *)rcvShareRewardDate
{
    _rcvShareRewardDate = rcvShareRewardDate;
    [[NSUserDefaults standardUserDefaults] setObject:rcvShareRewardDate forKey:kRceiceShareRewardDateKey];
}
#pragma mark -- 💰金币账户
/**
 得到【某个】技能【多少个】
 
 @param type 得到的技能类型
 @param count 得到的数量
 */
-(void)earnSkillType:(SkillType)type Count:(NSInteger)count{
    if (type == SkillTypeCleanSub) {
        self.skillCleanSubAmount +=count;
    }else if (type == SkillTypeSprint){
        self.skillSprintAmount +=count;
    }else if (type == SkillTypeNoDie){
        self.skillProtectAmount +=count;
    }
}


/**
 使用了某个技能
 
 @param type 使用的技能类型
 @param count 使用技能的数量
 */
-(void)useSkillType:(SkillType)type Count:(NSInteger)count{
    if (type == SkillTypeCleanSub) {
        self.skillCleanSubAmount -=count;
    }else if (type == SkillTypeSprint){
        self.skillSprintAmount -=count;
    }else if (type == SkillTypeNoDie){
        self.skillProtectAmount -=count;
    }
}
/**
 更新金币账户数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param goldCoinAmount 金币账户余额数量
 */
-(void)setGoldCoinAmount:(NSInteger)goldCoinAmount
{
    if (goldCoinAmount<_goldCoinAmount) {//消耗了
        [self payGoldCoinWithCount:_goldCoinAmount-goldCoinAmount ];
    }
    _goldCoinAmount = goldCoinAmount;
    [[NSUserDefaults standardUserDefaults]setInteger:goldCoinAmount forKey:kGodCionCountKey];
}
#pragma mark -- 👋技能账户
/**
 更新清理障碍技能账户数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param skillCleanSubAmount 清理障碍技能数量
 */
-(void)setSkillCleanSubAmount:(NSInteger)skillCleanSubAmount
{
    
    _skillCleanSubAmount = skillCleanSubAmount;
    [[NSUserDefaults standardUserDefaults]setInteger:skillCleanSubAmount forKey:kSkillCleanSubCountKey];
}


/**
 更新冲刺技能账户数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param skillSprintAmount 冲刺技能数量
 */
-(void)setSkillSprintAmount:(NSInteger)skillSprintAmount
{
    _skillSprintAmount = skillSprintAmount;
    [[NSUserDefaults standardUserDefaults]setInteger:skillSprintAmount forKey:kSkillSprintCountKey];
}


/**
 更新保护罩技能账户数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param skillProtectAmount 保护罩技能数量
 */
-(void)setSkillProtectAmount:(NSInteger)skillProtectAmount
{
    _skillProtectAmount = skillProtectAmount;
    [[NSUserDefaults standardUserDefaults]setInteger:skillProtectAmount forKey:kSkillProtectCountKey];
}

#pragma mark -- 永久去广告

/**
 更新钻石账户数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param removedAD 是否移除了广告
 */
-(void)setRemovedAD:(BOOL)removedAD
{
    _removedAD = removedAD;
    [[NSUserDefaults standardUserDefaults] setBool:removedAD forKey:kRemovedADKey];
}

#pragma mark -- 每日奖励
-(void)didReceivedDailyReward
{
    
    if ([self.lastReceiveDailyrewardDate isToday]) {
        self.receiveDailyrewardTimes += 1;
    }else{//不是今天
        self.receiveDailyrewardTimes = 1;
    }
    NSString *tiemsStr = [NSString stringWithFormat:@"第%ld次",(long)self.receiveDailyrewardTimes];
    [FIRAnalytics logEventWithName:@"领取钻石" parameters:@{@"次数":tiemsStr}];
    //更新最后领取时间是现在
    self.lastReceiveDailyrewardDate = [NSDate date];
    [self tryPushLocalNotification];
}

-(void)tryPushLocalNotification{
    NSInteger min = 5;
    switch (_receiveDailyrewardTimes) {
        case 1: min=5; break;
        case 2:min=30;break;
        case 3:min=60; break;
        case 4: min=240;break;
        default:min=0;break;
    }
    if (min!=0) {
        [[LocalNotificationManager defaultManager] sendLocalNotificationAfter:min];
    }
}
/**
 更新奖励领取状态
 */
-(void)updateDailyRewardState{
    //走过的时间，eg，1，800
    NSTimeInterval passedSec = [[NSDate date] timeIntervalSinceDate:_lastReceiveDailyrewardDate];
    if (![self.lastReceiveDailyrewardDate isToday]) {//不是今天，肯定冷却完毕了
        _dailyRewardstate = DailyRewardStateCooled;
        return;
    }else{
        if (self.receiveDailyrewardTimes>4) {
            _dailyRewardstate = DailyRewardStateFinished;
            return;
        }
        switch (_receiveDailyrewardTimes) {
            case 1: _SurplusSec = 5*60 - passedSec; break;
            case 2:_SurplusSec = 30*60 - passedSec; break;
            case 3:_SurplusSec = 60*60 - passedSec; break;
            case 4: _SurplusSec = 4*60*60 - passedSec;break;
            default:
            {
                _dailyRewardstate = DailyRewardStateCooled;
                return;
            }
                break;
        }
    }
    
    if (_SurplusSec>0) {//时间还不到
        _dailyRewardstate = DailyRewardStateCooling;
    }else{
        _dailyRewardstate = DailyRewardStateCooled;
    }
}
-(NSString *)formatCutDownString{
    [self updateDailyRewardState];
    if (_dailyRewardstate == DailyRewardStateFinished) {
        return @"";
    }else if (_dailyRewardstate == DailyRewardStateCooled){
        return @"";
    }else{
        return [self stringOfSurplusSec:_SurplusSec];
    }
}
/**
 更新每日奖励次数数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param receiveDailyrewardTimes 领取每日奖励的次数
 */
-(void)setReceiveDailyrewardTimes:(NSInteger)receiveDailyrewardTimes
{
    _receiveDailyrewardTimes = receiveDailyrewardTimes;
    [[NSUserDefaults standardUserDefaults] setInteger:receiveDailyrewardTimes forKey:kRceiceDailyRewardTimesKey];
}

/**
 更新上一次领取奖励的日期数据，存到userDefaults，不定期保存，后台失活保存，die保存

 @param lastReceiveDailyrewardDate 上一次领取奖励的日期
 */
-(void)setLastReceiveDailyrewardDate:(NSDate *)lastReceiveDailyrewardDate
{
    _lastReceiveDailyrewardDate = lastReceiveDailyrewardDate;
    [[NSUserDefaults standardUserDefaults] setObject:lastReceiveDailyrewardDate forKey:kRceiceDailyRewardDateKey];
}

/**
 领取分享奖励成功
 */
-(void)didReceivedShareReward{
    self.diamondAmount +=3;
    self.rcvShareRewardDate = [NSDate date];
}
/**
 剩余时间的格式化字符串
 
 @param surplusSec 剩余的时间
 @return 格式化字符串
 */
-(NSString *)stringOfSurplusSec:(NSInteger)surplusSec{
    NSInteger h = surplusSec / 3600;
    NSInteger m = surplusSec % 3600 /60;
    NSInteger s = surplusSec - h*3600 - m*60;
    return [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)h,(long)m,(long)s];
//    if (surplusSec<=60) {
//        return [NSString stringWithFormat:@"0:0:%ld",(long)surplusSec];
//    }else if (surplusSec>60 && surplusSec<=3600){//分钟
//        NSInteger m = surplusSec / 60;
//        NSInteger s = surplusSec % 60;
//        return [NSString stringWithFormat:@"%02ld:%02ld",(long)m,(long)s];
//    }else{//小时
//        NSInteger h = surplusSec / 3600;
//        NSInteger m = surplusSec % 3600 /60;
//        NSInteger s = surplusSec - h*3600 - m*60;
//        return [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)h,(long)m,(long)s];
//    }
    
}




@end
