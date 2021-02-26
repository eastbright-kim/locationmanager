//
//  ViewController.swift
//  locationmanager
//
//  Created by 김동환 on 2021/02/25.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        //in order to provide an overlay for a given route.
//        We need to set our view controller as the delegate.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5.0
        
        //request permission for user's location
        locationManager.requestWhenInUseAuthorization()
        
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        
        let appleStoreAnnotation = LocationAnnotation(title: "Apple Union Square", coordinate: CLLocationCoordinate2D(latitude: 37.7861369, longitude: -122.4089195))
        
        let blueBottleCoffeeAnnotation = LocationAnnotation(title: "Blue Bottle Coffee", coordinate: CLLocationCoordinate2D(latitude: 37.7763291, longitude: -122.4254317))
        
        mapView.addAnnotations([appleStoreAnnotation, blueBottleCoffeeAnnotation])
        
        displayRoute(source: appleStoreAnnotation.coordinate, destination: blueBottleCoffeeAnnotation.coordinate)
        
        
        mapView.addAnnotation(appleStoreAnnotation)
//        mapView.setCenter(appleStoreAnnotation.coordinate, animated: false)
    }
    //커스텀 렌더러 추가
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func displayRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        //source와 destination MKPlaceMark
        let source = MKPlacemark(coordinate: source)
        let destination = MKPlacemark(coordinate: destination)
        //request 생성
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        
        //directions 생성
        let directions = MKDirections(request: request)
        //거리 계산, 루트 얻음
        directions.calculate { (response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response {
                let route = response.routes.first!
                //루트를 지도에 그림(addoverlay)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                //zoom in and center the map's visible region on the route
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 80.0, bottom: 80.0, right: 80.0), animated: false)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        
        print("location \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        
    }


}

