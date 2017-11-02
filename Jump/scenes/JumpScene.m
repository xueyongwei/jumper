//
//  JumpScene.m
//  Jump
//
//  Created by xueyognwei on 2017/6/28.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "JumpScene.h"
#import "StepModel.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking.h>
#import <InMobiSDK/InMobiSDK.h>
#import "ResultScene.h"
#import "StartScene.h"

#import "JumpScene+Actions.m"
#import "JumpScene+Random.h"


#import "UserDefaultManager.h"

#import "ReLiveAlertView.h"
#import "PauseAlertView.h"

#import "GameCenterManager.h"

#import "GameRuleManager.h"

#import "StoreViewController.h"
#import "GuideViewController.h"

#import "WealthManager.h"
#import "XYWVersonManager.h"
#import "ReliveViewController.h"
#import "PauseViewController.h"
#import "JumpScene_Actions.h"
#import "JumpScene_Nodes.h"
#import "UIImage+Cut.h"
#import "JumperRoleManager.h"

#import "MyCommonActions.h"

#import "GameViewController.h"
#import "RewardVideoManager.h"
static CGFloat kStepZ = 0; //阶梯层级
static CGFloat kBgLayerZ = -100; //背景层级
static CGFloat kPlayLayerZ = 100; //jumper层级
static CGFloat kScoreLayerZ = 200; //Score层级
static CGFloat kAlertLayerZ = 300; //alert层级
static NSInteger kStepNumbersFullScreen = 10; //一屏多少个台阶
static NSInteger kJumperStartIndex = 3; //jumper开始位置

@interface JumpScene()<IMNativeDelegate>
@property (nonatomic, strong) PauseAlertView *pauseAlert;//暂停弹窗
//@property (nonatomic, strong) ReLiveAlertView *realert;
@property (nonatomic, strong) NSArray *bgColorsArray;
@property (nonatomic, strong) NSMutableArray *bgNodesArray;
@property (nonatomic, assign) NSInteger bgColorIndex;
@property (nonatomic,strong) SKSpriteNode *sceneBgNode;
@property (nonatomic,strong) ReliveViewController *reliveVC;
@property(nonatomic,strong) IMNative *InMobiNativeAd;
@property (nonatomic,weak) SKStepNode *currentStep;

@property (nonatomic, assign) BOOL haveDied;//已经死了
@property(nonatomic,strong)UIImage *bgNodeImage;

@property (nonatomic, strong) NSArray *guidStepsDicArr;//引导界面阶梯配置文件数组
@property (nonatomic,assign) CGPoint lastStepPosition;
@end

@implementation JumpScene
{
    //    SKSpriteNode *_PlayLayerNode;//玩游戏的那个node
    //    SKSpriteNode *_backgorundLayerNode;//背景node
    
    CGPoint _jumperPosition;//跳跃者的位置
    BOOL _lastIsHole;//上一个是否是个洞
    
    NSInteger _getGodCoins;//本局获得的金币
   
    NSInteger _lastRandomColorIndex;//上次随机到的颜色下标
    NSInteger _actionCountWaitToRun;//上次随机到的颜色下标
    
    NSMutableArray *_stepsArray;//阶梯数组
    NSMutableArray *_cloudsArray;//阶梯数组
    
    
    SKAction *_jumperAction;
    
    
    BOOL _havePaused;//游戏暂停
    BOOL _touchesDisable;
    
    NSInteger _reliveTimes;
    NSInteger _eachRelovePayment;
    
    CGSize _goldImageSize;
    
    SKJumperNode *tmp;
}
-(NSArray *)bgColorsArray
{
    if (!_bgColorsArray) {
        _bgColorsArray = [NSArray arrayWithObjects:@"81d5fa",@"4fc2f8",@"28b6f6",@"03a9f5",@"039be6",@"0091ea",@"b0bfff",@"91a6ff",
                           @"7c97ff",@"708dff",@"6281fd",@"5478ff",@"536dfe",@"b39ddb",@"a785e1",@"9b7ad4",
                           @"916ecc",@"8b64d0",@"825ac7",@"cf93d9",@"c672d5",@"c160d2",@"b54ec8",@"aa47bc",
                           @"a730bd",@"f48fb1",@"f36696",@"ee5b8c",@"f34d85",@"ea3c76",@"ee2367",@"f69988",
                           @"f26c60",@"f45749",@"f74249",@"f33138",@"e8222a",@"ffa589",@"fe8e6b",@"ff7e54",
                           @"fe6f41",@"ff6331",@"fe5722",@"ffcc80",@"ffbd5e",@"ffb64d",@"ffac34",@"ffa014",
                           @"ff9208",@"ffe083",@"fed85e",@"ffcf3e",@"ffc416",@"ffb304",@"fff59c",@"fff27d",
                           @"ffee58",@"ffea30",@"ffe00e",@"ffd318",@"e6ee9b",@"e8f37c",@"dfea70",@"d6e160",
                           @"cedb46",@"c3d324",@"c5e1a6",@"b6de88",@"aed582",@"9ccc66",@"8bc24a",@"83b949",
                           @"a3e9a3",@"7ada79",@"58ca57",@"42bd41",@"2bae2a",@"289f26",@"80cbc4",@"61c4bb",
                           @"4db6ac",@"30aba0",@"0aa293",@"009788",@"b2ebf2",@"84e3f0",@"62d9e9",@"4dd0e2",
                           @"25c6da",@"00bcd5",nil];
    }
    return _bgColorsArray;
}
-(SKSpriteNode *)eatGoldIconNode
{
    if (!_eatGoldIconNode) {
        _eatGoldIconNode = [SKSpriteNode spriteNodeWithImageNamed:@"goldCoin1"];

        CGSize orgSize = _eatGoldIconNode.size;
        CGFloat width = _eachStepHeight*1.458*0.5;
        CGFloat height = width*(orgSize.height/orgSize.width);
        _eatGoldIconNode.size = CGSizeMake(width, height);
    }
    return _eatGoldIconNode;
}
-(PauseAlertView *)pauseAlert
{
    if (!_pauseAlert) {
        _pauseAlert = [[[NSBundle mainBundle]loadNibNamed:@"PauseAlertView" owner:self options:nil]lastObject];
        __weak typeof(self) wkSelf = self;
        
        _pauseAlert.closeBlock = ^{
            [wkSelf goOnGameAfterSec:3];
        };
        _pauseAlert.GoOnBlock = ^{
            [wkSelf goOnGameAfterSec:3];
        };
        _pauseAlert.ReStartBlock = ^{
            [wkSelf changeToGameScene];
        };
        _pauseAlert.GoHomeBlock = ^{
            [wkSelf goHomeScene];
        };
        _pauseAlert.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    }
    return _pauseAlert;
}
-(SKAction *)eatGoldActuin
{
    if (!_eatGoldActuin) {
        
        SKNode *goldIconNode = [self childNodeWithName:@"goldNumberLabel"];
        
        SKAction *m1 = [SKAction moveTo:goldIconNode.position duration:0.5];
        SKAction *s4 =[SKAction scaleTo:0.3 duration:0.5];
        SKAction *g1 = [SKAction group:[NSArray arrayWithObjects:m1,s4,nil]];
//        SKAction *act = [SKAction sequence:@[m2,w1,g1]];
        _eatGoldActuin = g1;
    }
    return _eatGoldActuin;
}
-(void)setBgColorIndex:(NSInteger)bgColorIndex
{
    _bgColorIndex=bgColorIndex;
    if (bgColorIndex>self.bgColorsArray.count-1) {
        _bgColorIndex = 0;
    }
}
-(void)sceneDidLoad
{
    
}
-(void)didMoveToView:(SKView *)view
{
    DDLogVerbose(@"didMoveToView");
//    _shouldGuide = [UserDefaultManager shouldGuid];
    
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self initSkActions];
    
    [self observeAppEnterBackground];
    [UserDefaultManager gameStart];
    
    [self addSkillAction];
    
    [self requestInmobiNativeAds];
    [self addJumper];
    
    [self tryToguid];
}

-(void)dealloc
{
    [self dealocInmobiNativeAD];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)appEnterBackGround{
    if (_shouldGuide) {
        return;
    }
    if (!_havePaused && !_haveDied) {//没有暂停没有死
        [self alertPauseGame];
    }
    if (_haveDied) {
        [self.reliveVC pauseCutDown];
    }
}
-(void)appWillEnterForeground{
    if (_haveDied) {
        [self.reliveVC reStartCutDown];
    }
}
/**
 监听进入后台
 */
-(void)observeAppEnterBackground{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackGround) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(void)tryToguid{
    
    if (_shouldGuide) {
//        [self alertGUideView];
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showGuideVC];
        });
    }else{
        
    }

}


/**
 显示引导vc
 */
-(void)showGuideVC{
    
    GuideViewController *guidVC = [[GuideViewController alloc]initWithNibName:@"GuideViewController" bundle:nil];
    guidVC.view.frame = CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height);
    guidVC.view.alpha = 0;
    [self.viewController addChildViewController:guidVC];
    [self.view addSubview:guidVC.view];
    self.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        guidVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
    __weak typeof(self) wkSelf = self;
    guidVC.tapLeftBlock = ^{
        [wkSelf wannaJumpOfCount:1];
    };
    guidVC.tapRightBlock = ^{
        [wkSelf wannaJumpOfCount:2];
    };
    guidVC.tapSkill3Block = ^{
        [wkSelf skillProtect];
    };
    guidVC.showSkillItmsBlock = ^{
        [wkSelf animateShowSkillItems];
    };
    __weak typeof(guidVC) wkVC = guidVC;
    guidVC.closeVCBlock = ^{
        [wkSelf reLiveJumper];
        [wkVC.view removeFromSuperview];
        [wkVC removeFromParentViewController];
        _shouldGuide = NO;
        [UserDefaultManager didGuid];
    };
}

/**
 弹出引导view
 */

// no comments for you
// it was hard to write
// so it should be hard to read
-(void)alertGUideView{

    
    SKSpriteNode *guidCorverNode = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:0 alpha:0.5] size:CGSizeMake(self.size.width/2, self.size.height)];
    guidCorverNode.alpha = 0;
    guidCorverNode.name = @"guidCorverNode";
