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

#import "PLObjectBaseProtected.h"
#import "PLRenderer.h"
#import "PLLog.h"

@interface PLRenderer(Private)

-(void)createFramebuffer;
-(void)destroyFramebuffer;

-(NSUInteger)checkCollisionsWithScreenPoint:(CGPoint)screenPoint isMoving:(BOOL)isMoving;
-(void)createRayWithScreenPoint:(CGPoint)point ray:(PLVector3 **)ray;
-(PLPosition)convertPointTo3DPoint:(CGPoint)point z:(float)z;
-(NSUInteger)checkHotspotsCollisionWithRay:(PLVector3 **)ray isMoving:(BOOL)isMoving screenPoint:(CGPoint)screenPoint;

-(void)setColorR:(float)red G:(float)green B:(float)blue A:(float)alpha;
-(void)drawLineWithStartPoint:(const PLVector3 *)startPoint endPoint:(const PLVector3 *)endPoint width:(float)width;
-(void)drawLineWithStartPoint:(const PLVector3 *)startPoint endPoint:(const PLVector3 *)endPoint;
-(void)highlightVertex:(const PLVector3 *)vertex color:(PLRGBA)rgba;

-(void)performHotspotClickEvent:(NSObject *)args;
-(void)performHotspotOverEvent:(NSObject *)args;
-(void)performHotspotOutEvent:(NSObject *)args;

-(void)createCollisionData;
-(void)releaseCollisionData;

@end

@implementation PLRenderer

@synthesize view;
@synthesize scene;
@synthesize isValid;
@synthesize backingWidth, backingHeight;

#pragma mark -
#pragma mark init methods

-(id)initWithView:(UIView<PLIView> *)aView scene:(NSObject<PLIScene> *)aScene;
{
	if(self = [self init])
	{
		isValid = NO;
		self.view = aView;
		self.scene = aScene;
		
	}
	return self;
}

+(id)rendererWithView:(UIView<PLIView> *)view scene:(NSObject<PLIScene> *)scene
{
	return [[[PLRenderer alloc] initWithView:view scene:scene] autorelease];
}

-(void)initializeValues
{
	[super initializeValues];
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if(!context || ![EAGLContext setCurrentContext:context]) 
		[self release];
	[self createCollisionData];
	if(view && view.layer)
		[self resizeFromLayer];
}

-(void)createCollisionData
{
	ray[0] = [[PLVector3 alloc] init];
	ray[1] = [[PLVector3 alloc] init];
	hitPoint = nil;
	for(int i = 0; i < 4; i++)
		points[i] = [[PLVector3 alloc] init];
}

#pragma mark -
#pragma mark buffer methods

-(void)createFramebuffer 
{
	glGenFramebuffersOES(1, &defaultFramebuffer);
	glGenRenderbuffersOES(1, &colorRenderbuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
}

-(void)destroyFramebuffer 
{
	if(defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }
    if(colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
}

-(BOOL)resizeFromLayer
{	
	@synchronized(self)
	{
		if(context && (backingWidth != view.bounds.size.width || backingHeight != view.bounds.size.height))
		{
			isValid = NO;
			
			[self destroyFramebuffer];
			[self createFramebuffer];
			
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
			[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer *)view.layer];
			glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
			glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
			
			aspect = (float)backingWidth/(float)backingHeight;
			
			if(scene.currentCamera.fovSensitivity == kDefaultFovSensitivity)
				scene.currentCamera.fovSensitivity = (aspect >= 1.0f ? backingWidth : backingHeight) * 10.0f;
			
			if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
			{
                [PLLog error:@"PLRenderer::resizeFromLayer" format:@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES)];
				return NO;
			}
			
			isValid = YES;
			return YES;
		}
		return NO;
	}
}

#pragma mark -
#pragma mark render methods

