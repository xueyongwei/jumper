//
//  RewardVideoManager.m
//  Jump
//
//  Created by xueyognwei on 2017/10/9.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "RewardVideoManager.h"
#import "GameViewController.h"
@interface RewardVideoManager ()
@property (nonatomic,copy) void(^finishBlock)(UnityAdsFinishState state);
@property (nonatomic,copy) void(^errorBlock)(NSString *message);
@end

@implementation RewardVideoManager
+(instancetype)defaultManager
{
    static RewardVideoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RewardVideoManager alloc]init];
    });
    return manager;
}
-(void)setUpManager{
    [UnityAds initialize:@"1523110" delegate:self];
    
}
-(void)showRewardVideoInViewController:(UIViewController *)viewController Finished:(void(^)(UnityAdsFinishState state))finishBlock error:(void(^)(NSString *message))errorBlock{
    self.errorBlock = errorBlock;
    self.finishBlock = finishBlock;
    if ([UnityAds isReady:@"rewardedVideo"]) {
        [CoreSVP dismiss];
        [UnityAds show:viewController placementId:@"rewardedVideo"];
    }else{
        [CoreSVP dismiss];
        errorBlock(@"Not ready,Wait a jiff.");
    }
}
-(void)showRewardVideoInViewController:(UIViewController *)viewController canSkip:(BOOL)canSkip Finished:(void(^)(UnityAdsFinishState state))finishBlock error:(void(^)(NSString *message))errorBlock;
{
    self.errorBlock = errorBlock;
    self.finishBlock = finishBlock;
    NSString *placementId = canSkip?@"video":@"rewardedVideo";
    if ([UnityAds isReady:@"rewardedVideo"]) {
        [CoreSVP dismiss];
        [UnityAds show:viewController placementId:placementId];
    }else{
        [CoreSVP dismiss];
        errorBlock(@"Not ready,Wait a jiff.");
    }
}
#pragma mark -- unity ADS delegate
- (void)unityAdsReady:(NSString *)placementId{
    DDLogVerbose(@"unityAdsReady:%@",placementId);
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    DDLogError(@"unityAdsDidError :%@",message);
    if (self.errorBlock) {
        self.errorBlock(message);
    }
}

- (void)unityAdsDidStart:(NSString *)placementId{
    DDLogVerbose(@"unityAdsDidStart:%@",placementId);
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    DDLogVerbose(@"unityAdsDidFinish");
    if (self.finishBlock) {
        self.finishBlock(state);
    }
    
}
@end
