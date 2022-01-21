//
//  SettingsController.swift
//  WorldNews
//
//  Created by Alex Mosunov on 21.01.2022.
//

import UIKit

protocol SettingsControllerDelegate: AnyObject {
    func didFinishSettingSettings()
}

class SettingsController: UIViewController {
    
    private lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var languagePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var countryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var sourcePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Category"
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Language"
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Country"
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Source"
        return label
    }()
    
    weak var delegate: SettingsControllerDelegate?

    // MARK: API
    
    private func fetchSources() {
        AlamofireNetworkRequest.sendRequestForSources(url: "https://newsapi.org/v2/top-headlines/sources?apiKey=d7ae831b5c654b2bbee290b51935c35b") { [weak self ]result in
            guard let self = self else { return }
            
            switch result {
            case .success(let sources):
                
                SettingCategoriesModel.sourceItems = sources
                SettingCategoriesModel.sourceItems.insert("No selection", at: 0)
                DispatchQueue.main.async {
                    self.sourcePicker.reloadAllComponents()
                }
                
            case .failure(let error):
                print("error - \(error.localizedDescription)")
            }
            print("Result - \(result)")
        }
    }
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchSources()
        setStackViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        setPickerViewsSelection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didFinishSettingSettings()
    }
    
    // MARK: Helpers
    
    private func setPickerViewsSelection() {
        let categoryRow = UserDefaults.standard.integer(forKey:"categoryRow")
        if categoryRow <= SettingCategoriesModel.categoryItems.count - 1 {
            categoryPicker.selectRow(categoryRow, inComponent: 0, animated: false)
        }
        let languageRow = UserDefaults.standard.integer(forKey:"languageRow")
        if languageRow <= SettingCategoriesModel.languageItems.count - 1 {
            languagePicker.selectRow(languageRow, inComponent: 0, animated: false)
        }
        let countryRow = UserDefaults.standard.integer(forKey:"countryRow")
        if countryRow <= SettingCategoriesModel.countryItems.count - 1 {
            countryPicker.selectRow(countryRow, inComponent: 0, animated: false)
        }
        let sourceRow = UserDefaults.standard.integer(forKey:"sourceRow")
        if sourceRow <= SettingCategoriesModel.sourceItems.count - 1 {
            sourcePicker.selectRow(sourceRow, inComponent: 0, animated: false)
        }
    }
    
    private func setStackViews() {
        let categoryStackView = UIStackView(arrangedSubviews: [categoryLabel, categoryPicker])
        categoryStackView.axis = .vertical
        categoryStackView.alignment = .center
        
        self.view.addSubview(categoryStackView)
        
        let languageStackView = UIStackView(arrangedSubviews: [languageLabel, languagePicker])
        languageStackView.axis = .vertical
        languageStackView.alignment = .center
        self.view.addSubview(languageStackView)
        
        let countryStackView = UIStackView(arrangedSubviews: [countryLabel, countryPicker])
        countryStackView.axis = .vertical
        countryStackView.alignment = .center
        self.view.addSubview(countryStackView)
        
        let sourceStackView = UIStackView(arrangedSubviews: [sourceLabel, sourcePicker])
        sourceStackView.axis = .vertical
        sourceStackView.alignment = .center
        self.view.addSubview(sourceStackView)
        
        let stackView = UIStackView(arrangedSubviews: [categoryStackView, languageStackView])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.backgroundColor = .systemBackground
        self.view.addSubview(stackView)
        
        let stackViewTwo = UIStackView(arrangedSubviews: [countryStackView, sourceStackView])
        stackViewTwo.distribution = .fillEqually
        stackViewTwo.axis = .horizontal
        stackViewTwo.spacing = 4
        stackViewTwo.alignment = .center
        stackViewTwo.backgroundColor = .systemBackground
        self.view.addSubview(stackViewTwo)
        
        let stackViewGeneral = UIStackView(arrangedSubviews: [stackView, stackViewTwo])
        stackViewGeneral.distribution = .fillEqually
        stackViewGeneral.axis = .vertical
        stackViewGeneral.spacing = 2
        stackViewGeneral.alignment = .center
        stackViewGeneral.backgroundColor = .gray
        self.view.addSubview(stackViewGeneral)
        stackViewGeneral.centerY(inView: self.view)
        stackViewGeneral.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 400)
    }
    
}

// MARK: UIPickerViewDelegate & UIPickerViewDataSource

extension SettingsController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case categoryPicker:
            return SettingCategoriesModel.categoryItems.count
        case languagePicker:
            return SettingCategoriesModel.languageItems.count
        case countryPicker:
            return SettingCategoriesModel.countryItems.count
        case sourcePicker:
            return SettingCategoriesModel.sourceItems.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case categoryPicker:
            return SettingCategoriesModel.categoryItems[row]
        case languagePicker:
            return SettingCategoriesModel.languageItems[row]
        case countryPicker:
            return SettingCategoriesModel.countryItems[row]
        case sourcePicker:
            return SettingCategoriesModel.sourceItems[row]
        default:
            return nil
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case categoryPicker:
            UserDefaults.standard.set(row, forKey: "categoryRow")
        case languagePicker:
            UserDefaults.standard.set(row, forKey: "languageRow")
        case countryPicker:
            UserDefaults.standard.set(row, forKey: "countryRow")
        case sourcePicker:
            UserDefaults.standard.set(row, forKey: "sourceRow")
        default:
            ()
        }
    }
}
