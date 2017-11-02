//
//  JumpScene+Random.h
//  Jump
//
//  Created by xueyognwei on 2017/7/3.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene.h"
#import "SKPropNode.h"
#import "GameRule.h"

@interface JumpScene (Random)
/**
 随机一个白云的名字
 
 @return 白云的名字
 */
-(NSString *)randomCloudImageName;

/**
 随机一个白云的位置
 
 @param mustTop 是否从必需顶部出现
 @return 随机位置
 */
-(CGPoint )randomCloudStartPosition:(BOOL )mustTop;

/**
 随机一个踏板图片名字的下标
 
 @return 下标
 */
-(NSInteger)randomImageNameIndex;
/**
 随机一个踏板的名字
 
 @return 踏板图片名字
 */
-(NSString *)randomStepImageName;


/**
 随机摇一个道具
 
 @param step 到这个step
 @param preStep 前一个step
 @param nxtStep 后一个step
 @param rule 当前规则
 @return 道具
 */
-(SKPropNode *)randomOnePropOnStep:(SKStepNode *)step preStep:(SKStepNode *)preStep nxtStep:(SKStepNode *)nxtStep WithGameRule:(GameRule *)rule;
@end
