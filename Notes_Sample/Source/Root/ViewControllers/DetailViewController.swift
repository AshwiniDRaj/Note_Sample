//
//  DetailViewController.swift
//  Notes_Sample
//
//  Created by Ashwini on 03/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDate: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = noteTitleLabel,
                let dateLabel = noteDate,
                let textView = noteTextTextView {
                topicLabel.text = detail.title
                dateLabel.text = Date.convertDate(date: detail.creationDate!)
                textView.text = detail.noteDetail
                
                self.imageCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    var detailItem: Note? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNoteViewController" {
            if let editNoteVC = segue.destination as? CreateNoteViewController, let detail = detailItem {
                editNoteVC.note = detail
            }
        }
    }
}

//MARK: - Collection Datasource and Delegate Methods
extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailItem?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageview = cell.viewWithTag(100) as? UIImageView {
            if let noteMedia = detailItem?.images?[indexPath.row] {
                imageview.image = UIImage.init(data: noteMedia)
            }
            
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 64)
    }

}
