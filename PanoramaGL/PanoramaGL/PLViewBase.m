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

#import "PLViewBaseProtected.h"
#import "PLRenderer.h"
#import "PLLog.h"

@interface PLViewBase(Private)

-(void)doGyroUpdate;
-(void)doSimulatedGyroUpdate;

@end

@implementation PLViewBase

@synthesize panorama = scene;

@synthesize animationInterval;
@synthesize animationFrameInterval;

@synthesize isBlocked;

@synthesize isAccelerometerEnabled, isAccelerometerLeftRightEnabled, isAccelerometerUpDownEnabled;
@synthesize accelerometerSensitivity;
@synthesize accelerometerInterval;

@synthesize startPoint, endPoint;
@synthesize startFovPoint, endFovPoint;

@synthesize isScrollingEnabled;
@synthesize minDistanceToEnableScrolling;

@synthesize isInertiaEnabled;
@synthesize inertiaInterval;

@synthesize isResetEnabled, isShakeResetEnabled;
@synthesize numberOfTouchesForReset;

@synthesize isValidForFov;

@synthesize shakeThreshold;

@synthesize isDisplayLinkSupported;
@synthesize isAnimating;

@synthesize isSensorialRotationRunning;

@synthesize delegate;

@synthesize isValidForTransition;

@synthesize touchStatus;

@synthesize isPointerVisible;

#pragma mark -
#pragma mark init methods 

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
		[self initializeValues];
	return self;
}

-(id)initWithCoder:(NSCoder*)coder 
{
    if(self = [super initWithCoder:coder]) 
		[self initializeValues];
    return self;
}

-(void)initializeValues
{
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
	
	scene = nil;
	renderer = nil;
	
	displayLink = nil;
	displayLinkSupported = ([[[UIDevice currentDevice] systemVersion] compare:@"3.1" options:NSNumericSearch] != NSOrderedAscending);
	
	animationInterval = kDefaultAnimationTimerInterval;
	animationFrameInterval = kDefaultAnimationFrameInterval;
	isDisplayLinkSupported = YES;
	
	isAccelerometerEnabled = NO;
	isAccelerometerLeftRightEnabled = YES;
	isAccelerometerUpDownEnabled = NO;
	accelerometerSensitivity = kDefaultAccelerometerSensitivity;
	accelerometerInterval = kDefaultAccelerometerInterval;
	
	isScrollingEnabled = NO;
	minDistanceToEnableScrolling = kDefaultMinDistanceToEnableScrolling;
	
	isInertiaEnabled = YES;
	inertiaInterval = kDefaultInertiaInterval;
	
	isValidForTouch = NO;
	
	isResetEnabled = isShakeResetEnabled = YES;
	numberOfTouchesForReset = kDefaultNumberOfTouchesForReset;
	
	shakeData = PLShakeDataMake(0);
	shakeThreshold = kShakeThreshold;
	
	touchStatus = PLTouchStatusNone;
	
	isPointerVisible = NO;
	
	isValidForTransition = NO;
	isValidForTransitionString = @"";
	
	[self reset];
}

#pragma mark -
#pragma mark reset methods 

-(void)reset
{
	[self resetWithoutAlpha];
	[self resetSceneAlpha];
}

-(void)resetWithoutAlpha
{
	[self stopAnimationInternally];
	isValidForFov = isValidForScrolling = isScrolling = isValidForInertia = NO;
	startPoint = endPoint = CGPointMake(0.0f, 0.0f);
	startFovPoint = endFovPoint = CGPointMake(0.0f, 0.0f);
	fovDistance = 0.0f;
	if(scene && scene.currentCamera)
		[scene.currentCamera reset];
	if([self getIsValidForTransition])
	{
		if(currentTransition)
			[currentTransition stop];
		else
			[self setIsValidForTransition:NO];
	}
}

-(void)resetSceneAlpha
{
    if(scene)
        [scene resetAlpha];
}

#pragma mark -
#pragma mark property method

