//
//  ContactheadView.h
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactheadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contactLb;
+(instancetype)loadheadView;
@property (nonatomic ,strong) NSMutableDictionary *dataSource;

@end
