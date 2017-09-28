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

#import "PLRenderableElementBaseProtected.h"
#import "PLScene.h"

@interface PLScene(Private)

-(void)evaluateWhenCameraIsRemoved;

@end

@implementation PLScene

@synthesize cameras;
@synthesize currentCamera;
@synthesize cameraIndex;

@synthesize elements;

@synthesize view;

#pragma mark -
#pragma mark init methods

-(id)init
{
    if(self = [super init])
        [self addCamera:[PLCamera camera]];
    return self;
}

-(id)initWithCamera:(PLCamera *)camera
{
	if(self = [super init])
		[self addCamera:camera];
	return self;
}

-(id)initWithElement:(PLSceneElement *)element
{
	return [self initWithElement:element camera:[PLCamera camera]];
}

-(id)initWithElement:(PLSceneElement *)element camera:(PLCamera *)camera
{
	if(self = [super init])
	{
		[self addElement:element];
		[self addCamera:camera];
	}
	return self;
}

-(id)initWithView:(UIView<PLIView> *)aView
{
	if(self = [self init])
		view = aView;
	return self;
}

-(id)initWithView:(UIView<PLIView> *)aView camera:(PLCamera *)camera
{
	if(self = [self initWithCamera:camera])
		view = aView;
	return self;
}

-(id)initWithView:(UIView<PLIView> *)aView element:(PLSceneElement *)element
{
	if(self = [self initWithElement:element])
		view = aView;
	return self;
}

-(id)initWithView:(UIView<PLIView> *)aView element:(PLSceneElement *)element camera:(PLCamera *)camera
{
	if(self = [self initWithElement:element camera:camera])
		view = aView;
	return self;
}

+(id)scene
{
	return [[[PLScene alloc] init] autorelease];
}

+(id)sceneWithCamera:(PLCamera *)camera
{
	return [[[PLScene alloc] initWithCamera:camera] autorelease];
}

+(id)sceneWithElement:(PLSceneElement *)element
{
	return [[[PLScene alloc] initWithElement:element] autorelease];
}

+(id)sceneWithElement:(PLSceneElement *)element camera:(PLCamera *)camera
{
	return [[[PLScene alloc] initWithElement:element camera:camera] autorelease];
}

+(id)sceneWithView:(UIView<PLIView> *)view
{
	return [[[PLScene alloc] initWithView:view] autorelease];
}

+(id)sceneWithView:(UIView<PLIView> *)view camera:(PLCamera *)camera
{
	return [[[PLScene alloc] initWithView:view camera:camera] autorelease];
}

+(id)sceneWithView:(UIView<PLIView> *)view element:(PLSceneElement *)element
{
	return [[[PLScene alloc] initWithView:view element:element] autorelease];
}

+(id)sceneWithView:(UIView<PLIView> *)view element:(PLSceneElement *)element camera:(PLCamera *)camera
{
	return [[[PLScene alloc] initWithView:view element:element camera:camera] autorelease];
}

-(void)initializeValues
{
	[super initializeValues];
	elements = [[NSMutableArray alloc] init];
	cameras = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark alpha methods

-(void)setAlpha:(float)value
{
	[super setAlpha:value];
	for(PLSceneElement *element in elements)
		[element setAlpha:MIN(value, element.defaultAlpha)];
}

-(void)resetAlpha
{
	[super setAlpha:self.defaultAlpha];
	for(PLSceneElement *element in elements)
		[element setAlpha:element.defaultAlpha];
}

#pragma mark -
#pragma mark camera methods

-(void)setCameraIndex:(NSUInteger)index
{
	if(index < [cameras count])
	{
		cameraIndex = index;
		currentCamera = [cameras objectAtIndex:index];
	}
}

-(void)addCamera:(PLCamera *)camera
{
	if(camera)
	{
		if([cameras count] == 0)
		{
			cameraIndex = 0;
			currentCamera = camera;
		}
		[cameras addObject:camera];
	}	
}

-(void)removeCameraAtIndex:(NSUInteger)index
{
	[cameras removeObjectAtIndex:index];
	[self evaluateWhenCameraIsRemoved];
}

-(void)removeCamera:(PLCamera *)camera
{
	if(camera)
	{
		NSUInteger i = 0;
		BOOL flag = NO;
		for(PLCamera * currentcamera in cameras)
		{
			if(currentcamera == camera)
			{
				flag = YES;
				break;
			}
			i++;
		}
		if(flag)
		{
			[elements removeObjectAtIndex:i];
			[self evaluateWhenCameraIsRemoved];
		}
	}
}

-(void)removeAllCameras
{
	[cameras removeAllObjects];
	[self evaluateWhenCameraIsRemoved];
}

-(void)evaluateWhenCameraIsRemoved
{
	NSUInteger camerasCount = [cameras count];
	if(camerasCount == 0)
	{
		currentCamera = nil;
		cameraIndex = -1;
	}
	else if(cameraIndex > camerasCount - 1) 
	{
		currentCamera = [cameras objectAtIndex:0];
		cameraIndex = 0;
	}
	else
		currentCamera = [cameras objectAtIndex:cameraIndex];
}

#pragma mark -
#pragma mark element methods

-(void)addElement:(PLSceneElement *)element
{
	if(element)
		[elements addObject:element];
}

-(void)removeElementAtIndex:(NSUInteger)index
{
	[elements removeObjectAtIndex:index];
}

-(void)removeElement:(PLSceneElement *)element
{
	if(element)
	{
		NSUInteger i = 0;
		BOOL flag = NO;
		for(PLSceneElement *currentElement in elements)
		{
			if(currentElement == element)
			{
				flag = YES;
				break;
			}
			i++;
		}
		if(flag)
			[elements removeObjectAtIndex:i];
	}
}

-(void)removeAllElements
{
	[elements removeAllObjects];
}

#pragma mark -
#pragma mark render methods

-(void)internalRender
{
	[super internalRender];
	for(PLSceneElement *element in elements)
		[element render];
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
	view = nil;
	if(elements)
		[elements release];
	if(cameras)
		[cameras release];
	[super dealloc];
}

@end
