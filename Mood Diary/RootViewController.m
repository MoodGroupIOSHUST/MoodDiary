//
//  RootViewController.m
//  Mood Diary
//
//  Created by SunCheng on 15-4-8.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    [self initnav];
    upsideheight = 0;
    if (IS_IOS_7) {
        stateheight = [self getstateheight];
        navheight = [self getnavheight];
        upsideheight = stateheight + navheight;
    }
}

-(void)initnav
{
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],UITextAttributeTextColor,nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],UITextAttributeTextColor,nil]];
    }
    
}

//自适应文字
-(CGSize)maxlabeisize:(CGSize)labelsize fontsize:(NSInteger)fontsize text:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:labelsize lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}

-(void)refreshAgain {
    
}

-(void)showAlertViewTitle:(NSString *)title message:(NSString *)mseeage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:mseeage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
}


-(void)handPopBack {
    NSTimer *connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
}

-(void)timerFired:(NSTimer *)timer{
    
    [self popBack];
    
}

-(void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}
//新版本检测
-(BOOL)hasNewVersion
{
    NSString *flowversion = [NSUserDefaults objectUserForKey:APP_VERSION];
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *preVersion =[dic objectForKey:@"CFBundleVersion"];
    NSArray* preVerArr =[preVersion componentsSeparatedByString:@"."];
    NSArray* flowVerArr=[flowversion componentsSeparatedByString:@"."];
    BOOL isNewVersion=NO;
    for (int i=0; i<preVerArr.count; i++) {
        int a = [[preVerArr objectAtIndex:i]intValue];
        if (flowVerArr.count>i) {
            int b=[[flowVerArr objectAtIndex:i]intValue];
            if (a>b) {
                return NO;
            }
            if (a < b) {
                isNewVersion=YES;
                break ;
            }
        }
    }
    if (isNewVersion){
        
        return YES;
    }
    else
        return NO;
}

-(float)getnavheight
{
    float height;
    height = self.navigationController.navigationBar.frame.size.height;
    return height;
}

-(float)getstateheight
{
    float height;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    height = rectStatus.size.height;
    return height;
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
