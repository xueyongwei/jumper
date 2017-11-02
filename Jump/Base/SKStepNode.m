//
//  SKStepNode.m
//  Jump
//
//  Created by xueyognwei on 2017/6/30.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKStepNode.h"

@implementation SKStepNode
-(NSString*)description
{
    NSString *str = [super description];
    return [NSString stringWithFormat:@"%@ hole:%d prop:%@",str,_isHole,_propNode];
}
@end
