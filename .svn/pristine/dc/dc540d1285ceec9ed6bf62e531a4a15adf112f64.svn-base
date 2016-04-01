//
//  PersonaldetailsController.m
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PersonaldetailsController.h"
#import "PersonaldetailsCell.h"
#import "ADAccount.h"


@interface PersonaldetailsController ()
<
UITextFieldDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate
>
{
    NSString * lx;
    
    //更改后数据
    NSMutableDictionary *_modifyDict;
    NSMutableArray *_dataArr;
    //
    NSDictionary *_userInfoDict;
    UIScrollView *_sv;
    UIImageView *_svImgV;
    //图片
    NSData *_imageData;
    UIImagePickerController *_picker;
    NSMutableArray *_picArr;
    
    //pickerView
    UIPickerView *_pickerView;
    
    //工种
    NSArray *_gzTypeArr;
}
@end

@implementation PersonaldetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initalData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addDataToDic];
    
}
//初始化数据
-(void)initalData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _modifyDict = [[NSMutableDictionary alloc]init];
    //    [_modifyDict removeAllObjects];
    _dataArr = [NSMutableArray array];
    _userInfoDict = [[NSDictionary alloc]init];
    _userInfoDict = [[user objectForKey:@"enter_user_info"]objectForKey:@"data"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinish)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *footView = [UIView new];
    self.tableView.tableFooterView = footView;
    
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    lx=[defaults objectForKey:L];
    _picArr = [NSMutableArray array];
    _sv = [[UIScrollView alloc]init];
    _svImgV = [[UIImageView alloc]init];
    
    //
    
    _gzTypeArr = @[@"泥工",@"油工",@"水工",@"电工",@"木工",@"小工"];
}

