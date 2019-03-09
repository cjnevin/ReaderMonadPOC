// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



import Core


extension AppAction {
    internal enum prism {
        internal static let download = Prism<AppAction, AppAction.Download>(
            preview: { if case .download(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .download(x1) })
        internal static let login = Prism<AppAction, AppAction.Login>(
            preview: { if case .login(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .login(x1) })
    }
}

internal extension Prism where Part == AppAction {
	var download: Prism<Whole, AppAction.Download> {
		return self • AppAction.prism.download
	}
	var login: Prism<Whole, AppAction.Login> {
		return self • AppAction.prism.login
	}
}


extension AppAction.Download {
    internal enum prism {
        internal static let start = Prism<AppAction.Download, ()>(
            preview: { if case .start = $0 { return () } else { return nil } },
            review: { .start })
        internal static let complete = Prism<AppAction.Download, ()>(
            preview: { if case .complete = $0 { return () } else { return nil } },
            review: { .complete })
        internal static let failed = Prism<AppAction.Download, ()>(
            preview: { if case .failed = $0 { return () } else { return nil } },
            review: { .failed })
    }
}

internal extension Prism where Part == AppAction.Download {
	var start: Prism<Whole, Void> {
		return self • AppAction.Download.prism.start
	}
	var complete: Prism<Whole, Void> {
		return self • AppAction.Download.prism.complete
	}
	var failed: Prism<Whole, Void> {
		return self • AppAction.Download.prism.failed
	}
}


extension AppAction.Login {
    internal enum prism {
        internal static let send = Prism<AppAction.Login, ()>(
            preview: { if case .send = $0 { return () } else { return nil } },
            review: { .send })
        internal static let success = Prism<AppAction.Login, User>(
            preview: { if case .success(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .success(x1) })
        internal static let failed = Prism<AppAction.Login, ()>(
            preview: { if case .failed = $0 { return () } else { return nil } },
            review: { .failed })
    }
}

internal extension Prism where Part == AppAction.Login {
	var send: Prism<Whole, Void> {
		return self • AppAction.Login.prism.send
	}
	var success: Prism<Whole, User> {
		return self • AppAction.Login.prism.success
	}
	var failed: Prism<Whole, Void> {
		return self • AppAction.Login.prism.failed
	}
}

