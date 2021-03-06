//
//  PrayerTimesViewController.swift
//  Salah
//
//  Created by Deniz Tezcan on 17/12/2021.
//  Copyright (c) 2021 Tezcan IT Solutions BV. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class PrayerTimesViewController: UIViewController, CLLocationManagerDelegate  {
    
    var location: CLLocation?
    var prayerKit:AKPrayerTime = AKPrayerTime(lat: 52.37926042646426, lng: 4.899881247724632) // default location is AMS central train station for lulz
    let locationManager = CLLocationManager()
    var city = ""
    
    @IBOutlet weak var fajrLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var dhuhrLabel: UILabel!
    @IBOutlet weak var asrLabel: UILabel!
    @IBOutlet weak var maghribLabel: UILabel!
    @IBOutlet weak var ishaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        self.prayerKit.calculationMethod = .Makkah
        self.prayerKit.outputFormat = .Time24
        handlePrayerTimes()
    }
    
    func handlePrayerTimes(){
        let times = self.prayerKit.getPrayerTimes()
        fajrLabel.text = (times![.Fajr] as! String)
        sunriseLabel.text = (times![.Sunrise] as! String)
        dhuhrLabel.text = (times![.Dhuhr] as! String)
        asrLabel.text = (times![.Asr] as! String)
        maghribLabel.text = (times![.Maghrib] as! String)
        ishaLabel.text = (times![.Isha] as! String)
    }
    
    func initLocationManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }else {
            let alert = UIAlertController(title: "Whoops!", message: "You need to allow locations for this app to work.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        CLGeocoder().reverseGeocodeLocation(self.location!, completionHandler: {(placemarks, error) -> Void in
            self.city = (placemarks?.first?.locality)!
            self.prayerKit = AKPrayerTime(lat: (self.location?.coordinate.latitude)!, lng: (self.location?.coordinate.longitude)!)
            self.handlePrayerTimes()
        });
    }
}
