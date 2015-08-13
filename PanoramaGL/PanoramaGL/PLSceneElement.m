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

#import "PLSceneElementProtected.h"

@implementation PLSceneElement

#pragma mark -
#pragma mark init methods

-(id)initWithId:(long long)identifierValue
{
	if(self = [super init])
		self.identifier = identifierValue;
	return self;
}

-(id)initWithId:(long long)identifierValue texture:(PLTexture *)texture
{
	if(self = [super init])
	{
		self.identifier = identifierValue;
		[self addTexture:texture];
	}
	return self;
}

-(id)initWithTexture:(PLTexture *)texture
{
	if(self = [super init])
		[self addTexture:texture];
	return self;
}

-(void)initializeValues
{
	[super initializeValues];
	textures = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark property methods

-(PLSceneElementType)getType
{
	return PLSceneElementTypeObject;
}

-(NSMutableArray *)getTextures
{
	return textures;
}

#pragma mark -
#pragma mark texture methods

-(void)addTexture:(PLTexture *)texture
{
	if(texture)
	{
		[textures addObject:texture];
		[self evaluateIfElementIsValid];
	}
}

-(void)removeTexture:(PLTexture *)texture
{
	if(texture)
	{
		[textures removeObject:texture];
		[self evaluateIfElementIsValid];
	}
}

-(void)removeTextureAtIndex:(NSUInteger)index
{
	[textures removeObjectAtIndex:index];
	[self evaluateIfElementIsValid];
}

-(void)removeAllTextures
{
	[textures removeAllObjects];
	[self evaluateIfElementIsValid];
}

#pragma mark -
#pragma mark eval methods

-(void)evaluateIfElementIsValid
{
	[self setIsValid:[textures count] > 0];
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
	if(textures)
	{
		[self removeAllTextures];
		[textures release];
	}
	[super dealloc];
}

@end