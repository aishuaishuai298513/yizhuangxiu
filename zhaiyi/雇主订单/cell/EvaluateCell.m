//
//  EvaluateCell.m
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "EvaluateCell.h"

@interface EvaluateCell()


@property (weak, nonatomic) IBOutlet UIButton *Delete;

@property (nonatomic, assign) int xingji;

@property (nonatomic, assign) BOOL isFabiaopinglun;


- (IBAction)xingClicked:(id)sender;


//这是评论或者删除
- (IBAction)deleteClicked:(id)sender;

@end

@implementation EvaluateCell

- (void)awakeFromNib {
    // Initialization code
    
    _isFabiaopinglun = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)xingClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    //NSLog(@"%d",btn.tag);
    _xingji = btn.tag;
    
    
    for (int i = 1; i<=5; i++) {
        
        for (UIView *view in self.contentView.subviews) {
            if (view.tag == i) {
                UIButton *btn = (UIButton *)view;
                
                [btn setBackgroundImage:[UIImage imageNamed:@"xing3"] forState:UIControlStateNormal];
            }
        }
    }
    
    for (int i = 1; i<=btn.tag; i++) {
        
            for (UIView *view in self.contentView.subviews) {
                if (view.tag == i) {
                    UIButton *btn = (UIButton *)view;
                    
                    [btn setBackgroundImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                }
            }
}
}

////发表评论
//- (IBAction)deleteClicked:(id)sender {
//    if (_isFabiaopinglun == YES) {
//        
//        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//        
//        [parm setObject:self.UserAcount.userid forKey:@"user_id"];
//        [parm setObject:[NSString stringWithFormat:@"%d",_xingji] forKey:@"degree"];
//        [parm setObject:self.OrderModel.ddh forKey:@"order_number"];
//        NSLog(@"%@",self.OrderModel.ddh);
//        [parm setObject:self.pingjiaText.text forKey:@"content"];
//        [parm setObject:self.OrderModel.ID forKey:@"send_id"];
//        NSLog(@"%@",self.pingjiaText.text);
//        
//        if (_xingji <1 || self.pingjiaText.text.length<=0) {
//            [ITTPromptView showMessage:@"评价内容不能为空"];
//            return;
//        }
//        
//        [NetWork postNoParm:danduPingjia params:parm success:^(id responseObj) {
//            NSLog(@"%@",responseObj);
//            
//            if ([[responseObj objectForKey:@"code"] isEqualToString:@"1000"]) {
//                [ITTPromptView showMessage:@"评价成功"];
//                [self.Delete setTitle:@"删除" forState:UIControlStateNormal];
//                _isFabiaopinglun = NO;
//            }
//            
//        } failure:^(NSError *error) {
//            
//        }];
//    }else
//    {
//        //删除
//        if ([self.delegate respondsToSelector:@selector(cellDeleteClicked:)]) {
//            [self.delegate cellDeleteClicked:self];
//        }
//        
//    }
//    
//}

@end
