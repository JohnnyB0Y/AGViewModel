//
//  AGSwitchControl.m
//
//
//  Created by JohnnyB0Y on 2017/4/9.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  分段切换控制视图

#import "AGSwitchControl.h"

@interface AGSwitchCollectionView ()
/** 开始滚动的.x坐标偏移量 */
@property (nonatomic, assign) CGFloat startScrollOffsetX;
/** 当前选中的item */
@property (nonatomic, strong) UICollectionViewCell *currentItem;
@property (nonatomic, assign) NSInteger currentItemIndex;
/** 想移动到的item */
@property (nonatomic, strong) UICollectionViewCell *nextItem;
@property (nonatomic, assign) NSInteger nextItemIndex;
@end

@interface AGSwitchControl ()
<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AGSwitchControlSettable>

@property (nonatomic, strong) UIView *headerContainer;
@property (nonatomic, strong) UIView *footerContainer;
@property (nonatomic, strong) UIView *leftContainer;
@property (nonatomic, strong) UIView *rightContainer;
@property (nonatomic, strong) UIView *underlineContainer;

@property (nonatomic, strong) AGSwitchCollectionView *titleSwitchView;

@property (nonatomic, strong) AGSwitchCollectionView *detailSwitchView;

@property (nonatomic, weak) id<AGSwitchControlDelegate> delegate;
@property (nonatomic, weak) id<AGSwitchControlDataSource> dataSource;

@property (nonatomic, assign) CGFloat titleSwitchViewH;
@property (nonatomic, assign) CGFloat underlineBottomMargin;

@property (nonatomic, assign) BOOL titleAnimation;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL canMoveToNextItem; // 可以跳到下一个 item 吗？

@end

@implementation AGSwitchControl {
    CGRect _underlineOriginFrame; // 下划线上一次的位置信息
    CGSize _underlineStretchSize; // 下划线拉伸Size
    
    /** -1，需要刷新; 1，刷新中; 0, 完成刷新 */
    NSInteger _reloadFirst;
    
    CGFloat _beginDraggingX; // 开始拖拽的位置原始
    BOOL _isDragging; // 是否还在拖拽
    
    AGSwitchControlNextItemDirection _nextItemDirection;
}

#pragma mark - Init Methods
- (instancetype)initWithSettableBlock:(NS_NOESCAPE AGSwitchControlSetupSwitchControlBlock)block
{
    self = [super init];
    if ( nil == self ) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    _reloadFirst = -1;
    _titleAnimation = NO;
    _nextItemDirection = AGSwitchControlNextItemDirectionUnkonw;
    _beginDraggingX = -1;
    
    if ( block ) {
        block(self);
    }
    return self;
}

#pragma mark - ---------- Public Methods ----------
#pragma mark 添加视图
- (void) ag_setupHeaderViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block
{
    if ( block ) {
        self.headerContainer.size = block(self.headerContainer);
    }
}

- (void) ag_setupFooterViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block
{
    if ( block ) {
        self.footerContainer.size = block(self.footerContainer);
    }
}

- (void) ag_setupLeftViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block
{
    if ( block ) {
        self.leftContainer.size = block(self.leftContainer);
    }
}

- (void) ag_setupRightViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block
{
    if ( block ) {
        self.rightContainer.size = block(self.rightContainer);
    }
}

- (void)ag_setupUnderlineViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block
{
    if ( block ) {
        self.underlineContainer.size = block(self.underlineContainer);
        CGSize size = self.underlineContainer.size;
        _underlineOriginFrame = CGRectMake(0, 0, size.width, size.height);
    }
}

- (void) ag_setupTitleCollectionViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupCollectionViewBlock)block
{
    if ( block ) {
        block(self.titleSwitchView);
    }
}

- (void) ag_setupDetailCollectionViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupCollectionViewBlock)block
{
    if ( block ) {
        block(self.detailSwitchView);
    }
}

- (void) ag_reloadData
{
    // ...
//    [_detailCollectionView.collectionViewLayout invalidateLayout];
//    //[_detailCollectionView.collectionViewLayout prepareLayout];
//    [self setNeedsLayout];
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self ag_clickAtIndex:self.currentIndex];
//        [_detailCollectionView reloadData];
//    });
    
    
}

- (void)ag_clickAtIndex:(NSInteger)idx
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
    [self collectionView:self.titleSwitchView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - ----------- Override Methods -----------
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self _layoutEdgeSubView];
    
    // 默认选中
    if ( _reloadFirst == -1 ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ag_clickAtIndex:self.currentIndex];
        });
        _reloadFirst = 1;
    }
}

