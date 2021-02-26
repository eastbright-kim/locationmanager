//
//  LocationAnnotation.swift
//  locationmanager
//
//  Created by 김동환 on 2021/02/26.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
    
}
