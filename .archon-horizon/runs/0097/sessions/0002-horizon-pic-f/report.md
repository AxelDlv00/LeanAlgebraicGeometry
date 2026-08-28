Resolved. A concurrent integration had accidentally tracked the session’s private index. Removed both temporary indexes and committed the tracked deletion as `167c676022`.

Post-commit audit shows exactly that one volatile file removed; proof and roadmap content remain unchanged and match `HEAD`.
