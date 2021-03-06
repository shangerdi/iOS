//
//  TeacherDetailsHighScoreTableView.swift
//  mala-ios
//
//  Created by Elors on 1/11/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

private let TeacherDetailsHighScoreTableViewCellReuseId = "TeacherDetailsHighScoreTableViewCellReuseId"

class TeacherDetailsHighScoreTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables
    var models: [HighScoreModel?] = [] {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: - Constructed
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        register(TeacherDetailsHighScoreTableViewCell.self, forCellReuseIdentifier: TeacherDetailsHighScoreTableViewCellReuseId)
        
        // Style
        isScrollEnabled = false
        separatorStyle = .none
        
        setupTableHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupTableHeaderView() {
        let headerView = TeacherDetailsHighScoreTableViewCell(style: .default, reuseIdentifier: nil)
        headerView.setTableTitles(["姓  名", "提分区间", "所在学校", "考入学校"])
        headerView.separator.isHidden = true
        self.tableHeaderView = headerView
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherDetailsHighScoreTableViewCellReuseId, for: indexPath)
        let model = models[indexPath.row]
        if model == nil {
            (cell as! TeacherDetailsHighScoreTableViewCell).model = HighScoreModel(name: "-", score: 0, school: "-", admitted: "-")
        }else {
            (cell as! TeacherDetailsHighScoreTableViewCell).model = model
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
}

// MARK: - TeacherDetailsHighScoreTableViewCell
class TeacherDetailsHighScoreTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    var model: HighScoreModel? {
        didSet {
            nameLabel.text = model!.name
            scoresLabel.text = String(format: "%d", model!.increased_scores)
            schoolLabel.text = model!.school_name
            admittedLabel.text = model!.admitted_to
        }
    }
    
    
    // MARK: - Components
    private lazy var nameLabel: UILabel = UILabel.subTitleLabel()
    private lazy var scoresLabel: UILabel = UILabel.subTitleLabel()
    private lazy var schoolLabel: UILabel = UILabel.subTitleLabel()
    private lazy var admittedLabel: UILabel = UILabel.subTitleLabel()
    lazy var separator: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(named: .SeparatorLine)
        return separatorLine
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: MalaScreenWidth - 12, height: 33)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubView
        contentView.addSubview(nameLabel)
        contentView.addSubview(scoresLabel)
        contentView.addSubview(schoolLabel)
        contentView.addSubview(admittedLabel)
        contentView.addSubview(separator)
        
        // Autolayout
        nameLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.bottom.equalTo(contentView)
            maker.left.equalTo(contentView)
        }
        scoresLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.left.equalTo(nameLabel.snp.right)
            maker.width.equalTo(nameLabel)
            maker.height.equalTo(nameLabel)
        }
        schoolLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.left.equalTo(scoresLabel.snp.right)
            maker.width.equalTo(scoresLabel)
            maker.height.equalTo(scoresLabel)
        }
        admittedLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.left.equalTo(schoolLabel.snp.right)
            maker.width.equalTo(schoolLabel)
            maker.height.equalTo(schoolLabel)
            maker.right.equalTo(contentView)
        }
        separator.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.bottom.equalTo(contentView)
        }
    }
    
    
    // MARK: - API
    ///  根据传入的表头字符串数组，生成对应的表头
    ///
    ///  - parameter titles: 表头字符串数组
    func setTableTitles(_ titles: [String]) {
        nameLabel.text = titles[0]
        scoresLabel.text = titles[1]
        schoolLabel.text = titles[2]
        admittedLabel.text = titles[3]
        for view in self.contentView.subviews {
            (view as? UILabel)?.textColor = UIColor(named: .ArticleTitle)
        }
        contentView.backgroundColor = UIColor(named: .BaseBoard)
    }
}
