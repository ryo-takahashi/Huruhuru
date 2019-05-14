struct GithubIssue: Codable {
    let id: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}
