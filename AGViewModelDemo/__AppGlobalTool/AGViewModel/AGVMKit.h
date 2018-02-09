//
//  AGVMKit.h
//  https://github.com/JohnnyB0Y/AGViewModel
//  http://www.jianshu.com/u/8939e3430d49
//  Created by JohnnyB0Y on 2017/8/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#ifndef AGVMKit_h
#define AGVMKit_h

#import "AGVMKeys.h"
#import "AGVMProtocol.h"
#import "AGVMFunction.h"
#import "NSString+AGCalculate.h"

#import "AGVMManager.h"
#import "AGVMSection.h"
#import "AGVMPackager.h"
#import "AGViewModel.h"

#import "UITableViewCell+AGViewModel.h"
#import "UICollectionViewCell+AGViewModel.h"

/** TODO 宏 */
#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO~" DEFER_STRINGIFY(__COUNTER__) "] " MSG " [LINE:" DEFER_STRINGIFY(__LINE__) "]"
#define AGTODO(MSG) PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


#endif /* AGVMKit_h */
