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
+ (instancetype) newWithModel:(NSDictionary *)bindingModel
                     capacity:(NSInteger)capacity
{
    AGViewModel *vm = [[self alloc] initWithModel:ag_mutableDict(capacity)];
    [vm ag_mergeModelFromDictionary:bindingModel];
    return vm;
}

+ (instancetype) newWithModel:(NSDictionary *)bindingModel
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
- (void) ag_refreshUIByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
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
    if ( dict.count <= 0 ) {
        return;
    }
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj isKindOfClass:[NSString class]], @"Key is not kind of NSString!");
        self[obj] = dict[obj];
    }];
}

- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm byKeys:(NSArray<NSString *> *)keys
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

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    AGViewModel *vm = [[self.class allocWithZone:zone] initWithModel:_bindingModel];
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
    return [NSString stringWithFormat:@"♦️ <%@: %p> --- {\n%@\n}", [self class] , self, strM];
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

#pragma mark -
@implementation AGViewModel (AGVMObserverRegistration)
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
@end

#pragma mark -
@implementation AGViewModel (AGVMSafeAccessible)

#pragma mark safe number
- (id) ag_safeSetNumber:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetNumber:value forKey:key completion:nil];
}
- (NSNumber *) ag_safeNumberForKey:(NSString *)key
{
	return [self ag_safeNumberForKey:key completion:nil];
}
- (id) ag_safeSetNumber:(id)value forKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeSetCompletionBlock)block
{
	return [self _setNewObject:ag_safeNumber(value) forKey:key withObject:value completion:block];
}
- (NSNumber *) ag_safeNumberForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetCompletionBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeNumber(value) withObject:value completion:block];
}


#pragma mark safe string
- (id) ag_safeSetString:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetString:value forKey:key completion:nil];
}
- (NSString *) ag_safeStringForKey:(NSString *)key
{
	return [self ag_safeStringForKey:key completion:nil];
}
- (id) ag_safeSetString:(id)value forKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeSetCompletionBlock)block
{
	return [self _setNewObject:ag_safeString(value) forKey:key withObject:value completion:block];
}
- (NSString *) ag_safeStringForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetCompletionBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeString(value) withObject:value completion:block];
}
- (NSString *) ag_safeNumberStringForKey:(NSString *)key
{
    return [self ag_safeNumberStringForKey:key completion:nil];
}
- (NSString *) ag_safeNumberStringForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetCompletionBlock)block
{
    id value = self[key];
    return [self _getNewObject:ag_safeNumberString(value) withObject:value completion:block];
}



#pragma mark safe array
- (id) ag_safeSetArray:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetArray:value forKey:key completion:nil];
}
- (NSArray *) ag_safeArrayForKey:(NSString *)key
{
	return [self ag_safeArrayForKey:key completion:nil];
}
- (id) ag_safeSetArray:(id)value forKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeSetCompletionBlock)block
{
	return [self _setNewObject:ag_safeArray(value) forKey:key withObject:value completion:block];
}
- (NSArray *) ag_safeArrayForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetCompletionBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeArray(value) withObject:value completion:block];
}


#pragma mark safe dictionary
- (id) ag_safeSetDictionary:(id)value forKey:(NSString *)key
{
	return [self ag_safeSetDictionary:value forKey:key completion:nil];
}
- (NSDictionary *) ag_safeDictionaryForKey:(NSString *)key
{
	return [self ag_safeDictionaryForKey:key completion:nil];
}
- (id) ag_safeSetDictionary:(id)value forKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeSetCompletionBlock)block
{
	return [self _setNewObject:ag_safeDictionary(value) forKey:key withObject:value completion:block];
}
- (NSDictionary *) ag_safeDictionaryForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetCompletionBlock)block
{
	id value = self[key];
	return [self _getNewObject:ag_safeDictionary(value) withObject:value completion:block];
}


#pragma mark safe url
- (NSURL *) ag_safeURLForKey:(NSString *)key
{
	return [self ag_safeURLForKey:key completion:nil];
}
- (NSURL *) ag_safeURLForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetCompletionBlock)block
{
	id value = self[key];
	NSURL *url = ag_safeObj(value, [NSURL class]);
	if ( url == nil ) {
		NSString *urlStr = ag_safeString(value);
		if ( urlStr ) {
			url = [NSURL URLWithString:urlStr];
		}
	}
	return [self _getNewObject:url withObject:value completion:block];
}


