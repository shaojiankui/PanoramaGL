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

#import "PLIRenderableElement.h"
#import "PLCamera.h"
#import "PLSceneElement.h"

@protocol PLIView;

@protocol PLIScene <PLIRenderableElement>

@required

#pragma mark -
#pragma mark properties

@property(nonatomic, readonly) NSMutableArray *cameras;
@property(nonatomic, readonly) PLCamera *currentCamera;
@property(nonatomic, assign) NSUInteger cameraIndex;
@property(nonatomic, readonly) NSMutableArray *elements;
@property(nonatomic, readonly) UIView<PLIView> *view;

#pragma mark -
#pragma mark init methods

-(id)initWithCamera:(PLCamera *)camera;
-(id)initWithElement:(PLSceneElement *)element;
-(id)initWithElement:(PLSceneElement *)element camera:(PLCamera *)camera;

-(id)initWithView:(UIView<PLIView> *)view;
-(id)initWithView:(UIView<PLIView> *)view camera:(PLCamera *)camera;
-(id)initWithView:(UIView<PLIView> *)view element:(PLSceneElement *)element;
-(id)initWithView:(UIView<PLIView> *)view element:(PLSceneElement *)element camera:(PLCamera *)camera;

#pragma mark -
#pragma mark reset methods

-(void)resetAlpha;

#pragma mark -
#pragma mark camera methods

-(void)addCamera:(PLCamera *)camera;
-(void)removeCameraAtIndex:(NSUInteger)index;
-(void)removeCamera:(PLCamera *)camera;
-(void)removeAllCameras;

#pragma mark -
#pragma mark element methods

-(void)addElement:(PLSceneElement *)element;
-(void)removeElementAtIndex:(NSUInteger)index;
-(void)removeElement:(PLSceneElement *)element;
-(void)removeAllElements;

@end
