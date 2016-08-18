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
@interface JHEditTableViewController ()
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
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@implementation JHEditTableViewController
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

@end
