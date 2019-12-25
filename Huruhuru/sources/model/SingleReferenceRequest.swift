struct SingleReferenceRequest: GithubRequest {
    
    private let parameter: Parameter
    
    var path: String {
        return "/repos/\(parameter.ownerName)/\(parameter.repositoryName)/git/ref/\(parameter.reference)"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Encodable? {
        return nil
    }
    
    var allHTTPHeaderFields: [String : String]? {
        return [
            "Authorization": "token \(parameter.accessToken)"
        ]
    }
    
    typealias Response = SingleReferenceResponse
    
    init(parameter: Parameter) {
        self.parameter = parameter
    }
}

extension SingleReferenceRequest {
    struct Parameter {
        let ownerName: String
        let repositoryName: String
        let accessToken: String
        let reference: String
    }
    
    struct SingleReferenceResponse: Codable {
        struct Object: Codable {
            let sha: String
        }
        let ref: String
        let object: Object
        
        enum CodingKeys: String, CodingKey {
            case ref
            case object
        }
    }
}
