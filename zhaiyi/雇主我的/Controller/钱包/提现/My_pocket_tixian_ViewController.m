//
//  My_pocket_tixian_ViewController.m
//  zhaiyi
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_tixian_ViewController.h"
 
@interface My_pocket_tixian_ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate
>
{
    UITableView * tb;
    UIButton * yhk;
    ADAccount *_account;
    NSArray *_bankArr;
    UIButton *_bankBtn;
    
    UIPickerView *_pickerView;
    UITextField *textFeild;
    
    NSMutableDictionary *params;
}
@end

#define NUMBERS @"0123456789.\n"
@implementation My_pocket_tixian_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MakeUI];
    [self initalData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getBankList];
}
-(void)initalData{
    
    self.title=@"提现";
    params = [NSMutableDictionary dictionary];
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, Ga/2, kU, Ga/2)];
    // 显示选中框
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.view addSubview:_pickerView];
    _pickerView.hidden = YES;
    [self resignTheFirstResponser];
}

-(void)MakeUI
{
    _account = [ADAccountTool account];
    
    self.view.backgroundColor=[UIColor whiteColor];
    tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kU , Ga)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.bounces=NO;
    //tb.backgroundColor=[UIColor myColorWithString:@"f5f5f5"];
    [self.view addSubview:tb];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _pickerView.hidden = YES;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
        UITableViewCell *cell1;
        if (!cell1) {
            cell1=[[UITableViewCell alloc]init];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell1.backgroundColor=[UIColor myColorWithString:@"f5f5f5"];
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 30)];
        title.text=@"银行卡";
        title.font=[UIFont systemFontOfSize:15];
        [cell1.contentView addSubview:title];
        
        _bankBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 7, kU-200, 30)];
        [_bankBtn setTitle:@"选择银行卡" forState:0];
        [_bankBtn setTitleColor:[UIColor blueColor] forState:0];
        _bankBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cell1.contentView addSubview:_bankBtn];
        [_bankBtn addTarget:self  action:@selector(selectedBank:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line=[[UIView alloc]initWithFrame:CGRectMake(0, 49, kU, 1)];
        line.backgroundColor=[UIColor myColorWithString:@"f0f0f0"];
        [cell1.contentView addSubview:line];
        
        return cell1;
    }else if(indexPath.row==1)
    {
        UITableViewCell *cell2;
        if (!cell2) {
            cell2=[[UITableViewCell alloc]init];
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell2.backgroundColor=[UIColor myColorWithString:@"f5f5f5"];
        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 30)];
        title.text=@"金额(元)";
        title.font=[UIFont systemFontOfSize:15];
        [cell2.contentView addSubview:title];
        
        textFeild=[[UITextField alloc]initWithFrame:CGRectMake(100, 7, kU-110, 30)];
        textFeild.delegate = self;
        textFeild.keyboardType = UIKeyboardTypeNumberPad;
        if ([_account.type isEqualToString:@"78"]) {
          textFeild.placeholder=[NSString stringWithFormat:@"当前余额%@",_account.money];
        } else{
        textFeild.placeholder=[NSString stringWithFormat:@"当前余额%@",_account.recharge_money];
        }
        textFeild.backgroundColor=[UIColor clearColor];
        [cell2.contentView addSubview:textFeild];

        return cell2;
    }else
    {
        UITableViewCell *cell3;
        if (!cell3) {
            cell3=[[UITableViewCell alloc]init];
            cell3.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(kU/2-61, 20, 122, 40)];
        [btn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:0];
        [btn setTitle:@"提现" forState:0];
        [btn addTarget:self action:@selector(getMoneyFrom) forControlEvents:UIControlEventTouchUpInside];
        [cell3.contentView addSubview:btn];
        
        
        return cell3;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3) {
        return 100;
    }else
    return 50;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _pickerView.hidden = YES;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制输入的内容
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}
//获取银行列表
-(void)getBankList{
    
    [params setObject:_account.userid forKey:@"user_id"];
    [params setObject:_account.type forKey:@"type"];
    [NetWork postNoParm:POST_BANK_LIST params:params success:^(id responseObj) {
        NSLog(@"银行列表 %@",responseObj);
        if ([[responseObj objectForKey:@"message"]isEqualToString:@"您还没有添加银行卡"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有添加银行卡,请先添加银行卡" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"去添加银行卡", nil];
            [alert show];
        }
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            _bankArr = [responseObj objectForKey:@"data"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 没有银行卡
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            NSLog(@"tiaozhuan");
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"employersInMy" bundle:nil];
            UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"card"];
            [self.navigationController pushViewController:test2obj animated:YES];
        }
            break;
        default:
            break;
    }
    
}


