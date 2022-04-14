//
//  POIVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/13.
//

import UIKit
import MJRefresh

class POIVC: UIViewController {
    
    var delegate: POIVCDelegate?
    var poiName = ""

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var locationManager = AMapLocationManager()
    lazy var mapSearch = AMapSearchAPI()
    //搜索周边POI请求
    lazy var aroundSearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()
        request.types = kPOITypes
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        request.requireExtension = true
        request.offset = kPOIsOffset
        return request
    }()
    //关键字搜索POI请求
    var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        let request = AMapPOIKeywordsSearchRequest()
        request.requireExtension = true
        request.offset = kPOIsOffset
        return request
    }()
    lazy var footer = MJRefreshAutoNormalFooter()
    
    
    var pois = kPOIsInitArr
    var aroundSearchedPOIs = kPOIsInitArr
    var latitude = 0.0
    var longitude = 0.0
    var keyweords = ""
    var currentAroundPage = 1//当前页数
    var pagesCount = 1
    var currentKeywordsPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       
        searchBar.delegate = self

        congig()
        requestLacation()
        mapSearch?.delegate = self

    }

}

extension POIVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPOIVCCellID, for: indexPath) as! POICell
        let poi = pois[indexPath.row]
        cell.poi = poi
        if poi[0] == poiName{
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
}

extension POIVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        delegate?.updatePOIName(pois[indexPath.row][0])
        dismiss(animated: true, completion: nil)
    }
}
