//
//  GeolocationViewController.swift
//  Demo
//
//  Created by Pierre Chevallier on 04/04/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var location: UILabel?
    @IBOutlet weak var temperature: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var weatherCodeList: [Int] = []
    var timeList: [String] = []
    var temperatureList: [Float] = []
    var dayCounter: Int = 1
    
    let client = WebService()
	
	let locationManager = CLLocationManager()
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let weatherCode: Int = weatherCodeList[indexPath.row]
        let weather: String = self.getWeatherName(weatherCode: weatherCode)
        
        var temperature: String = String(temperatureList[indexPath.row])
        temperature = self.refactorTemperature(temp: temperature)
        
        let day = "J+\(self.dayCounter)"
        self.dayCounter += 1

        cell.weather.text = weather
        cell.temperature.text = temperature
        cell.day.text = day
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		checkLocationServices()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.layer.cornerRadius = 10
        self.tableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
	}
	
	// Check if the authorization services is ok
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
	
	// Update the position of the user when he move and show buses points with itineraire
	func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        client.getCity(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), completion: { tags in
            DispatchQueue.main.async {
                if (tags?.city != "") {
                    self.location?.text = tags?.city
                } else {
                    self.location?.text = tags?.locality
                }
            }
        })
        
        client.getWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), completion: { tags in

            DispatchQueue.main.async {
                self.refactorCurrentTemperature(tags: tags!)
                
                self.weatherCodeList = (tags?.hourly.weathercode)!
                self.timeList = (tags?.hourly.time)!
                self.temperatureList = (tags?.hourly.temperature_2m)!
                
                self.filterWeatherCodesByDay()
                self.filterTimesByDay()
                self.filterTemperaturesByDay()
                
                self.setCurrentDayWeatherIcon(tags: tags!)
                self.setBackgroundImage()
                
                self.tableView.reloadData()
            }
        })
	}
    
    func filterTimesByDay() {
        var refactoredTimeList: [String] = []
        for i in 1...self.timeList.count {
            if (i%24 == 0) {
                refactoredTimeList.append(self.timeList[i-1])
            }
        }
        self.timeList = refactoredTimeList
    }
    
    func filterWeatherCodesByDay() {
        var refactoredWeatherCodeList: [Int] = []
        for i in 1...self.weatherCodeList.count {
            if (i%24 == 0) {
                refactoredWeatherCodeList.append(self.weatherCodeList[i-1])
            }
        }
        self.weatherCodeList = refactoredWeatherCodeList
    }
    
    func filterTemperaturesByDay() {
        var refactoredTemperatureList: [Float] = []
        for i in 1...self.temperatureList.count {
            if (i%24 == 0) {
                refactoredTemperatureList.append(self.temperatureList[i-1])
            }
        }
        self.temperatureList = refactoredTemperatureList
    }
    
    func refactorCurrentTemperature(tags: Weather){
        self.temperature?.text = String((tags.current_weather.temperature)! )
        self.temperature?.text = self.temperature?.text!.replacingOccurrences(of: ".", with: "°C")
        var temperatureString = self.temperature?.text
        temperatureString?.removeLast()
        self.temperature?.text = temperatureString
    }
    
    func refactorTemperature(temp: String) -> String{
        var tempRefactored = temp.replacingOccurrences(of: ".", with: "°C")
        tempRefactored.removeLast()
        return tempRefactored
    }
    
    func setCurrentDayWeatherIcon(tags: Weather) {
        let imageName: String = self.getWeatherIconName(weatherCode:tags.current_weather.weathercode)
        let weatherIcon = UIImage(named: imageName)
        self.imageView.image = weatherIcon
    }
    
    func setBackgroundImage() {
        let backgroundImage = "background.jpeg"
        let background = UIImage(named: backgroundImage)
        self.background.image = background
    }
    
    func getWeatherIconName(weatherCode: Int) -> String {
        let imageName: String
        switch weatherCode {
        case 2:
            imageName = "cloudy-sun.png"
        case 3:
            imageName = "clouds.png"
        case 45,48:
            imageName = "fog.png"
        case 51,53,55:
            imageName = "light-rain.png"
        case 56,57,61,63,65,66,67:
            imageName = "rain.png"
        case 71,73,75,77:
            imageName = "snow.png"
        case 80,81,82,85,86:
            imageName = "heavy-rain.png"
        case 95,96,99:
            imageName = "storm.png"
        default:
            imageName = "sun.png"
        }
        return imageName
    }
    
    func getWeatherName(weatherCode: Int) -> String {
        let weatherName: String
        switch weatherCode {
        case 2:
            weatherName = "Couvert"
        case 3:
            weatherName = "Nuageux"
        case 45,48:
            weatherName = "Brouillard"
        case 51,53,55:
            weatherName = "Bruine"
        case 56,57,61,63,65,66,67:
            weatherName = "Pluie"
        case 71,73,75,77:
            weatherName = "Neige"
        case 80,81,82,85,86:
            weatherName = "Averse"
        case 95,96,99:
            weatherName = "Orage"
        default:
            weatherName = "Soleil"
        }
        return weatherName
    }
}
