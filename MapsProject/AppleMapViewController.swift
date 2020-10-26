//
//  ViewController.swift
//  MapsProject
//
//  Created by Egor Malyshev on 19.10.2020.
//

import UIKit
import MapKit

class AppleMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let lm = LocationManager.shared
    
    let places = PlacesCreator().places
                  
    let spbCenterCoordinate = CLLocationCoordinate2D(latitude: 59.933486, longitude: 30.346385)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        mapView.delegate = self
        mapView.addAnnotations(places)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let rad: CLLocationDistance = 20000
        let reg = MKCoordinateRegion(center: spbCenterCoordinate, latitudinalMeters: rad, longitudinalMeters: rad)
        mapView.setRegion(reg, animated: true)
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        var span = mapView.region.span
        if span.latitudeDelta > 0.004 && span.longitudeDelta > 0.004 {
            span.latitudeDelta -= span.latitudeDelta * 0.3
            span.longitudeDelta -= span.longitudeDelta * 0.3
            let reg = MKCoordinateRegion(center: mapView.region.center, span: span)
            mapView.setRegion(reg, animated: false)
        }
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        var span = mapView.region.span
        span.longitudeDelta += span.longitudeDelta * 0.3
        let reg = MKCoordinateRegion(center: mapView.region.center, span: span)
        mapView.setRegion(reg, animated: false)
    }
    
    @IBAction func centerOnUser(_ sender: Any) {
        let rad: CLLocationDistance = 1500
        let reg = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: rad, longitudinalMeters: rad)
        mapView.setRegion(reg, animated: true)
    }
    
}

extension AppleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        if let place = annotation as? Place {
            view.image = UIImage(named: place.name)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let place = view.annotation as? Place{
            print(place.name)
        }
        if let coordinate = view.annotation?.coordinate {
            mapView.setCenter(coordinate, animated: true)
        }
    }
}







