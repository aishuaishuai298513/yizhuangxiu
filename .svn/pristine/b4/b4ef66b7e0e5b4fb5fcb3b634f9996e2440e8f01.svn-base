//
//  MySearch.m
//  zhaiyi
//
//  Created by ass on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MySearch.h"

@interface MySearch()


@end

@implementation MySearch

+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MySearch" owner:nil options:nil] firstObject];

}

-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)YuYinAddTarget:(id)target action:(SEL)action
{
     [self.YuYin addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)SearchAddTarget:(id)target action:(SEL)action
{
    [self.SearchBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
