//
//  OrderFormOperatingView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

public protocol OrderFormOperatingViewDelegate: class {
    ///  立即支付
    func orderFormPayment()
    ///  再次购买
    func orderFormBuyAgain()
    ///  取消订单
    func orderFormCancel()
    ///  申请退费
    func requestRefund()
}


class OrderFormOperatingView: UIView {
    
    // MARK: - Property
    /// 需支付金额
    var price: Int = 0 {
        didSet{
            priceLabel.text = price.amountCNY
        }
    }
    /// 订单状态
    var orderStatus: MalaOrderStatus = .canceled {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.changeDisplayMode()
            })
        }
    }
    /// 老师上架状态标记
    var isTeacherPublished: Bool?
    weak var delegate: OrderFormOperatingViewDelegate?
    
    
    // MARK: - Components
    /// 价格容器
    private lazy var priceContainer: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 合计标签
    private lazy var stringLabel: UILabel = {
        let label = UILabel(
            text: "合计:",
            font: UIFont(name: "PingFang-SC-Light", size: 13),
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 金额标签
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "￥0.00",
            font: UIFont(name: "PingFang-SC-Light", size: 18),
            textColor: MalaColor_E26254_0
        )
        return label
    }()
    /// 确定按钮（确认支付、再次购买、重新购买）
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(OrderFormOperatingView.pay), for: .touchUpInside)
        return button
    }()
    /// 取消按钮（取消订单）
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(OrderFormOperatingView.cancelOrderForm), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.white
        
        // SubViews
        addSubview(priceContainer)
        priceContainer.addSubview(stringLabel)
        priceContainer.addSubview(priceLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
        
        // Autolayout
        priceContainer.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.44)
            maker.height.equalTo(44)
            maker.bottom.equalTo(self)
        })
        stringLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(priceLabel.snp.left)
            maker.centerY.equalTo(priceContainer)
            maker.height.equalTo(18.5)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(priceContainer)
            maker.centerX.equalTo(priceContainer).offset(17)
            maker.height.equalTo(25)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.28)
            maker.height.equalTo(self)
        }
        cancelButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(confirmButton.snp.left)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.28)
            maker.height.equalTo(self)
        }
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
        
        // 仅当订单金额已支付时，老师下架状态才会生效
        if isTeacherPublished == false && orderStatus != .penging {
            setTeacherDisable()
            return
        }
        
        switch orderStatus {
        case .penging:
            setOrderPending()
            break
            
        case .paid:
            setOrderPaid()
            break
            
        case .paidRefundable:
            setOrderPaidRefundable()
            break
            
        case .finished:
            setOrderFinished()
            break
            
        case .refunding:
            setOrderRefunding()
            break
            
        case .refund:
            setOrderRefund()
            break
            
        case .canceled:
            setOrderCanceled()
            break
            
        case .confirm:
            setOrderConfirm()
            break
        }
    }
    
    /// 待支付样式
    private func setOrderPending() {
        cancelButton.isHidden = false
        cancelButton.setTitle("取消订单", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setBackgroundImage(UIImage.withColor(MalaColor_C3DBED_0), for: .normal)
        cancelButton.addTarget(self, action: #selector(OrderFormOperatingView.cancelOrderForm), for: .touchUpInside)
        confirmButton.isHidden = false
        confirmButton.setTitle("去支付", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_9BC3E1_0), for: .normal)
        confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.pay), for: .touchUpInside)
    }
    
    /// 进行中不可退费样式(only for 1to1)
    private func setOrderPaid() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.setTitle("再次购买", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_E26254_0), for: .normal)
        confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 进行中可退费样式(only for live course)
    private func setOrderPaidRefundable() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.setTitle("申请退费", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_9EC379_0), for: .normal)
        confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.requestRefund), for: .touchUpInside)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 已完成样式(only for live course)
    private func setOrderFinished() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.setTitle("再次购买", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_E26254_0), for: .normal)
        confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 退费审核中样式(only for live course)
    private func setOrderRefunding() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.isEnabled = false
        confirmButton.setTitle("审核中...", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_CFCFCF_0), for: .normal)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 已退费样式
    private func setOrderRefund() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.isEnabled = false
        confirmButton.setTitle("已退费", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_9EC379_0), for: .normal)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 已取消样式
    private func setOrderCanceled() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.setTitle("重新购买", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_E26254_0), for: .normal)
        confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 订单预览样式
    private func setOrderConfirm() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.setTitle("提交订单", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_E26254_0), for: .normal)
        confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.pay), for: .touchUpInside)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    /// 教师已下架样式
    private func setTeacherDisable() {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        confirmButton.isEnabled = false
        confirmButton.setTitle("该老师已下架", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_CFCFCF_0), for: .normal)
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    
    
    // MARK: - Event Response
    /// 立即支付
    @objc func pay() {
        delegate?.orderFormPayment()
    }
    /// 再次购买
    @objc func buyAgain() {
        delegate?.orderFormBuyAgain()
    }
    /// 取消订单
    @objc func cancelOrderForm() {
        delegate?.orderFormCancel()
    }
    /// 申请退费
    @objc func requestRefund() {
        delegate?.requestRefund()
    }
}