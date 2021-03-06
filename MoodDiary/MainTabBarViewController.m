//
//  MainTabBarViewController.m
//  iCity_CQ
//
//  Created by William Chen on 12-12-26.
//  Copyright (c) 2012年 whty. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "UserInfo.h"

@interface MainTabBarViewController () {
    NSMutableArray *tabButtons;
    NSMutableArray *tabTitles;
    NSMutableArray *tabBarConfigs;
}

@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tabButtons = [[NSMutableArray alloc] initWithCapacity:5];
    tabTitles = [[NSMutableArray alloc] initWithCapacity:5];
    
    
	NSString *path = [[NSBundle mainBundle]pathForResource: @"TabBarConfig" ofType: @"plist"];
    
    tabBarConfigs = [[NSMutableArray alloc] initWithContentsOfFile: path];
    
    [self initTabbarController];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews{
    
    //自定义标题时，返回至rootview标题会重叠
    
    [super viewWillLayoutSubviews];
    
    for (UIView *child in self.tabBar.subviews) {
        
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [child removeFromSuperview];
            
        }
        
    }
    
}

//- (void)viewWillAppear:(BOOL)animated
//
//{
//    
//    // 删除系统自动生成的UITabBarButton
//    
//    for (UIView *child in self.tabBar.subviews) {
//        
//        if ([child isKindOfClass:[UIControl class]]) {
//            
//            [child removeFromSuperview];
//            
//        }
//        
//    }
//    
//    [super viewWillAppear:animated];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabbarController{

	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	NSInteger cnt = [tabBarConfigs count];
   
	for (int i=0; i<cnt; i++) {
		NSDictionary *dict = [tabBarConfigs objectAtIndex: i];
		
		NSString *itemBarName = [dict objectForKey: @"name"];
		//UIImage *itemBarImage = [UIImage imageNamed:[dict objectForKey: @"img_nomal"]];
		NSString *controlString = [dict objectForKey: @"controller"];
		
		Class currentElement_Class = NSClassFromString(controlString);
		UIViewController *currentController = [[currentElement_Class alloc]init];

		UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController: currentController];
   
        if ( IS_IOS_7 )
        {
            //导航栏title的属性
            navControl.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil, nil,[UIFont systemFontOfSize:14], NSFontAttributeName, nil];
        }
        currentController.title = itemBarName;
        

		[controllers addObject: navControl];
		
	}
    
	self.viewControllers = controllers;
    
    self.delegate = self;
    
    [self customTabBar];
    //[self printSubviewInfo:self.tabBar format:@"    " fixed:@"    "];
    
    [self tabButtonAction:[tabButtons objectAtIndex:0]];
	
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //[self customTabBar];
    
    return YES;
}

- (void)makeTabBarHidden:(BOOL)hide{
	
	if([self.view.subviews count] < 2)
		return;
	
    UIView *contentView = nil;
	
	if([[self.view.subviews objectAtIndex: 0] isKindOfClass: [UITabBar class]])
		contentView = [self.view.subviews objectAtIndex: 1];
	else
		contentView = [self.view.subviews objectAtIndex: 0];
	
	if(hide){
		contentView.frame = self.view.bounds;
	}else{
		contentView.frame = CGRectMake(self.view.bounds.origin.x,
									   self.view.bounds.origin.y,
									   self.view.bounds.size.width,
									   self.view.bounds.size.height - self.tabBar.frame.size.height);
	}
	self.tabBar.hidden = hide;
}

- (void)printSubviewInfo:(UIView *)view format:(NSString *)format fixed:(NSString *)fixed{
	
	NSLog(@"%@>%@; CGRect:%@", format, NSStringFromClass([view class]), NSStringFromCGRect(view.frame));
	for (UIView *tv in [view subviews]) {
		[self printSubviewInfo: tv format: [format stringByAppendingString:fixed] fixed: fixed];
	}
}

- (void)customTabBar{

    UITabBar *tabbar = self.tabBar;
    tabbar.layer.borderWidth = 1;
    tabbar.layer.borderColor = [[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]CGColor];
    tabbar.layer.masksToBounds = YES;

    NSArray *views = [tabbar subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    
    CGFloat btWidth = (SCREEN_WIDTH-49*4)/8.0;
    
//    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    for (int i=0; i<tabBarConfigs.count; i++) {
        NSDictionary *dict = [tabBarConfigs objectAtIndex: i];
//        NSString *itemBarName = [dict objectForKey: @"name"];
		UIImage *itemBarImage = [UIImage imageNamed:[dict objectForKey: @"img_nomal"]];
        UIImage *itemBarImage_selected = [UIImage imageNamed:[dict objectForKey: @"img_selected"]];
        
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame = CGRectMake(btWidth+i*(49+btWidth*2), 0, 49, 49);
        tabButton.tag = i;
        [tabButton setImage:itemBarImage forState:UIControlStateNormal];
        [tabButton setImage:itemBarImage_selected forState:UIControlStateSelected];
        //设置及button里面title和image的位置上左下右
//        [tabButton setImageEdgeInsets:UIEdgeInsetsMake(0,21.5,0,21.5)];
//        [tabButton setTitleEdgeInsets:UIEdgeInsetsMake(45,-86,20,12)];

        [tabButton addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //设置查询、周报权限
        
        [self.tabBar addSubview:tabButton];
        [tabButtons addObject:tabButton];
        
        tabButton.titleLabel.textColor = [UIColor clearColor];
//        [tabButton setTitle:[NSString stringWithFormat:@"%@",itemBarName] forState:UIControlStateNormal];
        
//        [tabButton setTitleColor:[UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0]forState:UIControlStateSelected];
//        [tabButton setTitleColor:[UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1] forState:UIControlStateNormal];
        tabButton.backgroundColor = [UIColor clearColor];
    }
    
}

- (void)tabButtonAction:(UIButton*)sender {
    for (UIButton *btn in tabButtons) {
        btn.selected = NO;
    }
    
    for (UILabel *view in tabTitles) {
        view.textColor = [UIColor whiteColor];
    }
//    UILabel *selectedLabel = [tabTitles objectAtIndex:sender.tag];
//    selectedLabel.textColor = MF_ColorFromRGB(18, 214, 254);
    sender.selected = YES;
    
    self.selectedIndex = sender.tag;
}

@end
