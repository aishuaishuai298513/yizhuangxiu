//
//  PersonalGuZhuController.m
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalGuZhuController.h"
#import "PersonaldetailsCell.h"
#import "Function.h"
#import "TiJiaoTableViewCell.h"

#define CELL_ID @"Personal_cell_ID"
@interface PersonalGuZhuController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource,
UITextFieldDelegate
>
{
    NSArray *_titleArr;
    NSMutableArray *_contentArr;
    ADAccount *_account;
    
    UIView *_pView;
    UIPickerView *_pickerView;
    
    NSArray *_pickerContentArr;
    
    //上传的字典
    NSMutableDictionary *_params;
    //要保存的字典
    NSMutableDictionary *_modifyDict;
}
@end

@implementation PersonalGuZhuController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initalData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initalData{
    
    _account = [ADAccountTool account];
    _params = [NSMutableDictionary dictionary];
    _modifyDict = [NSMutableDictionary dictionary];
    _titleArr = @[@"*姓名",@"*性别",@"*联系电话",@"*户籍",@"从事行业"];
    _contentArr = [NSMutableArray array];
    _pickerContentArr = @[@"男",@"女"];

    [self setData];
}
//设置初始化数据
-(void)setData{
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    
    [NetWork postNoParm:YZX_gerenziliao_gz params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            NSMutableDictionary *dicDate = [NSMutableDictionary dictionary];
            dicDate = [responseObj objectForKey:@"data"];
            NSLog(@"%@",dicDate);
            [_contentArr addObject:[dicDate objectForKey:@"name"]];
            [_contentArr addObject:[dicDate objectForKey:@"sex"]];
            [_contentArr addObject:[dicDate objectForKey:@"mobile"]];
            [_contentArr addObject:[dicDate objectForKey:@"huji"]];
            [_contentArr addObject:[dicDate objectForKey:@"hangye"]];
            [self.tv reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];

}
-(void)createUI{
    
    //[self customPickerView];
    [self customheaderView];
    //
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.tv setRowHeight:60];
    UIView *footerView = [UIView new];
    [self.tv setTableFooterView:footerView];
    self.tv.scrollEnabled = NO;
    //去掉线
    self.tv.separatorStyle =UITableViewCellSeparatorStyleNone;
}
#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArr.count+1;
}

//  textfield 的tag值 从380 - 383
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonaldetailsCell *cell = [PersonaldetailsCell loadPersonaldetailsCell];
    
    TiJiaoTableViewCell *cellBtn = [[[NSBundle mainBundle]loadNibNamed:@"TiJiaoTableViewCell" owner:nil options:nil]lastObject];
    

    if (indexPath.row <5) {
        
        cell.nameLabel.text = _titleArr[indexPath.row];
        
        //设置文字颜色
        if ([[cell.nameLabel.text substringToIndex:1] isEqualToString:@"*"]) {
            //设置字颜色
            [self setTextColor:cell.nameLabel];
        }
        
        if (_contentArr.count >0) {
            //性别转换
            if (indexPath.row == 1) {
                cell.textfield.text = [self returnSexType:_contentArr[indexPath.row]];
            }else
            {
                cell.textfield.text =_contentArr[indexPath.row];
            }
        }
        
    }
    
    
    if (indexPath.row == 0) {
        
        if ([cell.textfield.text isEqualToString:@""]) {
            cell.textfield.placeholder = @"请输入有效的姓名";
        }
        cell.textfield.userInteractionEnabled = YES;
        cell.textVScrool.userInteractionEnabled = YES;
    }
    if (indexPath.row == 1) {
        
        cell.textfield.clearButtonMode = UITextFieldViewModeNever;
        cell.textfield.userInteractionEnabled = NO;
        cell.textVScrool.userInteractionEnabled = NO;
        cell.textfield.enabled = NO;
        if ([cell.textfield.text isEqualToString:@""]) {
            cell.textfield.placeholder = @"点击选择性别";
        }
    }
    if (indexPath.row == 2) {
        cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
        cell.textfield.userInteractionEnabled = NO;
    }
    if (indexPath.row == 3) {
        
        if ([cell.textfield.text isEqualToString:@""]) {
            cell.textfield.placeholder = @"请输入户籍";
        }
        
        cell.textfield.userInteractionEnabled = YES;
        cell.textVScrool.userInteractionEnabled = YES;
    }
    if (indexPath.row == 4) {
        
        if ([cell.textfield.text isEqualToString:@""]) {
            cell.textfield.placeholder = @"请输入从事行业";
        }
        cell.textfield.userInteractionEnabled = YES;
        cell.textVScrool.userInteractionEnabled = YES;
    }
    
    if(indexPath.row == 5)
    {
        
        
        //[cell.finashBtn addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
        
        [cellBtn.tiJiaobtnClicked addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
        //cellBtn.contentView.backgroundColor = [UIColor redColor];
        
        return cellBtn;
    }
    
    cell.textfield.tag = 380 + indexPath.row;
    cell.textfield.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.view endEditing:YES];
    
    if (indexPath.row == 1) {
        
        NSLog(@"性别选择");
        [self customPickerView];
        
        UITextField *textFeild = (UITextField *)[self.tv viewWithTag:381];
        textFeild.text = @"男";

        

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 100;
    }
    return 50;
}

