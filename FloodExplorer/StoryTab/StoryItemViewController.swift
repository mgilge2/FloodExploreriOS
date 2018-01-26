//
//  StoryItemViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/22/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit

class StoryItemViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    var selectedStoryItem: StoryItemDetails?
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var captionText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView.delegate = self as UIScrollViewDelegate;
            scrollView.minimumZoomScale = 0.03;
            scrollView.maximumZoomScale = 3.0;
           // scrollView.addSubview(imageView);
        }
    }
    
    private var image: UIImage?  // by declaring UIImage with a ? here we are saying that var is an Optional and it is ok for it to return nil
    {
        get
        {
            return imageView.image;
        }
        set
        {

            imageView.image = newValue; // set imageView image
            //imageView.frame = scrollView.frame
           // imageView.sizeToFit();
           // imageView.center = scrollView.center
            
            imageView.contentMode = .scaleAspectFit
            scrollView?.contentSize = imageView.frame.size; //question is because outlet wont be set at some points when this is called and it will crash
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = selectedStoryItem?.fileTitle
        captionText.text = selectedStoryItem?.fileCaption
        addImageToNavBar()
        addMenuButtonToNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        loadImageView()
        if image == nil
        {
            //loadImageView()
        }
        loadImageView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        loadImageView()
        imageView.setNeedsLayout()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadImageView()
    {
        spinner.startAnimating()
        imageView.moa.onSuccess = { image in
            //self.image = image
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.center = self.scrollView.center
           // self.scrollView.frame = self.imageView.frame
            self.scrollView?.contentSize = self.imageView.frame.size
            self.imageView.setNeedsLayout()
            self.scrollView.setNeedsLayout()
            return image
        }
        imageView.moa.url = AppSettings.URL_IMAGES_ORIGINAL + (selectedStoryItem?.fileName)!
    }
}

extension StoryItemViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView;
    }
}
