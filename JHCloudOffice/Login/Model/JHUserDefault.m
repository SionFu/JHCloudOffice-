//
//  JHUserDefault.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/28.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHUserDefault.h"

@implementation JHUserDefault
+(void)remberUserName:(NSString *)userName andUserPwd:(NSString *)userPwd{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userName forKey:@"userName"];
    [user setObject:userPwd forKey:@"userPwd"];
}
+(BOOL)autoLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] == nil ) {
        return NO;
    }else{
        return YES;
    }
}
+(NSString *)getUserName{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userName"];
}
+(NSString *)getPwd{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userPwd"];
}
+(void)clearUser{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"userName"];
    [user setObject:nil forKey:@"userPwd"];
}
@end
