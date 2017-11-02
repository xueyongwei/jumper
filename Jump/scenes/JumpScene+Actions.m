//
//  JumpScene+Actions.m
//  Jump
//
//  Created by xueyognwei on 2017/6/30.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene+Actions.h"
#import <AFNetworking.h>
#import "UserDefaultManager.h"
#import "JumpScene_Actions.h"
@implementation JumpScene (Actions)

#pragma mark -- 背景动画
/**
 白云飘逸的动画
 
 @return 白云默认动画
 */
-(SKAction *)actionCloudNormal{
    SKAction *act1 = [SKAction scaleXTo:1.1 y:1.0 duration:2.0];
    SKAction *act2 = [SKAction scaleXTo:1.1 y:1.1 duration:1.0];
    SKAction *act3 = [SKAction scaleXTo:1.0 y:1.0 duration:2.0];
    SKAction *act5 = [SKAction moveByX:5 y:arc4random()%10 duration:2.0];
    SKAction *act4 = [SKAction waitForDuration:1];
    SKAction *sque = [SKAction sequence:[NSArray arrayWithObjects:act1,act2,act5,act3,act4,nil]];
    SKAction *repeat = [SKAction repeatActionForever:sque];
    return repeat;
}


-(SKAction *)newJumpSoundEffectAction{
    SKAction *ac = [SKAction playSoundFileNamed:@"jump.caf" waitForCompletion:NO];
    return ac;
}
-(SKAction *)newLoseSoundEffectAction{
    SKAction *ac = [SKAction playSoundFileNamed:@"lose.caf" waitForCompletion:NO];
    return ac;
}
-(SKAction *)newSprintEffectAction{
    SKAction *ac = [SKAction playSoundFileNamed:@"sprint.caf" waitForCompletion:YES];
    return ac;
}
-(SKAction *)newCleanSoundEffectAction{
    SKAction *ac = [SKAction playSoundFileNamed:@"clean.caf" waitForCompletion:NO];
    return ac;
}

-(SKAction *)newProtectSoundEffectAction{
    SKAction *ac = [SKAction playSoundFileNamed:@"protect.caf" waitForCompletion:NO];
    return ac;
}

#pragma mark -- 通用动画
-(SKAction *)zoomScaleX:(CGFloat)x scaleY:(CGFloat)y{
    SKAction *act1 = [SKAction scaleXTo:x y:y duration:0.2];
    SKAction *act2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.3];
    SKAction *se = [SKAction sequence:[NSArray arrayWithObjects:act1,act2,nil]];
    return se;
}
/**
 默认的缩放动画

 @param x x方向
 @param y y方向
 @return 返回这个动画
 */
-(SKAction *)normalZoomActionScaleX:(CGFloat) x Y:(CGFloat) y {
    SKAction *act1 = [SKAction scaleXTo:x y:y duration:0.3];
    SKAction *act11 = [SKAction moveByX:-5 y:0 duration:0.3];
    SKAction *sque1 = [SKAction group:[NSArray arrayWithObjects:act1,act11,nil]];
    SKAction *act2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.2];
    SKAction *act22 = [SKAction moveByX:5 y:0 duration:0.3];
    SKAction *sque2 = [SKAction group:[NSArray arrayWithObjects:act2,act22,nil]];
    return [SKAction sequence:[NSArray arrayWithObjects:sque1,sque2,nil]];
}
/**
 放大一次的动画
 
 @return 这个动画
 */
-(SKAction *)newZoomActionWithDuration:(CGFloat)dutation{
    SKAction *act1 = [SKAction scaleTo:1.3 duration:dutation];
    SKAction *act2 = [SKAction scaleTo:1.0 duration:dutation];
    SKAction *sque2 = [SKAction sequence:[NSArray arrayWithObjects:act1,act2,nil]];
    return sque2;
}
/**
 放大一次的动画

 @return 这个动画
 */
-(SKAction *)newStepBigOnceAction{
    SKAction *act1 = [SKAction scaleTo:1.5 duration:0.5];
    SKAction *act2 = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *sque2 = [SKAction sequence:[NSArray arrayWithObjects:act1,act2,nil]];
    return sque2;
}
/**
 滑动一下的动画
 
 @return 动画
 */
