//
//  ListViewController.swift
//  HaritaUygulamasi
//
//  Created by Zehra Coşkun on 9.05.2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var isimDizisi = [String]()
    var idDizisi = [UUID]()
    var secilenIsimx = ""
    var secilenIdx = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(artiButonuTiklandi))

        veriAl()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(veriAl), name: NSNotification.Name("yeniYerOlusturuldu"), object: nil)
    }
    @objc func artiButonuTiklandi() {
        secilenIsimx = ""
        performSegue(withIdentifier: "toMapsView", sender: nil)
    }
    
    @objc func veriAl() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
        request.returnsObjectsAsFaults = false
        
        isimDizisi.removeAll()
        idDizisi.removeAll()
        
        do {
            let sonuclar = try context.fetch(request)
            if sonuclar.count > 0 {
                for result in sonuclar as! [NSManagedObject] {
                    if let isim = result.value(forKey: "isim") as? String {
                        isimDizisi.append(isim)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idDizisi.append(id)
                    }
                }
                tableView.reloadData()
            }
        } catch { print("veri alma hatası")}
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenIsimx = isimDizisi[indexPath.row]
        secilenIdx = idDizisi[indexPath.row]
        performSegue(withIdentifier: "toMapsView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapsView" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.secilenId = secilenIdx
            destinationVC.secilenIsim = secilenIsimx
        }
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizisi[indexPath.row]
        return cell
    }
 

}
