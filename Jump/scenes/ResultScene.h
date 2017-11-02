//
//  ResultScene.h
//  testGame
//
//  Created by xueyognwei on 2017/6/26.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SKBaseScene.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface ResultScene : SKBaseScene <GADRewardBasedVideoAdDelegate>

//-(instancetype)initWithSize:(CGSize)size won:(BOOL)won source:(NSInteger)source;
-(instancetype)initWithSize:(CGSize)size won:(BOOL)won source:(NSInteger)source goldIcon:(NSInteger)goldIcons bgColorsImage:(UIImage *)bgColorsImage;
@end