-(void)setPanorama:(NSObject<PLIPanorama> *)panorama
{
    if(panorama)
    {
        @synchronized(self)
        {
            BOOL tempIsAnimating = isAnimating;
            if(tempIsAnimating)
                [self stopAnimation];
            [self stopSensorialRotation];
            if(renderer)
                [renderer stop];
            if(scene)
            {
                [scene release];
                scene = nil;
            }
            scene = [panorama retain];
            if(renderer)
            {
                renderer.scene = scene;
                [renderer start];
            }
            else
            {
                renderer = [[PLRenderer alloc] initWithView:self scene:scene];
                [renderer resizeFromLayer];
            }
            if(tempIsAnimating)
                [self startAnimation];
            else
                [self drawViewInternallyNTimes:2];
        }
    }
}

-(NSObject<PLIScene> *)scene
{
	return scene;
}

-(NSObject<PLIRenderer> *)renderer
{
	return renderer;
}

-(PLCamera *)getCamera
{
	if(scene)
		return scene.currentCamera;
	return nil;
}

-(void)setSceneAlpha:(float)value
{
    if(scene)
        scene.alpha = value;
}

-(BOOL)getIsValidForTransition
{
	return isValidForTransition;
}

-(void)setIsValidForTransition:(BOOL)value
{
	@synchronized(isValidForTransitionString)
	{
		isValidForTransition = value;
	}
}

-(void)setNumberOfTouchesForReset:(uint8_t)value
{
	if(value > 2)
		numberOfTouchesForReset = value;
}

-(BOOL)getIsDisplayLinkSupported
{
	return displayLinkSupported;
}

-(BOOL)isMultipleTouchEnabled
{
	return YES;
}

-(UIInterfaceOrientation)currentDeviceOrientation
{
	return [UIApplication sharedApplication].statusBarOrientation;
}

-(NSTimer *)animationTimer
{
	return animationTimer;
}

-(void)setAnimationTimer:(NSTimer *)newTimer 
{
	if(animationTimer)
	{
		[animationTimer invalidate];
		animationTimer = nil;
	}
    animationTimer = newTimer;
}

-(id)displayLink
{
	return displayLink;
}

-(void)setDisplayLink:(id)value
{
	if(displayLink)
	{
		[displayLink invalidate];
		displayLink = nil;
	}
	displayLink = value;
}

-(void)setAnimationInterval:(NSTimeInterval)interval 
{    
    animationInterval = interval;
}

-(void)setAnimationFrameInterval:(NSUInteger)value
{
	if(value >= 1)
	{
		animationFrameInterval = value;
		if(isDisplayLinkSupported && displayLinkSupported)
			animationInterval = (kDefaultAnimationTimerIntervalByFrame) * value;
	}
}

-(BOOL)setAccelerometerDelegate:(id <UIAccelerometerDelegate>)accelerometerDelegate
{
	UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
	if(accelerometer)
	{
		accelerometer.delegate = accelerometerDelegate;
		accelerometer.updateInterval = accelerometerInterval;
		return YES;
	}
	return NO;
}

-(void)setAccelerometerInterval:(NSTimeInterval)value
{
	accelerometerInterval = value;
	[self activateAccelerometer];
}

-(void)setAccelerometerSensitivity:(float)value
{
	accelerometerSensitivity = [PLMath valueInRange:value range:PLRangeMake(kAccelerometerSensitivityMinValue, kAccelerometerSensitivityMaxValue)];
}

+(Class)layerClass 
{
    return [CAEAGLLayer class];
}

#pragma mark -
#pragma mark draw methods 

-(void)drawView
{
	if(isScrolling && delegate && [delegate respondsToSelector:@selector(view:shouldScroll:endPoint:)] && ![delegate view:self shouldScroll:startPoint endPoint:endPoint])
		return;
	[self drawViewInternally];
	if(isScrolling && delegate && [delegate respondsToSelector:@selector(view:didScroll:endPoint:)])
		[delegate view:self didScroll:startPoint endPoint:endPoint];
}

-(void)drawViewNTimes:(NSUInteger)times
{
	for(int i = 0; i < times; i++)
		[self drawView];
}

-(void)drawViewInternally
{
	if(scene && !isValidForFov && !isSensorialRotationRunning)
    {
        PLCamera *camera = scene.currentCamera;
		[camera rotateWithStartPoint:startPoint endPoint:endPoint];
        if(delegate && [delegate respondsToSelector:@selector(view:didRotateCamera:rotation:)])
            [delegate view:self didRotateCamera:camera rotation:[camera getAbsoluteRotation]];
    }
    if(renderer)
        [renderer render];
}

