import Foundation

public final class RESTCredentialsService: CredentialsService {

    private let client: RESTClient

    public init(tink: Tink) {
        self.client = tink.client
    }

    init(client: RESTClient) {
        self.client = client
    }

    public func credentialsList(completion: @escaping (Result<[Credentials], Error>) -> Void) -> RetryCancellable? {

        let request = RESTResourceRequest<RESTCredentialsList>(path: "/api/v1/credentials/list", method: .get, contentType: .json) { result in
            let result = result.map { $0.credentials.map(Credentials.init) }
            completion(result)
        }

        return client.performRequest(request)
    }

    public func credentials(id: Credentials.ID, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTCredentials>(path: "/api/v1/credentials/\(id.value)", method: .get, contentType: .json) { result in
            let result = result.map(Credentials.init)
            completion(result)
        }

        return client.performRequest(request)
    }

    public func createCredentials(providerID: Provider.ID, refreshableItems: RefreshableItems, fields: [String: String], appUri: URL?, callbackUri: URL?, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable? {

        let body = RESTCreateCredentialsRequest(providerName: providerID.value, fields: fields, callbackUri: callbackUri?.absoluteString, appUri: appUri?.absoluteString, triggerRefresh: nil)

        let parameters: [URLQueryItem]
        if refreshableItems != .all {
            parameters = refreshableItems.strings.map({ .init(name: "items", value: $0) })
        } else {
            parameters = []
        }

        let request = RESTResourceRequest<RESTCredentials>(path: "/api/v1/credentials", method: .post, body: body, contentType: .json, parameters: parameters) { result in
            completion(result.map(Credentials.init))
        }

        return client.performRequest(request)
    }

    public func deleteCredentials(credentialsID: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)", method: .delete, contentType: .json) { (result) in
            completion(result.map { _ in })
        }

        return client.performRequest(request)
    }

    public func updateCredentials(credentialsID: Credentials.ID, providerID: Provider.ID, appUri: URL?, callbackUri: URL?, fields: [String: String], completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable? {
        let body = RESTUpdateCredentialsRequest(providerName: providerID.value, fields: fields, callbackUri: callbackUri?.absoluteString, appUri: appUri?.absoluteString)
        let request = RESTResourceRequest<RESTCredentials>(path: "/api/v1/credentials/\(credentialsID.value)", method: .put, body: body, contentType: .json) { result in
            completion(result.map(Credentials.init))
        }

        return client.performRequest(request)
    }

    public func refreshCredentials(credentialsID: Credentials.ID, refreshableItems: RefreshableItems, optIn: Bool, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        var parameters: [URLQueryItem]
        if refreshableItems != .all {
            parameters = refreshableItems.strings.map({ .init(name: "items", value: $0) })
        } else {
            parameters = []
        }

        if optIn {
            parameters.append(.init(name: "optIn", value: "true"))
        }

        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)/refresh", method: .post, contentType: .json, parameters: parameters) { (result) in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    public func supplementInformation(credentialsID: Credentials.ID, fields: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        let information = RESTSupplementalInformation(information: fields)
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)/supplemental-information", method: .post, body: information, contentType: .json) { (result) in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    public func cancelSupplementInformation(credentialsID: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let information = RESTSupplementalInformation(information: [:])
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)/supplemental-information", method: .post, body: information, contentType: .json) { (result) in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    public func enableCredentials(credentialsID: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)/enable", method: .post, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }
    public func disableCredentials(credentialsID: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)/disable", method: .post, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)

    }
    public func thirdPartyCallback(state: String, parameters: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        let relayedRequest = RESTCallbackRelayedRequest(state: state, parameters: parameters)
        let request = RESTSimpleRequest(path: "/api/v1/credentials/third-party/callback/relayed", method: .post, body: relayedRequest, contentType: .json) { (result) in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    public func manualAuthentication(credentialsID: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {

        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(credentialsID.value)/authenticate", method: .post, contentType: .json) { (result) in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    public func qr(credentialsID: Credentials.ID, completion: @escaping (Result<Data, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<Data>(path: "/api/v1/credentials/\(credentialsID.value)/qr", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }
}
