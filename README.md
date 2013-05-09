uicolor-helpers
===============

UIColor extension
* color from 8bit RGB and hex values
* color from CSS RGB and hex strings
* color caching by name
* color loading from JSON and Plist
* core graphics equivalent extensions 

 
**Sample JSON**

    {
      "color1": "0xff22ff",
      "color2": "rgb(25.0, 180.0, 65.0)",
      "color3": "rgba(122.0, 102.0, 0.0, 1.0)",
      "color4": "#5522f2"
    }

**Loading colors from file**

    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    if ([UIColor setColorsWithContentsOfFile:path])
    {
        // colors loaded
    }

**Accessing colors by name**

    UIColor *color = [UIColor colorNamed:@"color1"];
