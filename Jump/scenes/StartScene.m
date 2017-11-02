//
//  StartScene.m
//  Jump
//
//  Created by xueyognwei on 2017/6/28.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "StartScene.h"
#import "JumpScene.h"

#import "SettingView.h"
#import "GuideView.h"
#import "GameCenterManager.h"
#import "XYWVersonManager.h"

#import "StoreViewController.h"
#import "WealthManager.h"
#import "SKBaseScene+Actions.h"
#import "SetingViewController.h"
#import "NSTimerManager.h"
#import "XYWALertViewController.h"
#import "StoreAlertWithImgAndTextView.h"
#import "JumperRolesViewController.h"
#import "JumperRoleManager.h"
//#import "GetDiamodAlertView.h"
//#import "GetDimodAlertView.h"
#import <IAPShare.h>
@interface StartScene()
@property (nonatomic,strong) SKSpriteNode *jumper;
@end
@implementation StartScene
{
    JumpScene *_gameJumpeScene;
    CGPoint _jumperStartPoint;
    SKSpriteNode *tmp;
}
-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0, 0);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customWealth) name:kWealthChangedNoti object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCutDownLabel) name:kGlobleTimerNoti object:nil];
    }
    return self;
}
-(SKAction *)tapZoomAction
{
    if (!_tapZoomAction) {
        _tapZoomAction = [self newStepBigOnceAction];
    }
    return _tapZoomAction;
}
-(SKAction *)jumperDuangAction
{
    if (!_jumperDuangAction) {
        _jumperDuangAction = [self jumperAction];
    }
    return _jumperDuangAction;
}
-(void)didMoveToView:(SKView *)view
{
    [self customUI];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)customUI
{
    //背景图片
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"homebg"];
    bgNode.name = @"bgNode";
    bgNode.size = self.size;
    bgNode.anchorPoint = CGPointZero;
    [self addChild:bgNode];
    //游戏名字
    SKLabelNode *appNameLabel = [[SKLabelNode alloc]initWithFontNamed:@"changchengtecuyuan"];
    appNameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    appNameLabel.name = @"appNameLabel";
//    appNameLabel.text = NSLocalizedString(@"hop jump", nil);
    appNameLabel.text = @"HOP JUMP";
    appNameLabel.fontSize = YYScreenScale()==3?75:70;
    appNameLabel.fontColor = [SKColor whiteColor];
    appNameLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        self.size.height*0.65);
//    SKAction *ac = [SKAction actionNamed:@"repeatZoom1.2"];
//    [appNameLabel runAction:ac];
    [self addChild:appNameLabel];
    
    //点击 开始
    SKLabelNode *tapScreenLabel = [[SKLabelNode alloc]initWithFontNamed:@"changchengteyuanti"];
    tapScreenLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    tapScreenLabel.name = @"StartLabel";
    tapScreenLabel.text = NSLocalizedString(@"Click on Screen", nil);
    tapScreenLabel.fontSize = 20;
    tapScreenLabel.fontColor = [SKColor whiteColor];
    tapScreenLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame));
    [tapScreenLabel runAction:[SKAction actionNamed:@"repeatZoom1.2"]];
    [self addChild:tapScreenLabel];
    
    SKLabelNode *startLabel = [[SKLabelNode alloc]initWithFontNamed:@"changchengteyuanti"];
    tapScreenLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    startLabel.name = @"StartLabel";
    startLabel.text = NSLocalizedString(@"Start Game", nil);
    startLabel.fontSize = 20;
    startLabel.fontColor = [SKColor whiteColor];
    startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame)-tapScreenLabel.frame.size.height);
    
    [self addChild:startLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [startLabel runAction:[SKAction actionNamed:@"repeatZoom1.2"]];
    });
    
    
    //角色
    [self customJumper];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self customItems];
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self customWealth];
        [self customRoleChange];
    });
    
}

