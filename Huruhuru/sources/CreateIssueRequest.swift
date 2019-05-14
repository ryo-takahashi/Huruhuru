struct CreateIssueRequest: GithubRequest {
    
    private let ownerName: String
    private let repositoryName: String
    private let parameter: GithubCreateIssueParameter
    private let accessToken: String
    
    var path: String {
        return "/repos/\(ownerName)/\(repositoryName)/issues"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Encodable? {
        return parameter
    }
    
    var allHTTPHeaderFields: [String : String]? {
        return [
            "Authorization": "token \(accessToken)"
        ]
    }
    
    typealias Response = GithubIssue
    
    init(ownerName: String, repositoryName: String, title: String, body: String, accessToken: String) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.parameter = GithubCreateIssueParameter(title: title, body: body, assignees: [], milestone: nil, labels: [], accessToken: accessToken)
        self.accessToken = accessToken
    }
}

struct GithubCreateIssueParameter: Codable {
    let title, body: String
    let assignees: [String]
    let milestone: Int?
    let labels: [String]
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case assignees
        case milestone
        case labels
        case accessToken = "access_token"
    }
}
