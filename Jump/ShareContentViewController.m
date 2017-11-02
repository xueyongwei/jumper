//
//  ShareContentViewController.m
//  Jump
//
//  Created by xueyognwei on 2017/8/11.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "ShareContentViewController.h"
#import "UserDefaultManager.h"
@interface ShareContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressTorecoderLabel;


@end

@implementation ShareContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameDesLabel.text = NSLocalizedString(@"Hop or Jump，Survival or Death", nil);
    self.pressTorecoderLabel.text = NSLocalizedString(@"Long press to identify", nil);
    // Do any additional setup after loading the view from its nib.
}
-(void)setScore:(NSInteger)score
{
    _score = score;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)score];
    
}
-(void)setNewRecord:(BOOL)newRecord
{
    _newRecord = newRecord;
    if (newRecord) {//新纪录
        self.flagImageView.hidden = NO;
        self.scoreDescLabel.text = NSLocalizedString(@"New Record", nil);
    }else{
        self.flagImageView.hidden = YES;
        self.scoreDescLabel.text = NSLocalizedString(@"Score", nil);
    }
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
