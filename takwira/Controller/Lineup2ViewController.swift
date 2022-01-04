//
//  Lineup2ViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class Lineup2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var sentdate: String?
    var sentnametitle: String?
    var sentmatch: MatchModel?
    var sentteamchoice: String?
    
    @IBOutlet weak var nametitle: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var joinbutton: UIButton!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let team2 = sentmatch!.teamB!
        
        let filtered = team2.compactMap { $0 }
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var team2 = sentmatch!.teamB!
        
        var filtered = team2.compactMap { $0 }

        
        var users = [userModel]()
        
        for iduser in filtered {
            
            var userprofile = APIFunctions.shareInstance.finduserbyid(id: iduser )
                
                users.append(userprofile)
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "nCell")
        let cv = cell?.contentView
        let username = cv?.viewWithTag(1) as! UILabel
        let phonenumber = cv?.viewWithTag(2) as! UILabel
        let profilepic = cv?.viewWithTag(3) as! UIImageView
        
        let user = users[indexPath.row]
        let first = user.firstName ?? ""
        let last = user.lastName ?? ""
        username.text = first+" "+last
        phonenumber.text = user.phone ?? ""
        
        let imagepath = user.profilePic ?? ""
        
        let image = imagepath.components(separatedBy: "upload\\images\\")[1]
        
        
        let url = URL(string: HOST+"/"+image)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            profilepic.image = image
        }
        
        return cell!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        } else {
            nametitle.text! = sentnametitle!
            time.text! = sentdate!
            
            let team2 = sentmatch!.teamB!
            let filtered = team2.compactMap { $0 }
            let userid = UserDefaults.standard.value(forKey: "id") as! String?
            for id in filtered {
                if id == userid {
                    joinbutton.setTitle("Leave match", for: .normal)
                } else {
                    joinbutton.setTitle("Join match", for: .normal)
                }
            }
            if sentteamchoice! == "teamA" {
                joinbutton.isHidden = true
            }
        }
        
    }
    

    @IBAction func joinaction(_ sender: Any) {
        let team2 = sentmatch!.teamB!
        
        let filtered = team2.compactMap { $0 }
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        
        
        for id in team2 {
            if id == userid {
                
                
                MatchAPI.shareInstance.canceljointeamB(userid: userid!, matchid: sentmatch!._id!)
                let alert = UIAlertController(title: "Done", message: "Successfully left the match",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        
                self.table.reloadData()
                joinbutton.isHidden = true
                
                break

            } else {
                MatchAPI.shareInstance.jointeamB(userid: userid!, matchid: sentmatch!._id!)
                let alert = UIAlertController(title: "Done", message: "Successfully joined the match",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        
                self.table.reloadData()
                joinbutton.isHidden = true
                
                break
            }
        }
        
        
    }
    
    
    

}
