protocol TwitterAccessTokenModelProtocol: AnyObject {
    var state: TwitterAccessTokenModelState { get }
    var delegate: TwitterAccessTokenModelDelegate? { get set }

    func fetch()
}


enum TwitterAccessTokenModelState: Equatable {
    case notLoadYet
    case loading
    case loaded(accessToken: String)
    case failed


    var isLoading: Bool {
        switch self {
        case .notLoadYet, .failed, .loaded:
            return false
        case .loading:
            return true
        }
    }


    var accessToken: String? {
        switch self {
        case .notLoadYet, .loading, .failed:
            return nil
        case .loaded(accessToken: let accessToken):
            return accessToken
        }
    }
}


class TwitterAccessTokenModel: TwitterAccessTokenModelProtocol {
    var state: TwitterAccessTokenModelState = .notLoadYet
    private let interactor: TwitterAccessTokenInteractorProtocol
    weak var delegate: TwitterAccessTokenModelDelegate?


    init(interactor: TwitterAccessTokenInteractorProtocol)  {
        self.interactor = interactor
    }


    func fetch() {
        guard !self.state.isLoading else { return }

        self.state = .loading
        self.delegate?.twitterAccessTokenModelStateDidChange(state: self.state)
        interactor.token(with: Constants.Twitter.consumerKey, and: Constants.Twitter.consumerSecret) { [weak self] (accessToken) in
            guard let strongSelf = self else { return }

            guard let accessToken = accessToken else {
                strongSelf.state = .failed
                strongSelf.delegate?.twitterAccessTokenModelStateDidChange(state: strongSelf.state)
                return
            }
            strongSelf.state = .loaded(accessToken: accessToken)
            strongSelf.delegate?.twitterAccessTokenModelStateDidChange(state: strongSelf.state)
        }
    }
}


protocol TwitterAccessTokenModelDelegate: AnyObject {
    func twitterAccessTokenModelStateDidChange(state: TwitterAccessTokenModelState)
}
