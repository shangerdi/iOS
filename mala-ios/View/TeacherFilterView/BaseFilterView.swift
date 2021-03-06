//
//  BaseFilterView.swift
//  mala-ios
//
//  Created by Elors on 1/16/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

internal let FilterViewCellReusedId = "FilterViewCellReusedId"
internal let FilterViewSectionHeaderReusedId = "FilterViewSectionHeaderReusedId"
internal let FilterViewSectionFooterReusedId = "FilterViewSectionFooterReusedId"
/// 结果返回值闭包
typealias FilterDidTapCallBack = (_ model: GradeModel?)->()

class BaseFilterView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Property
    /// 年级及科目数据模型
    var grades: [GradeModel]? = nil
    /// Cell点击回调闭包
    var didTapCallBack: FilterDidTapCallBack?
    /// 当前选中项下标标记
    var selectedIndexPath: IndexPath? 
    
    
    // MARK: - Constructed
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, didTapCallBack: @escaping FilterDidTapCallBack) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.didTapCallBack = didTapCallBack
        configration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Deleagte
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let currentIndexPath = selectedIndexPath {
            collectionView.cellForItem(at: currentIndexPath)?.isSelected = false
        }
        cell?.isSelected = true
        self.selectedIndexPath = indexPath
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 默认情况为 小学, 初中, 高中 三项
        return self.grades?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gradeModel(section)?.subset?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView?
        // Section 头部视图
        if kind == UICollectionElementKindSectionHeader {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: FilterViewSectionHeaderReusedId,
                for: indexPath
                ) as! FilterSectionHeaderView
            sectionHeaderView.sectionTitleText = gradeModel(indexPath.section)?.name ?? "年级"
            reusableView = sectionHeaderView
        }
        // Section 尾部视图
        if kind == UICollectionElementKindSectionFooter {
            let sectionFooterView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionFooter,
                withReuseIdentifier: FilterViewSectionFooterReusedId,
                for: indexPath
            )
            reusableView = sectionFooterView
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewCellReusedId, for: indexPath) as! FilterViewCell
        cell.model = gradeModel(indexPath.section, row: indexPath.row)!
        cell.indexPath = indexPath
        return cell
    }
    
    
    // MARK: - Private Method
    private func configration() {
        delegate = self
        dataSource = self
        register(FilterViewCell.self,
            forCellWithReuseIdentifier: FilterViewCellReusedId)
        register(FilterSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: FilterViewSectionHeaderReusedId)
        register(UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: FilterViewSectionFooterReusedId)
        self.backgroundColor = UIColor.white
    }
    
    /// 便利方法——通过 Section 或 Row 获取对应数据模型
    internal func gradeModel(_ section: Int, row: Int? = nil) -> GradeModel? {
        if row == nil {
            return self.grades?[section]
        }else {
            return self.grades?[section].subset?[row!]
        }
    }
}


// MARK: - FilterSectionHeaderView
class FilterSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Property
    /// Section标题
    var sectionTitleText: String = L10n.title {
        didSet {
            titleLabel.text = sectionTitleText
            switch sectionTitleText {
            case "小学":
                iconView.image = UIImage(asset: .primarySchool)
            case "初中":
                iconView.image = UIImage(asset: .juniorHigh)
            case "高中":
                iconView.image = UIImage(asset: .seniorHigh)
            default:
                break
            }
        }
    }
    
    
    // MARK: - Components
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(imageName: "primarySchool")
        return iconView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(
            text: "小学",
            fontSize: 13,
            textColor: UIColor(named: .HeaderTitle),
            textAlignment: .center
        )
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    
    // MARK: - Contructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        addSubview(iconView)
        addSubview(titleLabel)
        
        // AutoLayout
        iconView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self).offset(4)
            maker.left.equalTo(self)
            maker.width.equalTo(20)
            maker.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(iconView)
            maker.left.equalTo(iconView.snp.right).offset(9)
        }
    }
}
