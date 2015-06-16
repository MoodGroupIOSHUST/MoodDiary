//
//  FirstpageVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/16.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "FirstpageVC.h"

@interface FirstpageVC ()

@end

@implementation FirstpageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"心情日记";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initparts];
}

- (void)initparts{
    scrollback = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    scrollback.backgroundColor = [UIColor whiteColor];
    scrollback.delegate = self;
    [self.view addSubview:scrollback];
    
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, (SCREEN_WIDTH-20)/2)];
    btn1.tag = 1;
    btn1.backgroundColor = [UIColor greenColor];
    [scrollback addSubview:btn1];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn1.frame.origin.y + btn1.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/2)];
    btn2.tag = 2;
    btn2.backgroundColor = [UIColor yellowColor];
    [scrollback addSubview:btn2];
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-20-8)/2-10, btn1.frame.origin.y + btn1.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/2)];
    btn3.tag = 3;
    btn3.backgroundColor = [UIColor redColor];
    [scrollback addSubview:btn3];
    
    btn4 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn3.frame.origin.y + btn3.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/2)];
    btn4.tag = 4;
    btn4.backgroundColor = [UIColor blueColor];
    [scrollback addSubview:btn4];
    
    btn5 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-20-8)/2-10, btn3.frame.origin.y + btn3.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/2)];
    btn5.tag = 5;
    btn5.backgroundColor = [UIColor orangeColor];
    [scrollback addSubview:btn5];
    
    scrollback.contentSize = CGSizeMake(SCREEN_WIDTH, btn5.frame.origin.y+btn5.frame.size.height);
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
