//
//  ViewModel.swift
//  Sample_TableView
//
//  Created by Hemaraju MacMini on 17/03/19.
//  Copyright © 2019 incipio. All rights reserved.


protocol ViewModelDelegate: class {
    func updateTitle()  // Title update
    
    func didFinishUpdates()// update each row
    
    func stopLoadingLoader() // stop loader
}


import UIKit
import Foundation

class ViewModel
{
   
    var dataList : [DataModel]  = [DataModel]()
    weak var delegate: ViewModelDelegate?
    var titleForViewController : String = ""
    
    func downloadDataFromServer(closure: @escaping () -> ()) {
        
        
        dataList.removeAll() // avoid duplicates
        
        DispatchQueue.global().async {
            
            guard let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json") else {
                return
                
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let dataResponse = data, error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                    
                }
                let responseStrInISOLatin = String(data: dataResponse, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else
                {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    if  let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as? NSDictionary{
                        
                        //Title
                        guard  let viewtitle = responseJSONDict.value(forKey: "title") as? String else{
                            
                            return
                        }
                        self.titleForViewController = viewtitle
                        self.delegate?.updateTitle()
                        
                        
                        //Get list of rows
                        guard  let listData = responseJSONDict.value(forKey: "rows") as? NSArray else{
                            
                            return
                        }
                        
                        
                        for dict in listData  {
                            
                            if let dataList = dict as? NSDictionary{
                                
                                let titles = dataList.value(forKey: "title") as? String ?? "No title available"
                                let descriptions = dataList.value(forKey: "description") as? String ?? "No Description available" //If no description available in JSON put nil
                                
                                //Check if url string nil or not
                                
                                //SOME OF URL'S PROVIDED IN JSON ARE NOT VALID SO I AM USING DEFAULT IMAGE FROM ASSETS
                                
                                if let imageUrl = dataList.value(forKey: "imageHref") as? NSNull {
                                    
                                    print("imageUrl \(imageUrl)")
                                    let img = UIImage(named: "flag_of_canada")  //Place the default image from assets if imageurl not found
                                    self.dataList.append(DataModel(Name: titles, Image: img , Desc: descriptions))
                                    
                                }
                                else
                                {
                                    if let imageUrl = URL(string: (dataList.value(forKey: "imageHref") as? String ?? "nil")){
                                        
                                        let imgdata = try? Data(contentsOf: imageUrl)
                                        if imgdata == nil
                                        {
                                            let img = UIImage(named: "flag_of_canada")//Place the default image from assets if imageurl not found
                                            self.dataList.append(DataModel(Name: titles, Image: img , Desc: descriptions))
                                        }
                                        else
                                        {
                                            let image = UIImage(data: imgdata!)
                                            self.dataList.append(DataModel(Name: titles, Image: image , Desc: descriptions))
                                        }
                                    }
                             
                                    
                                }
                            }
                            
                         //Reload tablview in ViewController for each data row
                         self.delegate?.didFinishUpdates()
                            
                        }
                        
                         closure() //completionhandler for stop loader
                    }
                    
                
                    
                }
                catch {
                
                    print(error)
                }
                
            }
           
            task.resume()
        }
        
        
        
        
        
    }
    
    
    
    
}




