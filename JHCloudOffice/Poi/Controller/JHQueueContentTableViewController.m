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
@interface JHQueueContentTableViewController ()<JHQueueObjectsDelegate,UIDocumentInteractionControllerDelegate,JHDownPFileDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic ,strong)JHRestApi *apiManger;
@property (nonatomic ,strong ) UINib *nib;
/**
 *  推送列表数组内容
 */
@property (nonatomic, strong ) NSMutableArray *queueArray;
//是否有查看全文
@property (nonatomic, assign) BOOL haveDetalContent;
/**
 *  是否有下载内容
 */
@property (nonatomic, assign) BOOL isFile;
/**
 *  当前文件的路径
 */
@property (nonatomic, strong) NSString *filePath;
@end

@implementation JHQueueContentTableViewController
- (BOOL)isFile {
    if ([[NSString stringWithFormat:@"%@",self.queueArray[0][@"ISFILE"]]isEqualToString:@"1"]) {
        return true;
    }else {
        return false;
    }
}
-(BOOL)haveDetalContent {
    NSDictionary *dic = self.queueArray[0];
    if ([[dic allKeys]containsObject:@"PURL"]) {
        return true;
    }
    return false;
}
-(NSMutableArray *)queueArray {
    if (_queueArray == nil) {
        _queueArray = [[JHPoiModel sharedJHPoiModel].queueDatasArray mutableCopy];
    }
    return _queueArray;
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
    [self getData];
}
- (void)getData {
    //获取所有列表检查 此项目是否订阅
    [self.apiManger subscribeObjectsGetSubscribeObjectsWithAction:@"alllist"];
    self.apiManger.getQueueObjectsDelegate = self;
    [self.apiManger pushQueueObjectsGetPushQueueObjectsWithPublicGuid:self.poiDic[@"PUBLICGUID"] andPageSize:@"6" andPageIndex:@"1"];
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
        if (self.isFile) {
         cell.publicUrlLabel.text = @"点击下载";
        }else {
        cell.publicUrlLabel.text = @"查看全文";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else {
        cell.publicUrlLabel.text = @"";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.haveDetalContent) {
        if (self.isFile) {
            [self downLoadFileWith:indexPath];
        }else {
        //显示详细视图
        JHDetailWebViewController *webView = [JHDetailWebViewController new];
        webView.urlStr = self.queueArray[indexPath.row][@"PURL"];
        [self.navigationController pushViewController:webView animated:YES];
    }
    }

}
- (void)downLoadFileWith:(NSIndexPath *) indexpath{
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.queueArray[indexpath.row][@"PTITLE"],self.queueArray[indexpath.row][@"FILETYPE"]];
    NSString *pUrl = self.queueArray[indexpath.row][@"PURL"];
    //downloadFile
    //判断文件是否存在
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    self.filePath = filePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.apiManger.downFileDelegate = self;
    if( [fileManager fileExistsAtPath:filePath]== YES ) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已经下载过同样名字的文件!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"重新下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //重新下载文件
            [MBProgressHUD showMessage:@"正在下载" toView:self.view];
            [self.apiManger downloadFileWithPURL:pUrl AndFileName:fileName];
        }];
        UIAlertAction *actionOpen = [UIAlertAction actionWithTitle:@"直接打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //直接打开文件
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",filePath]]];
            NSURL *url = [NSURL fileURLWithPath:filePath];
            _documentInteractionController = [UIDocumentInteractionController
                                              interactionControllerWithURL:url];
            [_documentInteractionController setDelegate:self];
            
            [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            
        }];
        UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@" 取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionYes];
        [alert addAction:actionOpen];
        [alert addAction:actionNo];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载文件!" message:[NSString stringWithFormat:@"确定下载文件:%@?",fileName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //下载文件
            [MBProgressHUD showMessage:@"正在下载" toView:self.view];
            [self.apiManger downloadFileWithPURL:pUrl AndFileName:fileName];
            
        }];
        UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@" 取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionYes];
        [alert addAction:actionNo];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark downloadFileDelegate
-(void)downFileSuccess {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载成功!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"打开文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开文件
        NSLog(@"%@",self.filePath);
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        _documentInteractionController = [UIDocumentInteractionController
                                          interactionControllerWithURL:url];
        [_documentInteractionController setDelegate:self];
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)downFileFaild {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"文件下载失败"];
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
            //1.删除服务器数据
        [self.apiManger resultPojoDeletePushQueueObjectWithPqid:self.queueArray[indexPath.row][@"PQID"]];
        // 2.删除本视图 数组内容
        [self.queueArray removeObjectAtIndex:indexPath.row];
            //3.返回 block 更新数据 删除 cell
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

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
