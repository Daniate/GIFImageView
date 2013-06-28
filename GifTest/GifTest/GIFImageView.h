//
//  GIFImageView.h
//  GifTest
//
//  Created by Daniate on 13-6-28.
//  Copyright (c) 2013年 ChinaEBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIFImageView : UIImageView
- (id)initWithGIFURL:(NSURL *)gifURL;
- (id)initWithGIFFile:(NSString *)gifFilePath;
- (id)initWithGIFData:(NSData *)gifData;
@end
