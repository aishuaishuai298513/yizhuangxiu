//
//  ContactheadView.m
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ContactheadView.h"

@interface ContactheadView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *office;
@end
@implementation ContactheadView

+(instancetype)loadheadView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ContactheadView" owner:nil options:nil]lastObject];
}

-(void)setDataSource:(NSMutableDictionary *)dataSource
{
    _dataSource = dataSource;
    self.name.text = [_dataSource objectForKey:@"appname"];
    self.office.text = [_dataSource objectForKey:@"company"];
    
}
@end
