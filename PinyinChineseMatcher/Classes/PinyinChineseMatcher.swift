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
//    case mixedCheck

    fileprivate func check(pinyinToCheck: String, pinyin: String, allowBreak: Bool = true) -> (passed: Bool, remains: String) {
        switch self {
        case .fullCheck:
            let pass = pinyinToCheck.hasPrefix(pinyin)
            if !pass {
                if pinyin.hasPrefix(pinyinToCheck) && allowBreak {
                    return (true, "")
                }
                return (false, "")
            }
            let matchRemains = pinyinToCheck.substring(from: pinyinToCheck.index(pinyinToCheck.startIndex, offsetBy: pinyin.characters.count))
            return (true, matchRemains)
        case .shorthandCheck:
            var first: String = ""
            var firstTwo: String?
            if pinyinToCheck.characters.count >= 2 {
                let twoChars = pinyinToCheck.substring(to: pinyinToCheck.index(pinyinToCheck.startIndex, offsetBy: 2))
                if ["zh", "ch", "sh"].contains(twoChars) {
                    firstTwo = twoChars
                }
            }
            if pinyinToCheck.characters.count >= 1 {
                first = pinyinToCheck.substring(to: pinyinToCheck.index(pinyinToCheck.startIndex, offsetBy: 1))
            }
            if let firstTwo = firstTwo, pinyin.hasPrefix(firstTwo) {
                let matchRemains = pinyinToCheck.substring(from: pinyinToCheck.index(pinyinToCheck.startIndex, offsetBy: 2))
                print("match2: \(firstTwo) for pinyinToCheck: \(pinyinToCheck) pinyin: \(pinyin)")
                return (true, matchRemains)
            } else if pinyin.hasPrefix(first) {
                let matchRemains = pinyinToCheck.substring(from: pinyinToCheck.index(pinyinToCheck.startIndex, offsetBy: 1))
                print("match1: \(first) for pinyinToCheck: \(pinyinToCheck) pinyin: \(pinyin)")
                return (true, matchRemains)
            } else {
                return (false, "")
            }
        }
    }
}

public class PinyinChineseMatcher {
    public class func match(chineseToMatch: String, pinyinToMatch: String) -> [NSRange] {
        var matches = match(chineseToMatch: chineseToMatch, pinyinToMatch: pinyinToMatch, matchType: .fullCheck)
        let shorthandMatch = match(chineseToMatch: chineseToMatch, pinyinToMatch: pinyinToMatch, matchType: .shorthandCheck)
        matches.append(contentsOf: shorthandMatch)
        return matches
    }
    public class func match(chineseToMatch: String, pinyinToMatch: String, matchType: PinyinChineseMatchType) -> [NSRange] {
        guard pinyinToMatch.characters.count > 0 else {
            return []
        }
        guard chineseToMatch.characters.count > 0 else {
            return []
        }

        let chinesePinyins = chineseToMatch.characters.map { $0.pinyins }
        var rangesSearched: [NSRange] = []
        var matchRemains = pinyinToMatch

        var searchStarted = false
        var startIndex = 0
        var currentIndex = 0

        outLoop: while currentIndex < chinesePinyins.count {
            let pinyins = chinesePinyins[currentIndex]
            let index = currentIndex
            var currentMatched = false

            print("matching index: \(index), pinyins: \(pinyins)")
            innerLoop: for pinyin in pinyins {
                let checkResult = matchType.check(pinyinToCheck: matchRemains, pinyin: pinyin)
                if checkResult.passed {
                    currentMatched = true
                }

                if checkResult.passed && !searchStarted {
                    matchRemains = checkResult.remains
                    if matchRemains.isEmpty {
                        rangesSearched.append(NSRange(location: index, length: 1))
                        matchRemains = pinyinToMatch
                        currentIndex = currentIndex + 1
                        continue outLoop
                    } else {
                        searchStarted = true
                        startIndex = index
                        break innerLoop
                    }

                } else if checkResult.passed {
                    matchRemains = checkResult.remains
                    if matchRemains.isEmpty {
                        searchStarted = false
                        currentIndex = currentIndex + 1
                        rangesSearched.append(NSRange(location: startIndex, length: index - startIndex + 1))
                        matchRemains = pinyinToMatch
                        continue outLoop
                    } else {
                        break innerLoop
                    }
                }
            }
            if !currentMatched {
                if searchStarted {
                    currentIndex = startIndex
                }
                searchStarted = false
                matchRemains = pinyinToMatch
            }
            currentIndex = currentIndex + 1
        }

        return rangesSearched
    }
}
