//
//  JumperRolesViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/9/12.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumperRolesViewController.h"
#import "JumperRoleManager.h"
#import "JumperRoleChangeCollectionViewCell.h"
#import "WealthManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ShareContentViewController.h"
#import "XYWALertViewController.h"
#import "StoreAlertWithImgAndTextView.h"

static NSInteger showNumberEachScreen = 4;

static SystemSoundID choseSoundID = 10;
static SystemSoundID sucessSoundID = 11;

@interface JumperRolesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *bigShowImgView;
@property (nonatomic,assign) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet UIButton *diamondCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *godCountBtn;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *unlockDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *unlockProgressLabel;

@property (weak, nonatomic) IBOutlet UIButton *unlockBtn;

@property (weak, nonatomic) IBOutlet UIView *corverView;

@property (nonatomic,strong) JumperRoleModel *wannaUnlcokRole;
@property (nonatomic,strong) NSDate *goTo5StarDate;

@end

@implementation JumperRolesViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.alpha = 1;
    }];
}

-(void)dissmissViewWithFinishBlock:(void(^)(void))finishedBlock{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            finishedBlock();
        }
    }];
}
-(void)setToDefautlState{
 
    self.bgView.alpha = 0;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置初始状态
    [self setToDefautlState];
    //定义tableview
    [self prepareData];
//    [self customTableView];
    [self customCollectionView];
    
    [self showCountAmount];
    [self creatSystemSoundID];
    [self observeAppEnterBackground];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showCountAmount) name:kWealthChangedNoti object:nil];
    // Do any additional setup after loading the view from its nib.
}

/**
 监听进入后台
 */
-(void)observeAppEnterBackground{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackGround) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(void)appEnterBackGround{
    
}
-(void)appWillEnterForeground{
    if (self.wannaUnlcokRole) {
        NSInteger passedSec = [[NSDate date] timeIntervalSinceDate:self.goTo5StarDate];
        if (passedSec>10) {//评论至少也得个10秒吧
            [self unlockJumperRole:self.wannaUnlcokRole];
        }else{
            DDLogWarn(@"去评论不到10s就回来了，所以猜你没有评论，不给解锁");
        }
    }
    self.wannaUnlcokRole = nil;
}

/**
 创建音效
 */
-(void)creatSystemSoundID{
    //切换的音效
    NSString *clickStr = [[NSBundle mainBundle] pathForResource:@"changeJumper" ofType:@"caf"];
    NSURL *clickUrl = [NSURL URLWithString:clickStr];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(clickUrl), &choseSoundID);
    
    //成功的音效
    NSString *sucessStr = [[NSBundle mainBundle] pathForResource:@"buySucess" ofType:@"caf"];
    NSURL *sucessUrl = [NSURL URLWithString:sucessStr];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sucessUrl), &sucessSoundID);
}
-(void)prepareData{
    self.dataSource = [[NSMutableArray alloc]init];
    [[JumperRoleManager shareManager].alllJumpers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JumperRoleModel *roleModel = [JumperRoleModel modelWithDictionary:obj];
        [self.dataSource addObject:roleModel];
    }];
    [self.collectionView reloadData];
}

-(void)customCollectionView{
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 5;
    
//    layout.sectionInset = UIEdgeInsetsMake(0, YYScreenSize().width/2-YYScreenSize().width/6, 0, 0 );
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 25, 5);
    CGFloat eachWidth = YYScreenSize().width/showNumberEachScreen;
    layout.itemSize = CGSizeMake(eachWidth, eachWidth*2);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, eachWidth*1.5, 0, eachWidth*1.5);
    self.collectionView.contentOffset =CGPointMake(-eachWidth*1.5, 0);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JumperRoleChangeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JumperRoleChangeCollectionViewCell"];
    [self showBigJumperAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0 ]];
}
/**
 显示最新的账户信息
 */
