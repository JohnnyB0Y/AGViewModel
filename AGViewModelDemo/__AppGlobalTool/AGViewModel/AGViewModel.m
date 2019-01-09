//
//  AGViewModel.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  视图-模型 绑定

#import "AGViewModel.h"
#import "AGVMFunction.h"
#import "AGVMNotifier.h"

@interface AGViewModel ()

@property (nonatomic, strong) AGVMNotifier *notifier;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *archivedDictM;

@end

#pragma mark - implementation
@implementation AGViewModel {
    AGVMConfigDataBlock _configDataBlock;
    
    struct AGResponeMethods {
        unsigned int ag_callDelegateToDoForInfo         : 1;
        unsigned int ag_callDelegateToDoForViewModel    : 1;
        unsigned int ag_callDelegateToDoForAction       : 1;
        unsigned int ag_callDelegateToDoForActionInfo   : 1;
    } _responeMethod;
    
    BOOL _cachedBindingViewSizeTag;
    
    BOOL _refreshUITag;
}

#pragma mark - ----------- Life Cycle ----------
+ (instancetype) newWithModel:(NSDictionary *)bindingModel
                     capacity:(NSInteger)capacity
{
    AGViewModel *vm = [[self alloc] initWithModel:ag_newNSMutableDictionary(capacity)];
    [vm ag_mergeModelFromDictionary:bindingModel];
    return vm;
}

+ (instancetype) newWithModel:(NSDictionary *)bindingModel
{
    NSMutableDictionary *dictM = bindingModel ? [bindingModel mutableCopy] : ag_newNSMutableDictionary(6);
    AGViewModel *vm = [[self alloc] initWithModel:dictM];
    return vm;
}

- (instancetype) initWithModel:(NSMutableDictionary *)bindingModel
{
    self = [super init];
    if (self) {
        _bindingModel = bindingModel;
        _cachedBindingViewSizeTag = YES;
    }
    return self;
}

- (void)dealloc
{
    _configDataBlock = nil;
}

#pragma mark - ---------- Public Methods ----------
#pragma mark 设置绑定视图
- (void) ag_setBindingView:(UIView<AGVMIncludable> *)bindingView
{
    [self ag_setBindingView:bindingView configDataBlock:nil];
}

- (void) ag_setBindingView:(UIView<AGVMIncludable> *)bindingView
           configDataBlock:(AGVMConfigDataBlock)configDataBlock
{
    _bindingView        = bindingView;
    _configDataBlock    = [configDataBlock copy];
    
    // 判断 bv 是否实现方法
    if (!_configDataBlock && [bindingView respondsToSelector:@selector(setViewModel:)])
    {
        _configDataBlock =
        ^( AGViewModel *vm, UIView<AGVMIncludable> *bv, NSMutableDictionary *bm ){
            [bv setViewModel:vm];
        };
    }
}

#pragma mark 设置绑定代理
/** 设置代理 */
- (void) ag_setDelegate:(id<AGVMDelegate>)delegate
           forIndexPath:(NSIndexPath *)indexPath
{
    self.delegate = delegate;
    self.indexPath = indexPath;
}

#pragma mark 绑定视图可以计算自己的Size，并提供给外界使用。
- (CGSize) ag_sizeOfBindingView
{
    if ( _cachedBindingViewSizeTag ) {
        return [self ag_cachedSizeByBindingView:_bindingView];
    }
    
    CGFloat height = [self[kAGVMViewH] floatValue];
    CGFloat width = [self[kAGVMViewW] floatValue];
    return CGSizeMake(width, height);
}

- (CGSize) ag_sizeForBindingView:(UIView<AGVMIncludable> *)bv
{
    if ( _cachedBindingViewSizeTag ) {
        return [self ag_cachedSizeByBindingView:bv];
    }
    
    CGFloat height = [self[kAGVMViewH] floatValue];
    CGFloat width = [self[kAGVMViewW] floatValue];
    CGSize bvSize = CGSizeMake(width, height);
    if ( [bv respondsToSelector:@selector(ag_viewModel:sizeForBindingView:)] ) {
        return [bv ag_viewModel:self sizeForBindingView:[UIScreen mainScreen]];
    }
    else {
        NSAssert(NO, @"绑定视图未实现 AGVMIncludable 协议方法：ag_viewModel:sizeForBindingView:");
    }
    return bvSize;
}

