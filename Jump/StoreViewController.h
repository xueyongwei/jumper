//
//  StoreViewController.h
//  Jump
//
//  Created by xueyognwei on 2017/7/17.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "UIShowViewController.h"
@interface StoreViewController : UIShowViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,copy) void (^closeVCBlock) (void);
@end
