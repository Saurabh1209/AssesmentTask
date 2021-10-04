//
//  SearchViewController.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 30/09/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import UIKit
import SwiftyJSON


class SearchViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagViewHeight: NSLayoutConstraint!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchError: UIImageView!
    @IBOutlet weak var searchResult: UILabel!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var unitArray = [Unit]()
    var allUnitArray = [Unit]()
    var blocksSelected = 0
     var blocks = [String]()
    var allTags = [String]()
    var database = DataBaseHelper.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.setup()
    }
    
    
    // MARK: Setup
    private func setup()
    {
        self.title = "Search"
        tagListView.delegate = self
        tagViewHeight.isActive = false
        let height = NSLayoutConstraint(item: tagListView!, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: tagListView, attribute: .height, multiplier: 0, constant: 50)
        tagListView.addConstraint(height)
        self.searchResult.attributedText = appshared.addDifferentColorToText(fulltext: "Type to start searching for Units, Activity, Status.", coloredtext: "Units, Activity, Status", normalColor: UIColor.white, highlightedColor: UIColor.systemYellow)
        self.getFileData()
    }
    
    
    func getFileData(){
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSArray{
                    let jsonData = JSON.init(json)
                    jsonData.array?.forEach({ (js) in
                        let units = js["units"].array?.compactMap({ (dict) -> Unit? in
                            return Unit(json: dict)
                        })
                        self.unitArray.append(contentsOf: units!)
                    })
                    DataBaseHelper.shared.insertUnitDetail(units: self.unitArray)
                    print(self.unitArray)
                    self.tableView.reloadData()
                    
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    

    // MARK: Action
    @IBAction func clearButtonAction(sender: UIButton) {
        self.clearButton.isHidden = true
        self.resultsView.isHidden = true

        self.tagListView.removeAllTags()
        self.allTags.removeAll()
        self.blocks.removeAll()
        self.unitArray.removeAll()
        self.allUnitArray.removeAll()
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
        
        self.searchResult.attributedText = appshared.addDifferentColorToText(fulltext: "Type to start searching for Units, Activity, Status.", coloredtext: "Units, Activity, Status", normalColor: UIColor.white, highlightedColor: UIColor.systemYellow)
        self.searchError.image = UIImage(named: "Search_Landing")
    }

}

// MARK: TagListViewDelegate
extension SearchViewController: TagListViewDelegate {
    
    func tagListView(_ sender: TagListView, didAdd title: String) {
        allTags.append(title)
        callSearchVisitForPlaces()
        clearButton.isHidden = false
    }
    
    func tagListView(_ sender: TagListView, didRemove title: String) {
        allTags.remove(object: title)
        callSearchVisitForPlaces()
        clearButton.isHidden = allTags.count == 0
    }
    func callSearchVisitForPlaces() {
        self.blocks.removeAll()
        self.unitArray.removeAll()
        self.allUnitArray.removeAll()
        for tag in allTags {
            let units = self.searchBlockDataToLocalStorage(searchText: tag)
            self.displaySearchResult(units: units)
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func registerNib() {
        self.collectionView.registerCell(collectionView: self.collectionView, cellIdentifier: "HeaderCollectionViewCell")
        self.tableView.registerView(tableView: self.tableView, viewIdentifier: "HeaderView")
       self.tableView.registerCell(tableView: self.tableView, cellIdentifier: "BlockTableViewCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blocks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
        cell.lblTitle.text = blocks[indexPath.row]
        cell.imgSelected.isHidden = !(blocksSelected == indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = blocks[indexPath.row].width(withConstrainedHeight: height, font: UIFont.systemFont(ofSize: 15))
        return CGSize(width: (width + 20), height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        blocksSelected = indexPath.row
        if blocksSelected != 0 {
            self.unitArray = self.allUnitArray.filter({ (unit) -> Bool in
                return unit.blockName == self.blocks[blocksSelected]
            })
        } else {
            self.unitArray = self.allUnitArray
        }
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
}





// MARK: UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.unitArray.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        headerView.backgroundColor = UIColor.clear
        headerView.lblUnitName.text = self.unitArray[section].title
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.unitArray[section].activities?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockTableViewCell", for: indexPath) as! BlockTableViewCell
        cell.activityData = self.unitArray[indexPath.section].activities?[indexPath.row]
        cell.unitData = self.unitArray[indexPath.section]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension SearchViewController{
    func searchBlockDataToLocalStorage(searchText: String) -> [Unit]? {
        var unitData = [Unit]()
       database.searchUnitData(searchText: searchText) { (units, activities) in
            units?.forEach({ (unit) in
                let activity = activities?.filter({ (act) -> Bool in
                    return act.unitsId == unit.id
                })
                let parse = Unit(unit: unit, activities: activity ?? [])
                if !(unitData.contains(where: { (unitt) -> Bool in
                    return unitt.id == parse.id
                })) {
                    unitData.append(Unit(unit: unit, activities: activity ?? []))
                }
            })
        }
       database.searchActivitiesData(searchText: searchText) { (units, activities) in
            units?.forEach({ (unit) in
                let activity = activities?.filter({ (act) -> Bool in
                    return act.unitsId == unit.id
                })
                let parse = Unit(unit: unit, activities: activity ?? [])
                if !(unitData.contains(where: { (unitt) -> Bool in
                    return unitt.id == parse.id
                })) {
                    unitData.append(Unit(unit: unit, activities: activity ?? []))
                }
            })
        }
        return unitData.count == 0 ? nil : unitData
    }
    func displaySearchResult(units: [Unit]?) {
        self.blocks.removeAll()
        self.unitArray.removeAll()
        self.allUnitArray.removeAll()
        if let result = units {
            self.allUnitArray = result
            self.resultsView.isHidden = false
            self.blocks = result.compactMap({ (unit) -> String? in
                return unit.blockName
            })
            self.blocks.insert("All", at: 0)
            self.blocks = appshared.uniq(source: self.blocks)
            if blocksSelected != 0 {
                self.unitArray = self.allUnitArray.filter({ (unit) -> Bool in
                    return unit.blockName == self.blocks[blocksSelected]
                })
            } else {
                self.unitArray = self.allUnitArray
            }
        } else {
            let searchText = allTags.joined(separator: ",")
            self.searchResult.attributedText = appshared.addDifferentColorToText(fulltext: "Term \(searchText) not found", coloredtext: searchText, normalColor: UIColor.white, highlightedColor: UIColor.systemYellow)
            self.searchError.image = UIImage(named: "Error_Search")
            self.resultsView.isHidden = true
        }
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
}
