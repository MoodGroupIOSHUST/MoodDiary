//
//  TestVC.h
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface TestVC : RootViewController<UIAlertViewDelegate>
{
    NSMutableArray *choicearr;
    UILabel *questionlable;
    UIBarButtonItem *left;
    UIBarButtonItem *right;
    UIButton *answerBt;
    BOOL isover;
    NSMutableArray *btarr;
    NSDate *last;
    NSDate *now;

}

@property(nonatomic,assign) BOOL hasdone;

@end
