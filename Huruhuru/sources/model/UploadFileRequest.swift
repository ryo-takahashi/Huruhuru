struct CreateFileRequest: GithubRequest {
    
    private let ownerName: String
    private let repositoryName: String
    private let parameter: GithubCreateFileParameter
    private let accessToken: String
    private let fileName: String
    
    var path: String {
        return "/repos/\(ownerName)/\(repositoryName)/contents/\(fileName)"
    }
    
    var method: HTTPMethod {
        return .put
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
    
    typealias Response = GithubCreateFileResponse
    
    init(ownerName: String, repositoryName: String, accessToken: String, fileName: String, uploadData: Data) {
        self.ownerName = ownerName
        self.repositoryName = repositoryName
        self.parameter = GithubCreateFileParameter(message: "upload \(fileName) from huruhuru", content: uploadData.base64EncodedString(), sha: nil, branch: "huruhuru-upload-image", comitter: nil)
        self.accessToken = accessToken
        self.fileName = fileName
    }
}

// https://developer.github.com/v3/repos/contents/#parameters-2
struct GithubCreateFileParameter: Codable {
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
}
