//
//  NewsViewModel.swift
//  NewsProject
//
//  Created by Zehra Coşkun on 24.05.2023.
//

import Foundation

struct NewsTableViewModel {
    let newList : [News]
}

extension NewsTableViewModel {
    
    func numberOfRowsInSection () -> Int {
        return self.newList.count
    }
    
    func newAtIndexPath ( _ index: Int) -> NewsViewModel {
        let news = self.newList[index]
        return NewsViewModel(news: news)
    }
}

struct NewsViewModel {
    
    let news : News
    var title : String {
        return self.news.title
    }
    var story : String {
        return self.news.story
    }
}
