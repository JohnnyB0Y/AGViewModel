//
//  AGViewModel.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  视图-模型 绑定

#import "AGViewModel.h"
#import "AGVMNotifier.h"

@interface AGViewModel ()

@property (nonatomic, strong) AGVMNotifier *notifier;

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
}

#pragma mark - ----------- Life Cycle ----------
+ (instancetype) ag_viewModelWithModel:(NSDictionary *)bindingModel
                              capacity:(NSUInteger)capacity
{
    AGViewModel *vm = [[self alloc] initWithModel:ag_mutableDict(capacity)];
    [vm ag_mergeModelFromDictionary:bindingModel];
    return vm;
}

+ (instancetype) ag_viewModelWithModel:(NSDictionary *)bindingModel
{
    NSMutableDictionary *dictM = bindingModel ? [bindingModel mutableCopy] : ag_mutableDict(6);
    AGViewModel *vm = [[self alloc] initWithModel:dictM];
    return vm;
}

- (instancetype) initWithModel:(NSMutableDictionary *)bindingModel
{
    self = [super init];
    if (self) {
        _bindingModel = bindingModel;
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

#pragma mark 绑定视图后，可以让视图做一些事情
/** 获取 bindingView 的 size */
- (CGSize) ag_sizeOfBindingView
{
    return [self ag_sizeOfBindingView:_bindingView];
}

/** 当 bindingView 为空时，直接传进去计算 size */
- (CGSize) ag_sizeOfBindingView:(UIView<AGVMIncludable> *)bv
{
    CGFloat height = [self[kAGVMViewH] floatValue];
    CGFloat width = [self[kAGVMViewW] floatValue];
    CGSize bindingViewS = CGSizeMake(width, height);
    
    if ( [bv respondsToSelector:@selector(ag_viewModel:sizeForBindingView:)] ) {
        bindingViewS = [bv ag_viewModel:self sizeForBindingView:bindingViewS];
        
        if ( height != bindingViewS.height ) {
            self[kAGVMViewH] = @(bindingViewS.height);
        }
        
        if ( width != bindingViewS.width ) {
            self[kAGVMViewW] = @(bindingViewS.width);
        }
        
    }
    return bindingViewS;
}

/** 预先计算 size */
- (void) ag_precomputedSizeOfBindingView:(UIView<AGVMIncludable> *)bv
{
    [self ag_sizeOfBindingView:bv];
}

#pragma mark help method
- (void) ag_refreshUIByUpdateModelInBlock:(AGVMUpdateModelBlock)block
{
    if ( block ) block( _bindingModel );
    
    if ( _configDataBlock && _bindingView.viewModel == self ) {
        _configDataBlock( self, _bindingView, _bindingModel );
    }
}

/** 合并 bindingModel */
- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm
{
    [self ag_mergeModelFromDictionary:vm.bindingModel];
}

- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict
{
    dict.count > 0 ? [_bindingModel addEntriesFromDictionary:dict] : nil;
}

- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict byKeys:(NSArray<NSString *> *)keys
{
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj isKindOfClass:[NSString class]], @"key is not kind of NSString!");
        self[obj] = dict[obj];
    }];
}

- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm  byKeys:(NSArray<NSString *> *)keys
{
    [self ag_mergeModelFromDictionary:vm.bindingModel byKeys:keys];
}

#pragma mark - other method
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

#pragma mark - observer
#pragma mark readd observer
- (void) ag_readdObserver:(NSObject *)observer
                   forKey:(NSString *)key
                    block:(AGVMNotificationBlock)block
{
    [self.notifier ag_readdObserver:observer forKey:key block:block];
}

- (void) ag_readdObserver:(NSObject *)observer
                  forKeys:(NSArray<NSString *> *)keys
                    block:(AGVMNotificationBlock)block
{
    [self.notifier ag_readdObserver:observer forKeys:keys block:block];
}

- (void) ag_readdObserver:(NSObject *)observer forKey:(NSString *)key options:(NSKeyValueObservingOptions)options block:(AGVMNotificationBlock)block
{
    [self.notifier ag_readdObserver:observer forKey:key options:options block:block];
}

- (void)ag_readdObserver:(NSObject *)observer forKeys:(NSArray<NSString *> *)keys options:(NSKeyValueObservingOptions)options block:(AGVMNotificationBlock)block
{
    [self.notifier ag_readdObserver:observer forKeys:keys options:options block:block];
}

#pragma mark add observer
- (void) ag_addObserver:(NSObject *)observer
                 forKey:(NSString *)key
                  block:(AGVMNotificationBlock)block
{
    [self.notifier ag_addObserver:observer forKey:key block:block];
}

- (void) ag_addObserver:(NSObject *)observer
                forKeys:(NSArray<NSString *> *)keys
                  block:(AGVMNotificationBlock)block
{
    [self.notifier ag_addObserver:observer forKeys:keys block:block];
}

