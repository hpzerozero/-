//
//  HPCollectionViewLayout.h
//  瀑布流练习
//
//  Created by hp on 2017/2/24.
//  Copyright © 2017年 hp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPCollectionViewFlowLayout;
@protocol HPCollectionViewFlowLayoutDelegate <NSObject>

@required
/**
 动态设置cell的高度

 @param collectionView 当前的collectionView
 @param collectionViewLayout 自定义的流式布局
 @param width cell的宽度
 @param indexPath 当前cell所在的位置
 @return 返回当前cell的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HPCollectionViewFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@optional
/** section header*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HPCollectionViewFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
/** section footer*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HPCollectionViewFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

//UICollectionViewFlowLayout
@interface HPCollectionViewFlowLayout : UICollectionViewLayout
/** 行间距*/
@property (assign, nonatomic) CGFloat rowSpace;
/** 列间距*/
@property (assign, nonatomic) CGFloat columnSpace;
/** 列数*/
@property (assign, nonatomic) int cellColumn;
/** 视图边界*/
@property (assign, nonatomic) UIEdgeInsets sectionEdgeInsets;
@property (weak, nonatomic) id<HPCollectionViewFlowLayoutDelegate> hpDelegate;
@end
