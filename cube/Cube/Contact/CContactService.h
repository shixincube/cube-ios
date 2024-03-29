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

#ifndef CContactService_h
#define CContactService_h

#import "CModule.h"

@class CSelf;
@class CContact;
@class CGroup;
@class CContactZone;
@class CContactAppendix;
@class CGroupAppendix;

#ifndef CUBE_MODULE_CONTACT
/*! @brief 模块名。 */
#define CUBE_MODULE_CONTACT @"Contact"
#endif

typedef void (^CSignBlock)(CSelf * owner);

typedef void (^CContactBlock)(CContact * contact);

typedef void (^CGroupBlock)(CGroup * group);

typedef void (^CContactZoneBlock)(CContactZone * contactZone);


/*!
 * @brief 联系人模块事件代理协议。
 */
@protocol CContactEventDelegate <NSObject>

@optional

- (NSDictionary *)needContactContext:(CContact *)contact;

@end



/*!
 * @brief 联系人模块。
 */
@interface CContactService : CModule

/*! 当前有效的在线联系人，即当前引擎签入的联系人。 */
@property (nonatomic, strong) CSelf * owner;

/*! 回溯时长，默认值：30个自然天。 */
@property (nonatomic, assign) UInt64 retrospectDuration;

/*! 联系人模块事件代理。 */
@property (nonatomic, weak) id<CContactEventDelegate> delegate;

/*!
 * @brief 初始化。
 */
- (instancetype)init;

/*!
 * @brief 签入当前终端的联系人。
 * @param me 指定签入的 @c CSelf 对象。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 * @return 如果返回 @c FALSE 表示当前状态下不能进行该操作，请检查是否正确启动魔方。
 */
- (BOOL)signIn:(CSelf *)me handleSuccess:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 签入当前终端的联系人。
 * @param identity 指定签入的联系人 ID 。
 * @param name 指定签入联系人名称。
 * @param context 指定上下文数据。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 * @return 如果返回 @c FALSE 表示当前状态下不能进行该操作，请检查是否正确启动魔方。
 */
- (BOOL)signInWith:(UInt64)identity name:(NSString *)name context:(NSDictionary *)context handleSuccess:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 将当前设置的联系人签出。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 * @return 是否执行了签出操作。
 */
- (BOOL)signOut:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 获取指定 ID 的联系人信息。
 * @param contactId 指定联系人 ID 。
 * @param handleSuccess 成功获取到数据回调该函数。
 * @param handleFailure 获取数据时故障回调该函数。
 */
- (void)getContact:(UInt64)contactId handleSuccess:(CContactBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 修改指定联系人名称。该操作仅影响本地数据库的数据。
 * @param contact 指定联系人。
 * @param name 指定新名称。
 */
- (void)modifyContactName:(CContact *)contact newName:(NSString *)name;

/*!
 * @brief 获取联系人的附录。
 * @param contact 指定联系人。
 * @param handleSuccess 操作成功时回调。
 * @param handleFailure 操作故障时回调。
 */
- (void)getAppendixWithContact:(CContact *)contact handleSuccess:(void(^)(CContact * contact, CContactAppendix * appendix))handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 获取群组的附录。
 * @param group 指定群组。
 * @param handleSuccess 操作成功时回调。
 * @param handleFailure 操作故障时回调。
 */
- (void)getAppendixWithGroup:(CGroup *)group handleSuccess:(void(^)(CGroup * contact, CGroupAppendix * appendix))handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 获取当前联系人所在的所有群。
 * @param beginning 指定查询群的起始的最近一次活跃时间戳，单位：毫秒。
 * @param ending 指定查询群的截止的最近一次活跃时间戳，单位：毫秒。
 * @param handler 获取到数据后的回调函数。
 */
- (void)listGroups:(UInt64)beginning ending:(UInt64)ending handler:(void(^)(NSArray *))handler;

/*!
 * @brief 获取指定名称的联系人分区。
 * @param zoneName 指定分区名称。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 */
- (void)getContactZone:(NSString *)zoneName handleSuccess:(void (^)(CContactZone * zone))handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 创建指定的联系人分区。
 * @param zoneName 指定分区名称。
 * @param displayName 指定分区显示名。如果不设置显示名，可设置为 @c nil 值。
 * @param contactIdList 指定分区的参与人 ID 列表。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 */
- (void)createContactZone:(NSString *)zoneName displayName:(NSString *)displayName contactIdList:(NSArray<__kindof NSNumber *> *)contactIdList handleSuccess:(void (^)(CContactZone * zone))handleSuccess handleFailure:(CFailureBlock)handleFailure;


- (void)getGroup:(UInt64)groupId handleSuccess:(CGroupBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @private
 */
- (void)fireSignInCompleted;

@end

#endif /* CContactService_h */
