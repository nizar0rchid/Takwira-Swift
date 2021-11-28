//
//  ProfileViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    var sentName : String?
    var sentEmail : String?
    var sentAge : Int?
    var sentPhone : String?
    var sentLocation : String?
    
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullname.text = sentName!
        email.text = sentEmail!
        age.text = String(sentAge!)
        phone.text = sentPhone!
        address.text = sentLocation!
        
        
        // Do any additional setup after loading the view.
    }
    

    

}
