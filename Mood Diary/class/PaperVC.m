//
//  PaperVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "PaperVC.h"
#import "ArticleDetailViewController.h"
#import "AppWebService.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface PaperVC (){
    CGFloat height;
    NSMutableArray *articleArray;
    NSInteger numbersOfRow;
    //NSInteger selectedRowOfIndexPath;
    UIWebView *webView;
}

@end

@implementation PaperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    height = 100;
    
    self.title = @"美文";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    [self initArticle];

}


- (void)initArticle{
    
    articleTableView.userInteractionEnabled = NO;
    [self.view showProgress:YES text:@"获取美文..."];
    
    [AppWebService articleListWithStart:@"0" limit:@"10" success:^(id result) {
        NSDictionary *tempdata  = [result objectForKey:@"data"];
        articleArray = [[NSMutableArray alloc]initWithArray:[tempdata objectForKey:@"acticles"]]; //这里接口有拼写错误
        numbersOfRow = [articleArray count];
        [self.view showProgress:NO];
        [articleTableView.header endRefreshing];
        [articleTableView reloadData];
        articleTableView.userInteractionEnabled = YES;
        
    } failed:^(NSError *error) {
        NSLog(@"fail");
        [self.view showProgress:NO];
        articleTableView.userInteractionEnabled = YES;
        
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [articleTableView.header endRefreshing];
    }];
}

- (void)getmoredata{
    
    NSInteger count = [articleArray count];
    NSString *string = [[NSString alloc]initWithFormat:@"%ld",(long)count];
    
    [AppWebService articleListWithStart:string limit:@"10" success:^(id result) {
        NSDictionary *tempdata  = [result objectForKey:@"data"];
        NSMutableArray *articleArray2 = [[NSMutableArray alloc]initWithArray:[tempdata objectForKey:@"acticles"]]; //这里接口有拼写错误
        for (NSDictionary *dic in articleArray2) {
            [articleArray addObject:dic];
        }
        numbersOfRow = [articleArray count];
        
        [articleTableView.footer endRefreshing];
        [articleTableView reloadData];
        
    } failed:^(NSError *error) {
        NSLog(@"fail");
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [articleTableView.footer endRefreshing];
    }];
}

- (void)initTableView{
    NSLog(@"0");
    
    articleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49-upsideheight)];
    articleTableView.delegate = self;
    articleTableView.dataSource = self;
    articleTableView.tableFooterView = [[UIView alloc]init];
    articleTableView.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];
    [articleTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    articleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载和下拉刷新
    [articleTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(initArticle)];
    [articleTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getmoredata)];
    
    CGRect frame = articleTableView.tableHeaderView.frame;
    frame.size.height = 25;
    [self.view addSubview:articleTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numbersOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"article";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self setElementInCell:cell atIndexPath:indexPath];
    }
        [self configElementInCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = articleArray[indexPath.row];
    ArticleDetailViewController *articleDetailViewController = [[ArticleDetailViewController alloc]init];
    NSString *tempString = [dic objectForKey:@"url"];
    tempString = [@"http://etotech.net:8080" stringByAppendingString:tempString];
    articleDetailViewController.url = [NSURL URLWithString:tempString];
    articleDetailViewController.titleString = [dic objectForKey:@"title"];
    articleDetailViewController.dateString = [dic objectForKey:@"date"];
    articleDetailViewController.frameheight = SCREEN_HEIGHT-upsideheight-49;
    
    if(![[dic objectForKey:@"photo"] isEqual: [NSNull null]]){
        NSString *urlstring = [@"http://etotech.net:8080" stringByAppendingString:[dic objectForKey:@"photo"]];
        NSURL *url =[NSURL URLWithString:urlstring];
        articleDetailViewController.thumbnailURL = url;
    }else{
        articleDetailViewController.thumbnailURL = nil;
    }

    articleDetailViewController.IDString = [dic objectForKey:@"id"];
    
    [self.navigationController pushViewController:articleDetailViewController animated:YES];
}


- (void)setElementInCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = articleArray[indexPath.row];
    
    UIView *tempBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH-20, height-4 )];
    tempBackgroundView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:196.0/255.0 blue:235.0/255.0 alpha:1.0];
    [cell addSubview:tempBackgroundView];
    
   
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
    
    if(![[dic objectForKey:@"photo"] isEqual: [NSNull null]]){
        NSString *urlstring = [@"http://etotech.net:8080" stringByAppendingString:[dic objectForKey:@"photo"]];
        NSURL *url =[NSURL URLWithString:urlstring];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    }else{
        UIImage *image = [UIImage imageNamed:@"articleTest.png"];
        [imageView setImage:image];
    }
    imageView.tag = 30;
    [cell addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, SCREEN_WIDTH - 118 , 30)];
    title.tag = 31;
    title.text = [dic objectForKey:@"title"];
    [cell addSubview:title];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, SCREEN_WIDTH - 100, 30)];
    time.tag = 32;
    time.text = [dic objectForKey:@"date"];
    time.textColor = [UIColor grayColor];
    time.font = [UIFont systemFontOfSize:12];
    [cell addSubview:time];
    
    cell.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];
}

- (void)configElementInCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = articleArray[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:30];
    if(![[dic objectForKey:@"photo"] isEqual: [NSNull null]]){
        NSString *urlstring = [@"http://etotech.net:8080" stringByAppendingString:[dic objectForKey:@"photo"]];
        NSURL *url =[NSURL URLWithString:urlstring];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    }else{
        UIImage *image = [UIImage imageNamed:@"articleTest.png"];
        [imageView setImage:image];
    }
    
    
    UILabel *title = (UILabel *)[cell viewWithTag:31];
    title.text = [dic objectForKey:@"title"];
    UILabel *time  = (UILabel *)[cell viewWithTag:32];
    time.text = [dic objectForKey:@"date"];
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
