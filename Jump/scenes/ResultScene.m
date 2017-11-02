//
//  ResultScene.m
//  testGame
//
//  Created by xueyognwei on 2017/6/26.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "ResultScene.h"
#import "JumpScene.h"
#import "StartScene.h"
#import "UserDefaultManager.h"
#import "WealthManager.h"
#import "GameCenterManager.h"
#import "CustomActivity.h"
#import <IAPShare.h>
#import "GetDiamodAlertView.h"
#import "ShareContentViewController.h"
#import "UIImage+Cut.h"
#import "XYWALertViewController.h"
#import "StoreAlertWithImgAndTextView.h"
#import "RewardVideoManager.h"
@interface ResultScene() <GADInterstitialDelegate>
@property (nonatomic,assign) BOOL canReceiveDiamondAndNotReceive;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic,strong)UIImage *bgColorsImage;
@property (nonatomic,assign) BOOL newRecord;
@end

@implementation ResultScene
{
    NSInteger _earnGodCions;
    NSInteger _score;
    BOOL _beRewarded;
    SKLabelNode *_videoLabel;
}
/**
 初始化结束时的界面
 
 @param size 大小
 @param won 是否突破新纪录赢得奖励
 @param source 分数
 @return 实例
 */
-(instancetype)initWithSize:(CGSize)size won:(BOOL)won source:(NSInteger)source
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _score = source;
        [self initUIWithwin:won andSource:source];
    }
    return self;
}
-(instancetype)initWithSize:(CGSize)size won:(BOOL)won source:(NSInteger)source goldIcon:(NSInteger)goldIcons bgColorsImage:(UIImage *)bgColorsImage{
    if (self = [super initWithSize:size]) {
//        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
//        self.backgroundColor = []
        _score = source;
        _earnGodCions = goldIcons;
        _bgColorsImage = bgColorsImage;
        [self initUIWithwin:won andSource:source];
    }
    return self;
}
-(void)didMoveToView:(SKView *)view
{
    if (![[WealthManager defaultManager] removedAD]) {//还没有移除广告
        if ([UserDefaultManager canResultShowAD]) {
            [self loadInsertAD];
        }
    }
}
-(void)dealloc
{
    [CoreSVP dismiss];
}

/**
 尝试显示一个插屏广告
 */
-(void)tryShowInsertAD{
    if ([UserDefaultManager canResultShowAD]) {
        __weak typeof(self) wkSelf = self;
        [[RewardVideoManager defaultManager ]showRewardVideoInViewController:wkSelf.viewController canSkip:YES Finished:nil error:^(NSString *message) {
            CoreSVPCenterMsg(message);
        }];
        /*
        self.interstitial = [[GADInterstitial alloc]
                             initWithAdUnitID:@"ca-app-pub-5418531632506073/7560857419"];
        self.interstitial.delegate = self;
        GADRequest *request = [GADRequest request];
        
//        request.testDevices = @[ @"1a0d2fc39522a82f72bfc130b3f788ba" ];
        [self.interstitial loadRequest:request];
         */
    }
    
}
//-(void)setCanReceiveDiamondAndNotReceive:(BOOL)canReceiveDiamondAndNotReceive
//{
//    _canReceiveDiamondAndNotReceive = canReceiveDiamondAndNotReceive;
//    [[NSUserDefaults standardUserDefaults] setBool:canReceiveDiamondAndNotReceive forKey:@"canReceiveDiamondAndNotReceive"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"canReceiveDiamondAndNotReceiveDate"];
//}

