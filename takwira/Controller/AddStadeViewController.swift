//
//  AddStadeViewController.swift
//  takwira
//
//  Created by Nizar on 26/12/2021.
//

import UIKit
import SendBirdUIKit

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
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        }

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
                
                
                let user = APIFunctions.shareInstance.finduserbyid(id: userid!)
                let nickname = user.firstName!+" "+user.lastName!
                let imagepath = user.profilePic!
                
                let image = imagepath.components(separatedBy: "upload\\images\\")[1]
                
                
                let url = HOST+"/"+image
                
                SBUGlobals.CurrentUser = SBUUser(userId: user._id!, nickname: nickname, profileUrl: url)
                
                SBUMain.connect { (user, error) in
                    guard let user = user else {
                        // The user is offline and you can't access any user information stored in the local cache.
                        return
                    }
                    if let error = error {
                        // The user is offline but you can access user information stored in the local cache.
                        print(error)
                    }
                    else {
                        // The user is online and connected to the server.
                    }
                }
                
                
                
                
                var params = SBDGroupChannelParams()
                var users: [String] = []
                params.isPublic = true
                params.isEphemeral = false
                params.isDistinct = false
                params.isSuper = false
                params.addUserIds(users)
                params.operatorUserIds = [userid!]       // Or .operators
                params.name = nameTF.text!
                params.channelUrl = status!  // In a group channel, you can create a new channel by specifying its unique channel URL in a 'GroupChannelParams' object.
                params.coverImage = nil            // Or .coverUrl
                params.data = nil
                params.customType = nil
                
                SBDGroupChannel.createChannel(with: params, completionHandler: { (groupChannel, error) in
                    guard error == nil else {
                        print(error)
                        return
                    }

                    // A group channel with detailed configuration is successfully created.
                    // By using groupChannel.channelUrl, groupChannel.members, groupChannel.data, groupChannel.customType, and so on,
                    // you can access the result object from Sendbird server to check your SBDGroupChannelParams configuration.
                    let channelUrl = groupChannel?.channelUrl
                   
                })
                
                
                
                
                /////////////////
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
