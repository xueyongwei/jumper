//
//  SKPropNode.m
//  Jump
//
//  Created by xueyognwei on 2017/7/5.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKPropNode.h"

@implementation SKPropNode

/**
 创建一个某种类型的道具node

 @param style 类型
 @param step 道具node
 @return 目标板子
 */
+(SKPropNode *)propWithStyle:(PropStyle)style onStep:(SKStepNode *)step{
    NSString *imgName = [self imageNameOfStyle:style];
    if (imgName) {
        SKPropNode *node = [SKPropNode spriteNodeWithImageNamed:imgName];
        node.style = style;
        [self customPropNode:node withStyle:style onStep:step];
        return node;
    }
    return nil;
}


/**
 定制这个道具

 @param propNode 道具
 @param style 类型
 @param step 板子上
 */
+(void)customPropNode:(SKPropNode *)propNode withStyle:(PropStyle)style onStep:(SKStepNode *)step{
    DDLogVerbose(@"style = %ld",(long)style);
    
//    [step addChild:propNode];
//    step.propNode = propNode;
    if (style == PropStyleScoreSlide) {//滑倒
        
    }else if (style == PropStyleScoreMoveToHit){//移动的怪兽
        CGFloat width = YYScreenSize().width*0.3;
        DDLogVerbose(@"width = %f ",width);
        
        SKAction *act1 = [SKAction moveToX:width duration:step.stayDuration+0.25];
        SKAction *act2 = [SKAction moveToX:-width duration:step.stayDuration+0.25];
        SKAction *ac = [SKAction repeatActionForever:[SKAction sequence:@[act1,act2]]];
        
//        SKAction * ac =[MyCommonActions monstersMoveAroundAction];
//        ac.duration = step.stayDuration*2+0.5;
        [propNode runAction:ac];
    }else if (style == PropStyleScoreAddGod){//金币
        SKAction *goldAc = [propNode newGoldPropsAction];
        [propNode runAction:goldAc];
    }else{
       
    }
}

/**
 获取某种类型的图片名

 @param style 类型
 @return 图片名
 */
+(NSString *)imageNameOfStyle:(PropStyle)style{
    if (style == PropStyleScoreAddGod) {
        return @"goldCoin1";
    }else if (style == PropStyleScoreSlide){
        return @"propSlide";
    }else if (style == PropStyleScoreMoveToHit){
        return @"propMonster";
    }else{
        return nil;
    }
}

-(SKAction *)newGoldPropsAction{
    SKTextureAtlas *iOSTextureAtlas = [SKTextureAtlas atlasNamed:@"goldProps"];
    
    NSMutableArray *allTextureArray = [NSMutableArray arrayWithCapacity:16];
    
    for (int i = 0; i < iOSTextureAtlas.textureNames.count; i++) {
        
        NSString *textureName = [NSString stringWithFormat:@"goldCoin%d.png",i+1];
        
        SKTexture *texture = [iOSTextureAtlas textureNamed:textureName];
        
        [allTextureArray addObject:texture];
    }
    //金币转动动画
    SKAction *animationAction = [SKAction animateWithTextures:allTextureArray timePerFrame:0.06];
    
    SKAction *repeatAc = [SKAction repeatActionForever:animationAction];
    return repeatAc;
}
@end
