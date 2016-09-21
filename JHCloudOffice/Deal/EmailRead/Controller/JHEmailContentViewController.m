//
//  JHEmailContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHEmailContentViewController.h"
#import "JHWeaverNetManger.h"
#import "MBProgressHUD+KR.h"
#import "JHMailDataModel.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface JHEmailContentViewController ()<JHGetMailDelegate,UIDocumentInteractionControllerDelegate,JHDownFileDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic ,strong)JHWeaverNetManger *manger;
/**
 *  发件人
 */
@property (weak, nonatomic) IBOutlet UILabel *sendFromLabel;
/**
 *  收到邮件时间
 */
@property (weak, nonatomic) IBOutlet UILabel *sendDateLbel;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
/**
 *  邮件内容显示控件
 */
@property (weak, nonatomic) IBOutlet UIWebView *mailContentWebView;
/**
 *  下载附件进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *downFileProgressView;
/**
 *  显示附件视图
 */
@property (weak, nonatomic) IBOutlet UIView *fileView;
/**
 *  显示邮件视图的高度, 没有附件时高度为0
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileViewHeight;
@property (nonatomic ,strong)NSArray *fileSubArray;
/**
 *  需要显示的邮件 id
 */
@property (nonatomic, strong) NSString *mailIdStr;
/**
 *  当前文件的路径
 */
@property (nonatomic, strong) NSString *filePath;
/**
 *  添加 navigation 按钮
 */
@property (nonatomic, strong)UIView *button;
@end

@implementation JHEmailContentViewController
-(NSArray *)fileSubArray {
    return [JHMailDataModel sharedJHMailDataModel].mailDocsArray;
}
-(NSString *)mailIdStr {
    return self.mailContentDic[@"mailid"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObject];
    self.manger = [JHWeaverNetManger new];
    self.manger.getMailDelegate = self;
    [self.manger mailContentObjectsGetMailContentWithMailId:self.mailIdStr];
    
}
- (void)addObject {
    self.subjectLabel.text = self.mailContentDic[@"subject"];
    self.sendFromLabel.text = self.mailContentDic[@"sendfrom"];
    self.sendDateLbel.text = self.mailContentDic[@"senddate"];
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
}
- (void)addNavigationBtn{
    self.button = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 + 20, 25, SCREENWIDTH / 2 - 25, 30)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"转发邮件",@"回复邮件", nil];
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *statusbutton = [[UIButton alloc]initWithFrame:CGRectMake(i * ((SCREENWIDTH / 2 - 25 ) / 2), 0, (SCREENWIDTH / 2 - 25 ) / 2, 30)];
        [statusbutton setTitle:titleArray[i] forState:UIControlStateNormal];
        [statusbutton setBackgroundImage:[UIImage imageNamed:@"tab_unselected_pressed.9"] forState:UIControlStateHighlighted];
        [statusbutton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [statusbutton setTag:10 + i];
        [self.button addSubview:statusbutton];
    }
    [self.navigationController.view addSubview:self.button];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.button removeFromSuperview];
}
-(void)dealloc {
    

}
-(void)getMailSuccess {
    //添加导航按钮 获取邮件内容后才可以出现转发按钮
     [self addNavigationBtn];
    //显示相关控件内容
    [self.mailContentWebView loadHTMLString:[JHMailDataModel sharedJHMailDataModel].mailContentDataDic[@"content"] baseURL:nil];
    //成功下载邮件 刷新视图
    self.mailContentWebView.scrollView.bounces = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    self.fileViewHeight = 0;
//    self.fileView.hidden = YES;
//    [self loadViewIfNeeded];
    [self addFileArrayToButton];
}
- (void)addFileArrayToButton {
    for (int i = 0; i< self.fileSubArray.count; i++) {
        NSDictionary *fileDic = self.fileSubArray[i];
        UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 35,SCREENWIDTH, 30)];
        [btn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitle:fileDic[@"filename"] forState:UIControlStateNormal];
        [btn setTag:i+100];
        //设置文本自动大小
        [btn.titleLabel setAutoresizesSubviews:YES];
        [btn.titleLabel setMinimumScaleFactor:0.5];
        [btn addTarget:self action:@selector(fileDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.fileView addSubview:btn];
    }
    self.fileViewHeight.constant =SCREENHEIGHT - 35 * self.fileSubArray.count - 10;
}
- (void)fileDownBtnClick:(UIButton *)sender {
    NSString *fileName = self.fileSubArray[sender.tag - 100][@"filename"];
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
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showError:@"文件下载失败"];
}
#pragma mark GetMaildelegate
-(void)getMailFaild {
    //下载邮件失败
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
