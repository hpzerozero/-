//
//  DataModel.h
//  瀑布流练习
//
//  Created by hp on 2017/2/25.
//  Copyright © 2017年 hp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataModel : NSObject
@property (copy,   nonatomic) NSString *img;
/** price*/
@property (copy, nonatomic) NSString *price;
/** width*/
@property (assign, nonatomic) CGFloat w;
/** height*/
@property (assign, nonatomic) CGFloat h;
@end