-(void)drawViewInternallyNTimes:(NSUInteger)times
{
	for(int i = 0; i < times; i++)
		[self drawViewInternally];
}

#pragma mark -
#pragma mark render buffer methods 

-(void)regenerateRenderBuffer
{
	if(renderer)
		[renderer resizeFromLayer];
}

#pragma mark -
#pragma mark layout methods 

-(void)layoutSubviews
{
	if(renderer)
		[renderer resizeFromLayer];
	if(!isAccelerometerActivated)
	{
		[self activateAccelerometer];
		isAccelerometerActivated = YES;
	}
    [self drawViewInternallyNTimes:2];
    [super layoutSubviews];
}

#pragma mark -
#pragma mark animation methods 

-(void)startAnimation 
{
	if(isAnimating)
		return;
	
	if(isDisplayLinkSupported && displayLinkSupported)
	{
		self.displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView)];
		[displayLink setFrameInterval:animationFrameInterval];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
	else
		self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
	
	if(isScrollingEnabled)
		isValidForScrolling = YES;
	[self stopInertia];
	
	isAnimating = YES;
}

-(void)stopAnimation
{
	if(isAnimating)
	{
		if(isDisplayLinkSupported && displayLinkSupported)
			self.displayLink = nil;
		else
			self.animationTimer = nil;
		[self stopOnlyAnimation];
		isAnimating = NO;
	}
	[self stopInertia];
}

-(void)stopOnlyAnimation
{
	if(isScrollingEnabled)
	{
		isValidForScrolling = NO;
		if(!isInertiaEnabled)
			isValidForTouch = NO;
	}
	else
		isValidForTouch = NO;
}

-(void)stopAnimationInternally
{		
	//[self stopInertia];
	//[self stopOnlyAnimation];
	[self stopAnimation];
}

#pragma mark -
#pragma mark fov methods

-(BOOL)calculateFov:(NSSet *)touches
{
	if([touches count] == 2)
	{				
		startFovPoint = [[[touches allObjects] objectAtIndex:0] locationInView:self];
		endFovPoint = [[[touches allObjects] objectAtIndex:1] locationInView:self];
		
		fovCounter++;
		if(fovCounter < kDefaultFovMinCounter)
		{
			fovDistance = [PLMath distanceBetweenPoints:startFovPoint :endFovPoint];
			return NO;
		}
		
		float distance = [PLMath distanceBetweenPoints:startFovPoint :endFovPoint];
		
		if(ABS(distance - fovDistance) < scene.currentCamera.minDistanceToEnableFov)
			return NO;
		
		distance = ABS(fovDistance) <= distance ? distance : -distance;
		BOOL isZoomIn = (distance >= 0);
		BOOL isNotCancelable = YES;
		
		if(delegate && [delegate respondsToSelector:@selector(view:shouldRunZooming:isZoomIn:isZoomOut:)])
			isNotCancelable = [delegate view:self shouldRunZooming:distance isZoomIn:isZoomIn isZoomOut:!isZoomIn];
		
		if(isNotCancelable)
		{
			fovDistance = distance;
			[scene.currentCamera addFovWithDistance:fovDistance];
			if(delegate && [delegate respondsToSelector:@selector(view:didRunZooming:isZoomIn:isZoomOut:)])
				[delegate view:self didRunZooming:fovDistance isZoomIn:isZoomIn isZoomOut:!isZoomIn];
			return YES;
		}
	}
	return NO;
}

#pragma mark -
#pragma mark action methods