//    guidRightNode.position = CGPointMake(self.size.width/4, 0);
    guidCorverNode.zPosition = kAlertLayerZ+10;
    guidCorverNode.position = CGPointMake(self.size.width/4*3, self.size.height/2);
    [self addChild:guidCorverNode];
    
    SKAction *action = [SKAction fadeAlphaTo:1 duration:1.0];
    
    __weak typeof(self) wkSelf = self;
    [guidCorverNode runAction:action completion:^{
        SKSpriteNode *guidPointNode = [SKSpriteNode spriteNodeWithImageNamed:@"guidPointL"];
        //    guidRightNode.alpha = 0.5;
        guidPointNode.name = @"guidPointNode";
        guidPointNode.position = CGPointMake(wkSelf.size.width/6, wkSelf.size.height/4);
        
        SKAction *a1 = [SKAction moveByX:5 y:5 duration:0.5];
        SKAction *a2 = [SKAction moveByX:-5 y:-5 duration:0.5];
        SKAction *g = [SKAction sequence:[NSArray arrayWithObjects:a1,a2,nil]];
        SKAction *rg = [SKAction repeatActionForever:g];
        [guidPointNode runAction:rg withKey:@"guidPointNode"];
        [wkSelf addChild:guidPointNode];
        
        SKSpriteNode *textNode = [SKSpriteNode spriteNodeWithImageNamed:@"Hop1Step"];
        textNode.name = @"textNode";
        textNode.position = CGPointMake(wkSelf.size.width/4, wkSelf.size.height/2);
        [wkSelf addChild:textNode];
    }];
}
/**
 绘制界面
 */
-(void)customUI{
    _lastIsHole = YES;
//    _shouldGuide = YES;
    _shouldGuide = [UserDefaultManager shouldGuid];
    _eachRelovePayment = 5;
    _reliveTimes = 1;
    
    _stepsArray = [[NSMutableArray alloc]init];
    _cloudsArray = [[NSMutableArray alloc]init];
    
    self.backgroundColor = [UIColor lightGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    if (_shouldGuide) {
        [WealthManager defaultManager].skillProtectAmount +=1;
    }
    [self initBackgroundLayerNode];
    [self initPlayLayerNode];
    [self addSource];
//    [self tryToguid];
}
#pragma mark -- skaction的初始化

/**
 初始化skactions
 */
-(void)initSkActions{
    //初始化背景音乐
    if (![UserDefaultManager isBgmClose]) {
        [self initBgm];
    }
    
    self.jumperAction = [self newJumperAction];
    self.slipAction = [self newSlipActionWithDuration:0.3];
    self.stepDown1Action = [self newStepDown1Action];
    self.stepDown2Action = [self newStepDown2Action];
    self.stepFallDownAction = [self newStepFallDownAction];
    self.jumperDiedAction = [self newJumperDiedWithEffectAction];
    self.slipPropAction = [self newSlipPropAction];
}

/**
 更新滑倒的动画（时间变短）
 */
-(void)updaSlideAction{
    if (_passedSteps==400) {
        self.slipAction = [self newSlipActionWithDuration:0.2];
    }else if (_passedSteps==800){
        self.slipAction = [self newSlipActionWithDuration:0.1];
    }
//    else if (_passedSteps==1500){
//        self.slipAction = [self newSlipActionWithDuration:0.1];
//    }
}

/**
 初始化音效
 */
-(void)initBgm{
    
    NSString *bgmPath = [[NSBundle mainBundle] pathForResource:@"BB2" ofType:@"caf"];
    self.bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgmPath] error:NULL];
    self.bgmPlayer.numberOfLoops = -1;
    [self.bgmPlayer play];
}

-(void)playProtectBgm{
    NSString *bgmPath = [[NSBundle mainBundle] pathForResource:@"bg_protect" ofType:@"caf"];
    self.bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgmPath] error:NULL];
    self.bgmPlayer.numberOfLoops = -1;
    [self.bgmPlayer play];
}
#pragma mark -- 背景层
/**
 添加背景层
 */

-(void)initBackgroundLayerNode{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.size];
    node.anchorPoint = CGPointMake(0, 0);
//    node.position = self.view.center;
//    node.position = CGPointMake(self.size.width/2, self.size.height/2);
    node.size = self.size;
    node.zPosition = kBgLayerZ;
    //    node.anchorPoint = CGPointMake(0, 0);
    node.name = @"backgroundLayer";
    [self addChild:node];
    _sceneBgNode = node;
    _bgNodesArray = [[NSMutableArray alloc]init];
//    0、6、13、19、25、31、37、43、49、55、61、67、73、79、85
    NSArray *indexArray = [NSArray arrayWithObjects:@0,@6,@13,@19,@25,@31,@37,@43,@49,@55,@61,@67,@73,@79,@85,nil];
    NSInteger begainIndex =arc4random()%(indexArray.count-1);
    if (begainIndex>=indexArray.count-1) {
        begainIndex = indexArray.count-1;
    }
    NSNumber *bgColorIndex = indexArray[begainIndex];
    self.bgColorIndex = bgColorIndex.integerValue;
    for (NSInteger i =0; i<5; i++) {
        NSString *colorName =  [self.bgColorsArray objectAtIndex:self.bgColorIndex];
        self.bgColorIndex +=1;
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithHexString:colorName] size:CGSizeMake(self.size.width, self.size.height/3)];
        
        bg.zPosition = kBgLayerZ+1;
        bg.position = CGPointMake(self.size.width/2,self.size.height/3*i);
        [node addChild:bg];
        [_bgNodesArray addObject:bg];
    }
    
    //添加几朵白云
    for (NSInteger i =0; i<5; i++) {
        [self addOneCloudNodeMustStart:NO];
    }
}

/**
 随机添加白云
 */
- (void)addOneCloudNodeMustStart:(BOOL) must{
    NSString *cloudName = @"sceneBgPoint";
    SKCloudNode *cloud = [SKCloudNode spriteNodeWithImageNamed:cloudName];
    cloud.name = @"cloud";
    cloud.zPosition = kBgLayerZ+10;
    //1 Determine where to spawn the monster along the Y axis
    CGSize winSize = [UIImage imageNamed:cloudName].size;
    cloud.size = winSize;
    
    CGPoint randomPistion = [self randomCloudStartPosition:must];
    
    cloud.position = randomPistion;
    [_sceneBgNode addChild:cloud];
    
    SKAction *cloudAct = [self actionCloudNormal];
    [cloud runAction:cloudAct];
    [_cloudsArray addObject:cloud];
}
#pragma mark -- 游戏操作层
/**
 添加操作层
 */
-(void)initPlayLayerNode{
    _eachHeight = self.size.height/kStepNumbersFullScreen;//设定每个台阶的大小
    _eachStepHeight = _eachHeight*1.3;
    
    NSString *guideFile = [[NSBundle mainBundle] pathForResource:@"GuideConfig" ofType:@"plist"];
    NSArray <NSDictionary *>*array = [NSArray arrayWithContentsOfFile:guideFile];
    self.guidStepsDicArr = array;
    
    [self initSomeSteps];
    
    
}

/**
 添加跳跃者
 */
-(void)addJumper{
    JumperRoleModel *curntRole = [JumperRoleManager shareManager].curntJumperRoleModel;
    SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_背面",curntRole.jumperPic]];
    SKJumperNode *jumper = [SKJumperNode spriteNodeWithTexture:texture];
    jumper.name = @"jumper";
    jumper.userInteractionEnabled = YES;
    //1.0里各角色大小不一样，可能需要再调
    CGFloat width =_eachHeight*1.2;
    jumper.size = CGSizeMake(width*1.2255, width);
    
    jumper.zPosition = kPlayLayerZ;
    jumper.anchorPoint = CGPointMake(0.5, 0);
    //    jumper.anchorPoint = CGPointMake(0, 0);
    
    _jumperPosition = CGPointMake(YYScreenSize().width/2,_eachHeight*kJumperStartIndex+_eachStepHeight*0.5);
    jumper.position = _jumperPosition;
    
    [self addChild:jumper];
    
    //        [self.jumper removeAllActions];
    //        [self.jumper removeAllChildren];
    //        [self.jumper removeFromParent];
//    gWSelf.jumper = nil;
//    [_jumper removeAllChildren];
    
    tmp = _jumper;
    _jumper = jumper;
    
}


/**
 添加操作的按钮
 */
-(void)addSkillAction{
    
    NSArray *skillImageNames = [NSArray arrayWithObjects:@"skill清除icon",@"skill加速icon",@"skill天使icon",nil];
    NSArray *skillShowNames = [NSArray arrayWithObjects:@"skill1",@"skill2",@"skill3",nil];
    
    CGFloat each = (self.size.width-60)/skillImageNames.count;
    CGFloat itemWidth = self.size.width*0.16;
    CGFloat positionY = _shouldGuide?-itemWidth:itemWidth;
    for (NSInteger i =0; i<skillImageNames.count; i++) {
        NSString *imageName = skillImageNames[i];
        SKSpriteNode *skill = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        skill.size = CGSizeMake(itemWidth, itemWidth);
        //    [[SKSpriteNode alloc]initWithColor:[SKColor brownColor] size:CGSizeMake(80, 80)];
        skill.name = skillShowNames[i];
        skill.position = CGPointMake(30+i*each + each/2,positionY);
        skill.zPosition = kPlayLayerZ;
        skill.color = [UIColor blackColor];
        [self addChild:skill];
        
        SKSpriteNode *skillCountBg = [SKSpriteNode spriteNodeWithImageNamed:@"skillCountBg"];
        skillCountBg.name = skillShowNames[i];
        skillCountBg.position = CGPointMake(0,-(skill.size.height/2+skillCountBg.size.height/2));
        skillCountBg.zPosition = kPlayLayerZ;
        skillCountBg.color = [UIColor whiteColor];
        [skill addChild:skillCountBg];
        
        
//        SKCropNode *cropNode = [SKCropNode node];
//        cropNode.position = CGPointMake(-skill.size.height*0.25, -skill.size.height/2-skill.size.height*0.2);
//
//        SKShapeNode *mask = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, skill.size.width*0.5, skill.size.width*0.25) cornerRadius:skill.size.width*0.25*0.5];
//        mask.fillColor = [UIColor whiteColor];
//        mask.lineWidth = 0.0001;
//        
//        [cropNode setMaskNode:mask];
//        
//        
        SKLabelNode *label = [SKLabelNode labelNodeWithText:@"0"];
        label.fontName = @"changchengteyuanti";
//        label.position = CGPointMake(skill.size.width*0.25, skill.size.width*0.25*0.5);
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.fontSize = 11;
        label.fontColor = [UIColor blackColor];
        [skillCountBg addChild:label];
//
//        [skill addChild:cropNode];
        
        if (i==0) {
            self.skill1Node = skill;
            self.skill1LabelNode = label;
        }else if (i==1){
            self.skill2Node = skill;
            self.skill2LabelNode = label;
        }else{
            self.skill3Node = skill;
            self.skill3LabelNode = label;
        }
    }
    [self showSkillNumberLabel];
}

