//
//  SKPropNode.h
//  Jump
//
//  Created by xueyognwei on 2017/7/5.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKBaseNode.h"
#import "SKStepNode.h"
typedef NS_ENUM(NSInteger, PropStyle) {//道具类型
    PropStyleScoreAddGod=0,//加金币
    PropStyleScoreSlide,//打滑
    PropStyleScoreMoveToHit,//移动的小怪兽
};
@interface SKPropNode : SKBaseNode
@property (nonatomic,assign) PropStyle style;

/**
 创建一个某种类型的道具node
 
 @param style 类型
 @param step 道具node
 @return 目标板子
 */
+(SKPropNode *)propWithStyle:(PropStyle)style onStep:(SKStepNode *)step;
@end
