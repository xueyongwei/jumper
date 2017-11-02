//
//  CustomActivity.h
//  Jump
//
//  Created by xueyognwei on 2017/7/31.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActivity : UIActivity
@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) NSArray * shareContexts;

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type  withShareContext:(NSArray *)shareContexts;
@end
