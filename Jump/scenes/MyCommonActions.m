//
//  MyCommonActions.m
//  Jump
//
//  Created by xueyognwei on 2017/9/13.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "MyCommonActions.h"

@implementation MyCommonActions

NSMutableDictionary *actionsMap;

+(SKAction *)monstersMoveAroundAction
{
    static SKAction *ac = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SKAction *act1 = [SKAction moveToX:100 duration:0.25];
        SKAction *act2 = [SKAction moveToX:-100 duration:0.25];
        ac = [SKAction repeatActionForever:[SKAction sequence:@[act1,act2]]];
    });
    return ac;
}

@end
