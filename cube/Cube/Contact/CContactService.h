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

#ifndef CContactService_h
#define CContactService_h

#import "CModule.h"
#import "CSelf.h"
#import "CGroup.h"

#ifndef CUBE_MODULE_CONTACT
/*! @brief 模块名。 */
#define CUBE_MODULE_CONTACT @"Contact"
#endif

typedef void (^sign_block_t)(CSelf *);

/*!
 * @brief 联系人模块。
 */
@interface CContactService : CModule

/*! 当前有效的在线联系人。 */
@property (nonatomic, strong) CSelf * myself;

/*! 默认回溯时长，默认值：30个自然天。 */
@property (nonatomic, assign) UInt64 defaultRetrospect;

/*!
 * @brief 初始化。
 */
- (instancetype)init;

/*!
 * @brief 签入当前终端的联系人。
 * @param mySelf 指定签入的 CSelf 对象。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 */
- (void)signIn:(CSelf *)mySelf handleSuccess:(sign_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure;

/*!
 * @brief 签入当前终端的联系人。
 * @param identity 指定签入的联系人 ID 。
 * @param name 指定签入联系人名称。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 */
- (void)signInWith:(UInt64)identity name:(NSString *)name handleSuccess:(sign_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure;

/*!
 * @brief 获取联系人的附录。
 * @param contact 指定联系人。
 * @param handleSuccess 操作成功时回调。
 * @param handleFailure 操作故障时回调。
 */
- (void)getAppendixWithContact:(CContact *)contact handleSuccess:(void(^)(CContact *, CContactAppendix *))handleSuccess handleFailure:(cube_failure_block_t)handleFailure;

/*!
 * @brief 获取群组的附录。
 * @param group 指定群组。
 * @param handleSuccess 操作成功时回调。
 * @param handleFailure 操作故障时回调。
 */
- (void)getAppendixWithGroup:(CGroup *)group handleSuccess:(void(^)(CGroup *, CGroupAppendix *))handleSuccess handleFailure:(cube_failure_block_t)handleFailure;

/*!
 * @brief 获取当前联系人所在的所有群。
 * @param beginning 指定查询群的起始的最近一次活跃时间戳，单位：毫秒。
 * @param ending 指定查询群的截止的最近一次活跃时间戳，单位：毫秒。
 * @param handler 获取到数据后的回调函数。
 */
- (void)listGroups:(UInt64)beginning ending:(UInt64)ending handler:(void(^)(NSArray *))handler;

/*!
 * @private
 */
- (void)fireSignInCompleted;

@end

#endif /* CContactService_h */