-(BOOL)executeDefaultAction:(NSSet *)touches eventType:(PLTouchEventType)type
{
	NSUInteger touchCount = [touches count];
	if(touchCount >= numberOfTouchesForReset)
    {
        if(!isSensorialRotationRunning)
            [self executeResetAction:touches];
    }
	else if(touchCount == 2)
	{
		BOOL isNotCancelable = YES;
		if(delegate && [delegate respondsToSelector:@selector(viewShouldBeginZooming:)])
			isNotCancelable = [delegate viewShouldBeginZooming:self];
		if(isNotCancelable)
		{
			if(type == PLTouchEventTypeMoved)
				[self calculateFov:touches];
			else if(type == PLTouchEventTypeBegan)
			{
				startFovPoint = [[[touches allObjects] objectAtIndex:0] locationInView:self];
				endFovPoint = [[[touches allObjects] objectAtIndex:1] locationInView:self];
				if(delegate && [delegate respondsToSelector:@selector(view:didBeginZooming:endPoint:)])
					[delegate view:self didBeginZooming:startFovPoint endPoint:endFovPoint];
			}
			if(!isValidForFov)
			{
				[self startAnimation];
				isValidForFov = YES;
			}
		}
	}
	else if(touchCount == 1)
	{
		if(type == PLTouchEventTypeMoved)
		{
			if(isValidForFov || (startPoint.x == 0 && endPoint.y == 0))
				startPoint = [self getLocationOfFirstTouch:touches];
			if(!displayLink && !animationTimer)
				[self startAnimation];
		}
		else if(type == PLTouchEventTypeEnded && startPoint.x == 0 && endPoint.y == 0)
			startPoint = [self getLocationOfFirstTouch:touches];
		isValidForFov = NO;
		return NO;
	}
	return YES;
}

-(BOOL)executeResetAction:(NSSet *)touches
{
	if(isResetEnabled && [touches count] >= numberOfTouchesForReset) 
	{
		BOOL isNotCancelable = YES;
		if(delegate && [delegate respondsToSelector:@selector(viewShouldReset:)])
			isNotCancelable = [delegate viewShouldReset:self];
		if(isNotCancelable)
		{
			[self stopAnimationInternally];
			[self reset];
			[self drawViewInternally];
			if(delegate && [delegate respondsToSelector:@selector(viewDidReset:)])
				[delegate viewDidReset:self];
			return YES;
		}
	}
	return NO;
}

#pragma mark -
#pragma mark touch methods

-(BOOL)isTouchInView:(NSSet *)touches
{
	for(UITouch *touch in touches)
		if(touch.view != self)
			return NO;
	return YES;
}

