//
//  JHWeaverNetManger.h
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 获取  邮件列表  邮件内容
 */
@protocol JHDownMailDelegate <NSObject>

- (void)downMailSuccess;
- (void)downMailFaild;

@end
/**
 *下载附件代理
 */
@protocol JHDownFileDelegate <NSObject>

- (void)downFileSuccess;
- (void)downFileFaild;

@end
/**
 *  发送邮件代理
 */
@protocol JHSendEmailDelegate <NSObject>

- (void)sendEmailSuccess;
- (void)sendEmailFaild;

@end
/**
 *  获取文件目录代理
 */
@protocol JHDocDelegate <NSObject>

- (void)getDocSuccess;
- (void)getDocFaild;
@end
/**
 *  获取文件列表 通知 代理
 */
@protocol JHFileListDelegate <NSObject>

- (void)getFileListSuccess;
- (void)getFileListFaild;

@end
/**
 *  获取文件内容 代理
 */
@protocol JHFileContentDelegate <NSObject>

- (void)getFileContentSuccess;
- (void)getFileContentFaild;

@end
@interface JHWeaverNetManger : NSObject
@property (nonatomic, weak) id<JHDownMailDelegate> downMailDelegate;
@property (nonatomic, weak) id<JHDownFileDelegate> downFileDelegate;
@property (nonatomic ,weak) id<JHFileContentDelegate> getFileContentDelegate;
/**
 *  成功获取文件列表 通知 代理
 */
@property (nonatomic, weak) id<JHFileListDelegate> getFileListDelegate;
/**
 *  发送邮件代理
 */
@property (nonatomic, weak)id<JHSendEmailDelegate> sendEamilDelegate;
/**
 *获取目录返回成功信息
 */
@property (nonatomic, weak)id<JHDocDelegate> getDocDelegate;
/**
 *  获取知识文档列表目录
 *
 *  @param mainid      主目录id
 *  @param subid       一级目录id
 *  @param seccategory 二级目录id
 */
- (void)weaverCategoryObjectsgetDocContentWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory;
/**
 * 通知 和 文件列表
 */
- (void)docInfoObjectsgetNoticesWithMainid:(NSString *)mainid andSubid:(NSString *)subid andSeccategory:(NSString *)seccategory andnewOnly:(NSString *)newOnly andPage:(NSString *)page andPageSize:(NSString *)pageSize;
/**
 *  文件内容
 */
- (void)docInfoContentObjectGetDocContentWithDocId:(NSString *)docId;
/**
 *  未收邮件列表 邮件列表
 */
- (void)mailObjectsGetMailInBoxWithNewOnly:(BOOL )iNewOnly andFolderId:(NSString *)folderId andPage:(NSString *)page andPageSize:(NSString *)pageSize;
/**
 *  邮件内容
 */
- (void)mailContentObjectsGetMailContent:(NSString *)mailId;
/**
 *  发送邮件
 */
- (void)mailResultSendMailWithPriority:(NSString *)priority andReceiver:(NSString *)receiver andSendToId:(NSString *)sendToId andMailSubject:(NSString *)mailSubject andMouldText:(NSString *)mouldText andFileURL:(NSURL *)fileURL andFileName:(NSString *)fileName;
/**
 *  downloadFile
 */
- (void)downloadFileWithDocId:(NSString *)docId AndFileName:(NSString *)fileName;
@end
