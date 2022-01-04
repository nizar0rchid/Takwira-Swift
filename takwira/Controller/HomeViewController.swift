//
//  HomeViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stades = MatchAPI.shareInstance.getStades()
    @IBOutlet weak var tableview: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nCell")
        let cv = cell?.contentView
        let stadename = cv?.viewWithTag(1) as! UILabel
        let stade = stades [indexPath.row]
        stadename.text = stade.name
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stadedetails" {
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
        performSegue(withIdentifier: "stadedetails", sender: indexPath)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        }
        // Do any additional setup after loading the view.
        
        
    }
    

    


}
