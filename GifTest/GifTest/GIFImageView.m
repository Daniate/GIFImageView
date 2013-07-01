//
//  GIFImageView.m
//  GifTest
//
//  Created by Daniate on 13-6-28.
//  Copyright (c) 2013年 ChinaEBI. All rights reserved.
//

#import "GIFImageView.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GIFImageView ()
@property (nonatomic, assign) CGFloat maxPixelWidth;
@property (nonatomic, assign) CGFloat maxPixelHeight;
@property (nonatomic, assign) BOOL didSetAnimationImages;
@property (nonatomic, assign) BOOL didSetAnimationDuration;
- (NSArray *)framesFromData:(NSData *)data;
@end

@implementation GIFImageView

- (id)initWithGIFURL:(NSURL *)gifURL {
	return [[[GIFImageView class] alloc] initWithGIFData:[NSData dataWithContentsOfURL:gifURL]];
}

- (id)initWithGIFFile:(NSString *)gifFilePath {
	return [[[GIFImageView class] alloc] initWithGIFData:[NSData dataWithContentsOfFile:gifFilePath]];
}

- (id)initWithGIFData:(NSData *)gifData {
	self = [super init];
	if (self) {
		self.contentMode = UIViewContentModeCenter;
		self.animationImages = [self framesFromData:gifData];
		self.didSetAnimationImages = YES;
		self.bounds = CGRectMake(0, 0, self.maxPixelWidth, self.maxPixelHeight);
		[self startAnimating];
	}
	return self;
}

- (NSArray *)framesFromData:(NSData *)data {
	NSMutableArray *frames = nil;
	CFStringRef keyList[2];
	CFTypeRef valueList[2];
	keyList[0] = kCGImageSourceShouldCache;
	valueList[0] = kCFBooleanTrue;
	keyList[1] = kCGImageSourceShouldAllowFloat;
	valueList[1] = kCFBooleanTrue;
	CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, (const void **)keyList, valueList, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CGImageSourceRef imgSource = CGImageSourceCreateWithData((CFDataRef)data, options);
	CFRelease(options);
	if (imgSource == NULL) {
		fprintf(stderr, "Image source is NULL\n");
	} else {
		CFStringRef imgType = CGImageSourceGetType(imgSource);
		// make sure the image's format is GIF
		if ([(NSString *)imgType isEqualToString:(NSString *)kUTTypeGIF]) {
			// how many frames in the gif image
			size_t frameCount = CGImageSourceGetCount(imgSource);
			frames = [NSMutableArray arrayWithCapacity:frameCount];
			NSTimeInterval animationDuration = 0.0;
			for (size_t i = 0; i < frameCount; i++) {
				CFDictionaryRef propertyDic = CGImageSourceCopyPropertiesAtIndex(imgSource, i, NULL);
				// find the max pixel height
				CFNumberRef pixelHeightRef = CFDictionaryGetValue(propertyDic, kCGImagePropertyPixelHeight);
				CGFloat pixelHeight = [(NSNumber *)pixelHeightRef floatValue];
				if (pixelHeight > self.maxPixelHeight) {
					self.maxPixelHeight = pixelHeight;
				}
				// find the max pixel width
				CFNumberRef pixelWidthRef = CFDictionaryGetValue(propertyDic, kCGImagePropertyPixelWidth);
				CGFloat pixelWidth = [(NSNumber *)pixelWidthRef floatValue];
				if (pixelWidth > self.maxPixelWidth) {
					self.maxPixelWidth = pixelWidth;
				}
				// change the animation duration
				CFDictionaryRef gifDic = CFDictionaryGetValue(propertyDic, kCGImagePropertyGIFDictionary);
				CFStringRef delayTimeRef = CFDictionaryGetValue(gifDic, kCGImagePropertyGIFDelayTime);
				animationDuration += [(NSString *)delayTimeRef doubleValue];
				
				CFRelease(propertyDic);
				
				NSAutoreleasePool *pool = [NSAutoreleasePool new];
				CGImageRef imgRef = CGImageSourceCreateImageAtIndex(imgSource, i, NULL);
				if (imgRef) {
					UIImage *img = [UIImage imageWithCGImage:imgRef];
					CGImageRelease(imgRef);
					if (img) {
						[frames addObject:img];
					}
				}
				[pool release];
			}
			self.animationDuration = animationDuration;
			self.didSetAnimationDuration = YES;
		} else {
			fprintf(stderr, "Image is not GIF format\n");
		}
		CFRelease(imgSource);
	}
	return frames;
}

- (void)setAnimationImages:(NSArray *)animationImages {
	if (!self.didSetAnimationImages && !self.animationImages) {
		[super setAnimationImages:animationImages];
	}
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
	if (!self.didSetAnimationDuration && !self.animationImages) {
		[super setAnimationDuration:animationDuration];
	}
}

@end
