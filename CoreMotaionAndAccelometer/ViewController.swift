//
//  ViewController.swift
//  CoreMotaionAndAccelometer
//
//  Created by Iman on 5/4/19.
//  Copyright © 2019 iman. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var qiblePointer: UIImageView!
    
    let latOfKabah = 21.4225
    let lngOfKabah = 39.8262
    var location: CLLocation?
    let locationManager = CLLocationManager()
    var bearingOfKabah = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    // This function use for set image and claculate the qibla finder and comass from heading
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let north = -1 * heading.magneticHeading * Double.pi/180
        let directionOfKabah = bearingOfKabah * Double.pi/180 + north
        compassImage.transform = CGAffineTransform(rotationAngle: CGFloat(north))
        qiblePointer.transform = CGAffineTransform(rotationAngle: CGFloat(directionOfKabah))
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        bearingOfKabah = getBearingBetweenTwoPoints1(location!, latitudeOfKabah: self.latOfKabah, longitudeOfKabah: self.lngOfKabah) //calculating the bearing of kabeh
    }
    
    // This two functions use for convert redains to degree and degree to radians
    func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
    
    func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
    
    // this function use for calculate degress from kabeh
    func getBearingBetweenTwoPoints1(_ point1 : CLLocation, latitudeOfKabah : Double , longitudeOfKabah :Double) -> Double {
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        let lat2 = degreesToRadians(latitudeOfKabah)
        let lon2 = degreesToRadians(longitudeOfKabah)
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var radiansBearing = atan2(y, x)
        if radiansBearing < 0.0 {
            radiansBearing += 2 * Double.pi
        }
        return radiansToDegrees(radiansBearing)
    }
}