-(SKAction *)newSlipAction{
    SKAction *ac1 = [SKAction moveByX:40 y:20 duration:0.05];
    SKAction *ac2 = [SKAction rotateToAngle:0.1 duration:0.05];
    SKAction *g1 = [SKAction group:[NSArray arrayWithObjects:ac1,ac2,nil]];
    
    SKAction *ac3 = [SKAction moveByX:-40 y:-20 duration:0.05];
    SKAction *ac4 = [SKAction rotateToAngle:0 duration:0.05];
    SKAction *g2 = [SKAction group:[NSArray arrayWithObjects:ac3,ac4,nil]];
    SKAction *res = [SKAction sequence:[NSArray arrayWithObjects:g1,g2,nil]];
    return res;
}
/**
 建立一个duration的滑动动画
 
 @return 动画
 */
-(SKAction *)newSlipActionWithDuration:(CGFloat)duration{
    SKAction *ac1 = [SKAction moveByX:40 y:20 duration:duration/2];
    SKAction *ac2 = [SKAction rotateToAngle:0.1 duration:duration/2];
    SKAction *g1 = [SKAction group:[NSArray arrayWithObjects:ac1,ac2,nil]];
    
    SKAction *ac3 = [SKAction moveByX:-40 y:-20 duration:duration/2];
    SKAction *ac4 = [SKAction rotateToAngle:0 duration:duration/2];
    SKAction *g2 = [SKAction group:[NSArray arrayWithObjects:ac3,ac4,nil]];
    SKAction *res = [SKAction sequence:[NSArray arrayWithObjects:g1,g2,nil]];
    return res;
}
/**
 旋转变小动画
 
 @return 动画
 */
-(SKAction *)newRotateScaleAction{
    SKAction *ac1 = [SKAction rotateToAngle:M_PI*2 duration:0.6];
    SKAction *ac2 = [SKAction scaleTo:0.1 duration:0.6];
    SKAction *res = [SKAction group:[NSArray arrayWithObjects:ac1,ac2,nil]];
    return res;
}
#pragma mark -- 板子动画
/**
 板子掉下去的动画
 
 @return 这个动画
 */
-(SKAction *)newStepFallDownAction{
    SKAction *fadeout = [SKAction fadeOutWithDuration:0.5];
    SKAction *scaleSmall = [SKAction scaleTo:0.01 duration:0.5];
    SKAction *move = [SKAction moveByX:self.eachHeight*2 y:self.eachHeight/2 duration:0.5];
    
    SKAction *sque = [SKAction group:[NSArray arrayWithObjects:fadeout,scaleSmall,move,nil]];
    return sque;
}
/**
 阶梯下降一个格子
 
 @return 动画
 */
-(SKAction *)newStepDown1Action{
    SKAction *stepDownAct = [SKAction moveByX:0 y:-self.eachHeight duration:self.jumperAction.duration];
    return stepDownAct;
}

/**
 阶梯下降两个格子
 
 @return 动画
 */
-(SKAction *)newStepDown2Action{
    SKAction *stepDownAct = [SKAction moveByX:0 y:-self.eachHeight*2 duration:self.jumperAction.duration];
    return stepDownAct;
}

/**
 阶梯下降N个格子
 
 @return 动画
 */
-(SKAction *)newStepDownActionWithCount:(NSInteger)count {
    SKAction *stepDownAct = [SKAction moveByX:0 y:-self.eachHeight*count duration:self.jumperAction.duration];
    return stepDownAct;
}

#pragma mark -- jumper的动画
/**
 jumper的动画

 @return 动画
 */
-(SKAction *)newJumperAction{
    SKAction *duang = [self ActionJumperDuangWithSize:1.4];
    duang.timingMode = SKActionTimingEaseOut;
    if ([UserDefaultManager isSoundEffectClose]) {
        return duang;
    }else{
        return [SKAction group:[NSArray arrayWithObjects:duang,[self newJumpSoundEffectAction],nil]];
    }
}
/**
 跳动时的duangduang动画
 
 @return duang动画
 */
-(SKAction *)ActionJumperDuangWithSize:(CGFloat) size{
    SKAction *zoom1 = [SKAction scaleXTo:1.0 y:1.0*size duration:0.03];
    SKAction *zoom2 = [SKAction scaleXTo:1.3 y:1.0*size duration:0.03*size];
    SKAction *zoom3 = [SKAction scaleXTo:1.0 y:1.0*size duration:0.03*size];
    SKAction *zoom4 = [SKAction scaleXTo:1.0 y:1.0 duration:0.03];
    SKAction *ac = [SKAction sequence:[NSArray arrayWithObjects:zoom1,zoom2,zoom3,zoom4,nil]];
    
    return ac;
}
/**
 jumper跌落死亡的综合动画
 
 @return 动画
 */
