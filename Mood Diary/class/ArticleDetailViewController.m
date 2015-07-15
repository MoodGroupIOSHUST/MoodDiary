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
#import "UMSocial.h"
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
@synthesize digest;
@synthesize likenumelabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataModel = [[DataModel alloc]init];
    [self initWebView];
    
    socialData = [[UMSocialData alloc] initWithIdentifier:[NSString stringWithFormat:@"%@%@",_url,_thumbnailURL]];
    socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
    
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
        
        likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 40, 40)];
        UIImage *tempImage1 = [UIImage imageNamed:@"likeButton.png"];
        
        [likeButton setImage:[UIImage imageNamed:@"like_unselected"] forState:UIControlStateNormal];
        [likeButton setImage:tempImage1 forState:UIControlStateSelected];

        [likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:likeButton];
        
        likenumelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        [likeButton addSubview:likenumelabel];
        likenumelabel.adjustsFontSizeToFitWidth = YES;
        likenumelabel.backgroundColor = [UIColor clearColor];
        likenumelabel.textColor = [UIColor whiteColor];
        likenumelabel.textAlignment = NSTextAlignmentCenter;
        
        
        [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
            // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
            NSInteger likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
            likenumelabel.text = [NSString stringWithFormat:@"%ld",(long)likeNumber];
            NSLog(@"likeNum is %ld",(long)likeNumber);
        }];
        
        islike = socialData.isLike;
        
        if (islike) {
            likeButton.selected = YES;
        }
        else{
            likeButton.selected = NO;
        }
        
        
        
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
    
    //把你的文章或者音乐的标识，作为@"identifier"
    
    islike = socialData.isLike;
    
    if (islike) {
        likeButton.selected = NO;
    }
    else{
        likeButton.selected = YES;
    }
    
    [socialDataService postAddLikeOrCancelWithCompletion:^(UMSocialResponseEntity *response){
        //获取请求结果
        NSLog(@"resposne is %@",response);
    }];
    
    [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
        // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
        NSInteger likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
        likenumelabel.text = [NSString stringWithFormat:@"%ld",(long)likeNumber];
        NSLog(@"likeNum is %ld",(long)likeNumber);
    }];
    
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
    NSArray *sharearr = [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,nil];

    NSData * data = [NSData dataWithContentsOfURL:_thumbnailURL];
    
    //设置点击分享内容跳转链接qq
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@",_url];
    
    //设置点击分享内容跳转链接qq空间
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"%@",_url];
    
    //设置分享标题qq
    [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:@"%@",_titleString];
    
    //设置分享标题qq空间
    [UMSocialData defaultData].extConfig.qzoneData.title = [NSString stringWithFormat:@"%@",_titleString];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:[NSString stringWithFormat:@"%@  (分享自心情日记iOS客户端) %@",digest,_url]
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:sharearr
                                       delegate:self];
    

    //        [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"2091897557"}];
    

            [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[@"2091897557"] completion:nil];

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
