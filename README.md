# QNUpload
七牛 单张或者多张上传图片


效果:

![七牛上传图片.gif](https://upload-images.jianshu.io/upload_images/1483397-dcc4ffe76677f56c.gif?imageMogr2/auto-orient/strip)

使用方法:
1. 传入获取token的URL；
2. 获取到token后传给上传图片的方法中，成功后拼接图片链接，域名后台会给。

```
 [HuUploadImgManage qiNiuUploadToken:@"请求七牛token的URL" success:^(NSString * _Nonnull token) {
      [HuUploadImgManage uploadMuchImage:_pictureArray view:self.view token:kToken success:^(NSArray * _Nonnull imgArrayUrl) {
          NSLog(@"图片上传成功:%@",imgArrayUrl);
      } failure:^(NSString * _Nonnull message) {
          NSLog(@"%@",message);
      }];

  }];
```
>PS:如有有疑问欢迎提问！
