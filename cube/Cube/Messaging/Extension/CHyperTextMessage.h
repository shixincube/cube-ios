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

#ifndef CHyperTextMessage_h
#define CHyperTextMessage_h

#import "CTypeableMessage.h"

/*!
 * @brief 内容格式描述。
 */
typedef enum _CFormattedContentFormat {
    /*! @brief 一般文本格式。 */
    CFormattedContentFormatText,

    /*! @brief 提醒联系人格式。 */
    CFormattedContentFormatAt,

    /*! @brief 表情符号格式。 */
    CFormattedContentFormatEmoji,

    /*! @brief 未知格式。 */
    CFormattedContentFormatUnknown = 99
} CFormattedContentFormat;


/*!
 * @brief 格式化的内容。
 */
@interface CFormattedContent : NSObject

/*! @brief 内容格式。 */
@property (nonatomic, assign) CFormattedContentFormat format;

/*! @brief 内容。 */
@property (nonatomic, strong) NSDictionary * content;

/*!
 * @brief 使用格式化内容初始化。
 * @param format 指定格式。
 * @param content 指定内容。
 * @return 返回 @c CFormattedContent 实例。
 */
- (instancetype)initWithFormat:(CFormattedContentFormat)format content:(NSDictionary *)content;

@end


/*!
 * @brief 超文本消息。
 */
@interface CHyperTextMessage : CTypeableMessage

/*! @brief 格式化的内容。 */
@property (nonatomic, strong, readonly) NSMutableArray <__kindof CFormattedContent *> * formattedContents;

/*! @brief 平滑文本内容。 */
@property (nonatomic, strong, readonly) NSString * plaintext;

/*! @brief 属性化字符串内容。 */
@property (nonatomic, strong, readonly) NSAttributedString * attributedText;


/*!
 * @brief 使用文本内容进行初始化。
 * @param text 指定文本内容。
 * @return 返回 @c CHyperTextMessage 实例。
 */
- (instancetype)initWithText:(NSString *)text;


/*!
 * @brief 使用文本内容作为数据初始化超文本消息。
 * @param text 指定文本内容。
 * @return 返回 @c CHyperTextMessage 实例。
 */
+ (CHyperTextMessage *)messageWithText:(NSString *)text;

@end

#endif /* CHyperTextMessage_h */
