//
//  NSNotification+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/11/28.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AGViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface NSNotification (AGViewModel)

@property (nonatomic, strong, readonly) AGViewModel *viewModel;

+ (instancetype) notificationWithName:(NSNotificationName)aName
                               object:(nullable id)anObject
                            viewModel:(nullable AGViewModel *)vm;

@end

NS_ASSUME_NONNULL_END