-(void)animateShowSkillItems{
//    50;
    SKAction *moveToY = [SKAction moveToY:self.size.width*0.16 duration:0.3];
    [self.skill1Node runAction:moveToY];
    [self.skill2Node runAction:moveToY];
    [self.skill3Node runAction:moveToY];
}
-(void)showSkillNumberLabel{
//    self.skill1Node.colorBlendFactor =[WealthManager defaultManager].skillCleanSubAmount==0?0.5:0;
//    self.skill2Node.colorBlendFactor =[WealthManager defaultManager].skillSprintAmount==0?0.5:0;
//    self.skill3Node.colorBlendFactor =[WealthManager defaultManager].skillProtectAmount==0?0.5:0;
    
    self.skill1LabelNode.text =  [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].skillCleanSubAmount];
    self.skill2LabelNode.text =  [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].skillSprintAmount];
    self.skill3LabelNode.text =  [NSString stringWithFormat:@"%ld",(long)[WealthManager defaultManager].skillProtectAmount];
}

/**
 创建一个随机踏板
 
 @return 踏板对象
 */
-(SKStepNode *)randomOneStepNode{
    SKStepNode *step = nil;
    if (self.shouldGuide && _stepsArray.count<self.guidStepsDicArr.count) {
        NSDictionary *dic = self.guidStepsDicArr[_stepsArray.count];
        BOOL isHole = [dic boolValueForKey:@"isHole" default:NO];
        if (isHole) {
            step = [SKStepNode spriteNodeWithImageNamed:@"踏板0"];
            step.isHole = YES;
        }else{
            step = [SKStepNode spriteNodeWithImageNamed:@"step草坪"];
            step.isHole = NO;
        }
    }else{
        BOOL noHole = _stepsArray.count<=kJumperStartIndex;
        if (_shouldGuide) {
            noHole =_stepsArray.count<=kJumperStartIndex+3;
        }
        if (noHole) {//不能为空
            step = [SKStepNode spriteNodeWithImageNamed:@"step草坪"];
            step.isHole = NO;
        }else{
            SKStepNode *lastStep = _stepsArray.lastObject;
            if (!lastStep || lastStep.isHole) {//上一个是个洞,这个不能为洞
                step = [SKStepNode spriteNodeWithImageNamed:@"step草坪"];
                step.isHole = NO;
            }else{//上一个不是洞，这个就看运气喽
                int x = arc4random() % 10;
                if (x<4) {
                    step = [SKStepNode spriteNodeWithImageNamed:@"踏板0"];
                    step.isHole = YES;
                }else{
                    step = [SKStepNode spriteNodeWithImageNamed:@"step草坪"];
                    step.isHole = NO;
                }
            }
        }
    }
    

    step.name = @"step";
    if (_stepsArray.count==0) {
        step.zPosition = kStepZ;
    }else{
        SKStepNode *lastStep = _stepsArray.lastObject;
        step.zPosition = lastStep.zPosition-0.0001;
    }
    
    step.anchorPoint = CGPointMake(0.5, 0);
    step.size = CGSizeMake(_eachStepHeight*1.458, _eachStepHeight);
    
    return step;
}


/**
 给前面的一个踏板加道具

 @param step 当前的新板子
 */
-(void)wannaAddPropToPreStepOfNewStep:(SKStepNode *)step{
    
    GameRule *rule = [[GameRuleManager defaultManager] currentRule];
    step.stayDuration = rule.stepDuration;
    
    NSLog(@"wannaAddPropToPreStepOfNewStep %@ %f",step,step.stayDuration);
    
    if (self.shouldGuide&& _stepsArray.count<self.guidStepsDicArr.count) {
        
        NSDictionary *dic = self.guidStepsDicArr[[_stepsArray indexOfObject:step]];
        NSInteger propstype = [dic intValueForKey:@"propType" default:-1];
        if (propstype>0) {
            SKPropNode *prop = [SKPropNode propWithStyle:propstype onStep:step];
            CGSize orgSize = prop.size;
            CGFloat width = step.size.width*[self percentOfProp:prop];
            CGFloat height = width*(orgSize.height/orgSize.width);
            prop.size = CGSizeMake(width, height);
            if (prop) {//摇到了个道具
                prop.position = CGPointMake(0, step.size.height*0.8);
                [step addChild:prop];
                step.propNode = prop;
            }
        }else{
            
        }
    }else{
        if (_stepsArray.count>8+3) {//在jumper前面的才出现道具
            if (rule.props.count>0) {//当前分数有道具属性
                //上一个板子
                SKStepNode *addToStep = _stepsArray[_stepsArray.count-2];
                SKStepNode *preStep = _stepsArray[_stepsArray.count-3];
                NSLog(@"addToStep %@ addToStep %@",addToStep,preStep);
                if (step.isHole) {
                    DDLogVerbose(@"hole");
                }
                if (!addToStep.isHole) {//要添加道具的板子不是洞才能添加道具
                    //给板子添加一个随机类型的道具
                    SKPropNode *prop = [self randomOnePropOnStep:addToStep preStep:preStep nxtStep:step WithGameRule:rule];
                    if (prop) {//摇到了个道具
                        prop.position = CGPointMake(0, addToStep.size.height*0.8);
                        CGSize orgSize = prop.size;
                        
                        CGFloat width = step.size.width*[self percentOfProp:prop];
                        CGFloat height = width*(orgSize.height/orgSize.width);
                        prop.size = CGSizeMake(width, height);
                        [addToStep addChild:prop];
                        addToStep.propNode = prop;
                    }
                }
            }
        }
    }
    
}

-(CGFloat)percentOfProp:(SKPropNode *)prop{
    switch (prop.style) {
        case PropStyleScoreAddGod:
        {
            return 0.4 ;
        }
            break;
        case PropStyleScoreSlide:
        {
            return 0.4 ;
        }
            break;
        case PropStyleScoreMoveToHit:
        {
            return 0.5 ;
        }
            break;
            
        default:
            break;
    }
}
/**
 初始化添加一些阶梯
 */
-(void)initSomeSteps{
    DDLogVerbose(@"初始化添加台阶");
    
    [[GameRuleManager defaultManager] resetGameRule];
    for (NSInteger i = 0; i<kStepNumbersFullScreen+3; i++) {
//        [self addOneNewStepAt:i];
        [self addOneNewStep];
    }
}


/**
 追加新的踏板
 
 @param count 追加几个
 */
-(void)addNewStepAtEndWithCount:(NSInteger)count{
    
    for (NSInteger i =0; i<count; i++) {
        [self addOneNewStep];
//        [self addOneNewStepAt:kStepNumbersFullScreen + 2+ i ];
    }
}

/**
 追加一个新的阶梯
 */
-(void)addOneNewStepAtTop{
    SKStepNode *lastStep = _stepsArray.lastObject;
    CGPoint lastPositon = lastStep.position;
    DDLogVerbose(@"lastPositon %@",NSStringFromCGPoint(lastPositon));
    lastPositon.y+=_eachHeight;
    DDLogVerbose(@"lastPositon %@",NSStringFromCGPoint(lastPositon));
    SKStepNode *step = [self randomOneStepNode];
    step.position = lastPositon;
    [self insertChild:step atIndex:0];
//    [self addChild:step];
    //添加到数组里
    [_stepsArray addObject:step];
}
/**
 添加一个新的阶梯
 */
-(void)addOneNewStep{
    NSLog(@"addOneNewStep");
    SKStepNode *step = [self randomOneStepNode];
    if (_stepsArray.count ==0) {
        step.position = CGPointMake(self.size.width/2, 0);
    }else{
        SKStepNode *lastStep = _stepsArray.lastObject;
        step.position = CGPointMake(lastStep.position.x, lastStep.position.y+_eachHeight);
    }
    //添加到数组里
    [_stepsArray addObject:step];
    [self addChild:step];
    
    if (_stepsArray.count>kStepNumbersFullScreen+3) {//开始记分
        _passedSteps ++;
        [self showSourceWithAnimateText:nil];
    }
    
    //试图添加个道具
    if (_shouldGuide) {
        [self wannaAddPropToPreStepOfNewStep:step];
//        if (_stepsArray.count>kJumperStartIndex+3) {
//            [self wannaAddPropToPreStepOfNewStep:step];
//        }
    }else{
        if (_stepsArray.count>kJumperStartIndex) {
            [self wannaAddPropToPreStepOfNewStep:step];
        }
    }
    
    if (_stepsArray.count>kStepNumbersFullScreen+10) {//多保留几个
        SKSpriteNode * todeleteNode = _stepsArray.firstObject;
        DDLogVerbose(@"太多了，删除一个%@ ",todeleteNode);
        [_stepsArray removeObject:todeleteNode];
        [todeleteNode removeFromParent];
    }
}
///**
// 添加一个新的阶梯
// 
// @param index 阶梯的下标
// */
//-(void)addOneNewStepAt:(NSInteger )index{
//    SKStepNode *step = [self randomOneStepNode];
//    NSLog(@"addOneNewStepAt %ld",(long)index);
//    step.position = CGPointMake(self.size.width/2,_eachHeight*index);
//    [self addChild:step];
////    [self addChild:step];
//    [[GameRuleManager defaultManager] updateGameRuleWithScore:_passedSteps];
////    DDLogVerbose(@"addOneNewStepAt %ld %@",index,step);
////
//    if (_stepsArray.count>kStepNumbersFullScreen+2) {//开始记分
//        _passedSteps ++;
//        [self showSourceWithAnimateText:nil];
//    }
//    if (_stepsArray.count>kStepNumbersFullScreen+10) {//多保留
//        SKSpriteNode * todeleteNode = _stepsArray.firstObject;
//        DDLogVerbose(@"太多了，删除一个%@ ",todeleteNode);
//        [_stepsArray removeObject:todeleteNode];
//        [todeleteNode removeFromParent];
//    }
//}


