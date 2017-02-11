//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Wilmer Arteaga on 5/02/17.
//  Copyright © 2017 killerwilmer. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumgImg: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    var itemTypes = [ItemType]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove title in back button
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // set picker
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Run once for save data in database
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Frys Electronics"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "K Mart"
        
        // with this we save the data
        //ad.saveContext()
        
        //generateDataItemType()
        
        getStores()
        getItemTypes()
        
        if itemToEdit != nil {
            
            loadItemData()
        }
    }
    
    // Init functions picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let store = stores[row]
//        return store.name
        if component == 0 {
            let storesRow = stores[row]
            return storesRow.name
        }
        let typesRow = itemTypes[row]
        return typesRow.type
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        }
        return itemTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }
    // End functions picker
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    func getItemTypes() {
        
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
        }
    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumgImg.image
        
        
        if itemToEdit == nil {
            
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        if picture.image != nil {
            item.toImage = picture
        }
        
        
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let detaisl = detailsField.text {
            item.details = detaisl
        }
        
        // save the id_store selected in relationship
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        // save the id_itemType selected in relationship
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        // save item in database
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details            
            thumgImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
            
            if let itemType = item.toItemType {
                
                var index = 0
                repeat {
                    
                    let s = itemTypes[index]
                    if s.type == itemType.type {
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < itemTypes.count)
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: AnyObject) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImagePressed(_ sender: AnyObject) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumgImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func generateDataItemType() {
        let itemType = ItemType(context: context)
        itemType.type = "Electronics"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Cars"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Toys"
        
        ad.saveContext()
    }
    
    
}
