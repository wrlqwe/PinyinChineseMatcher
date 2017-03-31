//
//  PinyinChineseMatcher.swift
//  Pods
//  
//  Created by 王儒林 on 2017/3/29.
//
//
import Foundation

public enum PinyinChineseMatchType: Int {
    case fullCheck
    case shorthandCheck
    case mixedCheck

    fileprivate func check(pinyinToCheck: String, pinyin: String) -> (passed: Bool, remains: String) {
        let pass = pinyinToCheck.hasPrefix(pinyin)
        if !pass {
            return (false, "")
        }
        let matchRemains = pinyinToCheck.substring(from: pinyinToCheck.index(pinyinToCheck.startIndex, offsetBy: pinyin.characters.count))
        return (true, matchRemains)
    }
}

public class PinyinChineseMatcher {
    public class func match(chineseToMatch: String, pinyinToMatch: String) -> [NSRange] {
        return match(chineseToMatch: chineseToMatch, pinyinToMatch: pinyinToMatch, matchType: .fullCheck)
    }
    public class func match(chineseToMatch: String, pinyinToMatch: String, matchType: PinyinChineseMatchType) -> [NSRange] {
        let chinesePinyins = chineseToMatch.characters.map { $0.pinyins }
        var rangesSearched: [NSRange] = []
        var matchRemains = pinyinToMatch

        var searchStarted = false
        var startIndex = 0
        chinesePinyins.enumerated().forEach { index, pinyins in
            print("match index: \(index), pinyins: \(pinyins)")
            for pinyin in pinyins {
                print("current pinyin: \(pinyin)")
                print("current match: \(matchRemains)")
                let checkResult = matchType.check(pinyinToCheck: matchRemains, pinyin: pinyin)
                if checkResult.passed && !searchStarted {
                    matchRemains = checkResult.remains
                    print("match:\(pinyin), remain:\(matchRemains)")
                    if matchRemains.isEmpty {
                        searchStarted = false
                        rangesSearched.append(NSRange(location: index, length: 1))
                        matchRemains = pinyinToMatch
                    } else {
                        searchStarted = true
                        startIndex = index
                    }
                    return
                } else if checkResult.passed {
                    matchRemains = checkResult.remains
                    if matchRemains.isEmpty {
                        searchStarted = false
                        rangesSearched.append(NSRange(location: startIndex, length: index - startIndex + 1))
                        matchRemains = pinyinToMatch
                    }
                    return
                } else if searchStarted {
                    searchStarted = false
                    matchRemains = pinyinToMatch
                }
            }
        }

        return rangesSearched
    }
}
