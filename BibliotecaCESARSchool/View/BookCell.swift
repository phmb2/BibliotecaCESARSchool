//
//  BookCell.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 26/03/21.
//

import UIKit
import Nuke

class BookCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var pixelSize: CGSize {
        CGSize(width: imageView.frame.width * UIScreen.main.scale, height: imageView.frame.height * UIScreen.main.scale)
    }

    var resizedImageProcessors: [ImageProcessing] {
        [ImageProcessors.Resize(size: pixelSize, contentMode: .aspectFill)]
    }

}
