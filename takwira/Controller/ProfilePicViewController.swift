//
//  ProfilePicViewController.swift
//  takwira
//
//  Created by Nizar on 22/12/2021.
//

import UIKit

class ProfilePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var email : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageview: UIImageView!
    
   
    @IBAction func btnprofilepic(_ sender: Any) {
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
              imageview.image = editedimage
              
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginafterpic" {
            let destination = segue.destination as! LoginViewController
            destination.email = email!
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let user = APIFunctions.shareInstance.findbyemail(email: email!)
        let id = user._id
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        APIFunctions.shareInstance.image(id: id!, photo: picker_image!) { error, success in
            if success {
                print("photo uploaded")
                self.spinner.stopAnimating()
                self.performSegue(withIdentifier: "loginafterpic", sender: self)
            }
        }
}
    
    ///// to do : perform segue to login screen, show alert on picture save,

}