-(CGPoint)getLocationOfFirstTouch:(NSSet *)touches
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	return [touch locationInView:touch.view];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if(delegate && [delegate respondsToSelector:@selector(view:touchesBegan:withEvent:)])
		[delegate view:self touchesBegan:touches withEvent:event];
	
	if(isBlocked || !scene || [self getIsValidForTransition])
		return;

    NSSet *eventTouches = [event allTouches];
    
	if(![self isTouchInView:eventTouches])
		return;
	
	if(delegate && [delegate respondsToSelector:@selector(view:shouldBeginTouching:withEvent:)] && ![delegate view:self shouldBeginTouching:eventTouches withEvent:event])
		return;
	
	switch([[eventTouches anyObject] tapCount])
	{
		case 1:
			touchStatus = PLTouchStatusSingleTapCount;
			if(isValidForScrolling)
			{
				[self stopAnimationInternally];
				startPoint = endPoint;
				isScrolling = NO;
				if(delegate && [delegate respondsToSelector:@selector(view:didEndScrolling:endPoint:)])
					[delegate view:self didEndScrolling:startPoint endPoint:endPoint];
			}
			else if(inertiaTimer)
			{
				[self stopAnimationInternally];
				startPoint = endPoint;
				if(delegate && [delegate respondsToSelector:@selector(view:didEndInertia:endPoint:)])
					[delegate view:self didEndInertia:startPoint endPoint:endPoint];
			}
			break;
		case 2:
			touchStatus = PLTouchStatusDoubleTapCount;
			break;
	}
	
	[self stopAnimationInternally];
	
	isValidForTouch = YES;
	touchStatus = PLTouchStatusBegan;
	fovCounter = 0;
	
	if(![self executeDefaultAction:eventTouches eventType:(PLTouchEventType)PLTouchStatusBegan])
	{
		startPoint = endPoint = [self getLocationOfFirstTouch:eventTouches];
		if([[eventTouches anyObject] tapCount] == 1)
		{
			touchStatus = PLTouchStatusFirstSingleTapCount;
            if(renderer)
                [renderer render];
			touchStatus = PLTouchStatusSingleTapCount;
		}
		[self startAnimation];
	}
    else if(isSensorialRotationRunning)
        [self startAnimation];
	
	if(delegate && [delegate respondsToSelector:@selector(view:didBeginTouching:withEvent:)])
		[delegate view:self didBeginTouching:eventTouches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(delegate && [delegate respondsToSelector:@selector(view:touchesMoved:withEvent:)])
		[delegate view:self touchesMoved:touches withEvent:event];
	
	if(isBlocked || !scene || [self getIsValidForTransition])
		return;
	
	NSSet *eventTouches = [event allTouches];
	
	if(![self isTouchInView:eventTouches])
		return;
	
	touchStatus = PLTouchStatusMoved;
	
	if(delegate && [delegate respondsToSelector:@selector(view:shouldTouch:withEvent:)] && ![delegate view:self shouldTouch:eventTouches withEvent:event])
		return;
	
	if(![self executeDefaultAction:eventTouches eventType:PLTouchEventTypeMoved])
		endPoint = [self getLocationOfFirstTouch:eventTouches];
	
	if(delegate && [delegate respondsToSelector:@selector(view:didTouch:withEvent:)])
		[delegate view:self didTouch:eventTouches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if(delegate && [delegate respondsToSelector:@selector(view:touchesEnded:withEvent:)])
		[delegate view:self touchesEnded:touches withEvent:event];
	
	if(isBlocked || !scene || [self getIsValidForTransition])
		return;
	
	NSSet *eventTouches = [event allTouches];
	
	if(![self isTouchInView:eventTouches])
		return;
	
	touchStatus = PLTouchStatusEnded;
	
	if(delegate && [delegate respondsToSelector:@selector(view:shouldEndTouching:withEvent:)] && ![delegate view:self shouldEndTouching:eventTouches withEvent:event])
		return;
		
	if(isValidForFov)
	{
		if([eventTouches count] == [touches count])
		{
			startPoint = endPoint = CGPointMake(0.0f, 0.0f);
			isValidForFov = isValidForTouch = NO;
            if(!isSensorialRotationRunning)
                [self stopAnimationInternally];
		}
	}
	else 
	{
		if(![self executeDefaultAction:eventTouches eventType:PLTouchEventTypeEnded])
		{
			endPoint = [self getLocationOfFirstTouch:eventTouches];
			BOOL isNotCancelable = YES;
				
			if(isScrollingEnabled && delegate && [delegate respondsToSelector:@selector(view:shouldBeingScrolling:endPoint:)])
				isNotCancelable = [delegate view:self shouldBeingScrolling:startPoint endPoint:endPoint];
				
			if(isScrollingEnabled && isNotCancelable)
			{
				BOOL isValidForMove = ([PLMath distanceBetweenPoints:startPoint :endPoint] <= minDistanceToEnableScrolling);
				if(isInertiaEnabled)
				{
					[self stopOnlyAnimation];
					if(isValidForMove)
						isValidForTouch = NO;
					else
					{
						isNotCancelable = NO;
						if(delegate && [delegate respondsToSelector:@selector(view:shouldBeginInertia:endPoint:)])
							isNotCancelable = [delegate view:self shouldBeginInertia:startPoint endPoint:endPoint];
						if(isNotCancelable)
							[self startInertia];
					}
				}
				else
				{
					if(isValidForMove)
                        [self stopOnlyAnimation];
					else
					{
						isScrolling = YES;
						if(delegate && [delegate respondsToSelector:@selector(view:didBeginScrolling:endPoint:)])
							[delegate view:self didBeginScrolling:startPoint endPoint:endPoint];
					}
				}
			}
			else
			{
				startPoint = endPoint;
                [self stopOnlyAnimation];
				if(delegate && [delegate respondsToSelector:@selector(view:didEndMoving:endPoint:)])
					[delegate view:self didEndMoving:startPoint endPoint:endPoint];
			}
		}
	}
	
	if(delegate && [delegate respondsToSelector:@selector(view:didEndTouching:withEvent:)])
		[delegate view:self didEndTouching:eventTouches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopAnimationInternally];
	isValidForFov = isValidForTouch = NO;
}

#pragma mark -
#pragma mark inertia methods

-(void)startInertia
{
	[self stopInertia];
	float interval = inertiaInterval / [PLMath distanceBetweenPoints:startPoint :endPoint];
	if(interval < 0.01f)
	{
		inertiaStepValue = 0.01f / interval;
		interval = 0.01f;
	}
	else
		inertiaStepValue = 1.0f;
	inertiaTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(inertia) userInfo:nil repeats:YES];
	
	if(delegate && [delegate respondsToSelector:@selector(view:didBeginInertia:endPoint:)])
		[delegate view:self didBeginInertia:startPoint endPoint:endPoint];
}

