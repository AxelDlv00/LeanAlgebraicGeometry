# Lean Audit Report

## Slug
iter059

## Iteration
059

## Scope
- files audited: 2 (directive-specified; both received prover edits this iter)
- files skipped (per directive): all others — review-phase narrow-scope directive

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 5 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L.1991–1998** (`genericFlatnessAlgebraic` body): diary comment reads "the genuine residual (it needs L4 finiteness + L5, the polynomial-ring core still under construction)". L4 (`exists_localizationAway_finite_mvPolynomial`) and L5 (`exists_free_localizationAway_polynomial`) are both fully closed and axiom-clean in this file. The comment is stale and actively misleading about the state of the proof. **Major.**
  - **L.653–686** (`exists_localizationAway_finite_mvPolynomial` body): a large block labelled `-- REMAINING ASSEMBLY` that describes the denominator-clearing steps as future work to be done. The actual assembly implementation sits immediately below in the same proof, fully realised. The roadmap block was not pruned after the code landed. **Minor** (misleading by proximity but the code is present and correct).
  - **L.3318** (`genericFlatness` body): `-- STATUS (iter-055).` label with a detailed accounting of what was open vs closed at iter-055. The proof is now fully closed (no sorry anywhere in the body). The iter label is stale; a reader studying the proof sees a progress snapshot 4 iters old. **Minor** (stale provenance tag; no wrong claim about the current state on its own).
  - **L.3335–3341** (`genericFlatness` body): comment reads "The remaining `sorry` is the per-(U,W) flatness check, which reduces (via `gf_section_span_flat_descent` + `gf_crossChart_spanning_cover`) to the per-piece flatness…". The proof body that follows (lines 3343–3624) contains no `sorry` — the step is fully implemented. Saying "the remaining sorry is X" when X is already closed is a false claim about proof status. **Major.**
  - **L.3449, L.3563–3576** (`genericFlatness` → `flatV` subproof): two inline comments describe the upcoming code block as "the ONLY open step" / "the lone remaining open step — pure transport, NO Mathlib gap". Both are immediately followed by the complete implementation. These read as route annotations left over from before the step was closed; harmless but redundant. **Minor.**

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L.299–311** (above `Scheme.Modules.glue`): a `NOTE (scaffold)` block that reads: "the body and the module-cocycle hypotheses on `g` are still to be filled; the transition data `g` is recorded in the signature, the multiplicative cocycle conditions remain to be added before the construction is closed." The `glue` declaration at line 382 carries a fully-implemented descent-equalizer body (pushforward product + cocycle equalizer via `∏ᵢ(ιᵢ)_*Mᵢ ⇉ ∏(j_ij)_*(f_ij^*Mᵢ)`). The scaffold NOTE predates the glue implementation and was not removed; it directly contradicts the code. **Major.**
  - **L.258** (`chartQuotientMap_ιFree`): `erw [Sigma.ι_desc_assoc]`. Justified — the SheafOfModules/X.Modules instance diamond prevents plain `rw` from locating the subterm positionally. No concern.
  - **L.605** (`bundleTransition_self`): `erw [matrixEnd_one, Category.id_comp]`. Same justification as above; this is the pattern documented for this file. No concern.
  - **L.472–473** (`opensMap_final`): `Subsingleton.elim _ _` to equate two morphisms `U → V` in the `Opens` category. Mathematically sound — all `Opens` hom-sets of the form `U → V` with `U ≤ V` are singletons. No concern.
  - **L.584** (`bundleTransition_self`): `set_option maxHeartbeats 1000000`. Accompanied by a rationale comment. Legitimate.
  - **L.650** (`bundleTransition_cocycle`): `:= sorry`. **Honest, documented sorry.** Comment: "body is the remaining hard step of the bundle cocycle (~50-100 LOC of matrix-to-module transport bookkeeping)". The sorry is accurately described and not laundering anything.
  - **L.670** (`universalQuotient`): `:= sorry`. **Honest, documented sorry.** Comment: "rides on bundle cocycle". Accurately describes the dependency chain.
  - **L.681** (`tautologicalQuotient`): `:= sorry`. **Honest, documented sorry.** Rides on `universalQuotient`.
  - **L.1175** (`represents`): `:= sorry`. **Honest, documented sorry.** Rides on `tautologicalQuotient` via the universal property chain.

---

## Must-fix-this-iter

None. No excuse-comments, no wrong definitions, no laundered sorries, no axioms on non-trivial claims.

---

## Major

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1991–1998` — stale diary comment claims L4/L5 are "still under construction" inside a proof where both are fully closed and axiom-clean. A reader checking proof status gets a false signal.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:3335–3341` — "The remaining `sorry` is the per-(U,W) flatness check" appears in a sorry-free proof body. False claim about proof completeness; the implementation immediately follows with no sorry.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:299–311` — scaffold NOTE states `glue`'s body is "still to be filled" and "cocycle conditions remain to be added". The `glue` body is fully implemented via descent equalizer at line 382. The NOTE directly contradicts the code.

---

## Minor

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:653–686` — stale `REMAINING ASSEMBLY` roadmap block describing steps already implemented immediately below it.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:3318` — `STATUS (iter-055)` iteration label in a now-closed proof; stale provenance tag.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:3449` and `3563–3576` — inline "only open step" / "lone remaining open step" route annotations for code that is already implemented below them.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:258,605` — `erw` usages; justified by the X.Modules instance diamond, but worth tracking if the diamond is ever resolved upstream.

---

## Excuse-comments (always called out separately)

None found. All sorry sites in GrassmannianQuot.lean carry accurate, non-excuse documentation about what remains open and why.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 — all stale comments, no wrong code
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: both files are mathematically clean and sorry-free except for four honestly-documented open sorries in GrassmannianQuot.lean (all riding on the bundle cocycle); the only issues are stale diary/scaffold comments in proof bodies that should be pruned now that the corresponding steps are closed.
