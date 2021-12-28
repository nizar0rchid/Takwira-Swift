//
//  AddStadeViewController.swift
//  takwira
//
//  Created by Nizar on 26/12/2021.
//

import UIKit

class AddStadeViewController: UIViewController {

    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var capacityTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var status: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addstadepic" {
            let destination = segue.destination as! StadePictureViewController
            destination.stadeid = status!
            
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        
        if nameTF.text! == "" || capacityTF.text! == "" || priceTF.text! == "" || locationTF.text! == "" || phoneTF.text! == "" {
            let alert = UIAlertController(title: title, message: "Please make sure to fill all details",preferredStyle: .alert)
            let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "HH:mm E, d MMM y"
            let datestring = formatter3.string(from: datePicker.date)
             status = MatchAPI.shareInstance.addStade(name: nameTF.text!, capacity: Int(capacityTF.text!)!, price: Float(priceTF.text!)!, location: locationTF.text!, phone: phoneTF.text!, datetime: datestring)
            status!.removeFirst()
            
            status!.removeLast()
            if status != "" {
                
                let capacity = Int(capacityTF.text!)
                var userid = UserDefaults.standard.value(forKey: "id") as! String?
                MatchAPI.shareInstance.autojoinmatch(teamcapacity: capacity!/2, stadeId: status!, userId: userid!)
                
                performSegue(withIdentifier: "addstadepic", sender: self)
            } else {
                let alert = UIAlertController(title: title, message: "Some error occured, please try again",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    

}
