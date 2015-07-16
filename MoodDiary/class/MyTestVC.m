//
//  MyTestVC.m
//  Mood Diary
//
//  Created by Sunc on 15/7/10.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "MyTestVC.h"
#import "AdviceVC.h"

@interface MyTestVC ()

@property (nonatomic) CGFloat height;

@end

@implementation MyTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的测评";
    
    _height = 60;
    
    [self initsettable];
}

- (void)initsettable{
    mytesttableview = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    mytesttableview.delegate = self;
    mytesttableview.dataSource = self;
    mytesttableview.tableFooterView = [[UIView alloc]init];
    
    CGRect frame = mytesttableview.tableHeaderView.frame;
    frame.size.height = 25;
    
    [self.view addSubview:mytesttableview];
    
}

#pragma mark - uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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

    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 200, _height-4)];
    
    if (indexPath.row == 0) {
        title.text = @"5个小技巧战胜焦虑";
    }
    else if (indexPath.row == 1){
        title.text = @"如何克服焦虑（知乎）";
    }
    else if (indexPath.row ==2){
        title.text = @"抑郁二三事";
    }
    else if (indexPath.row == 3){
        title.text = @"走出抑郁";
    }
    
    [cell.contentView addSubview:title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        AdviceVC *advice = [[AdviceVC alloc]init];
        advice.advicetype = @"jiaolv5";
        
        [self.navigationController pushViewController:advice animated:YES];
    }
    else if(indexPath.row == 1){
        AdviceVC *advice = [[AdviceVC alloc]init];
        advice.advicetype = @"kefujiaolvzhihu";
        
        [self.navigationController pushViewController:advice animated:YES];
    }
    else if (indexPath.row == 2){
        AdviceVC *advice = [[AdviceVC alloc]init];
        advice.advicetype = @"yiyu23";
        
        [self.navigationController pushViewController:advice animated:YES];
    }
    else if (indexPath.row == 3){
        AdviceVC *advice = [[AdviceVC alloc]init];
        advice.advicetype = @"zouchuyiyu";
        
        [self.navigationController pushViewController:advice animated:YES];
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