-(void)initUIWithwin:(BOOL)won andSource:(NSInteger)source{
    
    NSInteger maxScore = [UserDefaultManager maxScore];
    //1 Add a result label to the middle of screen
    //添加背景
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:self.bgColorsImage]];
    bgNode.color = [SKColor blackColor];
    bgNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    bgNode.colorBlendFactor = 0.5;
    bgNode.size = self.size;
    [self addChild:bgNode];
    //分数label
    SKLabelNode *sourceLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengtecuyuan"];
    sourceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    sourceLabel.text = [NSString stringWithFormat:@"%ld",(long)source];
    sourceLabel.fontSize = 60;
    sourceLabel.fontColor = [SKColor whiteColor];
    sourceLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height*(1-0.157));
    [self addChild:sourceLabel];
    self.newRecord =source>maxScore;
    if (self.newRecord) {//新纪录
        SKSpriteNode *newRecordNode = [SKSpriteNode spriteNodeWithImageNamed:@"resultNew"];
        newRecordNode.name = @"newRecord";
        newRecordNode.position = CGPointMake(sourceLabel.frame.origin.x+sourceLabel.frame.size.width/2+newRecordNode.size.width, sourceLabel.frame.origin.y+sourceLabel.frame.size.height/2+newRecordNode.size.height);
        [self addChild:newRecordNode];
    }
    
    //历史最佳
    SKLabelNode *localShowLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    localShowLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    localShowLabel.text = NSLocalizedString(@"Highest Score", nil);
    localShowLabel.fontSize = 14;
            localShowLabel.fontColor = [SKColor colorWithHexString:@"4fc2f8"];
    localShowLabel.position = CGPointMake(CGRectGetMidX(self.frame),sourceLabel.position.y-sourceLabel.frame.size.height/2-20-localShowLabel.frame.size.height/2);
    [self addChild:localShowLabel];
    //左分割线
    CGFloat eachLineWidth = (self.size.width - localShowLabel.frame.size.width - 45 -30)/2;
    SKSpriteNode *leftLine = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHexString:@"4fc2f8"] size:CGSizeMake(eachLineWidth, 1)];
    leftLine.position = CGPointMake(25+eachLineWidth/2, localShowLabel.position.y);
    [self addChild:leftLine];
    //右分割线
    SKSpriteNode *rightLine = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHexString:@"4fc2f8"] size:CGSizeMake(eachLineWidth, 1)];
    rightLine.position = CGPointMake(self.size.width - 25 -eachLineWidth/2, localShowLabel.position.y);
    [self addChild:rightLine];
    //最高分
    SKLabelNode *maxSourceLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    maxSourceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    if (maxScore>0) {//有记录，显示最高分
        maxSourceLabel.text = [NSString stringWithFormat:@"%ld",(long)maxScore];
    }else{
        maxSourceLabel.text = [NSString stringWithFormat:@"%ld",(long)source];
    }
    maxSourceLabel.fontSize = 22;
    maxSourceLabel.fontColor = [SKColor whiteColor];
    maxSourceLabel.position = CGPointMake(CGRectGetMidX(self.frame), localShowLabel.position.y -localShowLabel.frame.size.height/2-15-maxSourceLabel.frame.size.height/2);
    [self addChild:maxSourceLabel];
    
    
    //中间翻倍金币虚线框
    CGSize goldIconSize = CGSizeMake(self.size.width*0.565, self.size.height*0.11);
