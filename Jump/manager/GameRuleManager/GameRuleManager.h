//
//  GameRuleManager.h
//  Jump
//
//  Created by xueyognwei on 2017/7/19.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRule.h"
@interface GameRuleManager : NSObject
@property (nonatomic,strong) NSMutableArray *allRules;
@property (nonatomic,strong) GameRule *currentRule;

+(id)defaultManager;
/**
 重新开始游戏
 */
-(void)resetGameRule;


/**
 新的分数需要更新规则
 
 @param score 当前分数
 */
-(void)updateGameRuleWithScore:(NSInteger)score;
@end
