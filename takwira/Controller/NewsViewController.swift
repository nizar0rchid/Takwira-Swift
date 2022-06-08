//
//  NewsViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var matches = APIFunctions.shareInstance.liveMatches()
    
    @IBOutlet weak var Tableview: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nCell")
        let cv = cell?.contentView
        let homeLabel = cv?.viewWithTag(1) as! UILabel
        let awayLabel = cv?.viewWithTag(2) as! UILabel
        let match = matches [indexPath.row]
        homeLabel.text = match.homeName
        awayLabel.text = match.awayName
        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "livematchdetail" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! NewsDetailsViewController
            let match = matches [indexPath.row]
            destination.sentHome = match.homeName
            destination.sentAway = match.awayName
            destination.sentVenue = match.venue
            destination.sentLeague = match.league
            destination.sentCountry = match.country
            destination.sentElapsed = match.elapsed
            destination.sentElapsedplus = match.elapsedPlus
            destination.sentHomegoals = match.team_home_goals
            destination.sentAwaygoals = match.team_away_goals
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "livematchdetail", sender: indexPath)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        }
    }
        // Do any additional setup after loading the view.
}
    
