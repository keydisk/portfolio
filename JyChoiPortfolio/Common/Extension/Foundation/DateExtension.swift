//
//  DateExtension.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import Foundation

// MARK: - 데이트 타입 기능 확장
extension Date {
    func toUTC( dateFormat format: String ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }
    
    static let oneDaySeconds: TimeInterval = 86400
    
    /// 문자열과 포맷으로 Date 생성
    public init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = .current
        
        if let date = formatter.date(from: string) {
            self = date
        } else {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "ko_kr")
            RFC3339DateFormatter.dateFormat = format
            RFC3339DateFormatter.timeZone = .current
            
            if let date = RFC3339DateFormatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        }
    }
    
    static func getDateFromFormat(fromString string: String, format: String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = .current
        
        if let date = formatter.date(from: string) {
            return date
        } else {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "ko_kr")
            RFC3339DateFormatter.dateFormat = format
            RFC3339DateFormatter.timeZone = .current
            
            if let date = RFC3339DateFormatter.date(from: string) {
                return date
            } else {
                return nil
            }
        }
    }
    
    
    /// 현재 시간 가져오기
    ///
    /// - Returns: 현재시간 Date객체
    static func getCurrentDate() -> Date {
        
        let sourceDate = Date()
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = NSTimeZone.system
        
        let sourceGMTOffsetOffset     = sourceTimeZone?.secondsFromGMT(for: sourceDate)
        let destinationTimeZoneOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let dInterval = destinationTimeZoneOffset - sourceGMTOffsetOffset!
        
        let destinationDate = Date(timeInterval: TimeInterval(dInterval), since: sourceDate)
        
        return destinationDate
    }
    
    static func getCurrentDateKor() -> Date {
        
        let sourceDate = Date()
        let sourceTimeZone = TimeZone(abbreviation: "KST")
        let destinationTimeZone = NSTimeZone.system
        
        let sourceGMTOffsetOffset     = sourceTimeZone?.secondsFromGMT(for: sourceDate)
        let destinationTimeZoneOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let dInterval = destinationTimeZoneOffset - sourceGMTOffsetOffset!
        
        let destinationDate = Date(timeInterval: TimeInterval(dInterval), since: sourceDate)
        
        return destinationDate
    }
    
    
    /// 현재 시간 가져오기
    ///
    /// - Returns: 현재시간 Date객체
    var currentDate: Date {
        
        let sourceDate = Date()
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = NSTimeZone.system
        
        let sourceGMTOffsetOffset     = sourceTimeZone?.secondsFromGMT(for: sourceDate)
        let destinationTimeZoneOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let dInterval = destinationTimeZoneOffset - sourceGMTOffsetOffset!
        
        let destinationDate = Date(timeInterval: TimeInterval(dInterval), since: sourceDate)
        
        return destinationDate
    }
    
    /// 현재 위치 시간으로 전환 후 리턴
    ///
    /// - Returns: 전환된 시간
    var convertLocalDate: Date {
        
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = NSTimeZone.system
        
        let sourceGMTOffsetOffset     = sourceTimeZone?.secondsFromGMT(for: self)
        let destinationTimeZoneOffset = destinationTimeZone.secondsFromGMT(for: self)
        let dInterval = destinationTimeZoneOffset - sourceGMTOffsetOffset!
        
        let destinationDate = Date(timeInterval: TimeInterval(dInterval), since: self)
        
        return destinationDate
    }
  
    /// 년월일 로만 비교
    public func compareOnlyDate(date: Date) -> ComparisonResult {
        
        let firstDate  = String(format: "%d%02d%02d", self.year, self.month, self.day)
        let secondDate = String(format: "%d%02d%02d", date.year, date.month, date.day)
        
        if firstDate.numberWithInt == secondDate.numberWithInt {
            return .orderedSame
        }
        else if firstDate.numberWithInt < secondDate.numberWithInt {
            return .orderedAscending
        }
        else {
            return .orderedDescending
        }
    }
    
    /// Date 를 포맷에 해당하는 문자열로 반환한다
    ///
    /// - Parameter format: date변환 포맷
    /// - Returns: date 문자열
    public func toString(format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko")
        
        return formatter.string(from: self)
    }
    
    /// Date 를 포맷에 해당하는 문자열로 반환한다
    public func toLocalizedString(format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }
    
    /// Locale 에 따른 기본 날짜 표시
    public func toDefaultLocalizedString() -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
    /// 해당 날짜가 두 날짜 사이에 있는지 확인
    public func isBetween(startDate: Date, endDate: Date) -> Bool {
        
        return startDate.compare(self) == self.compare(endDate)
    }
    
    /// 해당 날짜 사이의 분
    public func isBetweenMinutes(_ endDate: Date) -> Int {
        
        return Int((self.timeIntervalSinceNow - endDate.timeIntervalSinceNow) / 60)
    }
    
    /// 날짜 차이
    ///
    /// - Parameters:
    ///   - anotherDay: 비교 날짜
    /// - Returns: 계산된 날짜
    public func getIntervalDays(anotherDay: Date? = nil) -> Double {
        
        var interval: Double!
        
        if anotherDay == nil {
            interval = self.timeIntervalSinceNow
        }
        else {
            interval = self.timeIntervalSince(anotherDay!)
        }
        
        let r = interval / 86400
        
        return floor(r)
    }
    
    /// 날짜 객체 생성
    ///
    /// - Parameter text: 텍스트
    /// - Returns: 계산된 날짜
    public static func makeDateFromDateText(text: String) -> Date? {
        
//        Date(fromString: insTimestamp.substring(startIndex: 0, length: 19), format: "yyyy-MM-dd HH:mm:ss")
        var dateComponent = DateComponents()
        
        dateComponent.year  = 2018
        dateComponent.month = 6
        dateComponent.day   = 20
        dateComponent.hour  = 15
        dateComponent.minute = 30
        dateComponent.second = 0
        
        let date = Calendar.current.date(from: dateComponent)
        
        return date
    }
}

