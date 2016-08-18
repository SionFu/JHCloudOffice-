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
@interface JHEditTableViewController ()
@property (nonatomic ,strong ) UINib *nib;
@property (nonatomic, strong) NSArray *typeArray;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@implementation JHEditTableViewController
-(NSArray *)typeArray{
    _typeArray = [JHBizDataManager sharedJHBizDataManager].typeArray;
    return _typeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNage = @"测试页面";
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
    NSArray *array = [JHBizDataManager sharedJHBizDataManager].itemDisplayNameArray[indexPath.row];
    NSString *str = array[0];
    cell.itemDisplayNameLabelText.text = [str stringByAppendingString:@":"];
    //将不同的控件添加到 cell 上
//    [self addControlTocontrolTypeView:cell inRow:indexPath.row];
    return cell;
}

-(void)addControlTocontrolTypeView:(JHBizEditTableViewCell *)cell inRow:(NSInteger)index {
    if ([self.typeArray[index] isEqualToString:@"ShortString"]) {
        
    }
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
