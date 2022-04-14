//
//  POIVC-KeywordsSearch.swift
//  SmallPink
//
//  Created by yalan on 2022/4/13.
//

import Foundation

extension POIVC: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            //重置
            pois = aroundSearchedPOIs
            setAroundSearchFoot()
            
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isBlank else { return }
        keyweords = searchText
        //重置
        pois.removeAll()
        currentKeywordsPage = 1
        
        keywordsSearchRequest.keywords = keyweords
        setKeywoardsSearchFoot()
        showLoadHUD()
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }
}

// MARK: - 所有搜索POI的回调
extension POIVC: AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        hideLoadHUD()
//        print(response.count)
        if response.count > kPOIsOffset{
            pagesCount = response.count / kPOIsOffset + 1
        }else{
            footer.endRefreshingWithNoMoreData()
        }
        if response.count == 0 {
                return
        }
        for poi in response.pois {
            let province = poi.province == poi.city ? "" : poi.province
            let address = poi.district == poi.address ? "" : poi.address
            let poi = [
                poi.name ?? kNoPOIPH,
                "\(province.unwrappedText)\(poi.city.unwrappedText)\(poi.district.unwrappedText)\(address.unwrappedText)"
            ]
            pois.append(poi)
            if request is AMapPOIAroundSearchRequest{
                aroundSearchedPOIs.append(poi)
            }
        }
        
        
        
        tableView.reloadData()
    }
}

// MARK: 默认的请求周边
extension POIVC{
    func makeKeywordsSearch(_ keywords: String, _ page: Int = 1){
        keywordsSearchRequest.keywords = keywords
        keywordsSearchRequest.page = page
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }
    func setKeywoardsSearchFoot(){
        footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(keywordsSearchPullToRequest))
    }
}

// MARK: 上拉加载
extension POIVC{
    @objc func keywordsSearchPullToRequest(){
        currentKeywordsPage = currentKeywordsPage + 1
        makeKeywordsSearch(keyweords, currentKeywordsPage)
        if currentKeywordsPage < pagesCount{
            footer.endRefreshing()
        }else{
            footer.endRefreshingWithNoMoreData()
        }
        
    }
}