/** 计算并缓存绑定视图的Size */
- (CGSize) ag_cachedSizeByBindingView:(UIView<AGVMIncludable> *)bv
{
    // old bv size
    CGFloat height = [self[kAGVMViewH] floatValue];
    CGFloat width = [self[kAGVMViewW] floatValue];
    CGSize bvSize = CGSizeMake(width, height);
    
    // 预防性
    if ( bv == nil ) {
        return bvSize;
    }
    
    if ( [bv respondsToSelector:@selector(ag_viewModel:sizeForBindingView:)] ) {
        // new bv size
        bvSize = [bv ag_viewModel:self sizeForBindingView:[UIScreen mainScreen]];
        // cache size
        if ( height != bvSize.height ) {
            self[kAGVMViewH] = @(bvSize. height);
        }
        
        if ( width != bvSize.width ) {
            self[kAGVMViewW] = @(bvSize. width);
        }
        // cached
        _cachedBindingViewSizeTag = NO;
    }
    else {
        NSAssert(NO, @"绑定视图未实现 AGVMIncludable 协议方法：ag_viewModel:sizeForBindingView:");
    }
    return bvSize;
}

- (void) ag_setNeedsCachedBindingViewSize
{
    _cachedBindingViewSizeTag = YES;
}

- (void) ag_cachedBindingViewSizeIfNeeded
{
    if ( _cachedBindingViewSizeTag ) {
        [self ag_cachedSizeByBindingView:_bindingView];
    }
}

#pragma mark 更新数据，刷新界面
/** 删除数据 */
- (void) ag_removeObjectForKey:(NSString *)key
{
    NSParameterAssert(key);
    [_bindingModel removeObjectForKey:key];
}

/** 删除所有数据 */
- (void) ag_removeAllObjects
{
    [_bindingModel removeAllObjects];
}

- (void) ag_refreshUIByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
{
    [self ag_setNeedsRefreshUIModelInBlock:block];
    [self ag_refreshUI];
}

/** 更新数据，并对“需要刷新UI”进行标记；当调用ag_refreshUIIfNeeded时，刷新UI界面。*/
- (void) ag_setNeedsRefreshUIModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
{
    if ( block ) block( _bindingModel );
    [self ag_setNeedsRefreshUI];
}

/** 对“需要刷新UI”进行标记；当调用ag_refreshUIIfNeeded时，刷新UI界面。*/
- (void) ag_setNeedsRefreshUI
{
    _refreshUITag = YES;
}

/** 刷新UI界面。*/
- (void) ag_refreshUI
{
    if ( _configDataBlock && _bindingView.viewModel == self ) {
        _configDataBlock( self, _bindingView, _bindingModel );
        _refreshUITag = NO;
    }
}

/** 如果有“需要刷新UI”的标记，马上刷新界面。 */
- (void) ag_refreshUIIfNeeded
{
    if ( _refreshUITag ) {
        [self ag_refreshUI];
    }
}

#pragma mark 数据合并
/** 合并 bindingModel */
- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm
{
    [self ag_mergeModelFromDictionary:vm.bindingModel];
}

- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict
{
    dict.count > 0 ? [_bindingModel addEntriesFromDictionary:dict] : nil;
}

- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict forKeys:(NSArray<NSString *> *)keys
{
    if ( dict.count <= 0 ) {
        return;
    }
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([key isKindOfClass:[NSString class]], @"Key is not kind of NSString!");
        self[key] = dict[key];
    }];
}

- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm forKeys:(NSArray<NSString *> *)keys
{
    [self ag_mergeModelFromDictionary:vm.bindingModel forKeys:keys];
}

#pragma mark Other method.
- (void)ag_callDelegateToDoForInfo:(NSDictionary *)info
{
    if ( _responeMethod.ag_callDelegateToDoForInfo ) {
        [_delegate ag_viewModel:self callDelegateToDoForInfo:info];
    }
    else {
        SEL sel = @selector(ag_viewModel:callDelegateToDoForInfo:);
        NSLog(@"Delegate not implementation %@!", NSStringFromSelector(sel));
    }
}

