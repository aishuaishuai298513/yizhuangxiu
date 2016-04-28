//
//  MyMessageCell.h
//  zhaiyi
//
//  Created by ass on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tongzhiL;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) NSString *XiaoxiID;

@property (nonatomic, copy )void(^DelMessageBlock)();

- (IBAction)removeCell:(id)sender;

@end
