//
//  YandexMapViewController.swift
//  MapsProject
//
//  Created by Egor Malyshev on 25.10.2020.
//

import UIKit
import YandexMapKit
import MapKit

class YandexMapViewController: UIViewController {

    @IBOutlet weak var mapView: YMKMapView!
    
    let lm = LocationManager.shared
    
    let places = PlacesCreator().places
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markersAdding()
        if CLLocationManager.locationServicesEnabled() {
            lm.delegate = self
            lm.requestLocation()
        }
        
        let instance = YMKMapKit.sharedInstance()
        let userLocationLayer = instance.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: 59.933486, longitude: 30.346385), zoom: 10, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
                cameraCallback: nil)
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let map = mapView.mapWindow.map
        map.move(
            with: YMKCameraPosition.init(target: map.cameraPosition.target, zoom: map.cameraPosition.zoom + 1, azimuth: 0, tilt: 0),
    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
        cameraCallback: nil)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        let map = mapView.mapWindow.map
        map.move(
            with: YMKCameraPosition.init(target: map.cameraPosition.target, zoom: map.cameraPosition.zoom - 1, azimuth: 0, tilt: 0),
    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
        cameraCallback: nil)
    }
    
    @IBAction func centerOnUser(_ sender: Any) {
        if let location = lm.location {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 13, azimuth: 0, tilt: 0),
        animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
            cameraCallback: nil)
        }
    }
    
    func markersAdding(){
        let mapObjects = mapView.mapWindow.map.mapObjects
        for place in places {
            let point = YMKPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            let placemark = mapObjects.addPlacemark(with: point)
            placemark.userData = place.name
            placemark.setIconWith(UIImage(named: place.name)!)
        }
        mapObjects.addTapListener(with: self)
    }
}

extension YandexMapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: point.latitude, longitude: point.longitude), zoom: 13, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
                cameraCallback: nil)
        print(mapObject.userData ?? "")
        return true
    }
}

extension YandexMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        guard status == .authorizedWhenInUse else {
        return
      }
      lm.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
          return
        }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 13, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
                cameraCallback: nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


