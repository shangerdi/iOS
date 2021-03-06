//
//  PaymentChannelCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class PaymentChannelCell: UITableViewCell {

    // MARK: - Property
    /// 支付方式
    var channel: MalaPaymentChannel = .Other
    /// 支付方式模型
    var model: PaymentChannel? {
        didSet {
            iconView.image = UIImage(named: (model?.imageName) ?? "")
            titleLabel.text = model?.title
            subTitleLabel.text = model?.subTitle
            channel = model?.channel ?? .Alipay
        }
    }
    override var isSelected: Bool {
        didSet {
            selectButton.isSelected = isSelected
        }
    }
    
    // MARK: - Components
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        return iconView
    }()
    /// 支付方式名称
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor(named: .ArticleTitle)
        return titleLabel
    }()
    /// 支付方式描述
    private lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        subTitleLabel.textColor = UIColor(named: .ArticleSubTitle)
        return subTitleLabel
    }()
    /// 选择按钮
    private lazy var selectButton: UIButton = {
        let selectButton = UIButton()
        selectButton.setBackgroundImage(UIImage(asset: .unselected), for: UIControlState())
        selectButton.setBackgroundImage(UIImage(asset: .selected), for: .selected)
        // 冻结按钮交互功能，其只作为视觉显示效果使用
        selectButton.isUserInteractionEnabled = false
        return selectButton
    }()
    /// 分割线
    lazy var separatorLine: UIView = {
        let separatorLine = UIView(UIColor(named: .SeparatorLine))
        return separatorLine
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // SubViews
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(selectButton)
        contentView.addSubview(separatorLine)
        
        // Autolayout
        iconView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(16)
            maker.left.equalTo(contentView).offset(12)
            maker.bottom.equalTo(contentView).offset(-16)
            maker.width.equalTo(iconView.snp.height)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(14)
            maker.top.equalTo(iconView)
            maker.left.equalTo(iconView.snp.right).offset(12)
        }
        subTitleLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(titleLabel)
            maker.bottom.equalTo(iconView)
            maker.height.equalTo(13)
        }
        selectButton.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(contentView)
            maker.right.equalTo(contentView).offset(-12)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.height.equalTo(MalaScreenOnePixel)
        }
    }
    
    func hideSeparator() {
        separatorLine.isHidden = true
    }
}
