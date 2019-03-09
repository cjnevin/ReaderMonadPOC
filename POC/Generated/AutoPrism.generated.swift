// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



import Core


extension AppAction {
    internal enum prism {
        internal static let download = Prism<AppAction, AppAction.Download>(
            preview: { if case .download(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .download(x1) })
        internal static let users = Prism<AppAction, AppAction.Users>(
            preview: { if case .users(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .users(x1) })
    }
}

internal extension Prism where Part == AppAction {
	var download: Prism<Whole, AppAction.Download> {
		return self • AppAction.prism.download
	}
	var users: Prism<Whole, AppAction.Users> {
		return self • AppAction.prism.users
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


extension AppAction.Users {
    internal enum prism {
        internal static let inject = Prism<AppAction.Users, ()>(
            preview: { if case .inject = $0 { return () } else { return nil } },
            review: { .inject })
        internal static let injected = Prism<AppAction.Users, User>(
            preview: { if case .injected(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .injected(x1) })
        internal static let watch = Prism<AppAction.Users, ()>(
            preview: { if case .watch = $0 { return () } else { return nil } },
            review: { .watch })
        internal static let received = Prism<AppAction.Users, [User]>(
            preview: { if case .received(let value) = $0 { return value } else { return nil } },
            review: { (x1) in .received(x1) })
        internal static let failed = Prism<AppAction.Users, ()>(
            preview: { if case .failed = $0 { return () } else { return nil } },
            review: { .failed })
    }
}

internal extension Prism where Part == AppAction.Users {
	var inject: Prism<Whole, Void> {
		return self • AppAction.Users.prism.inject
	}
	var injected: Prism<Whole, User> {
		return self • AppAction.Users.prism.injected
	}
	var watch: Prism<Whole, Void> {
		return self • AppAction.Users.prism.watch
	}
	var received: Prism<Whole, [User]> {
		return self • AppAction.Users.prism.received
	}
	var failed: Prism<Whole, Void> {
		return self • AppAction.Users.prism.failed
	}
}

