//
//  ViewController.swift
//  ContactPad
//
//  Created by Vaibhav Sharma on 02/09/19.
//  Copyright © 2019 Vaibhav Sharma. All rights reserved.
//

import UIKit

enum ActionType : String{
    case call = "Call"
    case number = "Number"
    case delete = "Delete"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var contentModelArray = [ContentModel]()
    var dialedNumber : [String] = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        //CollectionViewCell
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib(nibName: "NumberPadHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NumberPadHeaderView")
        collectionView.register(UINib(nibName: "NumberPadHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "NumberPadHeaderView")
        readJsonData()
        
//        getAvailableCoupons(urlString: "http://173.249.20.137:9000/apiapp/coupon") { (data, erros) in
//            print(data)
//            print(erros)
//        }
    }
    
    func getAvailableCoupons(urlString:String, completion: @escaping (_
        product: Any, _ error: Error?) -> Void){
        guard let url = URL(string: urlString) else {return}
        
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            let responseJSON = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                if statusCode == 200 {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseJSON, options: [])
                    //    let responseData = try jsonDecoder.decode(CoupensResponseModel.self, from:jsonData)
                        
                        if let result = String(data: jsonData, encoding: .utf8) {
                            print(result)
                        }
                        completion(jsonData, nil)
                        
                    } catch let error {
                        print("error when parshing json response \(error)")
                        completion(error, nil )
                    }
                    
                } else if statusCode == 404{
                    completion(" 404 not found", nil )
                    
                } else {
                    print("fatal error \(error?.localizedDescription ?? "big errror")")
                }
            }
            
            
            }.resume()
    }
    
    func readJsonData()  {
        if let path = Bundle.main.path(forResource: "Data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let dataArray = jsonResult["data"] as? [[String: AnyObject]] {
                    for obj in dataArray{
                        if let title = obj["title"] as? String,let description = obj["description"] as? String,let isVisible = obj["bgColor"] as? Bool, let image = obj["image"] as? String, let actionType = obj["actionType"] as? String{
                            let  contentModel =  ContentModel(title: title, description: description, isContentVisible: isVisible, imageName: image, actionType: actionType)
                            self.contentModelArray.append(contentModel)
                        }
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
}
extension ViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentModelArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            cell.tag = indexPath.row
            cell.updateData(contentModel: self.contentModelArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NumberPadHeaderView", for: indexPath) as!  NumberPadHeaderView
        //update tag
        header.tag = 100
        return header
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width
        let size = CGSize(width: width, height: width * 0.20)
        return size
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        let width = collectionView.frame.size.width
    //        let size = CGSize(width: width, height: width * 0.30)
    //        return size
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftRightPadding = view.frame.width * 0.13
        let interSpacing = view.frame.width * 0.1
        let cellWidth = (view.frame.width - 2 * leftRightPadding - 2 * interSpacing) / 3
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftAndRightPadding = view.frame.size.width * 0.15
        return UIEdgeInsets(top: 16, left: leftAndRightPadding, bottom: 16, right: leftAndRightPadding)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
       
        let contentModel =  self.contentModelArray[indexPath.row]
        guard let header = self.collectionView.viewWithTag(100) as? NumberPadHeaderView else {
            return
        }
        if let  actionType = ActionType(rawValue: contentModel.actionType ?? "") {
            switch actionType {
            case .call:
                //do call
                break
            case .delete:
                //delete number
                guard  dialedNumber.count > 0  else{
                    return
                }
                self.deleteNumber(numberPadHeaderView: header)
                break
            case .number:
                //enter number
                guard  dialedNumber.count < 10 else{
                    return
                }
                self.typeNumber(numberPadHeaderView: header, title: contentModel.title ?? "")
                break
            }
        }
    }
    
    func typeNumber(numberPadHeaderView : NumberPadHeaderView, title : String) {
        dialedNumber.append(title)
        numberPadHeaderView.updateHeaderValue(value:  dialedNumber.joined() )
    }
    
    func deleteNumber(numberPadHeaderView : NumberPadHeaderView) {
        dialedNumber.removeLast()
        numberPadHeaderView.updateHeaderValue(value:  dialedNumber.joined() )
    }
    
    func callToNumber() {
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            print(updatedText)
        }
        return true
    }
}
