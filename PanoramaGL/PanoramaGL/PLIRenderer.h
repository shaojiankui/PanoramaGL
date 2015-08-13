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

#import "PLIView.h"

@protocol PLIRenderer <NSObject>

@required

#pragma mark -
#pragma mark properties

@property(nonatomic, assign) UIView<PLIView> *view;
@property(nonatomic, assign) NSObject<PLIScene> *scene;
@property(nonatomic, readonly) BOOL isValid;
@property(nonatomic, readonly, getter = isRunning) BOOL isRunning;
@property(nonatomic, readonly) GLint backingWidth, backingHeight;

#pragma mark -
#pragma mark init methods

-(id)initWithView:(UIView<PLIView> *)view scene:(NSObject<PLIScene> *)scene;
+(id)rendererWithView:(UIView<PLIView> *)view scene:(NSObject<PLIScene> *)scene;

#pragma mark -
#pragma mark render methods

-(void)render;
-(void)renderNTimes:(NSUInteger)times;

#pragma mark -
#pragma mark buffer methods

-(BOOL)resizeFromLayer;

#pragma mark -
#pragma mark control methods

-(void)start;
-(BOOL)isRunning;
-(void)stop;

@end
