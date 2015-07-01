//
//  MoodWallVC.m
//  Mood Diary
//
//  Created by 王振辉 on 15/6/24.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "MoodWallVC.h"

@interface MoodWallVC (){
    CGFloat height;
}

@end

@implementation MoodWallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"心情日记"];
    height = 44;
    [self initTableView];
}

- (void)initTableView{
    MoodWalltableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    MoodWalltableView.delegate = self;
    MoodWalltableView.dataSource = self;
    MoodWalltableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:MoodWalltableView];
}

#pragma mark - UITableViewDataSource
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
    return height;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer = @"wall";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UILabel *colorCircle = [[UILabel alloc]initWithFrame:CGRectMake(15, height/4, height/2, height/2)];
    colorCircle.layer.cornerRadius = colorCircle.bounds.size.height/2;
    colorCircle.layer.masksToBounds = YES;
    colorCircle.backgroundColor = [UIColor blackColor];
    [cell addSubview:colorCircle];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(colorCircle.frame.origin.x + colorCircle.frame.size.width+10, 14, tableView.bounds.size.width - colorCircle.frame.origin.x - colorCircle.frame.size.width-40-80, 16)];
    title.text = @"1234567890123456789012345678901234567890";
    title.font = [UIFont systemFontOfSize:16];
    [cell addSubview:title];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x + title.bounds.size.width+10, 14, 70, 16)];
    time.text = @"15/06/15";
    [cell addSubview:time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected");
    
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
