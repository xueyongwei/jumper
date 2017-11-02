//
//  PauseViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/8/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PauseViewController : UIViewController
@property (nonatomic,copy) void(^goHomeBlock)(void);
@property (nonatomic,copy) void(^goOnBlock)(void);
@property (nonatomic,copy) void(^willCloseBlock)(void);
@end
