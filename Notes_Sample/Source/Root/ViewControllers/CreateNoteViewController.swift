//
//  CreateNoteViewController.swift
//  Notes_Sample
//
//  Created by Ashwini on 03/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextTextView: UITextView!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var note : Note?
    private var imagePickerController : UIImagePickerController?
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let note = self.note {
            self.titleTextField.text = note.title
            self.descriptionTextTextView.text = note.noteDetail
            self.noteDateLabel.text = Date.convertDate(date: note.creationDate!)
            if let images = note.images {
                for eachImage in images {
                    if let image = UIImage.init(data: eachImage) {
                        self.images.append(image)
                    }
                }
            }
        } else {
            noteDateLabel.text = Date.convertDate(date: Date())
        }
        
        // initialize text view UI - border width, radius and color
        descriptionTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextTextView.layer.borderWidth = 1.0
        descriptionTextTextView.layer.cornerRadius = 5
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
    }
        
    // MARK: - Action Methods
    
    @IBAction func saveNoteButtonAction(_ sender: Any) {
        if ( titleTextField.text?.isEmpty ?? true ) || ( descriptionTextTextView.text?.isEmpty ?? true ) {
            let alert = UIAlertController(
                title: "Notes_Sample",
                message: "Please enter Note title and Description to save",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            self.present(alert, animated: true)

        } else {
            var imageData : [Data] = []
            for eachImage in images {
                imageData.append(eachImage.jpegData(compressionQuality: 1.0)!)
            }

            if let note = self.note {
                CoreDataManager.manager.editNote(id: note.id!, title: titleTextField.text!, detail: descriptionTextTextView.text!, creationDate: Date(), images: imageData)
            } else {
                CoreDataManager.manager.addNote(title: titleTextField.text!, detail: descriptionTextTextView.text!, creationDate: Date(), images: imageData)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }

    }
    @IBAction func didTapAddImageButton(_ sender: Any) {

        let actionSheet: UIAlertController = UIAlertController(title: nil, message: "Please select any option", preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelActionButton)

        let galleryActionButton = UIAlertAction(title: "Gallery", style: .default)
            { _ in
                self.imagePickerController = UIImagePickerController()
                self.imagePickerController?.delegate = self
                self.imagePickerController?.sourceType = .savedPhotosAlbum
                self.present(self.imagePickerController!, animated: true, completion: nil)

        }
        actionSheet.addAction(galleryActionButton)

        let cameraActionButton = UIAlertAction(title: "Camera", style: .default)
            { _ in
                self.imagePickerController = UIImagePickerController()
                self.imagePickerController?.delegate = self

                self.imagePickerController?.sourceType = .camera
                self.present(self.imagePickerController!, animated: true, completion: nil)
        }
        actionSheet.addAction(cameraActionButton)
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    @IBAction func didTapBackground(_ sender: Any) {
        self.titleTextField.resignFirstResponder()
        self.descriptionTextTextView.resignFirstResponder()
    }
    
}

//MARK: - Image Picker Controller Delegate Methods
extension CreateNoteViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        images.append(image)

        self.collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Collection Datasource and Delegate Methods
extension CreateNoteViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageview = cell.viewWithTag(100) as? UIImageView {
            imageview.image = images[indexPath.row]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 64)
    }

}
