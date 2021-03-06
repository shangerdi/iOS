//
//  CommentViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/7.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    // MARK: - Property
    /// 单个课程模型
    var model: StudentCourseModel? {
        didSet {
            guard let model = model else { return }
            
            // 评价状态
            changeDisplayMode()
            
            // 课程类型
            if let isLive = model.isLiveCourse, isLive == true {
                liveCourseAvatarView.setAvatar(lecturer: model.lecturer?.avatar, assistant: model.teacher?.avatar)
                liveCourseAvatarView.isHidden = false
                avatarView.isHidden = true
            }else {
                avatarView.setImage(withURL: model.teacher?.avatar)
                avatarView.isHidden = false
                liveCourseAvatarView.isHidden = true
            }
            
            // 课程模型
            teacherLabel.text = model.teacher?.name
            subjectLabel.text = model.grade + " " + model.subject
            setDateString()
            schoolLabel.attributedText = model.attrAddressString
        }
    }
    
    // MARK: - Components
    /// 主要布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.addShadow(color: UIColor(named: .ShadowGray))
        return view
    }()
    /// 课程信息布局容器
    private lazy var mainLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 课程评价状态标示
    private lazy var statusIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .uncomment), for: UIControlState())
        button.setBackgroundImage(UIImage(asset: .commented), for: .highlighted)
        button.setBackgroundImage(UIImage(asset: .commentExpired), for: .disabled)
        button.setTitle("待 评", for: UIControlState())
        button.setTitle("已 评", for: .highlighted)
        button.setTitle("过 期", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 老师头像
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(
            cornerRadius: 55/2,
            image: "avatar_placeholder",
            contentMode: .scaleAspectFill
        )
        return imageView
    }()
    /// 双师直播课程头像
    private lazy var liveCourseAvatarView: LiveCourseAvatarView = {
        let view = LiveCourseAvatarView()
        return view
    }()
    /// 老师姓名图标
    private lazy var teacherIcon: UIImageView = {
        let imageView = UIImageView(imageName: "comment_teacher_normal")
        return imageView
    }()
    /// 老师姓名
    private lazy var teacherLabel: UILabel = {
        let label = UILabel(
            text: "教师姓名",
            fontSize: 13,
            textColor: UIColor(named: .ThemeBlue)
        )
        return label
    }()
    /// 学科信息图标
    private lazy var subjectIcon: UIImageView = {
        let imageView = UIImageView(imageName: "comment_subject")
        return imageView
    }()
    /// 学科信息
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "年级-学科",
            fontSize: 13,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        return label
    }()
    /// 上课时间图标
    private lazy var timeSlotIcon: UIImageView = {
        let imageView = UIImageView(imageName: "comment_time")
        return imageView
    }()
    /// 上课日期信息
    private lazy var timeSlotLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            fontSize: 13,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        return label
    }()
    /// 上课时间信息
    private lazy var timeLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 13,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 上课地点图标
    private lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView(imageName: "comment_location")
        return imageView
    }()
    /// 上课地点
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点",
            fontSize: 13,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        label.numberOfLines = 0
        return label
    }()
    /// 中部分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(UIColor(named: .SeparatorLine))
        return view
    }()
    /// 评分面板
    private lazy var floatRating: FloatRatingView = {
        let floatRating = FloatRatingView()
        floatRating.backgroundColor = UIColor.white
        floatRating.editable = false
        return floatRating
    }()
    /// 底部布局容器
    private lazy var bottomLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 已过期文字标签
    private lazy var expiredLabel: UILabel = {
        let label = UILabel(
            text: "评价已过期",
            fontSize: 12,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 评论按钮
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor(named: .ThemeRed).cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeRedHighlight)), for: .highlighted)
        button.setTitle("去评价", for: UIControlState())
        button.setTitleColor(UIColor(named: .ThemeRed), for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(CommentViewCell.toComment), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    /// 查看评论按钮
    private lazy var showCommentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor(named: .ThemeBlue).cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .CommitHighlightBlue)), for: .highlighted)
        button.setTitle("查看评价", for: UIControlState())
        button.setTitleColor(UIColor(named: .ThemeBlue), for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(CommentViewCell.showComment), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
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
        contentView.backgroundColor = UIColor(named: .RegularBackground)
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(mainLayoutView)
        content.addSubview(separatorLine)
        content.addSubview(bottomLayoutView)
        content.addSubview(floatRating)
        
        mainLayoutView.addSubview(avatarView)
        mainLayoutView.addSubview(liveCourseAvatarView)
        mainLayoutView.addSubview(statusIcon)
        
        mainLayoutView.addSubview(teacherIcon)
        mainLayoutView.addSubview(teacherLabel)
        mainLayoutView.addSubview(subjectIcon)
        mainLayoutView.addSubview(subjectLabel)
        mainLayoutView.addSubview(timeSlotIcon)
        mainLayoutView.addSubview(timeSlotLabel)
        mainLayoutView.addSubview(timeLabel)
        mainLayoutView.addSubview(schoolIcon)
        mainLayoutView.addSubview(schoolLabel)
        
        bottomLayoutView.addSubview(expiredLabel)
        bottomLayoutView.addSubview(commentButton)
        bottomLayoutView.addSubview(showCommentButton)
        
        // Autolayout
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(6)
            maker.left.equalTo(contentView).offset(12)
            maker.bottom.equalTo(contentView).offset(-6)
            maker.right.equalTo(contentView).offset(-12)
        }
        mainLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(separatorLine.snp.top)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainLayoutView.snp.bottom).offset(14)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(content).offset(5)
            maker.right.equalTo(content).offset(-5)
        }
        floatRating.snp.makeConstraints { (maker) in
            maker.center.equalTo(separatorLine)
            maker.height.equalTo(20)
            maker.width.equalTo(80)
        }
        bottomLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom)
            maker.bottom.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.height.equalTo(50)
        }
        statusIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(mainLayoutView).offset(-30)
            maker.top.equalTo(mainLayoutView).offset(-6)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusIcon)
            maker.top.equalTo(statusIcon.snp.bottom).offset(10)
            maker.height.equalTo(55)
            maker.width.equalTo(55)
        }
        liveCourseAvatarView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusIcon)
            maker.top.equalTo(statusIcon.snp.bottom).offset(10)
            maker.width.equalTo(72)
            maker.height.equalTo(45)
        }
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainLayoutView).offset(14)
            maker.left.equalTo(mainLayoutView).offset(12)
            maker.height.equalTo(14)
            maker.width.equalTo(14)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon)
            maker.left.equalTo(teacherIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        subjectIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.bottom).offset(14)
            maker.left.equalTo(mainLayoutView).offset(12)
            maker.height.equalTo(14)
            maker.width.equalTo(14)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon)
            maker.left.equalTo(subjectIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        timeSlotIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.bottom).offset(14)
            maker.left.equalTo(mainLayoutView).offset(12)
            maker.height.equalTo(14)
            maker.width.equalTo(14)
        }
        timeSlotLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon)
            maker.left.equalTo(timeSlotIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotLabel)
            maker.left.equalTo(timeSlotLabel.snp.right).offset(5)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon.snp.bottom).offset(14)
            maker.left.equalTo(mainLayoutView).offset(12)
            maker.height.equalTo(15)
            maker.width.equalTo(14)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(schoolIcon.snp.right).offset(10)
            maker.right.equalTo(avatarView.snp.left).offset(-10)
            maker.bottom.equalTo(mainLayoutView).offset(-14)
        }
        expiredLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(12)
            maker.center.equalTo(bottomLayoutView)
        }
        commentButton.snp.makeConstraints { (maker) in
            maker.center.equalTo(bottomLayoutView)
            maker.width.equalTo(96)
            maker.height.equalTo(24)
        }
        showCommentButton.snp.makeConstraints { (maker) in
            maker.center.equalTo(bottomLayoutView)
            maker.width.equalTo(96)
            maker.height.equalTo(24)
        }
    }
    
    ///  设置日期样式
    private func setDateString() {
        guard let start = model?.start else { return }
        let dateString = getDateString(start, format: "yyyy-MM-dd")
        let startString = getDateString(start, format: "HH:mm")
        let endString = getDateString(date: Date(timeIntervalSince1970: start).addingTimeInterval(3600*2), format: "HH:mm")
        timeSlotLabel.text = String(format: "%@", dateString)
        timeLabel.text = String(format: "%@-%@", startString, endString)
    }
    
    ///  设置过期样式
    private func setStyleExpired() {
        showCommentButton.isHidden = true
        commentButton.isHidden = true
        statusIcon.isHighlighted = false
        statusIcon.isEnabled = false
        expiredLabel.isHidden = false
        floatRating.isHidden = true
    }
    
    ///  设置已评论样式
    private func setStyleCommented() {
        commentButton.isHidden = true
        showCommentButton.isHidden = false
        statusIcon.isEnabled = true
        statusIcon.isHighlighted = true
        expiredLabel.isHidden = true
        floatRating.isHidden = false
        floatRating.rating = Float((model?.comment?.score) ?? 0)
    }
    
    ///  设置待评论样式
    private func setStyleNoComments() {
        commentButton.isHidden = false
        showCommentButton.isHidden = true
        statusIcon.isHighlighted = false
        statusIcon.isEnabled = true
        expiredLabel.isHidden = true
        floatRating.isHidden = true
    }
    
    /// 根据当前课程评价状态，渲染对应UI样式
    private func changeDisplayMode() {
        // 课程评价状态
        if model?.comment != nil {
            // 已评价
            setStyleCommented()
            
        }else if model?.isExpired == true {
            // 过期
            setStyleExpired()
            
        }else {
            // 未评价
            setStyleNoComments()
        }
    }
    
    
    // MARK: - Event Response
    ///  去评价
    @objc private func toComment() {
        let commentWindow = CommentViewWindow(contentView: UIView())
        
        commentWindow.finishedAction = { [weak self] in
            self?.setStyleCommented()
        }
        
        commentWindow.model = self.model ?? StudentCourseModel()
        commentWindow.isJustShow = false
        commentWindow.show()
    }
    
    ///  查看评价
    @objc private func showComment() {
        let commentWindow = CommentViewWindow(contentView: UIView())
        commentWindow.model = self.model ?? StudentCourseModel()
        commentWindow.isJustShow = true
        commentWindow.show()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusIcon.isHighlighted = false
        statusIcon.isEnabled = true
    }
}
