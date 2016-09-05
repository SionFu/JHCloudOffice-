//
//  JHDocModel.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDocModel.h"

@implementation JHDocModel
-(NSDictionary *)docData {
    return self.allDataArray.lastObject;
}
-(NSArray *)firDicArray {
     return   self.docData[@"data"];
}
- (NSArray *)thiDicArray {
      return  self.docData[@"data"];
}
- (NSMutableArray *)allDataArray {
    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }return _allDataArray;
}
-(void)removeLasterDocArray {
    [self.allDataArray removeLastObject];
}
- (NSDictionary *)fileListData {
    if (_fileListData == nil) {
        _fileListData = [NSDictionary dictionary];
    }return _fileListData;
}
-(NSArray *)fileListArray {
    return self.fileListData[@"data"][@"data"];
}
-(NSDictionary *)fileContentData {
    if (_fileContentData == nil) {
        _fileContentData = [NSDictionary dictionary];
    }return _fileContentData;
}
-(NSArray *)fileSubArray {
    return self.fileContentData[@"data"][@"subDocs"];
}
-(NSString *)fileContentDetailStr {
    return self.fileContentData[@"data"][@"gwDetail"];
}
singleton_implementation(JHDocModel)
@end
