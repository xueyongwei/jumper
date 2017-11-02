//
//  SetingViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/8/1.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SetingViewController.h"
#import "SettingModel.h"
#import "SettingCollectionViewCell.h"
#import "SettingTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "WealthManager.h"
#import <IAPShare.h>
#import <InMobiSDK/InMobiSDK.h>
#import <AFNetworking.h>
@interface SetingViewController () <UICollectionViewDelegate,UICollectionViewDataSource,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,IMNativeDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnBottonConst;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *aboutBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collctionViewLeadingConst;
@property (weak, nonatomic) IBOutlet UIScrollView *aboutScrollView;
@property (weak, nonatomic) IBOutlet UITableView *aboutTableView;
@property (nonatomic,strong)NSMutableArray *aboutDataSource;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property(nonatomic,strong) IMNative *InMobiNativeAdIcon;
@property (nonatomic,strong) UIView *aboutHeaderView;

@property (nonnull,strong) NSMutableArray *dataSource;
@end

@implementation SetingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.titleLabel.alpha = 1;
        self.collectionView.alpha = 1;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.closeBtnBottonConst.constant = 60;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:40];
    [self prepareItems];
    [self requestInmobiNativeAds];
    // Do any additional setup after loading the view from its nib.
}
-(void)dealloc
{
    [self.InMobiNativeAdIcon recyclePrimaryView];
    self.InMobiNativeAdIcon.delegate = nil;
}
#pragma mark -- inmobi原生广告
-(void)requestInmobiNativeAds{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager GET:@"https://api.tools.superlabs.info/config/v1.0/ios/xiangmeng.cn.jumper" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *review = responseObject[@"is_in_review"];
            if ([review isEqualToString:@"True"]) {
                DDLogVerbose(@"还在审核，不请求广告");
            }else{
                self.InMobiNativeAdIcon = [[IMNative alloc] initWithPlacementId:1505301699918];
                self.InMobiNativeAdIcon.delegate = self;
                [self.InMobiNativeAdIcon load];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
-(void)prepareItems{
    _dataSource = [[NSMutableArray alloc]init];
    
    NSArray *imgNamesArr = @[@"setting音乐icon",@"setting音效icon",@"setting购买icon",@"setting联系icon",@"setting关于icon",];
    
    NSArray *showNamesArr = @[NSLocalizedString(@"Music", nil),NSLocalizedString(@"Sound", nil),NSLocalizedString(@"Restore", nil),NSLocalizedString(@"Contact", nil),NSLocalizedString(@"About", nil)];
    NSArray *selNamesArr = @[@"onBgnClick",@"onEffectClick",@"onBuyClick",@"onConnectClick",@"onAboutClick"];
    for (NSInteger i =0; i<imgNamesArr.count; i++) {
        NSString *imgName = imgNamesArr[i];
        NSString *title = showNamesArr[i];
        NSString *selName = selNamesArr[i];
        SettingModel *model = [SettingModel settingModelWithTitle:title ImgName:imgName];
        model.selName = selName;
        [_dataSource addObject:model];
    }
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
        SettingModel *model = [SettingModel settingModelWithTitle:NSLocalizedString(@"Notification", nil) ImgName:@"setting通知icon"];
        model.selName = @"onNotiClick";
        [_dataSource insertObject:model atIndex:2];
    }
    [self customCollection];
    [self customAboutUsTableView];
}
-(void)customCollection{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 25, 5);
    CGFloat eachWidth = (YYScreenSize().width-10)/3;
    layout.itemSize = CGSizeMake(eachWidth, eachWidth/0.8);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SettingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SettingCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}