//    SKTexture *bgTexture = [SKTexture textureWithImage:txtImg];
    UIImage *image =[UIImage imageNamed:@"result虚线"];
    SKTexture *bgTexture = [self textureWithImage:image tiledForSize:goldIconSize withCapInsets:UIEdgeInsetsMake(image.size.width*0.35, image.size.height*0.35, image.size.width*0.35, image.size.height*0.35)];
    SKSpriteNode *GoldIconbgNode = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    GoldIconbgNode.color = [SKColor whiteColor];
    GoldIconbgNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    GoldIconbgNode.colorBlendFactor = 0.5;
    GoldIconbgNode.size = goldIconSize;
    [self addChild:GoldIconbgNode];
    //金币icon
    SKSpriteNode *godIconNode = [SKSpriteNode spriteNodeWithImageNamed:@"result金币icon"];
    godIconNode.size = CGSizeMake(34, 34);
    godIconNode.position = CGPointMake( GoldIconbgNode.position.x - GoldIconbgNode.size.width/2 +10 + godIconNode.size.width/2, GoldIconbgNode.position.y);
    [self addChild:godIconNode];
    //金币数
    SKLabelNode *godNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    godNumberLabel .name = @"godNumberLabel";
    godNumberLabel.verticalAlignmentMode  = SKLabelVerticalAlignmentModeCenter;
    godNumberLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    godNumberLabel.text = [NSString stringWithFormat:@"+%ld",(long)_earnGodCions];
    godNumberLabel.fontSize = 20;
    godNumberLabel.fontColor = [UIColor colorWithHexString:@"fbb31e"];
    godNumberLabel.position = CGPointMake(godIconNode.position.x+godIconNode.size.width/2+5, godIconNode.position.y);
    [self addChild:godNumberLabel];
    //金币翻倍icon
    SKSpriteNode *VideoIconNode = [SKSpriteNode spriteNodeWithImageNamed:@"result观看广告btn"];
    VideoIconNode.name = @"VideoIconNode";
    VideoIconNode.size = CGSizeMake(73, 53);
    VideoIconNode.color = [SKColor blackColor];
    VideoIconNode.position = CGPointMake( GoldIconbgNode.position.x + GoldIconbgNode.size.width/2 - 10 - VideoIconNode.size.width/2, GoldIconbgNode.position.y);
    [self addChild:VideoIconNode];
    //金币翻倍label
    SKLabelNode *videoLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    videoLabel.verticalAlignmentMode  = SKLabelVerticalAlignmentModeCenter;
    videoLabel.name = @"videoLabelNode";
    videoLabel.text = NSLocalizedString(@"Gold Doubles", nil);
    videoLabel.fontSize = 11;
    videoLabel.fontColor = [UIColor colorWithHexString:@"4fc2f8"];
    videoLabel.position = CGPointMake(0, -videoLabel.frame.size.height/2-5);
    _videoLabel = videoLabel;
    [VideoIconNode addChild:videoLabel];
    
    SKSpriteNode *retryIconNode = [SKSpriteNode spriteNodeWithImageNamed:@"result重新开始icon"];
    retryIconNode.name = @"retryGame";
    
    CGFloat retryWidth = self.size.height * 0.2;
    retryIconNode.size = CGSizeMake(retryWidth, retryWidth);
