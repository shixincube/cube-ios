/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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

#import <Foundation/Foundation.h>
#import "CPluginSystem.h"

/*!
 * @brief 哑元钩子。
 */
@interface CDummyHook : CHook

- (instancetype)init;

@end

@implementation CDummyHook

- (instancetype)init {
    if (self = [super initWithName:@"CubeDummyHook"]) {
    }
    return self;
}

- (id)apply:(id)data {
    return data;
}

@end

#pragma mark - CPluginSystem

@interface CPluginSystem () {
    
    NSMutableDictionary <NSString *, __kindof CHook *> * _hooks;
    
    NSMutableDictionary <NSString *, __kindof NSMutableArray *> * _plugins;
    
    CDummyHook * _dummyHook;
}

@end


@implementation CPluginSystem

- (instancetype)init {
    if (self = [super init]) {
        _hooks = [[NSMutableDictionary alloc] init];
        _plugins = [[NSMutableDictionary alloc] init];
        _dummyHook = [[CDummyHook alloc] init];
    }

    return self;
}

- (void)addHook:(CHook *)hook {
    hook.system = self;
    [_hooks setValue:hook forKey:hook.name];
}

- (void)removeHook:(CHook *)hook {
    [_hooks removeObjectForKey:hook.name];
    hook.system = nil;
}

- (CHook *)getHook:(NSString *)name {
    CHook * hook = [_hooks objectForKey:name];
    if (hook) {
        return hook;
    }

    return _dummyHook;
}

- (void)clearHooks {
    [_hooks removeAllObjects];
}

- (void)registerPlugin:(NSString *)name plugin:(id<CPlugin>)plugin {
    NSMutableArray * list = [_plugins objectForKey:name];
    if (list) {
        if (![list containsObject:plugin]) {
            [list addObject:plugin];
        }
    }
    else {
        list = [[NSMutableArray alloc] init];
        [list addObject:plugin];
        [_plugins setObject:list forKey:name];
    }
}

- (void)deregisterPlugin:(NSString *)name plugin:(id<CPlugin>)plugin {
    NSMutableArray * list = [_plugins objectForKey:name];
    if (list) {
        [list removeObject:plugin];
    }
}

- (void)clearPlugins {
    [_plugins removeAllObjects];
}

- (id)syncApply:(NSString *)name data:(id)data {
    NSMutableArray * list = [_plugins objectForKey:name];
    if (list) {
        id result = data;
        for (id<CPlugin> value in list) {
            result = [value onEvent:name data:result];
        }
        return result;
    }
    else {
        return data;
    }
}

@end
