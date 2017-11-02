//
//  StoreViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/7/17.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "StoreViewController.h"
#import <IAPShare.h>
#import "StoreGoldCollectionViewCell.h"
#import "SotreCollectionReusableView.h"
#import "StoreGodsModel.h"
#import "WealthManager.h"

#import "GetGoldSucessAlertView.h"
#import "GoldInsufficientView.h"
#import "StoreAlertWithImgAndTextView.h"

#import "XYWALertViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface StoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *diamondCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *godCountBtn;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeTralingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sotreTopConst;
@property (nonatomic,strong) NSMutableArray *sectionTitlesArr;
@end

@implementation StoreViewController
//音效的ID
static SystemSoundID clickSoundID = 10;
static SystemSoundID sucessSoundID = 11;

-(void)initViewConstAndAlpha{
    self.collectionView.alpha = 0;
    self.headerImageView.alpha = 0;
    self.titleLabel.alpha = 0;
    self.sotreTopConst.constant = 100;
    self.closeTralingConst.constant = -50;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewConstAndAlpha];
    [self customCollectionView];
    [self prepareData];
    self.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:25];
    UIImage *diamondBgImage = [UIImage imageNamed:@"home钻石数值"];
    diamondBgImage = [diamondBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, diamondBgImage.size.width*0.5, 0, diamondBgImage.size.width*0.2) resizingMode:UIImageResizingModeStretch];
    [self.diamondCountBtn setBackgroundImage:diamondBgImage forState:UIControlStateNormal];
    self.diamondCountBtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:14];
    UIImage *godBgImage = [UIImage imageNamed:@"home金币数值"];
    godBgImage = [godBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, godBgImage.size.width*0.5, 0, godBgImage.size.width*0.2) resizingMode:UIImageResizingModeStretch];
    self.godCountBtn.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:14];
    [self.godCountBtn setBackgroundImage:godBgImage forState:UIControlStateNormal];
    
    [self showCountAmount];
    //创建音效
    [self creatSystemSoundID];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 创建音效
 */
-(void)creatSystemSoundID{
    //点击的音效
    NSString *clickStr = [[NSBundle mainBundle] pathForResource:@"clickItem" ofType:@"caf"];
    NSURL *clickUrl = [NSURL URLWithString:clickStr];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(clickUrl), &clickSoundID);
    //成功的音效
    NSString *sucessStr = [[NSBundle mainBundle] pathForResource:@"buySucess" ofType:@"caf"];
    NSURL *sucessUrl = [NSURL URLWithString:sucessStr];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sucessUrl), &sucessSoundID);
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initIAP];
    self.closeTralingConst.constant = 15;
    self.sotreTopConst.constant = 64;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
        self.collectionView.alpha = 1;
        self.headerImageView.alpha = 1;
        self.titleLabel.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
/**
 显示最新的账户信息
 */
