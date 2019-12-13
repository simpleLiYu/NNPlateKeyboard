//
//  UICTViewCellKeyBoard.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/6.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit

import SnapKit
import SwiftExpand

/// 车牌键盘按键 UICollectionViewCell 子视图
class UICTViewCellKeyBoard: UICollectionViewCell {
    
    var leftConstant: CGFloat = 0.0
    var isEnabledStatus: Bool = true{
        willSet{
            let isSure = (label.text == "确定")
            if isSure {
                label.textColor = .white
                backImgView.image = newValue ? UIImageColor(NNKeyboardView.themeColor) : UIImageColor(UIColor.lightGray)
                
            } else {
                label.textColor = newValue ? .black : UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1);
                backImgView.image = UIImage.image(named:"btn_normal", podClass: NNPlateKeyboard.self)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backImgView)
        contentView.addSubview(iconImgView)
        contentView.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize);
        label.text = "-"
        label.textAlignment = .center
//        label.backgroundColor = UIColor.random
//        backImgView.backgroundColor = UIColor.random
        
        backImgView.contentMode = .scaleToFill
//        backImgView.backgroundColor = UIColor.white

        backImgView.image = UIImage.image(named:"btn_normal", podClass: NNPlateKeyboard.self)
        backImgView.highlightedImage = UIImage.image(named:"btn_pressed", podClass: NNPlateKeyboard.self)
        
        label.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "selected", options: .new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            guard let value = change![NSKeyValueChangeKey.newKey] as? String else { return }
            switch value {
            case "删除":
                label.isHidden = true;
                backImgView.image = UIImage.image(named:"btn_normal", podClass: NNPlateKeyboard.self)
                backImgView.highlightedImage = UIImage.image(named:"btn_pressed", podClass: NNPlateKeyboard.self)
                iconImgView.image = UIImage.image(named:"delete", podClass: NNPlateKeyboard.self)
                iconImgView.highlightedImage = UIImage.image(named:"delete", podClass: NNPlateKeyboard.self)
                
            case "确定":
                label.isHidden = false;
                label.textColor = UIColor.white
                backImgView.image = UIImageColor(UIColor.theme);
                backImgView.layer.cornerRadius = 8;
                backImgView.layer.masksToBounds = true;
                iconImgView.image = nil
                iconImgView.highlightedImage = nil
                
            default:
                label.isHidden = false;
                label.textColor = .black
                backImgView.contentMode = .scaleToFill
                backImgView.image = UIImage.image(named:"btn_normal", podClass: NNPlateKeyboard.self)
                backImgView.highlightedImage = UIImage.image(named:"btn_pressed", podClass: NNPlateKeyboard.self)
                iconImgView.image = nil
                iconImgView.highlightedImage = nil
            }
        } else if keyPath == "selected" {
//            guard let value = change![NSKeyValueChangeKey.newKey] as? Bool else { return }
//            label.textColor = value ? UIColor.white : UIColor.black;
//            label.textColor = value ? UIColor.black : UIColor.black;

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
         let isSure = (label.text == "确定")
         if isSure {
            backImgView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(1)
                make.left.equalToSuperview().offset(leftConstant+1)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-3)
            }

         } else {
            backImgView.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(leftConstant)
                make.right.equalToSuperview()
            }
         }
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(backImgView)
            make.bottom.equalToSuperview().offset(-kPadding)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(backImgView)
            make.bottom.equalToSuperview().offset(-kPadding)
        }
    }
    
    // MARK: - lazy
    lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view;
    }()
    
    lazy var backImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view;
    }()
    
  
    
}
