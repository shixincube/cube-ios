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

#ifndef CMessageType_h
#define CMessageType_h

/*!
 * @brief 消息类型。
 */
typedef NS_ENUM(NSInteger, CMessageType) {

    CMessageTypeUnknown = 0,

    /*! 文字。 */
    CMessageTypeText,

    /*! 文件。 */
    CMessageTypeFile,

    /*! 图片。 */
    CMessageTypeImage,

    /*! 短语音。 */
    CMessageTypeVoice,

    /*! 视频。 */
    CMessageTypeVideo,

    /*! 链接。 */
    CMessageTypeURL,

    /*! 定位。 */
    CMessageTypeLocation,

    /*! 卡片。 */
    CMessageTypeCard,

    /*! 系统。 */
    CMessageTypeSystem,

    /*! 其他类型。 */
    CMessageTypeOther
};

#endif /* CMessageType_h */
