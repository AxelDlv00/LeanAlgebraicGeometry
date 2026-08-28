No source changes or commit. File was restored exactly; its targeted git diff/status is clean.

Diagnosis:
- Clean single-thread `lake env lean` timed out at 180s without output or `.olean`.
- LSP also timed out after 30s.
- Temporary stubs localized cost to `scalarExtensionFacePackage` (lines 51–128) plus the later dependent package/theorem interfaces; even the finite package stub remained slow.
- The package-only native probe was stopped at 90s per cutoff.

Stopped all FaceReflection processes I started.
