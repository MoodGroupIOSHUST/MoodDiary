//
//  WallTableviewcellTableViewCell.m
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "WallTableviewcellTableViewCell.h"

@implementation WallTableviewcellTableViewCell

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        namelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 25)];
        
        img = [[UIImageView alloc]initWithFrame:CGRectMake(220, 10, 30, 25)];
        img.backgroundColor = [UIColor clearColor];
        
        contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, namelabel.frame.origin.y+namelabel.frame.size.height+10, SCREEN_WIDTH-25, 40)];
        contentlabel.lineBreakMode = NSLineBreakByCharWrapping;
        contentlabel.numberOfLines = 0;
        contentlabel.font = [UIFont systemFontOfSize:16];
        contentlabel.backgroundColor = [UIColor clearColor];
        
        //
        timelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 200, 25)];
        timelabel.font = [UIFont systemFontOfSize:14];
        
        _commentbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-120-10, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30)];
        _commentbtn.backgroundColor = [UIColor whiteColor];
        [_commentbtn setTitleColor:[UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:0.5] forState:UIControlStateNormal];
        [_commentbtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentbtn setImageEdgeInsets:UIEdgeInsetsMake(5,15,5,15)];
        
        _favouritebtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-60, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30)];
        _favouritebtn.backgroundColor = [UIColor whiteColor];
        [_favouritebtn setTitleColor:[UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:0.5] forState:UIControlStateNormal];
        [_favouritebtn setImage:[UIImage imageNamed:@"favourite"] forState:UIControlStateNormal];
        [_favouritebtn setImageEdgeInsets:UIEdgeInsetsMake(5,17,5,17)];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-5, SCREEN_WIDTH, 5)];
        line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:line];
        
        commentline = [[UIView alloc]init];
        commentline.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        commentview  =[[UIView alloc]initWithFrame:CGRectMake(20, timelabel.frame.origin.y+timelabel.frame.size.height+10, SCREEN_WIDTH-30, 16)];
        
        
        
        [self addSubview:timelabel];
        [self addSubview:_commentbtn];
        [self addSubview:_favouritebtn];
        
        [self addSubview:namelabel];
        [self addSubview:img];
        [self addSubview:contentlabel];
        [self addSubview:commentview];
    }
    return self;
}