-(void)showCountAmount{
    [self.diamondCountBtn setTitle:[NSString stringWithFormat:@"      %ld",(long)[WealthManager defaultManager].diamondAmount] forState:UIControlStateNormal];
    
    [self.godCountBtn setTitle:[NSString stringWithFormat:@"      %ld",(long)[WealthManager defaultManager].goldCoinAmount] forState:UIControlStateNormal];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kWealthChangedNoti object:nil];
}
#pragma mark -- UICollectionView的代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JumperRoleChangeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JumperRoleChangeCollectionViewCell" forIndexPath:indexPath];
    JumperRoleModel *roleModel = self.dataSource[indexPath.item];
    [cell setRoleModel:roleModel atIndexPath:indexPath];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView setContentOffset:CGPointMake(indexPath.item*(YYScreenSize().width/showNumberEachScreen)-YYScreenSize().width*0.5+YYScreenSize().width/showNumberEachScreen/2, 0) animated:YES];
//    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat eachWidth = YYScreenSize().width/showNumberEachScreen;
    
    if (indexPath.item == 2 ||indexPath.item == 7) {
        return CGSizeMake(eachWidth*1.5, eachWidth*2);
    }else{
        return CGSizeMake(eachWidth, eachWidth*2);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint centerPoint = CGPointMake(scrollView.contentOffset.x+YYScreenSize().width*0.5, scrollView.contentOffset.y);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    if (indexPath.item==0 && centerPoint.x>YYScreenSize().width/2) {
        return;
    }
    if (indexPath.item != self.currentIndex ) {
        NSLog(@"\n index=%ld",(long)indexPath.item);
        self.currentIndex =indexPath.item;
        [self showBigJumperAtIndexPath:indexPath];
        if (![UserDefaultManager isSoundEffectClose]) {
            AudioServicesPlaySystemSound(choseSoundID);
        }
    }
}

