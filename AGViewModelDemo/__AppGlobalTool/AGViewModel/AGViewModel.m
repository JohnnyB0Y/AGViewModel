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
    _configDataBlock    = configDataBlock;
    
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
        self[kAGVMViewW] = @(bindingViewS.width);
        self[kAGVMViewH] = @(bindingViewS.height);
    }
    return bindingViewS;
}

#pragma mark help method
- (void) ag_refreshViewByUpdateModelInBlock:(AGVMUpdateModelBlock)block
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

#pragma mark - other method
- (void)ag_callDelegateToDoForInfo:(NSDictionary *)info
{
    if ( _responeMethod.ag_callDelegateToDoForInfo ) {
        [_delegate ag_viewModel:self callDelegateToDoForInfo:info];
    }
}

- (void)ag_callDelegateToDoForViewModel:(AGViewModel *)info
{
    if ( _responeMethod.ag_callDelegateToDoForViewModel ) {
        [_delegate ag_viewModel:self callDelegateToDoForViewModel:info];
    }
}

- (void)ag_callDelegateToDoForAction:(SEL)action
{
    if ( _responeMethod.ag_callDelegateToDoForAction ) {
        [_delegate ag_viewModel:self callDelegateToDoForAction:action];
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
    [strM appendFormat:@"_status      : %@, \n", @(_status)];
    [strM appendFormat:@"_delegate    : %@, \n", _delegate];
    [strM appendFormat:@"_notifier    : %@, \n", _notifier];
    [strM appendFormat:@"_indexPath   : %@, \n", _indexPath];
    [strM appendFormat:@"_bindingView : <%@: %p>, \n", [_bindingView class], _bindingView];
    [strM appendFormat:@"_bindingModel: %@,", _bindingModel];
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
}

#pragma mark - ----------- Getter Methods ----------
- (AGVMNotifier *)notifier
{
    if (_notifier == nil) {
        _notifier = [AGVMNotifier ag_VMNotifierWithViewModel:self];
    }
    return _notifier;
}

@end



#pragma mark - fast funtion
/** fast create AGViewModel instance */
AGViewModel * ag_viewModel(NSDictionary *bindingModel)
{
    return [AGViewModel ag_viewModelWithModel:bindingModel];
}

/** fast create 可变字典函数 */
NSMutableDictionary * ag_mutableDict(NSUInteger capacity)
{
    return [NSMutableDictionary dictionaryWithCapacity:capacity];
}

/** fast create 可变数组函数 */
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

