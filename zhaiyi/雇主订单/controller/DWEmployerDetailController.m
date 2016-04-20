//
//  DWEmployerDetailController.m
//  zhaiyi
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DWEmployerDetailController.h"
#import "DWEmployerDetailCell.h"
#import "DWEmployerImageCell.h"
#import "DWReasionViewController.h"
#import "DWevaluateListViewController.h"


@interface DWEmployerDetailController ()

//////////HeaderView相关/////////
@property (strong, nonatomic) IBOutlet UIView *dwHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *headPicImage;

@property (weak, nonatomic) IBOutlet UILabel *jiedanLabel;

////////////////////////////////
@property (strong, nonatomic) IBOutlet UIView *dwFooterView;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@property (nonatomic, strong) NSArray *imageDataSource;


// 第六行的高度
@property (nonatomic, assign) CGFloat rowhightForSeven;
- (IBAction)quitBtnAction:(UIButton *)sender;
@end

@implementation DWEmployerDetailController

-(NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}

-(NSArray *)imageDataSource
{
    if (!_imageDataSource) {
        _imageDataSource = [NSArray array];
    }
    return _imageDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 60.0; // 设置为一个接近“平均”行高的值

    
    [self.navigationItem setTitle:@"1111"];
    self.tableView.tableHeaderView = self.dwHeaderView;
    self.tableView.tableFooterView = self.dwFooterView;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //[self.tableView registerNib:[UINib nibWithNibName:@"DWEmployerDetailCell" bundle:nil] forCellReuseIdentifier:@"DWEmployerDetailCell"];
    
    self.quitBtn.layer.cornerRadius = 20;
    self.quitBtn.layer.masksToBounds = YES;
    [self configueRightBarItem];
    
    if (self.type == 1) {
        self.tableView.tableFooterView.hidden = NO;
    }
    if (self.type == 3) {
        self.tableView.tableFooterView.hidden = YES;
    }
    if (self.type == 2) {
        self.tableView.tableFooterView.hidden = NO;
    }
    
    
    [self netWorkUserinfo];
    
    
    
  //NSLog(@"%@",self.acount.userid);
}

-(void)netWorkUserinfo
{
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    
    
//    NSLog(@"%@",self.orderModel);
//    NSLog(@"%@",self.orderModel.ID);
    [parm setObject:self.orderModel.userid forKey:@"userid2"];
    
    [NetWork postNoParm:YZX_cituipage params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            self.dataSource = [responseObj objectForKey:@"data"];
            
            [self refeshHeaderView];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark  设置头像等信息
-(void)refeshHeaderView
{
    //设置头像
    [self.headPicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,[self.dataSource objectForKey:@"headpic"]]] placeholderImage:[UIImage imageNamed:@"dj.png"]];
    //设置星级
    [Function xingji:self.dwHeaderView xingji:[[self.dataSource objectForKey:@"xing"] intValue] startTag:101];
    
   // NSArray * imageArray = [self.dataSource objectForKey:@"zizhizhengshu"];
    
}

//评价列表
- (void)evaluateList{
    
    DWevaluateListViewController *vc = [[DWevaluateListViewController alloc] initWithNibName:@"DWevaluateListViewController" bundle:nil];
    vc.userid = self.orderModel.userid;
   // vc.userAcount = self.acount;
   // NSLog(@"%@",vc.userAcount.userid);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configueRightBarItem{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(evaluateList) forControlEvents:UIControlEventTouchUpInside];

    [rightBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // DWEmployerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWEmployerDetailCell" forIndexPath:indexPath];
    //DWEmployerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWEmployerDetailCell"];
    
    DWEmployerDetailCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"DWEmployerDetailCell" owner:nil options:nil]lastObject];
    
    
    if (indexPath.row == 0) {
        cell.DWEmpilyerDetailLabelLeft.text = @"姓名";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"name"];

    }else if (indexPath.row == 1){
        cell.DWEmpilyerDetailLabelLeft.text = @"性别";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"sex"];
        
    }else if(indexPath.row == 2){
        cell.DWEmpilyerDetailLabelLeft.text = @"工种";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"gzname"];

    }else if(indexPath.row == 3){
        cell.DWEmpilyerDetailLabelLeft.text = @"工龄";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"gongling"];
    
    }else if(indexPath.row == 4){
        cell.DWEmpilyerDetailLabelLeft.text = @"学历";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"xueli"];
    
    }else if(indexPath.row == 5){
        cell.DWEmpilyerDetailLabelLeft.text = @"户籍";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"huji"];
    
    }else if(indexPath.row == 6){
        cell.DWEmpilyerDetailLabelLeft.text = @"自我评价";
        cell.DWEmpilyerDetailLabelRight.text = [self.dataSource objectForKey:@"ziwojieshao"];
        return cell;
    }else if (indexPath.row == 7)
    {
        DWEmployerImageCell *cell1 = [[[NSBundle mainBundle]loadNibNamed:@"DWEmployerImageCell" owner:nil options:nil]firstObject];

        cell1.DWEmpilyerDetailLabelLeft.text = @"资质证书";
        cell1.DWEmpilyerDetailLabelRight.hidden = YES;
        //添加图片按钮
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.image = [UIImage imageNamed:@"tianjia"];
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
        imgV.userInteractionEnabled = YES;
        //[imgV addGestureRecognizer:tap];
        
        //布局九宫格
        int lieshu = 3;//列数
        //int hangshu = 3;//行数
        CGFloat colpan = 10;//间隔
        int hangNum;//行号
        int lieNum;//列号
        CGFloat ImageWith = (SCREEN_WIDTH-cell.DWEmpilyerDetailLabelLeft.width-colpan*(lieshu+1))/lieshu;
        CGFloat ImageHeigh = ImageWith;
        
        //图片

            for (int i = 0; i < 1; i++) {
                //行号
                hangNum = i/lieshu;
                //列号
                lieNum = i%lieshu;
                
                UIImageView *imgV = [[UIImageView alloc]init];
                imgV.frame = CGRectMake((cell.DWEmpilyerDetailLabelLeft.width+20)+lieNum*(ImageWith+colpan), 10+hangNum*(ImageHeigh+colpan), ImageWith, ImageHeigh);
                [cell1.contentView addSubview:imgV];
                
                
                [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,[self.dataSource objectForKey:@"zizhizhengshu"]]]];
                
                self.rowhightForSeven =imgV.frame.origin.y+imgV.frame.size.height+10;
                }
                
        return cell1;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7)
    {
        return self.rowhightForSeven;
    }
    return 60;
}

- (IBAction)quitBtnAction:(UIButton *)sender {
    
    //辞退原因
    DWReasionViewController *vc = [[DWReasionViewController alloc] initWithNibName:@"DWReasionViewController" bundle:nil];
    
   // NSLog(@"%@",self.acount.userid);
    
    //vc.UserAcount = self.acount;
    
    vc.userId = self.orderModel.userid;
    vc.orderNum = [self.dataSource objectForKey:@"ordernum"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