-(void)showCountAmount{
    [self.diamondCountBtn setTitle:[NSString stringWithFormat:@"      %ld",(long)[WealthManager defaultManager].diamondAmount] forState:UIControlStateNormal];
    
    [self.godCountBtn setTitle:[NSString stringWithFormat:@"      %ld",(long)[WealthManager defaultManager].goldCoinAmount] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWealthChangedNoti object:nil];
}
-(void)prepareData{
    _dataSource = [[NSMutableArray alloc]init];
    _sectionTitlesArr = [[NSMutableArray alloc]init];
    //购买的道具
    
    StoreGodsModel *prop1 = [StoreGodsModel godWithTitle:NSLocalizedString(@"Clear Obstacle", nil) ImgName:@"商店道具1" Paymount:@"50" godType:GoodsTypeProp];
    prop1.getSkillType = SkillTypeCleanSub;
    StoreGodsModel *prop2 = [StoreGodsModel godWithTitle:NSLocalizedString(@"Rapid Sprint", nil) ImgName:@"商店道具2" Paymount:@"100" godType:GoodsTypeProp];
    prop2.getSkillType = SkillTypeSprint;
    StoreGodsModel *prop3 = [StoreGodsModel godWithTitle:NSLocalizedString(@"Wings Protection", nil) ImgName:@"商店道具3" Paymount:@"200" godType:GoodsTypeProp];
    prop3.getSkillType = SkillTypeNoDie;
    [_dataSource addObject:@[prop1,prop2,prop3]];
    [_sectionTitlesArr addObject:NSLocalizedString(@"Item", nil)];
    //购买的金币
    StoreGodsModel *god1 = [StoreGodsModel godWithTitle:@"X1000" ImgName:@"商店金币1" Paymount:@"10" godType:GoodsTypeGolds];
    god1.getCoinAmount = 1000;
    StoreGodsModel *god2 = [StoreGodsModel godWithTitle:@"X5000" ImgName:@"商店金币2" Paymount:@"50" godType:GoodsTypeGolds];
    god2.getCoinAmount = 5000;
    StoreGodsModel *god3 = [StoreGodsModel godWithTitle:@"X10000" ImgName:@"商店金币3" Paymount:@"100" godType:GoodsTypeGolds];
    god3.getCoinAmount = 10000;
    [_dataSource addObject:@[god1,god2,god3]];
    [_sectionTitlesArr addObject:NSLocalizedString(@"Gold", nil)];
    
    [self.collectionView reloadData];
    
}
-(void)customCollectionView{
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 5;
    
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 25, 5);
    CGFloat eachWidth = (YYScreenSize().width-10)/3;
    layout.itemSize = CGSizeMake(eachWidth, eachWidth/0.8);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"StoreGoldCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StoreGoldCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"SotreCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SotreCollectionReusableView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height)];
    
    bgView.image = [UIImage imageNamed:@"StoreCollectionBG"];
    self.collectionView.backgroundView = bgView;
}

/**
 点击关闭按钮
 
 @param sender 关闭按钮
 */
- (IBAction)onCloseClick:(UIButton *)sender {
    self.closeTralingConst.constant = -50;
    self.sotreTopConst.constant = 200;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
        self.collectionView.alpha = 0;
        self.headerImageView.alpha = 0;
        self.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeViewController:^{
                if (self.closeVCBlock) {
                    self.closeVCBlock();
                }
            }];
        }
    }];
    
}



