## Diagnostic

- Pre-edit LSP on `Pic0FiniteStageGlueDataFace.lean` timed out after 60s, still elaborating lines 1-206, with no diagnostics.
- Isolated the exact right-square package-projection proof in a helper module.
- Post-edit LSP timed out after 60s, still elaborating the theorem/proof, with no diagnostics.
- `timeout --signal=TERM --kill-after=30s 20m lake build AlgebraicJacobian.Picard.Pic0FiniteStageGlueDataFaceRightSquare` exited `124`.
- The kernel process remained at about 99% CPU and 7.3 GB RSS through the timeout.
- No `.olean` or `.ilean` was produced.

A package-argument helper cannot materially improve this: it either unfolds the same expensive projection or accepts that equality as a premise, moving the cost back into Face.

Per the lead’s direction, I removed both experimental helper files. `Pic0FiniteStageGlueDataFace.lean` is untouched, there is no source diff, no artifact, and no commit.
