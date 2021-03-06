//
//  MAAPI.swift
//  mala-ios
//
//  Created by 王新宇 on 15/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya
import Result

internal enum MAAPI {
    // account
    case sendSMS(phone: String)
    case verifySMS(phone: String, code: String)
    case userProtocolHTML()
    
    // profile
    case profileInfo(id: Int)
    case parentInfo(id: Int)
    case uploadAvatar(data: Data, profileId: Int)
    case saveStudentName(name: String, parentId: Int)
    case saveSchoolName(name: String, parentId: Int)
    case userCoupons(onlyValid: Bool)
    case getOrderList(page: Int)
    case userNewMessageCount()
    case userCollection(page: Int)
    case addCollection(id: Int)
    case removeCollection(id: Int)
    
    // teacher
    case loadTeachers(condition: JSON?, page: Int)
    case loadTags()
    case loadTeacherDetail(id: Int)
    case evaluationStatus(subjectId: Int)
    case getTeacherAvailableTime(teacherId: Int, schoolId: Int)
    case getTeacherGradePrice(teacherId: Int, schoolId: Int)
    case getConcreteTimeslots(id: Int, hours: Int, timeSlots: [Int])
    
    // live-course
    case getLiveClasses(schoolId: Int?, page: Int)
    case getLiveClassDetail(id: Int)
    
    // schedule&comment
    case getStudentSchedule(onlyPassed: Bool)
    case getCourseInfo(id: Int)
    case createComment(comment: CommentModel)
    case getCommentInfo(id: Int)
    
    // payment&order
    case createOrder(order: JSON)
    case getChargeToken(channel: MalaPaymentChannel, id: Int)
    case getOrderInfo(id: Int)
    case cancelOrder(id: Int)
    
    // study report
    case userStudyReportOverview()
    case userSubjectReport(id: Int)
    
    // region
    case loadRegions()
    case getSchools(regionId: Int?, teacherId: Int?)
    
    // exercise record
    case exerciseMistakes(subject: Int?, page: Int)
}

extension MAAPI: TargetType {
    
    public var baseURL: URL { return MABaseURL }

