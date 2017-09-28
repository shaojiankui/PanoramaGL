# PanoramaGL  全景展示
PanoramaGL, fixed some issues,share to someone need it,supports arm64,create by xcode7

based https://code.google.com/p/panoramagl

![](https://raw.githubusercontent.com/shaojiankui/PanoramaGL/master/demo.gif)


## 变更

* fix arm64 PLHotspot bug 		修正arm64下PLHotspot不能点击的bug
* texture supports 2048*2048  	纹理支持2048*2048
* remove some warning 			移除一些警告
* use CMMotionManager replace UIAccelerometer 对重力感应做了向下兼容
* add Accelerometer Effect  添加了重力感应效果

## 其他选择

* Panorama 	   https://github.com/robbykraft/Panorama
* JAPanoView     https://bitbucket.org/javieralonso/japanoview
* threejs.org    http://threejs.org/examples/webgl_panorama_equirectangular.html
* SceneKit自己动手实现全景展示 https://github.com/shaojiankui/Panorama-SceneKit
* OpenGL自己动手实现全景展示 https://github.com/shaojiankui/Panorama-OpenGL

## 工具
* Pano2vr 全景图像转化与制作软件
Pano2vr软件非常强大，可以鱼眼图与六方图互相转换，可以确定hotspot交互热点，可以输出html flash文件直接浏览。
![](https://raw.githubusercontent.com/shaojiankui/PanoramaGL/master/pano2vr.png)


## 扩展阅读

[iOS开发之360°/720°全景展示](http://www.skyfox.org/ios-720-panoramic-show.html) 

