//
//  JHEditTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/18.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHEditTableViewController.h"
#import "JHBizEditTableViewCell.h"
#import "JHBizDataManager.h"
#import "JHPageDataManager.h"
#import "JHPageData.h"
#import "MBProgressHUD+KR.h"
#import "JHNetworkManager.h"
@interface JHEditTableViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong ) UINib *nib;
/**
 *  所有项目的控件
 */
@property (nonatomic, strong) NSArray *typeArray;
/**
 *  所有二级选项菜单
 */
@property (nonatomic, strong)NSMutableArray *sourceArray;
/**
 *  初始化时控件的 tag - 100 值 为数组中的下标 不需要100 即可使用
 */
@property (nonatomic, assign)NSInteger senderControlTag;
/**
 *  准备上传的数据数组内容为字典 value
 */
@property (nonatomic, strong)NSMutableArray *datasDicArray;
/**
 *  整理从服务器接收的数据 数组位数上与本本地流程相同
 */
@property (nonatomic, strong)NSMutableArray *datasFromServerArray;
/**
 *  所有项目的 itemName
 */
@property (nonatomic, strong)NSMutableArray *pageDataItemsArray;
/**
 *  暂储存上传数据
 */
@property (nonatomic, strong)JHPageData *pageData;
/**
 *  格式化显示时间或者日期的方式
 */
@property (nonatomic, strong) NSString *dataFormart;
/**
 *  储存二级菜单从 server 获取的 parameters dic
 */
@property (nonatomic, strong)NSMutableDictionary *parametersDic;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@implementation JHEditTableViewController
-(NSMutableDictionary *)parametersDic{
    if (_parametersDic == nil) {
        _parametersDic = [NSMutableDictionary dictionaryWithObject:@"nil" forKey:@"nil"];
    }return _parametersDic;
}
-(JHPageData *)pageData{
    if (_pageData == nil) {
        _pageData = [JHPageData new];
    }return _pageData;
}
-(NSArray *)datasFromServerArray{
    if (_datasFromServerArray == nil) {
        _datasFromServerArray = [NSMutableArray array];
    }return _datasFromServerArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNage = @"测试页面";
    [self addNavigationBtn];
    [self getData];
    [self makeTheDataFromServerLikeLocaPage];
    [self getServerPageData];
    
}
-(void)makeTheDataFromServerLikeLocaPage {
    for (int i = 0; i < self.pageDataItemsArray.count ; i++) {
        self.datasFromServerArray[i] = @"";
    }
    for (NSDictionary *dic in [JHPageDataManager sharedJHPageDataManager].datasFromServerArray) {
        for (int i = 0; i < self.pageDataItemsArray.count ; i++) {
            if ([dic[@"Key"] isEqualToString:self.pageDataItemsArray[i]]) {
                self.datasFromServerArray[i] =  dic[@"Value"];
            }
        }
    }
    
}
- (void)getData {
    _typeArray = [JHBizDataManager sharedJHBizDataManager].typeArray;
    self.sourceArray = [NSMutableArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].sourceArray];
    self.pageDataItemsArray = [NSMutableArray arrayWithArray:[JHPageDataManager sharedJHPageDataManager].itemNameArray];
}
//使流程从服务器获取标题
-(void)getServerPageData {
    for (int i = 0 ; i < self.datasFromServerArray.count; i ++) {
        NSLog(@"%d:%@",i + 1,self.datasFromServerArray[i]);
    }
    for (int i = 0 ; i <self.datasFromServerArray.count; i++) {
        if ([self.datasFromServerArray[i] isEqualToString:@""]) {
            [self.datasDicArray addObject:@""];
        }
        else {
            [self.datasDicArray addObject:self.datasFromServerArray[i]];
        }
    }
}
#pragma AddNavigationButton
- (void)addNavigationBtn{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 + 75, 25, SCREENWIDTH / 2 - 80, 30)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"删除",@"确定", nil];
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *statusbutton = [[UIButton alloc]initWithFrame:CGRectMake(i * ((SCREENWIDTH / 2 ) / 3), 0, (SCREENWIDTH / 2 - 40 ) / 3, 30)];
        [statusbutton setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            statusbutton.hidden =  NO;
        }
        [statusbutton setBackgroundImage:[UIImage imageNamed:@"tab_unselected_pressed.9"] forState:UIControlStateHighlighted];
        [statusbutton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [statusbutton setTag:100 + i];
        [buttonView addSubview:statusbutton];
    }
    [self.navigationController.view addSubview:buttonView];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:@"取消"
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(todoClickBackAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)rightBarButtonClick:(UIBarButtonItem *)send {
    switch (send.tag) {
        case 100:
            NSLog(@"删除");
            //persent EditView
            break;
        case 101:
            NSLog(@"确定");
            //            [self saveButtonClick];
            break;
        default:
            NSLog(@"无效按钮");
            break;
    }
}
//返回 (取消) 按钮
- (void)todoClickBackAction:(UIBarButtonItem *)send {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 表单内容
-(NSMutableArray *)datasDicArray{
    if (_datasDicArray == nil) {
        _datasDicArray = [NSMutableArray array];
    }
    return _datasDicArray;
}
#pragma 收集文本框中的数据
- (void)addDataToArray:(UITextField *)sender {
    self.pageData.key = [JHPageDataManager sharedJHPageDataManager].itemNameArray[self.senderControlTag];
    self.pageData.value = sender.text;
    self.pageData.displayValue = sender.text;
    self.pageData.type = @"ShortString";
    self.datasDicArray[sender.tag - 100] = sender.text;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"bizEditCell";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHBizEditTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
        UILabel *headTitle = [[UILabel alloc]initWithFrame:CONTROLFRME];
        headTitle.text = self.pageNage;
        headTitle.font = [UIFont systemFontOfSize:20];
        headTitle.textAlignment = NSTextAlignmentCenter;
        headTitle.center = CGPointMake(self.view.frame.size.width / 2, 10);
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 5, 20)];
        [tableView.tableHeaderView addSubview: headTitle];
    }
    JHBizEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //防止表格重用
    if (cell != nil) {
        while ([cell.controlTypeView.subviews lastObject] != nil) {
            [(UIView *)[cell.controlTypeView.subviews lastObject] removeFromSuperview];
        }
    }
    //添加列表左边标题
    cell.itemDisplayNameLabelText.text = [[JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray[indexPath.row][0] stringByAppendingString:@":"];
    //将不同的控件添加到 cell 上
    [self addControlTocontrolTypeView:cell inRow:indexPath.row];
    return cell;
}

-(void)addControlTocontrolTypeView:(JHBizEditTableViewCell *)cell inRow:(NSInteger)index {
    //控件为文本输入框1行可以编辑
    if ([self.typeArray[index] isEqualToString:@"ShortString"]) {
        if ([self.sourceArray[index][0][@"Key"]  isEqual: @"Button"]) {
            UITextField *textField = [[UITextField alloc]initWithFrame:CONTROLFRME];
            textField.tag = 100 + index;
            textField.backgroundColor = [UIColor whiteColor];
            self.senderControlTag = index;
            textField.text = self.datasDicArray[index];
            textField.adjustsFontSizeToFitWidth = YES;
            [cell.controlTypeView addSubview:textField];
            //将输入好的内容存入数组
            [textField addTarget:self action:@selector(addDataToArray:) forControlEvents:UIControlEventEditingChanged];
            //控件为 文本选择器,从服务器获取数据
        }else if ([self.sourceArray[index][0][@"Key"]  isEqual: @"Server"]){
            [self choseStringFromServerWith:cell inRow:index];
            //控件为 文本选择器, 从本地获取目录, 获取数据为 服务器的 parents
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
        self.senderControlTag = index;
        textField.text = self.datasDicArray[index];
        //将输入好的内容存入数组
        [textField addTarget:self action:@selector(addDataToArray:) forControlEvents:UIControlEventEditingChanged];
        
        [cell.controlTypeView addSubview:textField];
        
    }
    //控件为文本选择 天数Double 数字键盘
    if ([self.typeArray[index] isEqualToString:@"Double"]||[self.typeArray[index] isEqualToString:@"Int"]) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CONTROLFRME];
        textField.tag = 100 + index;
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.adjustsFontSizeToFitWidth = YES;
        [cell.controlTypeView addSubview:textField];
        self.senderControlTag = index;
        textField.text = self.datasDicArray[index];
        //将输入好的内容存入数组
        [textField addTarget:self action:@selector(addDataToArray:) forControlEvents:UIControlEventEditingChanged];
    }
    //控件为时间日期选择器
    if ([self.typeArray[index] isEqualToString:@"DateTime"]) {
        if ([self.sourceArray[index][0][@"key"] isEqual: @"Date"]) {
            self.dataFormart = @"yyyy年MM月dd日";
        }else if ([self.sourceArray[index][0][@"key"] isEqual: @"Time"]){
            self.dataFormart = @"HH点mm分";
        }else if ([self.sourceArray[index][0][@"key"] isEqual: @"DateTime"]){
            self.dataFormart = @"yyyy年MM月dd日 HH点mm分";
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
        button.backgroundColor = [UIColor whiteColor];
        if ([self.datasDicArray[index] isEqualToString:@""]) {
            self.datasDicArray[index] = @"轻触选择...";
        }
        [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.tag = 100 + index;
        [button addTarget:self action:@selector(setTimeButtonCick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.controlTypeView addSubview:button];
    }

}
- (void)choseStringWith:(JHBizEditTableViewCell *)cell inRow:(NSInteger)index{
    UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.senderControlTag = index;
    button.tag = 100 + index;
    if ([self.datasDicArray[index] isEqualToString:@""]) {
        self.datasDicArray[index] = @"轻触选择..";
    }
    [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setSingleParticipant:) forControlEvents:UIControlEventTouchUpInside];
    [cell.controlTypeView addSubview:button];
}
- (void)choseStringFromServerWith:(JHBizEditTableViewCell *)cell inRow:(NSInteger)index{
    UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.senderControlTag = index;
    button.tag = 100 + index;
    if ([self.datasDicArray[index] isEqualToString:@""]) {
        self.datasDicArray[index] = @"轻触选择...";
    }
    [button setTitle:self.datasDicArray[index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setSingleParticipantFromServer:) forControlEvents:UIControlEventTouchUpInside];
    [cell.controlTypeView addSubview:button];
}
- (void)setSingleParticipant:(UIButton *)sender
{
    self.senderControlTag = sender.tag - 100;
    UIPickerView *itemPicker = [[UIPickerView alloc]init];
    itemPicker.center = CGPointMake(SCREENWIDTH / 2 - 5, 100);
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
        NSLog(@"二级菜单:%@",self.parametersDic);
        [itemPicker selectRow:row inComponent:1 animated:NO];
        self.datasDicArray[self.senderControlTag] = selectedString;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.senderControlTag inSection:0];
        //任何情况下当前 挑个都要刷新
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath ,nil] withRowAnimation:UITableViewRowAnimationBottom];
        //设置表格选择时的动画 如果有子菜单,父菜单选择后 需要子与父一起刷新
        NSLog(@"%@",self.sourceArray);
        for (int i = 0; i < self.sourceArray.count; i ++ ) {
            NSArray *array = self.sourceArray[i];
            NSLog(@"%@",array);
            if ([array[0][@"Key"] isEqualToString:@"Server"]) {
                self.datasDicArray[i] = @"轻触选择...";
                NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:i inSection:0];
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1 , nil]withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
        [sender setTitle:selectedString forState:UIControlStateNormal];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setSingleParticipantFromServer:(UIButton *)sender {
    self.senderControlTag = sender.tag - 100;
    //添加一个键值对
    [self.parametersDic setObject:@"ShortString" forKey:@"type"];
    [MBProgressHUD showMessage:@"正在加载..."];
    //获取上一个选项获得的 dic
    [[JHNetworkManager sharedJHNetworkManager] getPageSaverSettingWith:self.parametersDic];
    
    
}
@end