#pragma mark UICollectionViewDataSource <NSObject>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource ag_numberOfItemInSwitchControl:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<AGVMResponsive> *cell;
    if ( collectionView == _titleSwitchView ) {
        // 标题
        AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:indexPath.row];
        Class<AGCollectionCellReusable> cellClass = vm[kAGVMViewClass];
        
        if ( cellClass ) {
            cell = [cellClass ag_dequeueCellBy:collectionView for:indexPath];
        }
        else {
            cell = [AGSwitchControlItem ag_dequeueCellBy:collectionView for:indexPath];
        }
        cell.tag = indexPath.row;
        [cell setViewModel:vm];
        vm.setBindingView(cell);
    }
    else if ( collectionView == _detailSwitchView ) {
        // 详情
        cell = [UICollectionViewCell ag_dequeueCellBy:collectionView for:indexPath];
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView
        willDisplayCell:(UICollectionViewCell *)cell
     forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( collectionView == _detailSwitchView ) {
        // rm old view
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // add new view
        UIView *newView = [self.dataSource ag_switchControl:self viewForDetailItemAtIndex:indexPath.row];
        [cell.contentView addSubview:newView];
        newView.frame = cell.contentView.frame;
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( collectionView == _titleSwitchView ) {
        AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:indexPath.row];
        CGSize size = [vm ag_sizeOfBindingView];
        size.height = floor(collectionView.height);
        return size;
    }
    else if ( collectionView == _detailSwitchView ) {
        return CGSizeMake(floor(collectionView.width), floor(collectionView.height));
    }
    return CGSizeZero;
}

- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( collectionView == _titleSwitchView ) {
        
        AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:indexPath.row];
        UICollectionViewCell *toItem = (UICollectionViewCell *)vm.bindingView;
        UICollectionViewCell *fromItem = self.titleSwitchView.currentItem;
        
        // 相同不通知
        if ( fromItem == toItem ) {
            return;
        }
        
        self.titleSwitchView.nextItemIndex = indexPath.row;
        self.titleSwitchView.nextItem = toItem;
        // click call
        if ( [self.delegate respondsToSelector:@selector(ag_switchControl:clickTitleItemAtIndex:)] ) {
            [self.delegate ag_switchControl:self clickTitleItemAtIndex:indexPath.row];
        }
        
        // 让标签滚动
        if ( [self.dataSource respondsToSelector:@selector(ag_switchControl:animationWithTitleItem:toItem:)] ) {
            // 自定义动画
            [self.dataSource ag_switchControl:self animationWithTitleItem:self.titleSwitchView.currentItem toItem:toItem];
        }
        else {
            // 动画
            BOOL yesOrNo = self.titleAnimation;
            if ( _reloadFirst == 1 ) {
                yesOrNo = NO;
                _reloadFirst = 0;
            }
            [self _scrollTitleItem:fromItem toItem:toItem animation:yesOrNo];
            [_detailSwitchView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        // 记录
        self.titleSwitchView.currentItem = toItem;
    }
}

