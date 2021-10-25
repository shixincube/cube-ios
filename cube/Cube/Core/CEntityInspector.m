/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "CEntityInspector.h"
#import "CUtils.h"

@interface CEntityInspector ()

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) NSMutableArray<__kindof NSMutableDictionary<__kindof NSString *, __kindof CEntity *> *> * depositedMapArray;

@end

@implementation CEntityInspector

- (instancetype)init {
    if (self = [super init]) {
        self.depositedMapArray = [[NSMutableArray alloc] init];

        NSTimeInterval interval = 30;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self onTick];
        }];
    }

    return self;
}

- (void)dealloc {
    [self.depositedMapArray removeAllObjects];

    if (nil != self.timer) {
        [self.timer invalidate];
    }
}

- (void)depositMap:(NSMutableDictionary<__kindof NSString *, __kindof CEntity *> *)map {
    [self.depositedMapArray addObject:map];
}

- (void)withdrawMap:(NSMutableDictionary<__kindof NSString *, __kindof CEntity *> *)map {
    [self.depositedMapArray removeObject:map];
}

- (void)destroy {
    [self.depositedMapArray removeAllObjects];

    if (nil != self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Private

- (void)onTick {
    NSLog(@"CEntityInspector#onTick size : %ld", self.depositedMapArray.count);

    UInt64 now = [CUtils currentTimeMillis];
    // 遍历映射列表
    for (NSMutableDictionary<__kindof NSString *, __kindof CEntity *> * map in self.depositedMapArray) {
        NSArray<__kindof NSString *> * keyArray = [[NSArray alloc] initWithArray:[map allKeys]];
        for (NSString * key in keyArray) {
            CEntity * entity = [map objectForKey:key];
            if (now - entity.entityCreation > CUBE_MEMORY_LIFECYCLE) {
                // 超期，从内存里移除
                [map removeObjectForKey:key];
            }
        }
    }
}

@end