extension Date{
    
    //Function will return the current year
    /// yyyyMMdd 형태의 문자열로 리턴
    var yearMonthDay: String {
        return String(format: "%d%02d%02d", self.year, self.month, self.day)
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func getMonthList(_ endDate: Date) -> [Date] {
        
//        debugPrint("endDate : \(endDate)")
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(Set([.month]), from: self, to: endDate)
        
        var allDates: [Date] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "yyyyMM"
        
        let endIndex = self.day != endDate.day ? (components.month ?? 0) + 1 : (components.month ?? 0)
//        debugPrint("endIndex : \(endIndex)")
        for i in 0...endIndex {
            guard let date = calendar.date(byAdding: .month, value: i, to: self) else {
                continue
            }
            let endDateText = String(format: "%d%02d", endDate.year, endDate.month)
            let compareDateText = String(format: "%d%02d", date.year, date.month)
            
            if compareDateText.numberWithInt <= endDateText.numberWithInt {
                allDates += [date]
            }
        }
        
        return allDates
    }
    
    func  getYear() -> Int {
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return year
    }
    
    var  year: Int {
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return year
    }
    
    func  getMonth() -> Int {
        
        let calendar = Calendar.current
        let component = calendar.component(.month, from: self)
        return component
    }
    
    var month: Int {
        
        let calendar = Calendar.current
        let component = calendar.component(.month, from: self)
        return component
    }
    
    func  getDay() -> Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.day, from: self)
        return component
    }
    
    var  day: Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.day, from: self)
        return component
    }
    
    func  getHour() -> Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.hour, from: self)
        return component
    }
    
    var  hour: Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.hour, from: self)
        return component
    }
    
    func  getMinutes() -> Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.minute, from: self)
        return component
    }
    
    var  minutes: Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.minute, from: self)
        return component
    }
    
    func  getSecond() -> Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.minute, from: self)
        return component
    }
    
    var second: Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.second, from: self)
        return component
    }
    
    /// 요일
