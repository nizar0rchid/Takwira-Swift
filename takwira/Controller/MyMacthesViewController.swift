//
//  MyMacthesViewController.swift
//  takwira
//
//  Created by Nizar on 29/12/2021.
//

import UIKit

class MyMacthesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mystades = getmymatches()
        return mystades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var stades = getmymatches()
        let cell = tableView.dequeueReusableCell(withIdentifier: "nCell")
        let cv = cell?.contentView
        let stadename = cv?.viewWithTag(1) as! UILabel
        let stade = stades [indexPath.row]
        stadename.text = stade.name
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mymatch" {
            var stades = getmymatches()
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! MatchDetailsViewController
            var stade = stades [indexPath.row]
            destination.stadeid = stade._id
            destination.sentname = stade.name
            destination.sentdatetime = stade.DateTime
            destination.sentprice = stade.price
            destination.sentlocation = stade.location
            destination.sentphone = stade.phone
            destination.sentimage = stade.image
            destination.sentcapacity = stade.capacity
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mymatch", sender: indexPath)
    }

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var mystades = getmymatches()
        
    }

    
    
    
    func getmymatches() -> Array<StadeModel> {
        var mymatches = [MatchModel]()
        var matches = MatchAPI.shareInstance.getallmatches()
        
        var stades = MatchAPI.shareInstance.getStades()
        
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        
        var teamsA = [String]()
        var teamsB = [String]()
        
        for match in matches {
            for id in match.teamA!{
                if id != nil && id == userid {
                    teamsA.append(match.stadeId!)
                }
                
            }
            for id in match.teamB! {
                if id != nil && id == userid{
                    teamsB.append(match.stadeId!)
                }
            }
        }
        
        let teams = teamsA + teamsB
        var mystades = [StadeModel]()
        for id in teams {
            mystades.append(MatchAPI.shareInstance.getstadebyid(stadeid: id))
        }
        return mystades
    }
    
    

}
