//
//  AboutusVC.m
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "AboutusVC.h"
#import "HTCopyableLabel.h"

@interface AboutusVC ()

@end

@implementation AboutusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"关于我们"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initabout];
}

-(void)initabout
{
    NSString *str1 = @"心迹是一款专为大学生打造的心情管理软件，iOS正式版将于近期发布，在这里你可以记录心情，分享心情，享受专业的心理咨询与测试，还有好玩的心情墙。记得关注哦~";
    NSString *str2 = @"欢迎有志之士加盟我们工作室，共同打造高校心理第一互联服务平台。";
    
    CGSize size1 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-40, 999) fontsize:16 text:str1];
    UILabel *uplabel = [[UILabel alloc]initWithFrame:CGRectMake(20, upsideheight+20, SCREEN_WIDTH-40,
                                                                size1.height)];
    uplabel.text = str1;
    uplabel.font = [UIFont systemFontOfSize:16];
    uplabel.numberOfLines = 0;
    uplabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:uplabel];
    
    CGSize size2 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-40, 999) fontsize:16 text:str2];
    UILabel *downlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, uplabel.frame.origin.y+size1.height, SCREEN_WIDTH-40,
                                                                  size2.height)];
    downlabel.text = str2;
    downlabel.font = [UIFont systemFontOfSize:16];
    downlabel.numberOfLines = 0;
    downlabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:downlabel];
    
    NSString *str3 = @"客服QQ：1216985594";
    NSString *str4 = @"邮      箱：etotech@163.com";
    
    
    HTCopyableLabel *labelup = [[HTCopyableLabel alloc]initWithFrame:CGRectMake(20, downlabel.frame.origin.y+size2.height+20, SCREEN_WIDTH-40, 30)];
    labelup.text = str3;
    labelup.tag = 0;
    labelup.copyableLabelDelegate = self;
    [self.view addSubview:labelup];
//    UIView *lineup = [[UIView alloc]initWithFrame:CGRectMake(20+labelup.frame.size.width-200, labelup.frame.origin.y+24, 92, 1.5)];
//    lineup.backgroundColor  =[UIColor blueColor];
//    [self.view addSubview:lineup];
    
    HTCopyableLabel *labeldown = [[HTCopyableLabel alloc]initWithFrame:CGRectMake(20, labelup.frame.origin.y+30, SCREEN_WIDTH-40, 30)];
    labeldown.text = str4;
    labeldown.tag = 1;
    labeldown.copyableLabelDelegate = self;
    [self.view addSubview:labeldown];
//    UIView *linedown = [[UIView alloc]initWithFrame:CGRectMake(20+labeldown.frame.size.width-200, labeldown.frame.origin.y+24, 140, 1.5)];
//    linedown.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:linedown];
    
}

-(NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel
{
    //剪切板复制粘贴的qq号和邮箱
    if (copyableLabel.tag == 0) {
        return @"1216985594";
    }
    else
    {
        return @"etotech@163.com";
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
