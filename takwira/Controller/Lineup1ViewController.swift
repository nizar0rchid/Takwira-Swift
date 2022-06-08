//
//  Lineup1ViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit
import CoreData
import SendBirdUIKit

class Lineup1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var matchChatbutton: UIButton!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        let team1 = match.teamA!
        
        let filtered = team1.compactMap { $0 }
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        let team1 = match.teamA!
        
        let filtered = team1.compactMap { $0 }

        
        var users = [userModel]()
        
        for iduser in filtered {
            
            let userprofile = APIFunctions.shareInstance.finduserbyid(id: iduser )
                
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
    
    
    var sentstadeid: String?
    var senttitle: String?
    var sentdate: String?
    
    
    @IBOutlet weak var nametitle: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var joinbutton: UIButton!
    
    @IBAction func chat(_ sender: Any) {
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        let user = APIFunctions.shareInstance.finduserbyid(id: userid!)
        let nickname = user.firstName!+" "+user.lastName!
        let imagepath = user.profilePic!
        
        let image = imagepath.components(separatedBy: "upload\\images\\")[1]
        
        
        let url = HOST+"/"+image
        
        SBUGlobals.CurrentUser = SBUUser(userId: user._id!, nickname: nickname, profileUrl: url)
        
        SBUMain.connect { (user, error) in
            guard user != nil else {
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
        
       ////////// join channel
        SBDGroupChannel.getWithUrl(sentstadeid!, completionHandler: { (groupChannel, error) in
            guard error == nil else {
                // Handle error.
                print(error!)
                return
            }

            // Call the instance method of the result object in the "openChannel" parameter of the callback method.
            if groupChannel!.isPublic {
                groupChannel?.join(completionHandler: { (error) in
                    guard error == nil else {
                        // Handle error.
                        print(error)
                        return
                    }
                    let vc = SBUChannelViewController(channelUrl: self.sentstadeid!)
                    //let vc = SBUChannelListViewController()
                    let naviVC = UINavigationController(rootViewController: vc)
                    self.present(naviVC, animated: true)
                    // The current user successfully joins the group channel
                    
                })
            }
            
        })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        } else {
            nametitle.text! = senttitle!
            date.text! = sentdate!
            let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
            let team1 = match.teamA!
            
            let filtered = team1.compactMap { $0 }
            let userid = UserDefaults.standard.value(forKey: "id") as! String?
            for id in filtered {
                if id == userid {
                    joinbutton.setTitle("Leave match", for: .normal)
                } else {
                    joinbutton.setTitle("Join match", for: .normal)
                }
            }
            let teamchoice = checkuserteam()
            if teamchoice == "teamB" {
                joinbutton.isHidden = true
            }
            
            if teamchoice == "" {
                matchChatbutton.isHidden = true
            }
        }

        
        
        
        
    }
    
    
    @IBAction func joincancel(_ sender: Any) {
        let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        let team1 = match.teamA!
        
        _ = team1.compactMap { $0 }
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        
        for id in team1 {
            if id == userid {
                
                
                MatchAPI.shareInstance.canceljointeamA(userid: userid!, matchid: match._id!)
                let alert = UIAlertController(title: "Done", message: "Successfully left the match",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        
                self.tableview.reloadData()
                joinbutton.isHidden = true
                matchChatbutton.isHidden = false
                break

            } else if id == nil {
                MatchAPI.shareInstance.jointeamA(userid: userid!, matchid: match._id!)
                
               
                
                let alert = UIAlertController(title: "Done", message: "Successfully joined the match",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        
                self.tableview.reloadData()
                joinbutton.isHidden = true
                
                SBDGroupChannel.getWithUrl(sentstadeid!, completionHandler: { (groupChannel, error) in
                    guard error == nil else {
                        // Handle error.
                        print(error!)
                        return
                    }

                    // Call the instance method of the result object in the "openChannel" parameter of the callback method.
                    
                    groupChannel?.leave(completionHandler: { (error) in
                        guard error == nil else {
                            // Handle error.
                            print(error!)
                            return
                        }
                        
                        self.matchChatbutton.isHidden = true
                        
                    })
                    
                    
                })
                break
            }
        }
 
        
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teamB" {
            let destination = segue.destination as! Lineup2ViewController
            let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
            destination.sentdate = date.text!
            destination.sentnametitle = nametitle.text!
            destination.sentmatch = match
            let teamchoice = checkuserteam()
            destination.sentteamchoice = teamchoice
            
        }
    }
    
    @IBAction func teamb(_ sender: Any) {
        performSegue(withIdentifier: "teamB", sender: self)
    }
    
    
    func checkuserteam() -> String {
        let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        let team1 = match.teamA!
        let team2 = match.teamB!
        let filtered2 = team2.compactMap { $0 }
        let filtered1 = team1.compactMap { $0 }
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        
        for id in filtered1 {
            if id == userid {
                return "teamA"
            } else {
                return "not team A"
            }
            
        }
        for id in filtered2 {
            if id == userid {
                return "teamB"
            } else {
                return "not team B"
            }
        }
        return ""
    }

}
