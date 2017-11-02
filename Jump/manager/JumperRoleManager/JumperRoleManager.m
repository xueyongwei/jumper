//
//  JumperRoleManager.m
//  Jump
//
//  Created by xueyognwei on 2017/9/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumperRoleManager.h"
#import "HYFileManager.h"
#import "JumperRoleModel.h"

static NSString *const kCurrentJumperRoleDic = @"kuserdefltCurrentJumper";

@interface JumperRoleManager()
@property (nonatomic,copy) NSString *jumperFilePath;
@property (nonatomic,strong) NSMutableDictionary *localDataDic;
@end


@implementation JumperRoleManager

+(instancetype)shareManager
{
    static JumperRoleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JumperRoleManager alloc]init];
        manager.jumperFilePath = [[HYFileManager documentsDir] stringByAppendingPathComponent:@"jumperRoles.plist"];
        DDLogVerbose(@"jumperFilePath:%@",manager.jumperFilePath);
    });
    return manager;
}
-(void)setupManager{
    [self tryToMoveJumperFileToDocDir];
}
/**
 如果角色资源不存在，需要解压资源包
 */
-(void)tryToMoveJumperFileToDocDir{
    //bundle中的路径
    NSString *defaultFilePath = [[NSBundle mainBundle]pathForResource:@"JumperRolesData" ofType:@"plist"];
    if ([HYFileManager isExistsAtPath:self.jumperFilePath]) {//已经移动过了
        DDLogVerbose(@"已经移动过了");

        NSDictionary *bundleJumpers = [NSDictionary dictionaryWithContentsOfFile:defaultFilePath];
        NSInteger bundleVersion = [bundleJumpers integerValueForKey:@"jumperVersion" default:0];
        DDLogVerbose(@"bundleJumpers，%@",bundleJumpers);
        
        NSDictionary *sandboxJumpers = [NSDictionary dictionaryWithContentsOfFile:self.jumperFilePath];
        NSInteger sandboxVersion = [sandboxJumpers integerValueForKey:@"jumperVersion" default:0];
        DDLogVerbose(@"sandboxJumpers，%@",sandboxJumpers);
        if (sandboxVersion < bundleVersion ) {//沙盒中有的已经低于app内的版本，应该更新
            DDLogVerbose(@"沙盒中的已经低于app内的版本，应该更新");
            [self updateSandboxDic:sandboxJumpers withBundleDic:bundleJumpers];
        }
    }else{
        
        DDLogVerbose(@"第一次移动角色资源文件");
        
        BOOL moveSucess = [HYFileManager copyItemAtPath:defaultFilePath toPath:self.jumperFilePath error:nil];
        
        DDLogVerbose(@"movesucess = %d",moveSucess);
        //移动成功需要设置编号为0的角色为默认角色
    }
    NSDictionary *jumpersDic = [NSDictionary dictionaryWithContentsOfFile:self.jumperFilePath];
    self.localDataDic = [NSMutableDictionary dictionaryWithDictionary:jumpersDic];
    self.alllJumpers = [NSMutableArray arrayWithArray:[jumpersDic objectForKey:@"jumpers"]];
    
    
}


/**
 用bundle中的角色信息更新沙盒原有的

 @param sandboxDic 沙盒中的角色信息
 @param bundleDic bundle中的角色信息
 */
-(void)updateSandboxDic:(NSDictionary *)sandboxDic withBundleDic:(NSDictionary *)bundleDic{
    NSArray *sandBoxJumpers = [sandboxDic objectForKey:@"jumpers"];
    NSMutableArray *unlockedIDArray = [[NSMutableArray alloc]init];
    [sandBoxJumpers enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *roleID = [obj objectForKey:@"roleID"];
        BOOL isUnlocked = [obj boolValueForKey:@"isUnlocked" default:NO];
        
        if (isUnlocked) {
            DDLogVerbose(@"这个角色已经解锁");
            [unlockedIDArray addObject:roleID];
        }
    }];
    
    NSArray *bundleBoxJumpers = [bundleDic objectForKey:@"jumpers"];
    NSMutableArray *muBundleBoxJumpers = [[NSMutableArray alloc]init];
    
    [bundleBoxJumpers enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建可变字典
        NSMutableDictionary *muObj = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        //如果已经解锁过了，恢复解锁状态
        NSNumber *roleID = [muObj objectForKey:@"roleID"];
        if ([unlockedIDArray containsObject:roleID]) {
            DDLogVerbose(@"恢复这个角色的解锁状态");
            [muObj setValue:[NSNumber numberWithBool:YES] forKey:@"isUnlocked"];
        }
        
        [muBundleBoxJumpers addObject:muObj];
    }];
    //用新的数组覆盖之前的数据
    NSMutableDictionary *muBundleDic = [NSMutableDictionary dictionaryWithDictionary:bundleDic];
    [muBundleDic setObject:muBundleBoxJumpers forKey:@"jumpers"];
    
    DDLogVerbose(@"把新的角色信息，写入沙盒 %@",bundleDic);
    [muBundleDic writeToFile:self.jumperFilePath atomically:YES];
    
}

/**
 更新jumper角色属性

 @param jumper jumper
 */
-(void)updaJumper:(JumperRoleModel *)jumper
{
    NSMutableArray *newJumpers = [[NSMutableArray alloc]init];
    
    [self.alllJumpers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建可变字典
        NSInteger roleID = [obj integerValueForKey:@"roleID" default:0];
        if (jumper.roleID == roleID) {//找到这个角色
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[jumper modelToJSONObject]] ;
            [newJumpers addObject:dic];
        }else{
            [newJumpers addObject:obj];
        }
    }];
    //用最新的值
    self.alllJumpers = newJumpers;
    NSLog(@"%@",self.alllJumpers);
    [self.localDataDic setObject:self.alllJumpers forKey:@"jumpers"];
    
    [self.localDataDic writeToFile:self.jumperFilePath atomically:YES];
}

/**
 设置当前使用的角色
 
 @param jumper 要设置的角色
 */
-(void)updateCurntRoleModel:(JumperRoleModel *)jumper
{
    if (!jumper) {
        DDLogVerbose(@"要设置的角色是个空的");
        return;
    }
    
    _curntJumperRoleModel = jumper;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[jumper modelToJSONObject]] ;
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kCurrentJumperRoleDic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 当前使用的角色模型
 
 @return 角色模型
 */
-(JumperRoleModel *)curntJumperRoleModel{
    if (!_curntJumperRoleModel ) {
        NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
        NSDictionary *roleDic = [usf objectForKey:kCurrentJumperRoleDic];
        NSLog(@"roleDic = %@",roleDic);
        if (roleDic==nil) {//用户未设置角色，使用默认角色
            DDLogVerbose(@"用户未设置角色，使用默认角色");
            if (self.alllJumpers.count>0) {
                //要求配置文件里第一个必须是默认的，不然就乱了
                roleDic = self.alllJumpers.firstObject;
                DDLogVerbose(@"用配置文件里第一个");
            }else{
                //数据还未初始化完成，先自己创建一个
                DDLogVerbose(@"数据还未初始化完成，先自己创建一个");
                roleDic = @{@"jumperPic":@"jumper兔子背面",@"roleID":@0,@"isUnlocked":[NSNumber numberWithBool:YES],@"nickName":@"hop jump"};
            }
        }
        JumperRoleModel *roleModel = [JumperRoleModel modelWithDictionary:roleDic];
        _curntJumperRoleModel = roleModel;
    }
    return _curntJumperRoleModel;
}

@end
