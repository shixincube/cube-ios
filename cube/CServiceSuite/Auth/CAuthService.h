//
//  CAuthService.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CModule.h"
#import "CPipeline.h"
#import "CToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAuthService : CModule

@property (nonatomic , class , readonly) NSString *mName;


@property (nonatomic , weak) id <CPipelineListener> pipeListener;

-(void)check:(NSString *)domain appKey:(NSString *)appKey address:(NSString *)address completion:(void(^)(CToken *token))completion;

- (void)applyToken:(NSString *)domain appkey:(NSString *)appKey;

- (void)checkToken;




@end

NS_ASSUME_NONNULL_END
