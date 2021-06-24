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

typedef NS_ENUM(NSUInteger, CFileType) {
    CFileTypeNormal,//普通文件
    CFileTypeImage,//图片文件
    CFileTypeVideo,//视频文件
    CFileTypeOther,//其他
};


typedef NS_ENUM(NSUInteger, CFileDownloadState) {
    CFileDownloadStateNormal,
    CFileDownloadStateIng,
    CFileDownloadStateSuccess,
    CFileDownloadStateFail,
};

//文件实体
@interface CFile : CEntity


//文件ID
@property (nonatomic ,copy)   NSString *fileID;
//文件名称
@property (nonatomic ,copy)   NSString *fileName;
//远程文件地址
@property (nonatomic ,copy)   NSString *fileURL;
//缩略图路径
@property (nonatomic ,copy)   NSString *thumbPath;
//本地文件路径
@property (nonatomic ,copy)   NSString *filePath;
//文件类别
@property (nonatomic ,assign) CFileType fileType;

//下载状态
@property (nonatomic ,assign) CFileDownloadState downloadType;


@end


