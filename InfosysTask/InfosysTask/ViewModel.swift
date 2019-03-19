//
//  ViewModel.swift
//  Sample_TableView
//
//  Created by Hemaraju MacMini on 17/03/19.
//  Copyright © 2019 incipio. All rights reserved.


protocol ViewModelDelegate: class {
    func didFinishUpdates()
}


import UIKit
import Foundation

class ViewModel
{
    let rowHeight : Float = 100
    
    var dataList : [DataModel]  = [DataModel]()
    weak var delegate: ViewModelDelegate?
    
    func donwloadWithUrl(){
        
        DispatchQueue.global().async {
            
            guard let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json") else {
                return
                
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                let responseStrInISOLatin = String(data: dataResponse, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    if  let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as? NSDictionary{
                        
                        guard  let listData = responseJSONDict.value(forKey: "rows") as? NSArray else{
                            
                            return
                        }
                        
                        for dict in listData  {
                            
                            let titlee = dict as! NSDictionary
                            
                            let titles = titlee.value(forKey: "title") as? String ?? "na"
                            let descriptions = titlee.value(forKey: "description") as? String ?? "nil"
                            
                            //Check if url string nil or not
                            if let imageUrl = titlee.value(forKey: "imageHref") as? NSNull {
                                
                                print("imageUrl \(imageUrl)")
                                let img = UIImage(named: "flag_of_canada")  //Place the default image from assets if imageurl not found
                                self.dataList.append(DataModel(Name: titles, Image: img , Desc: descriptions))
                                
                            }
                            else
                            {
                                let imageUrl = URL(string: (titlee.value(forKey: "imageHref") as! String))
                                
                                let imgdata = try? Data(contentsOf: imageUrl!)
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
                            
                         //Reload tablview in ViewController for each data row
                         self.delegate?.didFinishUpdates()
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                } catch {
                    print(error)
                }
            }
            
            
            task.resume()
        }
        
        
        
        
        
    }
    
    
    
    
}