//    public var weekdayInt: Int {
//
//        return Calendar.current.component(.weekday, from: self)
//    }
    
    func  getWeekDay() -> Int {
        
        let calendar = Calendar.current
        let component = calendar.component(.weekday, from: self)
        return component
    }
    
    /// 두 날짜간의 일수 차이
    func dailyDiffence(compareDate: Date) -> Int? {
        
        return NSCalendar.current.dateComponents([.day], from: compareDate, to: self).day
    }
    
    /// 두 날짜간의 월 차이
    func dayDiffence(compareDate: Date) -> Int? {
        
        return NSCalendar.current.dateComponents([.month], from: compareDate, to: self).month
    }
    
    /// 전달 가져오기
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    /// 휴일인지 아닌지
    var isHoliday: Int {
        if self.getWeekDay() == 1 || self.getWeekDay() == 7 {
            return 1
        }
        
        return 0
    }
    
    func addMonth(_ addMonth: Int) -> Date {
        
        let date = Calendar.current.date(byAdding: .month, value: addMonth, to: self )
        
        return date ?? Date()
    }
    
    func addDay(_ addDay: Int) -> Date {
        
        let date = Calendar.current.date(byAdding: .day, value: addDay, to: self )
        
        return date ?? Date()
    }
    
    /// 이달의 첫번째 날
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// 이달의 마지막 날
    func endOfMonth() -> Date {
        
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: 0), to: self.startOfMonth())!
    }
    
    
    /// 년 월 일 비교
    ///
    /// - Parameter rightTarget: right target
    /// - Returns: orderedDescending <- 좌변이 더 작음, orderedSame <- 같음, orderedAscending <- 우변이 더 큼
    func compareDateOnlyYearMonthDay(rightTarget: Date) -> ComparisonResult {
        
        let leftDate  = String(format: "%d%02d%02d", self.year, self.month, self.day)
        let rightDate = String(format: "%d%02d%02d", rightTarget.year, rightTarget.month, rightTarget.day)
        
        if (UInt64(leftDate) ?? 0) < (UInt64(rightDate) ?? 0) {
            return .orderedDescending
        } else if (UInt64(leftDate) ?? 0) == (UInt64(rightDate) ?? 0) {
            return .orderedSame
        }
        
        return .orderedAscending
    }
    
    
    /// 년, 월, 일로만 같은지 비교
    ///
    /// - Parameter compareDate: 비교 날짜
    /// - Returns: nil 같음, false <- compareDate이 더 작음, true <- compareDate이 더 큼
    func isBigCompareDate(compareDate: Date) -> Bool? {
        
        let leftDate  = String(format: "%d%02d%02d", self.year, self.month, self.day)
        let rightDate = String(format: "%d%02d%02d", compareDate.year, compareDate.month, compareDate.day)
        
        if (UInt64(leftDate) ?? 0) == (UInt64(rightDate) ?? 0) {
//            debugPrint("date nil")
            return nil
        } else if (UInt64(leftDate) ?? 0) < (UInt64(rightDate) ?? 0) {
            return true
        } else {
//            debugPrint("date false")
            return false
        }
    }
    
    /// 현재 시간에 분을 더한다
    /// - Parameter minutes: 더할 분
    /// - Returns:분이 더해진 날짜 (optional)
    func addMinutes(minutes: Int) -> Date? {
        
        let date = Calendar.current.date(byAdding: .minute, value: minutes, to: self)
        return date
    }
    
    /// 현재 시간에 분을 더한다
    /// - Parameter minutes: 더할 분
    /// - Returns:분이 더해진 날짜 (optional)
    func minusMinutes(minutes: Int) -> Date? {
        
        let date = Calendar.current.date(byAdding: .minute, value: minutes * -1, to: self)
        
        return date
    }
    
    //MARK: - 연산자 오버로딩
    
    /// Date에서 Date를 뺐을때의 값을 날짜로 반환 (날짜 : Day)
    ///
    /// - Returns: 날짜 차이 (날짜 : Day)
    static func -(leftTarget: Date, rightTarget: Date) -> TimeInterval {
        
        return (leftTarget.timeIntervalSinceReferenceDate - rightTarget.timeIntervalSinceReferenceDate) / Date.oneDaySeconds
    }
    
    /// Date에서 Date를 뺐을때의 값을 날짜로 반환 (날짜 : Day)
    ///
    /// - Returns: 날짜 차이 (날짜 : Day)
    static func -(leftTarget: Date, rightValue: Int) -> Date {
        
        let value = rightValue * -1
        let date = Calendar.current.date(byAdding: .day, value: value, to: leftTarget)
        
        return date!
    }
    
    /// 현재 날짜에서 파라매터로 전달된 날짜 만큼을 뺀다
    ///
    /// - Parameter removeDay: Day
    /// - Returns: removeDay를 뺀 Date객체
    func removeDay(_ removeDay: Int) -> Date {
        let date = Date(timeIntervalSinceReferenceDate: (self.timeIntervalSinceReferenceDate - (TimeInterval(removeDay) * Date.oneDaySeconds) ) )
        
        return date
    }
    
    /// 날짜끼리 더한다. ex) 2018-08-01 + 4 = 2018-08-05
    ///
    /// - Returns:
    static func +(leftTarget: Date, rightTarget: Int) -> Date {
        
        let date = Calendar.current.date(byAdding: .day, value: rightTarget, to: leftTarget)

        return date!
    }
    
    static func <(leftTarget: Date, rightTarget: Date) -> Bool {
        
        let leftDate = String(format: "%d%02d%02d%02d%02d%02d", leftTarget.year, leftTarget.month, leftTarget.day, leftTarget.hour, leftTarget.minutes, leftTarget.second)
        let rightDate = String(format: "%d%02d%02d%02d%02d%02d", rightTarget.year, rightTarget.month, rightTarget.day, rightTarget.hour, rightTarget.minutes, rightTarget.second)
        
        return (UInt64(leftDate) ?? 0) < (UInt64(rightDate) ?? 0)
    }
    
    static func <=(leftTarget: Date, rightTarget: Date) -> Bool {
        
        let leftDate = String(format: "%d%02d%02d%02d%02d%02d", leftTarget.year, leftTarget.month, leftTarget.day, leftTarget.hour, leftTarget.minutes, leftTarget.second)
        let rightDate = String(format: "%d%02d%02d%02d%02d%02d", rightTarget.year, rightTarget.month, rightTarget.day, rightTarget.hour, rightTarget.minutes, rightTarget.second)
        
        return (UInt64(leftDate) ?? 0) <= (UInt64(rightDate) ?? 0)
    }
    
    static func >(leftTarget: Date, rightTarget: Date) -> Bool {
        
        let leftDate = String(format: "%d%02d%02d%02d%02d%02d", leftTarget.year, leftTarget.month, leftTarget.day, leftTarget.hour, leftTarget.minutes, leftTarget.second)
        let rightDate = String(format: "%d%02d%02d%02d%02d%02d", rightTarget.year, rightTarget.month, rightTarget.day, rightTarget.hour, rightTarget.minutes, rightTarget.second)
        
        return (UInt64(leftDate) ?? 0) > (UInt64(rightDate) ?? 0)
    }
    
    static func >=(leftTarget: Date, rightTarget: Date) -> Bool {
        
        let leftDate = String(format: "%d%02d%02d%02d%02d%02d", leftTarget.year, leftTarget.month, leftTarget.day, leftTarget.hour, leftTarget.minutes, leftTarget.second)
        let rightDate = String(format: "%d%02d%02d%02d%02d%02d", rightTarget.year, rightTarget.month, rightTarget.day, rightTarget.hour, rightTarget.minutes, rightTarget.second)
        
        return (UInt64(leftDate) ?? 0) >= (UInt64(rightDate) ?? 0)
    }
}
