//
//  ViewController.swift
//  GustieMenu
//
//  Created by Tucker Saude on 9/8/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class MenuViewController: UIViewController {
    
    var stations: [StationViewModel] = []
    var menuItems: [[MenuItemViewModel]] = []
    var date: Date = Date() {
        didSet {
            updateTableView()
        }
    }
    
    lazy var loadingView: UIView = {
        let loadingView = UIView(frame: CGRect(x: view.frame.width / 2 - 130 / 2, y: view.frame.height / 3 - 50, width: 130, height: 100))
        loadingView.backgroundColor = UIColor.darkGray
        loadingView.alpha = 0.75;
        loadingView.layer.cornerRadius = 20;
        loadingView.layer.masksToBounds = true;
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        var x = loadingView.frame.width / 2 - activityIndicator.frame.width / 2
        var y = loadingView.frame.height / 3 - activityIndicator.frame.height / 2
        activityIndicator.frame = CGRect(x: x, y: y, width: activityIndicator.frame.width, height: activityIndicator.frame.height);
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let loadingLabel = UILabel(frame: CGRect(x: 0, y: loadingView.frame.height - 40, width: loadingView.frame.width, height: 40))
        loadingLabel.text = "Loading..."
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont(name: "Comfortaa", size: 20)
        loadingLabel.textColor = UIColor.white
        loadingView.addSubview(loadingLabel)
        return loadingView
    }()
    
    var isShowingLoadingView: Bool {
        get {
            return loadingView.superview == self.view
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
    }

    func showLoadingView() {
        if (!isShowingLoadingView) {
            view.addSubview(loadingView)
        }
    }
    
    func hideLoadingView() {
        if (isShowingLoadingView) {
            loadingView.removeFromSuperview()
        }
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func updateTableView() {
        showLoadingView()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let numStations = stations.count
        stations = []
        tableView.deleteSections(IndexSet(0..<numStations), with: .right)

        Downloader.sharedInstance.downloadStations(date: date) { [weak self] stations, dateString in
            guard let self = self else { return }
            self.stations = stations.map { StationViewModel(from: $0) }
            self.menuItems = stations.map { s in s.menuItems.map { MenuItemViewModel(from: $0) } }
            self.dateLabel.text = dateString
            self.hideLoadingView()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            let sections = IndexSet(0..<self.stations.count)
            self.tableView.insertSections(sections, with: .left)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return stations.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard stations.count > section else { return 0 }
        let station = stations[section]
        return station.isShowingMenuItems ? 1 + menuItems[section].count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let station = stations[indexPath.section]
        if (indexPath.row == 0) {
            let cell: StationTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as! StationTableViewCell
            cell.station = station
            return cell
        } else {
            let menuItem = menuItems[indexPath.section][indexPath.row - 1]
            let cell: MenuItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
            cell.menuItem = menuItem
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let stationCell = cell as? StationTableViewCell,
            let station = stationCell.station {
            stationCell.station = station.toggleShowingMenuItems()
            stations[indexPath.section] = stationCell.station!
            let start = indexPath.row + 1
            let indexPaths: [IndexPath] = Array(start..<start + menuItems[indexPath.section].count).map() { i in
                return IndexPath(row: i, section: indexPath.section)
            }
            if (stationCell.station!.isShowingMenuItems) {
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            } else {
                self.tableView.deleteRows(at: indexPaths, with: .automatic)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension MenuViewController: THDatePickerDelegate {
    
    @IBAction func calendarPressed(sender: AnyObject) {
        let cal = THDatePickerViewController.datePicker()
        cal.delegate = self
        cal.date = self.date
        cal.selectedBackgroundColor = UIColor(hue: 0.13, saturation: 1.0, brightness: 0.15, alpha: 1.0)
        presentSemiViewController(cal, withOptions: [
            KNSemiModalOptionKeys.pushParentBack.takeUnretainedValue() as String : false,
            KNSemiModalOptionKeys.transitionStyle.takeUnretainedValue() as String : KNSemiModalTransitionStyle.fadeInOut.rawValue
        ])
    }
    
    func datePickerDonePressed(_ datePicker: THDatePickerViewController!) {
        self.date = datePicker.date
        self.dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        self.dismissSemiModalView()
    }
}

