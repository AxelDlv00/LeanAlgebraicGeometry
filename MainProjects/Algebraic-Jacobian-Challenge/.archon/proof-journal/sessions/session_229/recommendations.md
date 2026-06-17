# Recommendations for the next plan agent (post-iter-229)

## 1. Build ONE consumer on top of `overSliceSheafEquiv` — the decisive convergence test

The shared open-immersion ↔ slice sheaf-site equivalence landed axiom-clean this iter in
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (`overSliceSheafEquiv` +
`overEquivInverseIsDenseSubsite` + the pointwise cover-correspondence lemma). It is the single
Mathlib-absent root that iter-228's hard-block and the two iter-229 analogist consults
(ts229slice, ts229glue) independently localized for BOTH remaining ⊗-inverse bridges. The next
iter must convert "both reduce to this root" from claim to a sorry-elimination:

- Dispatch ONE `mathlib-build` prover to build a consumer. **Recommended: C-bridge
  `dual_isLocallyTrivial`** — iter-228 had already typechecked Steps 1–3 + H1 and isolated the
  residual `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)` to exactly the slice-site
  gap that `overSliceSheafEquiv` now fills. The A-engine `homOfLocalCompat` (gluing via
  `presheafHom` + `existsUnique_gluing` + `sheafHomSectionsEquiv` + `homMk`) is the alternative.
- **Success bar: a genuine project sorry 80 → 79** (`exists_tensorObj_inverse` closing, or a real
  step toward it). iter-229 met its own (bridge-only) bar; iter-230's bar is the counter moving.

## 2. The "both bridges reduce to one root" thesis is now testable — hold it accountable

If a consumer does **not** close on top of `overSliceSheafEquiv` next iter (e.g. the per-bridge
module-transport composition re-introduces a `restrictScalars`/CommRingCat gap — the
strategy-critic ts229 WATCH, the "4th cost-growth" signal), treat the thesis as falsified and
**re-escalate the RR-pause / divisor-route fork to the USER** with that concrete evidence — while
still taking a constructive fallback (never-idle). The RR-fork escalation is already LIVE in
PROGRESS.md; this would re-sharpen it with a hard datapoint.

## 3. lean-vs-blueprint-checker tensorobj229 (dispatched this iter — COMPLETE, 0 must-fix, 2 minor)

The per-file check of `TensorObjSubstrate.lean` ↔ `Picard_TensorObjSubstrate.tex` returned: the
new decl `overSliceSheafEquiv` (L2321) **matches** its pin `lem:open_immersion_slice_sheaf_equiv`,
axiom-clean, `\leanok` correctly set, Lean is appropriately MORE general (any `TopologicalSpace X`,
not "scheme"). **Two MINOR blueprint-side fixes owed (not must-fix; fold into the next
blueprint-writer pass, no prover block):**
  - (a) the proof sketch (`Picard_TensorObjSubstrate.tex` ~L2877–2905) names
    `Functor.IsDenseSubsite.sheafEquiv` as the route, but the Lean used the cheaper
    `CategoryTheory.Equivalence.sheafCongr` (+ the project-local `overEquivInverseIsDenseSubsite`
    instance). A prover following the sketch would hunt the wrong API. Update the sketch.
  - (b) the statement prose claims compatibility with `restrictFunctorIsoPullback`, but the Lean
    type bundles only the bare `≌` (no compatibility datum). Drop or soften the overreach.
Report: `.archon/task_results/lean-vs-blueprint-checker-tensorobj229.md` (archived to
`logs/iter-229/`).

## 4. Deferred (pre-existing, non-blocking) — carried from iter-228, still owed at polish time

- **`Sheaf.val` → `ObjectProperty.obj` deprecation (14 sites in `TensorObjSubstrate.lean`)** —
  deprecation warnings, not errors (lean-auditor ts221/ts228). Fold into a dedicated polish pass
  once the dual/⊗-inverse block lands.
- **Vestigial whiskering/stalk apparatus + `tensorObj_assoc_iso` unused-hyps** — delete with the
  direct-gluing associator re-route once `exists_tensorObj_inverse` is assembled.
- **Blueprint pin/sync hygiene** in `Picard_TensorObjSubstrate.tex` (lvb ts222 majors #2/#3;
  superseded-route blocks lacking `\lean{}` pins) — same polish pass.

## Status snapshot
- Route: `exists_tensorObj_inverse` (sheaf internal-hom dual, Decision-1). Project sorry **80**.
- Shared root bridge: **DONE** (axiom-clean, `TensorObjSubstrate.lean` ~L2250–2300). Consumers:
  **OPEN** (not yet decls).
- Build GREEN; blueprint-doctor CLEAN; sync_leanok iter 229 sha `814670bd` +4/−0
  (`Picard_TensorObjSubstrate.tex`).
- Prover met its iter-229 success bar (bridge axiom-clean); convergence (80→79) is iter-230's test.
