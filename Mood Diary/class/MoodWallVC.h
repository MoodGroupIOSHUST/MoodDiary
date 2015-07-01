//
//  MoodWallVC.h
//  Mood Diary
//
//  Created by 王振辉 on 15/6/24.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface MoodWallVC : RootViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *MoodWalltableView;
}

@end
