//
//  GeolocationViewController.swift
//  Demo
//
//  Created by Julie Saby on 09/03/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocationViewController: UIViewController, CLLocationManagerDelegate {
	
	// @IBOutlet weak var latitudeLabel: UILabel!
	// @IBOutlet weak var longitudeLabel: UILabel!
    // @IBOutlet weak var cityLabel: UILabel?
    // @IBOutlet weak var localityLabel: UILabel?
    @IBOutlet weak var location: UILabel?
    @IBOutlet weak var temperature: UILabel?
    @IBOutlet weak var weather_code: UILabel?
    
    let client = WebService()
	
	let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		checkLocationServices()
	}
	
	//check if the authorization services is ok
	func checkLocationServices(){
		if CLLocationManager.locationServicesEnabled(){
			setUpLocationManager()
			checkLocationAuthorization()
		} else{
			showAlert(title: "Alerte", message: "Vous devez autoriser la localisation GPS pour utiliser l'application")
		}
	}
	
	func setUpLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
	}
	
	func checkLocationAuthorization(){
		switch CLLocationManager.authorizationStatus() {
		case .authorizedWhenInUse:
			locationManager.startUpdatingLocation()
		case .denied:
			showAlert(title: "Alerte", message: "Vous devez autoriser la localisation GPS pour utiliser l'application")
			break
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
			break
		case .restricted:
			showAlert(title: "Alerte", message: "Vous devez autoriser la localisation GPS pour utiliser l'application")
			break
		case .authorizedAlways:
			break
			
		}
	}
	
	//update the position of the user when he move and show buses points with itineraire
	func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        print("location", location)
		// latitudeLabel.text = String(location.coordinate.latitude)
		// longitudeLabel.text = String(location.coordinate.longitude)
        client.getCity(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), completion: { tags in
            DispatchQueue.main.async {
                //self.cityLabel?.text = tags?.city
                //self.localityLabel?.text = tags?.locality
                if (tags?.city != "") {
                    self.location?.text = tags?.city
                } else {
                    self.location?.text = tags?.locality
                }
            }
        })
        
        client.getWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), completion: { tags in
            //print("weather",tags?.hourly.temperature_2m[0] as Any)
            DispatchQueue.main.async {
                self.temperature?.text = String((tags?.current_weather.temperature)! )
                self.weather_code?.text = String((tags?.current_weather.weathercode)! )
                /* print("DATE",tags?.hourly.time[0].prefix(10))
                var currentDate:String!
                currentDate = dateFormatter.string(from: date)
                print("DATE2", dateFormatter.string(from: date))
                print("Found",tags?.hourly.time.first(where: {$0 == currentDate}))
                 */
            }
        })
	}
}
