//
//  ContactDetailsViewController.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import UIKit
import PhotosUI

class ContactDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var firstNameTF: UITextField!
    @IBOutlet weak private var lastNameTF: UITextField!
    @IBOutlet weak private var phoneNumberTF: UITextField!
    
    //MARK: - Variables
    var viewModel: ContactDetailsViewModelProtocol!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupView()
        setupUserImageView()
        setupTextFields()
        setupViewModelCallBacks()
        viewModel.getContact()
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.makeRounded()
    }
    
    //MARK: - Actions & @objc
    
    @objc private func cancelDidTapped(_ sender: UIBarButtonItem) {
        viewModel.cancelTapped()
    }
    
    @objc private func saveContactDidTapped(_ sender: UIBarButtonItem) {
        let id: Int = 0
        let firstName = firstNameTF.text ?? ""
        let lastName = lastNameTF.text ?? ""
        let phoneNumber = phoneNumberTF.text ?? ""
        let uiimage = userImageView.image ?? UIImage(named: "user")!
        guard let photo = uiimage.pngData() else { return }
        
        let contact = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, photo: photo)
        viewModel.save(with: contact)
    }
    
    @objc private func chooseUserImageTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self
        self.present(photoPicker, animated: true)
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }

    //MARK: - Methods
    private func setupNavigationController() {
        title = "Add New Contact"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.main]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.main]
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDidTapped(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .main
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContactDidTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .main
    }
    
    private func setupUserImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseUserImageTapped))
        userImageView.isUserInteractionEnabled = true
        userImageView.image = UIImage(named: "user")
        userImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextFields() {
        firstNameTF.becomeFirstResponder()
        phoneNumberTF.delegate = self
        phoneNumberTF.keyboardType = .numberPad
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupViewModelCallBacks() {
        viewModel.unableToSaveContactBlock = {[weak self] message in
            self?.showError("Error", message: message)
        }
        
        viewModel.getContactInfoBlock = {[weak self] contact in
            guard let contact = contact else { return }
            self?.setupUIWithContact(contact)
        }
    }
    
    private func setupUIWithContact(_ contact: Contact) {
        lastNameTF.text = contact.lastName
        firstNameTF.text = contact.firstName
        phoneNumberTF.text = contact.phoneNumber
        userImageView.image = UIImage(data: contact.photo)
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ContactDetailsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self ] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.userImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showError("Error", message: "Unable to download provided image. Error: \(error?.localizedDescription ?? "").")
                    }
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension ContactDetailsViewController: UITextFieldDelegate {
    
    //MARK: Phone number validation
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, textField == phoneNumberTF {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
}

//MARK: - Storyboarded
extension ContactDetailsViewController: Storyboarded {
    static var storyboardName: String {
        "Main"
    }
    
    static var identifier: String {
        "ContactDetailsViewController"
    }
}
