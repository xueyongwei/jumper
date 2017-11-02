//
//  GameRule.h
//  Jump
//
//  Created by xueyognwei on 2017/7/19.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPropNode.h"

#pragma mark -- GameRule
@interface GameRule : NSObject
@property (nonatomic,assign) NSInteger minScore;
@property (nonatomic,assign) NSInteger maxScore;
@property (nonatomic,assign) CGFloat stepDuration;
@property (nonatomic,strong) NSArray *props;
-(BOOL)ContainScore:(NSInteger)score;
@end

#pragma mark -- RuleProp
@interface RuleProp : NSObject
@property (nonatomic,copy) NSString *propType;
@property (nonatomic,assign) PropStyle propStyle;
@property (nonatomic,assign) CGFloat showProb;
@property (nonatomic,assign) CGFloat showBeforeHoleProb;
@property (nonatomic,assign) CGFloat showAfterHoleProb;
@property (nonatomic,assign) CGFloat showBeforePropProb;
@property (nonatomic,assign) CGFloat showAfterPropProb;
@end
