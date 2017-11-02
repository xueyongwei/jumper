//
//  LocalNotificationManager.h
//  Jump
//
//  Created by xueyognwei on 2017/7/24.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject
+(instancetype)defaultManager;
-(void)setupManager;
-(void)sendLocalNotificationAfter:(NSInteger)minutes;
@end
