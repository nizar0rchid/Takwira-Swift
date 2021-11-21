//
//  LoginViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func SigninSegue(_ sender: Any) {
        performSegue(withIdentifier: "SigninSegue", sender: sender)
    }
    
    

}