#pragma mark - ---------- UIScrollViewDelegate ----------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( scrollView == _detailSwitchView ) {
        
        _isDragging = YES;
        _beginDraggingX = scrollView.contentOffset.x;
        
        if ( [self.delegate respondsToSelector:@selector(ag_switchControl:scrollViewWillBeginDraggingAtIndex:)] ) {
            [self.delegate ag_switchControl:self scrollViewWillBeginDraggingAtIndex:self.currentIndex];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ( scrollView == _detailSwitchView ) {
        _isDragging = NO;
        // 判断能否跳到下一 item
        if ( self.canMoveToNextItem ) {
             // click call
            if ( [self.delegate respondsToSelector:@selector(ag_switchControl:clickTitleItemAtIndex:)] ) {
                [self.delegate ag_switchControl:self clickTitleItemAtIndex:self.titleSwitchView.nextItemIndex];
            }
            
            // 去到新的位置
            [self _scrollTitleItem:self.titleSwitchView.currentItem toItem:self.titleSwitchView.nextItem animation:self.titleAnimation];
            
            // 内容视图去到下一页
            CGFloat x = self.titleSwitchView.nextItemIndex * scrollView.width;
            CGFloat y = scrollView.y;
            *targetContentOffset = CGPointMake(x, y);
        }
        else {
            // 内容视图回到原来的位置
            CGFloat x = self.titleSwitchView.currentItemIndex * scrollView.width;
            CGFloat y = scrollView.y;
            *targetContentOffset = CGPointMake(x, y);
            
            _nextItemDirection = AGSwitchControlNextItemDirectionUnkonw;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.underlineContainer.hidden = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 动画完成
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView == _detailSwitchView ) {
        
        // 0. 手指位移
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat fingerOffsetX = _beginDraggingX - offsetX;
        
        // offset 超出边界
        self.canMoveToNextItem = NO;
        if ( offsetX < 0 || offsetX > scrollView.contentSize.width - scrollView.width ) {
            //NSLog(@"Out of range.");
            return;
        }
        
        // 1. 判断是下划线往什么方向拉伸
        if ( fingerOffsetX < 0 ) {
            //NSLog(@"连接右边的 item !!!!!!!!!!!!!!");
            if ( _nextItemDirection != AGSwitchControlNextItemDirectionRight ) {
                _nextItemDirection = AGSwitchControlNextItemDirectionRight;
                
                // 方向改变才计算
                AGViewModel *vm = [self _getRightItemModelWithIndex:self.currentIndex];
                if ( nil == vm ) return;
                
                self.titleSwitchView.nextItem = (AGSwitchControlItem *)vm.bindingView;
                self.titleSwitchView.nextItemIndex = self.currentIndex + 1;
                // 记录下划线拉伸Size
                CGFloat stretchWidth = ([vm ag_sizeOfBindingView].width + self.titleSwitchView.currentItem.width + _underlineOriginFrame.size.width) * 0.5;
                _underlineStretchSize = CGSizeMake(stretchWidth, 0);
                
            }
        }
        else {
            //NSLog(@"连接左边的 item --------");
            if ( _nextItemDirection != AGSwitchControlNextItemDirectionLeft ) {
                _nextItemDirection = AGSwitchControlNextItemDirectionLeft;
                
                // 方向改变才计算
                AGViewModel *vm = [self _getLeftItemModelWithIndex:self.currentIndex];
                if ( nil == vm ) return;
                
                self.titleSwitchView.nextItem = (AGSwitchControlItem *)vm.bindingView;
                self.titleSwitchView.nextItemIndex = self.currentIndex - 1;
                // 记录下划线拉伸Size
                CGFloat stretchWidth = ([vm ag_sizeOfBindingView].width + self.titleSwitchView.currentItem.width + _underlineOriginFrame.size.width) * 0.5;
                _underlineStretchSize = CGSizeMake(stretchWidth, 0);
            }
        }
        
        CGFloat width = scrollView.bounds.size.width;
        CGFloat ratio = fabs(fingerOffsetX) / (width * 0.10); // 宽度拉伸控制%
        ratio = ratio < 1 ? ratio : 1; // 限制比例最大为 1
        CGFloat newWidth = ratio * _underlineStretchSize.width;
        
        //NSLog(@"ratio : %.2f width: %.1f", ratio, newWidth);
        if ( newWidth >= _underlineStretchSize.width ) {
            newWidth = _underlineStretchSize.width; // 最大
            if ( self.titleSwitchView.currentItem != self.titleSwitchView.nextItem ) {
                self.canMoveToNextItem = YES;
            }
        }
        else if ( newWidth < _underlineOriginFrame.size.width ) {
            newWidth = _underlineOriginFrame.size.width; // 最小
        }
        
        // 长度变化通知
        [self underlineWithChangeNotice:newWidth limit:self.canMoveToNextItem ratio:ratio];
        
    }
}

#pragma mark - ---------- Event Methods ----------
- (void) underlineWithChangeNotice:(CGFloat)newWidth limit:(BOOL)yesOrNo ratio:(CGFloat)ratio
{
    if ( self.underlineContainer.hidden && _isDragging ) {
        // 在恰当的时候显示
        self.underlineContainer.hidden = NO;
    }
    
    self.underlineContainer.width = newWidth; // set width
    if ( _nextItemDirection == AGSwitchControlNextItemDirectionRight ) {
        self.underlineContainer.x = _underlineOriginFrame.origin.x;
        
    }
    else if ( _nextItemDirection == AGSwitchControlNextItemDirectionLeft ) {
        self.underlineContainer.x = _underlineOriginFrame.origin.x - newWidth + _underlineOriginFrame.size.width;
    }
    
    if ( self.underlineContainer.hidden == NO ) {
        // 1.05 ~ 1.25
        CGFloat maxScale = ratio / 5. + 1.05;
        // 1.25 ~ 1.05
        CGFloat minScale = 1.25 - ratio / 5.;
        
        self.titleSwitchView.nextItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, maxScale, maxScale);
        self.titleSwitchView.currentItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, minScale, minScale);
    }
    
}

