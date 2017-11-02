//
//  SKBaseNode+Actions.h
//  Jump
//
//  Created by xueyognwei on 2017/7/25.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKBaseNode.h"

@interface SKBaseNode (Actions)
/**
 默认的缩放动画
 
 @param x x方向
 @param y y方向
 @return 返回这个动画
 */
-(SKAction *)normalZoomActionScaleX:(CGFloat) x Y:(CGFloat) y;
/**
 放大一次的动画
 
 @return 这个动画
 */
-(SKAction *)newStepBigOnceAction;
@end