    public var path: String {
        switch self {
        case .sendSMS, .verifySMS:
            return "/sms"
        case .profileInfo(let id), .uploadAvatar(_, let id):
            return "/profiles/\(id)"
        case .parentInfo(let id), .saveStudentName(_, let id), .saveSchoolName(_, let id):
            return "/parents/\(id)"
        case .userCoupons:
            return "/coupons"
        case .evaluationStatus(let id):
            return "/subject/\(id)/record"
        case .getStudentSchedule:
            return "/timeslots"
        case .getOrderList:
            return "/orders"
        case .userNewMessageCount:
            return "/my_center"
        case .userCollection, .addCollection:
            return "/favorites"
        case .removeCollection(let id):
            return "/favorites/\(id)"
        case .loadTeachers:
            return "/teachers"
        case .loadTeacherDetail(let id):
            return "/teachers/\(id)"
        case .getTeacherAvailableTime(let teacherId, _):
            return "teachers/\(teacherId)/weeklytimeslots"
        case .getTeacherGradePrice(let teacherId, let schoolId):
            return "teacher/\(teacherId)/school/\(schoolId)/prices"
        case .getLiveClasses:
            return "/liveclasses"
        case .getLiveClassDetail(let id):
            return "/liveclasses/\(id)"
        case .getCourseInfo(let id):
            return "timeslots/\(id)"
        case .getConcreteTimeslots:
            return "concrete/timeslots"
        case .createComment:
            return "comments"
        case .getCommentInfo(let id):
            return "comments/\(id)"
        case .createOrder:
            return "/orders"
        case .getChargeToken(_, let id):
            return "/orders/\(id)"
        case .getOrderInfo(let id), .cancelOrder(let id):
            return "/orders/\(id)"
        case .userProtocolHTML:
            return "/policy"
        case .userStudyReportOverview:
            return "/study_report"
        case .userSubjectReport(let id):
            return "/study_report/\(id)"
        case .loadRegions:
            return "/regions"
        case .getSchools:
            return "/schools"
        case .loadTags:
            return "/tags"
        case .exerciseMistakes:
            return "/exercise"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .sendSMS, .verifySMS, .addCollection, .createComment, .createOrder:
            return .post
        case .uploadAvatar, .saveStudentName, .saveSchoolName, .getChargeToken:
            return .patch
        case .removeCollection, .cancelOrder:
            return .delete
        default:
            return .get
        }
    }
    public var parameters: [String : Any]? {
        switch self {
        case .sendSMS(let phone):
            return ["action": "send", "phone": phone]
        case .verifySMS(let phone, let code):
            return ["action": "verify", "phone": phone, "code": code]
        case .saveStudentName(let name, _):
            return ["student_name": name]
        case .saveSchoolName(let name, _):
            return ["student_school_name": name]
        case .userCoupons(let onlyValid):
            return ["only_valid": String(onlyValid)]
        case .getStudentSchedule(let onlyPassed):
            return ["for_review": String(onlyPassed)]
        case .getOrderList(let page), .userCollection(let page):
            return ["page": page]
        case .addCollection(let id):
            return ["teacher": id]
        case .loadTeachers(let condition, let page):
            var params = condition ?? JSON()
            params["page"] = page
            if let city = MalaCurrentCity {
                params["region"] = city.id
            }
            if let school = MalaCurrentSchool {
                params["school"] = school.id
            }
            return params
        case .getTeacherAvailableTime(_, let schoolId):
            return ["school_id": schoolId]
        case .getLiveClasses(let id, let page):
            if let id = id {
                return ["school": id, "page": page]
            }else {
                return ["page": page]
            }
        case .getConcreteTimeslots(let id, let hours, let timeSlots):
            return [
                "teacher": id,
                "hours": hours,
                "weekly_time_slots": timeSlots.map { String($0) }.joined(separator: " ")
            ]
        case .createComment(let comment):
            return [
                "timeslot": comment.timeslot,
                "score": comment.score,
                "content": comment.content
            ]
        case .createOrder(let order):
            return order
        case .getChargeToken(let channel, _):
            return [
                "action": PaymentMethod.Pay.rawValue,
                "channel": channel.rawValue
            ]
        case .getSchools(let regionId, let teacherId):
            
            var params = JSON()
            
            if let id = regionId {
                params["region"] = id
            } else if let region = MalaCurrentCity {
                params["region"] = region.id
            }
            if let teacherId = teacherId {
                params["teacher"] = teacherId
            }
            return params
        case .exerciseMistakes(let subject, let page):
            if let id = subject {
                return ["subject": id, "page": page]
            }else {
                return ["page": page]
            }
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .sendSMS, .verifySMS, .saveStudentName, .saveSchoolName, .addCollection, .createOrder, .getChargeToken:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case .uploadAvatar(let imageData, _):
            return .upload(UploadType.multipart([MultipartFormData(provider: .data(imageData), name: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")]))
        default:
            return .request
        }
    }
}

extension MAAPI: AccessTokenAuthorizable {
    public var shouldAuthorize: Bool {
        switch self {
        case .sendSMS, .verifySMS, .getLiveClasses:
            return false
        case .loadTeacherDetail:
            return MalaUserDefaults.isLogined ? true : false
        default:
            return true
        }
    }
}

extension MAAPI: HUDController {
    public var shouldShowHUD: Bool {
        switch self {
        case .sendSMS, .verifySMS, .loadTeacherDetail, .evaluationStatus, .getTeacherAvailableTime, .getTeacherGradePrice, .getConcreteTimeslots,
             .getLiveClassDetail, .getCourseInfo, .createComment, .getCommentInfo, .createOrder, .getChargeToken, .getOrderInfo,
             .cancelOrder:
            return true
        default:
            return false
        }
    }
}
