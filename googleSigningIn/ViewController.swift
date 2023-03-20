//
//  ViewController.swift
//  googleSigningIn
//
//  Created by Andrey Rybalkin on 20.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let imageProcessor = ImageProcessor()
    var colorsArray: [UIColor]? = [UIColor]() {
        didSet {
            configureColors(with: colorsArray)
        }
    }
    
    var pickedImage: UIImage? {
        didSet {
            colorsArray = imageProcessor.averageColors(of: pickedImage)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var pickerButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("ADD PHOTO", for: .normal)
        bt.backgroundColor = UIColor.systemCyan
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        return bt
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        picker.sourceType = .photoLibrary
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        
        view.addSubview(pickerButton)
        
        pickerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        pickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        pickerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        pickerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.backgroundColor = .white
        
        configureCollection()
        // Do any additional setup after loading the view.
    }
    

                
    // MARK: -
        
    private func configureCollection() {
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
//        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PixelCell")
    }
    
    func configureColors(with pixels: [UIColor]?) {
        guard let pixels else { return }
        DispatchQueue.main.async {
            for (index, color) in pixels.enumerated() {
                if let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                    cell.contentView.backgroundColor = color
                }
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
            
            let spacing: CGFloat = 1
            let res: CGFloat = 16
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / res),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1 / res))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: 0, leading: 7, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        return compositionalLayout
    }
    
    @objc func showPicker() {
        present(imagePicker, animated: true, completion: nil)
    }

        
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 256
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixelCell", for: indexPath)
        cell.contentView.backgroundColor = .black
        return cell
    }
}


extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        self.pickedImage = image
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
