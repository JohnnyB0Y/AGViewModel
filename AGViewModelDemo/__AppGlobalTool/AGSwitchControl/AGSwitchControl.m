//
//  AGSwitchControl.m
//
//
//  Created by JohnnyB0Y on 2017/4/9.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  分段切换控制视图

#import "AGSwitchControl.h"
#import "AGSwitchControlItem.h"

@interface AGSwitchControl ()
<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AGSwitchControlSettable>

@property (nonatomic, strong) UIView *headerContainer;
@property (nonatomic, strong) UIView *footerContainer;
@property (nonatomic, strong) UIView *leftContainer;
@property (nonatomic, strong) UIView *rightContainer;
@property (nonatomic, strong) UIView *underlineContainer;

@property (nonatomic, strong) UICollectionView *titleCollectionView;

@property (nonatomic, strong) UICollectionView *detailCollectionView;

@property (nonatomic, weak) id<AGSwitchControlDelegate> delegate;
@property (nonatomic, weak) id<AGSwitchControlDataSource> dataSource;

@property (nonatomic, assign) CGFloat titleCollectionViewH;
@property (nonatomic, assign) CGFloat selectedOffsetX;
@property (nonatomic, assign) CGFloat underlineBottomMargin;

@property (nonatomic, assign) BOOL titleAnimation;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation AGSwitchControl {
	UICollectionViewCell *_currentItem; // 当前点击控件
    CGRect _originUnderlineFrame; // 下划线上一次的位置信息
    
    /** -1，需要刷新; 1，刷新中; 0, 完成刷新 */
    NSInteger _reloadFirst;
    
    CGFloat _beginScrollX; // 开始滚动的X点
    CGFloat _beginDraggingX; // 开始拖拽的位置原始
    CGSize _underlineStretchSize; // 下划线拉伸Size
    BOOL _isDragging; // 是否还在拖拽
    /** -1 未确定；0 向右滚动；1向左滚动；*/
    NSInteger _lastTimeScrollDirection;
    
    BOOL _isAnimationFinished; // 动画是否完成
    /** 是否滚动item到下一个位置 */
    BOOL _isScrollItemToIndex;
}

#pragma mark - Init Methods
- (instancetype)initWithSettableBlock:(NS_NOESCAPE AGSwitchControlSetupSwitchControlBlock)block
{
    self = [super init];
    if ( nil == self ) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    _currentIndex = 0;
    _reloadFirst = -1;
    _titleAnimation = NO;
    _selectedOffsetX = 100.;
    _lastTimeScrollDirection = -1;
    _beginDraggingX = -1;
    _isAnimationFinished = YES;
    
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
        _originUnderlineFrame = CGRectMake(0, 0, size.width, size.height);
    }
}

- (void) ag_setupTitleCollectionViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupCollectionViewBlock)block
{
    if ( block ) {
        block(self.titleCollectionView);
    }
}

