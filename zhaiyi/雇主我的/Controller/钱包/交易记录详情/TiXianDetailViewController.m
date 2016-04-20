//
//  TiXianDetailViewController.m
//  zhaiyi
//
//  Created by ass on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TiXianDetailViewController.h"

@interface TiXianDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jiaoyileixingT;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyijineT;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiT;

@property (weak, nonatomic) IBOutlet UILabel *changjianShijianT;

@property (weak, nonatomic) IBOutlet UILabel *jiaoyifangshiT;

@property (weak, nonatomic) IBOutlet UILabel *jiaoyidanhaoT;

@property (weak, nonatomic) IBOutlet UILabel *dingdanhaoT;
@property (weak, nonatomic) IBOutlet UILabel *dingdanhaoL;

@end

@implementation TiXianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWork];
    self.title = @"交易详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)netWork
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[self.List objectForKey:@"id"] forKey:@"id"];
    
    [NetWork postNoParm:YZX_jiaoyijiluxiangqing params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            _jiaoyileixingT.text = [[responseObj objectForKey:@"data"] objectForKey:@"leixing"];
            
            _jiaoyijineT.text =[[responseObj objectForKey:@"data"] objectForKey:@"money"];
            
           _zhuangtaiT.text = [[responseObj objectForKey:@"data"] objectForKey:@"status"];
            
           _changjianShijianT.text = [[responseObj objectForKey:@"data"] objectForKey:@"createtime"];
            
          _jiaoyifangshiT.text = [[responseObj objectForKey:@"data"] objectForKey:@"jiaoyifangshi"];
            
            _jiaoyidanhaoT.text = [[responseObj objectForKey:@"data"] objectForKey:@"jiaoyidanhao"];
            
            _dingdanhaoT.text = [[responseObj objectForKey:@"data"] objectForKey:@"ordercode"];
            
            if ([[self.List objectForKey:@"leixing"]isEqualToString:@"32"]) {
                _dingdanhaoL.hidden = YES;
                _dingdanhaoT.hidden = YES;
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
