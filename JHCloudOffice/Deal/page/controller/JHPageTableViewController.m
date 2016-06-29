//
//  JHPageTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPageTableViewController.h"
#import "JHPageTableViewCell.h"
@interface JHPageTableViewController ()
/**
 *  所有流程项目名称
 */
@property (nonatomic, strong)NSArray *pageCategory;
/**
 *  所有项目的控件
 */
@property (nonatomic, strong)NSArray *typeArray;
@property (nonatomic ,strong ) UINib *nib;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 25)
@implementation JHPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
- (NSArray *)pageCategory{
    if (_pageCategory == nil) {
        _pageCategory = [NSArray arrayWithObjects:@"日期:",@"姓名:",@"单位:", nil];
    }return _pageCategory;
}
-(NSArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
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

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"reuseIdentifier";
    
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHPageTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
        UILabel *headTitle = [[UILabel alloc]initWithFrame:CONTROLFRME];
        headTitle.text = self.pageNage;
        headTitle.textAlignment = NSTextAlignmentCenter;
        headTitle.center = CGPointMake(self.view.frame.size.width / 2, 10);
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        [tableView.tableHeaderView addSubview: headTitle];
        
    }
    JHPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.itemDisplayNameLabelText.text = self.pageCategory[indexPath.row];
    //将不同的控件添加到 cell 上
    [self addControlTocontrolTypeView:cell inRow:indexPath.row];
    return cell;
}

-(void)addControlTocontrolTypeView:(JHPageTableViewCell *)cell inRow:(NSInteger)index {
    if ([self.typeArray[index] isEqualToString:@"1"]) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 25)];
        textField.tag = index;
        textField.backgroundColor = [UIColor whiteColor];
        textField.text = @"我是一个测试的文字";
        [cell.controlTypeView addSubview:textField];
        
    }
    if ([self.typeArray[index] isEqualToString:@"2"]) {
        UIButton *button = [[UIButton alloc]initWithFrame:CONTROLFRME];
        button.backgroundColor = [UIColor redColor];
        [cell.controlTypeView addSubview:button];
    }
    if ([self.typeArray[index] isEqualToString:@"3"]) {
        UIDatePicker *pick = [[UIDatePicker alloc]initWithFrame:CONTROLFRME];
        UIPickerView *pickview = [[UIPickerView alloc]initWithFrame:CONTROLFRME];
        [cell.controlTypeView addSubview:pickview];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
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
