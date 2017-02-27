//
//  HPViewController.m
//  瀑布流练习
//
//  Created by hp on 2017/2/27.
//  Copyright © 2017年 hp. All rights reserved.
//

#import "HPViewController.h"
#import "HPCollectionViewCell.h"
#import "HPCollectionHeaderView.h"
#import "HPCollectionFooterView.h"
#import "HPViewModel.h"
#import "DataModel.h"
static NSString *cellIdentifier = @"HPCell";
static NSString *headerIdentifier = @"HPHeader";
static NSString *footerIdentifier = @"HPFooter";
@interface HPViewController ()<UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) HPViewModel *viewModel;
@end

@implementation HPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationView];
    self.viewModel = [[HPViewModel alloc] init];
    [self.viewModel getData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    
}
//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    [self.hpCollectionView.collectionViewLayout invalidateLayout];
//}
- (void)configurationView{
    // 初始化流式布局
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 10;
    fl.minimumInteritemSpacing = 10;
    fl.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
    fl.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
//    fl.itemSize = CGSizeMake(80, 150);
    self.collectionView.collectionViewLayout = fl;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HPCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HPCollectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        return self.viewModel.dataArray.count;
    //    [self.hpCollectionView.collectionViewLayout invalidateLayout];
//    return 1;
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = self.viewModel.dataArray[indexPath.section][indexPath.row];
    return CGSizeMake(80, model.h/model.w*80);
}
- (void)loadMoreInfo
{
    [self.viewModel getMoreData];
    @try {
        
        [self.collectionView reloadData];
        //        [self.hpCollectionView.collectionViewLayout invalidateLayout];
    } @catch (NSException *exception) {
        NSLog(@"%s,line=%d, %@",__FUNCTION__,__LINE__, exception);
    } @finally {
        
    }
}
@end
