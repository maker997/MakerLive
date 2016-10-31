//
//  LiveCell.m
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import "LiveCell.h"
#import "LiveItem.h"
#import "CreatorItem.h"
#import <UIImageView+WebCache.h>
@interface LiveCell()
@property(nonatomic,strong)UIImageView *icon;//头像
@property(nonatomic,strong)UIImageView *bigImage;//头像
@property(nonatomic,strong)UILabel *lblNickName;//昵称
@property(nonatomic,strong)UILabel *lbLcity;//城市
@property(nonatomic,strong)UILabel *lblOnline;//在线用户数字
@end
@implementation LiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    return self;
}

//创建 UI
- (void)setup
{
    //头像
    CGFloat margin = 10;
    _icon = [[UIImageView alloc] init];
    [self addSubview:_icon];
    _icon.frame = CGRectMake(margin, margin, 60, 60);
    [_icon.layer setMasksToBounds:YES];
    [_icon.layer setCornerRadius:3];
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    [_icon setClipsToBounds:YES];
    
    // 昵称
    _lblNickName = [[UILabel alloc] init];
    [self addSubview:_lblNickName];
    _lblNickName.frame = CGRectMake(_icon.right +margin, _icon.y, 150, 30);
    _lblNickName.textColor = Color(206, 206, 206);
    
    //城市
    _lbLcity = [[UILabel alloc] init];
    [self addSubview:_lbLcity];
    _lbLcity.frame = CGRectMake(_lblNickName.x, _lblNickName.bottom, 150, 30);
    _lbLcity.textColor = Color(206, 206, 206);
    
    //在线人数
    _lblOnline = [[UILabel alloc] init];
    [self addSubview:_lblOnline];
    _lblOnline.frame = CGRectMake(screenWidth -150 -margin, (80-30)/2, 150, 30);
    _lblOnline.textAlignment = NSTextAlignmentRight;
    
    //大图片
    _bigImage = [[UIImageView alloc] init];
    [self addSubview:_bigImage];
    _bigImage.frame = CGRectMake(0, _icon.bottom +margin, screenWidth, 350);
    _bigImage.contentMode = UIViewContentModeScaleAspectFill;
    [_bigImage setClipsToBounds:YES];
}
- (void)setLive:(LiveItem *)live{
    _live = live;
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",live.creator.portrait]];
    
    [self.icon sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    if (live.city.length == 0) {
        self.lbLcity.text = @"难道在火星?";
    }else{
        self.lbLcity.text = live.city;
    }
    
    self.lblNickName.text = live.creator.nick;
    [self.bigImage sd_setImageWithURL:imageUrl placeholderImage:nil];
    
     NSString *fullChaoyang = [NSString stringWithFormat:@"%zd人在看", live.online_users];
     NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%zd", live.online_users]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:Color(216, 41, 116) range:range];
    self.lblOnline.attributedText = attr;
}
@end







