//
//  liveVC.h
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveItem;
@interface liveVC : UIViewController

@property(nonatomic,strong)LiveItem *live;//直播对象
@property(nonatomic,strong)NSString *streamUrl;//直播流的地址

@end
