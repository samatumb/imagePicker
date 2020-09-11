//
//  DetailViewController.swift
//  ImagePickerDay50
//
//  Created by Samat on 01.08.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(contentsOfFile: imageToLoad)
        }
    }
     
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.hidesBarsOnTap = true
     }
     
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         navigationController?.hidesBarsOnTap = false
     }
}
