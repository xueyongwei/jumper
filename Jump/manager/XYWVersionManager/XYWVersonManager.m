//
//  XYWVersonManager.m
//  downloader
//
//  Created by xueyognwei on 2017/5/2.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "XYWVersonManager.h"

@implementation XYWVersonManager
+(instancetype)shareManager
{
    static XYWVersonManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
-(void)setUpManager{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    CGFloat lastVersionInter = [usf floatForKey:@"lastAppVersionIntegerValue"];
    //取本次启动时app的版本
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSRange dotrange = [version rangeOfString:@"."];
    NSString *bigVersion = [version substringToIndex:dotrange.location];
    NSString *smallVersion = [version substringFromIndex:dotrange.location+dotrange.length];
    CGFloat currentVersion = bigVersion.integerValue*100+smallVersion.floatValue;
    self.currentVersion = currentVersion;
    [usf setFloat:currentVersion forKey:@"lastAppVersionIntegerValue"];
    [usf synchronize];
    if (lastVersionInter>0) {//已有版本记录，启动过
        self.lastVersion = lastVersionInter;
        if (currentVersion != lastVersionInter) {//版本不同
            self.lunchType = XYWVersonManagerLunchTypeFirstLuchThisVersion;
        }else{
            self.lunchType = XYWVersonManagerLunchTypeNormal;
        }
    }else{//没有记录，安装后第一次启动
        self.lastVersion = currentVersion;
        self.lunchType = XYWVersonManagerLunchTypeFirstLuchAfterInstall;
    }
}
//+(CGFloat)lastVersionInter{
//    CGFloat lastVersionInter = [[NSUserDefaults standardUserDefaults] floatForKey:@"currentAppVersionIntegerValue"];
//    if (lastVersionInter&&lastVersionInter>0) {
//        DDLogVerbose(@"lastVersionInter = %lf",lastVersionInter);
//        return lastVersionInter;
//    }else{
//        DDLogVerbose(@"first lanch after install");
//        return 0;
//    }
//}
//+(BOOL)firstLanchOnlyThisVersion:(BOOL)onlyThisVersion{
//    if (onlyThisVersion) {
//        return [self currentVersionInter] == [self lastVersionInter]?NO:YES;
//    }else{
//        return [self lastVersionInter]==0?YES:NO;
//    }
//}
//+(CGFloat)currentVersionInter{
//    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSRange dotrange = [version rangeOfString:@"."];
//    NSString *bigVersion = [version substringToIndex:dotrange.location];
//    NSString *smallVersion = [version substringFromIndex:dotrange.location+dotrange.length];
//    
//    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
//    CGFloat currentVersion = bigVersion.integerValue*100+smallVersion.floatValue;
//    [usf setFloat:currentVersion forKey:@"currentAppVersionIntegerValue"];
//    return currentVersion;
//}

@end
