# HTAdjustView
## Show
![demoImg](https://github.com/runThor/HTAdjustView/raw/master/Other/Demo.png)
## Usage
```Objective-C
// ViewController.m

#import "HTAdjustView.h"

HTAdjustView *adjustView = [[HTAdjustView alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
[adjustView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
[adjustView setName:@"水泵" value:90 unit:@"L" maxValue:150 minValue:30];
[self.view addSubview:adjustView];
```
