//
//  JHitemEditTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/12.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHitemEditTableViewController.h"
#import "JHPageTableViewCell.h"
#import "JHBizDataManager.h"
@interface JHitemEditTableViewController ()
@property (nonatomic, strong) UINib *nib;
@property (nonatomic, strong) NSArray *typeArray;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@implementation JHitemEditTableViewController
-(NSArray *)typeArray{
    _typeArray = [JHBizDataManager sharedJHBizDataManager].typeArray;
    return _typeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBtn];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray.count;
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
    cell.itemDisplayNameLabelText.text = [[JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray[indexPath.row] stringByAppendingString:@":"];
    //将不同的控件添加到 cell 上
    [self addControlTocontrolTypeView:cell inRow:indexPath.row];
    return cell;
}

-(void)addControlTocontrolTypeView:(JHPageTableViewCell *)cell inRow:(NSInteger)index {
     if ([self.typeArray[index] isEqualToString:@"ShortString"]) {
         
     }
}

@end
