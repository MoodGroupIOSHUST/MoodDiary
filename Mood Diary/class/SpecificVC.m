//
//  SpecificVC.m
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "SpecificVC.h"
#import "TestVC.h"
#import "AboutusVC.h"
#import "NewTestVC.h"

@interface SpecificVC ()

@end

@implementation SpecificVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"测评说明"];
    [self initdetail];
    self.view.backgroundColor =[UIColor whiteColor];
}

-(void)setdone
{
    done = YES;
}

-(void)initdetail
{
    if (done) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已完成测评！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"关于我们",@"退出登录", nil];
        alert.tag = 0;
        [alert show];
        return;
    }
    
    NSString *content1 = @"下面有90条测试项目，列出了有些人可能会有的问题，请仔细地阅读每一条，然后更具最近一星期以内你的实际感觉，选择合适的答案点击，请注意不要漏题";
    
    NSString *content2 = @"应当记住的是：\n\n1.每一测题只能选择一个答案；\n\n2.不可漏掉任何测题；\n\n3.尽量不选择中性答案；\n\n4.本测验有时间限制，但凭自己的直觉反应进行作答，不要迟疑不决，拖延时间；\n\n5.有些题目你可能从未思考过，或者感到不太容易回答。对于这样的题目，同样要求你做出一种倾向性的选择。";
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, upsideheight+10, SCREEN_WIDTH-40, 70)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.lineBreakMode = NSLineBreakByCharWrapping;
    label1.numberOfLines = 0;
    label1.text = content1;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, label1.frame.origin.y+70, SCREEN_WIDTH-40, 230)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.lineBreakMode = NSLineBreakByCharWrapping;
    label2.numberOfLines = 0;
    label2.text = content2;
    [self.view addSubview:label2];
    
    confirmBt = [[UIButton alloc]initWithFrame:CGRectMake(20, label2.frame.origin.y+230+20, SCREEN_WIDTH-40, 40)];
    [confirmBt setTitle:@"确认" forState:UIControlStateNormal];
    
//    #warning 正式发布时，interaction改为no
    confirmBt.userInteractionEnabled = NO;
    confirmBt.layer.masksToBounds = YES;
    confirmBt.layer.cornerRadius = 5;
    confirmBt.backgroundColor = [UIColor lightGrayColor];
    [confirmBt addTarget:self action:@selector(confirmbtclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBt];
    
    [self counttime];
}

-(void)confirmbtclicked
{
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    if ([userinfo.accountType isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已完成SCL90测评" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        NewTestVC *test = [[NewTestVC alloc]init];
        [self.navigationController pushViewController:test animated:YES];
    }
}

-(void)counttime
{
    __block int timeout=15; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                confirmBt.userInteractionEnabled = YES;
                confirmBt.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
                confirmBt.titleLabel.font = [UIFont systemFontOfSize:16];
                [confirmBt setTitle:@"确认" forState:UIControlStateNormal];
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"确认(%ds)", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                confirmBt.titleLabel.font = [UIFont systemFontOfSize:16];
                [confirmBt setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -uialertviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AboutusVC *about = [[AboutusVC alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else
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
