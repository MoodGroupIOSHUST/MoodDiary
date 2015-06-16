//
//  LoginVC.m
//  Mood Diary
//
//  Created by SunCheng on 15-4-8.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "LoginVC.h"
#import "WelcomeVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [self setTitle:@"登陆"];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:241/255.0 alpha:1.0];
    if(IS_IOS_7)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    }
    
    [self initloginpart];
    [self initbt];
    
}

-(void)initloginpart
{
    backview = [[UIView alloc]initWithFrame:CGRectMake(20, upsideheight+20, SCREEN_WIDTH-40, 40)];
    backview.backgroundColor = [UIColor whiteColor];
    backview.layer.masksToBounds = YES;
    backview.layer.cornerRadius = 5;
    [self.view addSubview:backview];
    
    UIImageView *userimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, (40-25)/2, 25, 25)];
    userimg.image = [UIImage imageNamed:@"account"];
    [backview addSubview:userimg];
    
    useraccountTF = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, SCREEN_WIDTH-40-90, 40)];
    useraccountTF.delegate = self;
    useraccountTF.font = [UIFont systemFontOfSize:14];
    useraccountTF.returnKeyType = UIReturnKeyNext;
    useraccountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    useraccountTF.placeholder = @"请输入登录名";
    useraccountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backview addSubview:useraccountTF];
    
    //+20为临时调整
    backview = [[UIView alloc]initWithFrame:CGRectMake(20, upsideheight+40+20+10+20, SCREEN_WIDTH-40, 40)];
    backview.backgroundColor = [UIColor whiteColor];
    backview.layer.masksToBounds = YES;
    backview.layer.cornerRadius = 5;
    [self.view addSubview:backview];
    
    UIImageView *pwdimg = [[UIImageView alloc]initWithFrame:CGRectMake(20,(40-25)/2,25,25)];
    pwdimg.image = [UIImage imageNamed:@"password"];
    [backview addSubview:pwdimg];
    
    pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, SCREEN_WIDTH-40-90, 40)];
    pwdTF.delegate = self;
    pwdTF.font = [UIFont systemFontOfSize:14];
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.placeholder = @"请输入密码";
    pwdTF.secureTextEntry = YES;
    pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backview addSubview:pwdTF];

}

-(void)initbt
{
    NSArray *titlearr = [NSArray arrayWithObjects:@"登      陆",@"体       验",@"注      册", nil];
    
    for (int i=0; i<1; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, backview.frame.origin.y+40+i*50+30, SCREEN_WIDTH-40, 40)];
        button.tag = i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor colorWithRed:60/255.0 green:173/255.0 blue:235/255.0 alpha:1.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:[titlearr objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(loginclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)userlogin
{
//    if (useraccountTF.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
//    if (pwdTF.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    self.view.userInteractionEnabled = NO;
    [self.view showProgress:YES text:@"请等待..."];
    [AppWebService userLoginWithAccount:@"student1" loginpwd:@"123456" success:^(id result) {
        NSLog(@"success");
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
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
        userinfo.nickname = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"name"]];
        userinfo.phone = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"phone"]];
        userinfo.photo = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"photo"]];
        userinfo.registerDate = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"registerDate"]];
        userinfo.sex = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sex"]];
        userinfo.signature = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"signature"]];
        userinfo.status = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]];
        userinfo.useraccount = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"useraccount"]];
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        [NSUserDefaults setBool:YES forKey:IS_LOGIN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
        
        
    } failed:^(NSError *error) {
        NSLog(@"fail");
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

-(void)loginclicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        //登陆
//        [useraccountTF resignFirstResponder];
//        [pwdTF resignFirstResponder];
        [self userlogin];
    }
    else if (sender.tag == 1)
    {
        //体验
    }
    else if (sender.tag ==2)
    {
        //注册
    }
}

#pragma mark- uitextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == useraccountTF) {
        [useraccountTF resignFirstResponder];
        [pwdTF becomeFirstResponder];
    }
    else
    {
        [pwdTF resignFirstResponder];
        [self userlogin];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
