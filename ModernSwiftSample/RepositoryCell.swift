//
//  RepositoryCell.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/09/01.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import AlamofireImage

class RepositoryCell : UITableViewCell {
    
    var disposeBag: DisposeBag!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var avaterImageView: UIImageView!
    
    var repository: Repository! {
        didSet {
            let disposeBag = DisposeBag()
            
            titleLabel.text = repository.name
            if let avatarUrl = repository.avatarUrl,
                let url = NSURL(string: avatarUrl) {
                avaterImageView.af_setImageWithURL(url)
            }
            
            self.disposeBag = disposeBag
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = nil
    }
    
    deinit {
        print("RepositoryCell deinit")
    }
}