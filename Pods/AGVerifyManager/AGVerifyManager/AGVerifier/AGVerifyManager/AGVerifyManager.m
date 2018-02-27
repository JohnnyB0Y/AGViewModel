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

/** first error */
@property (nonatomic, strong) AGVerifyError *firstError;

/** 错误数组 */
@property (nonatomic, strong) NSMutableArray<AGVerifyError *> *errorsM;

@end

@implementation AGVerifyManager
#pragma mark - ---------- Public Methods ----------
- (AGVerifyManager *(^)(id<AGVerifyManagerVerifiable>))verify
{
    return ^AGVerifyManager *(id<AGVerifyManagerVerifiable> verifier) {
        // 判断错误
        AGVerifyError *error;
        if ( [verifier respondsToSelector:@selector(verify)] )
            error = [verifier verify];
        
        if ( error ) {
            // 有错
            _firstError = _firstError ?: error;
            
            // 打包错误
            [self.errorsM addObject:error];
        }
        return self;
    };
}

- (AGVerifyManager * _Nonnull (^)(id<AGVerifyManagerInjectVerifiable> _Nonnull,
								  id _Nonnull))verify_Obj
{
	return ^AGVerifyManager *(id<AGVerifyManagerInjectVerifiable> verifier,
							  id obj) {
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(verifyObj:)] )
			error = [verifier verifyObj:obj];
		
		if ( error ) {
			// 有错
			_firstError = _firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
	};
}

- (AGVerifyManager * _Nonnull (^)(id<AGVerifyManagerInjectVerifiable> _Nonnull,
								  id _Nonnull,
								  NSString * _Nullable))verify_Obj_Msg
{
	return ^AGVerifyManager *(id<AGVerifyManagerInjectVerifiable> verifier,
							  id obj,
							  NSString *msg) {
		
		// 判断错误
		AGVerifyError *error;
		if ( [verifier respondsToSelector:@selector(verifyObj:)] )
			error = [verifier verifyObj:obj];
		
		if ( error ) {
			// 有错
			error.msg = msg ?: error.msg;
			_firstError = _firstError ?: error;
			
			// 打包错误
			[self.errorsM addObject:error];
		}
		return self;
		
	};
}

- (AGVerifyManager *)verified:(AGVerifyManagerVerifiedBlock)verifiedBlock
{
    verifiedBlock ? verifiedBlock(self.firstError, [self.errorsM copy]) : nil;
    self.firstError = nil;
    self.errorsM = nil;
    return self;
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

AGVerifyManager * ag_verifyManager()
{
    return [AGVerifyManager new];
}

