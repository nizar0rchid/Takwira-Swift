//
//  MatchDetailsViewController.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import UIKit

class MatchDetailsViewController: UIViewController {
    
    var stadeid: String?
    var sentname: String?
    var sentdatetime: String?
    var sentprice: Float?
    var sentlocation: String?
    var sentphone: String?
    var sentcapacity: Int?
    var sentimage: String?
    
    
    @IBOutlet weak var titlename: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titlename.text! = sentname!
        date.text! = sentdatetime!
        let stringprice = String(sentprice!)
        price.text! = stringprice+" per person"
        location.text! = sentlocation!
        phone.text! = sentphone!
        let image = sentimage!.components(separatedBy: "upload\\images\\")[1]
        let url = URL(string: "http://172.17.0.170:3000/"+image)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            imageview.image = image
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lineup1" {
                if let destVC = segue.destination as? UINavigationController,
                    let destination = destVC.topViewController as? Lineup1ViewController {
                    destination.sentstadeid = stadeid!
                    destination.sentdate = date.text!
                    destination.senttitle = titlename.text!
                    
                    
                    
                }
            }
    }
    
    
    @IBAction func lineup1(_ sender: Any) {
        performSegue(withIdentifier: "lineup1", sender: self)
    }
    

}
