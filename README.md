# Kinvey GeoTag

This is a Kinvey sample app, to use make an account on
https://console.kinvey.com

For more details, see the blog post at http://goo.gl/9dyMm.


Also, you have to update `app-key` and `app-secret` in the file `KGAAppDelegate.m`
to your app-key and app-secret from the Kinvey console.


This has now been updated to take advantage of our data providers.

To enable Data Integration with this app, just

* Go to the **Locations** Add-On and select a provider. For example, choose "FourSquare" ![Enable Data Integration](https://github.com/KinveyApps/GeoTag-iOS/raw/master/Screenshots/Enable.png "Enable Data Integration")
* Name the endpoint `hotels` and enter your foursquare credentials. Then press `Create Configuration`. ![Enter Credentials](https://github.com/KinveyApps/GeoTag-iOS/raw/master/Screenshots/Active.png "Enter Credentials")
