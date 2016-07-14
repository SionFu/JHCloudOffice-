//
//  JHPageTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPageTableViewController.h"
#import "MBProgressHUD+KR.h"
#import "JHPageTableViewCell.h"
#import "JHPageDataManager.h"
#import "JHNetworkManager.h"
#import "JHPageDataItem.h"
#import "JHDataItemPermissions.h"

@interface JHPageTableViewController ()<JHPageDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  所有流程项目名称
 */
@property (nonatomic, strong)NSMutableArray *pageCategory;
/**
 *  所有项目的控件
 */
@property (nonatomic, strong)NSArray *typeArray;
/**
 *  所有二级选项菜单
 */
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic ,strong ) UINib *nib;
/**
 *  格式化显示时间或者日期的方式
 */
@property (nonatomic, strong) NSString *dataFormart;
/**
 *  初始化时控件的 tag 值
 */
@property (nonatomic, assign)NSInteger senderControlTag;
/**
 *  准备上传的数据数组内容为字典 value
 */
@property (nonatomic, strong)NSMutableArray *datasDicArray;
/**
 *  储存二级菜单从 server 获取的 parameters dic
 */
@property (nonatomic, strong)NSMutableDictionary *parametersDic;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@implementation JHPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [MBProgressHUD showMessage:@"正在载入..." toView:self.view];
    [JHNetworkManager sharedJHNetworkManager].getPageDelegate = self;
    //在导航栏上添加状态保存提交和取消按钮
    [self addNavigationBtn];
   
}
-(NSMutableDictionary *)parametersDic{
    if (_parametersDic == nil) {
        _parametersDic = [NSMutableDictionary dictionaryWithObject:@"nil" forKey:@"nil"];
    }return _parametersDic;
}
-(void)getPagefaild {
    
}
-(void)getPageNetError {
    
}
-(void)getPageSuccess {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.pageCategory = [NSMutableArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].pageCategory];
    self.typeArray = [NSArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].typeArray];
    self.sourceArray = [NSMutableArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].sourceArray];
     [self.tableView reloadData];

}
- (void)addNavigationBtn{
    UIView *button = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 + 20, 25, SCREENWIDTH / 2 - 25, 30)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"状态",@"保存",@"提交", nil];
    for (int i = 0; i < 3; i ++) {
        UIButton *statusbutton = [[UIButton alloc]initWithFrame:CGRectMake(i * ((SCREENWIDTH / 2 - 25 ) / 3), 0, (SCREENWIDTH / 2 - 25 ) / 3, 30)];
        [statusbutton setTitle:titleArray[i] forState:UIControlStateNormal];
        [statusbutton setBackgroundImage:[UIImage imageNamed:@"tab_unselected_pressed.9"] forState:UIControlStateHighlighted];
        [statusbutton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [statusbutton setTag:100 + i];
        [button addSubview:statusbutton];
    }
    [self.navigationController.view addSubview:button];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:@"取消"
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(doClickBackAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
//返回 (取消) 按钮
- (void)doClickBackAction:(UIBarButtonItem *)send {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonClick:(UIBarButtonItem *)send {
    switch (send.tag) {
        case 100:
            NSLog(@"点击了状态");
            [self statuesButtonClick];
            break;
        case 101:
            NSLog(@"保存");
            [self saveButtonClick];
            break;
        case 102:
            NSLog(@"提交");
            [self sendButtonClick];
            break;
        default:
            NSLog(@"无效按钮");
            break;
    }
}
- (void)statuesButtonClick {
    
}
- (void)saveButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存内容" message:@"确定保存草稿?" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)sendButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交内容" message:@"确定提交?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark 表单内容
-(NSMutableArray *)datasDicArray{
    if (_datasDicArray == nil) {
        _datasDicArray = [NSMutableArray arrayWithObjects:@"轻触选择0...",@"轻触选择1...",@"轻触选择2...",@"轻触选择3...",@"轻触选择4...",@"轻触选择5...",@"轻触选择6...",@"轻触选择7...",@"轻触选择8...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...",@"轻触选择...", nil];
    }return _datasDicArray;
}
#pragma mark 表单数据
- (NSMutableArray *)pageCategory {
    if (_pageCategory == nil) {
        _pageCategory = [NSMutableArray array];
    }return _pageCategory;
}
-(NSArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [NSArray array];
    }return _typeArray;
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

    return self.pageCategory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHPageTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
        UILabel *headTitle = [[UILabel alloc]initWithFrame:CONTROLFRME];
        headTitle.text = self.pageNage;
        headTitle.font = [UIFont systemFontOfSize:20];
        headTitle.textAlignment = NSTextAlignmentCenter;
        headTitle.center = CGPointMake(self.view.frame.size.width / 2, 10);
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 5, 20)];
        [tableView.tableHeaderView addSubview: headTitle];
    }



    JHPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //防止表格重用
    if (cell != nil) {
        while ([cell.controlTypeView.subviews lastObject] != nil) {
            [(UIView *)[cell.controlTypeView.subviews lastObject] removeFromSuperview];
        }
        
    }
    //添加列表左边标题
    cell.itemDisplayNameLabelText.text = [self.pageCategory[indexPath.row] stringByAppendingString:@":"];
    //将不同的控件添加到 cell 上
    [self addControlTocontrolTypeView:cell inRow:indexPath.row];
    
    return cell;
}
#pragma mark 流程控件
-(void)addControlTocontrolTypeView:(JHPageTableViewCell *)cell inRow:(NSInteger)index {
    //控件为文本输入框1行可以编辑
    if ([self.typeArray[index] isEqualToString:@"ShortString"]) {
//        NSLog(@"%@",self.sourceArray[index][0][@"Index"]);
        if ([self.sourceArray[index][0][@"Index"]  isEqual: @"Button"]) {
            UITextField *textField = [[UITextField alloc]initWithFrame:CONTROLFRME];
            textField.tag = 100 + index;
            textField.backgroundColor = [UIColor whiteColor];
//            textField.text = @"何建强";
            self.senderControlTag = index;
            textField.text = self.datasDicArray[self.senderControlTag];
            textField.adjustsFontSizeToFitWidth = YES;
            [cell.controlTypeView addSubview:textField];
        }else if ([self.sourceArray[index][0][@"Index"]  isEqual: @"Server"]){
            [self choseStringFromServerWith:cell inRow:index];
        }else {
            [self choseStringWith:cell inRow:index];
        }
       
        
    }
    //控件为文本输入框1行可以编辑链接文本
    if ([self.typeArray[index] isEqualToString:@"HyperLink"]) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CONTROLFRME];
        textField.tag = 100 + index;
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = @"http://";
        textField.keyboardType = UIKeyboardTypeURL;
        textField.adjustsFontSizeToFitWidth = YES;
        [cell.controlTypeView addSubview:textField];
        
    }
    //控件为文本选择 天数Double 数字键盘
    if ([self.typeArray[index] isEqualToString:@"Double"]||[self.typeArray[index] isEqualToString:@"Int"]) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CONTROLFRME];
        textField.tag = 100 + index;
        textField.backgroundColor = [UIColor whiteColor];
        textField.text = @"0";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.adjustsFontSizeToFitWidth = YES;
        [cell.controlTypeView addSubview:textField];
        
    }
    //控件为文本框不可编辑!!
    if ([self.typeArray[index] isEqualToString:@"2"]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CONTROLFRME];
        label.text = @"信息公司";
        label.tag = 100 + index;
        label.backgroundColor = [UIColor whiteColor];
        [cell.controlTypeView addSubview:label];
    }
    //控件为时间日期选择器
    if ([self.typeArray[index] isEqualToString:@"DateTime"]) {
        if ([self.sourceArray[index][0][@"Index"]  isEqual: @"Date"]) {
          self.dataFormart = @"yyyy年MM月dd日";
        }else if ([self.sourceArray[index][0][@"Index"]  isEqual: @"Time"]){
          self.dataFormart = @"HH点mm分";
        }else if ([self.sourceArray[index][0][@"Index"]  isEqual: @"DateTime"]){
            self.dataFormart = @"yyyy年MM月dd日 HH点mm分";
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(setTimeButtonCick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.controlTypeView addSubview:button];
    }
    //控件为文本视图,多行
    if ([self.typeArray[index] isEqualToString:@"String"]||[self.typeArray[index] isEqualToString:@"Html"]||[self.typeArray[index] isEqualToString:@"Comment"]) {
        UITextView *textView = [[UITextView alloc]initWithFrame:CONTROLFRME];
        textView.text = @"这是测试输入内容 测试换行显示内容";
        [cell.controlTypeView addSubview:textView];
    }
    //控件为类别选择,选择收件人
    if ([self.typeArray[index] isEqualToString:@"6"]) {
        
    }
    //控件为选择器true or fause
    if ([self.typeArray[index] isEqualToString:@"Bool"]) {
        UIButton *button = [[UIButton alloc]initWithFrame:BUTTONCONTROLFRME];

        [button setBackgroundImage:[UIImage imageNamed:@"checkBoxDefault"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkboxChecked"] forState:UIControlStateSelected];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(selectotBOOL:) forControlEvents:UIControlEventTouchUpInside];
        [cell.controlTypeView addSubview:button];
    }
    /**
     *  需要重新推出一个视图选择
     */
    //控件为选择器选择部门人
    if ([self.typeArray[index] isEqualToString:@"SingleParticipant"]) {
        [self chosePeoeleStringWith:cell inRow:index];
    }
    //控件为附件
    if ([self.typeArray[index] isEqualToString:@"Attachment"]) {
        
    }
    //控件为采购明细表
    if ([self.typeArray[index] isEqualToString:@"BizObjectArray"]) {
        
    }
    //控件为通知人选择
    if ([self.typeArray[index] isEqualToString:@"MultiParticipant"]) {
        
    }
    //控件为选择器意见
    if ([self.typeArray[index] isEqualToString:@"Comment"]) {
        
    }
}
- (void)chosePeoeleStringWith:(JHPageTableViewCell *)cell inRow:(NSInteger)index{
    UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    self.senderControlTag = index;
    button.tag = 100 + index;
    [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setpeopleSingleParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [cell.controlTypeView addSubview:button];
}
- (void)choseStringWith:(JHPageTableViewCell *)cell inRow:(NSInteger)index{
    UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    self.senderControlTag = index;
    button.tag = 100 + index;
    [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setSingleParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [cell.controlTypeView addSubview:button];
}
- (void)choseStringFromServerWith:(JHPageTableViewCell *)cell inRow:(NSInteger)index{
    UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.senderControlTag = index;
    button.tag = 100 + index;
    [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setSingleParticipantFromServer:) forControlEvents:UIControlEventTouchUpInside];
    [cell.controlTypeView addSubview:button];
}
- (void)sourceButtonClick:(UIButton *)sender {
   //未使用
}

- (void)selectotBOOL:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.datasDicArray[sender.tag - 100] = [NSNumber numberWithBool:sender.selected];
}
-(void)setpeopleSingleParticipant:(UIButton*)sender {
    [[JHNetworkManager sharedJHNetworkManager]getUsers];
    NSLog(@"已经选择人");
}
- (void)setSingleParticipant:(UIButton *)sender {
    self.senderControlTag = sender.tag - 100;
    UIPickerView *itemPicker = [[UIPickerView alloc]init];

    //    CALayer *viewLayer = itemPicker.layer;
    //    [viewLayer setFrame:CGRectMake(-10, -35, SCREENWIDTH - 5 , 300)];
    //    [viewLayer setBorderWidth:0];
#warning  自定义
    //    itemPicker.frame = CGRectMake(-10, -35, SCREENWIDTH - 5 , 300);
    itemPicker.center = CGPointMake(SCREENWIDTH / 2 - 5, 100);
//    NSLog(@"%f",itemPicker.frame.size.width);
    //WithFrame:CGRectMake(-10, -35, SCREENWIDTH - 5 , 300)];
    itemPicker.tag = sender.tag;
    itemPicker.delegate = self;
    itemPicker.showsSelectionIndicator = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert.view addSubview:itemPicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSInteger row = [itemPicker selectedRowInComponent:1];
        NSString *selectedString = self.sourceArray[self.senderControlTag][row][@"DisplayValue"];
        //只要在本地获取菜单的情况下才能获取以下值

        self.parametersDic = [NSMutableDictionary dictionaryWithDictionary:self.sourceArray[self.senderControlTag][row]];
        NSLog(@"%@",self.parametersDic);
        [itemPicker selectRow:row inComponent:1 animated:NO];
        self.datasDicArray[self.senderControlTag] = selectedString;
        //设置表格选择时的动画
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.senderControlTag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
        [sender setTitle:selectedString forState:UIControlStateNormal];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setSingleParticipantFromServer:(UIButton *)sender {
    self.senderControlTag = sender.tag - 100;
    [self.parametersDic setObject:@"ShortString" forKey:@"type"];
    [MBProgressHUD showMessage:@"正在加载..."];
    //获取上一个选项获得的 dic
    [[JHNetworkManager sharedJHNetworkManager] getPageSaverSettingWith:self.parametersDic];
    
    
}
- (void)getsetSingleParticipantFromServerSucceed {
    [MBProgressHUD hideHUD];
    self.sourceArray[self.senderControlTag] = [NSMutableArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].sourceFromServerArray];
    UIPickerView *itemPicker = [[UIPickerView alloc]init];
    itemPicker.center = CGPointMake(SCREENWIDTH / 2 - 5, 100);
    itemPicker.tag = self.senderControlTag;
    itemPicker.delegate = self;
    itemPicker.showsSelectionIndicator = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:itemPicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSInteger row = [itemPicker selectedRowInComponent:1];

        NSString *selectedString = [JHPageDataManager sharedJHPageDataManager].sourceFromServerArray[row][@"DisplayValue"];
        //每次从二级菜单中获取数据后,将是否从服务器获取数据标示转成 server 使再次点击或者更换菜单时重新从服务器获取数据
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"Server" forKey:@"Index"];
        self.sourceArray[self.senderControlTag][0] = dic;
        [itemPicker selectRow:row inComponent:1 animated:NO];
        self.datasDicArray[self.senderControlTag] = selectedString;
        //设置表格选择时的动画
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.senderControlTag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
        UIButton *sender = [[UIButton alloc]init];
        sender.tag = self.senderControlTag;
        [sender setTitle:selectedString forState:UIControlStateNormal];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark Picker Date Source Methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
       return SCREENWIDTH * 0.8 / 3;
    }else {
        return SCREENWIDTH * 2 / 3;
    }
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 1;
    }else {
    NSArray *array = [NSArray arrayWithArray:self.sourceArray[self.senderControlTag]];
    return array.count;
    }
}
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 0) {
//        return self.pageCategory[self.senderControlTag];
//    }else {
//        NSLog(@"%ld",row);
//        return self.sourceArray[self.senderControlTag][row][@"DisplayValue"];
//       
//    }
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{   if (component == 0) {
    UILabel *label = [[UILabel alloc] init];
    label.text = self.pageCategory[self.senderControlTag];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = 10;
    return label;
}else {
    UILabel *label = [[UILabel alloc] init];
    label.text = self.sourceArray[self.senderControlTag][row][@"DisplayValue"];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.minimumScaleFactor = 10;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
    }
}
- (void)setTimeButtonCick:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.center = CGPointMake(SCREENWIDTH / 2 - 5, 100);
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    if ([self.sourceArray[sender.tag - 100][0][@"Index"]  isEqual: @"Date"]) {
        self.dataFormart = @"yyyy年MM月dd日";
        datePicker.datePickerMode = UIDatePickerModeDate;
    }else if ([self.sourceArray[sender.tag - 100][0][@"Index"]  isEqual: @"Time"]){
        self.dataFormart = @"HH点mm分";
        datePicker.datePickerMode = UIDatePickerModeTime;
    }else if ([self.sourceArray[sender.tag - 100][0][@"Index"]  isEqual: @"DateTime"]){
        self.dataFormart = @"yyyy年MM月dd日 HH点mm分";
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    [format setDateFormat:self.dataFormart];
    NSDate *date = [format dateFromString:sender.titleLabel.text];
//    [datePicker setDate:date animated:YES];
    NSLog(@"%f",date.timeIntervalSinceNow);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:self.dataFormart];
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        NSLog(@"%@",dateString);
        sender.titleLabel.text = dateString;
        self.datasDicArray[sender.tag - 100] = dateString;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag - 100 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
/*
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
 
}

*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