-(void)stopInertia
{
	if(inertiaTimer)
	{
		[inertiaTimer invalidate];
		inertiaTimer = nil;
	}
}

-(void)inertia
{
	if(delegate && [delegate respondsToSelector:@selector(view:shouldRunInertia:endPoint:)] && ![delegate view:self shouldRunInertia:startPoint endPoint:endPoint])
		return;
	
	float m = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x);
	float b = (startPoint.y * endPoint.x - endPoint.y * startPoint.x) / (endPoint.x - startPoint.x);
	float x, y, add;
	
	if(ABS(endPoint.x - startPoint.x) >= ABS(endPoint.y - startPoint.y))
	{
		add = (endPoint.x > startPoint.x ? -inertiaStepValue : inertiaStepValue);
		x = endPoint.x + add;
		if((add > 0.0f && x > startPoint.x) || (add <= 0.0f && x < startPoint.x))
		{
			[self stopInertia];
			isValidForTouch = NO;
			
			if(delegate && [delegate respondsToSelector:@selector(view:didEndInertia:endPoint:)])
				[delegate view:self didEndInertia:startPoint endPoint:endPoint];
			
			return;
		}
		y = m * x + b;
	}
	else
	{
		add = (endPoint.y > startPoint.y ? -inertiaStepValue : inertiaStepValue);
		y = endPoint.y + add;
		if((add > 0.0f && y > startPoint.y) || (add <= 0.0f && y < startPoint.y))
		{
			[self stopInertia];
			isValidForTouch = NO;
			
			if(delegate && [delegate respondsToSelector:@selector(view:didEndInertia:endPoint:)])
				[delegate view:self didEndInertia:startPoint endPoint:endPoint];
			
			return;
		}
		x = (y - b)/m;
	}
	endPoint = CGPointMake(x, y);
	[self drawView];
	
	if(delegate && [delegate respondsToSelector:@selector(view:didRunInertia:endPoint:)])
		[delegate view:self didRunInertia:startPoint endPoint:endPoint];
}

#pragma mark -
#pragma mark accelerometer methods

-(void)activateAccelerometer
{
	if(![self setAccelerometerDelegate:self])
        [PLLog debug:@"PLViewBase::activateAccelerometer" format:@"Accelerometer not running on the device!", nil];
}

-(void)deactiveAccelerometer
{
	[self setAccelerometerDelegate:nil];
}

#define kSensorialRotationErrorMargin 5
 
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(isSensorialRotationRunning && sensorType == PLSensorTypeMagnetometer)
    {
        int pitch = ABS((int)(atan2(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? acceleration.y : acceleration.x, acceleration.z) * 180.0 / M_PI));
        //double distanceFactor = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z);
        //int pitch = (int)(acos(acceleration.z / distanceFactor) * 180.0 / M_PI);
        if(lastAccelerometerPitch != -1)
        {
            if((pitch > lastAccelerometerPitch && pitch - kSensorialRotationErrorMargin > lastAccelerometerPitch) || (pitch < lastAccelerometerPitch && pitch + kSensorialRotationErrorMargin < lastAccelerometerPitch))
                lastAccelerometerPitch = pitch;
        }
        else
            lastAccelerometerPitch = accelerometerPitch = pitch;
    }
    
    if(isBlocked || isSensorialRotationRunning || !scene || [self getIsValidForTransition])
		return;
	
	if([self resetWithShake:acceleration])
		return;
	
	if(isValidForTouch)
		return;
	
	if(isAccelerometerEnabled)
	{
		if(delegate && [delegate respondsToSelector:@selector(view:shouldAccelerate:withAccelerometer:)] && ![delegate view:self shouldAccelerate:acceleration withAccelerometer:accelerometer])
			return;
		
		UIAccelerationValue x = 0, y = 0;
		float factor = kAccelerometerMultiplyFactor * accelerometerSensitivity;
		UIInterfaceOrientation currentOrientation = [self currentDeviceOrientation];
		switch (currentOrientation) 
		{
			case UIDeviceOrientationPortrait:
			case UIDeviceOrientationPortraitUpsideDown:
				x = (isAccelerometerLeftRightEnabled ? acceleration.x : 0.0f);
				y = (isAccelerometerUpDownEnabled ? acceleration.z : 0.0f);
				startPoint = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
				if(currentOrientation == UIDeviceOrientationPortraitUpsideDown)
				{
					x = -x;
					y = -y;
				}
				break;
			case UIDeviceOrientationLandscapeLeft:
			case UIDeviceOrientationLandscapeRight:
				x = (isAccelerometerLeftRightEnabled ? -acceleration.y : 0.0f);
				y = (isAccelerometerUpDownEnabled ? -acceleration.z : 0.0f);
				startPoint = CGPointMake(self.bounds.size.height / 2.0f, self.bounds.size.width / 2.0f);
				if(currentOrientation == UIDeviceOrientationLandscapeRight)
				{
					x = -x;
					y = -y;
				}
                break;
		}

		endPoint = CGPointMake(startPoint.x + (x * factor), startPoint.y + (y * factor));
		[self drawView];
		
		if(delegate && [delegate respondsToSelector:@selector(view:didAccelerate:withAccelerometer:)])
			[delegate view:self didAccelerate:acceleration withAccelerometer:accelerometer];
	}
}

