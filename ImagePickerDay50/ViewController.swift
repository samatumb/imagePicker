//
//  ViewController.swift
//  ImagePickerDay50
//
//  Created by Samat on 01.08.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        //tableView.rowHeight = 100
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.caption
        
        return cell
    }

    
    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) { picker.sourceType = .camera }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Picture(imageName: imageName, caption: "Unknown")
                
        
        
        
        dismiss(animated: true) { [weak self] in
            let ac = UIAlertController(title: "Image Name", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                picture.caption = newName
                
                self?.pictures.append(picture)
                self?.save()
                self?.tableView.reloadData()
            }))
            
            self?.present(ac, animated: true)
        }
        
    }
    
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save people")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            let path = getDocumentDirectory().appendingPathComponent(picture.imageName)
            vc.selectedImage = path.path
            vc.title = "\(pictures[indexPath.row].caption)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

