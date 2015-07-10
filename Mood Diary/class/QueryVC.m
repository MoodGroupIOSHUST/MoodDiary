//
//  QueryVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "QueryVC.h"
#import "UIHyperlinksButton.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface QueryVC ()

@end

@implementation QueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"咨询指引";
    
    [self initquerytable];
}

- (void)initquerytable{
    querytable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    querytable.backgroundColor = [UIColor whiteColor];
    querytable.tableFooterView = [[UIView alloc]init];
    querytable.delegate = self;
    querytable.dataSource = self;
    [self.view addSubview:querytable];
}

- (void)labelClicked:(UIHyperlinksButton *)lable{
    NSLog(@"%ld",(long)lable.tag);
    
    NSString* str =lable.titleLabel.text;
    NSString* phone=lable.accessibilityLabel;
    if (lable.tag==1) {
        //打开网址
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
    if (lable.tag==2) {
        //拨打电话
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"拨打电话"
                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.accessibilityLabel=phone;
        actionSheet.tag = 0;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
    }
    
    if (lable.tag==3) {
        //发送邮件
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"发送邮件"
                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.accessibilityLabel=phone;
        actionSheet.tag = 1;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
    }

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex==0) {
            //调用电话的方式
            NSString *telUrl = [NSString stringWithFormat:@"tel:%@",actionSheet.accessibilityLabel];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else if (actionSheet.tag == 1){
        if (buttonIndex==0) {
            //邮件
            NSString *mailUrl = [NSString stringWithFormat:@"%@",actionSheet.accessibilityLabel];
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setToRecipients:[NSArray arrayWithObjects:mailUrl,nil]];
            
             if([self respondsToSelector:@selector(presentModalViewController:animated:)]) {
                 //- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated NS_DEPRECATED_IOS(2_0, 6_0);
                 [self presentModalViewController:mc animated:YES];
             }
             else {
                 //- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0);
                 [self presentViewController:mc animated:YES completion:^(void) {}];
             }
        }
    }
    
}
             
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件已保存");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送失败，错误: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^(void) {}];
}

#pragma mark - uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - uitableviewdelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"set";
    
    //如果以后cell数量增多，这里建议改为自定义cell
    
    float width = 220;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    }
    
    for (UIView *V in cell.contentView.subviews) {
        [V removeFromSuperview];
    }
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 60, 60)];
    imgview.layer.cornerRadius = imgview.bounds.size.height/2;
    imgview.layer.masksToBounds = YES;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-imgview.frame.size.width-width+10, 20, width, 25)];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor blackColor];
    
    UIHyperlinksButton* teleLbale1=[[UIHyperlinksButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-imgview.frame.size.width-width+10, title.frame.origin.y+title.frame.size.height+10, width, 25)];
    teleLbale1.tag=1;
    teleLbale1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    teleLbale1.titleLabel.font =[UIFont systemFontOfSize:14];
    [teleLbale1 setColor:[UIColor lightGrayColor]];
    [teleLbale1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [teleLbale1 setBackgroundColor:[UIColor clearColor]];
    teleLbale1.titleLabel.textAlignment=NSTextAlignmentLeft;
    [teleLbale1 addTarget:self action:@selector(labelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIHyperlinksButton* teleLbale2=[[UIHyperlinksButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-imgview.frame.size.width-width+10, teleLbale1.frame.origin.y+teleLbale1.frame.size.height+10, width, 25)];
    teleLbale2.tag=2;
    teleLbale2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    teleLbale2.titleLabel.font =[UIFont systemFontOfSize:14];
    [teleLbale2 setColor:[UIColor lightGrayColor]];
    [teleLbale2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [teleLbale2 setBackgroundColor:[UIColor clearColor]];
    teleLbale2.titleLabel.textAlignment=NSTextAlignmentLeft;
    [teleLbale2 addTarget:self action:@selector(labelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIHyperlinksButton* teleLbale3=[[UIHyperlinksButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-imgview.frame.size.width-width+10, teleLbale2.frame.origin.y+teleLbale2.frame.size.height+10, width, 25)];
    teleLbale3.tag=3;
    teleLbale3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    teleLbale3.titleLabel.font =[UIFont systemFontOfSize:14];
    [teleLbale3 setColor:[UIColor lightGrayColor]];
    [teleLbale3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [teleLbale3 setBackgroundColor:[UIColor clearColor]];
    teleLbale3.titleLabel.textAlignment=NSTextAlignmentLeft;
    [teleLbale3 addTarget:self action:@selector(labelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == 0) {
        
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"hust"];
        [cell.contentView addSubview:imgview];
        
        title.text = @"华中科技大学心理咨询室";
        [cell.contentView addSubview:title];
        
        [teleLbale1 setTitle:@"Http://xlzx.hust.edu.cn" forState:UIControlStateNormal];
        teleLbale1.accessibilityLabel=@"Http://xlzx.hust.edu.cn";
        [cell.contentView addSubview:teleLbale1];
        
        [teleLbale2 setTitle:@"Tel: 027-87543148" forState:UIControlStateNormal];
        teleLbale2.accessibilityLabel=@"027-87543148";
        [cell.contentView addSubview:teleLbale2];
        
        [teleLbale3 setTitle:@"Mail: zhangjy@mail.hust.edu.cn" forState:UIControlStateNormal];
        teleLbale3.accessibilityLabel=@"zhangjy@mail.hust.edu.cn";
        [cell.contentView addSubview:teleLbale3];
    }
    else if (indexPath.row ==1){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"whu"];
        imgview.frame = CGRectMake(15, 47, 65, 65);
        [cell.contentView addSubview:imgview];
        
        title.text = @"武汉大学心理咨询室";
        [cell.contentView addSubview:title];
        
        [teleLbale1 setTitle:@"Http://202.114.99.43/xlzx/AO" forState:UIControlStateNormal];
        teleLbale1.accessibilityLabel=@"Http://202.114.99.43/xlzx/AO";
        [cell.contentView addSubview:teleLbale1];
        
        [teleLbale2 setTitle:@"Tel: 027-68774413" forState:UIControlStateNormal];
        teleLbale2.accessibilityLabel=@"027-68774413";
        [cell.contentView addSubview:teleLbale2];
        
        [teleLbale3 setTitle:@"Mail: xlzx-whu@yahoo.cn" forState:UIControlStateNormal];
        teleLbale3.accessibilityLabel=@"xlzx-whu@yahoo.cn";
        [cell.contentView addSubview:teleLbale3];
    }
    
    
    return cell;
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