-(void)customPickerView{
    
    UIView *toolView = [[UIView  alloc]init];
    toolView.frame = CGRectMake(0, Ga - 240, kU, 240);
    toolView.backgroundColor = [UIColor grayColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 80, 30);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerChooseCancel) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kU - 90, 0, 80, 30);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerChooseEnsure) forControlEvents:UIControlEventTouchUpInside];
    //    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    //    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [toolView addSubview:rightBtn];
    [toolView addSubview:leftBtn];
    //    NSArray *itemsArr = @[leftItem1,rightItem1];
    //    tool.items = itemsArr;
    [toolView addSubview:_pickerView];

    
    
    
}
-(void)pickerChooseCancel{
    
    _pickerView.hidden = YES;
}
-(void)pickerChooseEnsure{
    
    _pickerView.hidden = YES;
    NSInteger selectIndex = [_pickerView selectedRowInComponent:0];
    NSLog(@"选择%@",_gzTypeArr[selectIndex]);
}
//
-(void)addDataToDic{
    [_modifyDict removeAllObjects];

    if ([lx isEqualToString:@"1"]) {
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"live_city"] forKey:@"live_city"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"education"] forKey:@"education"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"address"] forKey:@"address"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"education_image"] forKey:@"education_image"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"nickname"] forKey:@"nickname"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"job_year"] forKey:@"job_year"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"tel"] forKey:@"tel"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"user_desc"] forKey:@"user_desc"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"gztypeid"] forKey:@"type"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"sex"] forKey:@"sex"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"id_card"] forKey:@"id_card"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"set_rule"] forKey:@"set_rule"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"username"] forKey:@"username"];
        
        [_modifyDict setObject:[_userInfoDict objectForKey:@"record"] forKey:@"record"];
        
        [_modifyDict setObject:[_userInfoDict objectForKey:@"adminid"] forKey:@"adminid"];
        
        [_modifyDict setObject:[_userInfoDict objectForKey:@"userid"] forKey:@"user_id"];
    }else {
        
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"em_nickname"] forKey:@"username"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"em_sex"] forKey:@"sex"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"address"] forKey:@"address"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"tel"] forKey:@"tel"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"userid"] forKey:@"user_id"];
        //
        [_modifyDict setObject:[_userInfoDict objectForKey:@"address"] forKey:@"address"];
        
    }

    

}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([lx isEqualToString:@"1"]) {
        return 10;
    } else {
        return 4;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reusID = @"personCell";
    PersonaldetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reusID];
    if (!cell) {
        cell = [PersonaldetailsCell loadPersonaldetailsCell];
    }
    NSArray * arr = [NSArray array];
    NSArray * arr1 = [NSArray array];
    //帐号信息
    ADAccount *account = [ADAccount accountWithDict:_userInfoDict];
     if ([lx isEqualToString:@"1"]) {
        //工人
        arr=@[@"姓名",@"性别",@"工程种类",@"户籍",@"现居住地址",@"工龄",@"学历",@"身份证号码",@"资质证书",@"自我介绍"];
        arr1 = @[account.username,account.sex,[self jugeGongZhongType:account.gztypeid],account.live_city,account.address,account.job_year,account.education,account.id_card,@"",account.user_desc];
         if (indexPath.row == 2) {
//             cell.textfield.inputView = _pickerView;
         }
//
        if (indexPath.row == 8) {
            cell.textfield.enabled = NO;
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kU - 88, 10, 80, 80)];
            imgV.image = [UIImage imageNamed:@"tianjia"];
            [cell.contentView addSubview:imgV];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
            imgV.userInteractionEnabled = YES;
            [imgV addGestureRecognizer:tap];
             _sv.frame = CGRectMake(90, 0, kU - 188, 100);
            [cell.contentView addSubview:_sv];
            //图片
            NSLog(@"ttuuuut %ld",_picArr.count);
            for (int i = 0; i<_picArr.count; i++) {
                UIImageView *svImgV = [[UIImageView alloc]initWithFrame:CGRectMake((90)*i, 10, 80, 80)];
                svImgV.image = [UIImage imageWithData:[_picArr objectAtIndex:i]];
                [_sv addSubview:svImgV];
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                btn.frame = CGRectMake((90)*(i+1)-24, 4, 20, 20);
//                [btn setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
//                [_sv addSubview:btn];
//                [btn addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
//                btn.tag = 360+i;
            }
            _sv.contentSize = CGSizeMake(90*_picArr.count, 80);
            [_sv setShowsVerticalScrollIndicator:NO];
            [_sv setShowsHorizontalScrollIndicator:NO];
        }

    }else
    {
        //雇主
        arr=@[@"姓名",@"性别",@"联系电话",@"联系地址"];
        arr1 = @[account.em_name,account.em_sex,account.tel,account.address];
    }
    cell.textfield.delegate = self;
    cell.nameLabel.text = arr[indexPath.row];
    cell.textfield.text =arr1[indexPath.row];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 8) {
        return 100;
    } else {
        return 60;
    }
    
}
#pragma mark PickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _gzTypeArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _gzTypeArr[row];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *str =[_gzTypeArr objectAtIndex:[pickerView selectedRowInComponent:component]];
    NSLog(@"%@",str);
}
#pragma mark 工种判断
-(NSString *)jugeGongZhongType:(NSString *)str{
//    _gzTypeArr = @[@"泥工",@"油工",@"水工",@"电工",@"木工",@"小工"];
//    NSString *typeStr;
    NSLog(@"111 %@",str);
    if ([str isEqualToString:@"1"]) {
        return @"泥工";
    }else if ([str isEqualToString:@"2"]){
        return @"油工";
    }else if ([str isEqualToString:@"3"]){
        return @"水工";
    }else if ([str isEqualToString:@"4"]){
        return @"电工";
    }else if ([str isEqualToString:@"5"]){
        return @"木工";
    }else{
        return @"小工";
    }
}




#pragma mark textFeild 输入文字
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    UIView *v = [textField superview];
    PersonaldetailsCell *cell = (PersonaldetailsCell *)[v superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 0:{
            NSLog(@"姓名修改后: %@",textField.text);
            if ([lx isEqualToString:@"1"]) {
                [_modifyDict setObject:textField.text forKey:@"username"];
            }else{
                [_modifyDict setObject:textField.text forKey:@"username"];
            }
        }
            break;
        case 1:{
            if ([lx isEqualToString:@"1"]) {
                [_modifyDict setObject:textField.text forKey:@"sex"];
                
            }else {
                [_modifyDict setObject:textField.text forKey:@"sex"];
                
            }
            NSLog(@"性别修改后: %@",textField.text);
        }
            break;
        case 2:{
            if ([lx isEqualToString:@"1"]) {
                NSLog(@"工程种类 修改后: %@",textField.text);
                [_modifyDict setObject:textField.text forKey:@"type"];
            } else {
                [_modifyDict setObject:textField.text forKey:@"tel"];
                NSLog(@"电话修改后: %@",textField.text);
            }
        }
            break;
        case 3:{
            if ([lx isEqualToString:@"1"]) {
                NSLog(@"户籍 修改后: %@",textField.text);
                [_modifyDict setObject:textField.text forKey:@"live_city"];
            } else {
                NSLog(@"雇主地址修改后: %@",textField.text);
                [_modifyDict setObject:textField.text forKey:@"address"];
            }
            //            [_dataDict setObject:textField.text forKey:@"address"];
        }
            break;
        case 4:{
            NSLog(@"地址修改后: %@",textField.text);
            [_modifyDict setObject:textField.text forKey:@"address"];
        }
            break;
        case 5:{
            NSLog(@"工龄修改后: %@",textField.text);
            [_modifyDict setObject:textField.text forKey:@"job_year"];
        }
            break;
        case 6:{
            NSLog(@"学历修改后: %@",textField.text);
            [_modifyDict setObject:textField.text forKey:@"education"];
        }
            break;
        case 7:{
            NSLog(@"身份证修改后: %@",textField.text);
            [_modifyDict setObject:textField.text forKey:@"id_card"];
        }
            break;
        case 8:{
            NSLog(@"资质证书修改后: %@",textField.text);
            //上传图片
//            [_modifyDict setObject:textField.text forKey:@"education_image"];
            
        }
            break;
        case 9:{
            NSLog(@"自我介绍修改后: %@",textField.text);
            [_modifyDict setObject:textField.text forKey:@"user_desc"];
        }
            break;
        default:
            break;
    }
    //    NSLog(@"xxxxxx : %@",_dataDict);
    
    NSLog(@"%@----%@",indexPath,textField.text);
    return YES;
}