-(void)render
{
	@try
	{
		if(context && isValid)
		{
			[EAGLContext setCurrentContext:context];
			glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
			
			glViewport(0, 0, backingWidth, backingHeight);
			
			glMatrixMode(GL_PROJECTION);
			glLoadIdentity();
			
			PLCamera * camera = scene.currentCamera;
			BOOL isCorrectedRatio = (backingWidth > backingHeight);
			float zoomFactor = (camera.isFovEnabled ? (isCorrectedRatio ? camera.fovFactorCorrected : camera.fovFactor) : 1.0f);
			float perspective = kPerspectiveValue + (isCorrectedRatio ? 25.0f : 0.0f);
			
			gluPerspective(MIN(perspective * zoomFactor, 359.0f), aspect, kPerspectiveZNear, kPerspectiveZFar);
			
			glMatrixMode(GL_MODELVIEW);
			glLoadIdentity();
			
			glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
			glClearDepthf(1.0f);
			
			glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
			
			glEnable(GL_DEPTH_TEST);
			glDepthFunc(GL_LEQUAL);
			glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
			
			glTranslatef(0.0f, 0.0f, 0.0f);
			
			glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
			
            [camera render];
            [scene render];
			
			if(!view.isValidForFov && !view.isValidForTransition)
				[self checkCollisionsWithScreenPoint:view.endPoint isMoving:view.touchStatus != PLTouchStatusFirstSingleTapCount];
			
			glFlush();
			
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
			[context presentRenderbuffer:GL_RENDERBUFFER_OES];
		}
	}
	@catch(NSException *e)
	{
	}
}

-(void)renderNTimes:(NSUInteger)times
{
	for(NSUInteger i = 0; i < times; i++)
		[self render];
}

#pragma mark -
#pragma mark collition methods

-(NSUInteger)checkCollisionsWithScreenPoint:(CGPoint)screenPoint isMoving:(BOOL)isMoving
{
	if(view.isValidForTransition)
		return 0;
	
	NSUInteger result = 0;
	[self createRayWithScreenPoint:screenPoint ray:ray];
	result = [self checkHotspotsCollisionWithRay:ray isMoving:isMoving screenPoint:screenPoint];
	return result;
}

-(void)createRayWithScreenPoint:(CGPoint)point ray:(PLVector3 **)rayVectors
{
	PLPosition pos;
	
	glGetIntegerv(GL_VIEWPORT, viewport);	
	glGetFloatv(GL_MODELVIEW_MATRIX, mvmatrix);
	glGetFloatv(GL_PROJECTION_MATRIX, projmatrix);
	
	float y = (float)viewport[3] - point.y;
	
	gluUnProject(point.x, y, 0.0f, mvmatrix, projmatrix, viewport, &pos.x, &pos.y, &pos.z);
	[rayVectors[0] setValuesWithPosition:pos];
	gluUnProject(point.x, y, 1.0f, mvmatrix, projmatrix, viewport, &pos.x, &pos.y, &pos.z);
	[rayVectors[1] setValuesWithPosition:pos];
}

-(PLPosition)convertPointTo3DPoint:(CGPoint)point z:(float)z
{
	PLPosition pos = { 0.0f, 0.0f, 0.0f };
	CGSize size = view.frame.size;
	viewport[0] = 0;
	viewport[1] = 0;
	viewport[2] = size.width;
	viewport[3] = size.height;
	float y = (float)size.height - point.y;
	gluUnProject(point.x, y, z, mvmatrix, projmatrix, viewport, &pos.x, &pos.y, &pos.z);
	return pos;
}

