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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PLImage : NSObject
{
    #pragma mark -
    #pragma mark member variables
@private
	CGImageRef cgImage;
	NSUInteger width, height;
	BOOL isRecycled;
}

#pragma mark -
#pragma mark properties

@property(nonatomic, readonly, getter=getWidth) NSUInteger width;
@property(nonatomic, readonly, getter=getHeight) NSUInteger height;

@property(nonatomic, readonly, getter=getCGImage) CGImageRef CGImage;

@property(nonatomic, readonly, getter=getCount) NSUInteger count;
@property(nonatomic, readonly, getter=getBits) unsigned char * bits;

@property(nonatomic, readonly, getter=isRecycled) BOOL isRecycled;

#pragma mark -
#pragma mark init methods

-(id)initWithCGImage:(CGImageRef)image;
-(id)initWithSize:(CGSize)size;
-(id)initWithDimensions:(NSUInteger)width :(NSUInteger)height;
-(id)initWithPath:(NSString *)path;
-(id)initWithBuffer:(NSData *)buffer;

+(id)imageWithSizeZero;
+(id)imageWithCGImage:(CGImageRef)image;
+(id)imageWithSize:(CGSize)size;
+(id)imageWithDimensions:(NSUInteger)width :(NSUInteger)height;
+(id)imageWithPath:(NSString *)path;
+(id)imageWithBuffer:(NSData *)buffer;

#pragma mark -
#pragma mark property methods

-(NSUInteger)getWidth;
-(NSUInteger)getHeight;
-(CGSize)getSize;
-(CGRect)getRect;

-(CGImageRef)getCGImage;

-(NSUInteger)getCount;
-(unsigned char *)getBits;

-(BOOL)isValid;

-(BOOL)isRecycled;

#pragma mark -
#pragma mark operation methods

-(BOOL)equals:(PLImage *)image;
-(PLImage *)assign:(PLImage *)image;

#pragma mark -
#pragma mark crop methods

-(PLImage *)crop:(CGRect)rect;

#pragma mark -
#pragma mark scale methods

-(PLImage *)scale:(CGSize)size;

#pragma mark -
#pragma mark rotate methods

-(PLImage *)rotate:(NSInteger)angle;

#pragma mark -
#pragma mark mirror methods

-(PLImage *)mirrorHorizontally;
-(PLImage *)mirrorVertically;
-(PLImage *)mirror:(BOOL)horizontally :(BOOL)vertically;

#pragma mark -
#pragma mark save methods

-(BOOL)save:(NSString *)path;
-(BOOL)save:(NSString *)path quality:(NSUInteger)quality;

#pragma mark -
#pragma mark sub-image methods

-(PLImage *)getSubImageWithRect:(CGRect)rect;
+(PLImage *)joinImagesHorizontally:(PLImage *)leftImage rightImage:(PLImage *)rightImage;

#pragma mark -
#pragma mark recycle methods

-(void)recycle;

#pragma mark -
#pragma mark clone methods

-(CGImageRef)cloneCGImage;
-(PLImage *)clone;

@end