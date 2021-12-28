//
//  Lineup1ViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class Lineup1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        let team1 = match.teamA!
        
        let filtered = team1.compactMap { $0 }
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        var team1 = match.teamA!
        
        var filtered = team1.compactMap { $0 }

        
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
        
        
        let url = URL(string: "http://192.168.1.17:3000/"+image)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    
    @IBAction func joincancel(_ sender: Any) {
        let match = MatchAPI.shareInstance.findmatchwithstadeid(stadeid: sentstadeid!)
        let team1 = match.teamA!
        
        let filtered = team1.compactMap { $0 }
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
                break

            } else if id == nil {
                MatchAPI.shareInstance.jointeamA(userid: userid!, matchid: match._id!)
                let alert = UIAlertController(title: "Done", message: "Successfully joined the match",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        
                self.tableview.reloadData()
                joinbutton.isHidden = true
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
