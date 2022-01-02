//
//  ProfileViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit
import SendBirdUIKit

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
        
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        let user = APIFunctions.shareInstance.finduserbyid(id: userid!)
        let imagepath = user.profilePic!
        let image = imagepath.components(separatedBy: "upload\\images\\")[1]
        
        
        let url = URL(string: "http://172.17.0.170:3000/"+image)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            profilepic.image = image
        }
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            
            UserDefaults.standard.removeObject(forKey: "id")
        } else if segue.identifier == "changepic" {
            let destination = segue.destination as! ChangeProfilePictureViewController
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
        
        /*SBDOpenChannel.createChannel(withName: "nameTF.text", channelUrl: "status", coverUrl: "default", data: nil, operatorUserIds: nil, customType: nil, completionHandler: { (openChannel, error) in
            guard error == nil else {
                // Handle error.
                print(error!)
                return
            }

            let channelUrl = openChannel?.channelUrl
            
        })
        
        let channelListVC = SBUChannelListViewController()
        let naviVC = UINavigationController(rootViewController: channelListVC)
        self.present(naviVC, animated: true)*/
        

    }
    

    @IBAction func editprofileAction(_ sender: Any) {
        performSegue(withIdentifier: "editprofile", sender: self)
    }
    
    
    
    
    @IBOutlet weak var profilepic: UIImageView!
    
    
    @IBAction func changepic(_ sender: Any) {
        performSegue(withIdentifier: "changepic", sender: self)
    }
    
}
