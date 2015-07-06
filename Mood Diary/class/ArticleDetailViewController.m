//
//  ArticleDetailViewController.m
//  Mood Diary
//
//  Created by 王振辉 on 15/7/4.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface ArticleDetailViewController (){
    UIScrollView *scrollerView;
    UIImageView *imageView;
    UITextView *textView;
    NSInteger lastPosition;
    UIView *buttonView;
    UIButton *likeButton;
    UIButton *shareButton;
    UIButton *collectButton;
    BOOL buttonFlag;
}

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollView];
}

- (void)initScrollView{
    
    self.view.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:222.0/255.0 blue:221.0/255.0 alpha:1.0];
    self.title = self.titleString;
    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20, SCREEN_HEIGHT-44 - 64)];
    scrollerView.backgroundColor = [UIColor clearColor];
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:196.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 20 -10, 200)];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT*5)];
    
    if (self.url == nil) {
        
        imageView.image = nil;
        imageView.frame = CGRectMake(5, 10, SCREEN_WIDTH-20-10, 5);
    }else{
        
        [imageView sd_setImageWithURL:self.url placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            imageView.frame = CGRectMake(5, 10, SCREEN_WIDTH-20-10, (SCREEN_WIDTH-20-10)*image.size.height/image.size.width);
            
            textView.frame = CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+10, SCREEN_WIDTH-20, SCREEN_HEIGHT*5);
            
            CGSize sizeFrame =[textView.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, 10000) lineBreakMode:NSLineBreakByWordWrapping];
            
            textView.frame = CGRectMake(0, textView.frame.origin.y, SCREEN_WIDTH-20, sizeFrame.height +10);
            
            CGSize size = scrollerView.contentSize;
            size.height = imageView.bounds.size.height + textView.bounds.size.height + 40;
            scrollerView.contentSize = size;
            
        }];
    }
    
    [scrollerView addSubview:imageView];
    
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:17];
    textView.editable = NO;
    textView.text = _text;
    
    CGSize sizeFrame =[textView.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
    textView.frame = CGRectMake(0, textView.frame.origin.y, SCREEN_WIDTH-20, sizeFrame.height +10);
    textView.scrollEnabled = NO;
    [scrollerView addSubview:textView];
    
    [self.view addSubview:scrollerView];
    
    CGSize size = scrollerView.contentSize;
    size.height = imageView.bounds.size.height + textView.bounds.size.height + 40;
    scrollerView.contentSize = size;
    self.automaticallyAdjustsScrollViewInsets = NO;
    buttonFlag = NO;
    
}

- (void)setButton{
    if (buttonFlag == 0) {
        buttonView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120 -5, SCREEN_HEIGHT-44-55, 120, 40)];
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
    NSInteger currentPosition = scrollerView.contentOffset.y;
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
