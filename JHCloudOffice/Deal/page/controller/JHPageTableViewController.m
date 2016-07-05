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

@interface JHPageTableViewController ()<JHPageDelegate>
/**
 *  所有流程项目名称
 */
@property (nonatomic, strong)NSMutableArray *pageCategory;
/**
 *  所有项目的控件
 */
@property (nonatomic, strong)NSArray *typeArray;
@property (nonatomic ,strong ) UINib *nib;
/**
 *  格式化显示时间或者日期的方式
 */
@property (nonatomic, strong) NSString *dataFormart;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@implementation JHPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [MBProgressHUD showMessage:@"正在载入..." toView:self.view];
    [JHNetworkManager sharedJHNetworkManager].getPageDelegate = self;
    //在导航栏上添加状态保存提交和取消按钮
    [self addNavigationBtn];
   
}
-(void)getPageSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"成功接收数据");
    for (JHDataItemPermissions *per in [JHPageDataManager sharedJHPageDataManager].pageVisibleItemArray) {
        [JHPageDataManager sharedJHPageDataManager].Used = false;
        NSLog(@"%@",per.ItemName);
    }
    NSMutableArray *muarray = [NSMutableArray array];
    NSMutableArray *itemTypeMuarray = [NSMutableArray array];
    for (JHPageDataItem  *dataItem in [JHPageDataManager sharedJHPageDataManager].pageDataItemsArray) {
        NSLog(@"%@",dataItem.ItemDisplayName);
        NSLog(@"控件类型:%@",dataItem.ItemType[@"Value"]);
        [ JHPageDataManager sharedJHPageDataManager].pageDataUsed = false;
        [muarray addObject:dataItem.ItemDisplayName];
        [itemTypeMuarray addObject:dataItem.ItemType[@"Value"]];
    }
    self.pageCategory = [NSMutableArray arrayWithArray:muarray];
    self.typeArray = [NSArray arrayWithArray:itemTypeMuarray];
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
#pragma mark 表单数据
- (NSMutableArray *)pageCategory {
    if (_pageCategory == nil) {
//        _pageCategory = [NSArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].pageVisibleItemArray];
//         _pageCategory = [NSMutableArray arrayWithObjects:@"日期:",@"姓名:",@"请假开始时间:",@"详细信息:",@"详细信息:",@"详细信息:",@"详细信息:",@"详细信息:",@"详细信息:",@"日期:",@"详细信息:", nil];
        _pageCategory = [NSMutableArray array];
    }return _pageCategory;
}
-(NSArray *)typeArray{
    if (_typeArray == nil) {
//        _typeArray = [NSArray arrayWithObjects:@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"3",@"1",@"2",@"2",@"1",@"1",@"1",@"3",@"1",@"3",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5", nil];
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
        if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    else //防止表格重用
    {
        while ([cell.controlTypeView.subviews lastObject] != nil) {
            [(UIView *)[cell.controlTypeView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.itemDisplayNameLabelText.text = [self.pageCategory[indexPath.row] stringByAppendingString:@":"];
    //将不同的控件添加到 cell 上
    [self addControlTocontrolTypeView:cell inRow:indexPath.row];
    
    return cell;
}

-(void)addControlTocontrolTypeView:(JHPageTableViewCell *)cell inRow:(NSInteger)index {
    //控件为文本输入框1行可以编辑 和链接文本!!
    if ([self.typeArray[index] isEqualToString:@"ShortString"]||[self.typeArray[index] isEqualToString:@"HyperLink"]||[self.typeArray[index] isEqualToString:@"Html"]) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CONTROLFRME];
        textField.tag = 100 + index;
        textField.backgroundColor = [UIColor whiteColor];
        textField.text = @"何建强";
        textField.adjustsFontSizeToFitWidth = YES;
        [cell.controlTypeView addSubview:textField];
        
    }
    //控件为文本选择天数Double 数字键盘
    if ([self.typeArray[index] isEqualToString:@"Double"]) {
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
    if ([self.typeArray[index] isEqualToString:@"DateTime"]||[self.typeArray[index] isEqualToString:@"DateTime"]) {
        if ([self.typeArray[index] isEqualToString:@"DateTime"]) {
          self.dataFormart = @"yyyy年MM月dd日";
        }else if ([self.typeArray[index] isEqualToString:@"DateTime"]){
          self.dataFormart = @"yyyy年MM月dd日 HH点mm分";
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
        button.backgroundColor = [UIColor whiteColor];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:self.dataFormart];
        NSString *dataStr = [dateFormat stringFromDate:[NSDate date]];
        [button setTitle:dataStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(setTimeButtonCick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.controlTypeView addSubview:button];
    }
    //控件为文本视图,多行
    if ([self.typeArray[index] isEqualToString:@"String"]) {
        UITextView *textView = [[UITextView alloc]initWithFrame:CONTROLFRME];
//        cell.textLabel.text = @"这是测试输入内容";
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
        UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"轻触选择..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(setSingleParticipant:) forControlEvents:UIControlEventTouchUpInside];
        [cell.controlTypeView addSubview:button];
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
- (void)selectotBOOL:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)setSingleParticipant:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:self.dataFormart];
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        sender.titleLabel.text = dateString;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setTimeButtonCick:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    NSLog(@"%ld",sender.titleLabel.text.length);
    if (sender.titleLabel.text.length == 11) {
        self.dataFormart = @"yyyy年MM月dd日";
    }else if (sender.titleLabel.text.length == 18){
        self.dataFormart = @"yyyy年MM月dd日 HH点mm分";
    }
    [format setDateFormat:self.dataFormart];
    
    NSDate *date = [format dateFromString:sender.titleLabel.text];
    [datePicker setDate:date animated:YES];
    NSLog(@"%@",date);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:self.dataFormart];
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        sender.titleLabel.text = dateString;
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

/*
#pragma mark - Table view delegate

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
