# Directive — lean-vs-blueprint-checker (TensorObjSubstrate, iter-225)

## Scope (exactly one file + its chapter)
- Lean file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What received prover work this iter
A single new declaration was added (mathlib-build mode):

```lean
noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.dual (R₀ := X.presheaf) M.val) :
    SheafOfModules X.ringCatSheaf)
```

in namespace `AlgebraicGeometry.Scheme.Modules` (around L1580). It is the sheaf-level dual
`ℋom_{𝒪_X}(M, 𝒪_X)`, the dual analogue of the in-file `tensorObj`. Verified axiom-clean
(`{propext, Classical.choice, Quot.sound}`).

The blueprint pin is `lem:internal_hom_isSheaf` / `\lean{AlgebraicGeometry.Scheme.Modules.dual}`
in §`sec:tensorobj_dual_infra`.

## Your task (bidirectional, narrow file-vs-chapter)
1. **Lean → blueprint:** Does `dual` (and the surrounding sub-step-3/4 infrastructure it consumes —
   `PresheafOfModules.dual`, `internalHomEval`, `sheafification`) faithfully realise what the chapter
   states? Any fake/placeholder statement, signature mismatch with `\lean{...}` hints, or
   "temporary"/misleading definition? In particular check that `dual` matches the chapter's
   `lem:internal_hom_isSheaf` claim (the dual is a genuine sheaf-of-modules object via sheafification,
   not a stub).
2. **Blueprint → Lean:** Is `Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra` detailed
   enough to have guided this formalization? Does it correctly describe the sheafification-of-the-
   presheaf-dual construction and the (now-confirmed non-issue) CommRingCat/RingCat base situation?
3. Note (do NOT treat as must-fix unless load-bearing): the file carries known sorries at L641
   (`isLocallyInjective_whiskerLeft_of_W`, the d.2 stalk-⊗ residual), L1965, L2011 — these are
   pre-existing, tracked, and out of scope for this iter. Flag only NEW divergence introduced by the
   `dual` addition.

Report must-fix / major / minor per your usual format. Write your report to
`task_results/lean-vs-blueprint-checker-tensorobj225.md`.
