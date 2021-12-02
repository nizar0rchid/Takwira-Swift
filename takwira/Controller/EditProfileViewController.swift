//
//  EditProfileViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class EditProfileViewController: UIViewController {
    var userid : String = UserDefaults.standard.string(forKey: "id")!
    
   
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var locationTF: UITextField!
    
    var newemail : String?
    var newfullname : String?
    var newphone : String?
    var newage : Int?
    var newlocation : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = APIFunctions.shareInstance.finduserbyid(id: userid)
        firstnameTF.text = user.firstName
        lastnameTF!.text = user.lastName
        emailTF!.text = user.email
        phoneTF!.text = user.phone
        locationTF!.text = user.location
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutafterupdate" {
            let destination = segue.destination as! LoginViewController
            destination.email = newemail!
        } else if segue.identifier == "backtoprofile" {
            let destination = segue.destination as! ProfileViewController
            destination.sentName = newfullname!
            destination.sentAge = newage!
            destination.sentEmail = newemail!
            destination.sentPhone = newphone!
            destination.sentLocation = newlocation!
            
        }
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        let dateComponents = NSCalendar.current.dateComponents([.year], from: self.datepicker.date)
        let birthYear = (dateComponents.year)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let age = currentYear - birthYear!
        
        let oldUser = APIFunctions.shareInstance.finduserbyid(id: userid)
        
        var newUser = userModel()
        newUser._id = userid
        newUser.firstName = firstnameTF.text!
        newUser.lastName = lastnameTF.text!
        newUser.email = emailTF.text!
        newUser.age = age
        newUser.phone = phoneTF.text!
        newUser.location = locationTF.text!
        
        if confirmpasswordTF.text == passwordTF.text {
            if passwordTF.text! == UserDefaults.standard.string(forKey: "plainpassword"){
                
                if newUser.firstName == oldUser.firstName && newUser.lastName == oldUser.lastName && newUser.email == oldUser.email && newUser.age == oldUser.age && newUser.phone == oldUser.phone && newUser.location == oldUser.location {
                    let alert = UIAlertController(title: "Warning", message: "No new info registred",preferredStyle: .alert)
                    let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    
                    newemail = newUser.email!
                    newfullname = newUser.firstName!+" "+newUser.lastName!
                    newage = newUser.age!
                    newphone = newUser.phone!
                    newlocation = newUser.location!
                    
                    APIFunctions.shareInstance.updateProfile(_id: userid, firstname: newUser.firstName!, lastname: newUser.lastName!, email: newUser.email!, age: newUser.age!, phone: newUser.phone!, location: newUser.location!, password: UserDefaults.standard.string(forKey: "password")!, role: oldUser.role!)
                    
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "id")
                    let alert = UIAlertController(title: "Success", message: "Info updated successfully, please login again",preferredStyle: .alert)
                    let action = UIAlertAction(title:"ok", style: .cancel, handler: { action in self.performSegue(withIdentifier: "logoutafterupdate", sender: self) })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            } else {
                let alert = UIAlertController(title: "Warning", message: "Please check your password and try again",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Warning", message: "Passwords don't match, please verify and try again",preferredStyle: .alert)
            let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
   

}
