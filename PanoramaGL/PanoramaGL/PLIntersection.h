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

/*
 * This functions are a port from C++ to Objective-C of 
 * "Demonstration of a line mesh intersection test (Sample1-Mesh_Line_Intersection.zip)" 
 * example by Jonathan Kreuzer http://www.3dkingdoms.com/weekly. 
 * See checkLineBoxWithRay.h and checkLineBoxWithRay.cpp.
 */

#import "PLVector3.h"

@interface PLIntersection : NSObject

#pragma mark -
#pragma mark check methods

+(BOOL)checkLineBoxWithRay:(PLVector3 **)ray startBound:(PLVector3 *)startBound endBound:(PLVector3 *)endBound hitPoint:(PLVector3 **)hitPoint;
+(BOOL)checkLineBoxWithRay:(PLVector3 **)ray point1:(PLVector3 *)point1 point2:(PLVector3 *)point2 point3:(PLVector3 *)point3 point4:(PLVector3 *)point4 hitPoint:(PLVector3 **)hitPoint;
+(BOOL)checkLineTriangleWithRay:(PLVector3 **)ray firstVertex:(PLVector3 *)firstVertex secondVertex:(PLVector3 *)secondVertex thirdVertex:(PLVector3 *)thirdVertex hitPoint:(PLVector3 **)hitPoint;

@end

