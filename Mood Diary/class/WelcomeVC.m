//
//  WelcomeVC.m
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "WelcomeVC.h"
#import "SpecificVC.h"
#import "AboutusVC.h"

@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"欢迎"];
    
    [self initwelcome];

}

-(void)initwelcome
{
    UIImageView *welImg = [[UIImageView alloc]initWithFrame:CGRectMake(75, upsideheight+30, SCREEN_WIDTH-150, SCREEN_WIDTH-150)];
    welImg.backgroundColor = [UIColor clearColor];
    welImg.image = [UIImage imageNamed:@"logo"];
    welImg.layer.masksToBounds = YES;
    welImg.layer.cornerRadius = 6;
    [self.view addSubview:welImg];
    
    UILabel *welLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, welImg.frame.origin.y+SCREEN_WIDTH-150+10, SCREEN_WIDTH-60, 60)];
    welLabel.text = @"欢迎进入研究生入学心理健康测评";
    welLabel.font = [UIFont systemFontOfSize:14];
    welLabel.backgroundColor = [UIColor whiteColor];
    welLabel.lineBreakMode = NSLineBreakByCharWrapping;
    welLabel.numberOfLines = 0;
    welLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welLabel];
    
    UIButton *gototestBt = [[UIButton alloc]initWithFrame:CGRectMake(25, upsideheight+30+60+SCREEN_WIDTH-150+20, SCREEN_WIDTH-50, 40)];
    gototestBt.backgroundColor = [UIColor colorWithRed:60/255.0 green:173/255.0 blue:235/255.0 alpha:1.0];
    gototestBt.layer.masksToBounds = YES;
    gototestBt.layer.cornerRadius = 5;
    [gototestBt setTitle:@"进入测评" forState:UIControlStateNormal];
    [gototestBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gototestBt addTarget:self action:@selector(btclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gototestBt];
    
}

-(void)btclicked
{
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    if ([userinfo.accountType isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已完成测评" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"关于我们",@"退出登陆", nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        SpecificVC *specific = [[SpecificVC alloc]init];
        [self.navigationController pushViewController:specific animated:YES];
    }
}

#pragma mark - uialertviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        [self.view showProgress:YES text:@"请等待..."];
        [AppWebService userLogoutWithAccount:nil success:^(id result) {
            NSLog(@"logout success");
            [self.view showProgress:NO];
            [NSUserDefaults setBool:NO forKey:IS_LOGIN];
            [[NSNotificationCenter defaultCenter]postNotificationName:GO_TO_CONTROLLER object:nil];
        } failed:^(NSError *error) {
            NSLog(@"fail");
            [self.view showProgress:NO];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.delegate = self;
            [alert show];
        }];
    }
    else if(buttonIndex == 1)
    {
        AboutusVC *about = [[AboutusVC alloc]init];
        [self.navigationController pushViewController:about animated:YES];
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

@end
