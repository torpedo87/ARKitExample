//
//  DialogViewController.swift
//  ImageDetectionAR
//
//  Created by junwoo on 14/11/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {
  
  var delegate: DialogViewControllerDelegate?
  @IBOutlet weak var screenCollectionView: UICollectionView!
  let screens = ["iPhoneX1", "iPhoneX2", "iPhoneX3"]
  let titles = ["wallPaper", "home", "chapters"]
  let images = ["ARScreen1", "ARScreen2", "ARScreen3"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    screenCollectionView.delegate = self
    screenCollectionView.dataSource = self
  }
  
}

extension DialogViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell",
                                                  for: indexPath) as! DialogCollectionViewCell
    cell.screenImageButton.setImage(UIImage(named: screens[indexPath.row]),
                                    for: .normal)
    cell.screenLabel.text = titles[indexPath.row]
    cell.delegate = self
    cell.index = indexPath.row
    return cell
  }
  
  
}

extension DialogViewController: UICollectionViewDelegate {
  
}

extension DialogViewController: DialogCollectionViewCellDelegate {
  func screenImageButtonTapped(index: Int) {
    dismiss(animated: true, completion: nil)
    delegate?.screenImageButtonTapped(image: UIImage(named: images[index])!)
  }
}

protocol DialogViewControllerDelegate {
  func screenImageButtonTapped(image: UIImage)
}
