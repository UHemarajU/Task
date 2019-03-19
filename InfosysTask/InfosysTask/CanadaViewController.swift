//
//  CanadaViewController.swift
//  InfosysTask
//
//  Created by Hemaraju MacMini on 13/03/19.
//  Copyright © 2019 incipio. All rights reserved.
//

import UIKit

let viewModel = ViewModel()
class CanadaViewController: UITableViewController, ViewModelDelegate {

    let loadData = [String]()
    var entries  = [DataModel]()
      let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel.delegate = self
        
        viewModel.donwloadWithUrl()
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(DataCell.self, forCellReuseIdentifier: cellId)
    }
    
   //Reload the tableView
    func didFinishUpdates() {
        
        DispatchQueue.main.async {
            
            self.tableView?.reloadData()
        }
        
        
    }
    
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