#pragma mark -- 数据显示层
/**
 添加分数显示label
 */
-(void)addSource{
    
    //收集金币显示
    UIImage *goldImage = [UIImage imageNamed:@"home金币数值"];
    SKSpriteNode *goldIconNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:goldImage]];
    goldIconNode.zPosition = kScoreLayerZ;
    goldIconNode.name = @"goldIconNode";
    goldIconNode.anchorPoint = CGPointMake(0, 0.5);
    goldIconNode.centerRect = CGRectMake(0.45, 0, 0.2, 0.1);
    goldIconNode.position = CGPointMake(15, self.size.height-15 - goldIconNode.size.height/2);
    [self addChild:goldIconNode];
   
    SKLabelNode *goldNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    goldNumberLabel.zPosition = kScoreLayerZ;
    goldNumberLabel.name = @"goldNumberLabel";
    goldNumberLabel.fontSize = 14;
//    goldNumberLabel.text = @"0";
    goldNumberLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    goldNumberLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    goldNumberLabel.position = CGPointMake(55, self.size.height-15 - goldIconNode.size.height/2);
    goldNumberLabel.fontColor = [SKColor colorWithHexString:@"333333"];
    
    [self addChild:goldNumberLabel];
    _goldImageSize = goldImage.size;
    _getGodCoins = 0;
    [self showGoldColins];
    
    //本局得分显示
    SKLabelNode *sourceLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
    sourceLabel.text = [NSString stringWithFormat:@"%ld",(long)_passedSteps ];
    sourceLabel.fontSize = 30;
    sourceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    sourceLabel.zPosition = kScoreLayerZ;
    sourceLabel.fontColor = [SKColor whiteColor];
    sourceLabel.position = CGPointMake(self.size.width/2,self.size.height- 15 - sourceLabel.frame.size.height/2);
    sourceLabel.name = @"sourceLabel";
    _sourceLabel = sourceLabel;
    [self addChild:sourceLabel];
    
    //暂停
    
    SKSpriteNode *pauseNode = [SKSpriteNode spriteNodeWithImageNamed:@"game暂停_btn"];
//    pauseNode.size = CGSizeMake(50, 50);
    pauseNode.zPosition = kScoreLayerZ;
    pauseNode.position = CGPointMake(self.size.width - 15-pauseNode.size.width/2, self.size.height -15- pauseNode.size.height/2);
    pauseNode.name = @"pauseNode";
    
    [self addChild:pauseNode];
    SKSpriteNode *pauseArea = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(60, 60)];
    pauseArea.position = pauseNode.position;
    pauseArea.zPosition = kScoreLayerZ-0.1;
    pauseArea.name = @"pauseNode";
    [self addChild:pauseArea];
    
    
    //加载暂停广告
//    [self.pauseAlert loadAd];
    [self initRewardVideo];
}
-(void)showGoldColins{
    //改变图标的大小
    SKLabelNode * diamondNumberLabel = (SKLabelNode *)[self childNodeWithName:@"goldNumberLabel"];
    diamondNumberLabel.text = [NSString stringWithFormat:@"  %ld",(long)_getGodCoins];
    CGFloat diamondIconwidth = diamondNumberLabel.frame.size.width+_goldImageSize.width/2 + 20;
    SKNode *goldIconNode = [self childNodeWithName:@"goldIconNode"];
    goldIconNode.xScale = diamondIconwidth/_goldImageSize.width;
    
    [diamondNumberLabel runAction:[self newZoomActionWithDuration:0.2]  completion:^{
        
    }];
    
}

/**
 按格式显示分数
 */
-(void)showSourceWithAnimateText:(NSString *)text{
    //更新滑动的时间
    [self updaSlideAction];
    _sourceLabel.text = [NSString stringWithFormat:@"%ld",(long)_passedSteps];
    [[GameRuleManager defaultManager] updateGameRuleWithScore:_passedSteps];
    if (text) {
        SKNode *node = [self childNodeWithName:@"bigShowLabel"];
        if (node) {
            [node removeAllActions];
            [node removeFromParent];
        }
        SKLabelNode *bigShowLabel = [SKLabelNode labelNodeWithFontNamed:@"changchengteyuanti"];
        bigShowLabel.name = @"bigShowLabel";
        bigShowLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        bigShowLabel.text = text;
        bigShowLabel.fontSize = 35;
        bigShowLabel.fontColor = [UIColor blackColor];
        [self addChild:bigShowLabel];
        SKAction *zoom1 = [SKAction scaleTo:2.0 duration:0.2];
        SKAction *zoom2 = [SKAction scaleTo:1.5 duration:0.2];
        SKAction *wait = [SKAction waitForDuration:0.2];
        SKAction *zoom3 = [SKAction scaleTo:0.3 duration:0.3];
        SKAction *diss = [SKAction removeFromParent];
        
        [bigShowLabel runAction:[SKAction sequence:[NSArray arrayWithObjects:zoom1,zoom2,wait,zoom3,diss,nil]]];
        
    }
    
}

#pragma mark -- 😢 点击操作 touchesBegan

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    CGPoint touchLocation = [touch locationInNode:self];
    if (touch.view != self.view ) {
        return;
    }
    SKNode *touchNode = [self nodeAtPoint:touchLocation];
    
    if ([touchNode.name isEqualToString:@"cutDowmNode"]) {
        return;
    }
    if ([touchNode.name isEqualToString:@"actionMove"]) {
        [self wannaJumpOfCount:1];
    }else if ([touchNode.name isEqualToString:@"actionJump"]){
        [self wannaJumpOfCount:2];
    }else if ([touchNode.name isEqualToString:@"pauseNode"]){
        [self alertPauseGame];
    }else if ([touchNode.name isEqualToString:@"skill1"]){
        if ([self childNodeWithName:@"guidCorverNode"]) {
            
        }else{
            [self skillRemoveProps];
        }
        
    }else if ([touchNode.name isEqualToString:@"skill2"]){//向前走了
        if (self.jumper.reLive) {
            self.jumper.reLive = NO;
        }
        if ([self childNodeWithName:@"guidCorverNode"]) {
            
        }else{
            [self skillSprint];
        }
        
    }else if ([touchNode.name isEqualToString:@"skill3"]){
        if ([self childNodeWithName:@"guidCorverNode"]) {
            
        }else{
            [self skillProtect];
        }
    }else if ([touchNode.name isEqualToString:@"guidCorverNode"]||[touchNode.name isEqualToString:@"guidBgL"]){

    }else if ([touchNode.name isEqualToString:@"guidR"]||[touchNode.name isEqualToString:@"guidBgR"]){
       
    }else{
        if (touchLocation.x<self.size.width/2) {
            [self wannaJumpOfCount:1];
        }else{
            [self wannaJumpOfCount:2];
        }
    }
}
#pragma mark -- 😊点击了技能

/**
 移除障碍技能
 */
-(void)skillRemoveProps{
    if (_haveDied) {//已经死了
        return;
    }
    [FIRAnalytics logEventWithName:@"道具使用" parameters:@{@"道具名":@"清理障碍",@"状态":@"准备使用"}];
    if ([WealthManager defaultManager].skillCleanSubAmount>0) {
        if (![UserDefaultManager isSoundEffectClose]) {
            [_jumper runAction:[self newCleanSoundEffectAction]];
        }
        
        [self.skill1Node runAction:[self newZoomActionWithDuration:0.2]];
        __weak typeof(self) wkSelf = self;
        [_stepsArray enumerateObjectsUsingBlock:^(SKStepNode *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.propNode && obj.propNode.style >= PropStyleScoreSlide) {//消除减益
                [FIRAnalytics logEventWithName:@"道具使用" parameters:@{@"道具名":@"清理障碍",@"状态":@"使用成功"}];
                [wkSelf cleanPropOnStep:obj];
//                [obj.propNode removeFromParent];
//                obj.propNode = nil;
            }
        }];
        [WealthManager defaultManager].skillCleanSubAmount-=1;
        [self showSkillNumberLabel];
    }
}

-(void)cleanPropOnStep:(SKStepNode *)step{
//    for (int i=0; i<10; i++) {
//        int index = arc4random()%5;
//        NSString *imgName = [NSString stringWithFormat:@"clean%d",index+1];
//        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:imgName];
//        [prop addChild:node];
//    }
    SKPropNode *prop = step.propNode;
    step.propNode = nil;
    SKAction *fadeout = [SKAction fadeOutWithDuration:0.2];
    SKAction *min = [SKAction scaleTo:0.1 duration:0.2];
    SKAction *g1 = [SKAction group:[NSArray arrayWithObjects:fadeout,min,nil]];
    
    SKAction *star = [SKAction setTexture:[SKTexture textureWithImageNamed:@"星星点缀"]];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];
    SKAction *max = [SKAction scaleTo:2.0 duration:0.3];
    SKAction *g2 = [SKAction group:[NSArray arrayWithObjects:star,fadeIn,max,nil]];
    SKAction *fadeout1 = [SKAction fadeOutWithDuration:0.2];
    SKAction *rm = [SKAction removeFromParent];
    SKAction *sq = [SKAction sequence:[NSArray arrayWithObjects:g1,g2,fadeout1,rm,nil]];
    [prop runAction:sq completion:^{
        [prop removeFromParent];
    }];
    /*
    [prop runAction:fadeout completion:^{
        for (SKSpriteNode *children in prop.children) {
            int x = arc4random()%((int)prop.size.width)-prop.size.width/2;
            int y = arc4random()%((int)prop.size.height)-prop.size.height/2;
            SKAction *move = [SKAction moveTo:CGPointMake(x, y) duration:0.3];
            SKAction *fo = [SKAction fadeOutWithDuration:0.2];
            SKAction *rm = [SKAction removeFromParent];
            [children runAction:[SKAction sequence:@[move,fo,rm]] completion:^{
//                [prop removeFromParent];
            }];
        }
    }];
    */
}
/**
 冲刺技能
 */
