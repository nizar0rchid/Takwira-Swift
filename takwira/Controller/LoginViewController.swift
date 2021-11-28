//
//  LoginViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class LoginViewController: UIViewController {

    var email : String?
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.text = email
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SigninSegue" {
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
    
    @IBAction func SigninSegue(_ sender: Any) {
        
        if emailTF.text == "" || passwordTF.text == "" {
            self.showAlert(title: "Invalid credentials", message: "Please make sure to fill all the info.")
        } else {
            let user = APIFunctions.shareInstance.login(email: emailTF.text!, password: passwordTF.text!)
            
            if user._id != nil{
                
                performSegue(withIdentifier: "SigninSegue", sender: self)
                
            } else {
                self.showAlert(title: "Invalid credentials", message: "Please verify your info and try again.")
            }
        }
        
        
    }
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getUser() -> userModel {
        let user = APIFunctions.shareInstance.login(email: emailTF.text!, password: passwordTF.text!)
        return user
    }
    

}
