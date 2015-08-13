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

#import <OpenGLES/EAGL.h>
#import "glu.h"

#import "PLObjectBase.h"

#import "PLEnums.h"
#import "PLImage.h"
#import "PLLog.h"
#import "PLTextureDelegate.h"

@interface PLTexture : PLObjectBase
{
    #pragma mark -
    #pragma mark member variables
@private	
	GLuint *textureID;
	PLImage *image;
	BOOL isRecycled;
	int width, height;
	BOOL isValid;
	PLTextureColorFormat format;
	NSObject<PLTextureDelegate> *delegate;
}

#pragma mark -
#pragma mark properties

@property(nonatomic, readonly, getter=getTextureID) GLuint textureID;
@property(nonatomic, readonly, getter=getWidth) int width;
@property(nonatomic, readonly, getter=getHeight) int height;
@property(nonatomic, readonly, getter=isValid) BOOL isValid;
@property(nonatomic, readonly, getter=isRecycled) BOOL isRecycled;
@property(nonatomic, getter=getFormat, setter=setFormat:) PLTextureColorFormat format;
@property(nonatomic, assign) NSObject<PLTextureDelegate> *delegate;

#pragma mark -
#pragma mark init methods

-(id)initWithImage:(PLImage *)image;
+(id)textureWithImage:(PLImage *)image;

#pragma mark -
#pragma mark property methods

-(GLuint)getTextureID;
-(int)getWidth;
-(int)getHeight;
-(BOOL)isValid;
-(BOOL)isRecycled;
-(PLTextureColorFormat)getFormat;
-(void)setFormat:(PLTextureColorFormat)value;

#pragma mark -
#pragma mark recycle methods

-(void)recycle;

@end