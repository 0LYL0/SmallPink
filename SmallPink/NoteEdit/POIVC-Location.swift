//
//  POIVC-Location.swift
//  SmallPink
//
//  Created by yalan on 2022/4/13.
//

import Foundation
extension POIVC{
    func requestLacation(){
        //定位
        showLoadHUD()
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    self?.hideLoadHUD()
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    self?.hideLoadHUD()
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            guard let POIVC = self else { return }
        
            if let location = location {
    //                   print("location:%@", location)
                POIVC.latitude = location.coordinate.latitude
                POIVC.longitude = location.coordinate.longitude
                // MARK: 检索周边
                POIVC.setAroundSearchFoot()
                POIVC.makeAroundSearch()
            }
               
               if let reGeocode = reGeocode {
    //                   print("reGeocode:%@", reGeocode)
                   //AMapLocationReGeocode:{formattedAddress:湖北省武汉市洪山区珞喻路靠近武汉光谷金盾大酒店; country:中国;province:湖北省; city:武汉市; district:洪山区; citycode:027; adcode:420111; street:珞喻路; number:564号; POIName:武汉光谷金盾大酒店; AOIName:武汉光谷金盾大酒店;}
                   guard let formatterAddress = reGeocode.formattedAddress, !formatterAddress.isEmpty else { return }
                   let province = reGeocode.province == reGeocode.city ? "" : reGeocode.province!
                   let currentPOI = [reGeocode.poiName!, "\(province)\(reGeocode.city!)\(reGeocode.district!)\(reGeocode.street ?? "")\(reGeocode.number ?? "")"]
                   POIVC.pois.append(currentPOI)
                   POIVC.aroundSearchedPOIs.append(currentPOI)
                   DispatchQueue.main.async {
                       POIVC.tableView.reloadData()
                   }
               }
           })
    }
}

// MARK: 默认的请求周边
extension POIVC{
    func makeAroundSearch(_ page: Int = 1){
        aroundSearchRequest.page = page
        mapSearch?.aMapPOIAroundSearch(aroundSearchRequest)
    }
    func setAroundSearchFoot(){
        footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(aroundSearchPullToRefresh))
    }
}

// MARK: 上拉加载
extension POIVC{
    @objc func aroundSearchPullToRefresh(){
        currentAroundPage = currentAroundPage + 1
        makeAroundSearch(currentAroundPage)
        if currentAroundPage < pagesCount{
            footer.endRefreshing()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
        
    }
}
