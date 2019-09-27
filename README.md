[![Platform](https://img.shields.io/cocoapods/p/TGLExpandingButton.svg?maxAge=86400)]()
[![Tag](https://img.shields.io/github/tag/gleue/TGLExpandingButton.svg?maxAge=86400)]()
[![License](https://img.shields.io/github/license/gleue/TGLExpandingButton.svg?maxAge=86400)]()
[![Downloads](https://img.shields.io/cocoapods/dt/TGLExpandingButton.svg?maxAge=86400)]()

TGLExpandingButton
==================

A control that expands and collapses when one of its button subviews is tapped -- perfect for simple menus or option selection.
 
<p align="center">
<img src="https://raw.github.com/gleue/TGLExpandingButton/master/Screenshots/TGLExpandingButtonExample.gif" alt="TGLExpandingButtonExample" title="TGLExpandingButtonExample">
</p>

Getting Started
===============

Take a look at sample project `TGLExpandingExample.xcodeproj`. 

Usage
=====

Via [CocoaPods](http://cocoapods.org):

* Add `pod 'TGLExpandingButton', '~> 1.0'` to your project's `Podfile`

Or the "classic" way:

* Add files in folder `TGLExpandingButton` to your project

Then in your project:

* Create a `TGLExpandingButton` control in a Storyboard or in code
* Add `UIButtons` as direct subviews to the control and configure them at will
* Add layout constraints to define width and height of the control as well as the buttons
* Connect the control's `valueChanged` event to a suitable action in your code

Requirements
============

* Swift >= 5
* iOS >= 9.0
* Xcode >= 10.0

License
=======

TGLExpandingButton is available under the MIT License (MIT)

Copyright (c) 2017-2019 Tim Gleue (http://gleue-interactive.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
