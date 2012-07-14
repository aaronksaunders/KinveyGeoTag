# Kinvey GeoTag

This is a Kinvey sample app, to use make an account on
https://console.kinvey.com

For more details, see the blog post at http://goo.gl/9dyMm.


Also, you have to update `app-key` and `app-secret` in the file `KGAAppDelegate.m`
to your app-key and app-secret from the Kinvey console.


This has now been updated to take advantage of our data providers.

To enable Data Integration with this app, just

* Create a new collection ![Create New Collection](https://github.com/Kinvey/KinveyGeoTag/raw/master/Screenshots/Create.png "Create Collection")
* Name it "hotels" and enable Data Integration ![Enable Data Integration](https://github.com/Kinvey/KinveyGeoTag/raw/master/Screenshots/Enable.png "Enable Data Integration")
* Select Location from available choices ![Select Location](https://github.com/Kinvey/KinveyGeoTag/raw/master/Screenshots/DataIntegration.png "Create Collection")
* Select a provider (for example Foursquare) ![Select Foursquare](https://github.com/Kinvey/KinveyGeoTag/raw/master/Screenshots/Location.png "Select Foursquare")
* Enter your credentials, hit `update` and verify collection is `Active` ![Enter Credentials](https://github.com/Kinvey/KinveyGeoTag/raw/master/Screenshots/Active.png "Enter Credentials")
