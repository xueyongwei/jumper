//
//  SettingCollectionViewCell.m
//  Jump
//
//  Created by xueyognwei on 2017/8/1.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "SettingCollectionViewCell.h"
#import "UserDefaultManager.h"
@implementation SettingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"changchengteyuanti" size:14];
    // Initialization code
}
-(void)setModel:(SettingModel *)model atIndexPath:(NSIndexPath *)indexPath{
    _model = model;
    _indexPath = indexPath;
    self.titleLabel.text = model.title;
    [self.iconImageBTn setImage:[UIImage imageNamed:model.imgName] forState:UIControlStateNormal];
    [self.iconImageBTn setImage:[UIImage imageNamed:[model.imgName stringByAppendingString:@"_关"]] forState:UIControlStateSelected];
    if (self.indexPath.item == 0) {
        self.iconImageBTn.selected = [UserDefaultManager isBgmClose];
    }else if (self.indexPath.item ==1){
         self.iconImageBTn.selected = [UserDefaultManager isSoundEffectClose];
    }else {
        self.iconImageBTn.selected = NO;
    }
}
- (IBAction)onBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                if (finished) {
                    if (self.clickBtnBlock) {
                        self.clickBtnBlock(self.indexPath);
                    }
                    if (self.indexPath.item == 0) {
                        sender.selected = !sender.selected;
                        [UserDefaultManager setBgmClose:sender.selected];
                    }else if (self.indexPath.item ==1){
                        sender.selected = !sender.selected;
                        [UserDefaultManager setSoundEffectClose:sender.selected];
                    }else {
                        
                    }
                }
            }];
        }
    }];
    
}

@end