- (void) ag_setupDetailCollectionViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupCollectionViewBlock)block
{
    if ( block ) {
        block(self.detailCollectionView);
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
    [self collectionView:self.titleCollectionView didSelectItemAtIndexPath:indexPath];
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
    UICollectionViewCell<AGVMIncludable> *cell;
    if ( collectionView == _titleCollectionView ) {
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
        [vm ag_setBindingView:cell];
    }
    else if ( collectionView == _detailCollectionView ) {
        // 详情
        cell = [UICollectionViewCell ag_dequeueCellBy:collectionView for:indexPath];
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView
        willDisplayCell:(UICollectionViewCell *)cell
     forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( collectionView == _detailCollectionView ) {
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
    if ( collectionView == _titleCollectionView ) {
        AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:indexPath.row];
        CGSize size = [vm ag_sizeOfBindingView];
        size.height = floor(collectionView.height);
        return size;
    }
    else if ( collectionView == _detailCollectionView ) {
        return CGSizeMake(floor(collectionView.width), floor(collectionView.height));
    }
    return CGSizeZero;
}

- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( collectionView == _titleCollectionView ) {
        
        AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:indexPath.row];
        AGSwitchControlItem *toItem = (AGSwitchControlItem *)vm.bindingView;
        AGSwitchControlItem *fromItem = (AGSwitchControlItem *)_currentItem;
        
        // 相同不通知
        if ( fromItem == toItem ) {
            return;
        }
        
        [_detailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        // click call
        self.currentIndex = indexPath.row;
        if ( [self.delegate respondsToSelector:@selector(ag_switchControl:clickTitleItemAtIndex:)] ) {
            [self.delegate ag_switchControl:self clickTitleItemAtIndex:indexPath.row];
        }
        
        _itemToLeft = indexPath.row < _currentItem.tag;
        // 让标签滚动
        if ( [self.dataSource respondsToSelector:@selector(ag_switchControl:animationWithTitleItem:toItem:)] ) {
            // 自定义动画
            [self.dataSource ag_switchControl:self animationWithTitleItem:fromItem toItem:toItem];
            
        }
        else {
            // 动画
            BOOL yesOrNo = self.titleAnimation;
            if ( _reloadFirst == 1 ) {
                yesOrNo = NO;
                _reloadFirst = 0;
            }
            [self _scrollTitleItem:fromItem toItem:toItem animation:yesOrNo];
            
        }
        // 记录
        _currentItem = toItem;
    }
}

#pragma mark - ---------- UIScrollViewDelegate ----------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( scrollView == _detailCollectionView ) {
        
        _beginScrollX = scrollView.contentOffset.x;
        _isDragging = YES;
        _beginDraggingX = scrollView.contentOffset.x;
        self.underlineContainer.hidden = NO;
        
        if ( [self.delegate respondsToSelector:@selector(ag_switchControl:scrollViewWillBeginDraggingAtIndex:)] ) {
            [self.delegate ag_switchControl:self scrollViewWillBeginDraggingAtIndex:self.currentIndex];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( scrollView == _detailCollectionView ) {
        _isDragging = NO;
        
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat width = scrollView.width;
        NSInteger index = offsetX / width;
        
        // 这里跳的话，scrollViewDidEndDecelerating 就不跳le
        _isScrollItemToIndex = [self _scrollItemToIndex:index withAnimation:self.titleAnimation];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView == _detailCollectionView ) {
        
        if ( _isAnimationFinished ) {
            // 动画完成且scroll view 不再滚动，隐藏下划线
            self.underlineContainer.hidden = YES;
        }
        
        if ( NO == _isScrollItemToIndex ) {
            CGFloat offsetX = scrollView.contentOffset.x;
            CGFloat width = scrollView.width;
            NSInteger index = offsetX / width;
            
            [self _scrollItemToIndex:index withAnimation:self.titleAnimation];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView == _detailCollectionView ) {
        // ...
        CGFloat offsetX = scrollView.contentOffset.x;
        
        if ( _beginScrollX - offsetX > 12. ) {
            _itemToLeft = YES;
            _beginScrollX = offsetX;
        }
        else if ( offsetX - _beginScrollX > 12. ) {
            _itemToLeft = NO;
            _beginScrollX = offsetX;
        }
        
        if ( _beginDraggingX < 0 ) {
            NSLog(@"_beginDraggingX == 0");
            return;
        }
        
        // 0. 手指位移
        CGFloat fingerOffsetX = _beginDraggingX - offsetX;
        
        // 1. 判断是下划线往什么方向拉伸
        if ( fingerOffsetX < 0 ) {
            // 滚向右边
            _lastTimeScrollDirection = 0;
            //NSLog(@"向右滚动!!!!!!!!!!!!!!");
            // 方向改变才计算
            AGSwitchControlItem *toItem = [self _getRightItemWithIndex:self.currentIndex];
            if ( nil == toItem ) {
                return;
            }
            // 记录下划线拉伸Size
            CGFloat stretchWidth = (toItem.width + _currentItem.width + _originUnderlineFrame.size.width) * 0.5;
            _underlineStretchSize = CGSizeMake(stretchWidth, 0);
        }
        else {
            // 滚向左边
            _lastTimeScrollDirection = 1;
            //NSLog(@"向左滚动------");
            // 方向改变才计算
            AGSwitchControlItem *toItem = [self _getLeftItemWithIndex:self.currentIndex];
            
            if ( nil == toItem ) {
                return;
            }
            
            // 记录下划线拉伸Size
            CGFloat stretchWidth = (toItem.width + _currentItem.width + _originUnderlineFrame.size.width) * 0.5;
            _underlineStretchSize = CGSizeMake(stretchWidth, 0);
        }
        
        CGFloat width = scrollView.bounds.size.width;
        CGFloat move = fabs(fingerOffsetX) / (width * 0.4); // 宽度拉伸控制%
        
        if ( _lastTimeScrollDirection == 0 ) {
            // 向右滚
            CGFloat newWidth = move * _underlineStretchSize.width;
            if ( newWidth > _underlineStretchSize.width ) {
                newWidth = _underlineStretchSize.width; // 最大
            }
            self.underlineContainer.width = newWidth;
            self.underlineContainer.x = _originUnderlineFrame.origin.x;
            
        }
        else if ( _lastTimeScrollDirection == 1 ) {
            // 向左滚
            CGFloat newWidth = move * _underlineStretchSize.width;
            if ( newWidth > _underlineStretchSize.width ) {
                newWidth = _underlineStretchSize.width; // 最大
            }
            self.underlineContainer.x = _originUnderlineFrame.origin.x - newWidth + _originUnderlineFrame.size.width;
            self.underlineContainer.width = newWidth;
        }
    }
}

#pragma mark - ---------- Event Methods ----------


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
        _leftContainer.frame = CGRectMake(0, nextViewY, width, self.titleCollectionViewH);
    }
    
    if ( _rightContainer ) {
        x = self.width - _rightContainer.width;
        width = _rightContainer.width;
        _rightContainer.frame = CGRectMake(x, nextViewY, width, self.titleCollectionViewH);
    }
    
    // item scroll view
    x = _leftContainer.width;
    width = self.width - _leftContainer.width - _rightContainer.width;
    _titleCollectionView.frame = CGRectMake(x, nextViewY, width, self.titleCollectionViewH);
    nextViewY += self.titleCollectionViewH; // +2
    
    
    // underline
    CGSize underlineSize = _originUnderlineFrame.size;
    if ( underlineSize.width <= 0 ) {
        underlineSize = CGSizeMake(16., 5.);
    }
    CGFloat underlineY = nextViewY - underlineSize.height - self.underlineBottomMargin;
    _originUnderlineFrame = CGRectMake(0, underlineY, underlineSize.width, underlineSize.height);
    self.underlineContainer.frame = _originUnderlineFrame;
    
    
    // footer
    if ( _footerContainer ) {
        height = _footerContainer.height;
        _footerContainer.frame = CGRectMake(0, nextViewY, self.width, height);
        nextViewY += _footerContainer.height; // +3
    }
    
    // detail scroll view
    if ( _detailCollectionView ) {
        width = self.width;
        height = self.height - nextViewY;
        _detailCollectionView.frame = CGRectMake(0, nextViewY, width, height);
        
    }
}

