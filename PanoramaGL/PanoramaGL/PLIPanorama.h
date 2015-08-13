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

#import "PLIScene.h"
#import "PLImage.h"
#import "PLHotspot.h"

@protocol PLIPanorama <PLIScene>

@required

#pragma mark -
#pragma mark properties

@property(nonatomic, readonly, getter=getSides) int sides;

#pragma mark -
#pragma mark init methods

+(id)panorama;

#pragma mark -
#pragma mark property methods

-(int)getPreviewSides;
-(void)setPreviewImage:(PLImage *)value;
-(int)getSides;

#pragma mark -
#pragma mark texture remove methods

-(void)removePreviewTextureAtIndex:(NSUInteger)index;
-(void)removeAllPreviewTextures;

-(void)removeAllTextures;

#pragma mark -
#pragma mark clear methods

-(void)clearPanorama;

#pragma mark -
#pragma mark hotspot methods

-(void)addHotspot:(PLHotspot *)hotspot;
-(void)removeHotspot:(PLHotspot *)hotspot;
-(void)removeHotspotAtIndex:(NSUInteger)index;
-(void)removeAllHotspots;

@end