-(void)skillSprint{
    if (_haveDied || [_jumper actionForKey:kJumperFallDownActionKey]) {//已经死了
        return;
    }
    [FIRAnalytics logEventWithName:@"道具使用" parameters:@{@"道具名":@"冲刺",@"状态":@"准备使用"}];
    
    if ([_jumper childNodeWithName:@"jumperHeader"]) {//正在冲刺
        return;
    }
    if ([WealthManager defaultManager].skillSprintAmount>0) {
        [FIRAnalytics logEventWithName:@"道具使用" parameters:@{@"道具名":@"冲刺",@"状态":@"使用成功"}];
        [self.skill2Node runAction:[self newZoomActionWithDuration:0.2]];
        //给jumper加个动画
        [self addSprintAnimateOnJumper];
        //移动n个板子
        [self sprintStepWithCount:20];
        [WealthManager defaultManager].skillSprintAmount-=1;
        [self showSkillNumberLabel];
    }
}


/**
 护罩技能
 */
-(void)skillProtect{
    if (_haveDied) {//已经死了
        return;
    }
    [FIRAnalytics logEventWithName:@"道具使用" parameters:@{@"道具名":@"天使护佑",@"状态":@"准备使用"}];
    if ([_jumper childNodeWithName:@"Protect"]) {//已经有保护罩了
        return;
    }
    
    if ([WealthManager defaultManager].skillProtectAmount>0) {
        [FIRAnalytics logEventWithName:@"道具使用" parameters:@{@"道具名":@"天使护佑",@"状态":@"使用成功"}];
        [self.skill3Node runAction:[self newZoomActionWithDuration:0.2]];
        if (![UserDefaultManager isSoundEffectClose]) {
            [self.skill3Node runAction:[self newProtectSoundEffectAction]];
        }
        [self addProtectTojumper];
        
        [WealthManager defaultManager].skillProtectAmount -=1;
        [self showSkillNumberLabel];
    }
    
}
-(void)addSprintAnimateOnJumper{
    
    //头部罩子
    SKSpriteNode *jumperHeader = [SKSpriteNode spriteNodeWithImageNamed:@"冲刺波"];
    jumperHeader.name = @"jumperHeader";
    CGFloat width = _jumper.size.width*1.5;
    jumperHeader.size = CGSizeMake(width, width*0.64);
    jumperHeader.position = CGPointMake(0, _jumper.size.height+jumperHeader.size.height/2);
    SKAction *m1 = [SKAction moveByX:0 y:-10 duration:0.3];
    SKAction *m2 = [SKAction moveByX:0 y:10 duration:0.3];
    SKAction *sq = [SKAction sequence:[NSArray arrayWithObjects:m1,m2,nil]];
    SKAction *rp = [SKAction repeatActionForever:sq];
    [jumperHeader runAction:rp];
    [_jumper addChild:jumperHeader];
    
    //动画图片组
    NSMutableArray *allTextureArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"喷气尾%d.png",i+1];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [allTextureArray addObject:texture];
    }
    //尾部喷气动画
    SKAction *animationAction = [SKAction animateWithTextures:allTextureArray timePerFrame:0.04];
    SKAction *repeatAc = [SKAction repeatActionForever:animationAction];
    
    SKSpriteNode *jumperTail = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.jumper.size];
    jumperTail.name = @"jumperTail";
    jumperTail.position = CGPointMake(0, -jumperTail.size.height/2);
    [_jumper addChild:jumperTail];
    
    [jumperTail runAction:repeatAc withKey:@"sprintOnJumper"];
    if (![UserDefaultManager isSoundEffectClose]) {
        [self.bgmPlayer pause];
        __weak typeof(self) wkSelf = self;
        [_jumper runAction:[self newSprintEffectAction] completion:^{
            [wkSelf.bgmPlayer play];
        }];
    }
    
}
-(void)removeSprintAnimateOnJumper{
    SKSpriteNode *jumperTail =(SKSpriteNode *)[_jumper childNodeWithName:@"jumperTail"];
    if (jumperTail) {
        [jumperTail removeAllActions];
        [jumperTail removeFromParent];
    }
    SKSpriteNode *jumperHeader =(SKSpriteNode *)[_jumper childNodeWithName:@"jumperHeader"];
    if (jumperHeader) {
        [jumperHeader removeAllActions];
        [jumperHeader removeFromParent];
    }
    
}

/**
 尝试飞跃count个板子，如果这个板子是个洞，会顺延到下一个板子

 @param count 板子数
 */
-(void)sprintStepWithCount:(NSInteger)count{
    if (_havePaused) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sprintStepWithCount:count];
        });
        return;
    }
    if (count ==0) {//完成了刚开始指定的冲刺距离
        NSArray *nodes = [self nodesAtPoint:_jumperPosition];
        [nodes enumerateObjectsUsingBlock:^(SKNode *node, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([node.name isEqualToString:@"step"]) {
                *stop = YES;
                SKStepNode *step = (SKStepNode *)node;
                if (step.isHole) {//冲刺结束时的位置是个洞
                    [self sprintStepWithCount:1];//再往前冲一个
                }else{//真正结束了冲刺
                    [self removeSprintAnimateOnJumper];
                    //冲刺结束，这个地方不能久待
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self howlongStay] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//不能呆太久的
                        [self wannaBreakJumperOnStep:step];
                    });
                }
            }
        }];
        [_jumper removeActionForKey:@"sprint"];
        return;
    }
    SKAction *a1 = [SKAction scaleXTo:1.1 y:1.0 duration:0.1];
    SKAction *a2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.1];
    
    SKAction *s1 = [SKAction sequence:[NSArray arrayWithObjects:a1,a2,nil]];
    SKAction *r1 =[SKAction repeatActionForever:s1];
    [_jumper runAction:r1 withKey:@"sprint"];
    
    SKAction *downAction = [SKAction moveByX:0 y:-self.eachHeight duration:0.1];
    __weak typeof(self) wkSelf = self;
    
    [_stepsArray enumerateObjectsUsingBlock:^(SKStepNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj runAction:downAction completion:^{
            if (CGRectIntersectsRect(obj.frame, _jumper.frame)) {
                self.currentStep = obj;
                [wkSelf checkPropOnStep:obj withInvincible:YES];
            }
            if (obj == _stepsArray.lastObject) {//全部移动完毕，追加一个板子
                [wkSelf addNewStepAtEndWithCount:1];
                [wkSelf sprintStepWithCount:count-1];
            }
        }];
    }];
    [self moveDownBgStep];
}



//-(void)checkNowJumperStayStep{
//    NSArray *nodes = [self nodesAtPoint:_jumperPosition];
//    for (SKNode *node in nodes) {
//        if ([node.name isEqualToString:@"step"]) {
////            SKStepNode *step = (SKStepNode *)node;
////            if (step.isHole) {
////                [self wannaJumpOfCount:1];
////            }else{
//////                [self wannaJumpOfCount:1];
////            }
//        }
//    }
//    [self addNewStepAtEndWithCount:1];
//}

/**
 添加保护罩
 */
-(void)addProtectTojumper{
    
    SKSpriteNode *proNode = [SKSpriteNode spriteNodeWithImageNamed:@"jumper保护效果"];
    proNode.name = @"Protect";
    CGFloat width = (MAX(_jumper.size.width, _jumper.size.height))*1.3;
    proNode.size = CGSizeMake(width, width);
    proNode.position = CGPointMake(0, _jumper.size.height/2);
    [_jumper addChild:proNode];
    SKAction *zoom1 = [SKAction scaleXTo:1.1 y:1.1 duration:0.2];
    SKAction *zoom2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.2];
    SKAction *seq = [SKAction sequence:[NSArray arrayWithObjects:zoom1,zoom2,nil]];
    SKAction *rept = [SKAction repeatActionForever:seq];
    [proNode runAction:rept];
//    [self playProtectBgm];
}

/**
 移除保护罩
 */
-(void)removeProtectInJumper{
    SKNode *node =[_jumper childNodeWithName:@"Protect"];
    [node removeAllActions];
    [node removeFromParent];
//    [self initBgm];
}

-(void)sprintSomeDistance{
    
}
#pragma mark -- update

-(void)update:(NSTimeInterval)currentTime
{
    SKStepNode *firstStep = _stepsArray.firstObject;
    if (firstStep.position.y<0) {//超出屏幕，移除节点
        [firstStep removeFromParent];
    }
}

#pragma mark -- wannaJumpOfCount
/**
 点击跳跃的时候处理位移
 
 @param count 跳几次
 */
-(void)wannaJumpOfCount:(NSInteger )count{
    if (_shouldGuide) {
//        self.userInteractionEnabled = NO;
    }
    if ([_jumper actionForKey:@"sprint"] || [_jumper actionForKey:@"slipAction"]) {//冲刺的时候不响应
        return;
    }
    if ([_stepsArray.lastObject actionForKey:kStepMoveDownActionKey]) {//板子还在动
        return;
    }
    if ([self.jumper actionForKey:kJumperFallDownActionKey]) {//已经死了，不处理
        return;
    }
    if (self.jumper.reLive) {
        self.jumper.reLive = NO;
    }
     //处理跳跃者的动画
    __weak typeof(self) wkSelf = self;
    [self.jumper runAction:self.jumperAction];
//    添加新的阶梯
    [self addNewStepAtEndWithCount:count];
    
//    __block SKAction *stepDownAction = count ==1? self.stepDown1Action:self.stepDown2Action;
    
    
    //移动背景板子
    [self moveDownBgStep];

    
    //移动阶梯
    __block SKAction *stepDownAction = [self newStepDownActionWithCount:count];
    [_stepsArray enumerateObjectsUsingBlock:^(SKStepNode *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKAction *completion = [SKAction runBlock:^{
//            if (_shouldGuide) {//新手引导的时候不检测板子
//            }else{
                [wkSelf checkStep:obj];
//            }
        }];
        SKAction *sq = [SKAction sequence:[NSArray arrayWithObjects:stepDownAction,completion,nil]];
        [obj runAction:sq withKey:kStepMoveDownActionKey];
    }];
    
    //改变云彩的动画
    SKAction *cloudDown = [SKAction moveByX:0 y:-10*count duration:wkSelf.jumperAction.duration];
    [_cloudsArray enumerateObjectsUsingBlock:^(SKCloudNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj runAction:cloudDown completion:^{
            [wkSelf checkCloud:obj];
        }];
    }];
    
    if (_shouldGuide) {
        SKNode *corverNode = [self childNodeWithName:@"guidCorverNode"];
        
        [corverNode runAction:[SKAction actionNamed:@"fadeOutTo0"] completion:^{
            [self changeGuidAlertAction];
        }];
    }
}


