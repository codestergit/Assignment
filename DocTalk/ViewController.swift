//
//  ViewController.swift
//  DocTalk
//
//  Created by Wasan, Sahil on 10/7/17.
//  Copyright © 2017 Wasan, Sahil. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    static let cellIdentifier = "nameCell"
    var items: [String] = []
    let searchRate = 0.3

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier,for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset=UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    @objc func reload() {
        guard let text = searchController.searchBar.text, text.count > 0 else { return }
        let query = text.replacingOccurrences(of: " ", with: "+")
        NetworkService.getResults(name:query) { (names) in
            DispatchQueue.main.async {
                self.refreshTableView(names: names)
            }
        }
    }
    
    func refreshTableView(names: [String]) {
        self.items = names
        self.tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        if searchText.count > 0 {
            self.perform(#selector(self.reload), with: nil, afterDelay: searchRate)
        } else {
            refreshTableView(names: [])
        }
    }
}

