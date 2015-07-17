//
//  AppDelegate.m
//  MoodDiary
//
//  Created by Sunc on 15/7/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self registernotify];
    [self setUmengShare];
    
    [self ininloginvc];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)registernotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToWhitchViewController)
                                                 name:GO_TO_CONTROLLER object:nil];
}

- (void)setUmengShare{
    [UMSocialData setAppKey:@"5551a63e67e58ef9a3001ba3"];
    //新浪分享
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //qq空间和好友
    [UMSocialQQHandler setQQWithAppId:@"1104693283" appKey:@"wGqtJ9VZnpIB46Zp" url:@"http://etotech.net:8080/psychology/toIndex"];
    //微信和微信好友
}

-(void)ininloginvc
{
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    if (info.useraccount.length>0&&info.password.length>0) {
        //自动登陆
        
        NSString *passwaord = info.password;
        
        [AppWebService userLoginWithAccount:info.useraccount loginpwd:info.password success:^(id result) {
            NSLog(@"success");
            
            NSDictionary *temdata  = [result objectForKey:@"data"];
            NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[temdata objectForKey:@"account"]];
            
            UserInfo *userinfo  = [[UserInfo alloc]init];
            userinfo.accountType = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"accountType"]];
            userinfo.birthday = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"birthday"]];
            userinfo.email = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"email"]];
            userinfo.userid = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userid"]];
            userinfo.idCard = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"idCard"]];
            userinfo.loginCount = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"loginCount"]];
            userinfo.name = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"name"]];
            userinfo.nickname = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"nickname"]];
            userinfo.phone = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"phone"]];
            userinfo.photo = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"photo"]];
            userinfo.registerDate = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"registerDate"]];
            userinfo.sex = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sex"]];
            userinfo.signature = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"signature"]];
            userinfo.status = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]];
            userinfo.useraccount = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"username"]];
            userinfo.password = passwaord;
            
            [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
            [NSUserDefaults setBool:YES forKey:IS_LOGIN];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
            
            
        } failed:^(NSError *error) {
            NSLog(@"fail");
            
            [NSUserDefaults setBool:NO forKey:IS_LOGIN];
            
            [self goToWhitchViewController];
            
            
        }];
        
    }
    else{
        
        //手动登陆
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        LoginVC *loginvc = [[LoginVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
    }
}

- (void)goToWhitchViewController{
    //先判断是否登陆
    if ([NSUserDefaults boolForKey:IS_LOGIN]){
        self.tabBarController = [[MainTabBarViewController alloc]init];
        self.window.rootViewController = self.tabBarController;
    }
    else{
        LoginVC *loginvc = [[LoginVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
    }
}

#pragma mark - UmsocialCallback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"------first------url%@",url);
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"------second------url%@",url);
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
