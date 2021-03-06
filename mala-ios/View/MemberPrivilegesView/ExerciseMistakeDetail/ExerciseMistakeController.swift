//
//  ExerciseMistakeController.swift
//  mala-ios
//
//  Created by 王新宇 on 15/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

private let ExerciseMistakeViewCellReuseId = "ExerciseMistakeViewCellReuseId"

class ExerciseMistakeController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Property
    /// 当前下标
    var index: Int?
    var models: [ExerciseMistakeRecord] = MalaConfig.exerciseRecordDefaultData() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - Components
    /// 轮播视图
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaScreenHeight-MalaScreenNaviHeight)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CommonFlowLayout(type: .default, frame: frame))
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        configure()
        delay(0.05) {
            if let i = self.index {
                self.collectionView.scrollToItem(at: IndexPath(item: i, section: 0), at: [], animated: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private method
    private func configure() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ExerciseMistakeViewCell.self, forCellWithReuseIdentifier: ExerciseMistakeViewCellReuseId)
    }
    
    private func setupUserInterface() {
        
        let modelsFirstId = models.first?.id
        let defaultFirstId = MalaConfig.exerciseRecordDefaultData().first?.id
        
        title = modelsFirstId == defaultFirstId ? "错题样本" : "错题详情"
        
        // Style
        collectionView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        view.addSubview(collectionView)
        
        // Autolayout
        collectionView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view)
            maker.size.equalTo(view)
        }
    }
    
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseMistakeViewCellReuseId, for: indexPath) as! ExerciseMistakeViewCell
        MalaCurrentExerciseIndex = indexPath.row
        cell.index = indexPath.row+1
        cell.amount = models.count
        cell.model = models[indexPath.row]
        return cell
    }
}
