//
//  TestVC.m
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "TestVC.h"
#import "JSONKit.h"
#import "AboutusVC.h"

@interface TestVC ()

@end

@implementation TestVC
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    left = [[UIBarButtonItem alloc]initWithTitle:@"上一题" style:UIBarButtonItemStyleBordered target:self action:@selector(lastclicked)];
    self.navigationItem.leftBarButtonItem = left;
    right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(upload)];
    
    choicearr = [[NSMutableArray alloc]init];
    
    if (isover) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已做完测评!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"关于我们", nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"以下为研究生入学官方心理测试，请认真对待!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
}

-(void)inittest
{
    [self setTitle:@"1/90"];
    questionlable = [[UILabel alloc]initWithFrame:CGRectMake(20, upsideheight+20, SCREEN_WIDTH-40, 100)];
    questionlable.lineBreakMode = NSLineBreakByCharWrapping;
    questionlable.numberOfLines = 0;
    questionlable.font =[UIFont systemFontOfSize:16];
    questionlable.backgroundColor = [UIColor whiteColor];
    questionlable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:questionlable];
    
    btarr = [[NSMutableArray alloc]init];
    
    NSArray *answerarr = [[NSArray alloc]initWithObjects:@"无",@"很轻",@"中等",@"偏重",@"严重", nil];
    for (int i = 0; i<5; i++) {
        answerBt = [[UIButton alloc]initWithFrame:CGRectMake(30, questionlable.frame.origin.y+110+40*i, SCREEN_WIDTH-60, 30)];
        answerBt.tag = i;
        answerBt.backgroundColor = [UIColor colorWithRed:60/255.0 green:173/255.0 blue:235/255.0 alpha:1.0];
        [answerBt setTitle:[answerarr objectAtIndex:i] forState:UIControlStateNormal];
        answerBt.layer.masksToBounds = YES;
        answerBt.layer.cornerRadius = 5;
        [answerBt setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [answerBt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [answerBt addTarget:self action:@selector(btclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:answerBt];
        [btarr addObject:answerBt];
    }
}

-(void)lastclicked
{
    if (choicearr.count == 0) {
        return;
    }
    
    if (choicearr.count <= 90) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    for (UIButton *tembt in btarr) {
        tembt.selected = NO;
    }
    
    int j = [[choicearr lastObject] intValue];
    switch (j) {
        case 1:
            [[btarr objectAtIndex:0] setSelected:YES];
            break;
        case 2:
            [[btarr objectAtIndex:1] setSelected:YES];
            break;
        case 3:
            [[btarr objectAtIndex:2] setSelected:YES];
            break;
        case 4:
            [[btarr objectAtIndex:3] setSelected:YES];
            break;
        case 5:
            [[btarr objectAtIndex:4] setSelected:YES];
            break;
            
        default:
            break;
    }
    
    [choicearr removeLastObject];
    [self refreshtest];
    
}

-(void)upload
{
    [self uploadtest];
    [self initresultview];
}

-(void)btclicked:(UIButton *)sender
{
    if (choicearr.count == 90) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已做完全部题目，请提测评交结果" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    last = now;
    now = [NSDate date];
    if (last) {
         NSTimeInterval sec = [now timeIntervalSinceDate:last];
        if (sec < 0.3) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您做的过快，请根据自身情况认真答题" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (sender.tag == 0) {
        NSString *str = @"1";
        [choicearr addObject:str];
    }
    else if (sender.tag == 1)
    {
        NSString *str = @"2";
        [choicearr addObject:str];
    }
    else if (sender.tag == 2 )
    {
        NSString *str = @"3";
        [choicearr addObject:str];
    }
    else if (sender.tag == 3)
    {
        NSString *str = @"4";
        [choicearr addObject:str];
    }
    else if (sender.tag == 4)
    {
        NSString *str = @"5";
        [choicearr addObject:str];
    }
    
    if (choicearr.count == 90) {
        //答题完毕
        self.navigationItem.rightBarButtonItem = right;
        
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
    }
    else
    {
        NSString *number = [NSString stringWithFormat:@"%lu/90",choicearr.count+1];
        [self setTitle:number];
        for (UIButton *tembt in btarr) {
            tembt.selected = NO;
        }
        [self refreshtest];
    }
}

-(void)lastclickedtest
{
    
}

-(void)uploadtest
{
    NSLog(@"%lu",(unsigned long)choicearr.count);
    [self.view showProgress:YES text:@"上传结果..."];
    self.view.userInteractionEnabled = NO;
    NSString *string = [choicearr componentsJoinedByString:@","];
    NSString *replaced = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSLog(@"%@",string);
    [AppWebService uploadresult:replaced success:^(id result) {
        NSLog(@"success");
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        NSDictionary *temdic = [result objectForKey:@"data"];
        NSDictionary *studic = [temdic objectForKey:@"student"];
        NSDictionary *accountdic = [studic objectForKey:@"account"];

        UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        
        userinfo.accountType = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"accountType"]];
        userinfo.birthday = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"birthday"]];
        userinfo.email = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"email"]];
        userinfo.userid = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"userid"]];
        userinfo.idCard = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"idCard"]];
        userinfo.loginCount = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"loginCount"]];
        userinfo.name = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"name"]];
        userinfo.nickname = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"name"]];
        userinfo.phone = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"phone"]];
        userinfo.photo = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"photo"]];
        userinfo.registerDate = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"registerDate"]];
        userinfo.sex = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"sex"]];
        userinfo.signature = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"signature"]];
        userinfo.status = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"status"]];
        userinfo.useraccount = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"useraccount"]];
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        
        //设置说明页面题目做完状态
        if ([_delegate respondsToSelector:@selector(setdone)]) {
            [_delegate setdone];
        }
        
        //题目做完状态
        isover = YES;
        
        self.navigationItem.rightBarButtonItem = nil;
        
        left = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(lastclickedtest)];
        self.navigationItem.leftBarButtonItem = left;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传结果成功！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];

    }];
}

