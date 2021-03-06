//
//  JHDealViewViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDealViewViewController.h"
#import "JHHoneHeadView.h"
#import "JHUserInfo.h"
#import "JHNetworkManager.h"
#import "JHProcessViewController.h"
#import "JHScanCRCodeViewController.h"
#import "JHSendMailViewController.h"
#import "JHDocTableViewController.h"
#import "MBProgressHUD+KR.h"
#import "JHRestApi.h"
#import "UIImage+FDChangeStringToCRCode.h"
#import "JHFileListTableViewController.h"
#import "JHReadEmailTableViewController.h"
#import "JHTaskTableViewController.h"
#import "JHGlobalModel.h"
@interface JHDealViewViewController ()<JHHomeMenuButtonDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,JHGetNotificationObjectDelegate>
/**
 *  用户姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *heandImageView;
/**
 *  显示本人的二维码
 */
- (IBAction)cIQRCodeButton:(id)sender;
/**
 *  待办流程数
 */
@property (weak, nonatomic) IBOutlet UILabel *unReadTaskLabel;
/**
 *  未读邮件数
 */
@property (weak, nonatomic) IBOutlet UILabel *unReadEmailLabel;
/**
 *  未读通知数
 */
@property (weak, nonatomic) IBOutlet UILabel *unReadNotiLabel;
@property (nonatomic, strong)NSString *userCIQRCodeStr;
/**
 * 待办流程数 点击
 */
- (IBAction)unReadTaskBtnClick:(UIButton *)sender;
/**
 * 未读邮件 点击
 */
- (IBAction)unReadEmailBtnClick:(UIButton *)sender;
/**
 * 未读通知数 点击
 */
- (IBAction)unReadNotiBtnClick:(UIButton *)sender;


@property (nonatomic, strong)UINavigationItem *rootNavigatioItem;

@end

