//
//  JumpScene_Nodes.h
//  Jump
//
//  Created by xueyognwei on 2017/8/17.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene.h"

@interface JumpScene ()
@property (nonatomic, strong) SKSpriteNode *topLayerNode;//顶层node
@property (nonatomic, strong)SKLabelNode *sourceLabel; //分数label
@property (nonatomic, strong)SKLabelNode *heightSourceLabel; //最高分数label
@property (nonatomic, strong)SKStepNode *pausedStep;//暂停时停留的阶梯
@property (nonatomic,strong) SKSpriteNode *skill1Node;
@property (nonatomic,strong) SKSpriteNode *skill2Node;
@property (nonatomic,strong) SKSpriteNode *skill3Node;
@property (nonatomic,strong) SKLabelNode *skill1LabelNode;
@property (nonatomic,strong) SKLabelNode *skill2LabelNode;
@property (nonatomic,strong) SKLabelNode *skill3LabelNode;

/**
 吃金币后的动画node
 */
@property (nonatomic,strong) SKSpriteNode *eatGoldIconNode;
@end
