//
//  PauseAlertView.h
//  Jump
//
//  Created by xueyognwei on 2017/7/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface PauseAlertView : UIView <GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate,
GADVideoControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *alertBody;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *goOnBtn;
@property (weak, nonatomic) IBOutlet UIView *nativeAdPlaceholder;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderApp;

@property(nonatomic, strong) UIView *nativeAdView;
@property (weak, nonatomic) IBOutlet UIButton *reStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *goHomeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic,strong) void(^closeBlock)(void);
@property (nonatomic,strong) void(^GoOnBlock)(void);
@property (nonatomic,strong) void(^ReStartBlock)(void);
@property (nonatomic,strong) void(^GoHomeBlock)(void);

-(void)loadAd;
-(void)animateShow;
@end
