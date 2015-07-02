//
//  MyVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "MyVC.h"
#import "PersonalInfoVC.h"
#import "QueryVC.h"
#import "AboutusVC.h"
#import "AlertPwdViewController.h"

@interface MyVC ()

@property (nonatomic) CGFloat height;

@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _height = 60;
    [self initsettable];
}

- (void)initsettable{
    settable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    settable.delegate = self;
    settable.dataSource = self;
    settable.tableFooterView = [[UIView alloc]init];
    
    CGRect frame = settable.tableHeaderView.frame;
    frame.size.height = 25;
    
    [self.view addSubview:settable];
    
}

#pragma mark - uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _height;
}

#pragma mark - uitableviewdelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    }
    
    for (UIView *V in cell.contentView.subviews) {
        [V removeFromSuperview];
    }
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, _height-12, _height-12)];
    imgview.layer.masksToBounds = YES;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.origin.x + imgview.frame.size.width +10, 2, 200, _height-4)];
    
    if (indexPath.row == 0) {
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set1"];
        title.text = @"账户设置";
    }
    else if (indexPath.row == 1){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set2"];
        title.text = @"密码设置";
    }
    else if (indexPath.row ==2){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set3"];
        title.text = @"我的测评";
    }
    else if (indexPath.row == 3){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set4"];
        title.text = @"咨询指引";
    }
    else if (indexPath.row == 4){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set5"];
        title.text = @"我的收藏";
    }
    else if (indexPath.row == 5){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set6"];
        title.text = @"关      于";
    }
    
    [cell.contentView  addSubview:imgview];
    [cell.contentView addSubview:title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        PersonalInfoVC *personal = [[PersonalInfoVC alloc]init];
        personal.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personal animated:YES];
    }
    else if(indexPath.row == 3){
        QueryVC *query = [[QueryVC alloc]init];
        query.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:query animated:YES];
    }
    else if (indexPath.row == 5){
        AboutusVC *about = [[AboutusVC alloc]init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.row == 1){
        AlertPwdViewController *changepwd = [[AlertPwdViewController alloc]init];
        changepwd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changepwd animated:YES];
    }
    
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
