//
//  UserInfo.h
//  FlowMng
//
//  Created by tysoft on 14-2-27.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject  {
    NSString *accountType;
    NSString *birthday;
    NSString *email;
    NSString *userid; //是否需要限制文件类型
    NSString *idCard;
    NSString *loginCount;
    NSString *name;   //app更新地址
    NSString *nickname;  //用户权限
    NSString *phone; //记住密码
    NSString *photo;      //自动登录
    NSString *registerDate;
    NSString *sex;//默认显示多少行
    NSString *signature;
    NSString *status;
    NSString *useraccount;
 }

@property (nonatomic, retain) NSString *accountType;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *idCard;
@property (nonatomic, retain) NSString *loginCount;
@property (nonatomic ,retain) NSString *name;
@property (nonatomic ,retain) NSString *nickname;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic ,retain) NSString *registerDate;
@property (nonatomic ,retain) NSString *sex;
@property (nonatomic, retain) NSString *signature;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *useraccount;

@end
