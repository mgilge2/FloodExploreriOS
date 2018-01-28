//
//  HomeViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/22/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import Auk

class HomeViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadImageCarousel()
        setUpTextView()
        addImageToNavBar()
        addMenuButtonToNavBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setUpTextView()
    {
        textView.text = OmekaCollection.shared().omekaHomeText
        let imageView = UIImageView(frame: textView.bounds)
        let image = UIImage(named: "mammothtransparent")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
      
        textView.backgroundColor = UIColor.clear
        textView.addSubview(imageView)
        textView.sendSubview(toBack: imageView)
    }
    
    private func loadImageCarousel()
    {
        if let image = UIImage(named: "home1")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home2")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home3")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home4")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home5")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home6")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home7")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home8")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home9")
        {
            scrollView.auk.show(image: image)
        }
        if let image = UIImage(named: "home10")
        {
            scrollView.auk.show(image: image)
        }
        scrollView.auk.startAutoScroll(delaySeconds: 3)
    }
}

extension UIColor
{
    convenience init(hexString: String, alpha: CGFloat = 1.0)
    {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#"))
        {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