@implementation JHDealViewViewController
-(UINavigationItem *)rootNavigatioItem {
    return [JHGlobalModel sharedJHGlobalModel].rootNavigationItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [self timerAction];
    //添加navigation 扫描二维码 和 查找按钮内容  按钮
    [self addNavigationButton];
}
static int unReadTask;
static int unReadNoti;
static int lastUnReadNoti;
static int lastUnReadTask;
-(void)getNoticationSuccess {
    NSDictionary *responseObject = [JHUserInfo sharedJHUserInfo].notificationDic;
    unReadTask = [responseObject[@"taskCount"] intValue];
    unReadNoti = [responseObject[@"noticeCount"] intValue];
    //处理通知逻辑
    if (unReadTask > 10) {
        [JHGlobalModel sharedJHGlobalModel].unReadTask = unReadTask;
    }else {
        //如果获取的通知数与上次获取的相同 则不加通知数量
        if (unReadTask == lastUnReadTask) {
        }
        unReadTask = [JHGlobalModel sharedJHGlobalModel].unReadTask + unReadTask;
    }
    
    if (unReadNoti > 10) {
        [JHGlobalModel sharedJHGlobalModel].unReadNoti = unReadNoti;
    }else {
        //如果获取的通知数与上次获取的相同 则不加通知数量
        if (unReadNoti == lastUnReadNoti) {
        }
        unReadNoti = [JHGlobalModel sharedJHGlobalModel].unReadNoti + unReadNoti;
    }
    lastUnReadNoti = [responseObject[@"noticeCount"] intValue];
    lastUnReadTask = [responseObject[@"taskCount"] intValue];
    self.unReadTaskLabel.text = [NSString stringWithFormat:@"%d",unReadTask];
    self.unReadEmailLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"emailCount"]];
    self.unReadNotiLabel.text = [NSString stringWithFormat:@"%d",unReadNoti];
    NSString *timeStr= [NSString stringWithFormat:@"%@",responseObject[@"time"]];
    NSRange range = [timeStr rangeOfString:@" "];
    timeStr = [timeStr substringToIndex:(range.location)];
    [JHUserInfo sharedJHUserInfo].notificationTime = timeStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加入计时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //设置滚动选择视图
    [self setUpHomeHeadView];
    //显示用户登陆信息
    [self showUserInfo];
    [self.heandImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageViewTep)]];
    //获取形成用户的二维码字符串
    [self getuserCIQRCodeStr];

}
- (void)addNavigationButton {
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scanCRCodeViewController)];
    //打开扫描二维码
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(scanCRCodeViewController)];
    //打开查找视图
    NSArray *buttonArray = [NSArray arrayWithObjects:scanButton,searchButton, nil];
    self.rootNavigatioItem.rightBarButtonItems = buttonArray;
}
- (void) timerAction {
    //刷新通知数
    JHRestApi *apiManger = [JHRestApi new];
    [apiManger notificationObjectGetNotificationWithTime:[JHUserInfo sharedJHUserInfo].notificationTime];
    apiManger.getNotificationDelegate = self;
}
- (void)scanCRCodeViewController {
    JHScanCRCodeViewController *sVC = [JHScanCRCodeViewController new];
    UINavigationController *uVC = [[UINavigationController alloc]initWithRootViewController:sVC];
    [self.navigationController presentViewController:uVC animated:YES completion:nil];
}
-(void)headImageViewTep{
    //只能选择相册
//    [self choolImage:UIImagePickerControllerSourceTypePhotoLibrary];
    //警告框选择 两种选项
//        UIActionSheet *sht1 = [[UIActionSheet alloc]initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
//        [sht1 showInView:self.view];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //可以打开相机
            UIImagePickerController *pc = [[UIImagePickerController alloc]init];
            pc.allowsEditing = YES;
            pc.delegate = self;
            pc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pc animated:YES completion:nil];
        }
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *pc = [[UIImagePickerController alloc]init];
            pc.allowsEditing = YES;
            pc.delegate = self;
            pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pc animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 2) {
//    }else if (buttonIndex == 1){
//        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
//        pc.allowsEditing = YES;
//        pc.delegate = self;
//        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:pc animated:YES completion:nil];
//    }else{
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            //可以打开相机
//        }else{
//            NSLog(@"该设备暂时不支持打开相机");
//        }
//    }
//}

//-(void)choolImage:(UIImagePickerControllerSourceType)type{
//    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    picker.sourceType =type;
//    picker.allowsEditing = YES;
//    //设置代理
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
//}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];//取原图还是编辑过的图片
        self.heandImageView.image = image;//选择的图片
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showUserInfo {
    self.nameLabel.text = [JHUserInfo sharedJHUserInfo].name;
    self.companyLabel.text = [JHUserInfo sharedJHUserInfo].company;
}
- (void)setUpHomeHeadView {
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    JHHoneHeadView *headView = [[JHHoneHeadView alloc]initWithFrame:CGRectMake(0, 0, screenWith, screenWith / 1.5)];
    headView.delegate = self;
    [self.headView addSubview: headView];
}

-(void)clickHomeMenuButton:(long)sender{
    NSLog(@"%ld",sender - 100);
    switch (sender - 100) {
        case 0:{
            JHProcessViewController *evc = [JHProcessViewController new];
            evc.title = @"发起流程";
            [self.navigationController pushViewController:evc animated:YES];
                }
            break;
        case 1:{
            //发送邮件
            JHSendMailViewController *sMailVC  = [JHSendMailViewController new];
            sMailVC.title = @"发送邮件";
            UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:sMailVC];
            [self.navigationController presentViewController:nVC animated:YES completion:^{
                
            }];
        }
            break;
        case 2:{
            //打开集团彩云 app
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uban://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uban://"]];
            }
            else
            {
                [MBProgressHUD showError:@"请先安装集团彩云App"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://"]];
            }
        }
            break;
        case 3:{
            //扫描二维码
            [self scanCRCodeViewController];
        }
            break;
        case 4:{
            //显示用户文档
            JHDocTableViewController *docVC = [JHDocTableViewController new];
            [self.navigationController pushViewController:docVC animated:YES];
        }
            break;
        default:
            break;
    }
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
#pragma GetAndShowUserCIQRCode
- (void)getuserCIQRCodeStr {
    self.userCIQRCodeStr = [NSString stringWithFormat:@"user:%@:%@:%@",[JHUserInfo sharedJHUserInfo].objectId,[JHUserInfo sharedJHUserInfo].name,[JHUserInfo sharedJHUserInfo].loginid];
}
- (IBAction)cIQRCodeButton:(id)sender {
//    NSData *dataCode = [self.userCIQRCodeStr dataUsingEncoding:NSUTF8StringEncoding];
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];//二维码
//    [filter setValue:dataCode forKey:@"inputMessage"];
//    CIImage *ciimage = filter.outputImage;
    UIImageView *ciqrCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 50, 150, 150)];
    
    ciqrCodeView.layer.shadowOffset = CGSizeMake(0, 0.5);
    ciqrCodeView.layer.shadowColor = [UIColor blackColor].CGColor;
    ciqrCodeView.layer.shadowOpacity = 0.3;
//    ciqrCodeView.image = [self createNonInterpolatedUIImageFormCIImage:ciimage size:500];
    
  ciqrCodeView.image = [UIImage getCRCodeImageWithString:self.userCIQRCodeStr];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"我的二维码\n\n\n\n\n\n\n" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC.view addSubview:ciqrCodeView];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];

}

- (IBAction)unReadTaskBtnClick:(UIButton *)sender {
    NSLog(@"task");
    JHTaskTableViewController *taskView = [JHTaskTableViewController new];
    taskView.title = @"待办任务";
    taskView.taskStates = @"0;1";
    [self.navigationController pushViewController:taskView animated:YES];
    
}
- (IBAction)unReadEmailBtnClick:(UIButton *)sender {
        NSLog(@"email");
    JHReadEmailTableViewController *mailView = [JHReadEmailTableViewController new];
    mailView.title = @"查看邮件";
    mailView.unReadMail = true;
    [self.navigationController pushViewController:mailView animated:YES];
}
- (IBAction)unReadNotiBtnClick:(UIButton *)sender {
        NSLog(@"noti");
    JHFileListTableViewController *fileView = [JHFileListTableViewController new];
    fileView.seccategory = @"541";
    fileView.isNewOnl = @"true";
    fileView.title = @"查看通知";
    [self.navigationController pushViewController:fileView animated:YES];
}
@end
