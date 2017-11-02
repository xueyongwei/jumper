//
//  JumperRoleModel.h
//  Jump
//
//  Created by xueyognwei on 2017/9/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JumperRoleUnlockType) {
    JumperRoleUnlockTypeGold,//默认从0开始，金币解锁
    JumperRoleUnlockTypeDiamonds,//钻石解锁
    JumperRoleUnlockTypeShare,//分享解锁
    JumperRoleUnlockTypeHeightScore,//高分解锁
    JumperRoleUnlockType5Star,//5星好评解锁
    JumperRoleUnlockTypeAccumulatedConsumptionGold,//累计消费金币
    JumperRoleUnlockTypeAccumulatedConsumptionDiamonds,//累计消耗钻石
    JumperRoleUnlockTypeAccumulatedScore,//累计分数
};
@interface JumperRoleModel : NSObject
@property (nonatomic,assign) NSInteger roleID;//角色ID
@property (nonatomic,assign) JumperRoleUnlockType unlockType;//解锁类型
@property (nonatomic,assign) NSInteger unlockConsumption;//解锁消费
@property (nonatomic,assign) BOOL isUnlocked;//是否已经解锁
@property (nonatomic,copy) NSString *nickName;//用户定义的昵称
@property (nonatomic,copy) NSString *defaultName;//默认的昵称
@property (nonatomic,copy) NSString *jumperPic;//角色图片名


@end
