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
    
    self.gongzhong.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.gongzhong.layer.borderWidth = 1;
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

-(void)setMOdel:(DWOrderModel *)MOdel
{
    _MOdel = MOdel;
    NSMutableAttributedString *attRstring =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"预计%@天",MOdel.yuji]];
    
    NSRange range = NSMakeRange(2, attRstring.length-3);
    [ attRstring addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.date.text = MOdel.createtime;
    self.date.font = [UIFont systemFontSizeWithScreen:15];
    self.Adress.text = MOdel.adr;
    self.Adress.font = [UIFont systemFontSizeWithScreen:15];
    self.dingDanhao.text = MOdel.ordercode;
    self.dingDanhao.font = [UIFont systemFontSizeWithScreen:13];
    self.yujitianshu.attributedText = attRstring;
    self.yujitianshu.font = [UIFont systemFontSizeWithScreen:13];
    self.gongzhong.text = MOdel.gzname;
    self.gongzhong.font = [UIFont systemFontSizeWithScreen:12];
    
    self.zhuangTai.font = [UIFont systemFontSizeWithScreen:13];

    
    if ([MOdel.baozhengjin intValue]>0) {
        [self.biaoZhiImageV setImage:[UIImage imageNamed:@"保"] forState:UIControlStateNormal];
    }else
    {
        [self.biaoZhiImageV setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    if ([MOdel.jiesuanshu intValue]>0) {
        
        self.jiesuanshuBtn.hidden = NO;
        [self.jiesuanshuBtn setTitle:MOdel.jiesuanshu forState:UIControlStateNormal];
    }else
    {
        self.jiesuanshuBtn.hidden = YES;
    }
    
//    if (self.deleteBtn.hidden) {
//        self.rowHeit = self.frame.origin.y+10;
//    }else
//    {
//        self.rowHeit = self.deleteBtn.frame.size.height +self.frame.origin.y+10;
//    }
    
}

@end