- (void)ag_callDelegateToDoForViewModel:(AGViewModel *)info
{
    if ( _responeMethod.ag_callDelegateToDoForViewModel ) {
        [_delegate ag_viewModel:self callDelegateToDoForViewModel:info];
    }
    else {
        SEL sel = @selector(ag_viewModel:callDelegateToDoForViewModel:);
        NSLog(@"Delegate not implementation %@!", NSStringFromSelector(sel));
    }
}

- (void)ag_callDelegateToDoForAction:(SEL)action
{
    if ( _responeMethod.ag_callDelegateToDoForAction ) {
        [_delegate ag_viewModel:self callDelegateToDoForAction:action];
    }
    else {
        SEL sel = @selector(ag_viewModel:callDelegateToDoForAction:);
        NSLog(@"Delegate not implementation %@!", NSStringFromSelector(sel));
    }
}

- (void)ag_callDelegateToDoForAction:(SEL)action info:(AGViewModel *)info
{
    if ( _responeMethod.ag_callDelegateToDoForActionInfo ) {
        [_delegate ag_viewModel:self callDelegateToDoForAction:action info:info];
    }
    else {
        SEL sel = @selector(ag_viewModel:callDelegateToDoForAction:info:);
        NSLog(@"Delegate not implementation %@!", NSStringFromSelector(sel));
    }
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    AGViewModel *vm = [[self.class allocWithZone:zone] initWithModel:[_bindingModel mutableCopy]];
    [vm ag_setBindingView:_bindingView configDataBlock:_configDataBlock];
    [vm ag_setDelegate:_delegate forIndexPath:_indexPath];
    vm->_archivedDictM = [self->_archivedDictM mutableCopy];
    return vm;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    AGViewModel *vm = [[self.class allocWithZone:zone] initWithModel:[_bindingModel mutableCopy]];
    [vm ag_setBindingView:_bindingView configDataBlock:_configDataBlock];
    [vm ag_setDelegate:_delegate forIndexPath:_indexPath];
    vm->_archivedDictM = [self->_archivedDictM mutableCopy];
    return vm;
}

#pragma mark NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if ( _archivedDictM ) {
        
        NSMutableDictionary *dictM = ag_newNSMutableDictionary(_archivedDictM.count);
        [_archivedDictM enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id archiveObj = self->_bindingModel[key];
            BOOL isConformsToProtocol = [archiveObj conformsToProtocol:@protocol(NSCoding)];
            NSAssert(isConformsToProtocol, @"Archived object not conform to <NSCoding> protocol.");
            if ( isConformsToProtocol ) {
                [dictM setObject:archiveObj forKey:key];
            }
        }];
        
        [aCoder encodeObject:dictM forKey:kAGVMDictionary];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSMutableDictionary<NSString *, id> *bm = [[aDecoder decodeObjectOfClass:self.class forKey:kAGVMDictionary] mutableCopy];
    if ( bm == nil ) {
        bm = [NSMutableDictionary dictionaryWithCapacity:6];
    }
    
    self = [self initWithModel:bm];
    if ( self == nil ) return nil;
    
    self->_archivedDictM = [NSMutableDictionary dictionaryWithCapacity:bm.count];
    [bm enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self->_archivedDictM setObject:kAGVMObject forKey:key];
    }];
    
    return self;
}

/** 更新数据，并添加到支持 归档(NSKeyedArchiver)、转Json字符串当中。*/
- (void) ag_addArchivedObjectKey:(NSString *)key
{
    NSParameterAssert(key);
    [self.archivedDictM setObject:kAGVMObject forKey:key];
}

- (void) ag_removeArchivedObjectKey:(NSString *)key
{
    NSParameterAssert(key);
    [_archivedDictM removeObjectForKey:key];
}

- (void) ag_removeAllArchivedObjectKeys
{
    [_archivedDictM removeAllObjects];
}

#pragma mark AGVMJSONTransformable
- (NSString *) ag_toJSONStringWithExchangeKey:(AGViewModel *)vm
                              customTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    NSMutableDictionary *dictM = ag_newNSMutableDictionary(_archivedDictM.count);
    [_archivedDictM enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id archiveObj = self->_bindingModel[key];
        if ( [archiveObj conformsToProtocol:@protocol(NSCoding)] ) {
            [dictM setObject:archiveObj forKey:key];
        }
    }];
    
    return ag_newJSONStringWithDictionary(dictM, vm, block);
}

