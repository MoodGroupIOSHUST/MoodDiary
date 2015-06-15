//
//  NSObject+AppWebService.m
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTourAPIClient.h"
#import "AppWebService.h"
#import "OperationModel.h"

@implementation AppWebService

//登录方法例子
+(void)userLoginWithAccount:(NSString *)loginname loginpwd:(NSString *)loginpwd success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginname, @"j_username", loginpwd, @"j_password", nil];
    [[iTourAPIClient sharedClient] postPath:API_LOGIN parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            if ([errormsg isEqualToString:@"1"]) {
                errormsg = @"用户名为空";
            }
            else if ([errormsg isEqualToString:@"2"])
            {
                errormsg = @"密码为空";
            }
            else if ([errormsg isEqualToString:@"3"])
            {
                errormsg = @"验证码错误";
            }
            else if ([errormsg isEqualToString:@"4"])
            {
                errormsg = @"用户名不存在";
            }
            else if ([errormsg isEqualToString:@"5"])
            {
                errormsg = @"账号或密码错误";
            }
            else if ([errormsg isEqualToString:@"6"])
            {
                errormsg = @"账号未启用";
            }
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

+(void)uploadresult:(NSString *)result success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *point = @"100";
    NSString *type = @"3";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:result, @"result",type,@"type", point,@"points",nil];
    [[iTourAPIClient sharedClient] postPath:API_UPLOADTEST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//登出
+(void)userLogoutWithAccount:(NSString *)account success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict = nil;
    
    [[iTourAPIClient sharedClient] postPath:API_LOGOUT parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        SAFE_BLOCK_CALL(success, responseJson);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}
@end
