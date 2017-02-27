//
//  HPViewModel.m
//  瀑布流练习
//
//  Created by hp on 2017/2/25.
//  Copyright © 2017年 hp. All rights reserved.
//

#import "HPViewModel.h"
#import "DataModel.h"
#import "MJExtension.h"
@implementation HPViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.nameArray = [NSArray array];
    }
    return self;
}

- (void)getData
{
    NSArray *dataArray1 = [DataModel objectArrayWithFilename:@"1.plist"];
    NSArray *dataArray2 = [DataModel objectArrayWithFilename:@"2.plist"];
    NSArray *dataArray3 = [DataModel objectArrayWithFilename:@"3.plist"];
//    self.dataArray = [@[dataArray1, dataArray2, dataArray3] mutableCopy];
    [self.dataArray addObject:dataArray1];
    [self.dataArray addObject:dataArray2];
    [self.dataArray addObject:dataArray3];
    self.nameArray = @[@"1.plist", @"2.plist", @"3.plist"];
}
- (void)getMoreData
{
    NSArray *dataArray4 = [DataModel objectArrayWithFilename:@"4.plist"];
    NSMutableArray *tmpArray = [self.dataArray[0] mutableCopy];
    [tmpArray addObjectsFromArray:dataArray4];
    [self.dataArray replaceObjectAtIndex:0 withObject:tmpArray];
}
@end
