//
//  ViewController.m
//  瀑布流练习
//
//  Created by hp on 2017/2/24.
//  Copyright © 2017年 hp. All rights reserved.
//

#import "ViewController.h"
#import "HPCollectionViewFlowLayout.h"
#import "HPCollectionViewCell.h"
#import "HPCollectionHeaderView.h"
#import "HPCollectionFooterView.h"
#import "DataModel.h"
#import "HPViewModel.h"
static NSString *cellIdentifier = @"HPCell";
static NSString *headerIdentifier = @"HPHeader";
static NSString *footerIdentifier = @"HPFooter";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, HPCollectionViewFlowLayoutDelegate>

@property(strong, nonatomic) IBOutlet UICollectionView *hpCollectionView;
/** viewModel*/
@property (strong, nonatomic) HPViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationView];
    self.viewModel = [[HPViewModel alloc] init];
    [self.viewModel getData];
    [self.hpCollectionView reloadData];
    
}


- (void)configurationView{
    
    self.hpCollectionView.delegate = self;
    self.hpCollectionView.dataSource = self;
    // 初始化流式布局
    HPCollectionViewFlowLayout *fl = [[HPCollectionViewFlowLayout alloc] init];
    fl.columnSpace = 5;
    fl.cellColumn = 3;
    fl.sectionEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.hpCollectionView.collectionViewLayout = fl;
    fl.hpDelegate = self;
    [self.hpCollectionView registerNib:[UINib nibWithNibName:@"HPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.hpCollectionView registerNib:[UINib nibWithNibName:@"HPCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.hpCollectionView registerNib:[UINib nibWithNibName:@"HPCollectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return self.viewModel.dataArray.count;
//    [self.hpCollectionView.collectionViewLayout invalidateLayout];
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.viewModel.dataArray[section];
    return arr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    DataModel *model = self.viewModel.dataArray[indexPath.section][indexPath.row];
    [cell setData:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HPCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        [headerView.titleLabel setText:@"精品推荐"];
        return headerView;
    } else {
        HPCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        [footerView.loadBtn addTarget:self action:@selector(loadMoreInfo) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - HPCollectionViewFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HPCollectionViewFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = self.viewModel.dataArray[indexPath.section][indexPath.row];
    
    return model.h / model.w * width;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HPCollectionViewFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width - 20, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HPCollectionViewFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width - 20, 30);
}
- (void)loadMoreInfo
{
    [self.viewModel getMoreData];
    @try {
        
        [self.hpCollectionView reloadData];
//        [self.hpCollectionView.collectionViewLayout invalidateLayout];
    } @catch (NSException *exception) {
        NSLog(@"%s,line=%d, %@",__FUNCTION__,__LINE__, exception);
    } @finally {
        
    }
}
@end
