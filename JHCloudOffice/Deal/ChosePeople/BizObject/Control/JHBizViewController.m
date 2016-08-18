//
//  JHBizViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/8.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHBizViewController.h"
#import "TSTableViewModel.h"
#import "TSDefines.h"
#import "JHBizViewController+BizDataDefinition.h"
#import "TSTableViewHeaderSection.h"
#import "JHBizEiditTableViewController.h"
#import "JHBizDataManager.h"
#import "JHPageDataManager.h"

#import "JHEditTableViewController.h"
@interface JHBizViewController ()<TSTableViewDelegate> {
    TSTableView *_tableView;
    TSTableViewModel *_model;
}

@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@implementation JHBizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBtn];
     [[JHBizDataManager sharedJHBizDataManager] getItemDisplayName];
    [[JHBizDataManager sharedJHBizDataManager]makeSourceFromServer];
    [[JHPageDataManager sharedJHPageDataManager]makeSourceFromServerWithArray:[JHBizDataManager sharedJHBizDataManager].bizObjectObjArray];
    _tableView = [[TSTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _model = [[TSTableViewModel alloc]initWithTableView:_tableView andStyle:kTSTableViewStyleLight];
    [_model setColumns:[self columnsInfo] andRows:[self rowsInfo]];
    // Do any additional setup after loading the view.
}
-(void)dealloc {
    //视图消失时  自动删除 最后一个数组
    [[JHBizDataManager sharedJHBizDataManager]removerLastParentidsArray];
}
#pragma TSTableViewDelegate
- (void)tableView:(TSTableView *)tableView didSelectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex {
    NSLog(@"%ld",rowPath.section);
}
- (void)tableView:(TSTableView *)tableView willSelectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated {
    NSLog(@"%ld",(long)columnPath.section);
    if (columnPath.section == 0) {
        return;
    }
    JHBizEiditTableViewController *itemView = [JHBizEiditTableViewController new];
    UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:itemView];
    itemView.title = @"编辑采购明细表";
    [self presentViewController:nVC animated:YES completion:^{
        
    }];
}

#pragma AddNavigationButton
- (void)addNavigationBtn{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 + 75, 25, SCREENWIDTH / 2 - 80, 30)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"添加",@"确定", nil];
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *statusbutton = [[UIButton alloc]initWithFrame:CGRectMake(i * ((SCREENWIDTH / 2 ) / 3), 0, (SCREENWIDTH / 2 - 40 ) / 3, 30)];
        [statusbutton setTitle:titleArray[i] forState:UIControlStateNormal];
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
            NSLog(@"点击了添加");
            //persent EditView
            [self  AddItemButtonClick];
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
- (void)AddItemButtonClick {
    JHEditTableViewController *itemView = [JHEditTableViewController new];
    UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:itemView];
    itemView.title = @"添加采购项目";
    [[JHBizDataManager sharedJHBizDataManager]makeSourceFromServer];
    [self presentViewController:nVC animated:YES completion:^{
        
    }];
}
//返回 (取消) 按钮
- (void)todoClickBackAction:(UIBarButtonItem *)send {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
