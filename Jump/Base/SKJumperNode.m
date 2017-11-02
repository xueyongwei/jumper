//
//  SKJumperNode.m
//  Jump
//
//  Created by xueyognwei on 2017/7/3.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKJumperNode.h"

@implementation SKJumperNode

-(void)setReLive:(BOOL)reLive
{
    _reLive = reLive;
    if (reLive) {
        SKAction *action1 = [SKAction fadeAlphaTo:0.3 duration:0.2];
        SKAction *action2 = [SKAction fadeAlphaTo:0.6 duration:0.2];
        SKAction *g = [SKAction sequence:@[action1,action2]];
        SKAction *r = [SKAction repeatActionForever:g];
        [self runAction:r withKey:@"reLive"];
    }else{
        [self removeActionForKey:@"reLive"];
        self.alpha = 1.0;
    }
}

@end