/**
 改变引导层的动作
 */
-(void)changeGuidAlertAction{
    SKNode *corverNode = [self childNodeWithName:@"guidCorverNode"];
    [corverNode runAction:[SKAction actionNamed:@"fadeTo1"] completion:^{
        if (corverNode.position.x>self.size.width/2) {
            SKAction *mac1 = [SKAction moveToX:self.size.width/4 duration:0.5];
            [corverNode runAction:mac1 withKey:@"guidCorverNodeMove"];
            {
                SKSpriteNode *guidPintNode = (SKSpriteNode *)[self childNodeWithName:@"guidPointNode"];
                [guidPintNode removeActionForKey:@"guidPointNode"];
                SKAction *faout = [SKAction fadeAlphaTo:0 duration:0.2];
                SKAction *cg = [SKAction setTexture:[SKTexture textureWithImageNamed:@"guidPointR"]];
                SKAction *move = [SKAction moveToX:self.size.width/4*3 duration:0.1];
                SKAction *fain = [SKAction fadeAlphaTo:1 duration:0.3];
                SKAction *gpac = [SKAction sequence:[NSArray arrayWithObjects:faout,cg,move,fain,nil]];
                [guidPintNode runAction:gpac withKey:@"guidPiontChange"];
                SKAction *a1 = [SKAction moveByX:5 y:5 duration:0.5];
                SKAction *a2 = [SKAction moveByX:-5 y:-5 duration:0.5];
                SKAction *g = [SKAction sequence:[NSArray arrayWithObjects:a1,a2,nil]];
                SKAction *rg = [SKAction repeatActionForever:g];
                [guidPintNode runAction:rg withKey:@"guidPointNode"];
            }
            
            {
                SKSpriteNode *guidTextNode = (SKSpriteNode *)[self childNodeWithName:@"textNode"];
                SKAction *faout = [SKAction fadeAlphaTo:0 duration:0.2];
                SKAction *cg = [SKAction setTexture:[SKTexture textureWithImageNamed:@"Jump2Step"]];
                SKAction *move = [SKAction moveToX:self.size.width/4*3 duration:0.1];
                SKAction *fain = [SKAction fadeAlphaTo:1 duration:0.3];
                SKAction *gpac = [SKAction sequence:[NSArray arrayWithObjects:faout,cg,move,fain,nil]];
                [guidTextNode runAction:gpac withKey:@"guidPiontChange"];
                
            }
        }else{
            SKSpriteNode *guidPintNode = (SKSpriteNode *)[self childNodeWithName:@"guidPointNode"];
            SKSpriteNode *guidTextNode = (SKSpriteNode *)[self childNodeWithName:@"textNode"];
            [self removeChildrenInArray:[NSArray arrayWithObjects:corverNode,guidPintNode,guidTextNode,nil]];
            _shouldGuide = NO;
            [UserDefaultManager didGuid];
        }
//        self.userInteractionEnabled = YES;
    }];
    
}

/**
 移动背景色
 */
-(void)moveDownBgStep{
    SKAction *moveDown = [SKAction moveByX:0 y:-20 duration:0.1];
    //移动背景板子
    [_bgNodesArray enumerateObjectsUsingBlock:^(SKSpriteNode * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj runAction:moveDown];
        if (obj == _bgNodesArray.lastObject) {//移动第一个到最后一个
            SKSpriteNode *firstBg = _bgNodesArray.firstObject;
            if (firstBg.position.y<-firstBg.size.height/2) {
                [_bgNodesArray removeObject:firstBg];
                NSString *colorName = _bgColorsArray[_bgColorIndex];
                self.bgColorIndex+=1;
                
                SKAction *changec = [SKAction colorizeWithColor:[UIColor colorWithHexString:colorName] colorBlendFactor:0 duration:0];
                SKAction *changePosition = [SKAction moveTo:CGPointMake(obj.position.x, obj.position.y+firstBg.size.height) duration:0];
                [firstBg runAction:[SKAction group:[NSArray arrayWithObjects:changec,changePosition,nil]]];
                [_bgNodesArray addObject:firstBg];
            }
        }
    }];
}
#pragma mark --游戏辅助检测

/**
 检查下这个板子
 
 @param step 这个阶梯
 */
-(void)checkStep:(SKStepNode *)step {
    CGPoint point = CGPointMake(_jumperPosition.x, _jumperPosition.y);
    if ([step containsPoint:point]) {//jumper在这个板子上
        if (self.jumper.reLive) {//刚复活，处于金身状态
            return;
        }
        if (step.isHole) {
            [self jumperWillFallDown];
        }else{//不是洞，检查是否有道具
            __weak typeof(self)wkSelf = self;
            //检查道具
            self.currentStep = step;
            
            [self checkPropOnStep:step withInvincible:NO];
            ////不能呆太久的,一段时间不动要掉落
            if (_shouldGuide) {
                
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self howlongStay] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wkSelf wannaBreakJumperOnStep:step];
                });
            }
            
        }
    }
}
-(SKAction *)flyoutAction
{
    if (!_flyoutAction) {
        SKAction *a1 = [SKAction moveByX:100 y:100 duration:0.3];
        SKAction *a2 = [SKAction scaleXTo:0.2 y:0.2 duration:0.3];
        SKAction *g1 = [SKAction sequence:[NSArray arrayWithObjects:a1,a2,nil]];
        _flyoutAction = g1;
    }
    return _flyoutAction;
}

-(void)runEatGoldIconAction{
    if ([self.eatGoldIconNode hasActions]) {
        [self.eatGoldIconNode removeAllActions];
        [self.eatGoldIconNode removeFromParent];
        self.eatGoldIconNode.xScale = 0.1;
        self.eatGoldIconNode.yScale = 0.1;
    }
    self.eatGoldIconNode.xScale = 1.0;
    self.eatGoldIconNode.yScale = 1.0;
    self.eatGoldIconNode.position = _jumperPosition;
    [self addChild:self.eatGoldIconNode];
    __weak typeof(self) wkSelf = self;
    [self.eatGoldIconNode runAction:self.eatGoldActuin completion:^{
        [wkSelf.eatGoldIconNode removeFromParent];
        [wkSelf showGoldColins];
    }];
}


/**
 检查某个板子上的道具

 @param step 这个板子
 @param invincible 是否无敌状态
 */
-(void)checkPropOnStep:(SKStepNode *)step withInvincible:(BOOL)invincible {
    if (step.propNode) {
        if (step.propNode.style == PropStyleScoreAddGod) {
            _getGodCoins +=1;
            //吃金币的动画
            [self runEatGoldIconAction];
            //增加金币账户
            [WealthManager defaultManager].goldCoinAmount +=1;
            //移除道具
            [step.propNode removeFromParent];
            step.propNode = nil;
            //吃金币的音效
            if (![UserDefaultManager isSoundEffectClose]) {
                SKAction *eat = [SKAction playSoundFileNamed:@"godicon.caf" waitForCompletion:NO];
                [step runAction:eat];
            }
            
        }else if (step.propNode.style == PropStyleScoreSlide){
            if (invincible) {//无敌状态踢飞香蕉皮
                [step.propNode runAction:self.flyoutAction completion:^{
                    [step.propNode removeFromParent];
                    step.propNode = nil;
                }];
            }else{//否则检测是否碰到这个香蕉皮
//                SKSpriteNode *protect = (SKSpriteNode *)[_jumper childNodeWithName:@"Protect"];
//                if (protect) {//如果有保护者，移除香蕉皮
//                    [self removeProtectInJumper];
////                    [protect removeFromParent];
//                }else{//滑倒了
                
                [_jumper runAction:self.slipAction withKey:@"slipAction"];
                [step.propNode removeFromParent];
                step.propNode = nil;
//                [step.propNode runAction:self.flyoutAction completion:^{
//                    [step.propNode removeFromParent];
//                    step.propNode = nil;
//                }];
            }
        }else if (step.propNode.style == PropStyleScoreMoveToHit){
            if (invincible) {//无敌状态踢飞怪兽
                [step.propNode runAction:self.flyoutAction completion:^{
                    [step.propNode removeFromParent];
                    step.propNode = nil;
                }];
            }else{
                CGPoint jumperPoint = [self convertPoint:_jumper.frame.origin toNode:step];
                CGRect jumperRect = CGRectMake(jumperPoint.x+_jumper.size.width*0.2, jumperPoint.y, _jumper.size.width*0.5, _jumper.size.height*0.8);
                //小怪兽要循环检测
                [self checkMoveHitOnStep:step jumerRectInStep:jumperRect];
                
//                if (CGRectIntersectsRect(jumperRect, step.propNode.frame)) {
//                    [step.propNode removeFromParent];
//                    step.propNode = nil;
//                    [self jumperWillFallDown];
//                }else{
//                    __weak typeof(self)wkSelf = self;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [wkSelf checkStep:step];
//                    });
//                }
            }
        }
    }
}


/**
 反复检查是否碰撞到了junper

 @param step 怪兽在这个step上
 */
