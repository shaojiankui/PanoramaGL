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

#import "PLSceneElementBase.h"

@interface PLSceneElement : PLSceneElementBase 
{
    #pragma mark -
    #pragma mark member variables
@private
	NSMutableArray *textures;
}

#pragma mark -
#pragma mark init methods

-(id)initWithId:(long long)identifier;
-(id)initWithId:(long long)identifier texture:(PLTexture *)texture;
-(id)initWithTexture:(PLTexture *)texture;

#pragma mark -
#pragma mark texture methods

-(void)addTexture:(PLTexture *)texture;
-(void)removeTexture:(PLTexture *)texture;
-(void)removeTextureAtIndex:(NSUInteger)index;
-(void)removeAllTextures;

@end