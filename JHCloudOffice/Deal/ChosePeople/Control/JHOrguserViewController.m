//
//  JHOrguserViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHOrguserViewController.h"
#import "JHOrguserTableView.h"
#import "JHNetworkManager.h"
#import "JHOrguserManger.h"
#import "JHOrguserTableViewCell.h"
@interface JHOrguserViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  放置选择组织人员的左右滑动选择视图
 */
@property (nonatomic, strong) JHOrguserTableView *ortableView;
//声明表视图子类用这个表格初始化
@property (nonatomic, strong) NSArray *parentidsArray;
@property (nonatomic ,strong ) UINib *nib;
@end
#define TABLEVIEWFRAMEL CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height - 104)
#define TABLEVIEWFRAMER CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height - 104)
/*
 float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
 float navigationHeight = self.navigationController.navigationBar.frame.size.height;
 */
@implementation JHOrguserViewController

-(NSArray *)parentidsArray {
    if (_parentidsArray == nil) {
        _parentidsArray = [NSArray arrayWithArray:[JHOrguserManger sharedJHOrguserManger].parentidsArray];
    }return _parentidsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [JHNetworkManager sharedJHNetworkManager].getOrguserDelegate = self;
    
    self.ortableView.delegate = self;
    self.ortableView.dataSource = self;
    [self addTableViewToScrollViewController];
}

- (void)addTableViewToScrollViewController {
    self.ortableView = [[JHOrguserTableView alloc]initWithFrame:TABLEVIEWFRAMEL];
    [self.view addSubview:self.ortableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.parentidsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHOrguserTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
    }
    JHOrguserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = self.parentidsArray[indexPath.row][@"DisplayValue"];
    cell.headImage.image = [UIImage imageNamed:@"ic_menu_deal_on"];
    cell.footImage.image = [UIImage imageNamed:@"arraw_ic"];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
