import Foundation

final class RESTCredentialsService: CredentialsService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func credentialsList(completion: @escaping (Result<[Credentials], Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTCredentialsList>(path: "/api/v1/credentials/list", method: .get, contentType: .json) { result in
            let result = result.map { $0.credentials.map(Credentials.init) }
            completion(result)
        }

        return client.performRequest(request)
    }

    @discardableResult
    func credentials(id: Credentials.ID, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTCredentials>(path: "/api/v1/credentials/\(id.value)", method: .get, contentType: .json) { result in
            let result = result.map(Credentials.init)
            completion(result)
        }

        return client.performRequest(request)
    }

    @discardableResult
    func create(providerID: Provider.ID, refreshableItems: RefreshableItems, fields: [String: String], appURI: URL?, callbackURI: URL?, completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable? {
        let body = RESTCreateCredentialsRequest(providerName: providerID.value, fields: fields, callbackUri: callbackURI?.absoluteString, appUri: appURI?.absoluteString, triggerRefresh: nil)

        let parameters: [URLQueryItem]
        if refreshableItems != .all {
            parameters = refreshableItems.strings.map { .init(name: "items", value: $0) }
        } else {
            parameters = []
        }

        let request = RESTResourceRequest<RESTCredentials>(path: "/api/v1/credentials", method: .post, body: body, contentType: .json, parameters: parameters) { result in
            completion(result.map(Credentials.init))
        }

        return client.performRequest(request)
    }

    @discardableResult
    func delete(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)", method: .delete, contentType: .json) { result in
            completion(result.map { _ in })
        }

        return client.performRequest(request)
    }

    @discardableResult
    func update(id: Credentials.ID, providerID: Provider.ID, appURI: URL?, callbackURI: URL?, fields: [String: String], completion: @escaping (Result<Credentials, Error>) -> Void) -> RetryCancellable? {
        let body = RESTUpdateCredentialsRequest(providerName: providerID.value, fields: fields, callbackUri: callbackURI?.absoluteString, appUri: appURI?.absoluteString)
        let request = RESTResourceRequest<RESTCredentials>(path: "/api/v1/credentials/\(id.value)", method: .put, body: body, contentType: .json) { result in
            completion(result.map(Credentials.init))
        }

        return client.performRequest(request)
    }

    @discardableResult
    func refresh(id: Credentials.ID, authenticate: Bool, refreshableItems: RefreshableItems, optIn: Bool, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        var parameters: [URLQueryItem]
        if refreshableItems != .all {
            parameters = refreshableItems.strings.map { .init(name: "items", value: $0) }
        } else {
            parameters = []
        }

        if authenticate {
            parameters.append(.init(name: "authenticate", value: "true"))
        }

        if optIn {
            parameters.append(.init(name: "optIn", value: "true"))
        }

        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)/refresh", method: .post, contentType: .json, parameters: parameters) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func addSupplementalInformation(id: Credentials.ID, fields: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let information = RESTSupplementalInformation(information: fields)
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)/supplemental-information", method: .post, body: information, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func cancelSupplementalInformation(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let information = RESTSupplementalInformation(information: [:])
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)/supplemental-information", method: .post, body: information, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func enable(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)/enable", method: .post, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func disable(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)/disable", method: .post, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func thirdPartyCallback(state: String, parameters: [String: String], completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let relayedRequest = RESTCallbackRelayedRequest(state: state, parameters: parameters)
        let request = RESTSimpleRequest(path: "/api/v1/credentials/third-party/callback/relayed", method: .post, body: relayedRequest, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func authenticate(id: Credentials.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable? {
        let request = RESTSimpleRequest(path: "/api/v1/credentials/\(id.value)/authenticate", method: .post, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }

    @discardableResult
    func qrCode(id: Credentials.ID, completion: @escaping (Result<Data, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<Data>(path: "/api/v1/credentials/\(id.value)/qr", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }
}
