//
//  DWOrderCell.m
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWOrderCell.h"

@implementation DWOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteBtnActin:(UIButton *)sender {
    if (_deleteBlock) {
        _deleteBlock(sender);
    }
}

- (IBAction)evaluateBtnAction:(UIButton *)sender {
    if (_evaluateBlock) {
        _evaluateBlock(sender);
    }
}
@end
