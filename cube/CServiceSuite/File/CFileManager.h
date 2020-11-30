//
//  CFileManager.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/11/30.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CFile;

@interface CFileManager : NSObject

/*
上传文件
@param fileURL 上传路径
*/
-(void)uploadFileWithURL:(NSString*)fileURL;

/*
下载文件文件
@param filePath 文件本地路径
*/
-(void)downloadFileWithPath:(NSString*)filePath;

/*
获取文件缩略图
@param file 文件
@return 缩略图路径
*/
-(NSString*)getThumbFromFile:(CFile*)file;

@end


