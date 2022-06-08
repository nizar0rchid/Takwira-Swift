//
//  NewsDetailsViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    var sentHome: String?
    var sentAway: String?
    var sentElapsed: Int?
    var sentElapsedplus: Int?
    var sentCountry: String?
    var sentLeague: String?
    var sentVenue: String?
    var sentHomegoals: Int?
    var sentAwaygoals: Int?
    
    
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var away: UILabel!
    @IBOutlet weak var homegoals: UILabel!
    @IBOutlet weak var awaygoals: UILabel!
    @IBOutlet weak var elapsed: UILabel!
    @IBOutlet weak var elapsedplus: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var league: UILabel!
    @IBOutlet weak var venue: UILabel!
    
    
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        } else {
            home.text = sentHome!
            away.text = sentAway!
            homegoals.text = String(sentHomegoals!)
            awaygoals.text = String(sentAwaygoals!)
            elapsed.text = String(sentElapsed!)
            elapsedplus.text = String(sentElapsedplus!)
            if sentCountry == nil {
                country.text = "Not available"
            } else {
                country.text = sentCountry!
            }
            
            league.text = sentLeague!
            if sentVenue == nil {
                venue.text = "Not available"
            } else {
                venue.text = sentVenue!
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
