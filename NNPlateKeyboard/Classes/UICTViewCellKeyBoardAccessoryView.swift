//
//  UICTViewCellKeyBoardAccessoryView.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/10.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit

/// 键盘上方悬浮框 UICollectionViewCell 子视图
class UICTViewCellKeyBoardAccessoryView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        textLabel.frame = self.contentView.bounds;
    }
    
    // MARK: - lazy
    public lazy var textLabel: UILabel = {
        let view = UILabel(frame: .zero);
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.text = "-"
        
        view.font = UIFont.systemFont(ofSize: UIFont.labelFontSize);
        view.numberOfLines = 1;
        view.textAlignment = .center;
        return view
    }()

}
