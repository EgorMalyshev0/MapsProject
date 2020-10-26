//
//  GoogleMapViewController.swift
//  MapsProject
//
//  Created by Egor Malyshev on 22.10.2020.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let lm = CLLocationManager()
    
    let places = PlacesCreator().places
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm.delegate = self
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            lm.requestLocation()
            mapView.isMyLocationEnabled = true
          } else {
            lm.requestWhenInUseAuthorization()
          }
        
        markersAdding()
        mapView.settings.myLocationButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.animate(to: GMSCameraPosition(latitude: 59.933486, longitude: 30.346385, zoom: 10))
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let zoom = mapView.camera.zoom
        mapView.animate(toZoom: zoom + 1)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        let zoom = mapView.camera.zoom
        mapView.animate(toZoom: zoom - 1)
    }
    
    func markersAdding(){
        for place in places {
            let marker = GMSMarker(position: place.coordinate)
            marker.title = place.name
            marker.icon = UIImage(named: place.name)
            marker.map = mapView
        }
    }
    
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.title!)
        mapView.animate(to: GMSCameraPosition(latitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 13))
        return true
    }
}

extension GoogleMapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    lm.requestLocation()

    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    mapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 12))
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