-(void)customJumper{
    if (self.jumper) {
        [self.jumper removeFromParent];
    }
    JumperRoleModel *currentModel = [JumperRoleManager shareManager].curntJumperRoleModel;
    
    UIImage *jumperImage = [UIImage imageNamed:currentModel.jumperPic];
    SKSpriteNode *jumper = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:jumperImage]];
    jumper.name = @"jumper";
//    CGFloat jumperRatio = jumperImage.size.width/jumperImage.size.height;
//    CGFloat jumperWidth = self.size.width *0.2;
//    jumper.size = CGSizeMake(jumperWidth, jumperWidth/jumperRatio);
    jumper.anchorPoint = CGPointMake(0.5, 0);
    jumper.position = CGPointMake(self.size.width/2, self.size.height*0.195);
    _jumperStartPoint = jumper.position;
    [self addChild:jumper];
    tmp = _jumper;
    self.jumper = jumper;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self jumperBegainJump];
    });
}
/**
 开始跳动
 */
-(void)jumperBegainJump{
 
    SKSpriteNode *jumper = self.jumper;
    SKAction *m1 = [SKAction moveByX:0 y:50 duration:0.3];
    SKAction *act1 = [SKAction scaleXTo:1.0 y:1.1 duration:0.2];
    SKAction *mc1 = [SKAction group:@[m1,act1]];
    
    SKAction *w1 = [SKAction waitForDuration:0.1];
    
    SKAction *m2 = [SKAction moveByX:0 y:-50 duration:0.3];
    SKAction *act2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.2];
    SKAction *mc2 = [SKAction group:@[m2,act2]];
    
    SKAction *s1 = [SKAction sequence:@[mc1,w1,mc2]];
    
    SKAction *w2 = [SKAction waitForDuration:1];
    SKAction *g1 = [SKAction group:@[s1,w2]];
    if (![UserDefaultManager isSoundEffectClose]) {
        SKAction *v1 = [SKAction playSoundFileNamed:@"jump.caf" waitForCompletion:NO];
        g1 = [SKAction group:@[s1,v1,w2]];
    }
    
    //    SKAction *r1 = [SKAction rotateByAngle:0.08 duration:1.5];
    //
    //    SKAction *r2 = [r1 reversedAction];
    //    SKAction *s = [SKAction sequence:@[r1,r2]];
    
    [jumper runAction:[SKAction repeatActionForever:g1] withKey:@"jumperNormal"];
}

/**
 定义角色更换
 */
-(void)customRoleChange{
    
    SKSpriteNode *changeNode = (SKSpriteNode *)[self childNodeWithName:@"改变角色"];
    NSString *bgImgName = [UserDefaultManager shouldGuidChangeRole]?@"change_homeface_bg2":@"change_homeface_bg1";
    NSString *faceImgName = @"change_home兔子_face";
    
    if (!changeNode) {
        changeNode = [SKSpriteNode spriteNodeWithImageNamed:bgImgName];
        changeNode.name = @"改变角色bg";
        SKSpriteNode * faceNode = [SKSpriteNode spriteNodeWithImageNamed:faceImgName];
        faceNode.name = @"改变角色face";
        faceNode.position = CGPointMake(changeNode.size.width-faceNode.size.width/2-15, 10);
        [changeNode addChild:faceNode];
    }
    [changeNode setTexture:[SKTexture textureWithImageNamed:bgImgName]];
    changeNode.anchorPoint = CGPointMake(0, 0.5);
    changeNode.position = CGPointMake(0, YYScreenSize().height*0.83);
    [self addChild:changeNode];
    if ([UserDefaultManager shouldGuidChangeRole]) {
        SKAction *fac = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"change_homeface_bg1"],[SKTexture textureWithImageNamed:@"change_homeface_bg2"]] timePerFrame:0.5];
        SKAction *rp = [SKAction repeatActionForever:fac];
        [changeNode runAction: rp ];
    }
//    [SKSpriteNode spriteNodeWithImageNamed:NSLocalizedString(imgName, nil)];
//    menu1Node.anchorPoint = CGPointMake(0, 0.5);
//    menu1Node.position = CGPointMake(eachMeunWidth+eachMeunWidth*3*i, eachMeunHeight);
//    menu1Node.size = CGSizeMake(eachMeunWidth*2, eachMeunWidth*2);
//    menu1Node.name = showName;
//    menu1Node.color = [UIColor blackColor];
//    [self addChild:menu1Node];
}
/**
 定义财富视图
 */
