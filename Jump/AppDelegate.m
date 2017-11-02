//
//  AppDelegate.m
//  Jump
//
//  Created by xueyognwei on 2017/6/28.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "AppDelegate.h"
#import <Google/Analytics.h>
#import <AFNetworking.h>

#import "GameCenterManager.h"
#import "XYWLogerManager.h"
#import "XYWVersonManager.h"
#import "XYWDDLogFormatter.h"

#import <InMobiSDK/InMobiSDK.h>

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <FirebaseCore/FirebaseCore.h>
#import <UserNotifications/UserNotifications.h>
#import "WealthManager.h"
#import "NSTimerManager.h"
#import "UserDefaultManager.h"
#import "GADMAdapterInMobi.h"
#import "JumperRoleManager.h"
#import "RewardVideoManager.h"
@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //处理角色
    [[JumperRoleManager shareManager] setupManager];
    [self defauleConfigInBackground];
    [self defaultConfigInMainThread];
    // Override point for customization after application launch.
    return YES;
}
-(id)init
{
    if (self = [super init]) {
        // Initialize Google FireBase
        [FIRApp configure];
        
        // Initialize Google Mobile Ads SDK
        [GADMobileAds configureWithApplicationID:@"ca-app-pub-5418531632506073~4131657149"];
        //初始化inmobi
        
        [IMSdk initWithAccountID:@"450e020617004cd9ae73bb1f01fe1b7b"];
        [IMSdk setAgeGroup:kIMSDKAgeGroupBetween18And24];
        [IMSdk setGender:kIMSDKGenderFemale];
        [IMSdk setLogLevel:kIMSDKLogLevelDebug];
    }
    return self;
}

/**
 主线程处理
 */
-(void)defaultConfigInMainThread{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //注册推送
        [self registerLocalNotification];
        [NSTimerManager fire];
        //奖励视频
        [[RewardVideoManager defaultManager] setUpManager];
//        [GADMobileAds configureWithApplicationID:@"ca-app-pub-5418531632506073~4131657149"];
        
        
        
//        [FIRApp configure];
//        [FBAdSettings setLogLevel:FBAdLogLevelError];
//        [FBAdSettings addTestDevices:@[@"5e2e43d671ccaf6b0c8d9e081844f5d6298dc39d",
//                                       @"2c4dd9c3de47ee216314b05301e4ba1247cf7b9a",
//                                       @"b602d594afd2b0b327e07a06f36ca6a7e42546d0"]];
//        
//        NSError *configureError;
//        [[GGLContext sharedInstance] configureWithError:&configureError];
//        NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//        
//        // Optional: configure GAI options.
//        GAI *gai = [GAI sharedInstance];
//        gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//        gai.logger.logLevel = kGAILogLevelError;  // remove before app release
//        
        
    });
}

/**
 后台线程处理
 */
-(void)defauleConfigInBackground{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //初始化日志系统
        [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
        //    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
        
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:fileLogger];
        XYWDDLogFormatter *formatter = [[XYWDDLogFormatter alloc] init];
        [DDTTYLogger sharedInstance].logFormatter = formatter;
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);//ddlog抓取崩溃日志
        
        [UserDefaultManager setUp];
        
        
        //初始化版本管理
        [[XYWVersonManager shareManager] setUpManager];
        //初始化游戏中心
        [[GameCenterManager sharedManager] setupManager];
        //初始化日志系统
        [XYWLogerManager setUpLoger];
        //开始监控网络
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        //初始化账户
        [[WealthManager defaultManager] setupManager];
        
//        [self unzipJumperRolesIfNotExist];
    });
}

-(void)launchEdWithNewVerison:(NSInteger)version{
    
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
    center.delegate = self;
    
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
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
            }];
        } else {
            //用户点击不允许
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
//// (iOS9及之前)本地通知回调函数，当应用程序在前台时调用
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    NSLog(@"%@", notification.userInfo);
//    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
//    badge -= notification.applicationIconBadgeNumber;
//    badge = badge >= 0 ? badge : 0;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
