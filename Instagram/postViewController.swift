//
//  postViewController.swift
//  Instagram
//
//  Created by Joe Sloan on 12/7/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse

class postViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func displayAlert(title: String, message: String){
        //Create an alert called "Error in Form" with a subtitle.  Normal Styling.
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        //Add an action to the alert for the user to dismiss it.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        //Present the alert, don't do anything when it's dismissed.
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var imageToPost: UIImageView!
    
    
    @IBOutlet weak var captionField: UITextField!
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        
        //Define an imagePicker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //if the user picked an image(represented by String data) that can be used as an image
        //i.e. if there's some good valid data
        if let image =  info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //set that image to the one we're posting
            imageToPost.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func postPhoto(_ sender: Any) {
        
        
        if let image = imageToPost.image {
            let post = PFObject(className: "Post")
            post["message"] = captionField.text
            post["userId"] = PFUser.current()?.objectId
            if let imageData = UIImagePNGRepresentation(image){
                
                //Start a spinner
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                post.saveInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if success {
                        self.displayAlert(title: "Image Posted!", message: "Your image has been posted successfully!")
                        self.captionField.text = ""
                        self.imageToPost.image = nil
                    }else{
                        self.displayAlert(title: "Error", message: "Image could not be posted")
                    }
                })
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
