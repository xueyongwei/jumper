//
//  JumpScene.h
//  Jump
//
//  Created by xueyognwei on 2017/6/28.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SKBaseScene.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "SKStepNode.h"
#import "SKJumperNode.h"
#import "SKCloudNode.h"

@interface JumpScene : SKBaseScene <GADRewardBasedVideoAdDelegate>

@property (nonatomic, strong) AVAudioPlayer *bgmPlayer;//游戏背景音乐
@property (nonatomic, assign) NSInteger passedSteps;//通过的阶梯（不包含洞）
@property (nonatomic, assign) CGFloat eachHeight ;//每个阶梯的高度
@property (nonatomic, assign) CGFloat eachStepHeight ;//每个阶梯的高度
@property (nonatomic,assign) BOOL shouldGuide;//应该引导用户
#pragma mark -- actions

#pragma mark -- nodes
@property (nonatomic,strong) SKJumperNode *jumper;//跳跃者
-(void)customUI;
/**
 弹窗提示是否复活
 */
-(void)alertReLiveOrDie;
/**
 复活juper
 */
-(void)reLiveJumper;
/**
 切换场景
 
 @param won 是否胜利
 */
-(void) changeToResultSceneWithWon:(BOOL)won;
@end


