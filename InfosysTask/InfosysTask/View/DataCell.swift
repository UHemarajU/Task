//
//  ProductCell.swift
//  InfosysTask
//
//  Created by Hemaraju MacMini on 13/03/19.
//  Copyright © 2019 incipio. All rights reserved.
//

import UIKit


class DataCell : UITableViewCell {

    
    var data : DataModel? {
        didSet {
           Image.image = data?.Image
           NameLabel.text = data?.Name
           DescriptionLabel.text = data?.Desc
        }
    }
    
    
    private let NameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textAlignment = .left
       
        return lbl
    }()
    
    
    private let DescriptionLabel : UITextView = {
        let lbl = UITextView()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .justified
        
        return lbl
    }()
    
   
    
    
    private let Image : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "flag_of_canada"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        
        return imgView
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(Image)
        addSubview(NameLabel)
        addSubview(DescriptionLabel)
      
     
      
        
        Image.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 120, height: 120, enableInsets: false)
        NameLabel.anchor(top: topAnchor, left: Image.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        DescriptionLabel.anchor(top: NameLabel.bottomAnchor, left: Image.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2 , height: 90, enableInsets: false)
        
        
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
