//
//  JHFileContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHFileContentViewController.h"
#import "JHWeaverNetManger.h"
#import "JHDocModel.h"
#import "MBProgressHUD+KR.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@interface JHFileContentViewController ()<JHFileContentDelegate,UIWebViewDelegate,JHDownFileDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
/**
 *  当前文件的路径
 */
@property (nonatomic, strong) NSString *filePath;
/**
 *  进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/**
 *  显示文件内容 webView 视图
 */
@property (weak, nonatomic) IBOutlet UIWebView *fileContentWebView;
/**
 *  下载文件列表
 */
@property (weak, nonatomic) IBOutlet UIScrollView *fileSubScroolView;
/**
 *  文件中下载文件的 文件列表数组
 */
@property (nonatomic, strong) NSArray *fileSubArray;
/**
 *  文件中信息的内容 html 标记语言
 */
@property (nonatomic, strong) NSString *fileContentDetailStr;
@property (nonatomic ,strong) JHWeaverNetManger *manger;
@end

@implementation JHFileContentViewController
-(NSArray *)fileSubArray {
    return [JHDocModel sharedJHDocModel].fileSubArray;
}
-(NSString *)fileContentDetailStr {
    return [JHDocModel sharedJHDocModel].fileContentDetailStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件查看";
    [MBProgressHUD showMessage:@"正在载入..."];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.manger = [JHWeaverNetManger new];
    self.manger.getFileContentDelegate = self;
    [self.manger docInfoContentObjectGetDocContentWithDocId:[NSString stringWithFormat:@"%d",self.docId]];
}
- (void)getFileContentSuccess {
    [MBProgressHUD hideHUD];
    self.fileContentWebView.delegate = self;
    NSLog(@"\n文件列表:%@",self.fileSubArray);
    [self.fileContentWebView loadHTMLString:self.fileContentDetailStr baseURL:nil];
    [self addFileArrayToButton];
}
- (void)addFileArrayToButton {
    for (int i = 0; i< self.fileSubArray.count; i++) {
        NSDictionary *fileDic = self.fileSubArray[i];
        UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 30,SCREENWIDTH, 30)];
        [btn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitle:fileDic[@"fileName"] forState:UIControlStateNormal];
        [btn setTag:i+100];
        [btn addTarget:self action:@selector(fileDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fileSubScroolView addSubview:btn];
    }
}
- (void)fileDownBtnClick:(UIButton *)sender {
    NSString *fileName = self.fileSubArray[sender.tag - 100][@"fileName"];
    NSString *docid = self.fileSubArray[sender.tag - 100][@"docid"];
    //downloadFile
    //判断文件是否存在
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    self.filePath = filePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.manger.downFileDelegate = self;
    if( [fileManager fileExistsAtPath:filePath]== YES ) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已经下载过同样名字的文件!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"重新下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //重新下载文件
            [MBProgressHUD showMessage:@"正在下载" toView:self.view];
            [self.manger downloadFileWithDocId:docid AndFileName:fileName];
        }];
        UIAlertAction *actionOpen = [UIAlertAction actionWithTitle:@"直接打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //直接打开文件
            NSURL *url = [NSURL fileURLWithPath:filePath];
            _documentInteractionController = [UIDocumentInteractionController
                                              interactionControllerWithURL:url];
            [_documentInteractionController setDelegate:self];
            
            [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",filePath]]];
        }];
        [alert addAction:actionYes];
        [alert addAction:actionOpen];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载文件!" message:[NSString stringWithFormat:@"确定下载文件:%@?",fileName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //下载文件
            [MBProgressHUD showMessage:@"正在下载" toView:self.view];
            [self.manger downloadFileWithDocId:docid AndFileName:fileName];
            
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
#pragma markJHFileContentDelegate
-(void)getFileContentFaild {
    [MBProgressHUD showError:@"网络错误"];
}
-(void)closeScanVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
