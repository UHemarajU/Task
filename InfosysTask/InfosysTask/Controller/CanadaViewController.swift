//
//  CanadaViewController.swift
//  InfosysTask
//
//  Created by Hemaraju MacMini on 13/03/19.
//  Copyright © 2019 incipio. All rights reserved.
//

import UIKit

let viewModel = ViewModel() //viewmodel instance

class CanadaViewController: UITableViewController, ViewModelDelegate {
   
    var entries  = [DataModel]()  
    let cellId = "cellId"
    var spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        viewModel.delegate = self
        spinner.startAnimating()
        viewModel.downloadDataFromServer(closure: stopLoadingLoader)// In viewmodel network call login called
        
        
        //Add reload button
        let rightButton = UIBarButtonItem(title: "reload", style: UIBarButtonItem.Style.plain, target: self, action: #selector(reloadAgain))
        self.navigationItem.rightBarButtonItem = rightButton
        
        //Add loader while downloading
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        //Set row height of UITableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(DataCell.self, forCellReuseIdentifier: cellId)
    }
    

    //Reload action
    @objc func reloadAgain() {
        
        spinner.startAnimating()
        viewModel.downloadDataFromServer(closure: stopLoadingLoader)// In viewmodel network call login called
    }
    
    
   //Reload the tableView after network call completed in ViewModel
    func didFinishUpdates() {
        
        DispatchQueue.main.async {
           
            self.tableView?.reloadData()
        }
        
        
    }
    
    func stopLoadingLoader()
    {
        DispatchQueue.main.async {
            
             self.spinner.stopAnimating() //stop loader
        }
       
    }
    
    
    // MARK: - UITableView methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DataCell
        let currentLastItem = viewModel.dataList[indexPath.row]
        cell.data = currentLastItem
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }

}
