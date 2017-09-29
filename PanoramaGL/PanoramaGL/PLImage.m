/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PLImage.h"
#import "PLLog.h"

@interface PLImage(Private)

-(void)createWithPath:(NSString *)path;
-(void)createWithSize:(CGSize)size;
-(void)createWithCGImage:(CGImageRef)image;
-(void)createWithBuffer:(NSData *)buffer;

-(PLImage *)mirroredByOrientation:(UIImageOrientation)orient;

-(void)deleteImage;

@end

@implementation PLImage

#pragma mark -
#pragma mark init methods

-(id)init
{
	if(self = [super init])
		[self createWithSize:CGSizeMake(0.0f,0.0f)];
	return self;
}

-(id)initWithCGImage:(CGImageRef)image
{
	if(self = [super init])
		[self createWithCGImage:image];
	return self;
}

-(id)initWithSize:(CGSize) size
{
	if(self = [super init])
		[self createWithSize:size];
	return self;
}

-(id)initWithDimensions:(NSUInteger)w :(NSUInteger)h
{
	return [self initWithSize:CGSizeMake(w, h)];
}

-(id)initWithPath:(NSString *)path
{
	if(self = [super init])
		[self createWithPath:path];
	return self;
}

-(id)initWithBuffer:(NSData *)buffer
{
	if(self = [super init])
		[self createWithBuffer:buffer];
	return self;
}

+(id)imageWithCGImage:(CGImageRef)image
{
	return [[[PLImage alloc] initWithCGImage:image] autorelease];
}

+(id)imageWithSize:(CGSize)size
{
	return [[[PLImage alloc] initWithSize:size] autorelease];
}

+(id)imageWithDimensions:(NSUInteger)width :(NSUInteger)height
{
	return [[[PLImage alloc] initWithDimensions:width :height] autorelease];
}

+(id)imageWithSizeZero
{
	return [[[PLImage alloc] init] autorelease];
}

+(id)imageWithPath:(NSString *)path
{
	return [[[PLImage alloc] initWithPath:path] autorelease];
}

+(id)imageWithBuffer:(NSData *)buffer
{
	return [[[PLImage alloc] initWithBuffer:buffer] autorelease];
}

#pragma mark -
#pragma mark create methods

-(void)createWithPath:(NSString *)path
{
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
	if(!image)
		[NSException raise:@"createWithPath: Path not found" format:@"createWithPath: Path not found"];
	cgImage = CGImageRetain(image.CGImage);
	width = CGImageGetWidth(cgImage);
	height = CGImageGetHeight(cgImage);
	[image release];
}

-(void)createWithCGImage:(CGImageRef)image
{
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	cgImage = CGImageCreateWithImageInRect(image, CGRectMake(0.0f, 0.0f, width, height));
}

-(void)createWithSize:(CGSize)size
{
    
//	UIGraphicsBeginImageContext(CGRectMake(0.0f, 0.0f, size.width, size.height).size);
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGImageRef image = CGBitmapContextCreateImage(context);
	[self deleteImage];
	[self createWithCGImage:image];
	CGImageRelease(image);
	UIGraphicsEndImageContext();
}

-(void)createWithBuffer:(NSData *)buffer
{
	UIImage *image = [[UIImage alloc] initWithData:buffer];
	if(!image)
		[NSException raise:@"createWithBuffer: Buffer error" format:@"createWithBuffer: Buffer error"];
	cgImage = CGImageRetain(image.CGImage);
	width = CGImageGetWidth(cgImage);
	height = CGImageGetHeight(cgImage);
	[image release];
}

#pragma mark -
#pragma mark property methods

-(NSUInteger)getWidth
{
	return width;
}

-(NSUInteger)getHeight
{
	return height;
}

-(CGSize)getSize
{
	return CGSizeMake(width, height);
}

-(CGRect)getRect
{
	return CGRectMake(0.0f, 0.0f, width, height);
}

-(NSUInteger)getCount
{
	return width * height * 4;
}

-(CGImageRef)getCGImage
{
	return cgImage;
}

-(unsigned char *)getBits
{
	int w = (int)width, h = (int)height;
	CGImageRef image = cgImage;
	unsigned char * data = (unsigned char *) malloc(w * h * 4);
	CGContextRef context = CGBitmapContextCreate(data, w, h, 8, w * 4, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
	CGContextClearRect(context, CGRectMake(0.0f, 0.0f, (CGFloat)w, (CGFloat)h));
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)w, (CGFloat)h), cgImage);
	CGContextRelease(context);
	return data;
}