-(void)customAboutUsTableView{
    _aboutDataSource = [NSMutableArray arrayWithObjects:@"Direct: LaoMao",@"Design: Machamp Rabbit", @"Program: Yuri", @"Art: ChouChou", @"Test: Zheng", @"Help: Liam,Jon Snow,Dragon C", nil];
    [self.aboutTableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
    self.aboutTableView.dataSource = self;
    self.aboutTableView.delegate = self;
    
//    UIView *header = [[[NSBundle mainBundle]loadNibNamed:@"SettingAboutHeaderFooterView" owner:self options:nil]firstObject];
//    header.frame = CGRectMake(0, 0, YYScreenSize().width, 120);
//    UIView *footer = [[[NSBundle mainBundle]loadNibNamed:@"SettingAboutHeaderFooterView" owner:self options:nil]lastObject];
//    footer.frame = CGRectMake(0, 0, YYScreenSize().width, 50);
//    self.aboutTableView.tableHeaderView = header;
//    self.aboutTableView.tableFooterView = footer;
}
- (IBAction)onCLoseCLick:(UIButton *)sender {
    if (self.collctionViewLeadingConst.constant < 0) {
        self.collctionViewLeadingConst.constant = 0;
        [self.view setNeedsLayout];
        [self.closeBtn setImage:[UIImage imageNamed:@"settingX_btn-S"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        return;
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });
    self.closeBtnBottonConst.constant = -100;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 0;
//            self.titleLabel.alpha = 0;
//            self.collectionView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.closeBlick) {
                    self.closeBlick();
                }
            }
        }];
    }];
    
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
    SettingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SettingCollectionViewCell" forIndexPath:indexPath];
    SettingModel *model = self.dataSource[indexPath.item];
    [cell setModel:model atIndexPath:indexPath];
    if (!model.imgName) {
        if ([self.InMobiNativeAdIcon isReady]) {
            UIImage *roundImg = [self.InMobiNativeAdIcon.adIcon imageByResizeToSize:CGSizeMake(64, 64) contentMode:UIViewContentModeScaleAspectFit];
            roundImg = [roundImg imageByRoundCornerRadius:roundImg.size.width/2];
            
            [cell.iconImageBTn setImage:roundImg forState:UIControlStateNormal];
            UIView *view = [self.InMobiNativeAdIcon primaryViewOfWidth:25];
            view.frame = CGRectMake(0, 0, 1, 1);
            [cell addSubview:view];
        }
    }
    __weak typeof(self) wkSelf = self;
    cell.clickBtnBlock = ^(NSIndexPath *cellIndexPath) {
        [wkSelf collectionView:collectionView didSelectItemAtIndexPath:cellIndexPath];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SettingModel *model = self.dataSource[indexPath.item];
    [self performSelector:NSSelectorFromString(model.selName) withObject:nil afterDelay:0];
    
}
#pragma mark -- tableView的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.aboutDataSource[indexPath.row];
    return cell;
}
-(UIView *)aboutHeaderView
{
    if (!_aboutHeaderView) {
        UIView *header = [[[NSBundle mainBundle]loadNibNamed:@"SettingAboutHeaderFooterView" owner:self options:nil]firstObject];
        header.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reportBug:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 5;
        [header addGestureRecognizer:tap];
        _aboutHeaderView = header;
    }
    return _aboutHeaderView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.aboutHeaderView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[[NSBundle mainBundle]loadNibNamed:@"SettingAboutHeaderFooterView" owner:self options:nil]lastObject];
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55;
}

#pragma mark -- 点击方法
-(void)onBgnClick{
    
}
-(void)onEffectClick{
    if (self.effectClickBlock) {
        self.effectClickBlock();
    }
}
-(void)onBuyClick{
    [self initIAP];
}
-(void)onConnectClick{
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    if (!mailCompose) {
//        CoreSVPCenterMsg(@"无法发送邮件！");
        return;
    }
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"jumper report"];
    // 设置收件人
    [mailCompose setToRecipients:@[@"hopjumpgame@hotmail.com"]];

    NSString *mailBody = [NSString stringWithFormat:@"</br></br></br></br> iOS %.2f, jumper v%@ ",[UIDevice systemVersion],[UIApplication sharedApplication].appVersion];
    [mailCompose setMessageBody:mailBody isHTML:YES];
   
    [self presentViewController:mailCompose animated:YES completion:nil];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
-(void)onAboutClick{
    self.collctionViewLeadingConst.constant = - YYScreenSize().width;
    [self.view setNeedsLayout];
    [self.closeBtn setImage:[UIImage imageNamed:@"settingback_btn"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)onNotiClick{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
}
-(void)onADIconClick{
    [self.InMobiNativeAdIcon reportAdClickAndOpenLandingPage];
//    if ([self.InMobiNativeAdIcon isReady]) {
//        [self.InMobiNativeAdIcon reportAdClickAndOpenLandingPage];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark -- IAP

-(void)initIAP{

    NSSet* dataSet = [[NSSet alloc] initWithObjects:@"1",nil];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    CoreSVPLoading(@"wait..", NO);
    [FIRAnalytics logEventWithName:@"永久去广告" parameters:@{@"状态":@0}];
    [IAPShare sharedHelper].iap.production = NO;
    __weak typeof(self)wkSelf = self;
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if (response.products.count>0) {
             [response.products enumerateObjectsUsingBlock:^(SKProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if ([obj.productIdentifier isEqualToString:@"1"]) {
                     [wkSelf buyProduct:response.products.firstObject];
                     *stop = YES;
                 }
                 if (obj== response.products.lastObject && *stop != YES) {
                     [CoreSVP dismiss];
                     CoreSVPCenterMsg(@"无产品信息！");
                 }
             }];
         }else{
             [CoreSVP dismiss];
             CoreSVPCenterMsg(@"无产品信息！");
         }
     }];
}
-(void)buyProduct:(SKProduct*)product{
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
                                       [FIRAnalytics logEventWithName:@"永久去广告" parameters:@{@"状态":@1}];
                                       [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                       DDLogInfo(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Successful purchase！", nil));
                                       [wkSelf iapSucessedWithProduct:product];
                                       /*
                                       CoreSVPLoading(@"验证购买结果..", NO);
                                       [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"your sharesecret" onCompletion:^(NSString *response, NSError *error) {
                                           
                                           //Convert JSON String to NSDictionary
                                           NSDictionary* rec = [IAPShare toJSON:response];
                                           
                                           if([rec[@"status"] integerValue]==0)
                                           {
                                               [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                               DDLogInfo(@"SUCCESS %@",response);
                                               DDLogInfo(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                               [CoreSVP dismiss];
                                               CoreSVPCenterMsg(NSLocalizedString(@"Successful purchase！", nil));
                                               [self iapSucessedWithProduct:product];
                                           }
                                           else {
                                               DDLogError(@"Fail");
                                               [CoreSVP dismiss];
                                               CoreSVPCenterMsg(@"经验证购买无效！");
                                           }
                                       }];
                                        */
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Failed purchase", nil));
                                       DDLogError(@"Fail");
                                   }
                               }];//end of buy product
    
}
-(void)iapSucessedWithProduct:(SKProduct *)product{
    [WealthManager defaultManager] .removedAD = YES;
}

