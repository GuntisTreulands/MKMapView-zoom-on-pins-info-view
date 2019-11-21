//
//  MapViewController.swift
//  MapDemo
//
//  Created by Guntis on 04/10/2019.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIScrollViewDelegate {

	@IBOutlet var mapView: MKMapView!
	@IBOutlet var scrollView: PassThroughScrollView!

	@IBOutlet var scrollViewTopLayoutConstraint: NSLayoutConstraint!
	
	var infoView: InfoView!

	var calculatedMaxPinWidth: CGFloat = 0
	var calculatedMaxPinHeight: CGFloat = 0
	var maximumVisibleInfoViewHeight: CGFloat = 150

	var initialSetUpForRecenterIsDone: Bool = false
	var visiblePinsMapRect: MKMapRect?

	var mapDataPoints: [MapPoint]!

	// MARK: View loading

	override func viewDidLoad() {
        super.viewDidLoad()

		setUpInfoView()
        mapView.delegate = self
        mapView.addAnnotations(mapDataPoints)
    }

    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		initialSetUpForRecenterIsDone = true
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if initialSetUpForRecenterIsDone == false {
			recenterMapPins()
			repositionScrollView()
		}
	}

	// MARK: Set up

	func setUpInfoView() {
		infoView = InfoView.init()
		scrollView.addSubview(infoView)

		infoView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		infoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
		infoView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
		infoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

		infoView.titleLabel.text =  "Info text comes here\n\nInfo text comes here\n\nInfo text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nMore info text comes here\n\nEven more info here!\n\nEven more info here!\n\nEven more info here!\n\nBut no more information after this.\n"
		infoView.layoutIfNeeded()

		scrollView.delegate = self

		scrollView.isPagingEnabled = true
	}

	// MARK: MKMapViewDelegate

	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		recalculateVisibleMapRect()
		recenterMapPins()
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		guard !(annotation is MKUserLocation) else {
			return nil
		}

		let annotationIdentifier = "mapPoint"

		var annotationView: MKAnnotationView!

		if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
			annotationView = dequeuedAnnotationView
			annotationView?.annotation = annotation
		}
		else {
			let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			annotationView = av
		}

		if let mapPointAnnotation = annotationView.annotation as? MapPoint {
			annotationView.canShowCallout = false
			let mapPinAccessory = MapPinAccessoryView.init()
			mapPinAccessory.icon.image = UIImage(named: mapPointAnnotation.imageName)
			mapPinAccessory.titleLabel.text = mapPointAnnotation.title
			mapPinAccessory.layoutIfNeeded()

			calculatedMaxPinWidth = max(mapPinAccessory.frame.width, calculatedMaxPinWidth)
			calculatedMaxPinHeight = max(mapPinAccessory.frame.height, calculatedMaxPinHeight)

			annotationView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
			annotationView.addSubview(mapPinAccessory)
			annotationView.frame = mapPinAccessory.frame
		}

		return annotationView
	}

	// MARK: Functions

	func repositionScrollView() {
		scrollView.contentInset = UIEdgeInsets.init(top: scrollView.frame.height-min(maximumVisibleInfoViewHeight, infoView.frame.height) - self.view.safeAreaInsets.bottom, left: 0, bottom: 0, right: 0)
	}

	// Helper method to get a region from given points
	func regionFor(mapPoints points: [MapPoint]) -> MKCoordinateRegion {
		var r = MKMapRect.null

		for i in 0 ..< points.count {
			let p = MKMapPoint(points[i].coordinate)
			r = r.union(MKMapRect(x: p.x, y: p.y, width: 0, height: 0))
		}

		var region = MKCoordinateRegion(r)
		region.span.latitudeDelta = max(0.002, region.span.latitudeDelta)
    	region.span.longitudeDelta = max(0.002, region.span.longitudeDelta)
		return region
	}

	// Helper method to get MKMapRect from region
	func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
		let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
		let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

		let a = MKMapPoint(topLeft)
		let b = MKMapPoint(bottomRight)

		return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
	}

	// Call this to recalculate region and visible map rect.
	// We separated this, so that this could be done only once per annotations adding.
	func recalculateVisibleMapRect() {
		let region = self.regionFor(mapPoints: mapView.annotations as! [MapPoint])
		visiblePinsMapRect = MKMapRectForCoordinateRegion(region: region)
	}

	// Call this to recenter on map pins, position it correctly with insets.
	func recenterMapPins() {
		guard let visiblePinsMapRect = visiblePinsMapRect else { return }

		let scrollViewHeight = scrollView.frame.height - min(maximumVisibleInfoViewHeight, infoView.frame.height)

		let top = calculatedMaxPinHeight + 5
		let bottom = scrollViewHeight + min(0, scrollView.contentOffset.y) + scrollViewTopLayoutConstraint.constant - self.view.safeAreaInsets.bottom + 5

		let side = calculatedMaxPinWidth/2 + 5

		mapView.setVisibleMapRect(visiblePinsMapRect, edgePadding: UIEdgeInsets(top: top, left: side, bottom: bottom, right: side), animated: false)
	}

	// MARK: ScrollView Delegate

	func scrollViewDidScroll(_ scrollView: UIScrollView) {

		let frameHeight = scrollView.frame.height-self.view.safeAreaInsets.bottom-max(0, -scrollView.contentOffset.y)

		let contentHeight = scrollView.contentSize.height+self.view.safeAreaInsets.bottom+max(0, -scrollView.contentOffset.y)

		// Some magic, to calculate proper scroll indicator top inset, so that it would be at 0 position at all times, until full page is revealed.
		let ratio = min(1, frameHeight/contentHeight)
		let value = max(0, min(scrollView.contentInset.top, scrollView.contentInset.top+scrollView.contentOffset.y))
		scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top:max(0, -scrollView.contentOffset.y)-value*ratio, left: 0, bottom: 0, right: 0)

		if scrollView.contentOffset.y > 0 {
			scrollView.isPagingEnabled = false
		} else {
			scrollView.isPagingEnabled = true
		}

		recenterMapPins()
	}
}
