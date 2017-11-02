//
//  GameRule.m
//  Jump
//
//  Created by xueyognwei on 2017/7/19.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GameRule.h"

#pragma mark -- GameRule
@implementation GameRule
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"props" : [RuleProp class],
            };
}

-(BOOL)ContainScore:(NSInteger)score{
    if (score>=self.minScore && score<self.maxScore) {
        return YES;
    }
    return NO;
}
@end


#pragma mark -- RuleProp

@implementation RuleProp

-(void)setPropType:(NSString *)propType
{
    _propType = propType;
    if ([propType isEqualToString:@"propMonster"]) {
        _propStyle = PropStyleScoreMoveToHit;
    }else if ([propType isEqualToString:@"propSlip"]){
        _propStyle = PropStyleScoreSlide;
    }else if ([propType isEqualToString:@"propCoin"]){
        _propStyle = PropStyleScoreAddGod;
    }
}
@end