-(void)checkMoveHitOnStep:(SKStepNode *)step jumerRectInStep:(CGRect)jumperRect{
    if (_jumper.reLive || self.haveDied) {
        
        return;
    }
    if (_havePaused) {
        step.propNode.paused = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkMoveHitOnStep:step jumerRectInStep:jumperRect];
        });
        return;
    }
    step.propNode.paused = NO;
    if (step != _currentStep) {
        //已经跳过去了
        return;
    }
    if (step == nil || step.propNode == nil) {
        DDLogVerbose(@"不再检测这个小怪兽了");
        return;
    }
    //需要注意，已经过去的板子上的小怪兽碰撞不算
    
    if (CGRectIntersectsRect(jumperRect, step.propNode.frame)) {
        [step.propNode removeFromParent];
        step.propNode = nil;
        [self jumperWillFallDown];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkMoveHitOnStep:step jumerRectInStep:jumperRect];
        });
    }
}

/**
 能够停留的时间

 @return 秒数
 */
-(CGFloat)howlongStay{
    CGFloat duration = [[GameRuleManager defaultManager] currentRule].stepDuration;
    DDLogVerbose(@"step stay duration = %f",duration);
    return  duration;
}
/**
 想要碎裂让jumper掉下去

 @param step 这个踏板
 */
-(void)wannaBreakJumperOnStep:(SKStepNode *)step{
    if (_havePaused) {
        _pausedStep = step;
        return;
    }
    if (_haveDied) {//已经死了，没这么大仇，还要抽了板子
        return;
    }
    if (_jumper.reLive) {
        return;
    }
    if ([step containsPoint:_jumperPosition]) {
        if ([_jumper childNodeWithName:@"jumperHeader"]) {//开始冲刺了,就算没有冲出去，也不掉下去了
            
            return;
        }
        self.haveDied = YES;
        
        [_jumper removeAllActions];
        
        [step runAction:self.stepFallDownAction completion:^{
            
        }];
        [self jumperWillFallDown];
    }
}
/**
 检查下白云是否飘出去了
 
 @param cloud 这个白云
 */
-(void)checkCloud:(SKCloudNode *)cloud {
    if (cloud.position.y<-20) {//飘出去的移除
        [_cloudsArray removeObject:cloud];
        [cloud removeFromParent];
    }
    if (_cloudsArray.count<2) {//不够了，添加白云
        [self addOneCloudNodeMustStart:YES];
    }
}

#pragma mark -- 弹窗UIView

/**
 即将掉落
 */
-(void)jumperWillFallDown{
    if (_havePaused) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self jumperWillFallDown];
        });
        return;
    }
    self.haveDied = YES;
    [self.jumper runAction:self.jumperDiedAction withKey:kJumperFallDownActionKey];
}
/**
 弹窗提示是否复活
 */
-(void)alertReLiveOrDie{
    SKTexture *tr = [self.view textureFromNode:_sceneBgNode];
    UIImage *img = [[UIImage alloc]initWithCGImage:tr.CGImage];
    img =[img cutWithFrame:CGRectMake( img.size.width*0.3, img.size.height-YYScreenSize().height, YYScreenSize().width, YYScreenSize().height)];
    self.bgNodeImage = img;
    if (_reliveTimes==3) {
        [self changeToResultSceneWithWon:NO];
        return;
    }
    __weak typeof(self) wkSelf = self;
    _sceneBgNode.zPosition = 1000;
    ReliveViewController *reliveVC = [[ReliveViewController alloc]initWithNibName:@"ReliveViewController" bundle:nil];
    self.reliveVC = reliveVC;
    
    __weak typeof(reliveVC) wkVC = reliveVC;
    reliveVC.view.frame = self.view.bounds;
    
    [self.viewController addChildViewController:reliveVC];
    [self.view addSubview:reliveVC.view];
    //设置文字
    NSInteger dimodCount = [WealthManager defaultManager].diamondAmount;
    NSInteger thisPay = _eachRelovePayment*_reliveTimes;
    NSString *title = [NSString stringWithFormat:@"X%ld",(long)thisPay];
    if (thisPay>dimodCount) {
        title = NSLocalizedString(@"Inadequate Diamond", nil);
    }
    reliveVC.freeBtn.enabled = _reliveTimes<2;
    
    //设置回调
    self.reliveVC.dimondLabel.text = title;
    reliveVC.willCloseBlock = ^{
        wkSelf.sceneBgNode.zPosition = kBgLayerZ;
    };
    reliveVC.closeBlock = ^{
        [wkSelf removeAlertVC];
        [wkSelf changeToResultSceneWithWon:NO];
    };
    reliveVC.forFreeBlock = ^{
        CoreSVPLoading(@"loading..", NO);
        [wkVC pauseCutDown];
        [wkSelf requestRewardedVideo];
    };
    reliveVC.paymentBlock = ^{
        NSInteger checkDimodCount = [WealthManager defaultManager].diamondAmount;
        if (thisPay>checkDimodCount) {//钱不够，去充值
            [wkVC pauseCutDown];
            [wkSelf.reliveVC closeAlertVC:^{
                [wkSelf openStoreViewControllerWithCloseBlock];
            }];
            
            /*
            [wkSelf.reliveVC pauseCutDown];
            wkSelf.reliveVC.closeBtn.enabled = NO;
            
            [wkSelf openStoreViewControllerWithCloseBlock:^{
                NSInteger nowDimodCount = [WealthManager defaultManager].diamondAmount;
                if (nowDimodCount>thisPay) {
                    NSString *title = [NSString stringWithFormat:@"钻石X%ld复活",(long)thisPay];
                    wkSelf.reliveVC.dimondLabel.text = title;
                }
            }];
             */
        }else{//支付并复活
            [WealthManager defaultManager].diamondAmount -= thisPay;
            [wkSelf.reliveVC closeAlertVC:^{
                [FIRAnalytics logEventWithName:@"复活" parameters:@{@"类型": [NSString stringWithFormat:@"钻石第%ld次",(long)_reliveTimes]}];
                [wkSelf removeAlertVC];
                [wkSelf reLiveJumper];
                _reliveTimes +=1;
            }];
        }
    };
    
    
    
    /*
    ReLiveAlertView *realert = [[[NSBundle mainBundle]loadNibNamed:@"ReLiveAlertView" owner:self options:nil]lastObject];
    NSInteger dimodCount = [WealthManager defaultManager].diamondAmount;
    realert.reliveTimes = _reliveTimes;
    NSInteger thisPay = _eachRelovePayment*_reliveTimes;
    NSString *title = [NSString stringWithFormat:@" X%ld",(long)thisPay];
    if (thisPay>dimodCount) {
        title = @"余额不足";
    }
    [realert.payBtn setTitle:title forState:UIControlStateNormal];
    self.realert = realert;
    
    __weak typeof(self) wkSelf = self;
    realert.closeBlock = ^{
        [wkSelf changeToResultSceneWithWon:NO];
    };
    realert.forFreeBlock = ^{
        [wkSelf.realert pauseCutDown];
        [wkSelf.realert setCanClose:NO];
        wkSelf.realert.secLabel.font = [UIFont systemFontOfSize:15];
        wkSelf.realert.secLabel.text = @"loading video...";
        
        [wkSelf requestRewardedVideo];
    };
    realert.paymentBlock = ^{
        if (thisPay>dimodCount) {//钱不够，去充值
            [wkSelf.realert pauseCutDown];
            [wkSelf.realert setCanClose:NO];
            wkSelf.realert.secLabel.font = [UIFont systemFontOfSize:15];
            wkSelf.realert.secLabel.text = @"credit is running low";
            [wkSelf openStoreViewController];
        }else{
            [WealthManager defaultManager].diamondAmount -= thisPay;
            [wkSelf.realert dissmiss:^{
                [wkSelf reLiveJumper];
            }];
        }
    };
    
    realert.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    [self.view addSubview:realert];
    [realert animateShow];
     */
}

/**
 移除复活弹窗
 */
-(void)removeAlertVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.reliveVC.view removeFromSuperview];
        [self.reliveVC removeFromParentViewController];
        self.reliveVC = nil;
    });
}
/**
 移除复活弹窗
 */
-(void)removeVC:(UIViewController *)vc{
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    vc = nil;
}
/**
 弹窗游戏暂停
 */
-(void)alertPauseGame{
//    _sceneBgNode.zPosition = 1000;
    if (_haveDied) {
        return;
    }
    if ([WealthManager defaultManager].removedAD) {
        _havePaused = YES;
        
        PauseViewController *pause = [[PauseViewController alloc]initWithNibName:@"PauseViewController" bundle:nil];
        pause.view.frame = self.view.bounds;
        [self.viewController addChildViewController:pause];
        [self.view addSubview:pause.view];
        __weak typeof(pause) wkVC = pause;
        __weak typeof(self) wkSelf = self;
        pause.goHomeBlock = ^{
            [wkSelf removeVC:wkVC];
            [wkSelf goHomeScene];
        };
        pause.goOnBlock = ^{
            [wkSelf removeVC:wkVC];
            [wkSelf goOnGameAfterSec:3];
        };
        
    }else{
        _havePaused = YES;
        [self.view addSubview:self.pauseAlert];
        [self.pauseAlert animateShow];
        
    }
}

-(void)goOnGameAfterSec:(NSInteger)sec{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DDLogVerbose(@"应用不再活跃，等一会在说");
            [self goOnGameAfterSec:sec];
        });
        return ;
    }
    
    SKSpriteNode *cutNode = (SKSpriteNode *)[self childNodeWithName:@"cutDowmNode"];
//    SKLabelNode *labelNode = (SKLabelNode *)[cutNode childNodeWithName:@"cutDownlabelNode"];
    SKSpriteNode *labelNode = (SKSpriteNode *)[cutNode childNodeWithName:@"cutDownlabelNode"];
    if (!cutNode) {
        cutNode = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithWhite:0 alpha:0.5] size:self.size];
        cutNode.position = CGPointMake(self.size.width/2, self.size.height/2);
        cutNode.name = @"cutDowmNode";
        cutNode.zPosition = kAlertLayerZ;
        [self addChild:cutNode];
        
        labelNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"alert%ld",(long)sec]];
        labelNode.name = @"cutDownlabelNode";
        labelNode.position = CGPointMake(0, 0);
        [cutNode addChild:labelNode];
    }
    labelNode.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"alert%ld",(long)sec]];
    SKAction *zoom = [self zoomScaleX:1.3 scaleY:1.3];
    [labelNode runAction:zoom];
    
    if (sec==0) {//开始游戏
        [cutNode removeFromParent];
        _havePaused = NO;
        SKAction *a1 =[SKAction rotateByAngle:0.08 duration:0.2];
        SKAction *a2 =[SKAction rotateByAngle:-0.08 duration:0.3];
//        SKAction *a1 = [SKAction scaleXTo:1.1 y:1.1 duration:0.2];
//        SKAction *a2 = [SKAction scaleXTo:1.0 y:1.0 duration:0.2];
        [_jumper runAction:[SKAction sequence:[NSArray arrayWithObjects:a1,a2,nil]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self howlongStay] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//不能呆太久的
            [self wannaBreakJumperOnStep:_pausedStep];
        });
    }else{//等1秒再开始
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goOnGameAfterSec:sec-1];
        });
    }
}



