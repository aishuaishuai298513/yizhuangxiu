//
//  QiangDanTableViewCell.m
//  zhaiyi
//
//  Created by ass on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QiangDanTableViewCell.h"

@interface QiangDanTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *shengYuRenShu;

@property (weak, nonatomic) IBOutlet UILabel *renShu;

@property (weak, nonatomic) IBOutlet UILabel *jiaGe;

@property (weak, nonatomic) IBOutlet UIButton *gongZhong;

@property (weak, nonatomic) IBOutlet UILabel *Adrees;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhangDanId;


- (IBAction)qiangBtn:(id)sender;

@end

@implementation QiangDanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)qiangBtn:(id)sender {
    
    if (_qiangBlock) {
        _qiangBlock(self.indexPath);
    }
    
}


-(void)setCellModel:(DWOrderModel *)cellModel
{
    _cellModel = cellModel;
    NSString *datestr1=[NSString dateString:_cellModel.startDate];
    NSString *datestr2=[NSString dateString:_cellModel.endDate];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",datestr1,datestr2];

    self.Adrees.text = _cellModel.address;
 
    self.renShu.text = _cellModel.num;
    self.jiaGe.text = [NSString stringWithFormat:@"%d元/天",[_cellModel.money intValue]];
    
    //富文本
    NSString *yuren = [NSString stringWithFormat:@"余%d人",[_cellModel.num intValue]-[_cellModel.in_num intValue]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:yuren];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(1, yuren.length-2)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(1, yuren.length-2)];

    self.shengYuRenShu.attributedText = attributeStr;
    
//    self.shengYuRenShu.text = [NSString stringWithFormat:@"余%d人",[_cellModel.num intValue]-[_cellModel.in_num intValue]];
    self.zhangDanId.text = _cellModel.ddh;
    
    NSInteger type = [_cellModel.gztypeid integerValue];
    switch (type) {
        case 1:{
            [_gongZhong setTitle:@"泥工" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            [_gongZhong setTitle:@"油工" forState:UIControlStateNormal];
        }
            break;
        case 3:{
            [_gongZhong setTitle:@"水工" forState:UIControlStateNormal];
        }
            break;
        case 4:{
            [_gongZhong setTitle:@"电工" forState:UIControlStateNormal];
        }
            break;
        case 5:{
            [_gongZhong setTitle:@"木工" forState:UIControlStateNormal];
        }
            break;
        case 6:{
            [_gongZhong setTitle:@"小工" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    
 
    
}

@end
