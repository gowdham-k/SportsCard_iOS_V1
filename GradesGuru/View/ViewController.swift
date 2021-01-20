//
//  ViewController.swift
//  GradesGuru
//
//  Created by Superpower on 16/08/20.
//  Copyright © 2020 iMac superpower. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    var GradeDetails = ["Centering", "Corners", "Surface", "Edges"]

    @IBOutlet weak var scanfrontPage: UIImageView!
    @IBOutlet weak var scanBackPage: UIImageView!
    
    
    @IBOutlet weak var frontScanBtn: UIButton!
    @IBOutlet weak var backScanBtn: UIButton!
    
    @IBOutlet weak var gradeEstLbl: UILabel!
    @IBOutlet weak var completeLbl: UILabel!
    
    var selected_img = ""
    var isfrontAdded: Bool = false
    var isbackAdded: Bool = false
    
    var isFrontImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(verifyFrontImageAdded(notification:)), name: Notification.Name("frontImgSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(verifyBackImageAdded(notification:)), name: Notification.Name("backImgSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(bothImageAdded(notification:)), name: Notification.Name("bothImageAdded"), object: nil)
      
        //Upload image action:
        let tapFrontImg = UITapGestureRecognizer(target: self, action: #selector(scanFrontPage(tapGestureRecognizer:)))
        scanfrontPage.isUserInteractionEnabled = true
        scanfrontPage.addGestureRecognizer(tapFrontImg)
        
        let tapBackImg = UITapGestureRecognizer(target: self, action: #selector(scanBackPage(tapGestureRecognizer:)))
        scanBackPage.isUserInteractionEnabled = true
        scanBackPage.addGestureRecognizer(tapBackImg)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func scanFrontPage(tapGestureRecognizer: UITapGestureRecognizer) {
        selected_img = "front_img"
        print(":::::FrontImage view tapped ::::::")
        scanImageOption()
        
        
    }
    
    @objc func scanBackPage(tapGestureRecognizer: UITapGestureRecognizer) {
        selected_img = "back_img"
        print(":::::BackImage view tapped ::::::")
        scanImageOption()
        
    }
    
    @IBAction func infoBtnAction(_ sender: Any) {
        showViewInfo()
    }
    
    @IBAction func frontReScanBtnTapped(_ sender: Any) {
        scanImageOption()
    }
    
    @objc func verifyFrontImageAdded(notification: Notification) {
        if isFrontImage {
            print("£££ front Image added £££")
            self.frontScanBtn.isHidden = false
            self.isfrontAdded = true
        } else {
            print("£££ front Image empty £££")
            self.frontScanBtn.isHidden = true
            self.isfrontAdded = false
        }
        
    }
    
    @objc func verifyBackImageAdded(notification: Notification) {
        if isFrontImage {
            print("£££ back Image added £££")
            self.backScanBtn.isHidden = false
            self.isbackAdded = true
        } else {
            print("£££ back Image empty £££")
            self.backScanBtn.isHidden = true
            self.isbackAdded = false
        }
        
    }
    
    @objc func bothImageAdded(notification: Notification) {
        if isfrontAdded && isbackAdded {
            self.completeLbl.textColor = .systemGreen
            self.gradeEstLbl.textColor = .systemGreen
        } else {
            self.completeLbl.textColor = .systemBlue
            self.gradeEstLbl.textColor = .systemBlue

        }
        
    }
    
}


extension ViewController {
    
    func scanImageOption()
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.openCamera()
                }))

                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                    self.openGallery()
                }))

                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)

    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showViewInfo() {
        //self.navigationController?.navigationBar.isHidden = true
        let infoPage = self.storyboard?.instantiateViewController(withIdentifier: "InfoVc") as! InfoVc
        infoPage.modalPresentationStyle = .overCurrentContext
        self.present(infoPage, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:-- ImagePicker delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            var pickedImage : UIImage!

            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                    {
                pickedImage = img

                    }
            else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                    {
                pickedImage = img
                    }
            if selected_img == "front_img"
            {
                
            self.scanfrontPage.image = pickedImage
            self.isFrontImage = true
                
            NotificationCenter.default.post(name: Notification.Name("frontImgSelected"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("bothImageAdded"), object: nil)

            self.scanfrontPage.layer.cornerRadius = 8.0
            self.scanfrontPage.layer.masksToBounds = true
            self.scanfrontPage.layer.borderColor = UIColor.gray.cgColor
            self.scanfrontPage.layer.borderWidth = 1.0
                
            self.scanfrontPage.isHidden = false
            self.scanfrontPage.contentMode = .scaleAspectFill
                
            
            }
            else{
                self.scanBackPage.image = pickedImage
                
                NotificationCenter.default.post(name: Notification.Name("backImgSelected"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("bothImageAdded"), object: nil)

                self.scanBackPage.layer.cornerRadius = 8.0
                self.scanBackPage.layer.masksToBounds = true
                self.scanBackPage.layer.borderColor = UIColor.gray.cgColor
                self.scanBackPage.layer.borderWidth = 1.0
                
                self.scanBackPage.isHidden = false
                self.scanBackPage.contentMode = .scaleAspectFill
                
                

            }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int
   {
       return 1
   }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
       return 4
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
       var cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")

              if cell == nil {
                  cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
              }

              cell!.textLabel?.text = GradeDetails[indexPath.row]
              cell!.detailTextLabel?.text = "Review"

              return cell!
      }
}