//    retryIconNode.color = [SKColor blackColor];
    retryIconNode.position = CGPointMake( GoldIconbgNode.position.x, self.size.height*0.326 );
    [self addChild:retryIconNode];
    
    
    //底部选项
    SKSpriteNode *itemHome = [SKSpriteNode spriteNodeWithImageNamed:@"result首页icon"];
    itemHome.position = CGPointMake(self.size.width*0.25, self.size.height*0.105);
    itemHome.name = @"goHome";
    [self addChild:itemHome];
    SKLabelNode *homeLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    homeLabel.name = @"goHome";
    homeLabel.text = NSLocalizedString(@"Home", nil);
    homeLabel.fontSize = 11;
    homeLabel.fontColor = [SKColor colorWithHexString:@"ffffff"];
    homeLabel.position = CGPointMake(itemHome.position.x, itemHome.position.y -itemHome.size.height/2 - 5 -homeLabel.frame.size.height/2);
    [self addChild:homeLabel];
    
    //移除广告
    if (![[WealthManager defaultManager] removedAD]) {//还没有移除广告
        SKSpriteNode *itemRemoveAD = [SKSpriteNode spriteNodeWithImageNamed:@"result去广告icon"];
        itemRemoveAD.name = @"removeAD";
        itemRemoveAD.position = CGPointMake(self.size.width/2, self.size.height*0.105);
        [self addChild:itemRemoveAD];
        
        SKLabelNode *removeLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
        removeLabel.name = @"removeLabel";
        removeLabel.text = NSLocalizedString(@"Remove ads", nil);
        removeLabel.fontSize = 11;
        removeLabel.fontColor = [SKColor colorWithHexString:@"ffffff"];
        removeLabel.position = CGPointMake(itemRemoveAD.position.x, itemRemoveAD.position.y -itemRemoveAD.size.height/2 - 5 -removeLabel.frame.size.height/2);
        [self addChild:removeLabel];
        //初始化翻倍金币的广告
         [self initRewardVideo];
    }
    //分享
    NSString *shareImageName = @"result分享icon";
    BOOL demond = [self newRecordToady];
    if (demond) {
        shareImageName = @"result分享-钻icon";
        _canReceiveDiamondAndNotReceive = YES;
    }
    SKSpriteNode *itemShare = [SKSpriteNode spriteNodeWithImageNamed:shareImageName];
    itemShare.name = @"itemShare";
    itemShare.position = CGPointMake(self.size.width*(1-0.25), self.size.height*0.105);
    [self addChild:itemShare];
    SKLabelNode *shareLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    shareLabel.name = @"shareLabel";
    
    shareLabel.text = demond?NSLocalizedString(@"Share New Record", nil):NSLocalizedString(@"Share", nil);
    shareLabel.fontSize = 11;
    shareLabel.fontColor = [SKColor colorWithHexString:@"ffffff"];
    shareLabel.position = CGPointMake(itemShare.position.x, itemShare.position.y -itemShare.size.height/2 - 5 -shareLabel.frame.size.height/2);
    [self addChild:shareLabel];
    //同步本地分数
    [self updateNewScore];
}
-(SKTexture *)textureWithImage:(UIImage *)image tiledForSize:(CGSize)size withCapInsets:(UIEdgeInsets)capInsets{
    //get resizable image
    image =  [image resizableImageWithCapInsets:capInsets];
    //redraw image to target size
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [image drawInRect:CGRectMake(0, 0, size.width-1, size.height-1)];
    [[UIColor clearColor] setFill];
    //get target image
    UIImage *ResultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // get texture
    SKTexture * texture = [SKTexture textureWithImage:ResultImage];
    return texture;
}
/**
 请求插屏广告
 */
-(void)loadInsertAD{
     [self tryShowInsertAD];
}
/**
 更新最新分数
 */
-(void)updateNewScore{
    //上传到gc
    [[GameCenterManager sharedManager] saveAndReportScore:_score leaderboard:@"jumperHighest" sortOrder:GameCenterSortOrderHighToLow];
    //同步本地分数
    [UserDefaultManager updataNewScore:_score];
}


/**
 是否今天首次打破纪录

 @return 是否
 */
-(BOOL)newRecordToady{
    if ([UserDefaultManager maxScore]<_score) {//突破记录了
        if ([[WealthManager defaultManager].rcvShareRewardDate isToday]) {//今天领取过了
            return NO;
        }
//        if ([[UserDefaultManager maxScoreDate] isToday]) {
//            return NO;
//        }
        return  YES;
    }
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    if ([node.name isEqualToString:@"retryGame"]) {
        [self changeToGameScene];
    }else if ([node.name isEqualToString:@"goHome"]){
        [self goHomeScene];
    }else if ([node.name isEqualToString:@"VideoIconNode"]||[node.name isEqualToString:@"videoLabelNode"]){//金币翻倍，看视频
        if (!_beRewarded) {
            [FIRAnalytics logEventWithName:@"观看广告" parameters:@{@"用途":@"金币翻倍",@"状态":@0}];
            [self requestRewardedVideo];
        }
    }else if ([node.name isEqualToString:@"removeAD"]){//永久移除广告
        [self initIAP];
    }else if ([node.name isEqualToString:@"itemShare"]){//分享战绩
        [self shareMyScore];
    }
}

-(void)goHomeScene
{
    StartScene *start = [StartScene sceneWithSize:self.size];
    SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:0.3];
    start.backgroundColor = [UIColor darkGrayColor];
    [self.scene.view presentScene:start transition:reveal];
}

