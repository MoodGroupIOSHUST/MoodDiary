//
//  ArticleDetailViewController.h
//  Mood Diary
//
//  Created by 王振辉 on 15/7/4.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface ArticleDetailViewController : RootViewController<UIScrollViewDelegate>{
        //UITextView *textView;
}
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, copy)NSString *dateString;
@property (nonatomic, copy)NSURL *thumbnailURL;
@property (nonatomic, copy)NSString *IDString;
@property (nonatomic)float frameheight;
@end
