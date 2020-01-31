struct GithubIssue: Codable {
    let id: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}

// https://developer.github.com/v3/repos/contents/#response-1
struct GithubCreateFileResponse: Codable {
    struct Content: Codable {
        let htmlURL: String
        
        enum CodingKeys: String, CodingKey {
            case htmlURL = "html_url"
        }
    }
    let content: Content
    
    enum CodingKeys: String, CodingKey {
        case content
    }
}