-(void) changeToGameScene
{
    JumpScene *ms = [JumpScene sceneWithSize:self.size];
    [ms customUI];
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:0.3];
    ms.backgroundColor = [UIColor whiteColor];
    [self.scene.view presentScene:ms transition:reveal];
}
#pragma mark -- IAP

-(void)initIAP{
    [FIRAnalytics logEventWithName:@"永久去广告" parameters:@{@"状态":@0}];
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:@"1",nil];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    CoreSVPLoading(@"wait..", NO);
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
                     CoreSVPCenterMsg(@"no message！");
                 }
             }];
         }else{
             [CoreSVP dismiss];
             CoreSVPCenterMsg(@"no message！");
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
    [WealthManager defaultManager].removedAD = YES;
    [self removeRemoveADNode];
}
-(void)removeRemoveADNode{
    SKAction *a1 = [SKAction scaleXTo:1.1 y:1.1 duration:0.1];
    SKAction *a2 = [SKAction scaleXTo:0.1 y:0.1 duration:0.2];
    SKAction *d = [SKAction removeFromParent];
    SKAction *removeAction = [SKAction sequence:@[a1,a2,d]];
    SKNode *removeNode = [self childNodeWithName:@"removeAD"];
    SKNode *removeLabel = [self childNodeWithName:@"removeLabel"];
    [removeNode runAction:removeAction];
    [removeLabel runAction:removeAction];
}
#pragma mark -- 广告
-(void)initRewardVideo{
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    //    [self requestRewardedVideo];
    
}
- (void)requestRewardedVideo {
    __weak typeof(self) wkSelf = self;
    [[RewardVideoManager defaultManager ] showRewardVideoInViewController:wkSelf.viewController Finished:^(UnityAdsFinishState state) {
        if (state == kUnityAdsFinishStateCompleted) {
            [wkSelf rewardVideoFinished];
        }
    } error:^(NSString *message) {
        CoreSVPCenterMsg(message);
    }];
    /*
    if (![[GADRewardBasedVideoAd sharedInstance] isReady]) {
        CoreSVPLoading(@"loading..", NO);
        [GADRewardBasedVideoAd sharedInstance].delegate = self;
        GADRequest *request = [GADRequest request];
//        request.testDevices = @[ @"1a0d2fc39522a82f72bfc130b3f788ba" ];
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                               withAdUnitID:@"ca-app-pub-5418531632506073/7560857419"];
    }
     */
}
- (void)showVideo{
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self.view.viewController];
    } else {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
}
#pragma mark -- 分享
-(void)shareMyScore{
    CoreSVPLoading(nil, NO);
    BOOL newRecord = [self childNodeWithName:@"newRecord"] != nil;
    NSString *typeName = newRecord?@"新纪录":@"普通";
    [FIRAnalytics logEventWithName:@"分享" parameters:@{@"类型": typeName,@"状态":@0}];
    NSString *textToShare = NSLocalizedString(@"Hop or Jump，Survival or Death", nil);
    ShareContentViewController *shareVC = [[ShareContentViewController alloc]initWithNibName:@"ShareContentViewController" bundle:nil];
    shareVC.view.frame = self.view.bounds;
    [self.view.viewController addChildViewController:shareVC];
    shareVC.score = _score;
    shareVC.newRecord = self.newRecord;
    UIImage *imageToShare = [UIImage cutFromView:shareVC.view];
//    UIImage *imageToShare = [UIImage imageNamed:@"呆毛"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/app/id1259722147"];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    //自定义 customActivity继承于UIActivity,创建自定义的Activity加在数组Activities中。
//    NSURL *evaluateURl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1259722147"];
//    CustomActivity * custom = [[CustomActivity alloc] initWithTitie:@"去给好评" withActivityImage:[UIImage imageNamed:@"呆毛"] withUrl:evaluateURl withType:@"customActivity" withShareContext:activityItems];
//    NSArray *activities = @[custom];
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
                                         ,UIActivityTypeAssignToContact];
    
    //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
    __weak typeof(self) wkSelf = self;
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
             [FIRAnalytics logEventWithName:@"分享" parameters:@{@"类型": typeName,@"状态":@1}];
            if (_canReceiveDiamondAndNotReceive) {
                [wkSelf shareDidSucess];
            }else{
                CoreSVPCenterMsg(NSLocalizedString(@"Share successfully", nil));
            }
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
-(SKAction *)newBuySucessEffectSoundAction{
    SKAction *ac = [SKAction playSoundFileNamed:@"buySucess.caf" waitForCompletion:NO];
    return ac;
}
-(void)shareDidSucess{
    _canReceiveDiamondAndNotReceive = NO;
    
    SKSpriteNode *shareItem = (SKSpriteNode *)[self childNodeWithName:@"itemShare"];
    shareItem.texture = [SKTexture textureWithImageNamed:@"result分享icon"];
    SKLabelNode *shareLabel = (SKLabelNode *)[self childNodeWithName:@"shareLabel"];
    shareLabel.text = NSLocalizedString(@"Share", nil);
    //分享成功增加3个钻石
    [[WealthManager defaultManager] didReceivedShareReward];
    if (![UserDefaultManager isSoundEffectClose]) {
        [self runAction:[self newBuySucessEffectSoundAction]];
    }
    __weak UIViewController *wkSelf = self.view.viewController;
    [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        //        view.imgView.image = [UIImage imageNamed:@"store金币兑换"];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"Share successfully", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
        [text appendString:@"\n\n"];
        
        NSAttributedString *youget = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"You got ", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];;
        [text appendAttributedString:youget];
        
        NSString *dimond = [NSLocalizedString(@"Diamond", nil) stringByAppendingString:@"X3"];
        NSAttributedString *atText = [[NSAttributedString alloc]initWithString:dimond attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"fbb31e"]}];
        
        [text appendAttributedString:atText];
        
        //        NSString *text = [NSLocalizedString(@"Get %@?", nil) stringByReplacingOccurrencesOfString:@"%@" withString:skillModel.title];
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
//    GetDiamodAlertView *al = [[[NSBundle mainBundle]loadNibNamed:@"GetDiamodAlertView" owner:self options:nil]lastObject];
//    al.frame = CGRectMake(0, 0, self.view.size.width, self.view.size.height);
//    [self.view addSubview:al];
//    [al animateShow];
    
}
#pragma mark -- GADRewardBasedVideoAdDelegate implementation
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    [CoreSVP dismiss];
    CoreSVPCenterMsg(@"Reward video ad failed to load");
    NSLog(@"Reward based video ad failed to load.%@",error.localizedDescription);
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received.");
    [CoreSVP dismiss];
    [self showVideo];
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
    
    
    //    [self goOnGameAfterSec:3];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    
    [self rewardVideoFinished];
}
#pragma mark -- GADInterstitial 代理
/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
    [ad presentFromRootViewController:self.view.viewController];
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}


-(void)rewardVideoFinished{
    _videoLabel.text = NSLocalizedString(@"Successful", nil);
    SKSpriteNode *videoNode = (SKSpriteNode *)[self childNodeWithName:@"VideoIconNode"];
    videoNode.colorBlendFactor = 0.5;
    SKLabelNode *godlabel = (SKLabelNode *)[self childNodeWithName:@"godNumberLabel"];
    godlabel.text = [NSString stringWithFormat:@"+%ldX2!",(long)_earnGodCions];
    if (YYScreenSize().width<750) {
        godlabel.fontSize = 14;
    }
    [WealthManager defaultManager] .goldCoinAmount += _earnGodCions;
    _beRewarded = YES;
    [FIRAnalytics logEventWithName:@"观看广告" parameters:@{@"用途":@"金币翻倍",@"状态":@1}];
}
@end
