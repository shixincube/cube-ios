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

#ifndef CubeContactsItemModel_h
#define CubeContactsItemModel_h

#import <Foundation/Foundation.h>

@interface CubeContactsItemModel : NSObject

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) NSString * imageName;

@property (nonatomic, strong) NSString * imageURL;

@property (nonatomic, strong) NSString * title;

@property (nonatomic, strong) NSString * subTitle;

@property (nonatomic, strong) UIImage * placeholderImage;

@property (nonatomic, strong) id customData;

+ (CubeContactsItemModel *)modelWithTag:(NSInteger)tag imageName:(NSString *)imageName imageURL:(NSString *)imageURL title:(NSString *)title subTitle:(NSString *)subTitle customData:(id)customData;

+ (CubeContactsItemModel *)modelWithContact:(CContact *)contact;

@end

#endif /* CubeContactsItemModel_h */
