//
//  CFile.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/11/30.
//  Copyright © 2020 Ashine. All rights reserved.
//

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


