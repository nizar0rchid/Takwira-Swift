//
//  ChangeProfilePictureViewController.swift
//  takwira
//
//  Created by Nizar on 25/12/2021.
//

import UIKit

class ChangeProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = APIFunctions.shareInstance.checkinternet()
        if status != 200 {
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "nointernet") as! NoInternetViewController
            self.present(secondVC, animated:true, completion:nil)
        } else {
            spinner.isHidden = true
        }
        
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
         if segue.identifier == "logoutafterpic" {
            let userid = UserDefaults.standard.value(forKey: "id") as! String?
            let user = APIFunctions.shareInstance.finduserbyid(id: userid!)
            UserDefaults.standard.removeObject(forKey: "id")
            let destination = segue.destination as! LoginViewController
            destination.email = user.email!
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        let userid = UserDefaults.standard.value(forKey: "id") as! String?
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        APIFunctions.shareInstance.image(id: userid!, photo: picker_image!) { error, success in
            if success {
                print("photo uploaded")
                self.spinner.stopAnimating()
                
                let alert = UIAlertController(title: "Success", message: "Profile picture updated successfully, please login again",preferredStyle: .alert)
                let action = UIAlertAction(title:"ok", style: .cancel, handler: { action in self.performSegue(withIdentifier: "logoutafterpic", sender: self) })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    } 

    

}
