//
//  BroadListVC.m
//  MakerLive
//
//  Created by maker on 16/10/22.
//  Copyright © 2016年 maker. All rights reserved.
//

#import "BroadListVC.h"
#import "liveVC.h"
#import "LiveCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "LiveItem.h"
static NSString *const ID = @"cell";
@interface BroadListVC ()

@property(nonatomic,strong)NSMutableArray *lives;//直播的数组

@end

@implementation BroadListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播列表";
    
    //加载数据
    [self loadData];
}

#pragma mark   ==============请求数据==============
- (void)loadData
{
    //映客 URL
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    //AF
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/x-gzip", nil];
    [mgr GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _lives = [LiveItem mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        [self.tableView reloadData];
                  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lives.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.live = _lives[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    liveVC *live = [[liveVC alloc] init];
    live.live = _lives[indexPath.row];
    [self presentViewController:live animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}


@end
