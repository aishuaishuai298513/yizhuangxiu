//
//  MyMessageCell.m
//  zhaiyi
//
//  Created by ass on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyMessageCell.h"

@interface MyMessageCell()



@end

@implementation MyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)removeCell:(id)sender {
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.XiaoxiID forKey:@"id"];
    
    [NetWork postNoParm:YZX_delmessage params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            if (self.DelMessageBlock) {
                _DelMessageBlock();
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