/**
 复活juper
 */
-(void)reLiveJumper{
    __weak typeof(self) wkSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wkSelf addJumper];
//        [self initBgm];
        [_jumper removeAllActions];
        if (![UserDefaultManager isSoundEffectClose]) {
            SKAction *reliveEff = [SKAction playSoundFileNamed:@"relive.caf" waitForCompletion:NO];
            [_jumper runAction:reliveEff];
        }
        
        _jumperPosition = CGPointMake(CGRectGetMidX(wkSelf.frame),_eachHeight*(kJumperStartIndex+0)+_eachHeight*0.6);
        
        wkSelf.jumper.position = _jumperPosition;
        CGPoint nxtStePoint = CGPointMake(_jumperPosition.x, _jumperPosition.y+_eachHeight);
        NSArray * nodes = [wkSelf nodesAtPoint:nxtStePoint];
        
        [nodes enumerateObjectsUsingBlock:^(SKNode *node, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([node.name isEqualToString:@"step"]) {
                *stop = YES;
                SKStepNode *step = (SKStepNode *)node;
                if (step.isHole) {
                    [wkSelf wannaJumpOfCount:2];
                }else{
                    [wkSelf wannaJumpOfCount:1];
                }
            }
        }];

        
        //跳的时候就会触发取消复活金身，所以设置金身要在之后
        wkSelf.jumper.reLive = YES;
        [wkSelf.bgmPlayer play];
        wkSelf.haveDied = NO;
    });
    
}
-(void)payForAlive{
    
}
#pragma mark -- 奖励视频广告
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
    
//    if ([((GameViewController *)self.viewController) showRewardVideo]) {
//        [CoreSVP dismiss];
//    }else{
//        [CoreSVP dismiss];
//        CoreSVPCenterMsg(@"error !");
//    }
    /*
    if (![[GADRewardBasedVideoAd sharedInstance] isReady]) {
        GADRequest *request = [GADRequest request];
//        request.testDevices = @[ @"1a0d2fc39522a82f72bfc130b3f788ba" ];
        
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                               withAdUnitID:@"ca-app-pub-5418531632506073/7085123545"];
    }
     */
}
- (void)showVideo{
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self.viewController];
    } else {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
}

#pragma mark --切换场景
-(void)dealocInmobiNativeAD{
    [self.InMobiNativeAd recyclePrimaryView];
    self.InMobiNativeAd.delegate = nil;
}
-(void)disablereliveVC{
    if (self.reliveVC) {
        [self.reliveVC pauseCutDown];
        [self.reliveVC.view removeFromSuperview];
        self.reliveVC = nil;
    }
}
/**
 切换场景
 
 @param won 是否胜利
 */
-(void) changeToResultSceneWithWon:(BOOL)won
{
    [FIRAnalytics logEventWithName:@"分数" parameters:@{@"分数段": [self scoreAreaString],@"得分":@(_passedSteps)}];
    [self.bgmPlayer stop];
    self.bgmPlayer = nil;
    [self disablereliveVC];
//    self.backgroundColor = [UIColor lightGrayColor];
//    [self removeAllChildren];
//    [self removeAllActions];
//    [self updateNewScore];
    if (!self.bgNodeImage) {
        DDLogWarn(@"没有bgNodeImage哇，代码生成一个喽");
        NSMutableArray *colors = [[NSMutableArray alloc]init];
        NSInteger begain = _bgColorIndex-2;
        if (begain<0) {
            begain = 0;
        }
        for (NSInteger i= 0; i<3; i++) {
            [colors addObject:_bgColorsArray[begain]];
            if (begain>0) {
                begain--;
            }else{
                begain = _bgColorsArray.count-1;
            }
        }
        self.bgNodeImage = [self cutImageFromCurrentColors:colors];
    }
    
    ResultScene *rs = [[ResultScene alloc] initWithSize:self.size won:won source:_passedSteps goldIcon:_getGodCoins bgColorsImage:self.bgNodeImage];
//    ResultScene *rs = [[ResultScene alloc] initWithSize:self.size won:won source:_passedSteps];
//    rs.backgroundColor = [UIColor lightGrayColor];
    
    
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.5];
    [self.scene.view presentScene:rs transition:reveal];
    [self dealocInmobiNativeAD];
}


/**
 根据三个颜色返回一个彩条图

 @param colorNames 三个颜色数组
 @return 彩条图
 */
-(UIImage *)cutImageFromCurrentColors:(NSArray *)colorNames{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height)];
    
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YYScreenSize().width, YYScreenSize().height/3)];
    v1.backgroundColor = [UIColor colorWithHexString:colorNames[0]];
    [view addSubview:v1];
    
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(0, YYScreenSize().height/3, YYScreenSize().width, YYScreenSize().height/3)];
    v2.backgroundColor = [UIColor colorWithHexString:colorNames[1]];
    [view addSubview:v2];
    
    UIView *v3 = [[UIView alloc]initWithFrame:CGRectMake(0, YYScreenSize().height/3*2, YYScreenSize().width, YYScreenSize().height/3)];
    v3.backgroundColor = [UIColor colorWithHexString:colorNames[2]];
    [view addSubview:v3];
    
    UIImage *img = [UIImage cutFromView:view];
    return img;
    
}
-(NSString *)scoreAreaString{
    if (_passedSteps<50) {
        return @"0~50";
    }else if (_passedSteps>=50&&_passedSteps<100){
        return @"50~100";
    }else if (_passedSteps>=100&&_passedSteps<200){
        return @"100~200";
    }else if (_passedSteps>=200&&_passedSteps<300){
        return @"200~300";
    }else if (_passedSteps>=300&&_passedSteps<500){
        return @"300~500";
    }else if (_passedSteps>=500&&_passedSteps<1000){
        return @"500~1000";
    }else {
        return @"1000+";
    }
}
/**
 回到主页场景
 */
-(void)goHomeScene
{
    [self.bgmPlayer stop];
    self.bgmPlayer = nil;
    [self disablereliveVC];
//    [self updateNewScore];
    StartScene *start = [StartScene sceneWithSize:self.size];
    SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:0.3];
    start.backgroundColor = [UIColor darkGrayColor];
    [self.scene.view presentScene:start transition:reveal];
    [self dealocInmobiNativeAD];
}

-(void)changeToGameScene
{
    JumpScene *ms = [JumpScene sceneWithSize:self.size];
    [ms customUI];
    SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1.0];
    ms.backgroundColor = [UIColor whiteColor];
    [self.scene.view presentScene:ms transition:reveal];
}
-(void)openStoreViewControllerWithCloseBlock{
    [self disablereliveVC];
    StoreViewController *store = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
    store.view.frame = self.view.bounds;
    [self.viewController addChildViewController:store];
    [self.view addSubview:store.view];
    __weak typeof(self) wkSelf = self;
    store.closeVCBlock = ^{
        [wkSelf alertReLiveOrDie];
    };
}
//-(void)openStoreViewControllerWithCloseBlock:(void(^)(void))closeBlock{
//    
//        StoreViewController *store = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
//        store.view.frame = self.view.bounds;
//        [self.viewController addChildViewController:store];
//        [self.view addSubview:store.view];
//        __weak typeof(self) wkSelf = self;
//        store.closeVCBlock = ^{
//            wkSelf.reliveVC.closeBtn.enabled = YES;
//            [wkSelf.reliveVC reStartCutDown];
//            closeBlock();
//        };
//}
#pragma mark -- inmobi原生广告
-(void)requestInmobiNativeAds{
    self.InMobiNativeAd = [[IMNative alloc] initWithPlacementId:1503177764626];
    self.InMobiNativeAd.delegate = self;
    [self.InMobiNativeAd load];
}


#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    [self startNewGame];
}

#pragma mark -- inmobi的原生广告回调
-(void)nativeDidFinishLoading:(IMNative*)native{
    UIView* adPrimaryViewOfCorrectWidth = [native primaryViewOfWidth:YYScreenSize().width*0.75];
    adPrimaryViewOfCorrectWidth.frame = CGRectMake(0, 0, YYScreenSize().width*0.75, YYScreenSize().width*0.75);
    [self.pauseAlert.nativeAdPlaceholder addSubview:adPrimaryViewOfCorrectWidth];
    [adPrimaryViewOfCorrectWidth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.pauseAlert.nativeAdPlaceholder);
    }];
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
//    [self requestInmobiNativeAds];
    [native recyclePrimaryView];
    native.delegate= nil;
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



#pragma mark GADRewardBasedVideoAdDelegate implementation
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"Reward based video ad failed to load.%@",error.localizedDescription);
    [CoreSVP dismiss];
    CoreSVPCenterMsg(@"failed to load");
    [self.reliveVC reStartCutDown];
    self.reliveVC.closeBtn.enabled = YES;
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is received.");
    [CoreSVP dismiss];
    
    [self showVideo];
    self.reliveVC.closeBtn.enabled = YES;
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad is closed.");
    if (self.reliveVC) {
        [self.reliveVC reStartCutDown];
    }
//    [self goOnGameAfterSec:3];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    
    [self rewardVideoFinished];
}

-(void)rewardVideoFinished{
    self.sceneBgNode.zPosition = kBgLayerZ;
    _reliveTimes +=1;
    [FIRAnalytics logEventWithName:@"复活" parameters:@{@"类型": @"免费"}];
    [self reLiveJumper];
    [self removeAlertVC];
}
@end
