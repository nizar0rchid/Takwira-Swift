//
//  ViewController.swift
//  takwira
//
//  Created by Nizar on 9/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    

    var id = UserDefaults.standard.value(forKey: "id") as! String?
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "remember" {
            
            let user = getUser()
            
            let custMainVC = segue.destination as! UITabBarController
            let profileController = custMainVC.viewControllers!.last as! ProfileViewController
            profileController.sentName = user.firstName!+" "+user.lastName!
            profileController.sentEmail = user.email!
            profileController.sentPhone = user.phone!
            profileController.sentLocation = user.location!
            profileController.sentAge = user.age!
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if id != nil {
            
            performSegue(withIdentifier: "remember", sender: self)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    func getUser() -> userModel {
        let user = APIFunctions.shareInstance.finduserbyid(id: id!)
        return user
    }
}
