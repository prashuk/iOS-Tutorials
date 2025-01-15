# View App Life Cycle

## Before Scene Delegate Added

#### App run and First View Controller Shown

- Will Finishing Launching With Options
- Did Finishing Launching With Options
- Scene Will Enter Foreground
- Scene Did Become Active
- View Did Load First View Controller
- View Will Appear
- View Will Layout Subviews
- View Did Layout Subviews
- View Did Appear

#### Move to Second View Controller

- View Did Load Second View Controller
- View Will Disappear
- View Will Appear Second View Controller
- View Did Disappear
- View Did Appear Second View Controller

#### Move to first viewController

- View Will Disappear Second View Controller
- View Will Appear
- View Did Disappear Second View Controller
- View Did Appear

#### Press home button

- Application Will Resign Active
- Application Did Enter Background

#### Tap on app

- Application Will Enter Foreground
- Application Did Become Active

## After Scene Delegate Added

#### App run and First View Controller Shown

- Will Finishing Launching With Options
- Did Finishing Launching With Options
- Scene Will Enter Foreground
- Scene Did Become Active
- View Did Load First View Controller
- View Will Appear
- View Will Layout Subviews
- View Did Layout Subviews
- View Did Appear

#### Move to Second View Controller

- View Did Load Second View Controller
- View Will Disappear
- View Will Appear Second View Controller
- View Did Disappear
- View Did Appear Second View Controller

#### Move to first viewController

- View Will Disappear Second View Controller
- View Will Appear
- View Did Disappear Second View Controller
- View Did Appear

#### App swipe up

- Scene Will Resign Active
- Scene Did Enter Background
- View Will Layout Subviews
- View Did Layout Subviews

#### Tap on app

- Scene Will Enter Foreground
- Scene Did Become Active