#pragma mark safe value type
- (double) ag_safeDoubleValueForKey:(NSString *)key
{
	return [self ag_safeDoubleValueForKey:key completion:nil];
}
- (double) ag_safeDoubleValueForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(doubleValue)];
	NSNumber *number = [self _getNewNumber:respond withNumber:value completion:block];
	return [number doubleValue];
}


- (float) ag_safeFloatValueForKey:(NSString *)key
{
	return [self ag_safeFloatValueForKey:key completion:nil];
}
- (float) ag_safeFloatValueForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(floatValue)];
	NSNumber *number = [self _getNewNumber:respond withNumber:value completion:block];
	return [number floatValue];
}


- (int) ag_safeIntValueForKey:(NSString *)key
{
	return [self ag_safeIntValueForKey:key completion:nil];
}
- (int) ag_safeIntValueForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(intValue)];
	NSNumber *number = [self _getNewNumber:respond withNumber:value completion:block];
	return [number intValue];
}


- (NSInteger) ag_safeIntegerValueForKey:(NSString *)key
{
	return [self ag_safeIntegerValueForKey:key completion:nil];
}
- (NSInteger) ag_safeIntegerValueForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(integerValue)];
	NSNumber *number = [self _getNewNumber:respond withNumber:value completion:block];
	return [number integerValue];
}


- (long long) ag_safeLongLongValueForKey:(NSString *)key
{
	return [self ag_safeLongLongValueForKey:key completion:nil];
}
- (long long) ag_safeLongLongValueForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(longLongValue)];
	NSNumber *number = [self _getNewNumber:respond withNumber:value completion:block];
	return [number longLongValue];
}


- (BOOL) ag_safeBoolValueForKey:(NSString *)key
{
	return [self ag_safeBoolValueForKey:key completion:nil];
}
- (BOOL) ag_safeBoolValueForKey:(NSString *)key completion:(NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block
{
	id value = self[key];
	BOOL respond = [value respondsToSelector:@selector(boolValue)];
	NSNumber *number = [self _getNewNumber:respond withNumber:value completion:block];
	return [number boolValue];
}


#pragma mark - ---------- Private Methods ----------
- (id) _setNewObject:(id)newObj
              forKey:(NSString *)key
          withObject:(id)obj
          completion:(AGVMSafeSetCompletionBlock)block
{
	self[key] = newObj;
	block ? block(obj, newObj != nil) : nil;
	return newObj;
}

- (id) _getNewObject:(id)newObj
	      withObject:(id)obj
          completion:(AGVMSafeGetCompletionBlock)block
{
	if ( block ) {
		newObj = block(obj, newObj != nil);
	}
	return newObj;
}

- (NSNumber *) _getNewNumber:(BOOL)respond
				  withNumber:(id)obj
				  completion:(AGVMSafeGetNumberCompletionBlock)block
{
	if ( block ) {
		return block(obj, respond);
	}
	return respond ? obj : nil;
}

@end


@implementation AGViewModel (AGVMJSONTransformable)
- (NSString *) ag_toJSONStringWithExchangeKey:(AGViewModel *)vm
                              customTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    return ag_JSONStringWithDict(_bindingModel, vm, block);
}

- (NSString *)ag_toJSONStringWithCustomTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    return ag_JSONStringWithDict(_bindingModel, nil, block);
}

- (NSString *)ag_toJSONString
{
    return ag_JSONStringWithDict(_bindingModel, nil, nil);
}

@end

#pragma mark - Fast Funtion
/** Quickly create AGViewModel instance */
AGViewModel * ag_viewModel(NSDictionary *bindingModel)
{
    return [AGViewModel newWithModel:bindingModel];
}

/** Quickly create mutableDictionary */
NSMutableDictionary * ag_mutableDict(NSInteger capacity)
{
    return [NSMutableDictionary dictionaryWithCapacity:capacity];
}

/** Quickly create mutableArray */
NSMutableArray * ag_mutableArray(NSInteger capacity)
{
    return [NSMutableArray arrayWithCapacity:capacity];
}

/** Quickly create 可变数组函数, 包含 Null 对象 */
NSMutableArray * ag_mutableNullArray(NSInteger capacity)
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
    if ( obj == nil ) {
        return nil;
    }
    else if ( [obj isKindOfClass:objClass] ) {
        return obj;
    }
    else if ( [obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
//#ifdef DEBUG
//    NSLog(@"ag_safeObj(<%@: %p> != %@)", obj, obj, NSStringFromClass(objClass));
//#else
//
//#endif
    
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

/** 验证是否能转换为 NSString 对象；能转：返回 NSString 对象；不能：返回 nil */
NSString * ag_safeNumberString(id obj)
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