#pragma mark -- UICollectionView的代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataSource[section];
    return array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreGoldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreGoldCollectionViewCell" forIndexPath:indexPath];
    StoreGodsModel *model = self.dataSource[indexPath.section][indexPath.item];
    [cell customCellWithModel:model AtIndexPath:indexPath];
    [cell layoutIfNeeded];
    
    cell.centerConst.constant = indexPath.section ==2?0:10;
    
    cell.countLabel.hidden = !(indexPath.section ==0);
    
    if (indexPath.item ==0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bgView.bounds byRoundingCorners: UIRectCornerBottomLeft cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = cell.bgView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        cell.bgView.layer.mask = maskLayer;
        
    }else if (indexPath.item == 2){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bgView.bounds byRoundingCorners: UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = cell.bgView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        cell.bgView.layer.mask = maskLayer;
    }else{
        cell.bgView.layer.mask = nil;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserDefaultManager isSoundEffectClose]) {
        AudioServicesPlaySystemSound(clickSoundID);
    }
    
    StoreGodsModel *model = self.dataSource[indexPath.section][indexPath.item];
    if (model.goodType == GoodsTypeDiamond) {
        SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:indexPath.item];
        CoreSVPLoading(@"wait..", NO);
        [FIRAnalytics logEventWithName:@"购买" parameters:@{@"钻石":model.title,@"状态":@0}];
        [self buyProduct:product godsModel:model];
    }else if (model.goodType == GoodsTypeGolds){
        [self buygoldWithGodsModel:model atIndexPath:indexPath sucess:nil];
    }else if (model.goodType == GoodsTypeProp){
        [self buySkillWithGodsModel:model atIndexPath:indexPath];
    }
}
//头部和脚部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SotreCollectionReusableView *view=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SotreCollectionReusableView" forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view.label.text=_sectionTitlesArr[indexPath.section];
    }
    return view;
}
//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat eachWidth = (YYScreenSize().width-10)/3;
    if (indexPath.section ==0) {
        return CGSizeMake(eachWidth, eachWidth/0.74);
    }else{
        return CGSizeMake(eachWidth, eachWidth/0.8);
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -- 购买行为
-(void)buySkillWithGodsModel:(StoreGodsModel *)skillModel atIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wkSelf = self;
    XYWALertViewController *alert = [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        NSString *text = [NSLocalizedString(@"Get %@?", nil) stringByReplacingOccurrencesOfString:@"%@" withString:skillModel.title];
        view.textLabel.text = text;
        view.imgView.image = [UIImage imageNamed:[skillModel.imgName stringByAppendingString:@"Big"]];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        
    } RightBtnClick:^(UIButton *rightBtn) {
        if ([WealthManager defaultManager].goldCoinAmount<skillModel.payAmount.integerValue) {//钱不够
            [wkSelf alertToNoGoldToBuySkill:skillModel atIndexPath:indexPath];
        }else{//购买这个道具
            [WealthManager defaultManager].goldCoinAmount -= skillModel.payAmount.integerValue;
            [[WealthManager defaultManager ] earnSkillType:skillModel.getSkillType Count:1];
            [wkSelf.collectionView reloadData];
            
            [wkSelf showCountAmount];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wkSelf zoomCollectionCellAnIndexPath:indexPath];
            });
            
            
            [FIRAnalytics logEventWithName:@"购买" parameters:@{@"道具名":skillModel.title,@"状态":@1}];
        }
    }];
    [alert.rightBtn setImage:[UIImage imageNamed:@"商店金币icon"] forState:UIControlStateNormal];
    [alert.rightBtn setTitle:[NSString stringWithFormat:@" X%@",skillModel.payAmount] forState:UIControlStateNormal];
}

-(void)alertToNoGoldToBuySkill:(StoreGodsModel *)skillModel atIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wkSelf = self;
    CGFloat dimondPay = 10;
    CGFloat getGold = 1000;
    if (skillModel.payAmount.integerValue>800) {
        dimondPay = 50;
        getGold = 5000;
    }
    
    NSString *alertTitle =NSLocalizedString(@"Lack of Gold", nil);
    NSString *alertContent = [[NSLocalizedString(@"whether to spend %1@ diamonds for %2@ gold?", nil) stringByReplacingOccurrencesOfString:@"%1@" withString:[NSString stringWithFormat:@"%.0f",dimondPay]]stringByReplacingOccurrencesOfString:@"%2@" withString:[NSString stringWithFormat:@"%.0f",getGold]];
    NSString *showText = [NSString stringWithFormat:@"%@!\n\n%@",alertTitle,alertContent];

    XYWALertViewController *alert = [XYWALertViewController showContentOnWkVC:self addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        view.textLabel.text = showText;
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        
    } RightBtnClick:^(UIButton *rightBtn) {
        if (dimondPay>[WealthManager defaultManager].diamondAmount) {
            [wkSelf alertNoDimond];
        }else{//支付钻石换金币
            [WealthManager defaultManager].diamondAmount -= dimondPay;
            [WealthManager defaultManager].goldCoinAmount += getGold;
            [wkSelf showCountAmount];
            StoreGodsModel *godModel = [[StoreGodsModel alloc]init];
            godModel.title = [NSString stringWithFormat:@"X%.0f",getGold];
            godModel.getCoinAmount = getGold;
            godModel.payAmount = [NSString stringWithFormat:@"%.0f",dimondPay];
            [wkSelf paymentDidSucessOfGodModel:godModel atIndexPath:indexPath sucess:^{//兑换完成，继续问是否买道具
                [wkSelf buySkillWithGodsModel:skillModel atIndexPath:indexPath];
            }];
        }
    }];
    [alert.leftBtn setTitle:NSLocalizedString(@"No", nil) forState:UIControlStateNormal];
    [alert.rightBtn setTitle:NSLocalizedString(@"Yes", nil) forState:UIControlStateNormal];
}

