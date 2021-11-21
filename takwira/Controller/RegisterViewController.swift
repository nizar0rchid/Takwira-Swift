//
//  RegisterViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

let config = URLSessionConfiguration.default



class RegisterViewController: UIViewController {
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField! 
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    
    
    
    @IBAction func signupAction(_ sender: Any) {
        let user = userModel(firstName: firstnameTF.text!, lastName: lastnameTF.text!, email: emailTF.text!, password: passwordTF.text!, age: 22, phone: phoneTF.text!, location: locationTF.text!, role: "user")
        
        let status = APIFunctions.shareInstance.Register(user: user)
        if status == 201{
            self.showAlert(title: "Success", message: "User registred succcessfully")
            performSegue(withIdentifier: "successfulRegister", sender: sender)
        } else if status == 400 {
            self.showAlert(title: "Missing info !", message: "Please make sure to fill all the form and try again")
        } else if status == 409 {
            self.showAlert(title: "User exists", message: "User already exists please login")
            performSegue(withIdentifier: "successfulRegister", sender: sender)
        }
        
    
    }
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
