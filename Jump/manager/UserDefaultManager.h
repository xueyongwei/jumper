//
//  UserDefaultManager.h
//  Jump
//
//  Created by xueyognwei on 2017/6/29.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LocalScoreModel : NSObject
@property (nonatomic,assign)NSInteger maxScore;
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign)BOOL newRecorderAndRewared;
@end

@interface UserDefaultManager : NSObject

+(void)setUp;
/**
 更新最新的分数,只记录最高分数
 
 @param score 最新的分数
 */
+(void)updataNewScore:(NSInteger)score;

/**
 获取本地最高分
 
 @return 最高分
 */
+(NSInteger)maxScore;
+(NSDate *)maxScoreDate;
+(NSInteger)totalScore;


+(BOOL)canResultShowAD;
+(void)reLiceOnce;

+(void)gameStart;
+(NSInteger)diedTimeThisPlay;

+(void)setBgmClose:(BOOL)Close;
+(BOOL)isBgmClose;

+(void)setSoundEffectClose:(BOOL)Close;
+(BOOL)isSoundEffectClose;

+(BOOL)shouldGuid;
+(void)didGuid;

+(BOOL)shouldGuidChangeRole;
+(void)didGuidChangeRole;
@end
