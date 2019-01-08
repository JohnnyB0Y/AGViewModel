////
////  AGLikeButtom.m
////
////  Created by JohnnyB0Y on 2017/4/8.
////  Copyright © 2017年 JohnnyB0Y. All rights reserved.
////
//
//#import "AGLikeButtom.h"
//
///** 快速创建 likeBtn */
//AGLikeButtom * ag_likeButtom(UIEdgeInsets edgeInsets, CGFloat contentInterval, CGFloat height)
//{
//    return [AGLikeButtom ag_likeBtnWithContentEdgeInsets:edgeInsets
//                                         contentInterval:contentInterval
//                                                  height:height];
//}
//
//
//@interface AGLikeButtom ()
//
///** 内容边缘间距 */
//@property (nonatomic, assign) UIEdgeInsets      edgeInsets;
///** 图片和文字的间隔 */
//@property (nonatomic, assign) CGFloat           contentInterval;
///** 高度 */
//@property (nonatomic, assign) CGFloat           maxHeight;
//
///** 图片 */
//@property (nonatomic, strong) UIImageView       *customImageView;
///** 文字 */
//@property (nonatomic, strong) UILabel           *customTitleLabel;
//
///** 标题s */
//@property (nonatomic, strong) NSMutableArray    *titleArrM;
///** 图片s */
//@property (nonatomic, strong) NSMutableArray    *imageArrM;
///** 文字颜色s */
//@property (nonatomic, strong) NSMutableArray    *titleColorArrM;
//
//@end
//
//@implementation AGLikeButtom {
//    UIFont  *_titleFont;
//    UIImage *_backgroundImage;
//    UIImage *_badgeImage;
//    UIColor *_badgeColor;
//    CGSize  _badgeSize;
//    BOOL    _showBadge;
//}
//
//#pragma mark - ---------- Life Cycle ----------
//- (instancetype)init
//{
//    self = [super init];
//    
//    if (self) {
//        
//        self.clipsToBounds = YES;
//        self.backgroundColor = [UIColor clearColor];
//        [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//        // 默认
//        _edgeInsets = UIEdgeInsetsMake(6., 8., 6., 8.);
//        _contentInterval = 7.;
//        _maxHeight = 24.;
//        _showBadge = NO;
//        _badgeSize = CGSizeMake(5., 5.);
//        _titleFont = [UIFont systemFontOfSize:11.];
//    }
//    
//    return self;
//}
//
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    self.clipsToBounds = YES;
//    self.backgroundColor = [UIColor clearColor];
//    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    // 默认
//    _edgeInsets = UIEdgeInsetsMake(6., 8., 6., 8.);
//    _contentInterval = 7.;
//    _maxHeight = 24.;
//    _showBadge = NO;
//    _badgeSize = CGSizeMake(5., 5.);
//    _titleFont = [UIFont systemFontOfSize:11.];
//}
//
//+ (instancetype)ag_likeBtnWithContentEdgeInsets:(UIEdgeInsets)edgeInsets contentInterval:(CGFloat)contentInterval height:(CGFloat)height
//{
//    return [[self alloc] initWithContentEdgeInsets:edgeInsets contentInterval:contentInterval height:height];
//}
//
//- (instancetype)initWithContentEdgeInsets:(UIEdgeInsets)edgeInsets contentInterval:(CGFloat)contentInterval height:(CGFloat)height
//{
//    self = [self init];
//    if ( self ) {
//        self.edgeInsets = UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero) ? self.edgeInsets : edgeInsets;
//        self.contentInterval = contentInterval;
//        self.maxHeight = height > 0 ? height : self.maxHeight;
//        self.height = self.maxHeight;
//    }
//    return self;
//}
//
//#pragma mark - ---------- Public Methods ----------
//- (void) ag_setNorImage:(NSString *)imageName
//{
//    [self _setImage:imageName forState:UIControlStateNormal];
//}
//
//- (void) ag_setHigImage:(NSString *)imageName
//{
//    [self _setImage:imageName forState:UIControlStateHighlighted];
//}
//
//- (void) ag_setDisImage:(NSString *)imageName
//{
//    [self _setImage:imageName forState:UIControlStateDisabled];
//}
//
//- (void) ag_setSelImage:(NSString *)imageName
//{
//    [self _setImage:imageName forState:UIControlStateSelected];
//}
//
//- (void) ag_setNorTitle:(NSString *)title
//{
//    [self _setTitle:title forState:UIControlStateNormal];
//}
//
//- (void) ag_setHigTitle:(NSString *)title
//{
//    [self _setTitle:title forState:UIControlStateHighlighted];
//}
//
//- (void) ag_setDisTitle:(NSString *)title
//{
//    [self _setTitle:title forState:UIControlStateDisabled];
//}
//
//- (void) ag_setSelTitle:(NSString *)title
//{
//    [self _setTitle:title forState:UIControlStateSelected];
//}
//
//- (void) ag_setNorTitleColor:(UIColor *)color
//{
//    [self _setTitleColor:color forState:UIControlStateNormal];
//}
//
//- (void) ag_setHigTitleColor:(UIColor *)color
//{
//    [self _setTitleColor:color forState:UIControlStateHighlighted];
//}
//
//- (void) ag_setDisTitleColor:(UIColor *)color
//{
//    [self _setTitleColor:color forState:UIControlStateDisabled];
//}
//
//- (void) ag_setSelTitleColor:(UIColor *)color
//{
//    [self _setTitleColor:color forState:UIControlStateSelected];
//}
//
//- (void) ag_setCornerRadius:(CGFloat)cornerRadius
//{
//    if (cornerRadius >= 0) {
//        [self.layer setCornerRadius:cornerRadius];
//        self.layer.masksToBounds = YES;
//    }
//}
//
//- (void) ag_setImageCornerRadius:(CGFloat)cornerRadius
//{
//    if (cornerRadius >= 0) {
//        [self.customImageView.layer setCornerRadius:cornerRadius];
//        self.customImageView.layer.masksToBounds = YES;
//    }
//}
//
//- (void) ag_setImageCircle
//{
//    CGFloat height = _maxHeight - _edgeInsets.top - _edgeInsets.bottom;
//    [self ag_setImageCornerRadius:height * .5];
//}
//
//- (void) ag_setBorderWidth:(CGFloat)width
//{
//    self.layer.borderWidth = width;
//}
//
//- (void) ag_setBorderColor:(UIColor *)color
//{
//    self.layer.borderColor = color.CGColor;
//}
//
//- (void)ag_setBackgroundImageName:(NSString *)imageName
//{
//    // 绘制背景图片
//    [self ag_setBackgroundImage:[UIImage imageNamed:imageName]];
//}
//
//- (void)ag_setBackgroundImage:(UIImage *)image
//{
//    _backgroundImage = image;
//    [self setNeedsDisplay];
//}
//
//- (void) ag_setTitleFontSize:(CGFloat)fontSize
//{
//    if ( fontSize > 0) {
//        _titleFont = [UIFont systemFontOfSize:fontSize];
//        [_customTitleLabel setFont:_titleFont];
//    }
//}
//
///** 提示标记微章 */
//- (void) ag_setBadgeImage:(NSString *)imageName
//{
//    _badgeImage = [UIImage imageNamed:imageName];
//    NSAssert(_badgeImage, @"图片加载不了！");
//}
//
//- (void) ag_setBadgeColor:(UIColor *)color
//{
//    if ( color ) {
//        _badgeColor = color;
//        _badgeImage = nil;
//        if ( _showBadge ) [self setNeedsDisplay];
//    }
//}
//
//- (void) ag_setBadgeSize:(CGSize)size
//{
//    if ( size.width > 0 && size.height > 0 ) {
//        _badgeSize = size;
//        
//        if ( _showBadge ) [self setNeedsDisplay];
//    }
//}
//
//- (void) ag_showBadge
//{
//    _showBadge = YES;
//    [self setNeedsDisplay];
//}
//
//- (void) ag_hideBadge
//{
//    _showBadge = NO;
//    [self setNeedsDisplay];
//}
//
///** 网络图片 */
//- (void) ag_setNorImageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholder
//{
//    NSURL *imageURL = [NSURL URLWithString:imageUrl];
//    UIImage *placeholderImg = [UIImage imageNamed:placeholder];
//    [self.customImageView sd_setImageWithURL:imageURL placeholderImage:placeholderImg];
//    
//    // 更新布局
//    [self _updateSubviewCons];
//}
//
//#pragma mark - ------------- Override Methods ------------
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    // 更新视图大小
//    [self invalidateIntrinsicContentSize];
//}
//
//- (CGSize)intrinsicContentSize
//{
//    CGFloat width = _edgeInsets.left + _customImageView.width + _contentInterval + _customTitleLabel.width + _edgeInsets.right;
//    return CGSizeMake(width, _maxHeight);
//}
//
//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
//{
//    // 点击开始
//    [self _changeToState:UIControlStateHighlighted];
//    
//    return [super beginTrackingWithTouch:touch withEvent:event];
//}
//
//- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
//{
//    // 点击结束
//    [self _changeToState:UIControlStateNormal];
//    
//    [super endTrackingWithTouch:touch withEvent:event];
//}
//
//- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
//{
//    // 点击取消
//    if ( ! self.isSelected ) {
//        [self _changeToState:UIControlStateNormal];
//    }
//    
//    [super cancelTrackingWithEvent:event];
//}
//
//- (void)setEnabled:(BOOL)enabled
//{
//    if ( enabled ) {
//        [self _changeToState:UIControlStateNormal];
//    } else {
//        [self _changeToState:UIControlStateDisabled];
//    }
//    
//    [super setEnabled:enabled];
//}
//
//- (void)setSelected:(BOOL)selected
//{
//    if ( selected ) {
//        [self _changeToState:UIControlStateSelected];
//    } else {
//        [self _changeToState:UIControlStateNormal];
//    }
//    
//    [super setSelected:selected];
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    // 绘制背景图片
//    if ( _backgroundImage ) {
//        [_backgroundImage drawInRect:rect];
//    }
//    
//    // 绘制提示标记
//    if ( _showBadge ) {
//        
//        CGFloat badgeMargin = 2.;
//        CGPoint badgeP = CGPointMake(rect.size.width - badgeMargin - _badgeSize.width, badgeMargin);
//        CGRect badgeR = {badgeP, _badgeSize};
//        if ( _badgeImage ) {
//            // 有图直接绘制
//            [_badgeImage drawInRect:badgeR];
//        }
//        else {
//            // 颜色绘制
//            _badgeImage = [[UIImage ag_imageWithColor:_badgeColor size:_badgeSize] ag_circleImage];
//            [_badgeImage drawInRect:badgeR];
//        }
//        
//    }
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    AGLikeButtom *btn = [[self.class allocWithZone:zone] initWithContentEdgeInsets:self.edgeInsets contentInterval:self.contentInterval height:self.maxHeight];
//    btn.customTitleLabel.font = self.customTitleLabel.font;
//    [btn ag_setCornerRadius:self.layer.cornerRadius];
//    btn.layer.borderColor = self.layer.borderColor;
//    btn.layer.borderWidth = self.layer.borderWidth;
//    
//    return btn;
//}
//
//#pragma mark - ---------- Private Methods ----------
//- (void) _updateSubviewCons
//{
//    CGFloat contentH = self.height - _edgeInsets.top - _edgeInsets.bottom;
//    
//    if ( _customImageView.image && _customTitleLabel ) {
//        // 情况一：图片和文字都有
//        [_customImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(contentH, contentH));
//            make.left.mas_equalTo(self.mas_left).mas_offset(_edgeInsets.left);
//            make.centerY.mas_equalTo(self);
//        }];
//        
//        [_customTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self);
//            make.left.mas_equalTo(_customImageView.mas_right).mas_offset(_contentInterval);
//        }];
//    } else if ( _customImageView.image && ! _customTitleLabel ) {
//        // 情况二：只有图片
//        [_customImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            
//            if ( _centerLayout ) {
//                make.centerX.mas_equalTo(self);
//            }
//            else {
//                make.left.mas_equalTo(self).mas_offset(_edgeInsets.left);
//            }
//            
//            make.centerY.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(contentH, contentH));
//        }];
//    } else if ( _customTitleLabel && ! _customImageView.image ) {
//        // 情况三：只有文字
//        [_customTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            
//            if ( _centerLayout ) {
//                make.centerX.mas_equalTo(self);
//            }
//            else {
//                make.left.mas_equalTo(self).mas_offset(_edgeInsets.left);
//            }
//            make.centerY.mas_equalTo(self);
//        }];
//    }
//}
//
//- (void) _setImage:(NSString *)imageName forState:(UIControlState)state
//{
//    UIImage *image;
//    if ( imageName.length > 0 ) {
//        image = [UIImage imageNamed:imageName];
//    }
//    [self __setImage:image forState:state];
//}
//
//- (void) __setImage:(UIImage *)image forState:(UIControlState)state
//{
//    self.imageArrM[state] = image ?: [NSNull null];
//    
//    if ( state == self.state ) {
//        [self _changeToState:state];
//    }
//}
//
//- (void) _setTitle:(NSString *)title forState:(UIControlState)state
//{
//    self.titleArrM[state] = title ?: [NSNull null];
//    if ( state == self.state ) {
//        [self _changeToState:state];
//    }
//}
//
//- (void) _setTitleColor:(UIColor *)color forState:(UIControlState)state
//{
//    self.titleColorArrM[state] = color ?: [NSNull null];
//    if ( state == self.state ) {
//        [self _changeToState:state];
//    }
//}
//
//- (NSArray *) _arrayWithNull
//{
//    NSNull *null = [NSNull null];
//    return @[null, null, null, null, null, null, null];
//}
//
//- (void) _changeToState:(UIControlState)state
//{
//    // 标题
//    NSString *text = ag_safeString(self.titleArrM[state]);
//    text = text ?: ag_safeString(self.titleArrM[UIControlStateNormal]);
//    [self.customTitleLabel setText:text];
//    
//    // 图片
//    UIImage *image = ag_safeObj(self.imageArrM[state], [UIImage class]);
//    image = image ?: ag_safeObj(self.imageArrM[UIControlStateNormal], [UIImage class]);
//    [self.customImageView setImage:image];
//    
//    // 文字颜色
//    UIColor *textColor = ag_safeObj(self.titleColorArrM[state], [UIColor class]);
//    textColor = textColor ?: ag_safeObj(self.titleColorArrM[UIControlStateNormal], [UIColor class]);
//    textColor = textColor ?: [UIColor blackColor];
//    [self.customTitleLabel setTextColor:textColor];
//    
//    // 更新布局
//    [self _updateSubviewCons];
//}
//
//#pragma mark - ----------- Getter Methods ----------
//- (UIImageView *)customImageView
//{
//    if (_customImageView == nil) {
//        _customImageView = [[UIImageView alloc] init];
//        _customImageView.contentMode = UIViewContentModeScaleToFill;
//        [self addSubview:_customImageView];
//    }
//    
//    return _customImageView;
//}
//
//- (UILabel *)customTitleLabel
//{
//    if (_customTitleLabel == nil) {
//        _customTitleLabel = [[UILabel alloc] init];
//        [self addSubview:_customTitleLabel];
//        
//        // 字体
//        [_customTitleLabel setFont:_titleFont];
//        // 默认颜色
//        UIColor *norColor = self.titleColorArrM[UIControlStateNormal];
//        UIColor *higColor = self.titleColorArrM[UIControlStateHighlighted];
//        if ( ! [norColor isKindOfClass:[UIColor class]] ) {
//            norColor = [UIColor blackColor];
//            self.titleColorArrM[UIControlStateNormal] = norColor;
//        }
//        if ( ! [higColor isKindOfClass:[UIColor class]] ) {
//            higColor = [UIColor grayColor];
//            self.titleColorArrM[UIControlStateHighlighted] = higColor;
//        }
//        // 当前颜色
//        UIColor *currentColor = self.titleColorArrM[self.state];
//        if ( [currentColor isKindOfClass:[UIColor class]] ) {
//            _customTitleLabel.textColor = currentColor;
//        }
//        
//    }
//    
//    return _customTitleLabel;
//}
//
//- (NSMutableArray *)imageArrM
//{
//    if (_imageArrM == nil) {
//        _imageArrM = [NSMutableArray arrayWithArray:[self _arrayWithNull]];
//    }
//    return _imageArrM;
//}
//
//- (NSMutableArray *)titleArrM
//{
//    if (_titleArrM == nil) {
//        _titleArrM = [NSMutableArray arrayWithArray:[self _arrayWithNull]];
//    }
//    return _titleArrM;
//}
//
//- (NSMutableArray *)titleColorArrM
//{
//    if (_titleColorArrM == nil) {
//        _titleColorArrM = [NSMutableArray arrayWithArray:[self _arrayWithNull]];
//    }
//    return _titleColorArrM;
//}
//
//
//
//@end
