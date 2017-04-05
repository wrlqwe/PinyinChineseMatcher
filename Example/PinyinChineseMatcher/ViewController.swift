//
//  ViewController.swift
//  PinyinChineseMatcher
//
//  Created by wrlqwe on 03/29/2017.
//  Copyright (c) 2017 wrlqwe. All rights reserved.
//

import UIKit
import PinyinChineseMatcher

class ViewController: UIViewController {
    @IBOutlet weak var chineseTextView: UITextView!
    @IBOutlet weak var pinyinTextField: UITextField!
    @IBOutlet weak var tipsLabel: UILabel!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chineseTextView.delegate = self
        pinyinTextField.delegate = self
        process("")
        NotificationCenter.default.addObserver(self, selector: #selector(process(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func process(_ sender: Any) {
        guard let chineseText = chineseTextView.text else {
            return
        }
        guard let pinyin = pinyinTextField.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: chineseText)
        let ranges = PinyinChineseMatcher.match(chineseToMatch: chineseText, pinyinToMatch: pinyin)
        ranges.forEach { range in
            attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: range)
        }

        tipsLabel.attributedText = attributedString
    }

}

//汉语输入
extension ViewController: UITextViewDelegate {

}
//拼音输入
extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        process(textField)
        return true
    }
    
}