-(void)customWealth{
    //钻石账户
    UIImage *diamondImage = [UIImage imageNamed:@"home钻石数值Add"];
    SKSpriteNode *diamondIconNode = (SKSpriteNode *)[self childNodeWithName:@"diamondIconNode"] ;
    if (!diamondIconNode) {
       diamondIconNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:diamondImage]];
        diamondIconNode.name = @"diamondIconNode";
        diamondIconNode.anchorPoint = CGPointMake(0, 0.5);
        diamondIconNode.centerRect = CGRectMake(0.5, 0, 0.1, 0.1);
        diamondIconNode.position = CGPointMake(15, self.size.height-15 - diamondIconNode.size.height/2);
        [self addChild:diamondIconNode];
    }
    
    SKLabelNode *diamondNumberLabel = (SKLabelNode *)[self childNodeWithName:@"diamondNumberLabel"] ;
    if (!diamondNumberLabel) {
        diamondNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
        diamondNumberLabel.name = @"diamondNumberLabel";
        diamondNumberLabel.fontSize = 14;
        diamondNumberLabel.fontColor = [UIColor colorWithHexString:@"333333"];
        diamondNumberLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        diamondNumberLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        diamondNumberLabel.position = CGPointMake(55, self.size.height-15 - diamondIconNode.size.height/2);
        
        diamondNumberLabel.fontColor = [SKColor blackColor];
        [self addChild:diamondNumberLabel];
    }
    
    diamondNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].diamondAmount];
    //改变图标的大小
    CGFloat diamondIconwidth = diamondNumberLabel.frame.size.width+diamondImage.size.width/2 + 20;
    diamondIconNode.xScale = diamondIconwidth/diamondImage.size.width;
    
    
    //金币账户
    UIImage *godImage = [UIImage imageNamed:@"home金币数值Add"];
    SKSpriteNode *godIconNode = (SKSpriteNode *)[self childNodeWithName:@"godIconNode"] ;
    if (!godIconNode) {
        godIconNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:godImage]];
        godIconNode.name = @"godIconNode";
        godIconNode.anchorPoint = CGPointMake(0, 0.5);
        godIconNode.centerRect = CGRectMake(0.45, 0, 0.2, 0.1);
        [self addChild:godIconNode];
    }
    //修正位置
    godIconNode.position = CGPointMake(30+diamondIconNode.size.width, self.size.height-15 - diamondIconNode.size.height/2);
    
    SKLabelNode *godNumberLabel = (SKLabelNode *)[self childNodeWithName:@"godNumberLabel"] ;
    if (!godNumberLabel) {
        godNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
        godNumberLabel.name = @"godNumberLabel";
        godNumberLabel.fontSize = 14;
        godNumberLabel.fontColor =[UIColor colorWithHexString:@"333333"];
        godNumberLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        godNumberLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        
        godNumberLabel.fontColor = [SKColor blackColor];
        [self addChild:godNumberLabel];
    }
    //修正位置
    godNumberLabel.position = CGPointMake(60+15 + diamondIconNode.size.width, self.size.height-15 - diamondIconNode.size.height/2);
    
    godNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].goldCoinAmount];;
    
    //改变图标的大小
    CGFloat godIconwidth = godNumberLabel.frame.size.width+godImage.size.width/2 + 20;
    godIconNode.xScale = godIconwidth/godImage.size.width;
    
}

/**
 定义选项按钮
 */
