//
//  ViewController.swift
//  SavingImagesLocally
//
//  Created by Sierra on 9/14/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

var userDefaults = UserDefaults.standard

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userName.text = userDefaults.string(forKey: "name")
        
        let NewunarchivedData = userDefaults.string(forKey: "image")
        if let NewunarchivedData = NewunarchivedData{
            let imagepath = imagePath(imageName: NewunarchivedData )
          //  let image = UIImage(contentsOfFile: imagepath.path)
            let image = UIImage(named: imagepath.path)
            userImage.image = image
        }
    //    userImage.image = UIImage(named: userDefaults.string(forKey: "image")!)
    }

    @IBAction func setImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate=self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerEditedImage]
        userImage.image = selectedImage as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePath(imageName:String) -> URL {
        let urlpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = urlpath[0]
        let imagepath = directory.appendingPathComponent(imageName)
        return imagepath
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        let name = userName.text!
        let imageName = name.removeSpaces()
        let randomInt = arc4random_uniform(1000)
        let finalimageName = "\(imageName)\(randomInt)"
        userDefaults.set(finalimageName, forKey: "image")
        userDefaults.set(name, forKey: "name")
        let selectedimage = userImage.image!
        if let jpgimage = UIImageJPEGRepresentation(selectedimage, 0.8){
            let urlpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let directory = urlpath[0]
            let imagepath = directory.appendingPathComponent(finalimageName)
            
            try? jpgimage.write(to: imagepath)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension String{
    
    func removeSpaces()->String{
        return self.replacingOccurrences(of: " ", with: "")
    }
}
