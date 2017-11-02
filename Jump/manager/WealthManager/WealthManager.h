//
//  WealthManager.h
//  Jump
//
//  Created by xueyognwei on 2017/7/25.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kWealthChangedNoti @"kWealthChangedNoti"
typedef NS_ENUM(NSInteger,SkillType) {
    SkillTypeCleanSub,
    SkillTypeSprint,
    SkillTypeNoDie
};
typedef NS_ENUM(NSInteger , DailyRewardState) {
    DailyRewardStateCooling,
    DailyRewardStateCooled,
    DailyRewardStateFinished,
};
@interface WealthManager : NSObject

/**
 清理障碍技能的数量
 */
@property (nonatomic,assign) NSInteger skillCleanSubAmount;

/**
 冲刺技能的数量
 */
@property (nonatomic,assign) NSInteger skillSprintAmount;

/**
 免疫一次死亡技能的数量
 */
@property (nonatomic,assign) NSInteger skillProtectAmount;

/**
 金币账户数量
 */
@property (nonatomic,assign) NSInteger goldCoinAmount;

/**
 钻石账户数量
 */
@property (nonatomic,assign) NSInteger diamondAmount;

/**
 移除广告
 */
@property (nonatomic,assign) BOOL removedAD;

/**
 获得分享奖励的日期
 */
@property (nonatomic,strong) NSDate *rcvShareRewardDate;


/**
 每日奖励的状态
 */
@property (nonatomic,assign,readonly)DailyRewardState dailyRewardstate;


+(instancetype)defaultManager;

/**
 启动初始化，读取或生成账户
 */
-(void)setupManager;

/**
 得到【某个】技能【多少个】
 
 @param type 得到的技能类型
 @param count 得到的数量
 */
-(void)earnSkillType:(SkillType)type Count:(NSInteger)count;
//总支出金币
-(NSInteger)totalGoldCoinPayed;

/**
 使用了某个技能
 
 @param type 使用的技能类型
 @param count 使用技能的数量
 */
-(void)useSkillType:(SkillType)type Count:(NSInteger)count;

/**
 领取成功今日奖励
 */
-(void)didReceivedDailyReward;

/**
 领取分享奖励成功
 */
-(void)didReceivedShareReward;
/**
 格式化的冷却倒计时字符串
 
 @return 字符串
 */
-(NSString *)formatCutDownString;
@end
