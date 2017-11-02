//
//  GameViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/6/28.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "GameViewController.h"
#import "StartScene.h"
#import "ResultScene.h"
#import "SetingViewController.h"
#import "UIViewController+WXSTransition.h"
#import "HYFileManager.h"
#import "LoadingViewController.h"
@implementation GameViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    SKView *skView = (SKView *)self.view;
    // Present the scene
    StartScene *start = [[StartScene alloc]initWithSize:self.view.bounds.size];
//    ResultScene *start = [[ResultScene alloc]initWithSize:self.view.bounds.size won:YES source:100];
    // Set the scale mode to scale to fit the window
    start.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:start];
    
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self textSet];
}
-(void)textSet{
    [[GameCenterManager sharedManager] setDelegate:self];
    
    SetingViewController *setVC = [[SetingViewController alloc]initWithNibName:@"SetingViewController" bundle:nil];
    setVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self wxs_presentViewController:setVC animationType:WXSTransitionAnimationTypeCover completion:nil];
    [self presentViewController:setVC animated:YES completion:nil];
}
- (BOOL)shouldAutorotate {
    return YES;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}





//------------------------------------------------------------------------------------------------------------//
//------- GameKit Delegate -----------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - GameKit Delegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (gameCenterViewController.viewState == GKGameCenterViewControllerStateAchievements) {
        
    } else if (gameCenterViewController.viewState == GKGameCenterViewControllerStateLeaderboards) {
        
    } else {
        
    }
}

//------------------------------------------------------------------------------------------------------------//
//------- GameCenter Manager Delegate ------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
    NSLog(@"GC Availabilty: %@", availabilityInformation);
    if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) {
        [self.navigationController.navigationBar setValue:@"GameCenter Available" forKeyPath:@"prompt"];
        
    } else {
        [self.navigationController.navigationBar setValue:@"GameCenter Unavailable" forKeyPath:@"prompt"];
        
    }
    
    GKLocalPlayer *player = [[GameCenterManager sharedManager] localPlayerData];
    if (player) {
        if ([player isUnderage] == NO) {
            
            [[GameCenterManager sharedManager] localPlayerPhoto:^(UIImage *playerPhoto) {
                
            }];
        } else {
            
        }
    } else {
        
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
    NSLog(@"GCM Error: %@", error);
   
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Achievement: %@", achievement);
        
    } else {
        NSLog(@"GCM Error while reporting achievement: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Score: %@", score);
        
    } else {
        NSLog(@"GCM Error while reporting score: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
    NSLog(@"Saved GCM Score with value: %lld", score.value);
    
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
    NSLog(@"Saved GCM Achievement: %@", achievement);
   
}

@end
