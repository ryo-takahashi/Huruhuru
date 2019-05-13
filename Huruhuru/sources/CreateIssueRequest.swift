struct CreateIssueRequest: GithubRequest {
    private let ownerName: String
    private let repositoryName: String
    private let parameter: GithubCreateIssueParameter
    
    var path: String {
        return "/repos/\(ownerName)/\(repositoryName)/issues"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: "access_token", value: accessToken)]
    }
    
    var body: Encodable? {
        return parameter
    }
    
    var accessToken: String?
    
    typealias Response = GithubIssue
    
    init(ownerName: String, repositoryName: String, title: String, body: String, accessToken: String?) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.parameter = GithubCreateIssueParameter(title: title, body: body, assignees: [], milestone: nil, labels: [])
        self.accessToken = accessToken
    }
}

struct GithubCreateIssueParameter: Codable {
    let title, body: String
    let assignees: [String]
    let milestone: Int?
    let labels: [String]
}
