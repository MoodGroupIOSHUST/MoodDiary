//
//  FirstpageVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/16.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "FirstpageVC.h"
#import "NewTestVC.h"
#import "upsetVC.h"
#import "depressVC.h"
#import "SpecificVC.h"

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
    scrollback = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight+10, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-49-10)];
    scrollback.backgroundColor = [UIColor whiteColor];
    scrollback.delegate = self;
    [self.view addSubview:scrollback];
    
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, (SCREEN_WIDTH-20)/2)];
    btn1.tag = 1;
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"scl"] forState:UIControlStateNormal];
    [scrollback addSubview:btn1];
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 5;
    [btn1 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn1.frame.origin.y + btn1.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/1.4)];
    btn2.tag = 2;
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"upset"] forState:UIControlStateNormal];
    [scrollback addSubview:btn2];
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 5;
    [btn2 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-20-8)/2-10, btn1.frame.origin.y + btn1.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/1.4)];
    btn3.tag = 3;
    btn3.backgroundColor = [UIColor clearColor];
    btn3.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = 5;
    [btn3 setBackgroundImage:[UIImage imageNamed:@"depress"] forState:UIControlStateNormal];
    [scrollback addSubview:btn3];
    [btn3 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
//    btn4 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn3.frame.origin.y + btn3.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/2)];
//    btn4.tag = 4;
//    btn4.backgroundColor = [UIColor blueColor];
//    [scrollback addSubview:btn4];
//    [btn4 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    btn5 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-20-8)/2-10, btn3.frame.origin.y + btn3.frame.size.height+10, (SCREEN_WIDTH-20-8)/2, (SCREEN_WIDTH-20-8)/2)];
//    btn5.tag = 5;
//    btn5.backgroundColor = [UIColor orangeColor];
//    [scrollback addSubview:btn5];
//    [btn5 addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];
    
    if ((btn3.frame.origin.y+btn3.frame.size.height)<(SCREEN_HEIGHT-upsideheight-49)) {
        scrollback.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-49);
    }
    else
    {
        scrollback.contentSize = CGSizeMake(SCREEN_WIDTH, btn3.frame.origin.y+btn3.frame.size.height);
    }
    
    scrollback.showsVerticalScrollIndicator = NO;
    
}

- (void)btnpress:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [self pushtoscl];
            break;
        case 2:
            [self pushtojiaolv];
            break;
        case 3:
            [self pushtoyiyu];
            break;

        default:
            break;
    }
}

- (void)pushtoscl{
    
    SpecificVC *specific = [[SpecificVC alloc]init];
    specific.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:specific animated:YES];

}

- (void)pushtojiaolv{
    upsetVC *upset = [[upsetVC alloc]init];
    upset.testname = @"upset";
    upset.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:upset animated:YES];
}

- (void)pushtoyiyu{
    depressVC *depress = [[depressVC alloc]init];
    depress.testname = @"depress";
    depress.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:depress animated:YES];
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
