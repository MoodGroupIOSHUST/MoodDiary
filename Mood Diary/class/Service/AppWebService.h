//
//  NSObject+AppWebService.h
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppWebService:NSObject
#define API_LOGIN @"login"
#define API_UPLOADTEST @"admin/student/test/submit"
#define API_LOGOUT @"logout"

//用户登录
+(void)userLoginWithAccount:(NSString *)loginname loginpwd:(NSString *)loginpwd success:(SuccessBlock)success failed:(FailedBlock)failed;

//上传测试结果
+(void)uploadresult:(NSString *)result success:(SuccessBlock)success failed:(FailedBlock)failed;

//用户登出
+(void)userLogoutWithAccount:(NSString *)account success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
