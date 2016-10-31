//
//  LiveItem.h
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CreatorItem;
@interface LiveItem : NSObject
@property (nonatomic,copy)NSString *city;           /*城市*/
@property (nonatomic,copy)NSString *share_addr;     /*分享的地址*/
@property (nonatomic,assign)NSInteger online_users; /*在线人数*/
@property(nonatomic,strong)NSString *stream_addr;   //直播流地址
@property(nonatomic,strong)CreatorItem *creator;    //主播

@end
