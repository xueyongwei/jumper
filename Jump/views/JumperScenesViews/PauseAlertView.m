//
//  PauseAlertView.m
//  Jump
//
//  Created by xueyognwei on 2017/7/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "PauseAlertView.h"
//#import <GoogleMobileAds/GoogleMobileAds.h>
@implementation PauseAlertView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.alertBody.alpha = 0;
    self.alpha = 0;
    self.alertBody.layer.cornerRadius = 8;
    self.alertBody.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPlacehoderAD:)];
    [self.placeHolderApp addGestureRecognizer:tap];
//    [self loadAd];
    
    self.goOnBtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:18];
    self.goHomeBtn.titleLabel.font =[UIFont fontWithName:@"changchengteyuanti" size:18];
//    self.closeBtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:18];
}


/**
 加载谷歌原生广告
 */
-(void)loadAd{
    
    // Loads an ad for any of app install, content, or custom native ads.
    NSMutableArray *adTypes = [[NSMutableArray alloc] init];
    [adTypes addObject:kGADAdLoaderAdTypeNativeAppInstall];
    [adTypes addObject:kGADAdLoaderAdTypeNativeContent];
//    [adTypes addObject:kGADAdLoaderAdTypeNativeContent];
    
    
    if (adTypes.count == 0) {
        NSLog(@"At least one ad format must be selected to refresh the ad.");
    } else {
        
        GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
        videoOptions.startMuted = YES;
        
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-5418531632506073/6040539143"
                                           rootViewController:self.viewController
                                                      adTypes:adTypes
                                                      options:@[ videoOptions ]];
        self.adLoader.delegate = self;
        GADRequest *request = [GADRequest request];
//        request.testDevices = @[ @"1a0d2fc39522a82f72bfc130b3f788ba" ];
        [self.adLoader loadRequest:request];
        
    }
}

-(void)didMoveToSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self showAD];
    }];
}
-(void)showAD{
    
}
-(void)animateShow{
    self.alertBody.transform = CGAffineTransformMakeScale(0.5, 0.6);
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:1 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertBody.alpha = 1;
        self.alertBody.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    
}
- (IBAction)onClose:(UIButton *)sender {
    __weak typeof(self) wkSelf = self;
    [self animateDissmissFinishBlock:^{
        if (wkSelf.closeBlock) {
            wkSelf.closeBlock();
        }
    }];
}
- (IBAction)GoOnGameClick:(UIButton *)sender {
    __weak typeof(self) wkSelf = self;
    [self animateDissmissFinishBlock:^{
        if (wkSelf.GoOnBlock) {
            wkSelf.GoOnBlock();
        }
    }];
}
- (IBAction)ReStartClick:(UIButton *)sender {
    __weak typeof(self) wkSelf = self;
    [self animateDissmissFinishBlock:^{
        if (wkSelf.ReStartBlock) {
            wkSelf.ReStartBlock();
        }
    }];
}
- (IBAction)GoHomeClick:(UIButton *)sender {
    __weak typeof(self) wkSelf = self;
    [self animateDissmissFinishBlock:^{
        if (wkSelf.GoHomeBlock) {
            wkSelf.GoHomeBlock();
        }
    }];
}

- (void)tapPlacehoderAD:(UITapGestureRecognizer *)sender {
    NSURL *appUrl = [NSURL URLWithString:@"https://itunes.apple.com/app/1107496640"];
    if ([[UIApplication sharedApplication]canOpenURL:appUrl]) {
        [[UIApplication sharedApplication]openURL:appUrl];
    }
}



/**
 以动画隐藏
 */
