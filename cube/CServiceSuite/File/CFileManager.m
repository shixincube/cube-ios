//
//  CFileManager.m
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/11/30.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CFileManager.h"
#import "CFile.h"

@implementation CFileManager

-(void)uploadFileWithURL:(NSString*)fileURL{
    //TODO
}

-(void)downloadFileWithPath:(NSString*)filePath{
    //TODO
}

-(NSString*)getThumbFromFile:(CFile*)file{
    if(file.fileType != CFileTypeImage && file.fileType != CFileTypeVideo){return nil;}
    
    
}

@end
