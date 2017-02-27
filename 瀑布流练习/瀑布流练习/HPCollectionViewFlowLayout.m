//
//  HPCollectionViewLayout.m
//  瀑布流练习
//
//  Created by hp on 2017/2/24.
//  Copyright © 2017年 hp. All rights reserved.
//
#import "HPCollectionViewFlowLayout.h"

static CGFloat DEFAULTSPACE = 5.0f;
static int DEFAULTCOLUMN = 3;
@interface HPCollectionViewFlowLayout ()
/** 存储每一列最大Y值*/
@property (strong, nonatomic) NSMutableArray *columnMaxYs;
/** 存放所有cell的属性*/
@property (strong, nonatomic) NSMutableArray *cellAttrsArray;
@end

@implementation HPCollectionViewFlowLayout

#pragma mark - lazy load
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [NSMutableArray array];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)cellAttrsArray
{
    if (!_cellAttrsArray) {
        _cellAttrsArray = [NSMutableArray array];
    }
    return _cellAttrsArray;
}

/**
 -[HPCollectionViewFlowLayout prepareLayout]
 -[HPCollectionViewFlowLayout layoutAttributesForSupplementaryViewOfKind:atIndexPath:]
 -[HPCollectionViewFlowLayout layoutAttributesForItemAtIndexPath:]  // 多次调用
 -[HPCollectionViewFlowLayout layoutAttributesForSupplementaryViewOfKind:atIndexPath:]
 -[HPCollectionViewFlowLayout collectionViewContentSize]
 -[HPCollectionViewFlowLayout layoutAttributesForElementsInRect:]

 */

#pragma mark - 实现内部的方法
- (void)prepareLayout
{
    [super prepareLayout];
    NSLog(@"%s,line=%d",__FUNCTION__,__LINE__);
    // 设置默认值
    self.rowSpace = DEFAULTSPACE;
    self.columnSpace = DEFAULTSPACE;
    self.cellColumn = DEFAULTCOLUMN;
    self.sectionEdgeInsets = UIEdgeInsetsMake(DEFAULTSPACE, DEFAULTSPACE, DEFAULTSPACE, DEFAULTSPACE);
    
    // 重置每一列的最大值
    [self.columnMaxYs removeAllObjects];
    for (int column=0; column < self.cellColumn ; column++) {
        [self.columnMaxYs addObject:@(DEFAULTSPACE)];
    }
    
    // 计算所有cell的布局属性
    for (int section=0; section<[self.collectionView numberOfSections]; section++) {
        // header
        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        [self.cellAttrsArray addObject:headerAttr];
        // cell
        for (int row=0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [self.cellAttrsArray addObject:attr ];
        }
        // footer
        UICollectionViewLayoutAttributes *footerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        [self.cellAttrsArray addObject:footerAttr];
    }
}

- (CGSize)collectionViewContentSize{
    NSLog(@"%s,line=%d",__FUNCTION__,__LINE__);
    CGFloat tmpMaxY = [self.columnMaxYs[0] doubleValue];
    for (int index=0; index<self.columnMaxYs.count; index++) {
        CGFloat columnMaxY = [self.columnMaxYs[index] doubleValue];
        if (columnMaxY > tmpMaxY) {
            tmpMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, tmpMaxY + self.columnSpace);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%s,line=%d",__FUNCTION__,__LINE__);
    return self.cellAttrsArray;
}
// 说明cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s,line=%d",__FUNCTION__,__LINE__);
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 计算indexPath位置cell的属性
    CGSize collectionViewSize = self.collectionView.frame.size;
    CGFloat cellWidth = (collectionViewSize.width - self.sectionEdgeInsets.left - self.sectionEdgeInsets.right - self.columnSpace * (self.cellColumn - 1)) / self.cellColumn;
    
    CGFloat cellHeight = 0;
    if ([self.hpDelegate respondsToSelector:@selector(collectionView:layout:heightForWidth:atIndexPath:)]) {
        cellHeight = [self.hpDelegate collectionView:self.collectionView layout:self heightForWidth:cellWidth atIndexPath:indexPath];
    }
    
    // 找出最短最短那一列的列号和最大Y值：下一个cell从最短列开始
    CGFloat tmpMaxY = [self.columnMaxYs[0] doubleValue];
    int shortColumn = 0;
    for (int index=0; index<self.columnMaxYs.count; index++) {
        CGFloat maxY = [self.columnMaxYs[index] doubleValue];
        if (tmpMaxY > maxY) {
            tmpMaxY = maxY;
            shortColumn = index;
        }
    }
    
    CGFloat cellX = self.sectionEdgeInsets.left + (self.columnSpace + cellWidth) * shortColumn;
    CGFloat cellY = tmpMaxY + self.columnSpace;
    // cell的frame
    attr.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
    // 更新数组中的最大值
    self.columnMaxYs[shortColumn] = @(CGRectGetMaxY(attr.frame));
    return attr;
}

// 说明段头段尾的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s,line=%d",__FUNCTION__,__LINE__);
    // 找出最大Y值那一列
    int maxColumn = 0;
    CGFloat tmpMaxY = [self.columnMaxYs[0] doubleValue];
    for (int index=0; index<self.columnMaxYs.count; index++) {
        CGFloat maxY = [self.columnMaxYs[index] doubleValue];
        if (tmpMaxY<maxY) {
            tmpMaxY = maxY;
            maxColumn = index;
        }
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        CGFloat headerX = self.sectionEdgeInsets.left;
        CGFloat headerY = [self.columnMaxYs[maxColumn] doubleValue] + self.sectionEdgeInsets.top;
        CGSize headerSize = CGSizeZero;
        if ([self.hpDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerSize = [self.hpDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        // 更新所有对应列的最大Y值
        for(int index=0; index<self.columnMaxYs.count; index++){
            self.columnMaxYs[index] = @(headerY + headerSize.height);
        }
        
        headerAttr.frame = CGRectMake(headerX, headerY, headerSize.width, headerSize.height);
        return headerAttr;
        
    } else {
        UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        CGFloat footerX = self.sectionEdgeInsets.left;
        CGFloat footerY = [self.columnMaxYs[maxColumn] doubleValue];
        CGSize footerSize = CGSizeZero;
        if ([self.hpDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerSize = [self.hpDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }
        // 更新所有对应列的最大Y值
        for(int index=0; index<self.columnMaxYs.count; index++){
            self.columnMaxYs[index] = @(footerY + footerSize.height + self.sectionEdgeInsets.bottom);
        }
        footerAttr.frame = CGRectMake(footerX, footerY, footerSize.width, footerSize.height);
        return footerAttr;
    }
}



@end
