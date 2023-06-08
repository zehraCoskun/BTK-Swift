//
//  DetailViewController.swift
//  AlisverisListesi
//
//  Created by Zehra Coşkun on 27.04.2023.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isimTextField: UITextField!
    @IBOutlet weak var fiyatTextField: UITextField!
    @IBOutlet weak var bedenTextField: UITextField!
    @IBOutlet weak var kaydetButton: UIButton!
    
    var secilinUrunIsim = ""
    var secilenUrunUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ürüne tıkladığında ürün detayı ertıya tıkladığında ekleme ekranı çıkması kontrolü
        if secilinUrunIsim != "" {
            
            kaydetButton.isHidden = true
            
            if let uuidString = secilenUrunUUID?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Urun")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let sonuclar = try context.fetch(fetchRequest)
                    if sonuclar.count > 0 {
                        for sonuc in sonuclar as! [NSManagedObject] {
                            
                            if let isim = sonuc.value(forKey: "isim") as? String {
                                isimTextField.text = isim
                            }
                            if let beden = sonuc.value(forKey: "beden") as? String {
                                bedenTextField.text = beden
                            }
                            if let fiyat = sonuc.value(forKey: "fiyat") as? Int {
                                fiyatTextField.text = String(fiyat)
                            }
                            if let gorselData = sonuc.value(forKey: "gorsel") as? Data {
                                let image = UIImage(data: gorselData)
                                imageView.image = image
                            }
                        }
                    }
                } catch {
                    print("hata")
                }
            }
        }
        else {
            kaydetButton.isHidden = false
            kaydetButton.isEnabled = false
            isimTextField.text = ""
            fiyatTextField.text = ""
            bedenTextField.text = ""
        }
        
        
        //bir yere tıklayınca klavyeyi kapatma
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        //görsele tıklayınca albümü açma
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    
    
    @objc func klavyeyiKapat() {
        view.endEditing(true)
    }
    
    @objc func gorselSec() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //seçilen göreseli imageView'e ekleme ve sonra görsel seçme sayfasını kapatma
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        kaydetButton.isEnabled = true
        self.dismiss(animated: true)
    }

   
    @IBAction func kaydetButonuBasildi(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let urun = NSEntityDescription.insertNewObject(forEntityName: "Urun", into: context)
        
        urun.setValue(UUID(), forKey: "id")
        urun.setValue(isimTextField.text!, forKey: "isim")
        urun.setValue(bedenTextField.text!, forKey: "beden")
        if let fiyat =  Int(fiyatTextField.text!) {
            urun.setValue(fiyat, forKey: "fiyat")}
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        urun.setValue(data, forKey: "gorsel")
         
        do {
            try context.save()
            print("kaydedildi")
        } catch {print("hata var")}
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "veriGirildi"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
