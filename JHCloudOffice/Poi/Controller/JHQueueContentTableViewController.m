//
//  JHQueueContentTableViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/14.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHQueueContentTableViewController.h"
#import "JHRestApi.h"
#import "JHSubscribeViewController.h"
#import "JHQueueTableViewCell.h"
#import "JHPoiModel.h"
#import "MBProgressHUD+KR.h"
#import "JHDetailWebViewController.h"
@interface JHQueueContentTableViewController ()<JHQueueObjectsDelegate>
@property (nonatomic ,strong)JHRestApi *apiManger;
@property (nonatomic ,strong ) UINib *nib;
/**
 *  推送列表数组内容
 */
@property (nonatomic, strong ) NSArray *queueArray;
//是否有查看全文
@property (nonatomic, assign) BOOL haveDetalContent;
@end

@implementation JHQueueContentTableViewController
-(BOOL)haveDetalContent {
    NSDictionary *dic = self.queueArray[0];
    if ([[dic allKeys]containsObject:@"PURL"]) {
        return true;
    }
    return false;
}
-(NSArray *)queueArray {
    return [JHPoiModel sharedJHPoiModel].queueDatasArray;
}
-(JHRestApi *)apiManger {
    if (_apiManger == nil) {
        _apiManger = [JHRestApi new];
    }return _apiManger;
}
- (void)viewWillAppear:(BOOL)animated {
    [JHPoiModel sharedJHPoiModel].queueData = nil;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = NO;
    //获取所有列表检查 此项目是否订阅
    [self.apiManger subscribeObjectsGetSubscribeObjectsWithAction:@"alllist"];
    self.apiManger.getQueueObjectsDelegate = self;
    [self.apiManger pushQueueObjectsGetPushQueueObjectsWithPublicGuid:self.poiDic[@"PUBLICGUID"] andPageSize:@"4" andPageIndex:@"1"];
}
-(void)getQueueObjectsSuccess {
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //行高自适应====必须要给这两行
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //预估值
    self.tableView.estimatedRowHeight = 200;
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];

     self.clearsSelectionOnViewWillAppear = NO;
    self.title = self.poiDic[@"PUBLICNAME"];
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //显示内容
    
    
}
-(UIBarButtonItem *)editButtonItem {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"····" style:UIBarButtonItemStylePlain target:self action:@selector(detalButtonClink:)];
    return rightButton;
}

- (void)detalButtonClink:(id)sender {
    //推出是否取消订阅视图
    JHSubscribeViewController *subView = [JHSubscribeViewController new];
    subView.poiDic = [JHRestApi getObjectFollowSubscribeInAllListWithPublicCode:self.poiDic[@"PUBLICCODE"]];
    [self.navigationController pushViewController:subView animated:YES];
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
    return self.queueArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"QueueCell";
    
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHQueueTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    JHQueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateTimeStr = [NSString stringWithFormat:@"%@",self.queueArray[indexPath.row][@"PTIME"]];
    NSDate *date = [dateFormatter dateFromString:dateTimeStr];
    [dateFormatter setDateFormat:@"MM月dd日 HH时"];
    
    cell.publicTitleLabel.text = self.queueArray[indexPath.row][@"PTITLE"];
    cell.publicTimeLabel.text = [dateFormatter stringFromDate:date];
    cell.publicDescLabel.text = self.queueArray[indexPath.row][@"PDESC"];
    //判断是否需要显示 详细内容
    if (self.haveDetalContent) {
     cell.publicUrlLabel.hidden = NO;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.haveDetalContent) {
        NSLog(@"%ld",(long)indexPath.row);
        //显示详细视图
        JHDetailWebViewController *webView = [JHDetailWebViewController new];
        webView.urlStr = self.queueArray[indexPath.row][@"PURL"];
        [self.navigationController pushViewController:webView animated:YES];
    }

}
#pragma mark delete
//1.是否可以编辑canEdit
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//2.每行编辑的样式editstyleForAtIndex
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//3.点中删除后的效果commitEditStyle
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除本条推送?" message:@"确定" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //1.获取数据
//        TRPoetry *proty = self.poetryArray[indexPath.row];
//        
//        if ([TRPoetry removePotryWithID:proty.poetryID]) {
//            NSLog(@"删除成功");
//            //2.更新数组中的数据
//            NSString *protuStr = proty.poetryKind;
//            self.poetryArray = [TRPoetry poetryListWithKind:protuStr];
//            //[self.collectionView reloadData];
//            //3.删除对应的cell
//            
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        }
    }];
    [alertController addAction:action];
    [alertController addAction:delAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//自定义删除按钮
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除推送";
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//      自适应高度
//    return 400;
//
//}


@end