-(void)customItems{
    NSArray *imgNamesArr = @[@"home设置icon",@"home排名icon",@"home商店icon",@"home钻石icon"];
    NSArray *showNamesArr = @[@"设置",@"排行榜",@"商店",@"领奖"];
    NSInteger blockNumber = imgNamesArr.count*3+1;
    CGFloat eachMeunWidth = self.size.width/blockNumber;//每个选项的宽度
    CGFloat eachMeunHeight = self.size.height * 0.078;//每个选项的宽度
    
    
    for (NSInteger i = 0; i<imgNamesArr.count; i++) {
        NSString *imgName = imgNamesArr[i];
        NSString *showName = showNamesArr[i];
        
        SKSpriteNode *menu1Node = [SKSpriteNode spriteNodeWithImageNamed:NSLocalizedString(imgName, nil)];
        menu1Node.anchorPoint = CGPointMake(0, 0.5);
        menu1Node.position = CGPointMake(eachMeunWidth+eachMeunWidth*3*i, eachMeunHeight);
        menu1Node.size = CGSizeMake(eachMeunWidth*2, eachMeunWidth*2);
        menu1Node.name = showName;
        menu1Node.color = [UIColor blackColor];
        [self addChild:menu1Node];
        if (i == imgNamesArr.count -1) {//最后一个
            
            SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
            timeLabel.text = [[WealthManager defaultManager] formatCutDownString];
            timeLabel.fontSize = 14;
            timeLabel.name = showNamesArr.lastObject;
            timeLabel.fontColor = [SKColor whiteColor];
            timeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
            timeLabel.position = CGPointMake(menu1Node.position.x+menu1Node.size.width/2, menu1Node.position.y);
            [self addChild:timeLabel];
            self.cutDownLabel = timeLabel;
            [self updateCutDownLabel];
        }
    }
}