-(void)alertNoDimond{
    XYWALertViewController *alert = [XYWALertViewController showContentOnWkVC:self addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        view.textLabel.text = NSLocalizedString(@"Lack of Diamond", nil);
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        
    } RightBtnClick:^(UIButton *rightBtn) {
        [self wannaScrollToBugDimondSection];
    }];
    //    [alert.leftBtn setTitle:NSLocalizedString(@"No", nil) forState:UIControlStateNormal];
    [alert.rightBtn setTitle:NSLocalizedString(@"Purchase", nil) forState:UIControlStateNormal];
}
-(void)wannaScrollToBugDimondSection{
    if (self.collectionView.numberOfSections == 3) {//刷新出来了购买钻石
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }else{
        CoreSVPCenterMsg(NSLocalizedString(@"Please check the network connection", nil));
    }
    
}
-(void)zoomCollectionCellAnIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
            [self showAddToCell:cell AtIndexPath:indexPath];
        }
    }];
}
-(void)showAddToCell:(UICollectionViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    NSArray *colorNames = @[@"f29b16",@"40b8e6",@"ff3c76"];
    CGPoint center =  [self.collectionView convertPoint:cell.center toView:self.view];
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 100)];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.text = @"+1";
    showLabel.textColor = [UIColor colorWithHexString:colorNames[indexPath.item]] ;
    showLabel.center = CGPointMake(center.x, center.y-44);
    showLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:50];
    [self.view addSubview:showLabel];
    //放个音效
    if (![UserDefaultManager isSoundEffectClose]) {
        AudioServicesPlaySystemSound(sucessSoundID);
    }
    
    //显示个动画
    [UIView animateWithDuration:0.3 animations:^{
        showLabel.transform = CGAffineTransformMakeScale(1.8, 1.8);
        showLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [showLabel removeFromSuperview];
        }
    }];
}
-(void)buygoldWithGodsModel:(StoreGodsModel *)model atIndexPath:(NSIndexPath *)indexPath sucess:(void(^)(void))sucessBlock{
    __weak typeof(self) wkSelf = self;
    XYWALertViewController *alert = [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        NSString *text = [NSLocalizedString(@"Get %@ gold?", nil) stringByReplacingOccurrencesOfString:@"%@" withString:[model.title substringFromIndex:1]];
        view.textLabel.text = text;
        view.imgView.image = [UIImage imageNamed:[model.imgName stringByAppendingString:@"Big"]];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        
    } RightBtnClick:^(UIButton *rightBtn) {
        if ([WealthManager defaultManager].diamondAmount<model.payAmount.integerValue) {
            [wkSelf alertNoDimond];
        }else{
            [WealthManager defaultManager].diamondAmount -= model.payAmount.integerValue;
            [WealthManager defaultManager].goldCoinAmount += model.getCoinAmount;
            //                [[WealthManager defaultManager] paymentDiamonCunt:model.payAmount.integerValue];
            //                [[WealthManager defaultManager] earnGodCionCount:model.getCoinAmount];
            [wkSelf showCountAmount];
            [wkSelf paymentDidSucessOfGodModel:model atIndexPath:indexPath sucess:sucessBlock];
        }
        
    }];
    [alert.rightBtn setImage:[UIImage imageNamed:@"商店钻石icon"] forState:UIControlStateNormal];
    [alert.rightBtn setTitle:[NSString stringWithFormat:@" X%@",model.payAmount] forState:UIControlStateNormal];
    
    
}