-(void)initresultview
{
    //删除答题选项
    for (UIButton *tembt in btarr) {
        [tembt removeFromSuperview];
    }
    //删除题目
    [questionlable removeFromSuperview];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    [questionlable removeFromSuperview];
    [answerBt removeFromSuperview];
    UILabel *resultuplabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 50)];
    resultuplabel.font = [UIFont systemFontOfSize:18];
    resultuplabel.text = @"感谢您参与测评";
    resultuplabel.textAlignment = NSTextAlignmentCenter;
    [backview addSubview:resultuplabel];
    
    UILabel *resultdownlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, resultuplabel.frame.origin.y+60, SCREEN_WIDTH-40, 100)];
    resultdownlabel.font = [UIFont systemFontOfSize:14];
    resultdownlabel.text = @"近期我们将发布《心情日记》iOS正式版，有好玩的心情管理，匿名心情墙等功能";
    resultdownlabel.numberOfLines = 0;
    resultdownlabel.lineBreakMode = NSLineBreakByCharWrapping;
    [backview addSubview:resultdownlabel];
    
    UIButton *doneBt = [[UIButton alloc]initWithFrame:CGRectMake(20, resultdownlabel.frame.origin.y+120, SCREEN_WIDTH-40, 40)];
    [doneBt setTitle:@"了解一下我们吧~" forState:UIControlStateNormal];
    doneBt.backgroundColor = [UIColor colorWithRed:60/255.0 green:173/255.0 blue:235/255.0 alpha:1.0];
    doneBt.layer.masksToBounds = YES;
    doneBt.layer.cornerRadius = 5;
    [doneBt addTarget:self action:@selector(doneclicked) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:doneBt];
    
    UIButton *logoutBt = [[UIButton alloc]initWithFrame:CGRectMake(20, resultdownlabel.frame.origin.y+120+60, SCREEN_WIDTH-40, 40)];
    [logoutBt setTitle:@"退            出" forState:UIControlStateNormal];
    logoutBt.backgroundColor = [UIColor colorWithRed:60/255.0 green:173/255.0 blue:235/255.0 alpha:1.0];
    logoutBt.layer.masksToBounds = YES;
    logoutBt.layer.cornerRadius = 5;
    [logoutBt addTarget:self action:@selector(logoutclicked) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:logoutBt];
}

-(void)logoutclicked
{
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

-(void)doneclicked
{
    [self setTitle:nil];
    AboutusVC *about = [[AboutusVC alloc]init];
    [self.navigationController pushViewController:about animated:YES];
}

-(void)refreshtest
{
    int group = (int)((choicearr.count)/10);
    int num = (int)((choicearr.count)%10);
    
    NSString *name = @"jsonTest";
    NSString *testname = [[NSString alloc]initWithFormat:@"%@",name];
    NSString *path = [[NSBundle mainBundle]pathForResource:testname ofType:@"json"];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@";" withString:@","];
    NSDictionary *result = [json objectFromJSONString];
    NSArray *testlist = [result objectForKey:@"data"];
    
    NSArray *arr = [testlist objectAtIndex:group];
    NSString *str = [arr objectAtIndex:num];
    NSLog(@"%@",str);
    questionlable.text = str;
    
    NSString *number = [NSString stringWithFormat:@"%u/90",choicearr.count+1];
    [self setTitle:number];
    
    if (choicearr.count>0) {
        left = [[UIBarButtonItem alloc]initWithTitle:@"上一题" style:UIBarButtonItemStyleBordered target:self action:@selector(lastclicked)];
        self.navigationItem.leftBarButtonItem = left;
    }
    else
    {
        left = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(lastclickedtest)];
        self.navigationItem.leftBarButtonItem = left;
    }
}

#pragma mark uialertviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            AboutusVC *about = [[AboutusVC alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }
    }
    else
    {
        [choicearr removeAllObjects];
        [self inittest];
        [self refreshtest];
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