- (NSString *)ag_toJSONStringWithCustomTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    return [self ag_toJSONStringWithExchangeKey:nil customTransform:block];
}

- (NSString *)ag_toJSONString
{
    return [self ag_toJSONStringWithCustomTransform:nil];
}

#pragma mark - ------------ Override Methods --------------
- (id)objectForKeyedSubscript:(NSString *)key;
{
    NSParameterAssert(key);
    return key ? _bindingModel[key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;
{
    NSParameterAssert(key);
    if ( ! key ) return;
    
    if ( obj ) {
        _bindingModel[key] = obj;
    }
    else {
        [_bindingModel removeObjectForKey:key];
    }
}

- (NSString *)debugDescription
{
    return [self ag_debugString];
}

- (id)debugQuickLookObject
{
    return [self ag_debugString];
}

- (NSString *) ag_debugString
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"  _delegate     [ weak ] : %@, \n", _delegate];
    [strM appendFormat:@"  _notifier     (strong) : %@, \n", _notifier];
    [strM appendFormat:@"  _indexPath    ( copy ) : %@, \n", _indexPath];
    [strM appendFormat:@"  _bindingView  [ weak ] : <%@: %p>, \n", [_bindingView class], _bindingView];
    
    NSMutableString *bmStrM = [NSMutableString stringWithFormat:@"{\n"];
    [_bindingModel enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [bmStrM appendFormat:@"    %@ = %@, \n", key, obj];
    }];
    [bmStrM appendFormat:@"  }"];
    
    [strM appendFormat:@"  _bindingModel (strong) : %@", bmStrM];
    return [NSString stringWithFormat:@"♦️ <%@: %p> ♦️ {\n%@\n}", [self class] , self, strM];
}

#pragma mark - ----------- Setter Methods ----------
- (void)setDelegate:(id<AGVMDelegate>)delegate
{
    _delegate = delegate;
    
    _responeMethod.ag_callDelegateToDoForInfo
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForInfo:)];
    
    _responeMethod.ag_callDelegateToDoForViewModel
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForViewModel:)];
    
    _responeMethod.ag_callDelegateToDoForAction
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForAction:)];
    
    _responeMethod.ag_callDelegateToDoForActionInfo
    = [_delegate respondsToSelector:@selector(ag_viewModel:callDelegateToDoForAction:info:)];
}

#pragma mark - ----------- Getter Methods ----------
- (AGVMNotifier *)notifier
{
    if (_notifier == nil) {
        _notifier = [[AGVMNotifier alloc] initWithViewModel:self];
    }
    return _notifier;
}

- (NSMutableDictionary<NSString *,id> *)archivedDictM
{
    if (_archivedDictM == nil) {
        _archivedDictM = ag_newNSMutableDictionary(6);
    }
    return _archivedDictM;
}

@end

#pragma mark -
@implementation AGViewModel (AGVMObserverRegistration)
#pragma mark readd observer
- (void) ag_readdObserver:(NSObject *)observer
				   forKey:(NSString *)key
               usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_readdObserver:observer forKey:key usingBlock:block];
}

- (void) ag_readdObserver:(NSObject *)observer
				  forKeys:(NSArray<NSString *> *)keys
					usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_readdObserver:observer forKeys:keys usingBlock:block];
}

- (void) ag_readdObserver:(NSObject *)observer
                   forKey:(NSString *)key
                  options:(NSKeyValueObservingOptions)options
               usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_readdObserver:observer forKey:key options:options usingBlock:block];
}

- (void)ag_readdObserver:(NSObject *)observer
                 forKeys:(NSArray<NSString *> *)keys
                 options:(NSKeyValueObservingOptions)options
              usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_readdObserver:observer forKeys:keys options:options usingBlock:block];
}

#pragma mark add observer
- (void) ag_addObserver:(NSObject *)observer
				 forKey:(NSString *)key
             usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_addObserver:observer forKey:key usingBlock:block];
}

- (void) ag_addObserver:(NSObject *)observer
				forKeys:(NSArray<NSString *> *)keys
             usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_addObserver:observer forKeys:keys usingBlock:block];
}

