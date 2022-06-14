//
//  ImageSlidesView.swift
//  ImageSlidesView
//
//  Created by Moe Steinmueller on 13.06.22.
//

import Foundation
import UIKit
import SDWebImage


public class ImageSlidesView: UIView, UIScrollViewDelegate {

    var slidesWidth: CGFloat
    var slidesHeight: CGFloat
    
    let scrollView = UIScrollView()
    var viewFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl : UIPageControl = UIPageControl()
    
    var totalImages: Int?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private let belowNumberLabel: NumberLabel = {
        let label = NumberLabel(bgColor: UIColor.white.withAlphaComponent(0.4).cgColor,
                                colorForText: UIColor.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var insideNumberLabel: NumberLabel = {
        let label = NumberLabel(bgColor: UIColor.black.withAlphaComponent(0.5).cgColor,
                                colorForText: UIColor.white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(slidesWidth: CGFloat, slidesHeight: CGFloat, frame: CGRect = .zero) {
        self.slidesHeight = slidesHeight
        self.slidesWidth = slidesWidth
        super.init(frame: frame)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        setUpUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        if let totalImages = totalImages {
            belowNumberLabel.text = "\(String(Int(pageNumber + 1))) / \(totalImages)"
            insideNumberLabel.text = "\(String(Int(pageNumber + 1))) / \(totalImages)"
        }
        
    }
    
    open func setImages(images: [String]) {
        totalImages = images.count
        scrollView.frame = CGRect(x:0, y:0, width: slidesWidth, height: slidesHeight)
        self.pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            
            viewFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            viewFrame.size = self.scrollView.frame.size
            
            let subView = UIImageView(frame: viewFrame)
            subView.sd_setImage(with: URL(string: images[index]),
                                placeholderImage: UIImage(systemName: "photo"),
                                options: .continueInBackground,
                                completed: nil)

            self.scrollView.addSubview(subView)
            
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
            pageControl.addTarget(self, action: #selector(changePage(sender:)), for: UIControl.Event.valueChanged)
        }
        containerView.addSubview(scrollView)
    }
    
    // MARK: - setNumberLabelBelow
    
    open func setNumberLabelBelow() {
        setNumLabelBelowConstraints()
    }
    
    open func setNumberLabelBelow(bgColor: UIColor?, fontColor: UIColor?, fontName: String?) {
        if let bgColor = bgColor {
            belowNumberLabel.layer.backgroundColor = bgColor.cgColor
        }
        
        if let fontColor = fontColor {
            belowNumberLabel.textColor = fontColor
        }
        
        if let fontName = fontName {
            belowNumberLabel.font = UIFont(name: fontName, size: 12)
        }
        
        setNumLabelBelowConstraints()
    }
    
    private func setNumLabelBelowConstraints() {
        addSubview(belowNumberLabel)
        NSLayoutConstraint.activate([
            belowNumberLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            belowNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            belowNumberLabel.widthAnchor.constraint(equalToConstant: 100),
            belowNumberLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        if let totalImages = totalImages {
            belowNumberLabel.text = "1 / \(totalImages)"
        }
    }

    // MARK: - setNumberLabelInside

    
    open func setNumberLabelInside() {
        setNumLabelInsideConstraints()
    }
    
    open func setNumberLabelInside(bgColor: UIColor?, fontColor: UIColor?, fontName: String?) {
        if let bgColor = bgColor {
            insideNumberLabel.layer.backgroundColor = bgColor.cgColor
        }
        
        if let fontColor = fontColor {
            insideNumberLabel.textColor = fontColor
        }
        
        if let fontName = fontName {
            insideNumberLabel.font = UIFont(name: fontName, size: 12)
        }
        
        setNumLabelInsideConstraints()
    }
    
    private func setNumLabelInsideConstraints() {
        addSubview(insideNumberLabel)
        NSLayoutConstraint.activate([
            insideNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            insideNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            insideNumberLabel.widthAnchor.constraint(equalToConstant: 80),
            insideNumberLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        if let totalImages = totalImages {
            insideNumberLabel.text = "1 / \(totalImages)"
        }
    }

}
