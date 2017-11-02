//
//  GameRuleManager.m
//  Jump
//
//  Created by xueyognwei on 2017/7/19.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GameRuleManager.h"

@implementation GameRuleManager
{
    NSInteger _ruleIndex;
}
+(id)defaultManager{
    static GameRuleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        [manager initCinfig];
    });
    return manager;
}
-(NSMutableArray *)allRules
{
    if (!_allRules) {
        _allRules = [[NSMutableArray alloc]init];
    }
    return _allRules;
}
-(void)initCinfig{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameRuleConfig" ofType:@"plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                GameRule *rule = [GameRule modelWithDictionary:dic];
                [self.allRules addObject:rule];
            }
            [self resetGameRule];
        }else{
            DDLogError(@"游戏规则为空！");
        }
        
    }
}


/**
 重新开始游戏
 */
-(void)resetGameRule{
    GameRule *rule = self.allRules.firstObject;
    self.currentRule = rule;
}

/**
 新的分数需要更新规则

 @param score 当前分数
 */
-(void)updateGameRuleWithScore:(NSInteger)score
{
    if ([self.currentRule ContainScore:score]) {
        DDLogVerbose(@"分数 %ld 还在第 %ld 段内",(long)score,(long)_ruleIndex);
    }else{
        DDLogVerbose(@"更新分数 %ld 的规则",(long)score);
        self.currentRule = [self newRuleWithScore:score];
    }
}


/**
 寻找新的规则

 @param score 分数
 @return 对应的规则
 */
-(GameRule *)newRuleWithScore:(NSInteger)score{
    if (self.currentRule == self.allRules.lastObject) {
        DDLogVerbose(@"已经是最后一个阶段了,还用当前这个规则");
        return self.currentRule;
    }
    NSInteger indexOfCurrentRule = [self.allRules indexOfObject:self.currentRule];
   
    for (NSInteger i = indexOfCurrentRule+1; i<self.allRules.count; i++) {
        GameRule *rule = self.allRules[i];
        if ([rule ContainScore:score]) {
            _ruleIndex = i;
            DDLogVerbose(@"分数%ld找到第%ld阶段的规则 %@",(long)score,(long)i,rule);
            return rule;
        }
    }
    return self.allRules.lastObject;
}
@end
