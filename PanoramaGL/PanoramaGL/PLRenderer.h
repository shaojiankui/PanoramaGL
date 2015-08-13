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
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/CAEAGLLayer.h>
#import "glu.h"

#import "PLIRenderer.h"
#import "PLObjectBase.h"
#import "PLStructs.h"
#import "PLCamera.h"
#import "PLScene.h"
#import "PLSceneElement.h"

#import "PLVector3.h"
#import "PLIntersection.h"
#import "PLHotspot.h"

@interface PLRenderer : PLObjectBase <PLIRenderer>
{
    #pragma mark -
    #pragma mark member variables
@private
	BOOL isValid;
	
    EAGLContext *context;
    GLuint program;
	
	GLint backingWidth, backingHeight;
    
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	UIView<PLIView> *view;
	NSObject<PLIScene> *scene;
	
	float aspect;
	
	float mvmatrix[16];
	float projmatrix[16];
	int viewport[4];
	
	PLVector3 *ray[2];
	PLVector3 *hitPoint;
	PLVector3 *points[4];
}

@end