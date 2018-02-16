<h1>Introduction</h1>
INTUZ is presenting an interesting  Address Picker Control to integrate inside your Native iOS based application. 
Address Picker is a simple component, which lets you pick a location from map and search using Google Places API. 
You will get a latitude, longitude and full address for selected location.

Please follow the below steps to integrate this control in your next project.

<br/><br/>
<h1>Features</h1>

- Easy & Fast to get customer location picker.
- You can select a location from Google Place API or User’s current location.
- Allow to get location in easy block implementation.
- Fully customised design layout.

<br/><br/>
<img src="Screenshots/Screen1.png” width="300"/>

<img src="Screenshots/Screen2.png” width="300"/>

<img src="Screenshots/Screen3.png” width="300"/>



<br/><br/>
<h1>Getting Started</h1>

To use this component in your project you need to perform below steps:

1) Configure Google Firebase and Google Console Application to get API Key & Plist file from below URL.

> https://developers.google.com/places/ios-api/start

2) Install below list of CocoaPods in your application.

```
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SVProgressHUD'
```

3) Configure Google API Key & setup SVProgressHUD appearance in `didFinishLaunchingWithOptions` method.

```
// Setup SVProgressHUD Appearnce.
LocationUtility.sharedUtility.initOnce()
        
// Google Setup.
GMSPlacesClient.provideAPIKey(GoogleAPIKey)
GMSServices.provideAPIKey(GoogleAPIKey)
```

<br/>
<p><b>Note:</b> replace ‘<Your-Google-API-Key>’ with your google api key.</p>

4) Add ‘GoogleService-Info.plist’ in your project and you will get this file from Google Firebase Console.

<br/>
<p><b>Note:</b> If you not add ‘GoogleService-Info.plist’ file in your application then application will crash.</p>

5) Configure URL Types with 'REVERSED_CLIENT_ID' value from ‘GoogleService-Info.plist’. To configure URL Types please follow below steps.

Copy value of ‘REVERSED_CLIENT_ID’ from ‘GoogleService-Info.plist’.
Select Project->Targets and open “info” tab.
Expand URL Types at bottom of screen and click on + button.
Add ‘REVERSED_CLIENT_ID’ value in ‘URL Schemes’.

6) Copy ‘IntPickerViewController’ folder and add it to your project and make sure you have checked “Copy if needed” option.

7) Implement Address Picker from below code.

```
IntPickerViewController.show (with : self, coordinate: nil, address : "", completion :{
	newCoordinate, newAddress in
            
            let strMessage = "Lat: \((newCoordinate?.latitude ?? 0.0)!) Long: \((newCoordinate?.longitude ?? 0.0)!)\n\nAddress: \(newAddress!)"
            print(strMessage)
        })
``` 

<br/><br/>
<h1>Bugs and Feedback</h1>
For bugs, questions and discussions please use the Github Issues.

<br/><br/>
<h1>License</h1>
The MIT License (MIT)
<br/><br/>
Copyright (c) 2018 INTUZ
<br/><br/>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
<br/><br/>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<br/>
<br/>
<h1></h1>
<a href="https://www.intuz.com/" target="_blank"><img src="Screenshots/logo.jpg"></a>


