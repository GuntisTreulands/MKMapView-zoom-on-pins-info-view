# MKMapView-zoom-on-pins-info-view
Imagine you had a info view, that you drag over a map. How would you still keep the map pins centered in the remaining visible area?

This is a follow up for https://github.com/GuntisTreulands/MKMapView-zoom-on-pins-with-inset. 
But this time, info view is a proper UIScrollView.

The problems we tackled in this project are:
1.) Have the scrollview contain info view, that would be minimised
2.) Pull scrollview up, to reveal more info - in a paging way.
3.) Have scrollview scroll indicators, act in a way, to be always at 0 position, while info view is not maximised.

![Example](Resources/preview.gif?raw=true "Preview")
