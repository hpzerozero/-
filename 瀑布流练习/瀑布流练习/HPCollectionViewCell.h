//
//  HPCollectionViewCell.h
//  瀑布流练习
//
//  Created by hp on 2017/2/24.
//  Copyright © 2017年 hp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface HPCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setData:(DataModel *)model;
@end
