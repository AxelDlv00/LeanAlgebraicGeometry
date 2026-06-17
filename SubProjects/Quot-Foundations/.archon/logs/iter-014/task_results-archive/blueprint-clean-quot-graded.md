# Blueprint-clean report — Picard_QuotScheme.tex (post graded-API writer)
## Subagent: blueprint-clean / slug: quot-graded / Iter 014

### Summary

All tasks completed. File: `blueprint/src/chapters/Picard_QuotScheme.tex`.

---

### 1. Lean-syntax leakage stripped

The following raw Lean identifiers were present in **displayable prose** (outside `\lean{}`, `\mathlibok`, and `%` comments) and have been replaced with mathematical language:

| Lean identifier | Location | Replacement |
|---|---|---|
| `\mathrm{DirectSum.Decomposition}` | G1 stmt, G1 proof, G2 stmt, G2 proof, G3 proof, G4 proof | "internal direct sum decomposition" |
| `\mathrm{SetLike.GradedSMul}` | intro prose, G1 stmt, G1 proof, G2 stmt, G2 proof, G4 stmt, G4 proof, `lem:isHomogeneousElem_graded_smul_mathlib` | "graded scalar multiplication" |
| `\mathrm{QuotSMulTop}\,x\,M` | G2 stmt, G2 proof, `lem:quotSMulTop_mathlib` formula, main proof | `M/xM` |
| `p.\mathrm{mkQ}` / `\mathrm{mkQ}` | G2 stmt, G2 proof | "the quotient map `M → M/p`" / component formula |
| `\mathrm{Ideal.Quotient.mk}\,(x)` | G3 stmt, G3 proof | "the quotient ring homomorphism" |
| `\mathrm{GradedRing}` | G3 stmt, G3 proof (×2) | "graded ring" |
| `\mathrm{HomogeneousSubmodule}\,\mathcal{A}\,\mathcal{M}` | `lem:submodule_isHomogeneous_mathlib` | "homogeneous submodule type" |
| `\mathrm{SetLike}` | `lem:submodule_isHomogeneous_mathlib` | "order and extensionality structure" |
| `p.\mathrm{IsHomogeneous}\,\mathcal{M}` | `lem:submodule_isHomogeneous_mathlib` | parenthetical removed |
| `(\top : \mathrm{Submodule}\,R\,M)` | `lem:quotSMulTop_mathlib` formula | removed (formula simplified to `M/xM`) |
| `\mathrm{HomogeneousIdeal}` / `\mathrm{GradedRing}` API | section intro | sentence rewritten to mathematical language |

Identifiers remaining in `\lean{...}` fields, `\mathlibok` blocks, `\texttt{...}` import paths, and `%` comments are **correctly left untouched**.

---

### 2. Project-history / prover-scheduling verbosity removed

- **Removed**: The `\emph{Build order.}` paragraph (was lines 773–778) that described discharge order using prover-scheduling language ("most cheaply discharged", "carry the least risk", "unblock the most"). This is prover-coordination advice, not mathematical content.
- **No other** iter-N, "prover", or "next-iter" phrases found in displayable prose. (One `% NOTE` comment at line 433 mentioning "the prover" was in a `%` comment and correctly left in place.)

---

### 3. `\label` / `\lean` / `\uses` well-formedness

**`\uses` addition.** The proof of `lem:gradedHilbertSerre_rational` directly `\cref`-cites `lem:ideal_homogeneous_span_mathlib` at the inductive step ("that \((x)\) is homogeneous (\cref{...})"), but that label was absent from the proof's `\uses` list. Added:

```latex
\uses{..., lem:ideal_homogeneous_span_mathlib, ...}
```

**Chain connectivity.** All new `subsec:gradedModuleApi` nodes are `\uses`-linked into `lem:gradedHilbertSerre_rational` (either directly in its proof's `\uses`, or through the G/D chain that the proof's `\uses` already covers):

- 6 Mathlib anchors → each consumed by ≥ 1 G/D block  
- G1–G5 and D5 → each in the main proof's `\uses`  
- No isolated nodes.

**`\label` / `\lean` format.** All new labels follow the `lem:graded_*` convention; no malformed `\label`, `\lean`, or `\uses` syntax found.

---

### 4. `% SOURCE` / `% SOURCE QUOTE` blocks

Verified for the new `subsec:gradedModuleApi`:
- The Mathlib-anchor blocks (G1–G5, D5, 6 `\mathlibok` pins) are project-internal helpers over Stacks 00K1. They correctly carry no `% SOURCE` block (no external citation needed).
- The parent `lem:gradedHilbertSerre_rational` already has its `% SOURCE QUOTE` (Stacks Tag 00K1) and `% SOURCE QUOTE PROOF` blocks intact and accurate. No changes were needed.
- All other `% SOURCE QUOTE` blocks in the chapter were inspected and found accurate (Nitsure §1, Stacks, Hartshorne citations with verbatim quotes from `references/`).

---

### 5. Mathematical statements

No mathematical statements were altered. All edits were cosmetic (prose language, `\uses` metadata, removal of Lean identifiers from rendered text).

---

### Files modified

- `blueprint/src/chapters/Picard_QuotScheme.tex` (all edits above)

### Verdict: CLEAN
