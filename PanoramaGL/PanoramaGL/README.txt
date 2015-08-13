PanoramaGL Library
==================

Version: 0.1

Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>

1. Project description
======================
PanoramaGL library was the first open source library in the world to see panoramic views on the iPhone and iPod Touch. The supported features in version 0.1 are:

- Run on iPhone, iPod Touch and iPad
- Tested with SDK 4.x to 5.x
- Supports OpenGL ES 1.1
- Supports spherical, cubic and cylindrical panoramic images
- Allows scrolling and continuous scrolling
- Supports scrolling left to right and from top to bottom using the accelerometer
- Allows to use the inertia to stop scrolling
- Supports zoom in and zoom out (moving two fingers on the screen)
- Supports reset (placing three fingers on the screen or shaking the device)
- Allows you to control the range of rotation in the x and y axis
- Support for view events
- Support for hotspots
- Support for movement with simulated gyroscope (Only compatible with devices with Magnetometer and Accelerometer)

2. Licensing
============
* PanoramaGL is open source licensed under the Apache License version 2.0.
* Please, do not forget to put the credits in your app :).

PanoramaGL uses:
================
* glues: It is an OpenGL ES 1.0 CM port of part of GLU library by Mike Gorchak <mike@malva.ua> and licensed under SGI FREE SOFTWARE LICENSE B version 2.0.
* JSONKit: It is a JSON framework created by John Engelhart and licensed under Apache Licence version 2.0.

3. Requirements
===============
* iPhone >= 3g, iPod Touch >= 2g or iPad
* iOS >= 4.x
 
4. How to import PanoramaGL library?
====================================
a. Download PanoramaGL_0.1.zip or download the source code from repository
b. If you download the zip file then descompress the file
c. Copy PanoramaGL folder inside your project folder
d. Import PanoramaGL folder in your project (You can drag and drop the folder inside XCode)
f. Import the frameworks:
    -CoreMotion
    -CoreLocation
    -MobileCoreServices
    -SystemConfiguration
    -QuartzCore
    -OpenGLES
    -CFNetwork
    -UIKit
    -Foundation
    -CoreGraphics
g. Import the libraries:
    -libxml2.dylib
    -libz.dylib
    
To import frameworks and libraries you must:
    i. Select you project (select the root)
    ii. Go to "TARGETS" and select the project
    iii. Select "Build Phases" option
    iv. Go to "Link Binary With Libraries" panel
    v. Select "+" option
    vi. Select frameworks and libraries in the list (Use cmd key for multiple options)
    vii. Click on "Add" button

5. How to use PanoramaGL in your app?
=====================================
For next example, I have imported a spherical image named pano.jpg in the project.

5.1. With Interface Builder
===========================
a. Create a ViewController
b. Open ViewController with Interface Builder
c. Select the View in "Objects" panel
d. Show "Identity Inspector" (View->Utilities->Show Identity Inspector or Alt+Cmd+5)
e. Change in "Custom Class" the Class from UIView to PLView
f. Go to ViewController.h and import PLView.h (eg. #import "PLView.h")
g. Open ViewController.m, go to viewDidLoad method and put this code:
    PLView *plView = (PLView *)self.view;
    PLSpherical2Panorama *panorama = [PLSpherical2Panorama panorama];
    [panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano" ofType:@"jpg"]]];
    [plView setPanorama:panorama];

5.2. Only with code
===================
a. Import PLView.h in your class (eg. #import "PLView.h")
b. Create a variable of type PLView (eg. PLView *plView)
c. Create the view (eg. plView = [[PLView alloc] initWithFrame:CGRectMake(x,y,w,h)])
d. Load panorama:
    PLView *plView = [[PLView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    PLSpherical2Panorama *panorama = [PLSpherical2Panorama panorama];
    [panorama setImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"pano" ofType:@"jpg"]]];
    [plView setPanorama:panorama];
e. Add panorama view to the window or view:
    [window addSubview:plView] or [your_view addSubview:plView]
f. Release the view
    [plView release];

6. Simple JSON Protocol
=======================
Also, you can use JSON protocol to load panoramas. 

Note: JSON protocol is limited for local files in this version.

Source code:
============

[plView load:[PLJSONLoader loaderWithPath:[[NSBundle mainBundle] pathForResource:@"json" ofType:@"data"]]];

Note: For this code, I have a file named json.data in my app. 

JSON Protocol:
==============

{
    "urlBase": "res://",        //This is always res:// (this feature will be improve for support http protocol)
    "type": "spherical",        //Panorama type: spherical, spherical2, cubic, cylindrical
    "sensorialRotation": false, //Simulated gyroscope [true, false] (Optional)
    "images":                   //Panoramic images section
    {
        "preview": "preview.jpg",  //Preview image (Optional, this option will be used with http protocol)
        "image": "pano.jpg"     //Panoramic image name for spherical, spherical2 and cylindrical panoramas
        "front": "front.jpg",   //Front image for cubic panorama (only use with cubic panorama)
        "back": "back.jpg",     //Back image for cubic panorama (only use with cubic panorama)
        "left": "left.jpg",     //Left image for cubic panorama (only use with cubic panorama)
        "right": "right.jpg",   //Right image for cubic panorama (only use with cubic panorama)
        "up": "up.jpg",         //Up image for cubic panorama (only use with cubic panorama)
        "down": "down.jpg"      //Down image for cubic panorama (only use with cubic panorama)
    },
    "camera":                   //Camera settings section (Optional)
    {
        "vlookat": 0,           //Initial vertical position [-90, 90]
        "hlookat": 0,           //Initial horizontal position [-180, 180]
        "atvmin": -90,          //Min vertical position [-90, 90]
        "atvmax": 90,           //Max vertical position [-90, 90]
        "athmin": -180,         //Min horizontal position [-180, 180]
        "athmax": 180           //Max horizontal position [-180, 180]
    },
    "hotspots": [               //Hotspots section (Optional, this section is an array of hotspots)
                 {
                 "id": 1,               //Hotspot identifier (long)
                 "atv": 0,              //Vertical position [-90, 90]
                 "ath": 0,              //Horizontal position [-180, 180]
                 "width": 0.08,         //Width
                 "height": 0.08,        //Height
                 "image": "hotspot.png" //Image
                 }
                 ]
}

See:
====
* PLJSONLoader class and PLView load method.
* json.data, json_s2.data and json_cubic.data on "HelloPanoramaGL" example.

7. More information
===================
For more details, please check "HelloPanoramaGL" example. 
This example is compatible for iPhone, iPod Touch and iPad.

8. Supporting this project
==========================
If you want to support this project, please donate to my Paypal account

https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=TN942N9FFXYEL&lc=EC&item_name=PanoramaGL&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted