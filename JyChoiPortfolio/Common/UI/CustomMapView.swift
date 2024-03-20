//
//  CustomMapView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI
import MapKit
import Combine
import SnapKit


/// 맵뷰 딜리게이트
class MapViewDelegate: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "storePoint"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.canShowCallout = true
            view.isEnabled = true
            view.calloutOffset = CGPoint(x: -10, y: 10)
            
            let btn = UIButton(type: .detailDisclosure)
            
            view.rightCalloutAccessoryView = btn
            view.annotation = annotation
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        #if DEBUG
        print("btn.tag : \(view.annotation)")
        #endif
    }
}

/// 위치 정보 가져올때 딜리게이트
class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let locObserver = PassthroughSubject<CLLocation, Never>()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue = manager.location?.coordinate else {
            return
        }
        
        let coordinations = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        self.locObserver.send(coordinations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            // User has not yet made a choice with regards to this application
            
            break
        case .authorizedWhenInUse:
            
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            
            manager.startUpdatingLocation()
            break
        case .restricted:
            break
        case .denied:
            break
        default :
            break
        }
    }
}

/// 맵뷰를 사용하기 위해 UIKit의 맵뷰를 랩핑한 구조체
struct CustomMapView : UIViewRepresentable {
    let locationManager: CLLocationManager
    let map = MKMapView()
    let coordiate = MapViewDelegate()
    let locationDelegate = LocationDelegate()
    
    var cancelable = Set<AnyCancellable>()
    var currentLoc: CLLocationCoordinate2D
    
    
    func makeUIView(context: UIViewRepresentableContext<CustomMapView>) -> MKMapView {
        
        let viewRegion = MKCoordinateRegion(center: self.currentLoc, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        self.map.isRotateEnabled = false
        self.map.setRegion(viewRegion, animated: false)
        
        return self.map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CustomMapView>) {
        
        uiView.removeAnnotations(uiView.annotations)
        uiView.delegate = self.coordiate
    }
    
    /// 현재 위치 정보 가져오기
    public func getCurrentLocation() {
        
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            
            self.locationManager.startUpdatingLocation()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        self.locationManager.allowsBackgroundLocationUpdates = false
    }
}