#pragma mark -
#pragma mark sensorial rotation methods

-(void)startSensorialRotation
{
    if(!isSensorialRotationRunning)
    {
        /**
         * IMPORTANT: Gyroscope was not tested because, I do not have a device that support it. The function doGyroUpdate needs be tested and fix it.
         */
        /*motionManager = [[CMMotionManager alloc] init]; 
        if(motionManager.gyroAvailable)
        {
            motionManager.gyroUpdateInterval = 1.0/30.0;
            [motionManager startGyroUpdates];
            motionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                     target:self 
                                                   selector:@selector(doGyroUpdate)
                                                   userInfo:nil 
                                                    repeats:YES];
            sensorType = PLSensorTypeGyroscope;
            isSensorialRotationRunning = YES;
        }
        else*/
        {
            [PLLog debug:@"PLViewBase::startSensorialRotation" format:@"No gyroscope on device.", nil];
            if(motionManager)
            {
                [motionManager release];
                motionManager = nil;
            }
            if([CLLocationManager headingAvailable])
            {
                lastAccelerometerPitch = accelerometerPitch = -1;
                firstMagneticHeading = magneticHeading = -1;
                locationManager = [[CLLocationManager alloc] init];
                locationManager.headingFilter = kCLHeadingFilterNone;
                locationManager.delegate = self;
                [locationManager startUpdatingHeading];
                [self activateAccelerometer];
                motionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                               target:self 
                                                             selector:@selector(doSimulatedGyroUpdate)
                                                             userInfo:nil 
                                                              repeats:YES];
                sensorType = PLSensorTypeMagnetometer;
                isSensorialRotationRunning = YES;
            }
            else
                [PLLog debug:@"PLViewBase::startSensorialRotation" format:@"No magnetometer available on device.", nil];
        }
    }
}

/**
 * IMPORTANT: Gyroscope was not tested because, I do not have a device that support it. The function doGyroUpdate needs be tested and fix it.
 */

-(void)doGyroUpdate
{
    if(scene)
    {
        //CMRotationRate rotationRate = motionManager.gyroData.rotationRate;
        CMAttitude *attitude = motionManager.deviceMotion.attitude;
        double pitch = attitude.pitch * 180.0 / M_PI - 90.0;
        double yaw = attitude.yaw * 180.0 / M_PI - 180.0;
        [scene.currentCamera lookAtWithPitch:pitch yaw:yaw];
    }
}


