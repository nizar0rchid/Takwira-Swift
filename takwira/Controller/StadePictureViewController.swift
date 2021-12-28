//
//  StadePictureViewController.swift
//  takwira
//
//  Created by Nizar on 26/12/2021.
//

import UIKit

class StadePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var stadeid: String?
    
    @IBOutlet weak var stadepic: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        spinner.isHidden = true
        
        
        //print(stadeid!)
    }
    
    @IBAction func gallery(_ sender: Any) {
        let myPickerControllerGallery = UIImagePickerController()
              myPickerControllerGallery.delegate = self
              myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
              myPickerControllerGallery.allowsEditing = true
              self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    var picker_image: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedimage = info[.editedImage] as? UIImage else  {
            return
        }
        picker_image = editedimage
              stadepic.image = editedimage
              
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savestade" {
            var id = UserDefaults.standard.value(forKey: "id") as! String?
            var user = APIFunctions.shareInstance.finduserbyid(id: id!)
            let custMainVC = segue.destination as! UITabBarController
            let profileController = custMainVC.viewControllers!.last as! ProfileViewController
            profileController.sentName = user.firstName!+" "+user.lastName!
            profileController.sentEmail = user.email!
            profileController.sentPhone = user.phone!
            profileController.sentLocation = user.location!
            profileController.sentAge = user.age!
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        MatchAPI.shareInstance.stadeImage(id: stadeid!, photo: picker_image!) { error, success in
            if success {
                print("photo uploaded")
                self.spinner.stopAnimating()
                let alert = UIAlertController(title: "Success", message: "Match added succcessfully",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: { action in self.performSegue(withIdentifier: "savestade", sender: self) })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}