- (void) ag_addObserver:(NSObject *)observer
				 forKey:(NSString *)key
				options:(NSKeyValueObservingOptions)options
             usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_addObserver:observer forKey:key options:options usingBlock:block];
}

- (void) ag_addObserver:(NSObject *)observer
				forKeys:(NSArray<NSString *> *)keys
				options:(NSKeyValueObservingOptions)options
             usingBlock:(AGVMNotificationBlock)block
{
	[self.notifier ag_addObserver:observer forKeys:keys options:options usingBlock:block];
}

#pragma mark remove observer
- (void) ag_removeObserver:(NSObject *)observer
					forKey:(NSString *)key
{
	[self.notifier ag_removeObserver:observer forKey:key];
}

- (void) ag_removeObserver:(NSObject *)observer
				   forKeys:(NSArray<NSString *> *)keys
{
	[self.notifier ag_removeObserver:observer forKeys:keys];
}

- (void) ag_removeObserver:(NSObject *)observer
{
	[self.notifier ag_removeObserver:observer];
}

- (void) ag_removeAllObservers
{
	[self.notifier ag_removeAllObservers];
}

@end

#pragma mark -
@implementation AGViewModel (AGVMSafeAccessible)

#pragma mark safe number
- (id) ag_safeSetNumber:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetNumber:value forKey:key handle:nil];
}
- (NSNumber *) ag_safeNumberForKey:(NSString *)key
{
	return [self ag_safeNumberForKey:key handle:nil];
}
- (id) ag_safeSetNumber:(id)value forKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeSetHandleBlock)block
{
	return [self _setNewObject:ag_safeNumber(value) forKey:key withObject:value handle:block];
}
- (NSNumber *) ag_safeNumberForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetHandleBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeNumber(value) withObject:value handle:block];
}


#pragma mark safe string
- (id) ag_safeSetString:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetString:value forKey:key handle:nil];
}
- (NSString *) ag_safeStringForKey:(NSString *)key
{
	return [self ag_safeStringForKey:key handle:nil];
}
- (id) ag_safeSetString:(id)value forKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeSetHandleBlock)block
{
	return [self _setNewObject:ag_safeString(value) forKey:key withObject:value handle:block];
}
- (NSString *) ag_safeStringForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetHandleBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeString(value) withObject:value handle:block];
}
- (NSString *) ag_safeNumberStringForKey:(NSString *)key
{
    return [self ag_safeNumberStringForKey:key handle:nil];
}
- (NSString *) ag_safeNumberStringForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetHandleBlock)block
{
    id value = self[key];
    return [self _getNewObject:ag_newNSStringWithObj(value) withObject:value handle:block];
}



#pragma mark safe array
- (id) ag_safeSetArray:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetArray:value forKey:key handle:nil];
}
- (NSArray *) ag_safeArrayForKey:(NSString *)key
{
	return [self ag_safeArrayForKey:key handle:nil];
}
- (id) ag_safeSetArray:(id)value forKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeSetHandleBlock)block
{
	return [self _setNewObject:ag_safeArray(value) forKey:key withObject:value handle:block];
}
- (NSArray *) ag_safeArrayForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetHandleBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeArray(value) withObject:value handle:block];
}


#pragma mark safe dictionary
- (id) ag_safeSetDictionary:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetDictionary:value forKey:key handle:nil];
}
- (NSDictionary *) ag_safeDictionaryForKey:(NSString *)key
{
	return [self ag_safeDictionaryForKey:key handle:nil];
}
- (id) ag_safeSetDictionary:(id)value forKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeSetHandleBlock)block
{
	return [self _setNewObject:ag_safeDictionary(value) forKey:key withObject:value handle:block];
}
- (NSDictionary *) ag_safeDictionaryForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetHandleBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeDictionary(value) withObject:value handle:block];
}


#pragma mark safe url
- (NSURL *) ag_safeURLForKey:(NSString *)key
{
	return [self ag_safeURLForKey:key handle:nil];
}
- (NSURL *) ag_safeURLForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetHandleBlock)block
{
	id value = self[key];
	NSURL *url = ag_safeObj(value, [NSURL class]);
	if ( url == nil ) {
		NSString *urlStr = ag_safeString(value);
		if ( urlStr ) {
			url = [NSURL URLWithString:urlStr];
		}
	}
	return [self _getNewObject:url withObject:value handle:block];
}


