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

#import "PLSceneElement.h"
#import "PLVector3.h"

@interface PLHotspot : PLSceneElement
{
    #pragma mark -
    #pragma mark member variables
@private
	float width, height;
	
	float atv, ath;
	
	GLfloat *cube, *textureCoords;
	
	float overAlpha, defaultOverAlpha;
	
	BOOL hasChangedCoordProperty;
	
	BOOL isTouchBlock;
	PLHotspotTouchStatus touchStatus;
}

#pragma mark -
#pragma mark properties

@property(nonatomic, assign) float atv, ath;
@property(nonatomic, assign) float width, height;
@property(nonatomic, assign) PLCubeFaceOrientation faceOrientation;
@property(nonatomic, readonly, getter=getRect) PLRect rect;
@property(nonatomic, readonly, getter=getVertexs) GLfloat * vertexs;
@property(nonatomic, assign) float overAlpha, defaultOverAlpha;
@property(nonatomic, readonly) PLHotspotTouchStatus touchStatus;
@property(nonatomic, assign) BOOL isTouchBlock;

#pragma mark -
#pragma mark init methods

-(id)initWithId:(long long)identifier atv:(float)atv ath:(float)ath;
-(id)initWithId:(long long)identifier texture:(PLTexture *)texture atv:(float)atv ath:(float)ath;
-(id)initWithId:(long long)identifier texture:(PLTexture *)texture atv:(float)atv ath:(float)ath width:(float)width height:(float)height;

+(id)hotspotWithId:(long long)identifier atv:(float)atv ath:(float)ath;
+(id)hotspotWithId:(long long)identifier texture:(PLTexture *)texture atv:(float)atv ath:(float)ath;
+(id)hotspotWithId:(long long)identifier texture:(PLTexture *)texture atv:(float)atv ath:(float)ath width:(float)width height:(float)height;

#pragma mark -
#pragma mark property methods

-(PLRect)getRect;
-(GLfloat *)getVertexs;

#pragma mark -
#pragma mark layout methods

-(void)setLayout:(float)xValue :(float)yValue :(float)widthValue :(float)heightValue;

#pragma mark -
#pragma mark touch methods

-(void)touchBlock;
-(void)touchUnblock;
-(void)touchOver:(NSObject *)sender;
-(void)touchMove:(NSObject *)sender;
-(void)touchOut:(NSObject *)sender;
-(void)touchDown:(NSObject *)sender;

@end
