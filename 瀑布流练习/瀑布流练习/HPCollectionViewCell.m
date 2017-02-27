//
//  HPCollectionViewCell.m
//  瀑布流练习
//
//  Created by hp on 2017/2/24.
//  Copyright © 2017年 hp. All rights reserved.
//

#import "HPCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation HPCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setData:(DataModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self.priceLabel setText:model.price];
}
@end