-(BOOL)isValid
{
	return (cgImage != nil);
}

-(BOOL)isRecycled
{
	return isRecycled;
}

#pragma mark -
#pragma mark operation methods

-(BOOL)equals:(PLImage *)image
{	
	if ([image getCGImage] == cgImage)
		return YES;
	if (![image getCGImage] || !cgImage || [image getHeight] != height || [image getWidth] != width)
		return NO;
	unsigned char * bits = [image getBits];
	unsigned char * _bits = [self getBits];
	for(NSUInteger i = 0; i < [self getCount]; i++, bits++, _bits++)
	{
		if(*bits != *_bits)
		{
			free(bits);
			free(_bits);
			return NO;
		}
	}
	free(bits);
	free(_bits);
	return YES;
}

-(PLImage *)assign:(PLImage *)image
{
	[self deleteImage];
	[self createWithCGImage:[image getCGImage]];
	return self;
}

#pragma mark -
#pragma mark crop methods

-(PLImage *)crop:(CGRect)rect
{
	CGImageRef image = CGImageCreateWithImageInRect(cgImage, rect);
	
	[self deleteImage];
	[self createWithCGImage:image];
	
	CGImageRelease(image);
	
	return self;
}

#pragma mark -
#pragma mark scale methods

-(PLImage *)scale:(CGSize)size
{
	if(!cgImage) 
	{
        [PLLog error:@"PLImage::scale" format:@"CGImage is nil", nil];
		return self;
	}
	if((size.width == 0 && size.height == 0) || (size.width == width && size.height == height))
		return self;
	
	int w = size.width;
	int h = size.height;
	
   // UIGraphicsBeginImageContext(CGRectMake(0.0f, 0.0f, w, h).size);
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);

	CGContextRef context = UIGraphicsGetCurrentContext();

	if(!context)
	{
        [PLLog error:@"PLImage::scale" format:@"CGContext was not created!", nil];
		return self;
	}
		
	CGContextTranslateCTM(context, 0.0f, h);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, w, h), cgImage);
	CGImageRef image = CGBitmapContextCreateImage(context);

	[self deleteImage];
	[self createWithCGImage:image];
	
	CGImageRelease(image);
	UIGraphicsEndImageContext();
	
	return self;
}

#pragma mark -
#pragma mark rotate methods

-(PLImage *)rotate:(NSInteger)angle
{
	if(angle % 90 != 0)
		return self;
	
	CGFloat angleInRadians = angle * (M_PI / 180.0f);
	CGFloat w = width;
	CGFloat h = height;
	
	CGRect rect = CGRectMake(0.0f, 0.0f, w, h);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	CGRect rotatedRect = CGRectApplyAffineTransform(rect, transform);
		
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
	
	CGContextRef context = CGBitmapContextCreate(NULL,
												   rotatedRect.size.width,
												   rotatedRect.size.height,
												   8,
												   0,
												   colorSpace,
												   kCGImageAlphaPremultipliedLast);
	
	CGContextSetAllowsAntialiasing(context, NO);
	CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	CGContextTranslateCTM(context,+(rotatedRect.size.width/2),+(rotatedRect.size.height/2));
	CGContextRotateCTM(context, angleInRadians);
	CGContextTranslateCTM(context,-(rotatedRect.size.width/2),-(rotatedRect.size.height/2));
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, rotatedRect.size.width, rotatedRect.size.height), cgImage);
	
	CGImageRef rotatedImage = CGBitmapContextCreateImage(context);
	
	[self deleteImage];
	[self createWithCGImage:rotatedImage];
	
	CGColorSpaceRelease(colorSpace);
    CGImageRelease(rotatedImage);
	CGContextRelease(context);
	
	return self;
}

#pragma mark -
#pragma mark mirror methods

-(PLImage *)mirrorHorizontally
{
	return [self mirroredByOrientation:UIImageOrientationUpMirrored];
}

-(PLImage *)mirrorVertically
{
	return [self mirroredByOrientation:UIImageOrientationDownMirrored];
}