-(NSUInteger)checkHotspotsCollisionWithRay:(PLVector3 **)rayVectors isMoving:(BOOL)isMoving screenPoint:(CGPoint)screenPoint
{
	NSUInteger hits = 0;
	NSMutableArray *elements = scene.elements;
	NSUInteger elementsLength = [elements count];
	NSObject<PLViewDelegate> *delegate = view.delegate;
    NSObject *params = nil;
	for(NSUInteger i = 0; i < elementsLength; i++)
	{
		NSObject *element = [elements objectAtIndex:i];
		if([element isKindOfClass:[PLHotspot class]])
		{
			PLHotspot *hotspot = (PLHotspot *)element;
			GLfloat *vertexs = [hotspot getVertexs];
			if(vertexs == nil)
				continue;
			
			[points[0] setValuesWithX:vertexs[0] y:-vertexs[2]  z:vertexs[1]];
			[points[1] setValuesWithX:vertexs[3] y:-vertexs[5]  z:vertexs[4]];
			[points[2] setValuesWithX:vertexs[6] y:-vertexs[8]  z:vertexs[7]];
			[points[3] setValuesWithX:vertexs[9] y:-vertexs[11]  z:vertexs[10]];
			
			if([PLIntersection checkLineBoxWithRay:rayVectors point1:points[0] point2:points[1] point3:points[2] point4:points[3] hitPoint:&hitPoint])
			{
				if(view.isPointerVisible)
					[self highlightVertex:hitPoint color:PLRGBAMake(1.0f, 0.0f, 0.0f, 1.0f)];
				if(isMoving)
				{
					if(hotspot.touchStatus == PLHotspotTouchStatusOut)
					{
						if(delegate && [delegate respondsToSelector:@selector(view:didOverHotspot:screenPoint:scene3DPoint:)])
                        {
                            params = [NSArray 
                                      arrayWithObjects:hotspot,
                                      [NSNumber numberWithFloat:screenPoint.x],
                                      [NSNumber numberWithFloat:screenPoint.y],
                                      [hitPoint clone],
                                      nil];
                        }
                        else
                            params = hotspot;
                        [self performSelectorOnMainThread:@selector(performHotspotOverEvent:) withObject:params waitUntilDone:NO];
					}
					else
						[hotspot touchMove:self];
				}
				else
				{
					view.isBlocked = YES;
					view.startPoint = CGPointMake(view.endPoint.x, view.endPoint.y);
                    if(delegate && [delegate respondsToSelector:@selector(view:didClickHotspot:screenPoint:scene3DPoint:)])
                    {
                        params = [NSArray 
                                  arrayWithObjects:hotspot,
                                  [NSNumber numberWithFloat:screenPoint.x],
                                  [NSNumber numberWithFloat:screenPoint.y],
                                  [hitPoint clone],
                                  nil];
                    }
                    else
                        params = hotspot;
                    [self performSelectorOnMainThread:@selector(performHotspotClickEvent:) withObject:params waitUntilDone:NO];
					break;
				}
				hits++;
			}
			else
			{
				if(hotspot.touchStatus != PLHotspotTouchStatusOut)
				{
					if(delegate && [delegate respondsToSelector:@selector(view:didOutHotspot:screenPoint:scene3DPoint:)])
                    {
                        params = [NSArray 
                                  arrayWithObjects:hotspot,
                                  [NSNumber numberWithFloat:screenPoint.x],
                                  [NSNumber numberWithFloat:screenPoint.y],
                                  [hitPoint clone],
                                  nil];
                    }
                    else
                        params = hotspot;
					[self performSelectorOnMainThread:@selector(performHotspotOutEvent:) withObject:params waitUntilDone:NO];
				}
			}
		}
	}
	return hits;
}

#pragma mark -
#pragma mark hotspot event methods

-(void)performHotspotClickEvent:(NSObject *)args
{
    if([args isKindOfClass:[NSArray class]])
    {
        NSArray *argsArray = (NSArray *)args;
        PLHotspot *hotspot = (PLHotspot *)[argsArray objectAtIndex:0];
        [hotspot touchDown:self];
        [view.delegate 
            view:view
            didClickHotspot:hotspot
            screenPoint:CGPointMake([((NSNumber *)[argsArray objectAtIndex:1]) floatValue], [((NSNumber *)[argsArray objectAtIndex:2]) floatValue])
            scene3DPoint:((PLVector3 *)[argsArray objectAtIndex:3]).position
        ];
    }
    else
        [(PLHotspot *)args touchDown:self];
	view.isBlocked = NO;
}

-(void)performHotspotOverEvent:(NSObject *)args
{
    if([args isKindOfClass:[NSArray class]])
    {
        NSArray *argsArray = (NSArray *)args;
        PLHotspot *hotspot = (PLHotspot *)[argsArray objectAtIndex:0];
        [hotspot touchOver:self];
        [view.delegate 
            view:view
            didOverHotspot:hotspot
            screenPoint:CGPointMake([((NSNumber *)[argsArray objectAtIndex:1]) floatValue], [((NSNumber *)[argsArray objectAtIndex:2]) floatValue])
            scene3DPoint:((PLVector3 *)[argsArray objectAtIndex:3]).position
        ];
    }
    else
        [(PLHotspot *)args touchOver:self];
}