-(SKAction *)newJumperDiedWithEffectAction{
    __weak typeof(self) wkSelf = self;
    SKAction *pauseBgm = [SKAction runBlock:^{
        [wkSelf.bgmPlayer pause];
    }];
    
    SKAction *loseAct = [self newRotateScaleAction];
    if (![UserDefaultManager isSoundEffectClose]) {
        loseAct = [SKAction group:[NSArray arrayWithObjects:[wkSelf newRotateScaleAction],[wkSelf newLoseSoundEffectAction],nil]];
    }
    SKAction *completion = [SKAction runBlock:^{
        SKNode *product = [wkSelf.jumper childNodeWithName:@"Protect"];
        if (product) {//有保护罩
            if (!self.shouldGuide) {//引导的时候不复活，由引导程序适时复活
                [wkSelf reLiveJumper];
                [product removeFromParent];
            }
            
        }else{
            if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                [wkSelf alertReLiveOrDie];
            }else{
                [wkSelf changeToResultSceneWithWon:NO];
            }
        }
    }];
    SKAction *rmv = [SKAction removeFromParent];
    SKAction *sq = [SKAction sequence:[NSArray arrayWithObjects:pauseBgm,loseAct,rmv,completion,nil]];
    return sq;
}


#pragma mark -- 特效动画
/**
 sliper的动画
 
 @return 动画
 */
-(SKAction *)newSlipPropAction{
    SKAction *sc1 = [SKAction scaleXTo:0.3 y:1 duration:0.1];
    SKAction *rt1 = [SKAction rotateToAngle:1.57 duration:0.1];
    
    SKAction *mv1 = [SKAction moveByX:20 y:0 duration:0.1];
    SKAction *fa = [SKAction fadeInWithDuration:0.1];
    SKAction *gr1 = [SKAction group:[NSArray arrayWithObjects:mv1,fa,nil]];
    
    SKAction *rm = [SKAction removeFromParent];
    SKAction *sq = [SKAction sequence:[NSArray arrayWithObjects:sc1,rt1,gr1,rm,nil]];
    return sq;
}

/**
 踩到炸弹的动画
 
 @return 动画
 */
-(SKAction *)newBoomAction{
    SKTextureAtlas *iOSTextureAtlas = [SKTextureAtlas atlasNamed:@"boom"];
    
    NSMutableArray *allTextureArray = [NSMutableArray arrayWithCapacity:16];
    
    for (int i = 0; i < iOSTextureAtlas.textureNames.count; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"image%d.png",i*2+20];
        
        SKTexture *texture = [iOSTextureAtlas textureNamed:textureName];
        
        [allTextureArray addObject:texture];
        
    }
    //爆炸效果动画
    SKAction *animationAction = [SKAction animateWithTextures:allTextureArray timePerFrame:0.04];
    
    return animationAction;
}


-(SKAction *)newJumperProtectAction{
    
    SKTextureAtlas *iOSTextureAtlas = [SKTextureAtlas atlasNamed:@"boom"];
    
    NSMutableArray *allTextureArray = [NSMutableArray arrayWithCapacity:16];
    
    for (int i = 0; i < iOSTextureAtlas.textureNames.count; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"image%d.png",i*2+20];
        
        SKTexture *texture = [iOSTextureAtlas textureNamed:textureName];
        
        [allTextureArray addObject:texture];
        
    }
    //爆炸效果动画
    SKAction *animationAction = [SKAction animateWithTextures:allTextureArray timePerFrame:0.04];
    SKAction *repeatAc = [SKAction repeatActionForever:animationAction];
    return repeatAc;
}

-(SKAction *)newGoldPropsAction{
    SKTextureAtlas *iOSTextureAtlas = [SKTextureAtlas atlasNamed:@"goldProps"];
    
    NSMutableArray *allTextureArray = [NSMutableArray arrayWithCapacity:16];
    
    for (int i = 0; i < iOSTextureAtlas.textureNames.count; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"$%d.png",i+1];
        
        SKTexture *texture = [iOSTextureAtlas textureNamed:textureName];
        
        [allTextureArray addObject:texture];
    }
    //金币转动动画
    SKAction *animationAction = [SKAction animateWithTextures:allTextureArray timePerFrame:0.04];
    SKAction *repeatAc = [SKAction repeatActionForever:animationAction];
    return repeatAc;
}


@end
