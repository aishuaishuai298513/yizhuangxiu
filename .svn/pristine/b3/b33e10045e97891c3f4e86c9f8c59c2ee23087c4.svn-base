//
//  MainMessageDetailViewController.m
//  zhaiyi
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMessageDetailViewController.h"
#import "ADDetailController.h"
#import "MJExtension.h"

@interface MainMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *neirong;


@property (nonatomic, strong) NSMutableDictionary *dateS;

@end

@implementation MainMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageView.hidden = self.messageTpy;
    self.noMessage.hidden = self.noMessageTpy;
    [self.detailButton setTitle:self.btnName forState:(UIControlStateNormal)];
    
    // Do any additional setup after loading the view.
}

-(NSMutableDictionary *)dateS
{
    if (_dateS == nil) {
        _dateS = [NSMutableDictionary dictionary];
    }
    return _dateS;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self netWork];
}

-(void)netWork
{
    NSLog(@"%@",self.dataSource);
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:[self.dataSource objectForKey:@"userid"] forKey:@"news_id"];
    NSLog(@"%@",parm);
    
    [NetWork postNoParm:xiangxixiangqing params:parm success:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        self.dateS = [responseObj objectForKey:@"data"];
        [self createUI];
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

//
-(void)createUI
{
    self.time.text = [self.dateS objectForKey:@"updatetime"];
    self.neirong.text = [self.dateS objectForKey:@"news_content"];
}


- (IBAction)orderDetail:(id)sender {
    
    ADAccount *acount = [ADAccountTool account];
    NSLog(@"%@",acount.type);
    
    NSLog(@"%@",self.dataSource);
    
    if ([self.btnName isEqualToString:@"订单详情"]&& [acount.type isEqualToString:@"78"]) {
    
        ADDetailController *detail = [[ADDetailController alloc]init];
        
        __weak typeof (ADDetailController) *Detail =detail;
        __weak typeof (self)WeakSelf = self;
        
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        [parm setObject:acount.userid forKey:@"user_id"];
        [parm setObject:[self.dataSource objectForKey:@"sendxqid"] forKey:@"send_id"];
        
        [NetWork postNoParm:xiaoxixiangqing params:parm success:^(id responseObj) {
            
            NSLog(@"%@",responseObj);
            DWOrderModel *OrderModel = [DWOrderModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
            Detail.OrderModel = OrderModel;
            
           [WeakSelf.navigationController pushViewController:detail animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
        //[self.navigationController pushViewController:detail animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
