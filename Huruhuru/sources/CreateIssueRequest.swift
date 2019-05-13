struct CreateIssueRequest: GithubRequest {
    
    private let ownerName: String
    private let repositoryName: String
    
    var path: String {
        return "/repos/\(ownerName)/\(repositoryName)/issues"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Encodable?
    
    typealias Response = GithubIssue
    
    init(ownerName: String, repositoryName: String) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
    }
}