-(void)doSimulatedGyroUpdate
{
    if(scene && lastAccelerometerPitch != -1 && firstMagneticHeading != -1)
    {
        float step = (ABS(lastAccelerometerPitch - accelerometerPitch) <= 5 ? 0.25f : 1.0f);
        if(lastAccelerometerPitch > accelerometerPitch)
            accelerometerPitch += step;
        else if(lastAccelerometerPitch < accelerometerPitch)
            accelerometerPitch -= step;
        [scene.currentCamera lookAtWithPitch:accelerometerPitch - 90 yaw:-magneticHeading]; 
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading
{
    if(firstMagneticHeading == -1)
    {
        firstMagneticHeading = heading.magneticHeading;
        magneticHeading = 0.0f;
    }
    else if(lastAccelerometerPitch > 50)
        magneticHeading = heading.magneticHeading - firstMagneticHeading;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([error code] == kCLErrorDenied)
        [self stopSensorialRotation];
    else if([error code] == kCLErrorHeadingFailure)
    {
    }
}

-(void)stopSensorialRotation
{
    if(isSensorialRotationRunning)
    {
        startPoint = endPoint = CGPointMake(0.0f, 0.0f);
        isSensorialRotationRunning = NO;
        sensorType = PLSensorTypeUnknow;
        if(motionTimer)
        {
            [motionTimer invalidate];
            motionTimer = nil;
        }
        if(motionManager)
        {
            [motionManager stopGyroUpdates];
            [motionManager release];
            motionManager = nil;
        }
        if(locationManager)
        {
            [locationManager stopUpdatingHeading];
            [locationManager release];
            locationManager = nil;
        }
    }
}

#pragma mark -
#pragma mark shake methods

-(void)setShakeThreshold:(float)value
{
	if(value > 0.0f)
		shakeThreshold = value;
}

-(BOOL)resetWithShake:(UIAcceleration *)acceleration
{
	if(!isShakeResetEnabled || !isResetEnabled)
		return NO;
	
	BOOL result = NO;
	long currentTime = (long)(CACurrentMediaTime() * 1000);
	
	if ((currentTime - shakeData.lastTime) > kShakeDiffTime)
	{
		long diffTime = (currentTime - shakeData.lastTime);
		shakeData.lastTime = currentTime;
		
		shakeData.shakePosition.x = acceleration.x;
		shakeData.shakePosition.y = acceleration.y;
		shakeData.shakePosition.z = acceleration.z;
		
		float speed = ABS(shakeData.shakePosition.x + shakeData.shakePosition.y + shakeData.shakePosition.z - shakeData.shakeLastPosition.x - shakeData.shakeLastPosition.y - shakeData.shakeLastPosition.z) / diffTime * 10000;
		if (speed > shakeThreshold)
		{
			[self reset];
			[self drawViewInternally];
			result = YES;
		}
		
		shakeData.shakeLastPosition.x = shakeData.shakePosition.x; 
		shakeData.shakeLastPosition.y = shakeData.shakePosition.y; 
		shakeData.shakeLastPosition.z = shakeData.shakePosition.z;
	}
	return result;
}

#pragma mark -
#pragma mark transition methods

-(BOOL)executeTransition:(PLTransition *)transition
{
	if(!scene || !renderer || !transition || [self getIsValidForTransition])
		return NO;
	
	[self setIsValidForTransition:YES];
	isValidForTouch = NO;
	
	startPoint = endPoint = CGPointMake(0.0f, 0.0f);
	
	currentTransition = [transition retain];
	currentTransition.delegate = self;
	[currentTransition executeWithView:self scene:scene];
	
	return YES;
}

-(void)transition:(PLTransition *)transition didBeginTransition:(PLTransitionType)type
{
	if(delegate && [delegate respondsToSelector:@selector(view:didBeginTransition:)])
		[delegate view:self didBeginTransition:transition];
}

-(void)transition:(PLTransition *)transition didProcessTransition:(PLTransitionType)type progressPercentage:(NSUInteger)progressPercentage
{
	if(delegate && [delegate respondsToSelector:@selector(view:didProcessTransition:progressPercentage:)])
		[delegate view:self didProcessTransition:transition progressPercentage:progressPercentage];
}

-(void)transition:(PLTransition *)transition didEndTransition:(PLTransitionType)type
{
	[self setIsValidForTransition:NO];
	if(currentTransition)
	{
		[currentTransition release];
		currentTransition = nil;
	}
	if(delegate && [delegate respondsToSelector:@selector(view:didEndTransition:)])
		[delegate view:self didEndTransition:transition];
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc 
{
	[self stopAnimation];
	[self reset];
	[self deactiveAccelerometer];
	if(isValidForTransitionString)
		[isValidForTransitionString release];
	if(currentTransition)
	{
		[currentTransition stop];
		[currentTransition release];
	}
    if(renderer)
    {
        [renderer stop];
		[renderer release];
    }
    if(scene)
		[scene release];
	[super dealloc];
}
				
@end
