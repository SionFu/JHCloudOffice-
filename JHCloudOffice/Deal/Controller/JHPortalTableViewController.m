//
//  JHPortalTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHPortalTableViewController.h"
#import "JHModulesData.h"
#import "JHCategoryTableViewCell.h"
#import "JHModules.h"
#import "JHNetworkManager.h"
#import "JHPageTableViewController.h"
@interface JHPortalTableViewController ()
@property (nonatomic, strong)NSMutableArray *catrgoryArray;

@property (nonatomic ,strong ) UINib *nib;




@end

@implementation JHPortalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.catrgoryArray = [JHModulesData sharedJHModulesData].allModuleArray[i];
    ++i;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    i = 0;
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

    return self.catrgoryArray.count;
}
static int i = 0;
- (NSInteger)getNumberOfRowsInSection{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"CateGoryCell";
    
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHCategoryTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JHModules *data = self.catrgoryArray[indexPath.row];
    cell.textLabel.text = data.ModuleName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前流程的控件数据
    [[JHNetworkManager sharedJHNetworkManager] getPageSettingWithCurrentVC:[JHModulesData sharedJHModulesData].curreatVCIndex andRow:indexPath.row];
    //获取当前选择流程的流程数据
    [[JHNetworkManager sharedJHNetworkManager] getPageDatas];
    JHPageTableViewController *pageVC = [[JHPageTableViewController alloc]init];
    UINavigationController *nvpageVC = [[UINavigationController alloc]initWithRootViewController:pageVC];
    JHModules *data = self.catrgoryArray[indexPath.row];
    pageVC.pageName = data.ModuleName;
    [self.navigationController presentViewController:nvpageVC animated:YES completion:nil];
    
}


@end