-(void)showBigJumperAtIndexPath:(NSIndexPath *)indexPath{
    JumperRoleModel *roleModel = self.dataSource[indexPath.item];
    NSString *imgName = [roleModel.jumperPic stringByAppendingString:@"_big"];
    if (!roleModel.isUnlocked) {
        imgName = [imgName stringByAppendingString:@"_黑"];
    }
    NSLog(@"imgName %@",imgName);
    self.bigShowImgView.image = [UIImage imageNamed:imgName];
    if (roleModel.isUnlocked) {
        self.actionBtn.hidden = NO;
        self.unlockBtn.hidden = YES;
        self.unlockDesLabel.hidden = YES;
        self.unlockProgressLabel.hidden = YES;
    }else{
        self.actionBtn.hidden = YES;
        
        [self customBottonActionUIWithJumperRoleModel:roleModel];
    }
    
}
-(void)customBottonActionUIWithJumperRoleModel:(JumperRoleModel *)roleModel
{
    switch (roleModel.unlockType) {
        case JumperRoleUnlockTypeGold://金币解锁
        {
            self.unlockBtn.hidden = NO;
            self.unlockDesLabel.hidden = YES;
            self.unlockProgressLabel.hidden = YES;
            
            [self.unlockBtn setImage:[UIImage imageNamed:@"changeRole金币解锁_icon"] forState:UIControlStateNormal];
            [self.unlockBtn setTitle:[NSString stringWithFormat:@" %ld",(long)roleModel.unlockConsumption] forState:UIControlStateNormal];
            [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"fbb31e"] forState:UIControlStateNormal];
            
        }
            break;
        case JumperRoleUnlockTypeDiamonds://钻石解锁
        {
            self.unlockBtn.hidden = NO;
            self.unlockDesLabel.hidden = YES;
            self.unlockProgressLabel.hidden = YES;
            [self.unlockBtn setImage:[UIImage imageNamed:@"changeRole钻石解锁_icon"] forState:UIControlStateNormal];
            [self.unlockBtn setTitle:[NSString stringWithFormat:@" %ld",(long)roleModel.unlockConsumption] forState:UIControlStateNormal];
            [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"f84d3b"] forState:UIControlStateNormal];
        }
            break;
        case JumperRoleUnlockTypeShare://分享解锁
        {
            self.unlockBtn.hidden = NO;
            [self.unlockBtn setImage:nil forState:UIControlStateNormal];
            [self.unlockBtn setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
            self.unlockDesLabel.hidden = YES;
            self.unlockProgressLabel.hidden = YES;
            [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"28b6f6"] forState:UIControlStateNormal];
        }
            break;
        case JumperRoleUnlockTypeHeightScore://高分解锁
        {
            NSInteger maxScore =[UserDefaultManager maxScore];
            if (maxScore>=roleModel.unlockConsumption) {
                self.unlockBtn.hidden = NO;
                self.unlockDesLabel.hidden = YES;
                self.unlockProgressLabel.hidden = YES;
                [self.unlockBtn setImage:nil forState:UIControlStateNormal];
                [self.unlockBtn setTitle:NSLocalizedString(@"Unlock", nil) forState:UIControlStateNormal];
                [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"28b6f6"] forState:UIControlStateNormal];
            }else{
                self.unlockBtn.hidden = YES;
                self.unlockDesLabel.hidden = NO;
                self.unlockProgressLabel.hidden = NO;
                
                self.unlockDesLabel.text = NSLocalizedString(@"Highest Score", nil);
                NSString *text = [NSString stringWithFormat:@"%ld",(long)roleModel.unlockConsumption];
                self.unlockProgressLabel.text = text;
            }
            
        }
            break;
        case JumperRoleUnlockType5Star://5星好评解锁
        {
            self.unlockBtn.hidden = NO;
            self.unlockDesLabel.hidden = YES;
            [self.unlockBtn setImage:nil forState:UIControlStateNormal];
            [self.unlockBtn setTitle:NSLocalizedString(@"Rate us", nil) forState:UIControlStateNormal];
            self.unlockProgressLabel.hidden = YES;
            [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"28b6f6"] forState:UIControlStateNormal];
        }
            break;
        case JumperRoleUnlockTypeAccumulatedConsumptionGold://累计消费金币
        {
            
            NSInteger totalGold =[[WealthManager defaultManager] totalGoldCoinPayed];
            if (totalGold>=roleModel.unlockConsumption) {
                self.unlockBtn.hidden = NO;
                self.unlockDesLabel.hidden = YES;
                self.unlockProgressLabel.hidden = YES;
                [self.unlockBtn setImage:nil forState:UIControlStateNormal];
                [self.unlockBtn setTitle:NSLocalizedString(@"Unlock", nil) forState:UIControlStateNormal];
                [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"28b6f6"] forState:UIControlStateNormal];
            }else{
                self.unlockBtn.hidden = YES;
                self.unlockDesLabel.hidden = NO;
                self.unlockProgressLabel.hidden = NO;
                self.unlockDesLabel.text = NSLocalizedString(@"Gold Spending", nil);
                NSString *showText = [NSString stringWithFormat:@"%ld/%ld",(long)totalGold,(long)roleModel.unlockConsumption];
                self.unlockProgressLabel.text = showText;
            }
            
        }
            break;
        case JumperRoleUnlockTypeAccumulatedConsumptionDiamonds://累计消耗钻石
        {
            self.unlockBtn.hidden = YES;
            self.unlockDesLabel.hidden = NO;
            self.unlockProgressLabel.hidden = NO;
            self.unlockDesLabel.text = NSLocalizedString(@"Diamond Spending", nil);
        }
            break;
        case JumperRoleUnlockTypeAccumulatedScore://累计分数
        {
            NSInteger totalScore = [UserDefaultManager totalScore];
            if (totalScore>=roleModel.unlockConsumption) {
                self.unlockBtn.hidden = NO;
                self.unlockDesLabel.hidden = YES;
                self.unlockProgressLabel.hidden = YES;
                [self.unlockBtn setImage:nil forState:UIControlStateNormal];
                [self.unlockBtn setTitle:NSLocalizedString(@"Unlock", nil) forState:UIControlStateNormal];
                [self.unlockBtn setTitleColor:[UIColor colorWithHexString:@"28b6f6"] forState:UIControlStateNormal];
            }else{
                self.unlockBtn.hidden = YES;
                self.unlockDesLabel.hidden = NO;
                self.unlockProgressLabel.hidden = NO;
                self.unlockDesLabel.text = NSLocalizedString(@"Cumulative Score", nil);
                NSString *showText = [NSString stringWithFormat:@"%ld/%ld",(long)totalScore,(long)roleModel.unlockConsumption];
                self.unlockProgressLabel.text = showText;
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 点击操作
- (IBAction)onCloseBtnClick:(UIButton *)sender {
    
    if (self.closeBlock) {
        __weak typeof(self) wkSelf = self;
        [self dissmissViewWithFinishBlock:^{
            [wkSelf.view removeFromSuperview];
            [wkSelf removeFromParentViewController];
            wkSelf.closeBlock();
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onStartGame:(UIButton *)sender {
    JumperRoleModel *roleModel = self.dataSource[self.currentIndex];
    if (roleModel) {
        [[JumperRoleManager shareManager] updateCurntRoleModel:roleModel];
    }else{
        CoreSVPCenterMsg(@"The character went wrong");
        return;
    }
    [self onCloseBtnClick:nil];
}

- (IBAction)onUnlockClick:(UIButton *)sender {
    JumperRoleModel *roleModel = self.dataSource[self.currentIndex];
    switch (roleModel.unlockType) {
        case JumperRoleUnlockTypeShare:
        {
            [self shareToUnlockRole:roleModel];
        }
            break;
        case JumperRoleUnlockType5Star:
        {
            [self go5star:roleModel];
        }
            break;
        case JumperRoleUnlockTypeGold:
        {
            [self wannaBuyRoleModel:roleModel];
        }
            break;
        case JumperRoleUnlockTypeDiamonds:
        {
            [self wannaBuyRoleModel:roleModel];
        }
            break;
        default:
        {//直接解锁
            [self unlockJumperRole:roleModel];
        }
            break;
    }
    
}

- (IBAction)onDimondClick:(UIButton *)sender {
    if (self.dimondClickBlock) {
        self.dimondClickBlock();
    }
}
- (IBAction)onGoldClick:(UIButton *)sender {
    if (self.goldClickBlock) {
        self.goldClickBlock();
    }
}


/**
 解锁这个角色

 @param roleModel 角色
 */
-(void)unlockJumperRole:(JumperRoleModel *)roleModel{
    roleModel.isUnlocked = YES;
    [[JumperRoleManager shareManager] updaJumper:roleModel];
    [self.collectionView reloadData];
    NSString *imgName = [roleModel.jumperPic stringByAppendingString:@"_big"];
    if (!roleModel.isUnlocked) {
        imgName = [imgName stringByAppendingString:@"_黑"];
    }
    self.bigShowImgView.image = [UIImage imageNamed:imgName];
    self.actionBtn.hidden = NO;
    self.unlockBtn.hidden = YES;
    [self animateUnlockFlash];
}

/**
 发光哦
 */
-(void)animateUnlockFlash{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YYScreenSize().width*1.5, YYScreenSize().width*1.5)];
    imgView.image = [UIImage imageNamed:@"jumperUnlock光芒"];
    imgView.center = CGPointMake(YYScreenSize().width/2, YYScreenSize().height/2);
    
    [self.corverView addSubview:imgView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![UserDefaultManager isSoundEffectClose]) {
            AudioServicesPlaySystemSound(sucessSoundID);
        }
    });
    [UIView animateWithDuration:2.0 animations:^{
        imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI);
    } completion:^(BOOL finished) {
        if (finished) {
            [imgView removeFromSuperview];
        }
    }];
//    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

-(void)go5star:(JumperRoleModel *)roleModel{
    [FIRAnalytics logEventWithName:@"去评论" parameters:@{@"目的": @"解锁角色"}];;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1259722147"]];
    self.wannaUnlcokRole = roleModel;
    self.goTo5StarDate = [NSDate date];
}



#pragma mark -- 分享
-(void)shareToUnlockRole:(JumperRoleModel *)roleModel{
    CoreSVPLoading(nil, NO);

    [FIRAnalytics logEventWithName:@"分享" parameters:@{}];
    NSString *textToShare = NSLocalizedString(@"Come and challenge high scores in Hop Jump's colorful world!", nil);
    
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/app/id1259722147"];
    NSArray *activityItems = @[urlToShare,textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    
    // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
    //关闭系统的一些Activity类型,不需要的功能关掉。
    //    ,@"com.apple.reminders.RemindersEditorExtension",
    //    @"com.apple.mobilenotes.SharingExtension"
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage
                                         ,UIActivityTypeMail
                                         ,UIActivityTypePrint
                                         ,UIActivityTypeAirDrop
                                         ,UIActivityTypeOpenInIBooks
                                         ,UIActivityTypeAddToReadingList
                                         ,UIActivityTypeAssignToContact,
                                         UIActivityTypeCopyToPasteboard];
    
    //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
    __weak typeof(self) wkSelf = self;
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            [wkSelf unlockJumperRole:roleModel];
        }else{
            CoreSVPCenterMsg(NSLocalizedString(@"Share failed", nil));
        }
    };
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
    
    [self.view.viewController presentViewController:activityVC animated:YES completion:^{
        [CoreSVP dismiss];
    }];
}