-(void)reportBug:(UITapGestureRecognizer *)tap{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    if (!mailCompose) {
        return;
    }
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"Hop Jump Crash report"];
    // 设置收件人
    [mailCompose setToRecipients:@[@"xueyongwei@eoemarket.com"]];
    
    NSString *mailBody = [NSString stringWithFormat:@"</br></br></br></br>Using '%@(v%@)' on my %@ (iOS %.2f).",@"Hop Jump",[UIApplication sharedApplication].appVersion,[UIDevice currentDevice].machineModelName,[UIDevice systemVersion]];
    [mailCompose setMessageBody:mailBody isHTML:YES];
    
    NSString *errorLogPath = [NSString stringWithFormat:@"%@/Documents/error.log", NSHomeDirectory()];
    NSData *pdf = [NSData dataWithContentsOfFile:errorLogPath];
    if (pdf) {
        [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"crash.data"];
    }
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
    
}


#pragma mark - IMNative Delegate

/*The native ad notifies its delegate that it is ready. Fetching publisher-specific ad asset content from native.adContent. The publisher will specify the format. If the publisher does not provide a format, no ad will be loaded.*/
-(void)nativeDidFinishLoading:(IMNative*)native{
    SettingModel *model = [SettingModel settingModelWithTitle:native.adTitle ImgName:nil];
    model.selName = @"onADIconClick";
    [_dataSource insertObject:model atIndex:4];
//    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:4 inSection:0]]];
    [self.collectionView reloadData];
}
/*The native ad notifies its delegate that an error has been encountered while trying to load the ad.Check IMRequestStatus.h for all possible errors.Try loading the ad again, later.*/
-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error{
    NSLog(@"Native Ad load Failed");
}
/* Indicates that the native ad is going to present a screen. */ -(void)nativeWillPresentScreen:(IMNative*)native{
    NSLog(@"Native Ad will present screen"); //Full Screen experience
}
/* Indicates that the native ad has presented a screen. */
-(void)nativeDidPresentScreen:(IMNative*)native{
    NSLog(@"Native Ad did present screen"); //Full Screen experience
}
/* Indicates that the native ad is going to dismiss the presented screen. */
-(void)nativeWillDismissScreen:(IMNative*)native{
    NSLog(@"Native Ad will dismiss screen"); //Full Screen experience
}
/* Indicates that the native ad has dismissed the presented screen. */
-(void)nativeDidDismissScreen:(IMNative*)native{
    NSLog(@"Native Ad did dismiss screen"); //Full Screen experience
}
/* Indicates that the user will leave the app. */
-(void)userWillLeaveApplicationFromNative:(IMNative*)native{
    NSLog(@"User leave"); //CTA External
}

-(void)native:(IMNative *)native didInteractWithParams:(NSDictionary *)params{
    NSLog(@"User clicked the ad"); // Click Counting
    
    [native recyclePrimaryView];
    native.delegate = nil;
    [_dataSource removeObjectAtIndex:4];
    
    [self requestInmobiNativeAds];
}

-(void)nativeAdImpressed:(IMNative *)native{
    NSLog(@"Impression was counted"); // Impression Counting
}

-(void)native:(IMNative *)native rewardActionCompletedWithRewards:(NSDictionary *)rewards{
    NSLog(@"User can be rewarded"); //Rewarded
}
/**
 * Notifies the delegate that the native ad has finished playing media.
 */
-(void)nativeDidFinishPlayingMedia:(IMNative*)native{
    NSLog(@"The Video has finished playing");
    //PreRoll Use Case
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
