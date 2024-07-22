//
//  ViewController.swift
//  MovieBookingApp
//
//  Created by 김동건 on 7/22/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let movieNameLabel = UILabel()
    let movieNameTextField = UITextField()
    let dateLabel = UILabel()
    let datePicker = UIDatePicker()
    let peopleLabel = UILabel()
    let peopleCountLabel = UILabel()
    let peopleStepper = UIStepper()
    let totalPriceLabel = UILabel()
    let payButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        titleLabel.text = "예매하기"
        titleLabel.font = .boldSystemFont(ofSize: 35)
        view.addSubview(titleLabel)
        
        // Movie Name
        movieNameLabel.text = "영화명"
        movieNameLabel.font = .boldSystemFont(ofSize: 17)
        view.addSubview(movieNameLabel)
        
        movieNameTextField.borderStyle = .roundedRect
        view.addSubview(movieNameTextField)
        
        // Date
        dateLabel.text = "날짜"
        dateLabel.font = .boldSystemFont(ofSize: 17)
        view.addSubview(dateLabel)
        
        datePicker.datePickerMode = .date
        view.addSubview(datePicker)
        
        // People
        peopleLabel.text = "인원"
        peopleLabel.font = .boldSystemFont(ofSize: 17)
        view.addSubview(peopleLabel)
        
        peopleCountLabel.text = "1"
        view.addSubview(peopleCountLabel)
        
        peopleStepper.minimumValue = 1
        peopleStepper.maximumValue = 10
        peopleStepper.value = 1
        peopleStepper.addTarget(self, action: #selector(peopleStepperChanged), for: .valueChanged)
        view.addSubview(peopleStepper)
        
        // Total Price
        totalPriceLabel.text = "총 가격: 10,000원"
        totalPriceLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(totalPriceLabel)
        
        // Pay Button
        payButton.setTitle("결제하기", for: .normal)
        payButton.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        payButton.setTitleColor(.black, for: .normal)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        view.addSubview(payButton)
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).offset(20)
        }
        
        movieNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.equalTo(view).offset(20)
        }
        
        movieNameTextField.snp.makeConstraints { make in
            make.top.equalTo(movieNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(movieNameLabel)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameTextField.snp.bottom).offset(40)
            make.leading.equalTo(movieNameLabel)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateLabel)
            make.trailing.equalTo(view).offset(-20)
        }
        
        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(40)
            make.leading.equalTo(movieNameLabel)
        }
        
        peopleCountLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleLabel.snp.bottom).offset(10)
            make.leading.equalTo(peopleLabel)
        }
        
        peopleStepper.snp.makeConstraints { make in
            make.top.equalTo(peopleCountLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view).offset(-20)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleStepper.snp.bottom).offset(80)
            make.trailing.equalTo(view).offset(-20)
        }
        
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
        }
    }
    
    @objc func peopleStepperChanged(_ sender: UIStepper) {
        let count = Int(sender.value)
        peopleCountLabel.text = "\(count)"
        totalPriceLabel.text = "총 가격: \(count * 10000)원"
    }
    
    @objc func payButtonTapped() {
        let alert = UIAlertController(title: "결제 확인", message: "결제를 진행하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.showCompletionAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showCompletionAlert() {
        let completionAlert = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        completionAlert.addAction(okAction)
        
        present(completionAlert, animated: true, completion: nil)
    }
}
