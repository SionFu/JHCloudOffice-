//
//  JHSendMailViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHSendMailViewController.h"
#import "JHChosePeopleViewController.h"
#import "JHPageDataManager.h"
#import "JHNetworkManager.h"
#import "MBProgressHUD+KR.h"
#import "JHUserInfo.h"
#import "JHPageDataItem.h"
#import "JHOrguserManger.h"
#import "JHWeaverNetManger.h"
@interface JHSendMailViewController ()<JHOrguser,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JHSendEmailDelegate>
- (IBAction)receivePeopleBtn:(id)sender;
/**
 *  选择接收者按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *receivePeopleBtn;
/**
 *  邮件标题
 */
@property (weak, nonatomic) IBOutlet UITextField *mailTitle;
/**
 *  邮件内容
 */
@property (weak, nonatomic) IBOutlet UITextView *mailContent;
/**
 *  选择文件按钮
 */
- (IBAction)selectFileBtn:(UIButton *)sender;
@property (nonatomic ,assign) NSInteger senderControlTag;
/**
 *  图片的地址
 */
@property (nonatomic ,strong) NSURL *fileUrl;
@end

@implementation JHSendMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationButton];
}
- (void)addNavigationButton {
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmail:)];
    [self.navigationItem setLeftBarButtonItem:liftButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}
- (void)sendEmailSuccess {
//    用代理返回到主页面  并显示是否发送成功
    [MBProgressHUD showSuccess:@"提交成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)sendEmailFaild{
    [MBProgressHUD showError:@"提交失败,网络错误..."];
}
- (void)sendEmail:(UIButton *)send {
    NSLog(@"点击发送按钮");
    [self clickSendBen];
}
- (void)clickSendBen {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定发送?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送邮件
        [self sendEmailContent];
        
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 发送邮件逻辑
//发送邮件逻辑
- (void)sendEmailContent {
    JHWeaverNetManger *manger = [JHWeaverNetManger new];
    manger.sendEamilDelegate = self;
    NSString *sendToId = [JHOrguserManger sharedJHOrguserManger].saveAllListDic[@"0"][@"Key"];
    if ([sendToId isEqualToString:@""]) {
        [MBProgressHUD showError:@"选择收件人"];
        return;
    }
    if ([self.mailTitle.text  isEqualToString:@""]) {
        [MBProgressHUD showError:@"邮件标题不能为空"];
    }
    if ([self.mailContent.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"邮件内容不能为空"];
    }
    [manger mailResultSendMailWithPriority:@"3" andReceiver:@"" andSendToId:sendToId andMailSubject:self.mailTitle.text andMouldText:self.mailContent.text andFileURL:self.fileUrl andFileName:@"test"];
    [MBProgressHUD showMessage:@"正在提交..."];
}
- (void)closeScanVC {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)receivePeopleBtn:(id)sender {
    UIButton *button = sender;
    self.senderControlTag = button.tag;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *value = [JHUserInfo sharedJHUserInfo].companyObjectId;
    NSString *displayValue = value;
    NSString *type = @"ShortString";
    NSString *Key = @"owercompany";
    dic = @{
            @"value":value,
            @"displayValue":displayValue,
            @"type":type,
            @"Key":Key,
            };
    JHPageDataItem *item = [JHPageDataItem new];
    item.Parents = [NSArray arrayWithObject:dic];
    [JHPageDataManager sharedJHPageDataManager].pageDataItemsArray = [NSMutableArray arrayWithObject:item];
    [[JHNetworkManager sharedJHNetworkManager] getPageSettingWithCurrentVC:0 andRow:0];
    
    [[JHNetworkManager sharedJHNetworkManager]getUsersWithDic:[[JHPageDataManager sharedJHPageDataManager]findOwercompanyWithKey:button.tag]];
    JHNetworkManager *net = [JHNetworkManager new];
    net.getOrguserDelegate = self;
    [MBProgressHUD showMessage:@"正在加载..."];
}
-(void)getOrguserSuccess {
    [MBProgressHUD hideHUD];
    JHChosePeopleViewController *cVC = [JHChosePeopleViewController new];
    cVC.navigationTitle = @"选择收件人";
    UINavigationController *nvpageVC = [[UINavigationController alloc]initWithRootViewController:cVC];
    cVC.indexPathTag = self.senderControlTag;
    [self.navigationController presentViewController:nvpageVC animated:YES completion:nil];
    cVC.sendBtn = self.receivePeopleBtn;
    cVC.indexNView = self.view;
}
- (void)dealloc {
//视图消失时  自动删除 最后一个数组
[[JHOrguserManger sharedJHOrguserManger]removerLastParentidsArray];
}
- (IBAction)selectFileBtn:(UIButton *)sender {
    
#pragma 图片\文件选择器
        [self choolImage:UIImagePickerControllerSourceTypePhotoLibrary];
        // 打开相册 或者相机 选取图片
        //    UIActionSheet *sht1 = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
        //    [sht1 showInView:self.view];
}
-(void)choolImage:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType =type;
    picker.allowsEditing = YES;
    //设置代理
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@\n%@",info,picker);
    //    UIImage *image = info[UIImagePickerControllerEditedImage];//取原图还是编辑过的图片
    //此处选择上传文件
    //先把图片转成NSData
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //调整图片方向，防止上传后图片方向不对
    [self fixOrientation:image];
    //压缩图片
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"图片储存路径：%@",DocumentsPath);
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
    NSLog(@"................%@",filePath);
    self.fileUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  图片调整方向
 */
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