#pragma mark - ---------- Private Methods ----------
- (void) _layoutEdgeSubView
{
    CGFloat height = 0;
    CGFloat width = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat nextViewY = 0; // 下一个视图的y
    
    // header
    if ( _headerContainer ) {
        _headerContainer.frame = CGRectMake(x, y, self.width, _headerContainer.height);
        nextViewY = _headerContainer.height; // +1
    }
    
    // left right
    if ( _leftContainer ) {
        width = _leftContainer.width;
        _leftContainer.frame = CGRectMake(0, nextViewY, width, self.titleSwitchViewH);
    }
    
    if ( _rightContainer ) {
        x = self.width - _rightContainer.width;
        width = _rightContainer.width;
        _rightContainer.frame = CGRectMake(x, nextViewY, width, self.titleSwitchViewH);
    }
    
    // item scroll view
    x = _leftContainer.width;
    width = self.width - _leftContainer.width - _rightContainer.width;
    _titleSwitchView.frame = CGRectMake(x, nextViewY, width, self.titleSwitchViewH);
    nextViewY += self.titleSwitchViewH; // +2
    
    
    // underline
    CGSize underlineSize = _underlineOriginFrame.size;
    if ( underlineSize.width <= 0 ) {
        underlineSize = CGSizeMake(16., 5.);
    }
    CGFloat underlineY = nextViewY - underlineSize.height - self.underlineBottomMargin;
    CGFloat underlineX = _underlineOriginFrame.origin.x;
    _underlineOriginFrame = CGRectMake(underlineX, underlineY, underlineSize.width, underlineSize.height);
    self.underlineContainer.frame = _underlineOriginFrame;
    
    // footer
    if ( _footerContainer ) {
        height = _footerContainer.height;
        _footerContainer.frame = CGRectMake(0, nextViewY, self.width, height);
        nextViewY += _footerContainer.height; // +3
    }
    
    // detail scroll view
    if ( _detailSwitchView ) {
        width = self.width;
        height = self.height - nextViewY;
        _detailSwitchView.frame = CGRectMake(0, nextViewY, width, height);
        
    }
}

- (void) _scrollTitleItem:(UICollectionViewCell *)fromItem toItem:(UICollectionViewCell *)toItem animation:(BOOL)yesOrNo
{
    [_titleSwitchView ag_moveToNextItemWithDirection:_nextItemDirection withAnimation:^(AGSwitchControl *switchControl, AGSwitchCollectionView *animateView) {
        
        if ( yesOrNo ) {
            [UIView animateWithDuration:0.35 animations:^{
                if ( animateView.needsToScroll ) {
                    [animateView setContentOffset:CGPointMake(animateView.needsScrollOffsetX, 0)];
                }
            }];
        }
        else {
            if ( animateView.needsToScroll ) {
                [animateView setContentOffset:CGPointMake(animateView.needsScrollOffsetX, 0)];
            }
        }
    }];
    
    // 下划线
    CGFloat underlineY = _underlineOriginFrame.origin.y;
    CGFloat underlineW = _underlineOriginFrame.size.width;
    CGFloat underlineH = _underlineOriginFrame.size.height;
    CGFloat underlineX = self.titleSwitchView.nextItemRect.origin.x + (toItem.width - underlineW) * 0.5;
    _underlineOriginFrame = CGRectMake(underlineX, underlineY, underlineW, underlineH);
    
    if ( yesOrNo ) {
        // 有动画
        NSTimeInterval animateDuration = 0.35;
        
        self.underlineContainer.width = self->_underlineOriginFrame.size.width;
        self.underlineContainer.x = underlineX;
        
        if ( [fromItem isKindOfClass:[AGSwitchControlItem class]] ) {
            AGSwitchControlItem *item = (AGSwitchControlItem *)fromItem;
            item.underline.hidden = YES;
        }
        
        [UIView animateWithDuration:animateDuration animations:^{
            fromItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            
        }];
        
        [UIView animateWithDuration:animateDuration animations:^{
            toItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        }];
        
        
        if ( [toItem isKindOfClass:[AGSwitchControlItem class]] ) {
            AGSwitchControlItem *item = (AGSwitchControlItem *)toItem;
            item.underline.hidden = NO;
            item.underlineBottomMargin = self.underlineBottomMargin;
            item.underline.backgroundColor = self.underlineContainer.backgroundColor;
            item.underline.size = self->_underlineOriginFrame.size;
            [item makeUnderlineCenter];
        }
        
    }
    else {
        // 无动画
        self.underlineContainer.x = underlineX;
        self.underlineContainer.width = _underlineOriginFrame.size.width;
        toItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        fromItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        
        if ( [fromItem isKindOfClass:[AGSwitchControlItem class]] ) {
            AGSwitchControlItem *item = (AGSwitchControlItem *)fromItem;
            item.underline.hidden = YES;
        }
        
        if ( [toItem isKindOfClass:[AGSwitchControlItem class]] ) {
            AGSwitchControlItem *item = (AGSwitchControlItem *)toItem;
            item.underline.hidden = NO;
            item.underlineBottomMargin = self.underlineBottomMargin;
            item.underline.backgroundColor = self.underlineContainer.backgroundColor;
            item.underline.size = self->_underlineOriginFrame.size;
            [item makeUnderlineCenter];
        }
    }
    
    // 记录数据
    self.titleSwitchView.currentItem = self.titleSwitchView.nextItem;
    self.titleSwitchView.currentItemIndex = self.titleSwitchView.nextItemIndex;
    self.canMoveToNextItem = NO;
    self.underlineContainer.hidden = YES;
    _nextItemDirection = AGSwitchControlNextItemDirectionUnkonw;
}

