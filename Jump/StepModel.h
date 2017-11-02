//
//  StepTypeModel.h
//  Jump
//
//  Created by xueyognwei on 2017/6/28.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, StepModelStyle) {
    StepModelStyleNormal,
    StepModelStyleHole,
};
@interface StepModel : NSObject
@property (nonatomic,assign) StepModelStyle style;
@end
