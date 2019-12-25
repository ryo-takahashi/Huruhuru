struct CreateReferenceRequest: GithubRequest {
    
    private let parameter: Parameter
    
    var path: String {
        return "/repos/\(parameter.ownerName)/\(parameter.repositoryName)/git/refs"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Encodable? {
        return parameter.body
    }
    
    var allHTTPHeaderFields: [String : String]? {
        return [
            "Authorization": "token \(parameter.accessToken)"
        ]
    }
    
    typealias Response = CreateReferenceResponse
    
    init(parameter: Parameter) {
        self.parameter = parameter
    }
}

extension CreateReferenceRequest {
    struct Parameter {
        let ownerName: String
        let repositoryName: String
        let accessToken: String
        let body: Body
    }
    
    struct Body: Codable {
        let ref: String
        let sha: String
        
        enum CodingKeys: String, CodingKey {
            case ref
            case sha
        }
    }
    
    struct CreateReferenceResponse: Codable {
        let ref: String
        
        enum CodingKeys: String, CodingKey {
            case ref
        }
    }
}