-(PLImage *)mirroredByOrientation:(UIImageOrientation)orient
{
	CGRect             bounds = CGRectZero;
	CGContextRef       context = nil;
	CGImageRef         image = cgImage;
	CGRect             rect = CGRectZero;
	CGAffineTransform  transform = CGAffineTransformIdentity;
		
	rect.size.width  = width;
	rect.size.height = height;
	
	bounds = rect;
	
	switch (orient)
	{				
		case UIImageOrientationUpMirrored:
			transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0f);
			transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
			break;
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformMakeTranslation(0.0f, rect.size.height);
			transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
			break;
		default:
			assert(NO);
			return self;
	}
	
//	UIGraphicsBeginImageContext(bounds.size);
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1.0);

	context = UIGraphicsGetCurrentContext();
	
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0.0f, -rect.size.height);
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, image);
	image = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
	
	[self deleteImage];
	[self createWithCGImage:image];
	
	CGImageRelease(image);
	UIGraphicsEndImageContext();
	
	return self;
}

-(PLImage *)mirror:(BOOL)horizontally :(BOOL)vertically
{
	NSUInteger w = width, h = height;
	CGImageRef image = cgImage;
	unsigned char * data = (unsigned char *) malloc(w * h * 4);
	CGContextRef context = CGBitmapContextCreate(data, w, h, 8, w * 4, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
	
	CGContextScaleCTM(context, !horizontally ? -1.0 : 1.0 , !vertically ? -1.0 : 0);
	CGContextTranslateCTM(context, !horizontally ? -w : 0 , !vertically ? -h : 0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)w, (CGFloat)h), image);
	CGImageRef cgimage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());	
	free(data);
	
	[self deleteImage];
	[self createWithCGImage:cgimage];
	
	CGImageRelease(cgimage);
	CGContextRelease(context);
	
	return self;
}

#pragma mark -
#pragma mark save methods

-(BOOL)save:(NSString *)path
{
	return [self save:path quality:80];
}

-(BOOL)save:(NSString *)path quality:(NSUInteger)quality
{
	if([self isValid])
		return NO;
	quality = (quality == 0 ? 80 : MIN(quality, 100));
	NSData *data = UIImageJPEGRepresentation([UIImage imageWithCGImage:cgImage], (CGFloat)quality/100.0f);
	return ([data writeToFile:path atomically:YES] == YES);
}

#pragma mark -
#pragma mark sub-image methods

-(PLImage *)getSubImageWithRect:(CGRect)rect
{
	CGImageRef newImage = CGImageCreateWithImageInRect(cgImage, rect);
	PLImage *result = [PLImage imageWithCGImage:newImage];
	CGImageRelease(newImage);
	return result;
}

+(PLImage *)joinImagesHorizontally:(PLImage *)leftImage rightImage:(PLImage *)rightImage
{
    if(leftImage && leftImage.isValid && rightImage && rightImage.isValid)
    {
        UIImage *leftUImage = [UIImage imageWithCGImage:leftImage.CGImage];
        UIImage *rightUImage = [UIImage imageWithCGImage:rightImage.CGImage];
        
        CGSize newSize = CGSizeMake([leftImage getWidth] + [rightImage getWidth], MAX([leftImage getHeight], [rightImage getHeight]));
//        UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0);

        [leftUImage drawInRect:CGRectMake(0.0f, 0.0f, [leftImage getWidth], newSize.height)];
        [rightUImage drawInRect:CGRectMake([rightImage getWidth], 0.0f, [rightImage getWidth], newSize.height)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return [PLImage imageWithCGImage:newImage.CGImage];
    }
    return nil;
}

#pragma mark -
#pragma mark recycle methods

-(void)recycle
{
	if(!isRecycled)
		[self deleteImage];
}

#pragma mark -
#pragma mark clone methods

-(CGImageRef)cloneCGImage
{	
    id tempCGImage = [(id)CGImageCreateWithImageInRect(cgImage, CGRectMake(0.0f, 0.0f, width, height)) autorelease];
	return (CGImageRef)tempCGImage;
}

-(PLImage *)clone
{
	return [PLImage imageWithCGImage:cgImage];
}

#pragma mark -
#pragma mark dealloc methods

-(void)deleteImage
{
	if(cgImage)
	{
		CGImageRelease(cgImage);
		cgImage = nil;
		isRecycled = YES;
	}
}

-(void)dealloc
{
	[self deleteImage];
	[super dealloc];
}

@end
