//
//  HomeViewController.swift
//  PracticeImageSlides
//
//  Created by Moe Steinmueller on 12.06.22.
//

import UIKit
import ImageSlides


class HomeViewController: UIViewController {
    var filmDataManager: NetWorkingProtocol!
    private var images = [String]()
    
    var imageSlides: ImageSlidesView = {
        var slidesView = ImageSlidesView(slidesWidth: 350, slidesHeight: 600)
        slidesView.translatesAutoresizingMaskIntoConstraints = false
        return slidesView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        filmDataManager.fetchGenericData(urlString: "https://ghibliapi.herokuapp.com/films", type: [Film].self) { [weak self] result in
            switch result {
            case .success(let films):
                self?.images = films.map{$0.image}
                
                DispatchQueue.main.async { [weak self] in
                    self?.imageSlides.setImages(images: films.map{$0.image})
//                    self?.imageSlides.setNumberLabelBelow()
                    self?.imageSlides.setNumberLabelInside()
                }
                
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.showError()
                }
            }
        }
        
        view.backgroundColor = .systemGray
        view.addSubview(imageSlides)
        
        setUpConstraints()
        
    }
    
    init(filmDataManager: NetWorkingProtocol) {
        self.filmDataManager = filmDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageSlides.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSlides.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageSlides.widthAnchor.constraint(equalToConstant: 350),
            imageSlides.heightAnchor.constraint(equalToConstant: 600),
        ])
    }
    
    private func showError() {
//        write error code
    }

}

