//
//  QiblaViewController.swift
//  Salah
//
//  Created by Deniz Tezcan on 17/12/2021.
//

import Foundation
import UIKit
import CoreLocation

class QiblaViewController: UIViewController, CLLocationManagerDelegate {
    
    let kabaLat = 21.4225
    let kabaLon = 39.8262
    var kabaBearing = Double()
    
    var location: CLLocation?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var compassBG: UIImageView!
    @IBOutlet weak var compassNeedle: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
    }
    
    func initLocationManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }else {
            let alert = UIAlertController(title: "Whoops!", message: "You need to allow locations for this app to work.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let north = -1 * heading.trueHeading * Double.pi/180
        let kabaDirection = kabaBearing * Double.pi/180 + north

        compassBG.transform =   CGAffineTransform(rotationAngle: CGFloat(north));
        compassNeedle.transform =  CGAffineTransform(rotationAngle: CGFloat(kabaDirection));
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        kabaBearing = getBearingBetweenTwoPoints(location!, latitudeOfKabah: self.kabaLat, longitudeOfKabah: self.kabaLon)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
    func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
    
    func getBearingBetweenTwoPoints(_ currentloc : CLLocation, latitudeOfKabah : Double , longitudeOfKabah :Double) -> Double {
        let radianCurrentLat = degreesToRadians(currentloc.coordinate.latitude)
        let radianCurrentLon = degreesToRadians(currentloc.coordinate.longitude)
        let radianKabaLat = degreesToRadians(kabaLat);
        let radianKabaLon = degreesToRadians(kabaLon);

        let dLon = radianKabaLon - radianCurrentLon;

        let y = sin(dLon) * cos(radianKabaLat);
        let x = cos(radianCurrentLat) * sin(radianKabaLat) - sin(radianCurrentLat) * cos(radianKabaLat) * cos(dLon);
        var bearing = atan2(y, x);
        if(bearing < 0.0){
            bearing += 2 * Double.pi;
        }

        return radiansToDegrees(bearing)
    }
}
