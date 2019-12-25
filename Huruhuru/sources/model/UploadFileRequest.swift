struct CreateFileRequest: GithubRequest {
    
    private let parameter: Parameter
    
    var path: String {
        return "/repos/\(parameter.ownerName)/\(parameter.repositoryName)/contents/\(parameter.fileName)"
    }
    
    var method: HTTPMethod {
        return .put
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
    
    typealias Response = GithubCreateFileResponse
    
    init(parameter: Parameter) {
        self.parameter = parameter
    }
}

extension CreateFileRequest {
    struct Parameter {
        let ownerName: String
        let repositoryName: String
        let accessToken: String
        let fileName: String
        let body: Body
    }
    
    // https://developer.github.com/v3/repos/contents/#parameters-2
    struct Body: Codable {
        struct Comitter: Codable {
            let name: String
            let email: String
            
            enum CodingKeys: String, CodingKey {
                case name
                case email
            }
        }
        let message, content: String
        let sha, branch: String?
        let comitter: Comitter?
        
        enum CodingKeys: String, CodingKey {
            case message
            case content
            case sha
            case branch
            case comitter
        }
        
        init(message: String, content: String, sha: String? = nil, branch: String?, comitter: Comitter? = nil) {
            self.message = message
            self.content = content
            self.sha = sha
            self.branch = branch
            self.comitter = comitter
        }
    }

}
