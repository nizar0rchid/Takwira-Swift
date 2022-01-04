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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successfulRegister" {
            let destination = segue.destination as! LoginViewController
            destination.email = emailTF.text
        } else if segue.identifier == "profilepic" {
            let destination = segue.destination as! ProfilePicViewController
            destination.email = emailTF.text
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        let dateComponents = NSCalendar.current.dateComponents([.year], from: self.datepicker.date)
        let birthYear = (dateComponents.year)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let age = currentYear - birthYear!


        
        
        if confirmpasswordTF.text != passwordTF.text{
            self.showAlert(title: "Error", message: "Passwords don't match, please verify and try again")
        } else {
            let user = userModel(firstName: firstnameTF.text!, lastName: lastnameTF.text!, email: emailTF.text!, password: passwordTF.text!, age: age, phone: phoneTF.text!, location: locationTF.text!, role: "user")
            
            let status = APIFunctions.shareInstance.Register(user: user)
            
            if status == 201{
                
                let alert = UIAlertController(title: "Success", message: "User registred succcessfully",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: { action in self.performSegue(withIdentifier: "profilepic", sender: self) })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else if status == 400 {
                self.showAlert(title: "Missing info !", message: "Please make sure to fill all the form and try again")
            } else if status == 409 {
                let alert = UIAlertController(title: "User exists", message: "User already exists please login",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: { action in self.performSegue(withIdentifier: "successfulRegister", sender: self) })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
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
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        }
        // Do any additional setup after loading the view.
    }

}
