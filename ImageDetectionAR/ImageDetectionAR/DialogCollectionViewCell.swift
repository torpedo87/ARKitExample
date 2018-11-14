//
//  DialogCollectionViewCell.swift
//  ImageDetectionAR
//
//  Created by junwoo on 14/11/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit

class DialogCollectionViewCell: UICollectionViewCell {
  
  var delegate: DialogCollectionViewCellDelegate?
  var index = 0
  
  @IBOutlet weak var screenImageButton: UIButton!
  
  @IBOutlet weak var screenLabel: UILabel!
  
  
  @IBAction func screenImageButtonTapped(_ sender: UIButton) {
    delegate?.screenImageButtonTapped(index: index)
  }
}

protocol DialogCollectionViewCellDelegate {
  func screenImageButtonTapped(index: Int)
}
