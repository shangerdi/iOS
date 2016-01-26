//
//  ThemeClassSchedule.swift
//  ThemeClassSchedule
//
//  Created by 王新宇 on 1/25/16.
//  Copyright © 2016 Elors. All rights reserved.
//

import UIKit

private let ThemeClassScheduleCellReuseId = "ThemeClassScheduleCellReuseId"
private let ThemeClassScheduleSectionTitles = ["时间", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]


class ThemeClassSchedule: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    var model: [[ClassScheduleDayModel]]? {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: - Instance Method
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configura()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configura() {
        delegate = self
        dataSource = self
        backgroundColor = UIColor.whiteColor()
        
        registerClass(ThemeClassScheduleCell.self, forCellWithReuseIdentifier: ThemeClassScheduleCellReuseId)
    }
    
    
    // MARK: - DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ThemeClassScheduleCellReuseId, forIndexPath: indexPath) as! ThemeClassScheduleCell
        
        // 设置Cell样式
        cell.contentView.layer.borderColor = MalaLoginVerifyButtonNormalColor.CGColor
        cell.contentView.layer.borderWidth = MalaScreenOnePixel
        cell.button.selected = false
        
        // 在Cell中标注IndexPath
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.sizeToFit()
        label.center = cell.contentView.center
        cell.contentView.addSubview(label)
        
        // 设置Cell列头标题
        if indexPath.section == 0 {
            label.text = ThemeClassScheduleSectionTitles[indexPath.row]
            label.textColor = UIColor.whiteColor()
            label.sizeToFit()
            label.center = cell.contentView.center
            cell.button.highlighted = true
        }
        
        // 设置Cell行头标题
        if indexPath.row == 0 && indexPath.section > 0 && (model ?? []) != [] {
            
            label.removeFromSuperview()
            
            // 行头数据源
            let rowTitleModel = model?[0][indexPath.section-1]
            
            let firstLabel = UILabel()
            firstLabel.text = rowTitleModel?.start
            firstLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height/2)
            firstLabel.font = UIFont.systemFontOfSize(12)
            firstLabel.sizeToFit()
            firstLabel.frame.origin.x = (cell.frame.width - firstLabel.frame.width)/2
            firstLabel.frame.origin.y = cell.frame.height/2 - firstLabel.frame.height
            firstLabel.textColor = MalaDetailsCellSubTitleColor
            
            let secondLabel = UILabel()
            secondLabel.text = rowTitleModel?.end
            secondLabel.frame = CGRect(x: 0, y: cell.frame.height/2, width: cell.frame.width, height: cell.frame.height/2)
            secondLabel.font = UIFont.systemFontOfSize(12)
            secondLabel.sizeToFit()
            secondLabel.frame.origin.x = (cell.frame.width - secondLabel.frame.width)/2
            secondLabel.textColor = MalaDetailsCellSubTitleColor
            
            cell.contentView.addSubview(firstLabel)
            cell.contentView.addSubview(secondLabel)
        }
        
        // 根据数据源设置显示样式
        if indexPath.section > 0 && indexPath.row > 0 && (model ?? []) != [] {
            label.removeFromSuperview()
            
            let itemModel = model?[indexPath.row-1][indexPath.section-1]
            cell.button.enabled = itemModel?.available ?? false
        }
        
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ThemeClassScheduleCell
        cell.button.selected = !cell.button.selected
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        // 不可点击表头、行头
        if indexPath.section > 0 && indexPath.row > 0 {
            let itemModel = model?[indexPath.row-1][indexPath.section-1]
            print("should Select \(itemModel?.available)")
            return itemModel?.available ?? false
        }
        return false
    }
}


class ThemeClassScheduleCell: UICollectionViewCell {
    
    // MARK: - Compontents
    lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.withColor(UIColor.whiteColor()), forState: .Normal)
        button.setBackgroundImage(UIImage.withColor(MalaTeacherCellBackgroundColor), forState: .Disabled)
        button.setBackgroundImage(UIImage.withColor(MalaClassScheduleSelectedColor), forState: .Selected)
        button.setBackgroundImage(UIImage.withColor(MalaLoginVerifyButtonNormalColor), forState: .Highlighted)
        button.userInteractionEnabled = false
        return button
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        contentView.addSubview(button)
        
        button.frame.size = contentView.frame.size
        button.center = contentView.center
    }
}




class ThemeClassScheduleFlowLayout: UICollectionViewFlowLayout {
    
    private var frame = CGRectZero
    
    // MARK: - Instance Method
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        
        configura()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    private func configura() {
        scrollDirection = .Vertical
        let itemWidth: CGFloat = frame.width / 8
        let itemHeight: CGFloat = frame.height / 6
        itemSize = CGSizeMake(itemWidth, itemHeight)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}