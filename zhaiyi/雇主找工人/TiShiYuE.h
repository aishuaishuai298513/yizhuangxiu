//
//  TiShiYuE.h
//  zhaiyi
//
//  Created by ass on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiShiYuE : UIView

+(instancetype)loadView;
- (void)MakeSureBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