#pragma mark safe value type
- (double) ag_safeDoubleValueForKey:(NSString *)key
{
	return [self ag_safeDoubleValueForKey:key handle:nil];
}
- (double) ag_safeDoubleValueForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetNumberHandleBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(doubleValue)];
	NSNumber *number = [self _getNewNumber:value respond:respond handle:block];
	return [number doubleValue];
}


- (float) ag_safeFloatValueForKey:(NSString *)key
{
	return [self ag_safeFloatValueForKey:key handle:nil];
}
- (float) ag_safeFloatValueForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetNumberHandleBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(floatValue)];
	NSNumber *number = [self _getNewNumber:value respond:respond handle:block];
	return [number floatValue];
}


- (int) ag_safeIntValueForKey:(NSString *)key
{
	return [self ag_safeIntValueForKey:key handle:nil];
}
- (int) ag_safeIntValueForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetNumberHandleBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(intValue)];
	NSNumber *number = [self _getNewNumber:value respond:respond handle:block];
	return [number intValue];
}


- (NSInteger) ag_safeIntegerValueForKey:(NSString *)key
{
	return [self ag_safeIntegerValueForKey:key handle:nil];
}
- (NSInteger) ag_safeIntegerValueForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetNumberHandleBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(integerValue)];
	NSNumber *number = [self _getNewNumber:value respond:respond handle:block];
	return [number integerValue];
}


- (long long) ag_safeLongLongValueForKey:(NSString *)key
{
	return [self ag_safeLongLongValueForKey:key handle:nil];
}
- (long long) ag_safeLongLongValueForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetNumberHandleBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(longLongValue)];
	NSNumber *number = [self _getNewNumber:value respond:respond handle:block];
	return [number longLongValue];
}


- (BOOL) ag_safeBoolValueForKey:(NSString *)key
{
	return [self ag_safeBoolValueForKey:key handle:nil];
}
- (BOOL) ag_safeBoolValueForKey:(NSString *)key handle:(NS_NOESCAPE AGVMSafeGetNumberHandleBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(boolValue)];
	NSNumber *number = [self _getNewNumber:value respond:respond handle:block];
	return [number boolValue];
}

#pragma mark - ---------- Private Methods ----------
- (id) _setNewObject:(id)newObj
              forKey:(NSString *)key
          withObject:(id)obj
              handle:(AGVMSafeSetHandleBlock)block
{
	self[key] = newObj;
	block ? block(obj, newObj != nil) : nil;
	return newObj;
}

- (id) _getNewObject:(id)newObj
	      withObject:(id)obj
              handle:(AGVMSafeGetHandleBlock)block
{
	if ( block ) {
		newObj = block(obj, newObj != nil);
	}
	return newObj;
}

- (NSNumber *) _getNewNumber:(id)obj
                     respond:(BOOL)respond
                      handle:(AGVMSafeGetNumberHandleBlock)block
{
	if ( block ) {
		return block(obj, respond);
	}
	return respond ? obj : nil;
}

@end


static NSString * const kAGViewModelStrongToWeakMapTable = @"kAGViewModelStrongToWeakMapTable";
@implementation AGViewModel (AGWeakly)

- (void)ag_setWeakRefObject:(id)obj forKey:(NSString *)key
{
    AGAssertParameter(key);
    [[self _strongToWeakMapTable] setObject:obj forKey:key];
}

- (void)ag_removeWeakRefObjectForKey:(NSString *)key
{
    AGAssertParameter(key);
    [[self _strongToWeakMapTable] removeObjectForKey:key];
}

- (id)ag_weakRefObjectForKey:(NSString *)key
{
    AGAssertParameter(key);
    return [[self _strongToWeakMapTable] objectForKey:key];
}

- (NSMapTable *) _strongToWeakMapTable
{
    NSMapTable *mt = _bindingModel[kAGViewModelStrongToWeakMapTable];
    if ( nil == mt ) {
        mt = [NSMapTable strongToWeakObjectsMapTable];
        [_bindingModel setObject:mt forKey:kAGViewModelStrongToWeakMapTable];
    }
    return mt;
}

@end