- (void) ag_addObserver:(NSObject *)observer
                 forKey:(NSString *)key
                options:(NSKeyValueObservingOptions)options
                  block:(AGVMNotificationBlock)block
{
    [self.notifier ag_addObserver:observer forKey:key options:options block:block];
}

- (void) ag_addObserver:(NSObject *)observer
                forKeys:(NSArray<NSString *> *)keys
                options:(NSKeyValueObservingOptions)options
                  block:(AGVMNotificationBlock)block
{
    [self.notifier ag_addObserver:observer forKeys:keys options:options block:block];
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

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    AGViewModel *vm = [[self.class allocWithZone:zone] initWithModel:_bindingModel];
    vm.status = _status;
    [vm ag_setBindingView:_bindingView configDataBlock:_configDataBlock];
    [vm ag_setDelegate:_delegate forIndexPath:_indexPath];
    return vm;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [[self.class allocWithZone:zone] initWithModel:[_bindingModel mutableCopy]];
}

#pragma mark - ------------ Override Methods --------------
- (id)objectForKeyedSubscript:(NSString *)key;
{
    NSAssert(key, @"key can't be nil.");
    return key ? _bindingModel[key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;
{
    NSAssert(key, @"key can't be nil.");
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
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"  _status       [assign] : %@, \n", @(_status)];
    [strM appendFormat:@"  _delegate     [ weak ] : %@, \n", _delegate];
    [strM appendFormat:@"  _notifier     (strong) : %@, \n", _notifier];
    [strM appendFormat:@"  _indexPath    ( copy ) : %@, \n", _indexPath];
    [strM appendFormat:@"  _bindingView  [ weak ] : <%@: %p>, \n", [_bindingView class], _bindingView];
    
    NSMutableString *bmStrM = [NSMutableString stringWithFormat:@"{\n"];
    [_bindingModel enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [bmStrM appendFormat:@"    %@ = %@, \n", key, obj];
    }];
    [bmStrM appendFormat:@"  }"];
    
    [strM appendFormat:@"  _bindingModel (strong) : %@,", bmStrM];
    return [NSString stringWithFormat:@"<%@: %p> --- {\n%@\n}", [self class] , self, strM];
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

@end



#pragma mark - Fast Funtion
/** fast create AGViewModel instance */
AGViewModel * ag_viewModel(NSDictionary *bindingModel)
{
    return [AGViewModel ag_viewModelWithModel:bindingModel];
}

/** fast create mutableDictionary */
NSMutableDictionary * ag_mutableDict(NSUInteger capacity)
{
    return [NSMutableDictionary dictionaryWithCapacity:capacity];
}

/** fast create mutableArray */
NSMutableArray * ag_mutableArray(NSUInteger capacity)
{
    return [NSMutableArray arrayWithCapacity:capacity];
}

/** fast create 可变数组函数, 包含 Null 对象 */
NSMutableArray * ag_mutableNullArray(NSUInteger capacity)
{
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        [arrM addObject:[NSNull null]];
    }
    return arrM;
}

#pragma mark - Safe Convert
id ag_safeObj(id obj, Class objClass)
{
	if ( [obj isKindOfClass:objClass] ) {
		return obj;
	}
	return nil;
}

#pragma mark 字典、数组
/** 验证是否为NSDictionary对象；是：返回原对象；否：返回nil */
NSDictionary * ag_safeDictionary(id obj)
{
	return ag_safeObj(obj, [NSDictionary class]);
}

/** 验证是否为NSMutableDictionary对象；是：返回原对象；否：返回nil */
NSMutableDictionary * ag_safeMutableDictionary(id obj)
{
	return ag_safeObj(obj, [NSMutableDictionary class]);
}

/** 验证是否为NSArray对象；是：返回原对象；否：返回nil */
NSArray * ag_safeArray(id obj)
{
	return ag_safeObj(obj, [NSArray class]);
}

/** 验证是否为NSMutableArray对象；是：返回原对象；否：返回nil */
NSMutableArray * ag_safeMutableArray(id obj)
{
	return ag_safeObj(obj, [NSMutableArray class]);
}

#pragma mark 字符串、数字
/** 验证是否为NSString对象；是：返回原对象；否：返回nil */
NSString * ag_safeString(id obj)
{
	return ag_safeObj(obj, [NSString class]);
}

/** 转换为NSString对象；能转为：返回NSString对象；不能：返回nil */
NSString * ag_convertSafeString(id obj)
{
	if ( [obj isKindOfClass:[NSString class]] ) {
		return obj;
	}
	else if ( [obj isKindOfClass:[NSNumber class]] ) {
		NSNumber *numObj = obj;
		return numObj.stringValue;
	}
	return nil;
}

/** 验证是否为NSNumber对象；是：返回原对象；否：返回nil */
NSNumber * ag_safeNumber(id obj)
{
	return ag_safeObj(obj, [NSNumber class]);
}
