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

/// 유저가 화면에 표시하는 어노테이션
class StorePointAnnotationOnMap: NSObject, MKAnnotation {
    
    let id: String?
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    let model: StoreModel?
    
    init(id: String?, title: String?, locationName: String?, coordinate: CLLocationCoordinate2D, model: StoreModel?) {
        
        self.id = id
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.model = model
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    
    /// 유저가 선택한 어노테이션
    let selectAnnotationObserver = PassthroughSubject<StorePointAnnotationOnMap?, Never>()
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? StorePointAnnotationOnMap else {
            return nil
        }
        
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
        
        print("btn.tag : \(view.annotation)")
        
        guard let model = view.annotation as? StorePointAnnotationOnMap else {
            return
        }
        
        self.selectAnnotationObserver.send(model)
    }
}

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

struct CustomMapView : UIViewRepresentable {
    let locationManager: CLLocationManager
    let map = MKMapView()
    let coordiate = MapViewDelegate()
    let locationDelegate = LocationDelegate()
    
    var cancelable = Set<AnyCancellable>()
    var storeList: [StoreModel]
    var currentLoc: CLLocationCoordinate2D
    
    let 석촌호수 = CLLocationCoordinate2D(latitude: 37.51005, longitude: 127.10280)
    init(_ storePointList: [StoreModel], _ selectPoint: PassthroughSubject<StoreModel, Never>) {
        
        self.storeList = storePointList
        self.locationManager = CLLocationManager()
        
        self.locationDelegate.locObserver.sink(receiveValue: {loc in
        }).store(in: &self.cancelable)
        
        self.currentLoc = self.석촌호수
        
        self.map.delegate = self.coordiate
        self.locationManager.delegate = self.locationDelegate
        
        self.coordiate.selectAnnotationObserver.filter({value in
            value?.model != nil
        }).map({value -> StoreModel in
            value!.model!
        }).sink(receiveValue: {model in
            
            selectPoint.send(model)
        }).store(in: &self.cancelable)
    }
    
    init(_ model: StoreDetailModel, moveMap: Bool = true) {
        
        self.storeList = [StoreModel(id: model.id, storeImgList: [], metaData: StorePointModel(id: model.id, title: model.storeTitle, location: self.석촌호수, thumbnailUrl: nil), address: model.address, tagList: [], minimumPrice: 0, distance: 0)]
        self.currentLoc = model.loc
        self.locationManager = CLLocationManager()
        
        self.locationDelegate.locObserver.sink(receiveValue: {loc in
        }).store(in: &self.cancelable)
        
        self.locationManager.delegate = self.locationDelegate
        
        self.map.isScrollEnabled = moveMap
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomMapView>) -> MKMapView {
        
        let viewRegion = MKCoordinateRegion(center: self.currentLoc, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        self.map.isRotateEnabled = false
        self.map.setRegion(viewRegion, animated: false)
        
        return self.map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CustomMapView>) {
        
        uiView.removeAnnotations(uiView.annotations)
        uiView.delegate = self.coordiate
        uiView.addAnnotations(self.storeList.map({model -> StorePointAnnotationOnMap in
            
            StorePointAnnotationOnMap(id: model.id, title: model.metaData.title, locationName: model.address, coordinate: model.metaData.location, model: model)
        }) )
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