-(void)selectedBank:(UIButton *)sender{
    
    NSLog(@"银行选择 %@",_bankArr);
    [_pickerView reloadComponent:0];
    _pickerView.hidden = NO;
    [self.view endEditing:YES];
}



#pragma mark 银行选择
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _bankArr.count;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [_bankBtn setTitle:[_bankArr[row]objectForKey:@"name"] forState:UIControlStateNormal];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
    }
    label.text = [self pickerView:_pickerView titleForRow:row forComponent:component];
    return label;
}


//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
     NSDictionary *dict = _bankArr[row];
    NSLog(@"银行1111   %@",dict);
    return [_bankArr[row]objectForKey:@"name"];
}

-(void)getMoneyFrom{
     NSLog(@"提现");
 
     //判断提现金额
    if ([_account.type isEqualToString:@"78"]) {
        
        if ([ textFeild.text intValue]>[_account.money intValue]) {
             [ITTPromptView showMessage:@"余额不足"];
        } else if ([textFeild.text isEqualToString:@""]) {
             [ITTPromptView showMessage:@"金额不能为空"];
        } else if ([_bankBtn.titleLabel.text isEqualToString:@"选择银行卡"]){
            [ITTPromptView showMessage:@"请选择银行卡"];
        } else {
            [self getCash];
        }
        
        
    } else {
        //雇主端
        if ([ textFeild.text intValue]>[_account.recharge_money intValue]) {
            [ITTPromptView showMessage:@"余额不足"];
        } else if ([textFeild.text isEqualToString:@""]) {
            [ITTPromptView showMessage:@"金额不能为空"];
        } else if ([_bankBtn.titleLabel.text isEqualToString:@"选择银行卡"]){
            [ITTPromptView showMessage:@"请选择银行卡"];
        } else {
            [self getCash];
        }
        
    }

 }

-(void)getCash{
    
    NSInteger selectedIndex = [_pickerView selectedRowInComponent:0];
    NSDictionary *dict = _bankArr[selectedIndex];
    NSLog(@"选择银行对应卡号%@", [dict objectForKey:@"num"]);
    
    [params setObject:_account.username forKey:@"username"];
    [params setObject:_account.userid forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"num"] forKey:@"bank_number"];
    [params setObject:[dict objectForKey:@"name"] forKey:@"bank_name"];
    [params setObject:_account.type forKey:@"type"];
    [params setObject:textFeild.text forKey:@"carry_cash"];
    [params setObject:@"提现" forKey:@"goods_type"];
    NSLog(@"提现待上传信息 %@",params);
    
    [NetWork postNoParm:POST_GET_CASH params:params success:^(id responseObj) {
        
        NSString *message = [responseObj objectForKey:@"message"];
        [ITTPromptView showMessage:message];

        NSLog(@"提现信息%@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"提现错误信息 %@",error.localizedDescription);
    }];
}

-(void)resignTheFirstResponser{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelFirstResponser:)];
    [self.view addGestureRecognizer:tap];
}
-(void)cancelFirstResponser:(UITapGestureRecognizer *)sender{
    
    _pickerView.hidden = YES;
    [self.view endEditing:YES];
    
    
}



@end
