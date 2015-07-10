    //
//  ArticleDetailViewController.m
//  Mood Diary
//
//  Created by 王振辉 on 15/7/4.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "DataModel.h"
#import "ArticleDetail.h"
@interface ArticleDetailViewController (){
    UIWebView *webView;
    NSInteger lastPosition;
    UIView *buttonView;
    UIButton *likeButton;
    UIButton *shareButton;
    UIButton *collectButton;
    BOOL buttonFlag;
    DataModel *_dataModel;
}

@end

@implementation ArticleDetailViewController
@synthesize frameheight;

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataModel = [[DataModel alloc]init];
    [self initWebView];
    
}

- (void)initWebView{
    
    self.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, frameheight)];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    webView.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    buttonFlag = NO;
}

- (void)setButton{
    if (buttonFlag == 0) {
        buttonView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120 -5, frameheight+upsideheight-50, 120, 40)];
        buttonView.backgroundColor = [UIColor clearColor];
        
        likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImage *tempImage1 = [UIImage imageNamed:@"likeButton.png"];
        UIImageView *tempImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [tempImageView1 setImage:tempImage1];
        [likeButton addSubview:tempImageView1];
        [likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:likeButton];
        
        collectButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, 40, 40)];
        UIImage  *tempImage2 = [UIImage imageNamed:@"collectButton.png"];
        UIImageView *tempImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 40)];
        [tempImageView2 setImage:tempImage2];
        [collectButton addSubview:tempImageView2];
        [collectButton addTarget:self action:@selector(collectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:collectButton];
        
        
        shareButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 40, 40)];
        UIImage  *tempImage3 = [UIImage imageNamed:@"shareButton.png"];
        UIImageView *tempImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 40, 40)];
        [tempImageView3 setImage:tempImage3];
        [shareButton addSubview:tempImageView3];
        [shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:shareButton];
        
        [self.view addSubview:buttonView];
    }else{
        [buttonView removeFromSuperview];
    }
    buttonFlag = !buttonFlag;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPosition = webView.scrollView.contentOffset.y;
    if (currentPosition - lastPosition >25) {
        if (buttonFlag == 1) {
            [self setButton];
        }
        lastPosition = currentPosition;
    }else if( lastPosition - currentPosition >25 ){
        if (buttonFlag == 0) {
            [self setButton];
        }
        lastPosition = currentPosition;
    }
}

#pragma mark - ButtonTapped
- (void)likeButtonTapped:(id)sender{
    NSLog(@"likeButtonTapped");
}

- (void)collectButtonTapped:(id)sender{
    NSLog(@"collectButtonTapped");
    ArticleDetail *articlDetail = [[ArticleDetail alloc]init];
    articlDetail.thumbnailURL = _thumbnailURL;
    articlDetail.titleString = _titleString;
    articlDetail.dateString = _dateString;
    articlDetail.articleURL = _url;
    articlDetail.IDString = _IDString;
    BOOL flag;
    flag = [_dataModel addObject:articlDetail];
    if (flag == 1) {
        [self.view showResult:ResultViewTypeOK text:@"收藏成功"];
        NSLog(@"已收藏");
    }else{
        NSLog(@"已取消收藏");
        [self.view showResult:ResultViewTypeOK text:@"取消收藏"];
    }
    [_dataModel saveArticles];
}

- (void)shareButtonTapped:(id)sender{
    NSLog(@"shareButtonTapped");
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
