//
//  MovieCell.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit
import SDWebImage

final class MovieCell: UITableViewCell, AutoIndentifierCell {
    @IBOutlet private weak var titleL: UILabel?
    @IBOutlet private weak var overviewL: UILabel?
    @IBOutlet private weak var posterIV: UIImageView?
    
    private var noImage = UIImage(named: "no-image")?.withTintColor(.label, renderingMode: .alwaysOriginal)
    
    public func commonInit(_ movie: MovieObject) {
        titleL?.text = movie.title
        overviewL?.text = movie.overview
        posterIV?.image = noImage
        if let posterPath = movie.posterPath {
            posterIV?.sd_setImage(with: SettingsManager.environment.getPosterURL(for: posterPath), placeholderImage: noImage)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleL?.text = ""
        overviewL?.text = ""
        posterIV?.image = noImage
    }
}