-(void)animateDissmissFinishBlock:(void(^)(void))finishBlock{
    [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertBody.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alertBody.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.alertBody.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self removeFromSuperview];
                            
                            finishBlock();
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)setAdView:(UIView *)view {
    // Remove previous ad view.
    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = view;
    
    // Add new ad view and set constraints to fill its container.
    [self.nativeAdPlaceholder addSubview:view];
    [self.nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
    [self.nativeAdPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.nativeAdPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}


#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
    
}

#pragma mark GADNativeAppInstallAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    NSLog(@"Received native app install ad: %@", nativeAppInstallAd);
    GADNativeAppInstallAdView *appInstallAdView =
    [[NSBundle mainBundle] loadNibNamed:@"NativeAppInstallAdView" owner:nil options:nil]
    .firstObject;
    [self setAdView:appInstallAdView];
    
    // Associate the app install ad view with the app install ad object. This is required to make the
    // ad clickable.
    appInstallAdView.nativeAppInstallAd = nativeAppInstallAd;
    
    // Populate the app install ad view with the app install ad assets.
    // Some assets are guaranteed to be present in every app install ad.
    ((UILabel *)appInstallAdView.headlineView).text = nativeAppInstallAd.headline;
    ((UIImageView *)appInstallAdView.iconView).image = nativeAppInstallAd.icon.image;
    ((UILabel *)appInstallAdView.bodyView).text = nativeAppInstallAd.body;
    [((UIButton *)appInstallAdView.callToActionView)setTitle:nativeAppInstallAd.callToAction
                                                    forState:UIControlStateNormal];
    
    // Some app install ads will include a video asset, while others do not. Apps can use the
    // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
    // UI accordingly.
    if (nativeAppInstallAd.videoController.hasVideoContent) {
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the video it displays.
        NSLayoutConstraint *heightConstraint =
        [NSLayoutConstraint constraintWithItem:appInstallAdView.mediaView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:appInstallAdView.mediaView
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:(1 / nativeAppInstallAd.videoController.aspectRatio)
                                      constant:0];
        heightConstraint.active = YES;
        
        // By acting as the delegate to the GADVideoController, this ViewController receives messages
        // about events in the video lifecycle.
        nativeAppInstallAd.videoController.delegate = self;
        
    } else {
        // If the ad doesn't contain a video asset, the GADMediaView will automatically display the
        // first image asset instead, so a fixed value of 150 is used for the height constraint.
//        NSLayoutConstraint *heightConstraint =
//        [NSLayoutConstraint constraintWithItem:appInstallAdView.mediaView
//                                     attribute:NSLayoutAttributeHeight
//                                     relatedBy:NSLayoutRelationEqual
//                                        toItem:nil
//                                     attribute:NSLayoutAttributeNotAnAttribute
//                                    multiplier:0
//                                      constant:150];
//        heightConstraint.active = YES;
        
    }
    
    // These assets are not guaranteed to be present, and should be checked first.
    if (nativeAppInstallAd.starRating) {
        ((UIImageView *)appInstallAdView.starRatingView).image =
        [self imageForStars:nativeAppInstallAd.starRating];
        appInstallAdView.starRatingView.hidden = NO;
    } else {
        appInstallAdView.starRatingView.hidden = YES;
    }
    
    if (nativeAppInstallAd.store) {
        ((UILabel *)appInstallAdView.storeView).text = nativeAppInstallAd.store;
        appInstallAdView.storeView.hidden = NO;
    } else {
        appInstallAdView.storeView.hidden = YES;
    }
    
    if (nativeAppInstallAd.price) {
        ((UILabel *)appInstallAdView.priceView).text = nativeAppInstallAd.price;
        appInstallAdView.priceView.hidden = NO;
    } else {
        appInstallAdView.priceView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    appInstallAdView.callToActionView.userInteractionEnabled = NO;
}

/// Gets an image representing the number of stars. Returns nil if rating is less than 3.5 stars.
- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
    double starRating = numberOfStars.doubleValue;
    if (starRating >= 5) {
        return [UIImage imageNamed:@"stars_5"];
    } else if (starRating >= 4.5) {
        return [UIImage imageNamed:@"stars_4_5"];
    } else if (starRating >= 4) {
        return [UIImage imageNamed:@"stars_4"];
    } else if (starRating >= 3.5) {
        return [UIImage imageNamed:@"stars_3_5"];
    } else {
        return nil;
    }
}

#pragma mark GADNativeContentAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    NSLog(@"Received native content ad: %@", nativeContentAd);
    
    // Create and place ad in view hierarchy.
    GADNativeContentAdView *contentAdView =
    [[NSBundle mainBundle] loadNibNamed:@"NativeContentAdView" owner:nil options:nil].firstObject;
    [self setAdView:contentAdView];
    
    // Associate the content ad view with the content ad object. This is required to make the ad
    // clickable.
    contentAdView.nativeContentAd = nativeContentAd;
    
    // Populate the content ad view with the content ad assets.
    // Some assets are guaranteed to be present in every content ad.
    ((UILabel *)contentAdView.headlineView).text = nativeContentAd.headline;
    ((UILabel *)contentAdView.bodyView).text = nativeContentAd.body;
    ((UIImageView *)contentAdView.imageView).image =
    ((GADNativeAdImage *)nativeContentAd.images.firstObject).image;
    ((UILabel *)contentAdView.advertiserView).text = nativeContentAd.advertiser;
    [((UIButton *)contentAdView.callToActionView)setTitle:nativeContentAd.callToAction
                                                 forState:UIControlStateNormal];
    
    // Other assets are not, however, and should be checked first.
    if (nativeContentAd.logo && nativeContentAd.logo.image) {
        ((UIImageView *)contentAdView.logoView).image = nativeContentAd.logo.image;
        contentAdView.logoView.hidden = NO;
    } else {
        contentAdView.logoView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    contentAdView.callToActionView.userInteractionEnabled = NO;
}

#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    
}


@end
