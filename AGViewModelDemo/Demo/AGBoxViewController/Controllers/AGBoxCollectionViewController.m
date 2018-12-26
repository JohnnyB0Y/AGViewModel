//
//  AGBoxCollectionViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBoxCollectionViewController.h"
#import "AGBoxDetailViewController.h"
#import "AGBoxVMGenerator.h"

@interface AGBoxCollectionViewController ()
<AGVMDelegate, UICollectionViewDelegateFlowLayout>

/** box generator */
@property (nonatomic, strong) AGBoxVMGenerator *boxVMGenerator;

@end

@implementation AGBoxCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🐒" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    
    // 注册 cell
    [AGBoxACell ag_registerCellBy:self.collectionView];
    [AGBoxBCell ag_registerCellBy:self.collectionView];
    [AGBoxCCell ag_registerCellBy:self.collectionView];
    
    
    // 监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewModelNoti:) name:kChangeViewModelNoti object:nil];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (UIViewController *)initWithViewModel:(AGViewModel *)vm
{
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:fl];
    if ( self ) {
        self.title = @"多彩盒子";
    }
    return self;
}

+ (instancetype)newWithViewModel:(AGViewModel *)vm
{
	return [[self alloc] initWithViewModel:vm];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.boxVMGenerator.boxVMManager.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.boxVMGenerator.boxVMManager[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AGViewModel *vm =
    self.boxVMGenerator.boxVMManager[indexPath.section][indexPath.row];
    
    Class<AGCollectionCellReusable> cellClass = vm[kAGVMViewClass];
    UICollectionViewCell<AGVMIncludable> *cell = [cellClass ag_dequeueCellBy:collectionView for:indexPath];
    
    [cell setViewModel:vm];
    [vm ag_setBindingView:cell];
    [vm ag_setDelegate:self forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AGViewModel *vm =
    self.boxVMGenerator.boxVMManager[indexPath.section][indexPath.row];
    
    CGSize cellS = [vm ag_sizeOfBindingView];
    if ( cellS.height <= 0 || cellS.width <= 0) {
        // 这里 cell的类型是随机生成的，处理比较麻烦。也可以在 vm generator 时，计算好 cell的 size。
        UIView<AGVMIncludable> *view;
        Class<AGCollectionCellReusable> cellClass = vm[kAGVMViewClass];
        if ( cellClass == [AGBoxACell class] ) {
            view = [AGBoxACell ag_createFromNib];
        }
        else if ( cellClass == [AGBoxBCell class] ) {
            view = [AGBoxBCell ag_createFromNib];
        }
        else if ( cellClass == [AGBoxCCell class] ) {
            view = [AGBoxCCell ag_createFromNib];
        }
        cellS = [vm ag_sizeForBindingView:view];
    }
    return cellS;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(34., 4., 34., 4.);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中
    AGViewModel *vm = self.boxVMGenerator.boxVMManager[indexPath.section][indexPath.row];
    AGBoxDetailViewController *vc = [AGBoxDetailViewController newWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---------- Event Methods ----------
- (void) rightBarButtonItemClick:(UIBarButtonItem *)item
{
    static BOOL selected = 0;
    selected = ! selected;
    
    AGVMManager *boxVMManager = self.boxVMGenerator.boxVMManager;
    
    [boxVMManager ag_enumerateSectionItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSIndexPath * _Nonnull indexPath, BOOL * _Nonnull stop) {
        
        // 所有 Class A 选中猴子
        Class cellClass = vm[kAGVMViewClass];
        if ( cellClass == [AGBoxACell class] ) {
            //
            [vm ag_refreshUIByUpdateModelInBlock:^(NSMutableDictionary *bm) {
                bm[kAGBoxACellSegmentedControlSelectedIndex] = @( selected );
            }];
            
            NSLog(@"indexPath : %ld - %ld", (long)indexPath.section, (long)indexPath.item);
        }
        
    }];
}

- (void) changeViewModelNoti:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    Class selectedCellClass = dict[kAGVMViewClass];
    UIColor *selectedCellColor = dict[kAGVMBoxColor];
    
    AGVMManager *boxVMManager = self.boxVMGenerator.boxVMManager;
    
    [boxVMManager ag_enumerateSectionItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSIndexPath * _Nonnull indexPath, BOOL * _Nonnull stop) {
        
        // 改变对应类的颜色
        if ( vm[kAGVMViewClass] == selectedCellClass ) {
            // 选中类名的 cell
            [vm ag_refreshUIByUpdateModelInBlock:^(NSMutableDictionary *bm) {
                bm[kAGVMBoxColor] = selectedCellColor;
            }];
            
        }
        
    }];
    
    
}

#pragma mark - ----------- Getter Methods ----------
- (AGBoxVMGenerator *)boxVMGenerator
{
    if (_boxVMGenerator == nil) {
        _boxVMGenerator = [AGBoxVMGenerator new];
    }
    return _boxVMGenerator;
}

@end
