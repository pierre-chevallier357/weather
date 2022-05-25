//
//  CustomTableViewController.swift
//  Demo
//
//  Created by Julie Saby on 09/03/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit

enum DataVC: String {
	case geoloc = "Geolocation"
}

class CustomTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var customTableView: UITableView!

	let datas: [DataVC] = [.geoloc]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		customTableView.delegate = self
		customTableView.dataSource = self
    }

	//MARK: - Events Table View
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return datas.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let titleView = UIView()
		
		let titleLabel = UILabel()
		titleLabel.text = "Titre de section"
		titleView.addSubview(titleLabel)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 20).isActive = true
		titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10).isActive = true
		titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
		
		return titleView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let deaultCell = UITableViewCell()
		
		let cell = customTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
		cell.titleLabel.text = datas[indexPath.row].rawValue
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let data = datas[indexPath.row]
		pushViewController(data)
		
		customTableView.deselectRow(at: indexPath, animated: true)
	}
	
	func pushViewController(_ dataVC: DataVC) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		var nextViewController: UIViewController!
		
			nextViewController = storyboard.instantiateViewController(withIdentifier: "GeolocationViewController") as! GeolocationViewController
		
		
		self.navigationController?.pushViewController(nextViewController, animated: true)
	}
}
