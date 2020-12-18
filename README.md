# Cube for iOS

**Cube** **时信魔方** 是面向开发者的实时协作开发框架。帮助开发者快速、高效的在项目中集成实时协作能力。

支持的操作系统有：Windows、Linux 、macOS 、Android、iOS 等，支持的浏览器有：Chrome、Firefox、Safari 等。

## 简介

TODO


## 功能列表

Cube 包含以下协作功能：

* 即时消息（Instant Messaging / IM）。支持卡片消息、通知消息、文件消息和自定义消息等。
* 实时多人语音/多人视频（Multipoint RTC）。支持自适应码率、超低延迟等，支持实时图像识别等。
* 超大规模(100+)会议 （Video Conference）。支持会议控制、演讲模式，自定义 MCU 和 SFU 布局等。
* 群组管理（Group management）。支持集成式管理和扩展组织架构等。
* 共享桌面（Remote Desktop Sharing）。支持无缝集成白板等。
* 云端文件存储（Cloud File Storage）。支持无缝集成文档在线协作等。
* 实时白板（Realtime Whiteboard）。支持集成媒体回放、远程桌面和文档分享等。
* 视频直播（Live video）。支持第三方推流和 CDN ，无缝支持会议直播和回放等。
* 互动课堂（Online Classroom）。支持实时课堂互动和在线习题、考试。
* 电子邮件管理与代收发（Email management）。
* 在线文档协作（Online Document Collaboration）。支持 Word、PowerPoint、Excel 等主流格式文多人在写协作。
* 安全与运维管理（Operation and Maintenance management）。所有数据通道支持加密，可支持国密算法等。
* 风控管理（Risk Management）。对系统内所有文本、图片、视频、文件等内容进行包括 NLP、OCR、IR 等技术手段的风险控制和预警等。


## 快速集成

1.下载cube源码工程到你本地,运行cube源码工程文件,找到工程Products文件夹CServiceSuite.framework右键show in finder找到编译完成的cube库.

2.将上一步得到的cube库通过右键Add Files to "Your project"添加到你的工程文件中,然后选中project->target,找到Build phases栏使用“+”号增加Embed Frameworks Destination选择Frameworks使用下方的“+”号添加刚才加入到你工程文件中的cube库.


## 如何使用

你可以参照源码demo工程的方式引入并使用cube库.

或者使用如下方式:

在你的工程pch文件使用以下方式导入引擎库头文件

```objc
#import <CServiceSuite/CServiceSuite.h>
```

配置cube

```objc
CKernelConfig *config = [[CKernelConfig alloc] init];
config.domain = @"shixincube.com";
config.appKey = @"shixin-cubeteam-opensource-appkey";
config.address = @"192.168.1.113";
[[CEngine shareEngine] startWithConfig:config];
```

登入账户

```objc
[[CEngine shareEngine] signIn:@"102030405" name:@"MyApp用户的显示名"]; 
```

消息发送

```objc
CMessageService *messageService = (CMessageService *)[[CKernel shareKernel] getModule:CMessageService.mName];
CMessage *message = [[CMessage alloc] initWithPayload:@{@"content":content}];
[messageService sendToContact:@"908070605" message:message];
```

更多功能请参照Cube手册和api文档

## 功能展示

| 即时消息 |
|:----:|
|![IM](https://static.shixincube.com/cube/assets/showcase/im.gif)|

| 视频聊天(1) | 视频聊天(2) |
|:----:|:----:|
|![VideoChat1](https://static.shixincube.com/cube/assets/showcase/videochat_1.gif)|![VideoChat2](https://static.shixincube.com/cube/assets/showcase/videochat_2.gif)|

| 多人视频聊天(1) | 多人视频聊天(2) |
|:----:|:----:|
|![VideoChat3](https://static.shixincube.com/cube/assets/showcase/videochat_3.gif)|![VideoChat4](https://static.shixincube.com/cube/assets/showcase/videochat_4.gif)|

| 会议 |
|:----:|
|![Conf100](https://static.shixincube.com/cube/assets/showcase/screen_conference.jpg)|
|![ConfTile](https://static.shixincube.com/cube/assets/showcase/screen_conference_tile.jpg)|
|![StartConf](https://static.shixincube.com/cube/assets/showcase/start_conference.gif)|

| 共享桌面 |
|:----:|
|![ScreenSharing](https://static.shixincube.com/cube/assets/showcase/screen_sharing.gif)|

| 云端文件存储 |
|:----:|
|![CFS](https://static.shixincube.com/cube/assets/showcase/cloud_file.gif)|

| 白板 |
|:----:|
|![Whiteboard](https://static.shixincube.com/cube/assets/showcase/whiteboard.gif)|

| 直播 |
|:----:|
|![Live](https://static.shixincube.com/cube/assets/showcase/live.gif)|

| 在线课堂 |
|:----:|
|![OnlineClassroom](https://static.shixincube.com/cube/assets/showcase/online_classroom.gif)|

| 文档协作 |
|:----:|
|![DocCollaboration](https://static.shixincube.com/cube/assets/showcase/doc_collaboration_excel.gif)|
|![DocCollaboration](https://static.shixincube.com/cube/assets/showcase/doc_collaboration.gif)|


## 获得帮助

您可以访问 [时信魔方官网](https://www.shixincube.com/) 获得更多信息。如果您在使用 Cube 的过程中需要帮助可以发送邮件到 [cube@spap.com](mailto:cube@spap.com) 。
