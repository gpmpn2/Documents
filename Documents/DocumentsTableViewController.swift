//
//  DocumentsTableViewController.swift
//  Documents
//
//  Created by Grant Maloney on 8/26/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class DocumentsTableViewController: UITableViewController {
    
    var notes = [Note]()
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let formatter = DateFormatter()
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNotepad", sender: nil)
    }
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = loadNotes()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notes = loadNotes()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if let cell = cell as? CustomTableViewCell {
            
            let note = notes[indexPath.row]
            
            cell.noteTitle.text = note.noteTitle
            cell.noteSize.text = note.noteSize
            cell.dateModified.text = note.dateModified
        }

        return cell
    }
    
    func loadNotes() -> [Note] {
        var foundNotes = [Note]()
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for url in fileURLs {
                let fileName = documentsURL.appendingPathComponent(url.lastPathComponent)
                do {
                    let data = try Data(contentsOf: fileName, options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let document = try decoder.decode(Document.self, from: data)

                    if let date = url.modificationDate {
                        let formattedDate = formatter.string(from: date)
                        foundNotes.append(Note(noteTitle: document.noteTitle, noteSize: "Size: \(url.fileSize) bytes", dateModified: "Modified: \(formattedDate)", noteContents: document.noteContents))
                    }
                    
                } catch let err {
                    print("Error decoding information", err)
                }
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        return foundNotes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NotePadViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                destination.viewingNote = self.notes[selectedRow]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToNotepad", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try FileManager.default.removeItem(at: documentsURL.appendingPathComponent("\(notes[indexPath.row].noteTitle).json"))
            } catch let err {
                print("Error deleting file", err)
            }
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
