//
//  SKBaseNode+Actions.m
//  Jump
//
//  Created by xueyognwei on 2017/7/25.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKBaseNode+Actions.h"

@implementation SKBaseNode (Actions)
/**
 默认的缩放动画
 
 @param x x方向
 @param y y方向
 @return 返回这个动画
 */
-(SKAction *)normalZoomActionScaleX:(CGFloat) x Y:(CGFloat) y {
    SKAction *act1 = [SKAction scaleXTo:x y:y duration:0.3];
    SKAction *act11 = [SKAction moveByX:-5 y:0 duration:0.3];
    SKAction *sque1 = [SKAction group:@[act1,act11]];
    SKAction *act2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.2];
    SKAction *act22 = [SKAction moveByX:5 y:0 duration:0.3];
    SKAction *sque2 = [SKAction group:@[act2,act22]];
    return [SKAction sequence:@[sque1,sque2]];
}

/**
 放大一次的动画
 
 @return 这个动画
 */
-(SKAction *)newStepBigOnceAction{
    SKAction *act1 = [SKAction scaleTo:1.5 duration:0.5];
    SKAction *act2 = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *sque2 = [SKAction group:@[act1,act2]];
    return sque2;
}

@end
