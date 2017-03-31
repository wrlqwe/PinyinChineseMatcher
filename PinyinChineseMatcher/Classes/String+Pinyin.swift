//
//  String+Pinyin.swift
//  Pods
//
//  Created by 王儒林 on 2017/3/29.
//
//
import PinYin4Objc_FrameworksSupport

fileprivate let hanyupinyinFormat: HanyuPinyinOutputFormat = {
    let format = HanyuPinyinOutputFormat()!
    format.toneType = ToneTypeWithoutTone
    format.vCharType = VCharTypeWithV
    format.caseType = CaseTypeLowercase
    return format
}()

extension Character {
    var pinyins: [String] {
        guard let unicode = self.unicodeScalarCodePoint() else {
            return []
        }
        let pinyins = PinyinHelper.toHanyuPinyinStringArray(withChar: unicode, with: hanyupinyinFormat) as? [String] ?? []
        return pinyins
    }

    private func unicodeScalarCodePoint() -> unichar?
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        let firstChar = scalars.first!
        return unichar(exactly: firstChar.value)
    }
}
