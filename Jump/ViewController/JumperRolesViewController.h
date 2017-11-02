//
//  JumperRolesViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/9/12.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JumperRolesViewController : UIViewController

@property (nonatomic,copy) void(^closeBlock)(void);
@property (nonatomic,copy) void(^goldClickBlock)(void);
@property (nonatomic,copy) void(^dimondClickBlock)(void);

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
