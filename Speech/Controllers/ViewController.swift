//
//  ViewController.swift
//  Speech
//
//  Created by Amy Lin on 9/11/18.
//  Copyright © 2018 Amy Lin. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var translations: [Translation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
   
        
        let skyline = UIImageView.init(frame:CGRect(x:0, y:view.frame.size.height - 160, width:view.frame.size.width, height:160))
        print(view.frame.size.width);
        skyline.image = UIImage(named: "MOOO.png")
        view.addSubview(skyline)
        //view.insertSubview(skyline, belowSubview: tableView)
        navigationController?.navigationBar.tintColor = UIColor(red:0.24, green:0.26, blue:0.38, alpha:1);
        
        navigationItem.title = "Flowlingo"
}
   
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.frame.size.width = view.frame.size.width;
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let identifier = "TranscriptionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier, for: indexPath) as! TranscriptionTableViewCell
        cell.frame.size.width = view.frame.size.width;
        
        
            let task = translations[indexPath.row]
            if let myName = task.name {
                cell.nameLabel?.text = myName
            }
        
        let v = UIView()
        v.backgroundColor = UIColor.white
        cell.selectedBackgroundView = v
       cell.backgroundColor = UIColor.clear
        
        return cell as UITableViewCell
    }
    
    func getData() {
        do {
            translations = try context.fetch(Translation.fetchRequest())

        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        
            header.textLabel?.text = "   Conversations";
        
        
        header.textLabel?.font = UIFont(name: "Prata-Regular", size: 18)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            return "Conversations";
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exposeSecrets",
            let indexPath = self.tableView?.indexPathForSelectedRow,
            let destinationViewController: DetailViewController = segue.destination as? DetailViewController {
            
                destinationViewController.translation = translations[indexPath.row];
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                if (indexPath.section == 0) {
                    let task = translations[indexPath.row]
                    context.delete(task)
                    
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                do {
                    translations = try context.fetch(Translation.fetchRequest())
                }
                catch {
                    print("Fetching Failed")
                }
            }
            tableView.reloadData()
}
}
}
