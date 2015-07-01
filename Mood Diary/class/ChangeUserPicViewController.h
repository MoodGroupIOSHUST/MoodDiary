//
//  ChangeUserPicViewController.h
//  inteLook
//
//  Created by Sunc on 15-3-4.
//  Copyright (c) 2015年 whtysf. All rights reserved.
//

#import "RootViewController.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"

@interface ChangeUserPicViewController : RootViewController<UIAlertViewDelegate>
{
    UIButton *changeBt;
    UserInfo *userInfo;
    UIImage *picImage;
}

@property(retain,nonatomic)UIImageView *oldUserImg;

@end
