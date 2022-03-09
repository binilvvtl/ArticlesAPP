//
//  ArticleCollectionViewCell.swift
//  ArtilcesAPP
//
//  Created by Binil V on 07/03/22.
//

import UIKit
import AVFoundation
import SDWebImage

class ArticleCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var imageContiner: UIView!
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  static var reuseIdentifier: String {
    return String(describing: ArticleCollectionViewCell.self)
  }
    override func awakeFromNib() {
        super.awakeFromNib()
      self.layer.cornerRadius = 2.0
      thumbnailView.layer.borderWidth = 1.0
      imageContiner.layer.borderColor = UIColor.white.cgColor
      imageContiner.clipsToBounds = true
    }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailView.image = nil
  }
  
  // Updates UI based on the Value provided
  func configure(title: String?, image: String) {
    titleLabel.text = title ?? " "
    thumbnailView.sd_setImage(with: URL.init(string: image), completed: nil)
  }
}
