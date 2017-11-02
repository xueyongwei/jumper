//
//  JumperRoleManager.h
//  Jump
//
//  Created by xueyognwei on 2017/9/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JumperRoleModel.h"
//@class JumperRoleModel;
@interface JumperRoleManager : NSObject

/**
 所有的角色
 */
@property (nonatomic,strong) NSMutableArray <NSDictionary *> *alllJumpers;

/**
 当前使用的角色模型
 */
@property (nonatomic,strong) JumperRoleModel *curntJumperRoleModel;


/**
 单例

 @return 这个管理器
 */
+(instancetype)shareManager;


/**
 初始化
 */
-(void)setupManager;


///**
// 当前使用的角色模型
//
// @return 角色模型
// */
//-(JumperRoleModel *)currentJumperRoleModel;


/**
 更新jumper角色属性,比如改过昵称，及解锁等，调用更新本地数据
 
 @param jumper jumper
 */
-(void)updaJumper:(JumperRoleModel *)jumper;

-(void)updateCurntRoleModel:(JumperRoleModel *)jumper;
@end
