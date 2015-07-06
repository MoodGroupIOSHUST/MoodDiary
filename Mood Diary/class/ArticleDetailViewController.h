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
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *titleString;
@end
