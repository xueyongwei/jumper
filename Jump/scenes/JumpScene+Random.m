//
//  JumpScene+Random.m
//  Jump
//
//  Created by xueyognwei on 2017/7/3.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene+Random.h"
#import "GameRuleManager.h"
@implementation JumpScene (Random)

/**
 随机一个白云的名字
 
 @return 白云的名字
 */
-(NSString *)randomCloudImageName{
    int x = arc4random() % 4 +1;//1-4
    return [NSString stringWithFormat:@"白云%d",x];
}


/**
 随机一个白云的位置
 
 @param mustTop 是否从必需顶部出现
 @return 随机位置
 */
-(CGPoint )randomCloudStartPosition:(BOOL )mustTop {
    int minX = -10;
    int maxX = self.size.width+10;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    int actualY = self.size.height;
    if (!mustTop) {
        int minY = self.size.height/2;
        int maxY = self.size.height+10;
        int rangeY = maxY - minY;
        actualY = (arc4random() % rangeY) + minY;
    }
    return CGPointMake(actualX, actualY);
}


/**
 随机一个踏板图片名字的下标
 
 @return 下标
 */
-(NSInteger)randomImageNameIndex{
    int x = arc4random() % 7 +1;//1-7
    return x;
}

/**
 随机一个踏板的名字
 
 @return 踏板图片名字
 */
-(NSString *)randomStepImageName{
    NSInteger index = [self randomImageNameIndex];
    return [NSString stringWithFormat:@"踏板%1ld",(long)index];
    
}



/**
 随机摇一个道具
 
 @param step 到这个step
 @param preStep 前一个step
 @param nxtStep 后一个step
 @param rule 当前规则
 @return 道具
 */
-(SKPropNode *)randomOnePropOnStep:(SKStepNode *)step preStep:(SKStepNode *)preStep nxtStep:(SKStepNode *)nxtStep WithGameRule:(GameRule *)rule{
    PropStyle style = [self randomPropStyleOn:step preStep:preStep nxtStep:nxtStep WithGameRule:rule];
    if (style == NSNotFound) {
        return nil;
    }
    SKPropNode *prop = [SKPropNode propWithStyle:style onStep:step];
    
//    CGSize orgSize = prop.size;
//    CGFloat height = 50*(orgSize.height/orgSize.width);
//    prop.size = CGSizeMake(50, height);
    return prop;
}

/**
 获取一个复合当前规则的道具类型
 
 @param step 到这个step
 @param preStep 前一个step
 @param nxtStep 后一个step
 @param rule 当前分数的游戏规则
 @return 道具类型
 */
-(PropStyle)randomPropStyleOn:(SKStepNode *)step preStep:(SKStepNode *)preStep nxtStep:(SKStepNode *)nxtStep WithGameRule:(GameRule *)rule{
    NSMutableArray *canShowProps = [[NSMutableArray alloc]init];
    for (RuleProp *prop in rule.props) {
        NSLog(@"=== 道具 :%@ %ld",prop,(long)prop.propStyle);
        CGFloat percent = 1;
        if (prop.showProb==0) {//不出现
            NSLog(@"=== 不出现");
            percent = 0;//概率0滚出
        }else{
            percent *= prop.showProb;//出现的概率
            if (preStep.isHole) {
                NSLog(@"=== prestep 是个洞");
                percent *= prop.showAfterHoleProb;//出现的概率
                if (nxtStep.isHole) {//前洞后洞
                    NSLog(@"=== nxtStep 是个洞");
                    percent *= prop.showBeforeHoleProb;
                }else{//前洞后板
                }
            }else{
                if (nxtStep.isHole) {//前板后洞
                    NSLog(@"=== nxtStep 是个洞");
                    percent *= prop.showBeforeHoleProb;
                }else{//前板后板
                }
            }
            if (preStep.propNode) {
                if (preStep.propNode.style == prop.propStyle) {//已经出现过了
                    NSLog(@"=== preStep 有道具 %ld",(long)prop.propStyle);
                    percent *= prop.showAfterPropProb;
                }
            }else{
            }
        }
        NSLog(@"=== 当前出现的概率为 %f",percent);
        [canShowProps addObject:@(percent)];
    }
    //得到了三个属性最后出现的概率
    NSInteger index = [self resultIndexOfProbs:canShowProps];
    if (index == NSNotFound) {
        NSLog(@"=== 不添加道具");
        return NSNotFound;
    }
    RuleProp *resultProp = rule.props[index];
    NSLog(@"=== 添加道具类型：%ld",(long)resultProp.propStyle);
    return resultProp.propStyle;
}


/**
 找到这么多个prop的下标

 @param probs 道具们
 @return 下标
 */
-(NSInteger)resultIndexOfProbs:(NSArray *)probs{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:probs.count];
    for (NSNumber *nb in probs) {
         NSNumber *last = arr.lastObject;
        [arr addObject: @(nb.floatValue*100+last.floatValue)];
    }
    NSInteger x = arc4random() %100;
    DDLogInfo(@"x = %ld ,arr = %@ probs= %@",(long)x,arr,probs);
    for (NSInteger i = 0; i<arr.count; i++) {
        NSNumber *nb = arr[i];
        DDLogInfo(@"i = %ld ,nb = %@",(long)i,nb);
        if (x < nb.integerValue) {
            DDLogInfo(@"return %ld",(long)i);
            return i;
        }
    }
    return NSNotFound;
}
@end
