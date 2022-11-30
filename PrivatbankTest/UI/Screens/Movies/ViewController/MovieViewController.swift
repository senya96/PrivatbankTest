//
//  MovieViewController.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 26.11.2022.
//

import UIKit

final class MovieViewController: BaseViewController {
    
    public var viewModel: MovieViewModel?
    
    @IBOutlet private weak var posterIV: UIImageView?
    @IBOutlet private weak var ratingL: UILabel?
    @IBOutlet private weak var overviewL: UILabel?
    @IBOutlet private weak var releaseDateL: UILabel?
    @IBOutlet private weak var popularityL: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        bindViewModel()
    }
}

private extension MovieViewController {
    func bindViewModel() {
        viewModel?.movie.bind { [weak self] _ in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        title = viewModel?.movie.value?.title
        let noImage = UIImage(named: "no-image")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        posterIV?.image = noImage
        if let posterPath = viewModel?.movie.value?.posterPath {
            posterIV?.sd_setImage(with: SettingsManager.environment.getPosterURL(for: posterPath), placeholderImage: noImage)
        }
        popularityL?.text = "Popularity: \(viewModel?.movie.value?.popularity ?? 0.0)"
        ratingL?.text = "Rating: \(viewModel?.movie.value?.voteAverage ?? 0.0)"
        overviewL?.text = viewModel?.movie.value?.overview
        releaseDateL?.text = "Release date: \(viewModel?.movie.value?.releaseDate ?? "")"
    }
}

extension MovieViewController: StoryboardInstantiable {
    static var storyboardName: String {
        Storyboard.movies.rawValue
    }
}
