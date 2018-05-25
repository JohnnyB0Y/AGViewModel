//
//  AGDocumentVMGenerator.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/12/1.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGDocumentVMGenerator.h"
#import "AGGlobalVMKeys.h"
#import "GZPSItemHeaderView.h"
#import "GZPSItemDetailCell.h"

@implementation AGDocumentVMGenerator

- (AGVMManager *) documentVMM
{
    if (_documentVMM == nil) {
        _documentVMM = ag_VMManager(5);
        
        [_documentVMM ag_packageSection:^(AGVMSection * _Nonnull vms) {
            
            [vms ag_packageHeaderData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMItemTitle] = @"赤壁";
                package[kAGVMItemSubTitle] = @"唐代：杜牧";
                package[kAGVMViewH] = @54.;
                package[kAGVMViewClass] = [GZPSItemHeaderView class];
                
                // 数据
                AGVMSection *subVMS = ag_VMSection(2);
                [subVMS ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                    package[kAGVMItemDetail] = @"折戟沉沙铁未销，自将磨洗认前朝。";
                    package[kAGVMViewClass] = [GZPSItemDetailCell class];
                }];
                
                [subVMS ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                    package[kAGVMItemDetail] = @"东风不与周郎便，铜雀春深锁二乔。";
                    package[kAGVMViewClass] = [GZPSItemDetailCell class];
                }];
                
                package[kAGVMSection] = subVMS;
                
            }];
            
        } capacity:1];
        
        [_documentVMM ag_packageSection:^(AGVMSection * _Nonnull vms) {
            
            [vms ag_packageHeaderData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMItemTitle] = @"蝉";
                package[kAGVMItemSubTitle] = @"唐代：李商隐";
                package[kAGVMViewH] = @54.;
                package[kAGVMViewClass] = [GZPSItemHeaderView class];
                
                // 数据
                AGVMSection *subVMS = ag_VMSection(1);
                [subVMS ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                    package[kAGVMItemDetail] = @"本以高难饱，徒劳恨费声。\
                    \n五更疏欲断，一树碧无情。\
                    \n薄宦梗犹泛，故园芜已平。\
                    \n烦君最相警，我亦举家清。";
                    package[kAGVMViewClass] = [GZPSItemDetailCell class];
                }];
                
                [subVMS ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                    package[kAGVMItemDetail] = @"译文\n你栖身高枝之上才难以饱腹，悲鸣传恨无人理会白费其声。\n五更以后疏落之声几近断绝，满树碧绿依然如故毫不动情。\n我官职卑下像桃梗漂流不定，家园长期荒芜杂草早已长平。\n烦劳你的鸣叫让我能够警醒，我是一贫如洗全家水一样清。\n\n注释\n⑴以：因。薄宦：指官职卑微。高难饱：古人认为蝉栖于高处，餐风饮露，故说“高难饱”。\n⑵恨费声：因恨而连声悲鸣。费，徒然。\n⑶五更（gēng）：中国古代把夜晚分成五个时段，用鼓打更报时，所以叫“五更”。疏欲断：指蝉声稀疏，接近断绝。\n⑷碧：绿。\n⑸薄宦：官职卑微。梗犹泛：典出《战国策·齐策》：土偶人对桃梗说：“今子东国之桃梗也，刻削子以为人，降雨下，淄水至，流子而去，则子漂漂者将何如耳。”后以梗泛比喻漂泊不定，孤苦无依。梗，指树木的枝条。\n⑹故园：对往日家园的称呼，故乡。芜已平：荒草已经平齐没胫，覆盖田地。芜，荒草。平，指杂草长得齐平。\n⑺君：指蝉。警：提醒。\n⑻亦：也。举家清：全家清贫。举，全。清，清贫，清高。";
                    
                    package[kAGVMViewClass] = [GZPSItemDetailCell class];
                }];
                
                package[kAGVMSection] = subVMS;
                
            }];
            
        } capacity:1];
        
    }
    return _documentVMM;
}

@end
