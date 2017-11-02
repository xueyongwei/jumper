//
//  UserDefaultManager.h
//  Jump
//
//  Created by xueyognwei on 2017/6/29.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultManager : NSObject
+(void)setScore:(NSInteger)score;
+(NSInteger)maxScore;
@end
