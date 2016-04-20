//
//  My_pocket_jiaoyijiluDetil_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_jiaoyijiluDetil_ViewController.h"
#import "TradeRecordModel.h"

@interface My_pocket_jiaoyijiluDetil_ViewController ()
{
    NSDictionary *detailDict;
    UILabel *zhanghu;
    UILabel *zhanhuNameL;
    
    UILabel *goodsLb;
    UILabel *statusLb;
    UILabel *createtimeLb;
    UILabel *jiaoyifangshi;
    UILabel *jiaoyidanhao;

    UILabel *dingdanhao;
    UILabel *dingdanhaoNeirong ;
}
@end

@implementation My_pocket_jiaoyijiluDetil_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setExtraCellLineHidden:self.tableView];
    [self getPostData];
    self.title = @"交易详情";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellID;
    if (indexPath.row==0) {
        cellID=@"cell1";
        
    }else
    {
        cellID=@"cell2";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    //金额

    if (indexPath.row==0) {
       zhanghu = [cell viewWithTag:410];
        //充值账户 or 对方账户
    zhanhuNameL = [cell viewWithTag:418];
        
    }else
    {
        goodsLb = [cell viewWithTag:411];
        statusLb = [cell viewWithTag:412];
        createtimeLb = [cell viewWithTag:413];
        jiaoyifangshi = [cell viewWithTag:414];
        jiaoyidanhao = [cell viewWithTag:415];
        //订单号
       dingdanhao = [cell viewWithTag:419];
        //订单内容
        dingdanhaoNeirong = [cell viewWithTag:416];
    }
    
     //支付
    if ([[self.List objectForKey:@"leixing"]isEqualToString:@"33"]) {
        zhanhuNameL.text = @"对方账户";
    }
    //充值
    if ([[self.List objectForKey:@"leixing"]isEqualToString:@"35"])
    {
        zhanhuNameL.text = @"充值账户";
        dingdanhao.hidden = YES;
        dingdanhaoNeirong.hidden = YES;
        
    }
    

    NSString *status = [NSString stringWithFormat:@"%@",[detailDict objectForKey:@"status"]];
    if ([status isEqualToString:@"107"]) {
        statusLb.text = @"提现申请已提交";;
    }
    if ([status isEqualToString:@"108"]) {
        statusLb.text = @"提现申请已完成";
    }
    
    TradeRecordModel *model = [[TradeRecordModel alloc]init];
    [model setValuesForKeysWithDictionary:detailDict];
    NSRange range = NSMakeRange(16, 3);
//    bankNameLb.text = [NSString stringWithFormat:@"%@(%@)",model.bank_name,[model.bank_number substringWithRange:range]];
//    moneyLb.text = model.carry_cash;
//    goodsLb.text = model.goods_type;
//    createtimeLb.text = model.createtime;
//    updatetimeLb.text = model.updatetime;
//    orderNumLb.text = model.order_number;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 50;
    }else
    {
        return 200;
    }
}



-(void)getPostData{
    
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm  = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:[self.List objectForKey:@"id" ]forKey:@"id"];
    
    NSLog(@"%@",[self.List objectForKey:@"id" ]);
    
    [NetWork postNoParm:YZX_jiaoyijiluxiangqing params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            zhanghu.text = [[responseObj objectForKey:@"data"] objectForKey:@"chongzhizhanghu"];
            goodsLb.text = [[responseObj objectForKey:@"data"] objectForKey:@"money"];
            statusLb.text = [[responseObj objectForKey:@"data"] objectForKey:@"status"];
            createtimeLb.text = [[responseObj objectForKey:@"data"] objectForKey:@"createtime"];
            jiaoyifangshi.text = [[responseObj objectForKey:@"data"] objectForKey:@"jiaoyifangshi"];
            jiaoyidanhao.text = [[responseObj objectForKey:@"data"] objectForKey:@"jiaoyidanhao"];
            dingdanhaoNeirong.text = [[responseObj objectForKey:@"data"] objectForKey:@"ordercode"];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


@end
