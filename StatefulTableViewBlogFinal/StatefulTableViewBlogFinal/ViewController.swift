//
//  ViewController.swift
//  StatefulTableViewBlogFinal
//
//  Created by Sauvik Dolui on 28/10/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit
import SDStateTableView

class ViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var stateTableView: SDStateTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension ViewController {
    @IBAction func dataAvailableButtonTapped(_ sender: UIButton) {
        stateTableView.setState(state: .dataAvailable)
    }
    
    @IBAction func noDataAvailableButtonTapped(_ sender: UIButton) {
        stateTableView.setState(state: .withImage(image: "empty_cart",
                                                  title: "EMPTY CART",
                                                  message: "Please add some item in your cart first"))
    }
    
    @IBAction func errorWithImageButtonTapped(_ sender: UIButton) {
        stateTableView.setState(state: .withImage(image: "server_error",
                                                  title: "SERVER ERROR",
                                                  message: "We are notified and working on it, we will be back soon"))
    }
    @IBAction func errorWithTitleButtonTapped(_ sender: UIButton) {
        stateTableView.setState(state: .withImage(image: nil,
                                                  title: "SIMPLE ERROR TITLE",
                                                  message: "Error message goes here"))
    }
    
    @IBAction func loadingDataButtonTapped(_ sender: UIButton) {
        stateTableView.setState(state: .loading(message: "Loading data..."))
    }
    @IBAction func noInternetButtonTapped(_ sender: Any) {
        stateTableView.setState(state: .withButton(errorImage: "no_internet",
                                                   title: "NO INTERNET",
                                                   message: "You are not connected to Internet, please try later",
                                                   buttonTitle: "Try Again",
                                                   buttonConfig: { (button) in
                                                    
            // configure the button as per your requirement
        },
                                                   retryAction: {
                    self.stateTableView.setState(state: .loading(message: "Loading data..."))
        }))
    }
}

// MARK: - UITableViewDataSource Methods
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (tableView as! SDStateTableView).currentState {
        case .dataAvailable:
            tableView.separatorStyle = .singleLine
            return 14
        default:
            tableView.separatorStyle = .none
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        cell?.textLabel?.text = "Row number \(indexPath.row)"
        return cell!
    }
}