-(void)initJumperScene{
    _gameJumpeScene = [JumpScene sceneWithSize:self.size];
    [_gameJumpeScene customUI];
}
-(void)updateCutDownLabel{
    self.cutDownLabel.text = [[WealthManager defaultManager] formatCutDownString];
    
    SKSpriteNode *rewardNode = (SKSpriteNode *)[self childNodeWithName:@"领奖"];
    if ([WealthManager defaultManager].dailyRewardstate == DailyRewardStateCooled) {//冷却完毕可领取
        rewardNode.colorBlendFactor = 0.0;
        [rewardNode runAction:[self rewardCooledAction] withKey:@"rewardCooledAction"];
        [self waterOnRewardNode:rewardNode];
    }else{
        if ([rewardNode actionForKey:@"rewardCooledAction"]) {
            [rewardNode removeActionForKey:@"rewardCooledAction"];
            
            SKSpriteNode *node1 = (SKSpriteNode *)[rewardNode childNodeWithName:@"领奖node1"];
            [node1 removeFromParent];
            SKSpriteNode *node2 = (SKSpriteNode *)[rewardNode childNodeWithName:@"领奖node2"];
            [node2 removeFromParent];
        }
        rewardNode.colorBlendFactor = 0.5;
    }
}
-(void)waterOnRewardNode:(SKSpriteNode *)rewardNode{
    SKSpriteNode *node1 = (SKSpriteNode *)[rewardNode childNodeWithName:@"领奖node1"];
    
    if (!node1) {
        node1 = [SKSpriteNode spriteNodeWithImageNamed:@"水波纹_2"];
        node1.name = @"领奖node1";
        node1.position = CGPointMake(rewardNode.size.width/2, 0);
        node1.xScale = 0.7;
        node1.yScale = 0.7;
        [rewardNode addChild:node1];
        [node1 runAction:[self waterAction]];
    }
    
    SKSpriteNode *node2 = (SKSpriteNode *)[rewardNode childNodeWithName:@"领奖node2"];
    
    if (!node2) {
        node2 = [SKSpriteNode spriteNodeWithImageNamed:@"水波纹_2"];
        node2.name = @"领奖node2";
        node2.position = CGPointMake(rewardNode.size.width/2, 0);
        node2.xScale = 0.5;
        node2.yScale = 0.5;
        [rewardNode addChild:node2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [node2 runAction:[self waterAction]];
        });
        
    }
}
-(SKAction *)waterAction{
    //1
    SKAction *s1 = [SKAction scaleTo:1.0 duration:0.9];
    //2
    SKAction *s3 = [SKAction scaleTo:1.1 duration:0.099];
    SKAction *fot1 = [SKAction fadeOutWithDuration:0.099];
    SKAction *g2 = [SKAction group:@[s3,fot1]];
    //3
    SKAction *s2 = [SKAction scaleTo:0.5 duration:0.001];
    SKAction *fin1= [SKAction fadeInWithDuration:0.001];
    SKAction *g3 = [SKAction group:@[s2,fin1]];
    
    SKAction *g1 = [SKAction sequence:@[s1,g2,g3]];
    return [SKAction repeatActionForever:g1];
}
-(SKAction *)rewardCooledAction{
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"home钻石icon"];
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"home钻石icon_可领"];
    if (!(texture1&&texture2)) {
        NSAssert(0, @"rewardCooledAction texture have nil");
    }
    NSArray *textureArray = @[texture1,texture2];
    //爆炸效果动画
    SKAction *animationAction = [SKAction animateWithTextures:textureArray timePerFrame:0.5];
    SKAction *repeatAc = [SKAction repeatActionForever:animationAction];
    
    return repeatAc;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        if ([node.name isEqualToString:@"diamondIconNode"]||[node.name isEqualToString:@"godIconNode"]||[node.name isEqualToString:@"diamondNumberLabel"]||[node.name isEqualToString:@"godNumberLabel"] ) {
            [self openStoreViewController];
        }else if ([node.name isEqualToString:@"设置"]){
            
            [node runAction:self.tapZoomAction completion:^{
                [self alertSettingView];
            }];
        }else if ([node.name isEqualToString:@"排行榜"]){
            [node runAction:self.tapZoomAction completion:^{
                [FIRAnalytics logEventWithName:@"排行榜" parameters:@{@"操作":@"前往"}];
                [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self.viewController withLeaderboard:@"jumperHighest"];
            }];
        }else if ([node.name isEqualToString:@"商店"]){
            [node runAction:self.tapZoomAction completion:^{
                [self openStoreViewController];
            }];
        }else if ([node.name containsString:@"领奖"]){
            [node runAction:self.tapZoomAction completion:^{
                [self wannaGetDailyReward];
            }];
        }else if ([node.name isEqualToString:@"bgNode"]||[node.name isEqualToString:@"StartLabel"]){
            [self tryToStartGame];
        }else if ([node.name isEqualToString:@"jumper"]){
            [self tryToStartGame];
//            [node runAction:self.jumperDuangAction completion:^{
//                
//            }];
        }else if ([node.name hasPrefix:@"改变角色"]){
            [self openJumpersViewController];
        }
        else{
           
        }
    }
}
-(void)tryToStartGame{
//    if ([XYWVersonManager shareManager].lunchType != XYWVersonManagerLunchTypeNormal) {//只要不是普通启动，都显示引导
//        [self alertGUideView];
//    }else{
//        [self initJumperScene];
        [self changeToGameScene];
//    }
}


/**
 想领取一下今天的奖励哦
 */
-(void)wannaGetDailyReward{
    
    DailyRewardState state = [WealthManager defaultManager].dailyRewardstate;
    switch (state) {
        case DailyRewardStateCooled:
        {
            [WealthManager defaultManager].diamondAmount+=1;
            [[WealthManager defaultManager] didReceivedDailyReward];
            
            [self customWealth];
            [self alertReceiveDailyReward];
        }
            break;
        case DailyRewardStateCooling:
        {
            DDLogVerbose(@"RewardStateCooling");
        }
            break;
        case DailyRewardStateFinished:
        {
            DDLogVerbose(@"RewardStateFinished");
            CoreSVPCenterMsg(NSLocalizedString(@"Today 's diamonds have been all led away, come back tomorrow.", nil));
        }
            break;
        default:
            break;
    }
}

