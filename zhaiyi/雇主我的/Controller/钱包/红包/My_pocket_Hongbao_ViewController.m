//
//  My_pocket_Hongbao_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_Hongbao_ViewController.h"
#import "My_pocket_HongbaoHeader_ViewCell.h"



@interface My_pocket_Hongbao_ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tb;
    NSString *_lx;
    NSArray *_hongbaoArr;
    NSString *_moneyText;
    NSString *_name;
    NSString *_imagUrl;
    ADAccount *_account;
}


@end

@implementation My_pocket_Hongbao_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"红包";
    [self MakeUI];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initalData];
    [self loadMoneyData];
    
}
-(void)initalData{
//    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
//    _userInfoDict = [userDefualts objectForKey:@"enter_user_info"];
    _hongbaoArr = [NSArray array];
    _account = [ADAccountTool account];
    _moneyText = @"0.00";
}
#pragma mark 下拉刷新
-(void)MJRefreshPull{
    
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadMoneyData];
        
    }];
}



-(void)MakeUI
{
    self.view.backgroundColor=[UIColor whiteColor];
     tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kU , Ga)];
    tb.delegate=self;
    tb.dataSource=self;
    [self.view addSubview:tb];
    [self MJRefreshPull];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _hongbaoArr.count+1;
//    return 1;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
        My_pocket_HongbaoHeader_ViewCell * cell;
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"My_pocket_HongbaoHeader_ViewCell" owner:self options:nil]lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if (GetUserDefaultsGR) {
            //工人
            cell.nameLb.text = [NSString stringWithFormat:@"%@共收到红包",_name];
            NSString *picStr = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,_imagUrl];
            
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:nil];
            
            //[NSString stringWithFormat:@"¥%@",_moneyText];
            cell.moneyLb.text = [NSString stringWithFormat:@"¥%@",_moneyText];
        } else {
            
            cell.nameLb.text = [NSString stringWithFormat:@"%@共收到红包",_name];
            NSString *picStr = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,_imagUrl];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:nil];
            //cell.moneyLb.text = _moneyText;
            cell.moneyLb.text = [NSString stringWithFormat:@"¥%@",_moneyText];

        }
        return cell;
        
    }else
    {
        UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1=[[UITableViewCell alloc]init];
        }
        if (_hongbaoArr.count != 0) {
            NSDictionary *dict = [_hongbaoArr objectAtIndex:indexPath.row-1];
            UILabel * title=[[UILabel alloc]init];
            title.font=[UIFont systemFontOfSize:14];
            title.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fasongren"]];
            
            CGSize size=[title sizeThatFits:CGSizeMake(MAXFLOAT,30)];
            if (size.width>kU/2) {
                title.frame=CGRectMake(10, 7, kU/2, 30);
            }else
            {
                title.frame=CGRectMake(10, 7, size.width, 30);
            }
            [cell1.contentView addSubview:title];
            
            UILabel * time=[[UILabel alloc]initWithFrame:CGRectMake(size.width+15, 7, 120, 30)];
            
            NSString *timeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"createtime"]];
            
            time.text= [timeStr substringToIndex:10];
            
            time.textColor=[UIColor grayColor];
            time.font=[UIFont systemFontOfSize:12];
            [cell1.contentView addSubview:time];
            
            UILabel * money=[[UILabel alloc]initWithFrame:CGRectMake(kU-60, 7, 50, 30)];
            money.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"money"]];
            money.textColor=[UIColor redColor];
            money.font=[UIFont systemFontOfSize:14];
            [cell1.contentView addSubview:money];
            
            
        }
       
        
        
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(10, 43, kU-20, 1)];
        view.backgroundColor=[UIColor myColorWithString:@"f4f4f4"];
        [cell1.contentView addSubview:view];
        return cell1;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 250;
    }else
    {
        return 44;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadMoneyData{

//    NSLog(@"钱包钱包 %@",dict);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_account.userid forKey:@"userid"];
    [params setObject:_account.token forKey:@"token"];
    
        [NetWork postNoParm:YZX_hongbao params:params success:^(id responseObj) {
            NSLog(@"钱包成功:%@",responseObj);
            if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
            
            
                _hongbaoArr = [responseObj objectForKey:@"list"];
                //
                NSLog(@"红包 %@",_hongbaoArr);
                _moneyText = [[responseObj objectForKey:@"data"]objectForKey:@"count"];
                _name = [[responseObj objectForKey:@"data"]objectForKey:@"name"];
                _imagUrl =[[responseObj objectForKey:@"data"]objectForKey:@"headpic"];

                NSLog(@"%@",_moneyText);
 
                [tb reloadData];
                [tb.mj_header endRefreshing];

                //
            }
        } failure:^(NSError *error) {
            NSLog(@"钱包错误:%@",error.localizedDescription);
            [tb.mj_header endRefreshing];

        }];
    
}





@end
