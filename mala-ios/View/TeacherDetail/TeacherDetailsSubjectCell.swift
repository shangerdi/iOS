//
//  TeacherDetailsSubjectCell.swift
//  mala-ios
//
//  Created by Elors on 1/5/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class TeacherDetailsSubjectCell: MalaBaseCell {

    // MARK: - Property
    /// 授课年级字符串数据
    var gradeStrings: [String] = [] {
        didSet {
            
            if gradeStrings != oldValue {
                
                var elementarySchools = [String](repeating: "", count: 6)
                var juniorSchools = [String](repeating: "", count: 3)
                var seniorSchools = [String](repeating: "", count: 3)
                
                
                for gradeName in gradeStrings {
                    
                    // 过滤无用数据
                    if gradeName == "小学" || gradeName == "初中" || gradeName == "高中" {
                        continue
                    }
                    
                    // 用年级名称获取对应下标
                    guard let index = MalaConfig.malaGradeShortName()[gradeName] else {
                        return
                    }
                    
                    // 截取首个字符
                    let firstCharacter = gradeName.substring(to: gradeName.characters.index(gradeName.startIndex, offsetBy: 1))
                    
                    // 根据字符分隔显示
                    if firstCharacter == "高" {
                        seniorSchools[index] = gradeName
                    }else if firstCharacter == "初" {
                        juniorSchools[index] = gradeName
                    }else {
                        elementarySchools[index] = gradeName
                    }
                }
                
                // 添加label
                self.setupTags(elementarySchool, strings: &elementarySchools)
                height = (MalaScreenWidth <= 375 && elementarySchools.count > 4) ? 55 : 25
                elementarySchool.snp.updateConstraints { (maker) in
                    maker.height.equalTo(height)
                }
                
                self.setupTags(juniorSchool, strings: &juniorSchools)
                self.setupTags(seniorSchool, strings: &seniorSchools)
            }
        }
    }
    
    // MARK: - Components
    /// 小学
    private lazy var elementarySchool: ThemeTagListView = {
        let tagsView = ThemeTagListView()
        tagsView.imageName = "detail_class1"
        tagsView.labelBackgroundColor = UIColor(named: .SubjectLightRed)
        tagsView.textColor = UIColor(named: .SubjectRed)
        return tagsView
    }()
    /// 初中
    private lazy var juniorSchool: ThemeTagListView = {
        let tagsView = ThemeTagListView()
        tagsView.imageName = "detail_class2"
        tagsView.labelBackgroundColor = UIColor(named: .SubjectTagBlue)
        tagsView.textColor = UIColor(named: .SubjectBlue)
        return tagsView
    }()
    /// 高中
    private lazy var seniorSchool: ThemeTagListView = {
        let tagsView = ThemeTagListView()
        tagsView.imageName = "detail_class3"
        tagsView.labelBackgroundColor = UIColor(named: .SubjectLightGreen)
        tagsView.textColor = UIColor(named: .SubjectGreen)
        return tagsView
    }()
    private var height = 25
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        
        // SubViews
        content.addSubview(elementarySchool)
        content.addSubview(juniorSchool)
        content.addSubview(seniorSchool)
        
        // Autolayout
        elementarySchool.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.height.equalTo(25)
            maker.bottom.equalTo(juniorSchool.snp.top).offset(-12)
        }
        juniorSchool.snp.makeConstraints { (maker) in
            maker.top.equalTo(elementarySchool.snp.bottom).offset(12)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.height.equalTo(25)
            maker.bottom.equalTo(seniorSchool.snp.top).offset(-12)
        }
        seniorSchool.snp.makeConstraints { (maker) in
            maker.top.equalTo(juniorSchool.snp.bottom).offset(12)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.height.equalTo(25)
            maker.bottom.equalTo(content)
        }
    }
    
    private func setupTags(_ tagsView: ThemeTagListView, strings: inout [String]) {
        
        // 判断转入数组的所有元素是否都为空字符串
        // 是，将移除对应控件。
        // 否，将添加字符串到对应控件中
        var isEmpty = ""
        
        for string in strings {
            isEmpty += string
            if string == "", let index = strings.index(of: string) {
                strings.remove(at: index)
            }
        }
        
        if isEmpty == "" {
            tagsView.removeFromSuperview()
        }
        
        
        // 根据8种页面状态调整UI
        switch (elementarySchool.superview, juniorSchool.superview, seniorSchool.superview) {
            
        case (nil, nil, nil):
            // 均已移除不做处理
            break
        case (_, nil, nil):
            
            elementarySchool.snp.makeConstraints { (maker) in
                maker.top.equalTo(content)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(height)
                maker.bottom.equalTo(content)
            }
            
            break
        case (nil, _, nil):
            
            juniorSchool.snp.makeConstraints { (maker) in
                maker.top.equalTo(content)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(25)
                maker.bottom.equalTo(content)
            }
            
            break
        case (nil, nil, _):
            
            seniorSchool.snp.makeConstraints { (maker) in
                maker.top.equalTo(content)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(25)
                maker.bottom.equalTo(content)
            }
            
            break
        case (_, _, nil):
            
            juniorSchool.snp.makeConstraints { (maker) in
                maker.top.equalTo(elementarySchool.snp.bottom).offset(12)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(25)
                maker.bottom.equalTo(content)
            }

            break
        case (_, nil, _):
            
            elementarySchool.snp.remakeConstraints { (maker) in
                maker.top.equalTo(content)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(25)
                maker.bottom.equalTo(seniorSchool.snp.top).offset(-12)
            }
            seniorSchool.snp.remakeConstraints { (maker) in
                maker.top.equalTo(elementarySchool.snp.bottom).offset(12)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(25)
                maker.bottom.equalTo(content)
            }
            
            break
        case (nil, _, _):
            
            juniorSchool.snp.makeConstraints { (maker) in
                maker.top.equalTo(content)
                maker.left.equalTo(content)
                maker.right.equalTo(content)
                maker.height.equalTo(25)
                maker.bottom.equalTo(seniorSchool.snp.top).offset(-12)
            }
            
            break
        case (_, _, _):
            // 均存在使用默认设置
            break
        }

        if isEmpty != "" {
            tagsView.labels = strings
        }
    }
}