- (void) _scrollTitleItem:(UICollectionViewCell *)fromItem toItem:(UICollectionViewCell *)toItem animation:(BOOL)yesOrNo
{
    self.underlineContainer.hidden = NO;
    
    // 自带动画
    CGFloat toItemX = toItem.x;
    CGFloat contentW = _titleCollectionView.contentSize.width; // 内容滚动宽度
    CGFloat startX = _titleCollectionView.width * 0.5 - toItem.width * 0.5; // 起步偏移
    startX = self.selectedOffsetX;
    CGFloat stopX = contentW - _titleCollectionView.width + startX; // 止步偏移
    CGFloat originOffsetX = _titleCollectionView.contentOffset.x; // 原来的滚动距离
    CGFloat currentOffsetX = 0; // 最终的滚动距离
    CGFloat underlineOffsetX = 0; // 下划线相对偏移
    
    if ( _itemToLeft ) { // item move to left
        if (  toItemX < stopX ) {
            // 小于一定距离才偏移
            if ( toItemX > startX ) {
                currentOffsetX = toItemX - startX;
                underlineOffsetX = originOffsetX - currentOffsetX;
                CGPoint offset = CGPointMake(currentOffsetX, 0);
                [_titleCollectionView setContentOffset:offset animated:YES];
            }
            else { // near first item
                // 固定偏移位置，不移动了。
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [_titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                // 停止滚动前，移动一小段距离。
                underlineOffsetX = originOffsetX - currentOffsetX;
                if ( underlineOffsetX < 0 ) {
                    underlineOffsetX = 0;
                }
            }
        }
    }
    else { // item move to right
        if ( toItemX > startX ) {
            // 大于一定距离才偏移
            if ( toItemX > stopX ) {
                // 固定偏移位置，不移动了。
                currentOffsetX = stopX - startX;
                // 停止滚动前，移动一小段距离。
                underlineOffsetX = originOffsetX - currentOffsetX;
                if ( underlineOffsetX > 0 ) {
                    underlineOffsetX = 0;
                }
            }
            else {
                currentOffsetX = toItemX - startX;
                underlineOffsetX = originOffsetX - currentOffsetX;
            }
            
            CGPoint offset = CGPointMake(currentOffsetX, 0);
            [_titleCollectionView setContentOffset:offset animated:YES];
        }
    }
    
    // 下划线
    CGFloat underlineY = _originUnderlineFrame.origin.y;
    CGFloat underlineW = _originUnderlineFrame.size.width;
    CGFloat underlineH = _originUnderlineFrame.size.height;
    
    CGRect itemRectInCollection = [_titleCollectionView convertRect:toItem.frame toView:_titleCollectionView];
    CGRect itemRectInSwitchControl = [_titleCollectionView convertRect:itemRectInCollection toView:self];
    CGFloat underlineX = itemRectInSwitchControl.origin.x + (toItem.width - underlineW) * 0.5 + underlineOffsetX;
    _originUnderlineFrame = CGRectMake(underlineX, underlineY, underlineW, underlineH);
    
    if ( yesOrNo ) {
        // 有动画
        _isAnimationFinished = NO;
        NSTimeInterval animateDuration = 0.35;
        self.underlineContainer.x = underlineX;
        self.underlineContainer.width = self->_originUnderlineFrame.size.width;
        
        if ( [fromItem isKindOfClass:[AGSwitchControlItem class]] ) {
            AGSwitchControlItem *item = (AGSwitchControlItem *)fromItem;
            item.underline.hidden = YES;
        }
        
        [UIView animateWithDuration:animateDuration animations:^{
            fromItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:animateDuration animations:^{
            toItem.contentView.subviews.firstObject.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        } completion:^(BOOL finished) {
            
            self->_isAnimationFinished = YES;
        }];
        
        if ( [toItem isKindOfClass:[AGSwitchControlItem class]] ) {
            AGSwitchControlItem *item = (AGSwitchControlItem *)toItem;
            item.underline.hidden = NO;
            item.underlineBottomMargin = self.underlineBottomMargin;
            item.underline.backgroundColor = self.underlineContainer.backgroundColor;
            item.underline.size = self->_originUnderlineFrame.size;
            [item makeUnderlineCenter];
        }
        
        self.underlineContainer.hidden = YES;
    }
    else {
        // 无动画
        self.underlineContainer.x = underlineX;
        self.underlineContainer.width = _originUnderlineFrame.size.width;
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
            item.underline.size = self->_originUnderlineFrame.size;
            [item makeUnderlineCenter];
        }
        
        // hidden underline
        self.underlineContainer.hidden = YES;
    }
}

- (BOOL) _scrollItemToIndex:(NSInteger)index withAnimation:(BOOL)yesOrNo
{
    if ( index == self.currentIndex ) {
        return NO;
    }
    
    AGSwitchControlItem *toItem;
    AGSwitchControlItem *fromItem = (AGSwitchControlItem *)_currentItem;
    if ( _itemToLeft ) {
        toItem = [self _getItemWithIndex:index];
        
        if ( nil == toItem ) {
            return NO;
        }
        self.currentIndex = index;
    }
    else {
        toItem = [self _getItemWithIndex:index];
        
        if ( nil == toItem ) {
            return NO;
        }
        self.currentIndex = index;
    }
    
    if ( [self.delegate respondsToSelector:@selector(ag_switchControl:clickTitleItemAtIndex:)] ) {
        [self.delegate ag_switchControl:self clickTitleItemAtIndex:self.currentIndex];
    }
    
    // 让标签滚动
    if ( [self.dataSource respondsToSelector:@selector(ag_switchControl:animationWithTitleItem:toItem:)] ) {
        // 自定义动画
        [self.dataSource ag_switchControl:self animationWithTitleItem:fromItem toItem:toItem];
        
    }
    else {
        // 动画
        [self _scrollTitleItem:fromItem toItem:toItem animation:yesOrNo];
        
    }
    // 记录
    _currentItem = toItem;
    return YES;
}

- (AGSwitchControlItem *) _getLeftItemWithIndex:(NSInteger)index
{
    NSInteger leftIdx = index - 1;
    if ( leftIdx < 0 ) {
        return nil;
    }
    AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:leftIdx];
    return (AGSwitchControlItem *)vm.bindingView;
}

