//
//  AGVerifyManager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGVerifyManager.h"
#import <objc/runtime.h>

@interface AGVerifyManager ()
<AGVerifyManagerVerifying>

/** first error */
@property (nonatomic, strong) AGVerifyError *firstError;

/** 错误数组 */
@property (nonatomic, strong) NSMutableArray<AGVerifyError *> *errorsM;

/** 执行验证器的 Block */
@property (nonatomic, copy) AGVerifyManagerVerifyingBlock verifyBlock;

/** 验证完成调用的 Block */
@property (nonatomic, copy) AGVerifyManagerCompletionBlock completionBlock;

@end

@implementation AGVerifyManager
#pragma mark - ---------- Public Methods ----------
- (AGVerifyManagerVerifyObjBlock)verifyObj
{
    __weak typeof(self) weakSelf = self;
	return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier,
							  id obj) {
        
        __strong typeof(weakSelf) self = weakSelf;
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(ag_verifyObj:)] )
			error = [verifier ag_verifyObj:obj];
		
		if ( error ) {
			// 有错
			self.firstError = self.firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
	};
}

- (AGVerifyManagerVerifyObjMsgBlock)verifyObjMsg
{
    __weak typeof(self) weakSelf = self;
	return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier,
							  id obj,
							  NSString *msg) {
        
		__strong typeof(weakSelf) self = weakSelf;
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(ag_verifyObj:)] )
			error = [verifier ag_verifyObj:obj];
		
		if ( error ) {
			// 有错
			error.msg = msg ?: error.msg;
			self.firstError = self.firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
		
	};
}

- (void)ag_executeVerify:(NS_NOESCAPE AGVerifyManagerVerifyingBlock)verifyBlock
              completion:(NS_NOESCAPE AGVerifyManagerCompletionBlock)completionBlock
{
    verifyBlock ? verifyBlock(self) : nil;
    completionBlock ? completionBlock(self.firstError, [self.errorsM copy]) : nil;
    self.firstError = nil;
    self.errorsM = nil;
}

- (void)ag_prepareVerify:(AGVerifyManagerVerifyingBlock)verifyBlock
              completion:(AGVerifyManagerCompletionBlock)completionBlock
{
    self.verifyBlock = verifyBlock ?: nil;
    self.completionBlock = completionBlock ?: nil;
}

- (void)ag_executeVerify
{
    _verifyBlock ? _verifyBlock(self) : nil;
    _completionBlock ? _completionBlock(self.firstError, [self.errorsM copy]) : nil;
    self.firstError = nil;
    self.errorsM = nil;
}

#pragma mark - ----------- Getter Methods ----------
- (NSMutableArray *)errorsM
{
    if (_errorsM == nil) {
        _errorsM = [NSMutableArray arrayWithCapacity:5];
    }
    return _errorsM;
}

@end


#pragma mark -
@implementation AGVerifyError

#pragma mark - ----------- Override Methods ----------
- (NSString *) debugDescription
{
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: @"nil";
        [dictM setObject:value forKey:name];
    }
    
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class] , self, dictM];
}

@end

AGVerifyManager * ag_verifyManager(void)
{
    return [AGVerifyManager new];
}

