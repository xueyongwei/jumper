//
//  LocalNotificationManager.m
//  Jump
//
//  Created by xueyognwei on 2017/7/24.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "LocalNotificationManager.h"
#import <UserNotifications/UserNotifications.h>

#define kLocalNotificationKey @"kLocalNotificationKey"

@implementation LocalNotificationManager
+(instancetype)defaultManager
{
    static LocalNotificationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

-(void)setupManager
{
    [self registerLocalNotification];
}

-(void)sendLocalNotificationAfter:(NSInteger)minutes{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [self sendiOS10LocalNotificationAfter:minutes];
    } else {
        [self sendiOS8LocalNotificationAfter:minutes];
    }
}

- (void)sendiOS10LocalNotificationAfter:(NSInteger)minutes
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    content.title = nil;
//    content.subtitle = @"SubTitle:三三";
    
    content.body = NSLocalizedString(@"Come and get free diamonds! Challenge high scores in Hop Jump's colorful world!", nil);
    content.badge = @(1);
//    content.categoryIdentifier = kNotificationCategoryIdentifile;
    content.userInfo = @{kLocalNotificationKey: @"iOS10推送"};
//    content.launchImageName = @"呆毛";
//    //推送附件
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"mp4"];
//    NSError *error = nil;
//    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"AttachmentIdentifile" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
//    content.attachments = @[attachment];
    
    //推送类型
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:minutes*60 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"jumperReward" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"iOS 10 发送推送， error：%@", error);
    }];
}

- (void)sendiOS8LocalNotificationAfter:(NSInteger)minutes
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //触发通知时间
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:minutes*60];
    //重复间隔
    //    localNotification.repeatInterval = kCFCalendarUnitMinute;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //通知内容
    localNotification.alertBody = NSLocalizedString(@"Come and get free diamonds! Challenge high scores in Hop Jump's colorful world!", nil);
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //通知参数
    localNotification.userInfo = @{kLocalNotificationKey: @"iOS8推送"};
    
//    localNotification.category = kNotificationCategoryIdentifile;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}




- (void)registerLocalNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [self registeriOS10LocalNotification];
    } else {
        [self registeriOS8LocalNotification];
    }
}

- (void)registeriOS10LocalNotification
{
    //iOS10特有
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // 必须写代理，不然无法监听通知的接收与点击
//    center.delegate = self;
    
    /**
     UNNotificationActionOptionAuthenticationRequired: 锁屏时需要解锁才能触发事件，触发后不会直接进入应用
     UNNotificationActionOptionDestructive：字体会显示为红色，且锁屏时触发该事件不需要解锁，触发后不会直接进入应用
     UNNotificationActionOptionForeground：锁屏时需要解锁才能触发事件，触发后会直接进入应用界面
     */
    //    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:kNotificationActionIdentifileStar title:@"赞" options:UNNotificationActionOptionAuthenticationRequired];
    //    UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:kNotificationActionIdentifileComment title:@"评论一下吧" options:UNNotificationActionOptionForeground textInputButtonTitle:@"评论" textInputPlaceholder:@"请输入评论"];
    //    UNNotificationCategory *catetory = [UNNotificationCategory categoryWithIdentifier:kNotificationCategoryIdentifile actions:@[action1, action2] intentIdentifiers:@[kNotificationActionIdentifileStar, kNotificationActionIdentifileComment] options:UNNotificationCategoryOptionNone];
    
    //    [center setNotificationCategories:[NSSet setWithObject:catetory]];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //用户点击允许
            NSLog(@"注册成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
            }];
        } else {
            //用户点击不允许
            NSLog(@"注册失败");
        }
    }];
}

- (void)registeriOS8LocalNotification
{
    //创建消息上面要添加的动作（iOS9才支持）
//    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    //    action1.identifier = kNotificationActionIdentifileStar;
    //    action1.title = @"赞";
    //    //当点击的时候不启动程序，在后台处理
    //    action1.activationMode = UIUserNotificationActivationModeBackground;
    //    //需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了赞不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    //    action1.authenticationRequired = YES;
    /*
     destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
     如果两个按钮均设置为YES，则均为红色（略难看）
     如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
     如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。
     */
    //    action1.destructive = NO;
    
    //第二个动作
    //    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    //    action2.identifier = kNotificationActionIdentifileComment;
    //    action2.title = @"评论";
    //    //当点击的时候不启动程序，在后台处理
    //    action2.activationMode = UIUserNotificationActivationModeBackground;
    //    //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入
    //    action2.behavior = UIUserNotificationActionBehaviorTextInput;
    //    //这个字典定义了当用户点击了评论按钮后，输入框右侧的按钮名称，如果不设置该字典，则右侧按钮名称默认为 “发送”
    //    action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"评论"};
    //
    //    //创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    //    //这组动作的唯一标示
    //    category.identifier = kNotificationCategoryIdentifile;
    //    //最多支持两个，如果添加更多的话，后面的将被忽略
    //    [category setActions:@[action1, action2] forContext:(UIUserNotificationActionContextMinimal)];
    //创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObject:category]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}
@end
