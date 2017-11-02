//
//  XYWVersonManager.h
//  downloader
//
//  Created by xueyognwei on 2017/5/2.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XYWVersonManagerLunchType) {//道具类型
    XYWVersonManagerLunchTypeNormal=0,
    XYWVersonManagerLunchTypeFirstLuchThisVersion,
    XYWVersonManagerLunchTypeFirstLuchAfterInstall,
};
@interface XYWVersonManager : NSObject
@property (nonatomic,assign) CGFloat lastVersion;
@property (nonatomic,assign) CGFloat currentVersion;
@property (nonatomic,assign) XYWVersonManagerLunchType lunchType;
+(instancetype)shareManager;
-(void)setUpManager;
@end
