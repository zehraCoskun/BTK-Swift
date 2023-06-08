//
//  DetailViewController.swift
//  SuperKahramanUIKit
//
//  Created by Zehra Coşkun on 26.04.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var secilenKahramanDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: secilenKahramanDetail)
        label.text = secilenKahramanDetail
    }
    


}