-(void)alertReceiveDailyReward{
    __weak UIViewController * wkSelf = self.viewController;
    if (![UserDefaultManager isSoundEffectClose]) {
        [self.jumper runAction:[self newBuySucessEffectSoundAction]];
    }
    
    [XYWALertViewController showContentOnWkVC:wkSelf addContentView:^(UIView *contentView) {
        StoreAlertWithImgAndTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"StoreAlertWithImgAndTextView" owner:self options:nil]lastObject];
        //        view.imgView.image = [UIImage imageNamed:@"store金币兑换"];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"Congratulations on getting", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
        [text appendString:@"\n\n"];
        
        
        NSString *dimond = [NSLocalizedString(@"Diamond", nil) stringByAppendingString:@"X1"];
        NSAttributedString *atText = [[NSAttributedString alloc]initWithString:dimond attributes:@{NSFontAttributeName:[UIFont fontWithName:@"changchengteyuanti" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"fa3d2a"]}];
        
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
}
/**
 弹出引导view
 */
-(void)alertGUideView{
    GuideView *guide = [[[NSBundle mainBundle]loadNibNamed:@"GuideView" owner:self options:nil]lastObject];
    __weak typeof(self) wkSelf = self;
    guide.closeBlock = ^{
        [wkSelf changeToGameScene];
    };
    guide.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    [self.view.superview addSubview:guide];
    [guide animateShow];
}


/**
 弹出设置界面
 */
-(void)alertSettingView{
    
    SetingViewController *setVC = [[SetingViewController alloc]initWithNibName:@"SetingViewController" bundle:nil];
//    setVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    setVC.view.frame = self.view.bounds;
    [self.viewController addChildViewController:setVC];
    self.jumper.paused = YES;
    [self.view addSubview:setVC.view];
    __weak typeof(setVC) wkSetVc = setVC;
    __weak typeof(self) wkSelf = self;
    setVC.effectClickBlock = ^{
        [wkSelf.jumper removeActionForKey:@"jumperNormal"];
        wkSelf.jumper.position = _jumperStartPoint;
        [wkSelf jumperBegainJump];
        wkSelf.jumper.paused = YES;
    };
    setVC.closeBlick = ^{
        [wkSetVc.view removeFromSuperview];
        [wkSetVc removeFromParentViewController];
        wkSelf.jumper.paused = NO;
    };

}

-(void)changeToGameScene{
    _gameJumpeScene = [JumpScene sceneWithSize:self.size];
    [_gameJumpeScene customUI];
//    SKAction *ro = [SKAction rotateByAngle:6.28 duration:0.5];
//    SKAction *scale = [SKAction scaleTo:0.5 duration:0.5];
    
    SKTransition *open = [SKTransition doorsOpenVerticalWithDuration:0.3];
    _gameJumpeScene.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scene.view presentScene:_gameJumpeScene transition:open];
    });
//    __weak typeof(self) wkSelf = self;
//    [self.jumper runAction:[SKAction group:@[ro,scale]] completion:^{
//        
//    }];
//    if (_gameJumpeScene) {
//        
//        
//        
//    }
}
-(void)openStoreViewController{
    StoreViewController *store = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
    
    store.view.frame = self.view.bounds;
    [self.viewController addChildViewController:store];
    self.jumper.paused = YES;
    [self.view addSubview:store.view];
    __weak typeof(self) wkSelf = self;
    store.closeVCBlock = ^{
        wkSelf.jumper.paused = NO;
    };
}
-(void)openJumpersViewController{
    JumperRolesViewController *jumpersVC = [[JumperRolesViewController alloc]initWithNibName:@"JumperRolesViewController" bundle:nil];
    
    jumpersVC.view.frame = self.view.bounds;
    [self.viewController addChildViewController:jumpersVC];
    self.jumper.paused = YES;
    [self.view addSubview:jumpersVC.view];
    
    [UserDefaultManager didGuidChangeRole];
    
    __weak typeof(self) wkSelf = self;
    jumpersVC.closeBlock = ^{
        wkSelf.jumper.paused = NO;
        [wkSelf customJumper];
    };
    jumpersVC.dimondClickBlock = ^{
       [wkSelf openStoreViewController];
    };
    jumpersVC.goldClickBlock = ^{
       [wkSelf openStoreViewController];
    };
}
@end