#pragma mark 设置label字体颜色
-(void)setTextColor:(UILabel *)label
{
    [Function fuwenbenLabel:label FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:[UIColor redColor]];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _pView.hidden = YES;
    textField.keyboardType = UIKeyboardTypeDefault;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    UIView *v = [textField superview];
    PersonaldetailsCell *cell = (PersonaldetailsCell *)[v superview];
    NSIndexPath *indexPath = [self.tv indexPathForCell:cell];
   // _contentArr = @[_account.em_name,[self returnSexType:_account.em_sex],_account.tel,_account.em_address];

    switch (indexPath.row) {
        case 0:{
            [_params setObject:textField.text forKey:@"name"];
            [_modifyDict setObject:textField.text forKey:@"em_name"];
        }
            break;
        case 1:{
            [_params setObject:textField.text forKey:@"sex"];

        }
            break;
        case 2:{
//            if ([Function isMobileNumber:textField.text]) {
                //[_params setObject:textField.text forKey:@"tel"];
                [_modifyDict setObject:textField.text forKey:@"tel"];
//            }
        }
            break;
        case 3:{
            [_params setObject:textField.text forKey:@"adr"];
            [_modifyDict setObject:textField.text forKey:@"em_address"];
            
        }
            break;
          
        default:
            break;
    }
    return YES;
}



#pragma mark 判断性别
-(NSString *)getSexType:(NSString *)str{
    if ([str isEqualToString:@"男"]) {
        return @"82";
    }else{
        return @"81";
    }
}

-(NSString *)returnSexType:(NSString *)str{
    if ([str isEqualToString:@"82"]) {
        return @"男";
    }else{
        return @"女";
    }
}


#pragma mark 自定义 pickerView
-(UIView *)customPickerView{
    
    _pView = [[UIView alloc]initWithFrame:CGRectMake(0, Ga-240, kU, 240)];
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kU, 200)];
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(10, 0, 60, 30);
//    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [leftBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(cancelChoosePicker) forControlEvents:UIControlEventTouchUpInside];
//    [_pView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kU - 70, 0, 60, 30);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ensureChoosePicker) forControlEvents:UIControlEventTouchUpInside];
    [_pView addSubview:rightBtn];
    
    _pView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource =self;
    [_pView addSubview:_pickerView];
    [self.view addSubview:_pView];
    //_pView.hidden = YES;
    
    return _pView;
}
#pragma mark 自定义 headView
-(void)customheaderView
{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    self.tv.tableHeaderView = headV;
}
//
//-(void)cancelChoosePicker{
//    [UIView animateWithDuration:2 animations:^{
//        _pView.hidden = YES;
//        [self.view layoutIfNeeded];
//        
//    }];
//    
//    NSLog(@"取消");
//}
-(void)ensureChoosePicker{
    
    [_pView removeFromSuperview];
    
//    [UIView animateWithDuration:1 animations:^{
//        _pView.hidden = YES;
//    }];
}

#pragma mark PickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerContentArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _pickerContentArr[row];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSInteger selectIndex = [pickerView selectedRowInComponent:0];
    UITextField *textFeild = (UITextField *)[self.tv viewWithTag:381];
    textFeild.text = _pickerContentArr [selectIndex];
//    [_modifyDict setObject:textFeild.text forKey:@"em_sex"];
    NSLog(@"select %@", _pickerContentArr [selectIndex]);
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        //        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark 修改个人资料

-(void)clickFinish{
    
    [self.view endEditing:YES];
    
    //姓名
    UITextField *nameTF = [self.view viewWithTag:380];
    //性别
    UITextField *sexTF = [self.view viewWithTag:381];
    //电话
    UITextField *telTF = [self.view viewWithTag:382];
    //户籍
    UITextField *addressTF = [self.view viewWithTag:383];
    //从事行业
    UITextField *hangyeTF = [self.view viewWithTag:384];
    
    if ([telTF.text isEqualToString:@""] || [sexTF.text isEqualToString:@""] || [nameTF.text isEqualToString:@""] || [addressTF.text isEqualToString:@""]) {
        
        [ITTPromptView showMessage:@"信息请填写完整"];
        
    } else {
        
        ADAccount *acount = [ADAccountTool account];
        
        [_params setObject:acount.userid forKey:@"userid"];
        [_params setObject:acount.token forKey:@"token"];
        [_params setObject:nameTF.text forKey:@"name"];
        [_params setObject:[self getSexType:sexTF.text] forKey:@"sex"];
        [_params setObject:addressTF.text forKey:@"huji"];
        [_params setObject:hangyeTF.text forKey:@"hangye"];
        
        [self postData];
    }
    
}


#pragma mark 上传数据
-(void)postData{

    [NetWork postNoParm:YZX_gerenzhiliao_gz_baocun params:_params success:^(id responseObj) {
        
        NSLog(@"个人信息:%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
         [ITTPromptView showMessage:@"修改失败"];
    }];
}

-(void)resignTheFirstResponser{
    UITapGestureRecognizer *tapFirst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTheFirst:)];
    [self.view addGestureRecognizer:tapFirst];
}
-(void)resignTheFirst:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