- (AGViewModel *) _getCurrentItemModelWithIndex:(NSInteger)index
{
    return [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:index];
}
- (AGViewModel *) _getLeftItemModelWithIndex:(NSInteger)index
{
    NSInteger toIndex = index - 1;
    if ( toIndex < 0 ) {
        return nil;
    }
    return [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:toIndex];
}
- (AGViewModel *) _getRightItemModelWithIndex:(NSInteger)index
{
    NSInteger toIndex = index + 1;
    if ( toIndex > [self.dataSource ag_numberOfItemInSwitchControl:self] - 1 ) {
        return nil;
    }
    return [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:toIndex];
}

- (void) _underlineAnimationToLeft
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    animation.duration = 1.0f;
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
//    [self.layer addAnimation:animation forKey:@"positionAnimation"];
}

#pragma mark - ----------- Getter Methods ----------
- (UIView *)headerContainer
{
    if (_headerContainer == nil) {
        _headerContainer = [UIView new];
        [self addSubview:_headerContainer];
    }
    return _headerContainer;
}

- (UIView *)footerContainer
{
    if (_footerContainer == nil) {
        _footerContainer = [UIView new];
        [self addSubview:_footerContainer];
    }
    return _footerContainer;
}

- (UIView *)leftContainer
{
    if (_leftContainer == nil) {
        _leftContainer = [UIView new];
        [self addSubview:_leftContainer];
    }
    return _leftContainer;
}

- (UIView *)rightContainer
{
    if (_rightContainer == nil) {
        _rightContainer = [UIView new];
        [self addSubview:_rightContainer];
    }
    return _rightContainer;
}

- (UIView *)underlineContainer
{
    if (_underlineContainer == nil) {
        _underlineContainer = [UIView new];
        [self addSubview:_underlineContainer];
        _underlineContainer.backgroundColor = [UIColor blackColor];
    }
    return _underlineContainer;
}