-(void)performHotspotOutEvent:(NSObject *)args
{
    if([args isKindOfClass:[NSArray class]])
    {
        NSArray *argsArray = (NSArray *)args;
        PLHotspot *hotspot = (PLHotspot *)[argsArray objectAtIndex:0];
        [hotspot touchOut:self];
        [view.delegate 
            view:view
            didOutHotspot:hotspot
            screenPoint:CGPointMake([((NSNumber *)[argsArray objectAtIndex:1]) floatValue], [((NSNumber *)[argsArray objectAtIndex:2]) floatValue])
            scene3DPoint:((PLVector3 *)[argsArray objectAtIndex:3]).position
        ];
    }
    else
        [(PLHotspot *)args touchOut:self];
}

#pragma mark -
#pragma mark draw methods

-(void)setColorR:(float)red G:(float)green B:(float)blue A:(float)alpha
{
	glColor4f(red, green, blue, alpha);
}

-(void)drawLineWithStartPoint:(const PLVector3 *)startPoint endPoint:(const PLVector3 *)endPoint width:(GLfloat)width
{
	GLfloat linePoints[] = { startPoint.x, startPoint.y, startPoint.z, endPoint.x, endPoint.y, endPoint.z };
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	glEnable(GL_LINE_SMOOTH);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glLineWidth(width);
	
	glVertexPointer(3, GL_FLOAT, 0, linePoints);
	glDrawArrays(GL_LINE_STRIP, 0, 2);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisable(GL_BLEND);
	glDisable(GL_LINE_SMOOTH);
}

-(void)drawLineWithStartPoint:(const PLVector3 *)startPoint endPoint:(const PLVector3 *)endPoint
{
	[self drawLineWithStartPoint:startPoint endPoint:endPoint width:1.0f];
}

-(void)highlightVertex:(const PLVector3 *)vertex color:(PLRGBA)rgba
{
	glPushMatrix();
	
	glColor4f(rgba.red, rgba.green, rgba.blue, rgba.alpha);
	
#define DD 0.008f
	[self drawLineWithStartPoint:[vertex sub:[PLVector3 vector3WithX:-DD y: DD z: DD]] endPoint:[vertex add:[PLVector3 vector3WithX:-DD y: DD z: DD]]];
	[self drawLineWithStartPoint:[vertex sub:[PLVector3 vector3WithX: DD y:-DD z: DD]] endPoint:[vertex add:[PLVector3 vector3WithX: DD y:-DD z: DD]]];
	[self drawLineWithStartPoint:[vertex sub:[PLVector3 vector3WithX: DD y: DD z:-DD]] endPoint:[vertex add:[PLVector3 vector3WithX: DD y: DD z:-DD]]];
	
	glPopMatrix();
	
	glColor4f(1.0f, 1.0f, 1.0f , 1.0f);
}

#pragma mark -
#pragma mark control methods

-(void)start
{
    if(!isValid)
    {
        @synchronized(self)
        {
            isValid = YES;
        }
    }
}

-(BOOL)isRunning
{
    return isValid;
}

-(void)stop
{
    if(isValid)
    {
        @synchronized(self)
        {
            isValid = NO;
        }
    }
}

#pragma mark -
#pragma mark dealloc methods

-(void)releaseCollisionData
{
    [ray[0] release];
    [ray[1] release];
	hitPoint = nil;
	for(NSUInteger i = 0; i < 4; i++)
        [points[i] release];
}

-(void)dealloc
{
	[self releaseCollisionData];
	[self destroyFramebuffer];
    if(context)
    {
        if([EAGLContext currentContext] == context)
            [EAGLContext setCurrentContext:nil];
        [context release];
        context = nil;
    }
	self.scene = nil;
	self.view = nil;
	[super dealloc];
}

@end
