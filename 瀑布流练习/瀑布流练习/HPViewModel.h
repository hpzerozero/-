//
//  HPViewModel.h
//  瀑布流练习
//
//  Created by hp on 2017/2/25.
//  Copyright © 2017年 hp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPViewModel : NSObject
/** data*/
@property (strong, nonatomic) NSMutableArray *dataArray;
/** title*/
@property (strong, nonatomic) NSArray *nameArray;
/** 获取数据*/
- (void)getData;
/** 获取更多数据*/
- (void)getMoreData;
@end