- (void)setcontent:(NSDictionary *)sender commentarr:(NSMutableArray *)arr height:(CGFloat )height more:(BOOL)more number:(NSInteger) index{
    NSDictionary *accountdic = [NSDictionary dictionaryWithDictionary:[sender objectForKeyedSubscript:@"account"]];
    
    //昵称
    if ([accountdic objectForKey:@"nickname"] == nil) {
        namelabel.text = @"";
    }
    else
    {
        namelabel.text = [accountdic objectForKey:@"nickname"];
    }
    
    CGSize namesize = [self maxlabeisize:CGSizeMake(999, 25) fontsize:14 text:[accountdic objectForKey:@"nickname"]];
    namelabel.frame = CGRectMake(15, 10, namesize.width, 25);
    namelabel.font = [UIFont systemFontOfSize:14];
    img.frame = CGRectMake(namelabel.frame.origin.x+10+namelabel.frame.size.width, 10, 30, 25);
    
    //性别
    NSString *sex;
    sex = [NSString stringWithFormat:@"%@",[accountdic objectForKey:@"sex"]];
    if ([sex isEqualToString:@"1"]) {
        img.image = [UIImage imageNamed:@"male"];
    }
    else if ([sex isEqualToString:@"0"]){
        img.image = [UIImage imageNamed:@"female"];
    }
    else
    {
        img.image = nil;
    }
    
    //内容
    NSString *content = [sender objectForKey:@"content"];
    CGSize contentsize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-20, 999) fontsize:16 text:content];
    contentlabel.frame = CGRectMake(15, namelabel.frame.origin.y+namelabel.frame.size.height+10, SCREEN_WIDTH-20, contentsize.height);
    contentlabel.font = [UIFont systemFontOfSize:16];
    contentlabel.text = content;
    
    //时间
    timelabel.text = [sender objectForKey:@"date"];
    timelabel.frame = CGRectMake(15, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 200, 25);
    
    //评论
    [_commentbtn setTitle:[NSString stringWithFormat:@"%@",[sender objectForKey:@"commentCount"]] forState:UIControlStateNormal];
    _commentbtn.frame = CGRectMake(SCREEN_WIDTH-10-120-10, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30);
    
    //点赞
    [_favouritebtn setTitle:[NSString stringWithFormat:@"%@",[sender objectForKey:@"favourCount"]] forState:UIControlStateNormal];
    _favouritebtn.frame = CGRectMake(SCREEN_WIDTH-15-60, contentlabel.frame.origin.y+contentlabel.frame.size.height+10, 60, 30);
    
    //评论
    if (arr == nil) {
        //没有评论
        [commentview removeFromSuperview];
        [commentline removeFromSuperview];
        line.frame = CGRectMake(0, _commentbtn.frame.origin.y+_commentbtn.frame.size.height+5, SCREEN_WIDTH, 10);
    }
    else
    {
        //有评论
        
        for (UIView *view in commentview.subviews) {
            [view removeFromSuperview];
        }
        
        commentview.frame = CGRectMake(20, timelabel.frame.origin.y+timelabel.frame.size.height+5, SCREEN_WIDTH-30, height);
        CGFloat btnheight = 2;
        for (int i= 0; i<arr.count; i++) {
            NSDictionary *commentdic = [arr objectAtIndex:i];
            
            NSString *content = [commentdic objectForKey:@"content"];
            NSString *date = [commentdic objectForKey:@"date"];
            
            CGSize commentsize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-45, 999) fontsize:14 text:content];
            
            UILabel *contentlb = [[UILabel alloc]initWithFrame:CGRectMake(35, btnheight, SCREEN_WIDTH-30-35, commentsize.height+8)];
            contentlb.text = content;
            contentlb.font = [UIFont systemFontOfSize:14];
            contentlb.textAlignment = NSTextAlignmentLeft;
            contentlb.textColor = [UIColor darkGrayColor];
            contentlb.textAlignment = NSTextAlignmentLeft;
            contentlb.numberOfLines=0;
            contentlb.lineBreakMode = NSLineBreakByWordWrapping;
            contentlb.backgroundColor = [UIColor clearColor];
            [commentview addSubview:contentlb];
            
            UILabel *datelabel = [[UILabel alloc]initWithFrame:CGRectMake(35, contentlb.frame.origin.y+contentlb.frame.size.height-2, SCREEN_WIDTH-30, 12)];
            datelabel.text = date;
            datelabel.font = [UIFont systemFontOfSize:12];
            datelabel.textAlignment = NSTextAlignmentLeft;
            datelabel.textColor = [UIColor darkGrayColor];
            datelabel.textAlignment = NSTextAlignmentLeft;
            [commentview addSubview:datelabel];
            
            UIImageView *imgpic = [[UIImageView alloc]initWithFrame:CGRectMake(0, btnheight+4, 30, 30)];
            imgpic.backgroundColor = [UIColor greenColor];
            imgpic.layer.masksToBounds = YES;
            imgpic.layer.cornerRadius = imgpic.bounds.size.height/2;
            [commentview addSubview:imgpic];

            
#pragma mark - 此处修改评论间距
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnheight, SCREEN_WIDTH-30, commentsize.height+20)];
#pragma mark - 此处修改评论间距
            btnheight = btnheight+commentsize.height+2+20;
            btn.tag = i + index*100;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
            [commentview addSubview:btn];
        }
        
        [self addSubview:commentview];
        
        commentline.frame = CGRectMake(20, timelabel.frame.origin.y+timelabel.frame.size.height+4, SCREEN_WIDTH-30, 1);
        [self addSubview:commentline];
#pragma mark - 此处修改评论间距
        line.frame = CGRectMake(0, commentview.frame.origin.y+commentview.frame.size.height+15, SCREEN_WIDTH, 10);
    }
    
    
}

- (void)btnclicked:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if ([self.delegate respondsToSelector:@selector(subcommentbtnclicked:)]) {
        [_delegate subcommentbtnclicked:sender];
    }
}

//自适应文字
-(CGSize)maxlabeisize:(CGSize)labelsize fontsize:(NSInteger)fontsize text:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:labelsize lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