- (AGSwitchControlItem *) _getItemWithIndex:(NSInteger)index
{
    AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:index];
    return (AGSwitchControlItem *)vm.bindingView;
}

- (AGSwitchControlItem *) _getRightItemWithIndex:(NSInteger)index
{
    NSInteger rightIdx = index + 1;
    if ( rightIdx > [self.dataSource ag_numberOfItemInSwitchControl:self] - 1 ) {
        return nil;
    }
    AGViewModel *vm = [self.dataSource ag_switchControl:self viewModelForTitleItemAtIndex:rightIdx];
    return (AGSwitchControlItem *)vm.bindingView;
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

- (UICollectionView *)titleCollectionView
{
    if (_titleCollectionView == nil) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumInteritemSpacing = 0.;
        fl.minimumLineSpacing = 0.;
        _titleCollectionView = [[AGSwitchCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
        
        [AGSwitchControlItem ag_registerCellBy:_titleCollectionView];
    }
    return _titleCollectionView;
}

- (UICollectionView *)detailCollectionView
{
    if (_detailCollectionView == nil) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumInteritemSpacing = 0.;
        fl.minimumLineSpacing = 0.;
        _detailCollectionView = [[AGSwitchCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _detailCollectionView.backgroundColor = [UIColor whiteColor];
        _detailCollectionView.showsHorizontalScrollIndicator = NO;
        _detailCollectionView.pagingEnabled = YES;
        _detailCollectionView.delegate = self;
        _detailCollectionView.dataSource = self;
        _detailCollectionView.alwaysBounceHorizontal = YES;
        if (@available(iOS 11.0, *)) {
            _detailCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        [UICollectionViewCell ag_registerCellBy:_detailCollectionView];
    }
    return _detailCollectionView;
}

#pragma mark - ----------- Setter Methods ----------
- (void)setDataSource:(id<AGSwitchControlDataSource>)dataSource
{
    _dataSource = dataSource;
    if ([self.dataSource respondsToSelector:@selector(ag_numberOfItemInSwitchControl:)] &&
        [self.dataSource respondsToSelector:@selector(ag_switchControl:viewModelForTitleItemAtIndex:)] ) {
        [self addSubview:self.titleCollectionView];
        
        if ( [self.dataSource respondsToSelector:@selector(ag_switchControl:viewForDetailItemAtIndex:)] ) {
            [self addSubview:self.detailCollectionView];
        }
    }
}

@end

@implementation AGSwitchCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
