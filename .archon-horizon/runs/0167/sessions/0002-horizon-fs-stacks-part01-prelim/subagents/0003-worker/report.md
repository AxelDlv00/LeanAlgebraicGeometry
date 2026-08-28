Implemented `StacksPart01Lib/Categories.lean` with five sorry-free declarations:

- `isIso_iff_exists_inverse`
- `inverse_unique`
- `isGroupoid_iff_all_isIso`
- `isIso_mono_of`
- `isIso_epi_of`

LSP diagnostics and outline checks are clean, and the final `horizon check --lean StacksPart01Lib/Categories.lean` passes. No `Basic.lean` or blueprint files were modified.

Commit: `338be92e14`. Note: shared staging was polluted, so this commit also includes pre-existing `.archon-horizon` and run-0163 artifacts; I notified `/root` and did not revert them.
