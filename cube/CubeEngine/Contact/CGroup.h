/**
* This file is part of Cube.
*
* The MIT License (MIT)
*
* Copyright (c) 2020 Shixin Cube Team.
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

#import <CServiceSuite/CServiceSuite.h>

typedef NS_ENUM(NSUInteger, CGroupState) {
    CGroupStateNormal,        //普通
    CGroupStateDismissed,    //解散
    CGroupStateForbidden,   //禁用
    CGroupStateHighRisk,   //高风险
    CGroupStateDisabled,  //失效
    CGroupStateOther,    //其他
};


@interface CGroup : CContact

//创建人
@property (nonatomic ,strong) CContact *owner;
//成员
@property (nonatomic ,copy) NSArray<CContact*> *members;
//创建时间
@property (nonatomic ,strong) NSNumber *creationTime;
//活跃时间
@property (nonatomic ,strong) NSNumber *lastActiveTime;
//状态
@property (nonatomic ,assign) CGroupState state;

-(instancetype)createGroup:(NSString *)newName;
-(void)modifyName:(NSString *)newName;
-(void)changeOwner:(CContact*)newOwner;
-(BOOL)isOwner:(CContact*)contact;
-(void)addMmeber:(NSArray<CContact*> *)contacts;


@end


