//
//  Place.swift
//  MapsProject
//
//  Created by Egor Malyshev on 25.10.2020.
//

import Foundation
import MapKit
import YandexMapKit

class Place: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}

struct PlacesCreator {
    var places: [Place]
    
    init() {
        places = [Place(name: "Петропавловская крепость", coordinate: CLLocationCoordinate2D(latitude: 59.950126, longitude: 30.317494)),
        Place(name: "Спас на Крови", coordinate: CLLocationCoordinate2D(latitude: 59.940090, longitude: 30.328864)),
        Place(name: "Государственный Эрмитаж", coordinate: CLLocationCoordinate2D(latitude: 59.941043, longitude: 30.313193)),
        Place(name: "Исаакиевский собор", coordinate: CLLocationCoordinate2D(latitude: 59.934143,  longitude: 30.305928)),
        Place(name: "Газпром Арена", coordinate: CLLocationCoordinate2D(latitude: 59.973769, longitude: 30.218614))]
    }
}

struct LocationManager{
    static let shared = CLLocationManager()
}
