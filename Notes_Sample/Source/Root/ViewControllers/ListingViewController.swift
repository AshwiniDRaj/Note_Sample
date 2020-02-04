//
//  ListingViewController.swift
//  Notes_Sample
//
//  Created by Ashwini on 03/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let refreshData = Notification.Name("RefreshData")
}

class ListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterHolderView: UIView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            // set context in the storage
            CoreDataManager.manager.setManagedContext(managedObjectContext: managedContext)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(syncDataFromDB), name: NSNotification.Name.refreshData, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncDataFromDB()
    }
    
    @objc func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "CreateNoteViewController", sender: self)
    }

    @objc func syncDataFromDB() {
        CoreDataManager.manager.fetchNotes()
        self.tableView.reloadData()
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            if let indexPath = tableView.indexPathForSelectedRow, let note = CoreDataManager.manager.notes?[indexPath.row] {
                
               let controller = segue.destination as! DetailViewController
               controller.detailItem = note
            }
        }
    }

    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource()?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as! NoteListTableViewCell
        if let note = self.dataSource()?[indexPath.row] {
            cell.updateData(data: note)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let note = self.dataSource()?[indexPath.row] {
                CoreDataManager.manager.deleteNoteFromCoreData(idToBeDeleted: note.id!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func didTapFilterAction(_ sender: Any) {
        if self.filterHolderView.isHidden {
            self.filterHolderView.isHidden = false
            self.startDateTextField.text = Date.convertDate(date: Date().firstDateOfMonth(), format: "dd/MM/yyyy")
            self.endDateTextField.text = Date.convertDate(date: Date(), format: "dd/MM/yyyy")
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didTapClearAction(_ sender: Any) {
        self.filterHolderView.isHidden = true
        self.tableView.reloadData()
    }
    
    @IBAction func presentDatePicker(_ sender: Any) {
        let datePickerView = UIDatePicker()
        
        if let textField = (sender as?  UITextField) {
            
            switch textField {
            case startDateTextField:
                datePickerView.tag = 200
                datePickerView.maximumDate = Date()

                if let startDate = startDateTextField.text, let date = Date.convertDate(date: startDate, format: "dd/MM/yyyy") {
                    datePickerView.date = date
                }
            case endDateTextField:
                datePickerView.tag = 201
                datePickerView.maximumDate = Date()

                if let startDate = startDateTextField.text, let date = Date.convertDate(date: startDate, format: "dd/MM/yyyy") {
                    datePickerView.minimumDate = date
                }

                if let endDate = endDateTextField.text, let date = Date.convertDate(date: endDate, format: "dd/MM/yyyy") {
                    datePickerView.date = date
                }
                
            default:
                break
            }
            datePickerView.datePickerMode = .date
            (sender as? UITextField)?.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {

        let date = Date.convertDate(date: sender.date, format: "dd/MM/yyyy")
        switch sender.tag {
        case 200:
            startDateTextField.text = date
            
        case 201:
            endDateTextField.text = date
            
        default:
            break
        }
        dismissKeyboard()
        self.tableView.reloadData()
    }

    @objc func dismissKeyboard() {
        startDateTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
    }

    // MARK: - Utility Methods
    
    func dataSource() -> [Note]? {
        
        if ( !(searchBar.text?.isEmpty ?? true)  ) && !self.filterHolderView.isHidden {
            return CoreDataManager.manager.notes?.filter { (($0.title?.localizedCaseInsensitiveContains(searchBar.text!))!) || (($0.noteDetail?.localizedCaseInsensitiveContains(searchBar.text!))!) && Date.convertDate(date: $0.creationDate!, format: "dd/MM/yyyy") >= startDateTextField.text! && Date.convertDate(date: $0.creationDate!, format: "dd/MM/yyyy") <= endDateTextField.text! }
        } else if ( !(searchBar.text?.isEmpty ?? true) ) {
            return CoreDataManager.manager.notes?.filter { (($0.title?.localizedCaseInsensitiveContains(searchBar.text!))!) || (($0.noteDetail?.localizedCaseInsensitiveContains(searchBar.text!))!) }
        } else if !self.filterHolderView.isHidden {
            return CoreDataManager.manager.notes?.filter { Date.convertDate(date: $0.creationDate!, format: "dd/MM/yyyy") >= startDateTextField.text! && Date.convertDate(date: $0.creationDate!, format: "dd/MM/yyyy") <= endDateTextField.text! }
        } else {
            return CoreDataManager.manager.notes
        }
    }
}

extension ListingViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