- (AGSwitchCollectionView *)titleSwitchView
{
    if (_titleSwitchView == nil) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumInteritemSpacing = 0.;
        fl.minimumLineSpacing = 0.;
        _titleSwitchView = [[AGSwitchCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _titleSwitchView.backgroundColor = [UIColor whiteColor];
        _titleSwitchView.showsHorizontalScrollIndicator = NO;
        _titleSwitchView.delegate = self;
        _titleSwitchView.dataSource = self;
        
        [AGSwitchControlItem ag_registerCellBy:_titleSwitchView];
    }
    return _titleSwitchView;
}

- (AGSwitchCollectionView *)detailSwitchView
{
    if (_detailSwitchView == nil) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumInteritemSpacing = 0.;
        fl.minimumLineSpacing = 0.;
        _detailSwitchView = [[AGSwitchCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _detailSwitchView.backgroundColor = [UIColor whiteColor];
        _detailSwitchView.showsHorizontalScrollIndicator = NO;
        _detailSwitchView.bounces = YES;
        _detailSwitchView.delegate = self;
        _detailSwitchView.decelerationRate = 0.3;
        _detailSwitchView.dataSource = self;
        _detailSwitchView.alwaysBounceHorizontal = YES;
        if (@available(iOS 11.0, *)) {
            _detailSwitchView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        [UICollectionViewCell ag_registerCellBy:_detailSwitchView];
    }
    return _detailSwitchView;
}

- (NSInteger)currentIndex
{
    return self.titleSwitchView.currentItemIndex;
}

- (CGFloat)startScrollOffsetX
{
    return self.titleSwitchView.startScrollOffsetX;
}

#pragma mark - ----------- Setter Methods ----------
- (void)setDataSource:(id<AGSwitchControlDataSource>)dataSource
{
    _dataSource = dataSource;
    if ([self.dataSource respondsToSelector:@selector(ag_numberOfItemInSwitchControl:)] &&
        [self.dataSource respondsToSelector:@selector(ag_switchControl:viewModelForTitleItemAtIndex:)] ) {
        [self addSubview:self.titleSwitchView];
        
        if ( [self.dataSource respondsToSelector:@selector(ag_switchControl:viewForDetailItemAtIndex:)] ) {
            [self addSubview:self.detailSwitchView];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    self.titleSwitchView.currentItemIndex = currentIndex;
}

- (void)setStartScrollOffsetX:(CGFloat)startScrollOffsetX
{
    self.titleSwitchView.startScrollOffsetX = startScrollOffsetX;
}

@end


@implementation AGSwitchCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if ( nil == self ) return nil;
    
    _currentItemIndex = 0;
    _startScrollOffsetX = 120.;
    
    return self;
}

- (void) ag_moveToNextItemWithDirection:(AGSwitchControlNextItemDirection)direction
                          withAnimation:(AGSwitchControlAnimationBlock)block
{
    CGFloat toItemX = self.nextItem.x;
    CGFloat contentW = self.contentSize.width; // 内容滚动宽度
    CGFloat stopX = contentW - self.width + self.startScrollOffsetX; // 止步偏移
    CGFloat originOffsetX = self.contentOffset.x; // 原来的滚动距离
    CGFloat needsScrollOffsetX = 0; // 最终的滚动距离
    CGFloat moveOffsetX = 0; // 动画后相对偏移
    self->_needsToScroll = YES;
    if ( direction == AGSwitchControlNextItemDirectionLeft ) { // item move to left
        if (  toItemX < stopX ) {
            // 小于一定距离才偏移
            if ( toItemX > self.startScrollOffsetX ) {
                needsScrollOffsetX = toItemX - self.startScrollOffsetX;
                moveOffsetX = originOffsetX - needsScrollOffsetX;
            }
            else { // near first item
                // 停止滚动前，移动一小段距离。
                moveOffsetX = originOffsetX - needsScrollOffsetX;
                if ( moveOffsetX < 0 ) {
                    moveOffsetX = 0;
                }
            }
        }
        else {
            // 固定偏移位置，不移动了。
            self->_needsToScroll = NO;
        }
    }
    else { // item move to right
        if ( toItemX > self.startScrollOffsetX ) {
            // 大于一定距离才偏移
            if ( toItemX > stopX ) {
                // 停止滚动前，移动一小段距离。
                needsScrollOffsetX = stopX - self.startScrollOffsetX;
                moveOffsetX = originOffsetX - needsScrollOffsetX;
                if ( moveOffsetX > 0 ) {
                    moveOffsetX = 0;
                }
            }
            else {
                needsScrollOffsetX = toItemX - self.startScrollOffsetX;
                moveOffsetX = originOffsetX - needsScrollOffsetX;
            }
        }
        else {
            // 固定偏移位置，不移动了。
            self->_needsToScroll = NO;
        }
    }
    
    self->_currentItemRect = [self _rectInView:self.superview withItem:self.currentItem moveOffsetX:0.];
    self->_nextItemRect = [self _rectInView:self.superview withItem:self.nextItem moveOffsetX:moveOffsetX];
    self->_needsScrollOffsetX = needsScrollOffsetX;
    
    if ( block ) {
        block((AGSwitchControl *)self.superview, self);
    }
}

- (CGRect) _rectInView:(UIView *)inView withItem:(UICollectionViewCell *)item moveOffsetX:(CGFloat)offsetX
{
    CGRect newF = CGRectMake(item.x + offsetX, item.y, item.width, item.height);
    CGRect itemRectInCollection = [self convertRect:newF toView:self];
    return [self convertRect:itemRectInCollection toView:inView];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