//完成
- (void)clickFinish{
    NSLog(@"修改后信息: %@",_modifyDict);
    [self postData];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)postData{
    //工人
    if ([lx isEqualToString:@"1"]) {
        NSString *url = @"http://zhaiyi.bjqttd.com/api/personal/save_user";
        NSLog(@"工人待上传信息 %@",_modifyDict);
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSMutableArray *keyArr = [[NSMutableArray alloc]initWithCapacity:_picArr.count];
        NSLog(@"上传图片数量: %ld",_picArr.count);
        for (int i = 0; i <_picArr.count; i++) {
            [array addObject:[_picArr objectAtIndex:i]];
            NSString *douStr = @",";
            NSData *dataStr =[douStr dataUsingEncoding:NSUTF8StringEncoding];
            [array addObject:dataStr];
            [keyArr addObject:@"education_image"];
        }
        //        education_image
        [AFNetFirst typearrPicturePOST:url parameters:_modifyDict withPicureData:_picArr withKeyArray:keyArr finish:^(NSData *data, NSError *error) {
             NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"工人修改信息%@",dict);
            NSLog(@"工人错误信息%@",error.localizedDescription);
        }];
      }
    
    //雇主
    if ([lx isEqualToString:@"0"]) {
        NSString *url = @"http://zhaiyi.bjqttd.com/api/personal/edit_employee";
        NSLog(@"待上传信息 %@",_modifyDict);
        [NetWork postNoParm:url params:_modifyDict success:^(id responseObj) {
            NSLog(@"雇主上传成功信息:%@",responseObj);
        } failure:^(NSError *error) {
            NSLog(@"雇主错误信息:%@",error.localizedDescription);
        }];
    }
}

//删除证书
-(void)deletePicture:(UIButton *)sender{
    NSInteger indexBtn = sender.tag - 360;
    [_picArr removeObjectAtIndex:indexBtn];
    
    [self.tableView reloadData];
    NSLog(@"delete");
    
}


//添加证书
-(void)addPicture:(UITapGestureRecognizer *)sender{
    
    NSLog(@"1111");
    UIActionSheet *myAction = [[UIActionSheet alloc]initWithTitle:@"上传证书" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [myAction showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                _picker = [[UIImagePickerController alloc]init];
                _picker.delegate = self;
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _picker.allowsEditing = YES;
                [self presentViewController:_picker animated:YES completion:^{
                    
                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
        case 1:{
            //相册
            _picker = [[UIImagePickerController alloc]init];
            _picker.delegate = self;
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_picker animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma Delegate method UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
        //        _userImage = image;
        //保存图片
//        [self saveImage:image];
        [_picArr addObject:_imageData];
//        [self changeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
            NSArray *indexPathArr = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"来自相册");
        }];
    } else if (_picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
        //        _userImage = image;
        [_picArr addObject:_imageData];
        //保存图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        [self saveImage:image];
//        [self changeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
            NSArray *indexPathArr = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"来自相机");
        }];
    }
}


//判断工种
//-(NSString *)jugeGZtype{
//    
//    
//    
//}

//保存图片
-(void)saveImage:(UIImage *)image{
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docunmentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [docunmentsDirectory stringByAppendingPathComponent:@"zhengshu.jpg"];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if (success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    //写入
    [UIImageJPEGRepresentation(image, 0.3f) writeToFile:imageFilePath atomically:YES];
    }
}



@end
