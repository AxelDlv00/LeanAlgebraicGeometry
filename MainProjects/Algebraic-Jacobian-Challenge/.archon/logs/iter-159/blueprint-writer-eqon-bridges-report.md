# blueprint-writer report — eqon-bridges (iter-159)

## Scope
Edited ONLY `blueprint/src/chapters/AbelianVarietyRigidity.tex`. No `.lean` files touched, no
`\leanok`/`\mathlibok` markers added or removed, no verbatim source quotes altered, theorem-of-the-cube
block / `prop:morphism_P1_to_AV_constant` / genus-0 blocks untouched.

## Edits made

### 1. `lem:rigidity_eqOn_dense_open` — `[IsAlgClosed]` formalization note
Appended a `\medskip \noindent\textbf{Formalization note: the base field is algebraically closed.}`
paragraph after the existing (untouched) "collapse hypothesis is load-bearing" paragraph. It records:
the formalization carries `[IsAlgClosed kbar]` on this lemma and propagates it to
`thm:rigidity_lemma` + `rigidity_core`; required for per-slice residue-field triviality
(`κ(y) = k̄ ⟹ Γ(slice) = k̄`); already assumed by downstream `prop:morphism_P1_to_AV_constant` and
`thm:rigidity_genus0_curve_to_AV` (variable named `kbar`), so zero downstream cost. The original
load-bearing paragraph was preserved verbatim.

### 2. Proof block — "Formalization notes" addendum (the two bridges + fibre fact)
Appended after the existing prose proof (Mumford verbatim `% SOURCE QUOTE PROOF` and textbook proof
left unchanged). Three labelled pieces, prose only, naming Mathlib lemmas as the route (no tactic strings):
- **Bridge 1 (closed map) — BUILT.** `snd_left_isClosedMap` via `IsProper.toUniversallyClosed` +
  base change + `Over.snd_left` (monoidal proj IS `Limits.pullback.snd`). Stated as already proven.
- **Fibre fact — RESOLVED, char-free.** Coarse `PullbackCarrier` route: paste identity square against
  canonical pullback square (`IsPullback.of_right`, `IsPullback.of_horiz_isIso`, section identities from
  `lift_fst`/`lift_snd` + `Over.w`), read fibre via
  `Scheme.Pullback.image_preimage_eq_of_isPullback`. Explicitly flags the fine
  `Triplet`/`carrierEquiv`/residue-field route as wrong granularity / to be avoided. No `[IsAlgClosed]`.
- **Bridge 2 (slice-constancy) — RESOLVED, cohomology-FREE.** Global-sections + per-closed-point stack:
  `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closedness ⟹ `Γ(X_y)=k̄`;
  `ext_of_isAffine` pins the slice map; `closure_closedPoints` / Jacobson density;
  `ext_of_isDominant_of_isSeparated'` globalises. Explicitly states the relative Stein /
  `f_*O = O` framing is a Mathlib gap that must NOT be attempted. Flags the one missing connective
  ("morphisms agreeing on a dense set of closed points are equal" hom-ext) as the residual ~1–2 iter
  prover task, not cohomology.

### 3. `rmk:rigidity_lemma_decomposition` — status update
Appended an "Status (iter-159)" paragraph: bridge 1 built; both residual sorries now have a concrete
char-free route (pointer to the lemma's formalization notes); `[IsAlgClosed]` added to all three chain
lemmas; relative-Stein framing deliberately avoided. Original decomposition prose preserved.

## Citation discipline
No new external `% SOURCE:` lines added — the additions cite Mathlib lemma names (project-internal
formalization route), per directive. No Mumford/Milne text was newly quoted this session.

## Source-of-truth used
`analogies/rigidity-hfib.md` (api-alignment, ALIGN_WITH_MATHLIB — coarse PullbackCarrier route,
LSP-verified iter-159) and `analogies/rigidity-affineconst.md` (Decision 1 NEEDS_GAP_FILL → avoid
Stein; Decision 2 PROCEED → global-sections route; Decision 3 ALIGN → add `[IsAlgClosed]`).

## Notes for next iter
- The chapter now matches the prover's concrete route. The residual prover task is precise: build the
  dense-closed-points hom-ext connective on top of the per-slice `ext_of_isAffine` constancy, then
  feed `ext_of_isDominant_of_isSeparated'`. Plus the bookkeeping signature change adding
  `[IsAlgClosed kbar]` to `rigidity_eqOn_dense_open`/`rigidity_core`/`rigidity_lemma`.
- LaTeX changes are prose-only paragraph appends; no structural/macro changes, so no build risk beyond
  ordinary recompile.
