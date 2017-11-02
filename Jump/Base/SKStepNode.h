//
//  SKStepNode.h
//  Jump
//
//  Created by xueyognwei on 2017/6/30.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKBaseNode.h"
@class SKPropNode;
//typedef NS_ENUM(NSInteger, SKStepNodePropType) {
//    SKStepNodePropTypeNone,
//    SKStepNodePropTypeAddTime,
//    SKStepNodePropTypeSubTime,
//};
@interface SKStepNode : SKBaseNode
@property (nonatomic,assign) BOOL isHole;
//@property (nonatomic,assign) SKStepNodePropType propType;
@property (nonatomic,assign) CGFloat goingToY;
@property (nonatomic,strong) SKPropNode *propNode;
@property (nonatomic,assign) CGFloat stayDuration;
@end
