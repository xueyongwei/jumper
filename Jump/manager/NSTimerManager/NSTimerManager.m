//
//  NSTimerManager.m
//  Jump
//
//  Created by xueyognwei on 2017/7/24.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "NSTimerManager.h"

@implementation NSTimerManager
+(void)fire
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [timer fire];
    });
}
+(void)timerFired{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobleTimerNoti object:nil];
}
@end