/**
 兑换金币成功
 
 @param model 金币的model
 @param indexPath 下标
 @param sucessBlock 成功的回掉
 */
-(void)paymentDidSucessOfGodModel:(StoreGodsModel *)model atIndexPath:(NSIndexPath *)indexPath sucess:(void(^)(void))sucessBlock
{
    if (![UserDefaultManager isSoundEffectClose]) {
        AudioServicesPlaySystemSound(sucessSoundID);
    }
    [FIRAnalytics logEventWithName:@"购买" parameters:@{@"金币":model.title,@"状态":@1}];

    __weak typeof(self) wkSelf = self;
    
    [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        view.imgView.image = [UIImage imageNamed:@"store金币兑换"];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"Successful purchase！", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
        [text appendString:@"\n\n"];
        
        NSAttributedString *youget = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"You got ", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];;
        [text appendAttributedString:youget];
        
        NSString *earnStr = [NSString stringWithFormat:@"X%ld",(long)model.getCoinAmount];
        NSString *dimond = [NSLocalizedString(@"Gold", nil) stringByAppendingString:earnStr];
        NSAttributedString *atText = [[NSAttributedString alloc]initWithString:dimond attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"fbb31e"]}];
        
        [text appendAttributedString:atText];
        
        view.textLabel.attributedText = text;
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        if (sucessBlock) {
            sucessBlock();
        }
    } RightBtnClick:nil];
    
}
#pragma mark -- IAP应用内支付
-(void)refreshIAP{
    NSSet* dataSet = [[NSSet alloc] initWithObjects:@"1",@"2",@"3",@"4",nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    [IAPShare sharedHelper].iap.production = NO;
    
    __weak typeof(self) wkSelf = self;
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if (response.products.count == dataSet.count) {//请求都有了
             
         }
         if ([IAPShare sharedHelper].iap.products.count<3) {
             return ;
         }
         SKProduct* product0 = [IAPShare sharedHelper].iap.products[0];
         StoreGodsModel *model0 = [StoreGodsModel godWithTitle:@"60" ImgName:@"商店钻石1" Paymount:[self moneyStrLocanizedWithProduct:product0] godType:GoodsTypeDiamond];
         
         SKProduct* product1 = [IAPShare sharedHelper].iap.products[1];
         StoreGodsModel *model1 = [StoreGodsModel godWithTitle:@"300+20" ImgName:@"商店钻石2" Paymount:[wkSelf moneyStrLocanizedWithProduct:product1] godType:GoodsTypeDiamond];
         
         SKProduct* product2 = [IAPShare sharedHelper].iap.products[2];
         StoreGodsModel *model2 = [StoreGodsModel godWithTitle:@"980+100" ImgName:@"商店钻石3" Paymount:[wkSelf moneyStrLocanizedWithProduct:product2] godType:GoodsTypeDiamond];
         
         //         [_sectionTitlesArr insertObject:@"钻石" atIndex:1];
         
         [_sectionTitlesArr addObject:NSLocalizedString(@"Diamond", nil)];
         [wkSelf.dataSource addObject:@[model0,model1,model2]];
         //         [self.dataSource insertObject:@[model0,model1,model2] atIndex:1];
         
         [wkSelf.collectionView insertSections:[NSIndexSet indexSetWithIndex:2]];
         
     }];
}
-(void)initIAP{
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:@"2",@"3",@"4",nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    
    [IAPShare sharedHelper].iap.production = NO;
    
    __weak typeof(self) wkSelf = self;
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if ([IAPShare sharedHelper].iap.products.count<3) {
             return ;
         }
         SKProduct* product0 = [IAPShare sharedHelper].iap.products[0];
         StoreGodsModel *model0 = [StoreGodsModel godWithTitle:@"60" ImgName:@"商店钻石1" Paymount:[self moneyStrLocanizedWithProduct:product0] godType:GoodsTypeDiamond];
         
         SKProduct* product1 = [IAPShare sharedHelper].iap.products[1];
         StoreGodsModel *model1 = [StoreGodsModel godWithTitle:@"300+20" ImgName:@"商店钻石2" Paymount:[wkSelf moneyStrLocanizedWithProduct:product1] godType:GoodsTypeDiamond];
         
         SKProduct* product2 = [IAPShare sharedHelper].iap.products[2];
         StoreGodsModel *model2 = [StoreGodsModel godWithTitle:@"980+100" ImgName:@"商店钻石3" Paymount:[wkSelf moneyStrLocanizedWithProduct:product2] godType:GoodsTypeDiamond];
         
         //         [_sectionTitlesArr insertObject:@"钻石" atIndex:1];
         
         [_sectionTitlesArr addObject:NSLocalizedString(@"Diamond", nil)];
         [wkSelf.dataSource addObject:@[model0,model1,model2]];
         //         [self.dataSource insertObject:@[model0,model1,model2] atIndex:1];
         
         [wkSelf.collectionView insertSections:[NSIndexSet indexSetWithIndex:2]];
         
     }];
}