/**
 想要购买角色

 @param roleModel 角色
 */
-(void)wannaBuyRoleModel:(JumperRoleModel *)roleModel{
    __weak typeof(self) wkSelf = self;
    XYWALertViewController *alert = [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        view.textLabel.text = NSLocalizedString(@"Unlock this role？", nil);
        NSString *imgName = [NSString stringWithFormat:@"%@_big_黑",roleModel.jumperPic];
        view.imgView.image = [UIImage imageNamed:imgName];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(30);
            make.right.equalTo(contentView).offset(-10);
            make.bottom.equalTo(contentView).offset(-10);
            make.left.equalTo(contentView).offset(10);
        }];
    } withLeftBtnCLick:^(UIButton *leftBtn) {
        
    } RightBtnClick:^(UIButton *rightBtn) {
        NSInteger wealthCount = [WealthManager defaultManager].goldCoinAmount;
        NSString *notEnufStr = NSLocalizedString(@"Lack of Gold", nil);
        if (roleModel.unlockType == JumperRoleUnlockTypeDiamonds){
            wealthCount = [WealthManager defaultManager].diamondAmount;
            notEnufStr = NSLocalizedString(@"Lack of Diamond", nil);
        }
        
        if (wealthCount<roleModel.unlockConsumption) {//钱不够
            CoreSVPCenterMsg(notEnufStr);
        }else{//购买这个道具
            if (roleModel.unlockType == JumperRoleUnlockTypeDiamonds){
                [WealthManager defaultManager].diamondAmount -= roleModel.unlockConsumption;
            }else{
                [WealthManager defaultManager].goldCoinAmount -= roleModel.unlockConsumption;
            }
            roleModel.isUnlocked = YES;
            [[JumperRoleManager shareManager] updaJumper:roleModel];
            [wkSelf.collectionView reloadData];
            
            [wkSelf showCountAmount];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wkSelf unlockJumperRole:roleModel];
            });
            
        }
    }];
    NSString *rightBtnImgName = roleModel.unlockType == JumperRoleUnlockTypeDiamonds?@"商店钻石icon":@"商店金币icon";
    [alert.rightBtn setImage:[UIImage imageNamed:rightBtnImgName] forState:UIControlStateNormal];
    [alert.rightBtn setTitle:[NSString stringWithFormat:@" X%ld",(long)roleModel.unlockConsumption] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    NSLog(@"⚠️ jumpersVC 释放了");
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
