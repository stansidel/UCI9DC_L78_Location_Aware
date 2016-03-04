//
//  ViewController.swift
//  UCI9DC L78 Location Aware
//
//  Created by Stanislav Sidelnikov on 04/03/16.
//  Copyright © 2016 Stanislav Sidelnikov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            var text = "location: \(location.coordinate.latitude), \(location.coordinate.longitude)\n"
            text += "course: \(location.course)\n"
            text += "speed: \(location.speed)\n"
            text += "altitude: \(location.altitude)\n"
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error: \(error!.localizedDescription)")
                } else {
                    if let pm = placemarks?.first {
                        let address = "\(pm.locality ?? "") \(pm.postalCode ?? ""), \(pm.administrativeArea ?? ""), \(pm.country ?? "")"
                        text += "address: \(address)"
                    } else {
                        print("Problem with the data received from geocoder")
                    }
                }
                self.infoLabel.text = text
            })
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }

}