-(NSString *)moneyStrLocanizedWithProduct:(SKProduct *)product{
    NSNumberFormatter*numberFormatter
    = [[NSNumberFormatter alloc]
       init];
    
    [numberFormatter
     setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    
    [numberFormatter
     setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter
     //     setLocale:[NSLocale currentLocale]];
     //    [numberFormatter
     setLocale:product.priceLocale];
    
    NSString*formattedPrice
    = [numberFormatter stringFromNumber:product.price];
    return formattedPrice;
}
-(void)buyProduct:(SKProduct*)product godsModel:(StoreGodsModel *)model{
    __weak typeof(self) wkSelf = self;
    [[IAPShare sharedHelper].iap buyProduct:product
                               onCompletion:^(SKPaymentTransaction* trans){
                                   
                                   if(trans.error)
                                   {
                                       DDLogError(@"buyProduct Fail %@",[trans.error localizedDescription]);
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Failed purchase", nil));
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                       [CoreSVP dismiss];
                                       [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                       DDLogInfo(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(@"购买成功！");
                                       [wkSelf iapSucessedWithProduct:product godsModel:model];
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Failed purchase", nil));
                                       DDLogError(@"Fail");
                                   }
                               }];//end of buy product
    
}
-(void)iapSucessedWithProduct:(SKProduct *)product godsModel:(StoreGodsModel *)model{
    if (![UserDefaultManager isSoundEffectClose]) {
        AudioServicesPlaySystemSound(sucessSoundID);
    }
    [FIRAnalytics logEventWithName:@"购买" parameters:@{@"钻石":model.title,@"状态":@1}];
    [FIRAnalytics logEventWithName:@"支付成功" parameters:@{@"itunesID":product.productIdentifier}];
    NSInteger earn = 0;
    
    if ([product.productIdentifier isEqualToString:@"2"]) {
        earn = 60;
    }else if ([product.productIdentifier isEqualToString:@"3"]){
        earn = 320;
    }else if ([product.productIdentifier isEqualToString:@"4"]){
        earn = 1080;
    }
    [WealthManager defaultManager].diamondAmount+=earn;
    [self showCountAmount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWealthChangedNoti object:nil];

    __weak typeof(self) wkSelf = self;
     [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];

        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"Successful purchase！", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
        [text appendString:@"\n\n"];
        
        NSAttributedString *youget = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"You got ", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];;
        [text appendAttributedString:youget];
        
        NSString *earnStr = [NSString stringWithFormat:@"X%ld",(long)earn];
        NSString *dimond = [NSLocalizedString(@"Diamond", nil) stringByAppendingString:earnStr];
        NSAttributedString *atText = [[NSAttributedString alloc]initWithString:dimond attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"fa3d2a"]}];
        
        [text appendAttributedString:atText];
        
        view.textLabel.attributedText = text;
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        
    } RightBtnClick:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
