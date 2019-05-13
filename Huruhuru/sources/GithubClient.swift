import Foundation

struct GithubAPIError: Decodable, Error {
    
}

enum GithubClientError: Error {
    case connectionError(Error)
    case responseParseError(Error)
    case apiError(GithubAPIError)
}

class GithubClient {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    func send<Request: GithubRequest>(
        request: Request,
        completion: @escaping (Result<Request.Response, GithubClientError>) -> Void) {
        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(Result.failure(.connectionError(error)))
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(Result.success(response))
                } catch let error as GithubAPIError {
                    completion(Result.failure(.apiError(error)))
                } catch {
                    completion(Result.failure(.responseParseError(error)))
                }
            default:
                fatalError("invaild response combination \(String(describing: data)), \(String(describing: response)), \(String(describing: error))")
            }
        }
        
        task.resume()
    }
}
