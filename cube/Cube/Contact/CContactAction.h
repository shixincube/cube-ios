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

#ifndef CContactAction_h
#define CContactAction_h

/*!
 * @brief 指定当前客户端对应的联系人信息并签入。
 */
#define CUBE_CONTACT_SIGNIN @"signIn"

/*!
 * @brief 指定当前客户端的联系人签出。
 */
#define CUBE_CONTACT_SIGNOUT @"signOut"

/*!
 * @brief 恢复终端当前连接。
 */
#define CUBE_CONTACT_COMEBACK @"comeback"

/*!
 * @brief 当前联系人的所有端都脱机。
 */
#define CUBE_CONTACT_LEAVE @"leave"

/*!
 * @brief 获取指定联系人的信息。
 */
#define CUBE_CONTACT_GETCONTACT @"getContact"

/*!
 * @brief 修改联系人信息。
 */
#define CUBE_CONTACT_MODIFYCONTACT @"modifyContact"

/*!
 * @brief 获取联系人分区。
 */
#define CUBE_CONTACT_GETCONTACTZONE @"getContactZone"

/*!
 * @brief 创建联系人分区。
 */
#define CUBE_CONTACT_CREATECONTACTZONE @"createContactZone"

/*!
 * @brief 删除联系人分区。
 */
#define CUBE_CONTACT_DELETECONTACTZONE @"deleteContactZone"

/*!
 * @brief 联系人是否在分区。
 */
#define CUBE_CONTACT_CONTAINSCONTACTINZONE @"containsContactInZone"

/*!
 * @brief 添加联系人到分区。
 */
#define CUBE_CONTACT_ADDCONTACTTOZONE @"addContactToZone"

/*!
 * @brief 从分区移除联系人。
 */
#define CUBE_CONTACT_REMOVECONTACTFROMZONE @"removeContactFromZone"

/*!
 * @brief 获取指定群组的信息。
 */
#define CUBE_CONTACT_GETGROUP @"getGroup"

/*!
 * @brief 列出所有本人相关的群组。
 */
#define CUBE_CONTACT_LISTGROUPS @"listGroups"

/*!
 * @brief 创建群组。
 */
#define CUBE_CONTACT_CREATEGROUP @"createGroup"

/*!
 * @brief 解散群组。
 */
#define CUBE_CONTACT_DISSOLVEGROUP @"dissolveGroup"

/*!
 * @brief 向群组添加成员。
 */
#define CUBE_CONTACT_ADDGROUPMEMBER @"addGroupMember"

/*!
 * @brief 从群组移除成员。
 */
#define CUBE_CONTACT_REMOVEGROUPMEMBER @"removeGroupMember"

/*!
 * @brief 修改群组信息。
 */
#define CUBE_CONTACT_MODIFYGROUP @"modifyGroup"

/*!
 * @brief 修改群组内成员的信息。
 */
#define CUBE_CONTACT_MODIFYGROUPMEMBER @"modifyGroupMember"

/*!
 * @brief 获取指定的附录。
 */
#define CUBE_CONTACT_GETAPPENDIX @"getAppendix"

/*!
 * @brief 更新附录。
 */
#define CUBE_CONTACT_UPDATEAPPENDIX @"updateAppendix"

/*!
 * @brief 群组的附录已更新。
 */
#define CUBE_CONTACT_GROUPAPPENDIXUPDATED @"groupAppendixUpdated"

/*!
 * @brief 联系人的阻止列表操作。
 */
#define CUBE_CONTACT_BLOCKLIST @"blockList"

/*!
 * @brief 置顶操作。
 */
#define CUBE_CONTACT_TOPLIST @"topList"

/*!
 * @brief 搜索联系人或群组。
 */
#define CUBE_CONTACT_SEARCH @"search"

#endif /* CContactAction_h */
