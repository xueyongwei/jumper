//
//  JumpScene_Actions.h
//  Jump
//
//  Created by xueyognwei on 2017/8/16.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene.h"

@interface JumpScene ()
@property (nonatomic, strong) SKAction *jumperAction;//跳跃动画
@property (nonatomic, strong) SKAction *slipAction;//打滑动画
@property (nonatomic, strong) SKAction *slipPropAction;//炸飞动画
@property (nonatomic,strong)  SKAction *jumperDiedAction;//jumper死亡综合动画
@property (nonatomic, strong) SKAction *stepFallDownAction;//板子掉落动画
@property (nonatomic, strong) SKAction *stepDown1Action;//板子移动一格
@property (nonatomic, strong) SKAction *stepDown2Action;//板子移动两格
@property (nonatomic, strong) SKAction *cloudGoAction;//白云移动动画
@property (nonatomic, strong) SKAction *flyoutAction;//白云移动动画

/**
 吃了金币时，金币的动画
 */
@property (nonatomic, strong) SKAction *eatGoldActuin;
@end
