//
//  JumpScene+Actions.h
//  Jump
//
//  Created by xueyognwei on 2017/6/30.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene.h"
static NSString* const kJumperFallDownActionKey = @"JumperFallDownActionKey";
static NSString* const kStepFallDownActionKey = @"StepFallDownActionKey";
static NSString* const kStepMoveDownActionKey = @"StepMoveDownActionKey";

@interface JumpScene (Actions)



/**
 白云飘逸的动画
 
 @return 白云默认动画
 */
-(SKAction *)actionCloudNormal;

/**
 跳动时的duangduang动画
 
 @return duang动画
 */
-(SKAction *)ActionJumperDuangWithSize:(CGFloat) size;


/**
 默认的缩放动画
 
 @param x x方向
 @param y y方向
 @return 返回这个动画
 */
-(SKAction *)normalZoomActionScaleX:(CGFloat) x Y:(CGFloat) y;
-(SKAction *)zoomScaleX:(CGFloat)x scaleY:(CGFloat)y;
-(SKAction *)newZoomActionWithDuration:(CGFloat)dutation;
#pragma mark -- 板子的动画
/**
 放大一次的动画
 
 @return 这个动画
 */
-(SKAction *)newStepBigOnceAction;

/**
 掉下去的动画
 
 @return 这个动画
 */
-(SKAction *)newStepFallDownAction;


/**
 滑动一下的动画
 
 @return 动画
 */
-(SKAction *)newSlipAction;

/**
 建立一个duration的滑动动画
 
 @return 动画
 */
-(SKAction *)newSlipActionWithDuration:(CGFloat)duration;
/**
 sliper的动画
 
 @return 动画
 */
-(SKAction *)newSlipPropAction;
/**
 踩到炸弹的动画
 
 @return 动画
 */
-(SKAction *)newBoomAction;

/**
 jumper的动画
 
 @return 动画
 */
-(SKAction *)newJumperAction;

/**
 阶梯下降一个格子
 
 @return 动画
 */
-(SKAction *)newStepDown1Action;

/**
 阶梯下降两个格子
 
 @return 动画
 */
-(SKAction *)newStepDown2Action;

/**
 阶梯下降N个格子
 
 @return 动画
 */
-(SKAction *)newStepDownActionWithCount:(NSInteger)count;
/**
 jumper跌落死亡的综合动画
 
 @return 动画
 */
-(SKAction *)newJumperDiedWithEffectAction;


/**
 jumper护照时的动画

 @return 动画
 */
-(SKAction *)newJumperProtectAction;

-(SKAction *)newGoldPropsAction;
//技能音效动画
-(SKAction *)newSprintEffectAction;
-(SKAction *)newCleanSoundEffectAction;
-(SKAction *)newProtectSoundEffectAction;
@end
