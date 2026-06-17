# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts224dual

## Iteration
224

## Question

Is the project hand-rolling the internal-hom **evaluation morphism** `internalHomEval :
M ⊗_R M^∨ ⟶ 𝟙_` on `PresheafOfModules R` in a shape that forces a `whnf` of the monoidal
unit `𝟙_` during naturality — and does Mathlib provide either (a) a ready evaluation/counit
to reuse, or (b) a `Hom`-builder / unit-targeting idiom whose naturality is dischargeable
**without** `kabstract`-over-`𝟙_`? Decide align-vs-deviate and give a concrete bounded recipe.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Reuse a Mathlib counit (`ihom.ev` / `MonoidalClosed`) | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. Target explicit `unit R`, not `𝟙_`, in `dual`/`internalHomEval` | ALIGN_WITH_MATHLIB | critical |
| 3. `homMk` pre-reduced-naturality builder | PROCEED | informational |
| 4. `with_reducible` rewriting (tactical) | DIVERGE_INTENTIONALLY | informational |

## Lead verdict & single most promising recipe

**ALIGN-WITH-MATHLIB with two composable fixes; try the cheap tactical one first.** There is
**no** reusable evaluation/counit (Decision 1 — `MonoidalClosed (PresheafOfModules R)` does not
exist in Mathlib), so question-1's "naturality is free" path does not fire. The bomb is caused
by the project writing `dual M := internalHom M (𝟙_ …)`: the `𝟙_` *instance projection*
`MonoidalCategoryStruct.tensorUnit` is embedded in `dual`'s body, and since `dual M` saturates
the naturality goal, every `kabstract` (run at ambient `.default` transparency by
`rw`/`erw`/`simp`/`change`) unfolds it and whnf-s the heavy unit machinery.

1. **First probe — `with_reducible` (cheapest, ~1 iter, 0 signature changes).** Wrap each
   rewriting tactic in the `internalHomEval` naturality proof in `with_reducible`, e.g.
   `with_reducible rw [tensorObj_map_tmul, internalHomEvalApp_tmul, internalHomEvalApp_tmul]`,
   `with_reducible simp only […]`. `kabstract` then runs at `.reducible`, leaving the
   non-reducible `def`s `dual`/`internalHom`/`tensorUnit` folded (no whnf bomb); the
   elementwise lemma LHSs are head-aligned with the goal and match anyway. Direct
   monoidal-coherence precedent: `Mathlib/RepresentationTheory/Action.lean:157-158`
   (`with_reducible convert …`, `all_goals with_reducible simp`); `conv` variant at
   `Mathlib/Tactic/Conv.lean:123`.

2. **Robust structural fix — re-shape `dual` onto `unit` (the genuine ALIGN, ~20–40 LOC).**
   `dual M := InternalHom.internalHom M (PresheafOfModules.unit …)` instead of `… (𝟙_ …)`;
   retype the `evalLin` cast to `restr X.unop (unit …)`; set `internalHomEval`'s codomain to
   `unit …` (definitionally equal to `𝟙_`, so downstream `⟶ 𝟙_` consumers still typecheck);
   replace the six-step reduction's `tensorUnit_map` step by `unit`'s definitional `R.map f`
   (`unit_map_one`/`unit_map_apply`). This is exactly what Mathlib does — `unitHomEquiv` and the
   unitor-naturality proofs at `Monoidal.lean:113-122` are all written against `unit R`, never
   the `𝟙_` projection.

## Must-fix-this-iter

- **Decision 2 — `dual` is shipped against `𝟙_`.** `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1359`
  defines `dual M := InternalHom.internalHom M (𝟙_ …)`. Mathlib's idiom for any construction
  touching the unit object is the explicit `PresheafOfModules.unit R`
  (`Mathlib/Algebra/Category/ModuleCat/Presheaf.lean`, `def unit`, `unit_map_one`,
  `unitHomEquiv`); the monoidal layer only aliases it (`…/Presheaf/Monoidal.lean:110`,
  `tensorUnit := unit _`). The `𝟙_` literal is the direct cause of the iter-221→223 whnf bomb:
  it embeds the `tensorUnit` instance projection into `dual`'s body, which `kabstract` must
  whnf. **Cost of the divergence**: a load-bearing `sorry` blocked for 3 funded iters; carrying
  it forward risks a fragile decl or a forced `maxHeartbeats` (forbidden). Refactor `dual`
  (and `internalHomEval`'s codomain) to `unit …`.

## Informational

- **Decision 1 — no reusable counit (NEEDS_MATHLIB_GAP_FILL).** Confirmed by source: the only
  `Closed` token in `…/ModuleCat/Presheaf/*` is the import of the fixed-ring
  `ModuleCat.Monoidal.Closed` at `Monoidal.lean:9`; `grep "MonoidalClosed (PresheafOfModules\|
  SheafOfModules"` over all of Mathlib → 0 hits. Re-confirms ts219dual Decision 1; does **not**
  overturn the object-level "build the dual by hand" verdict. Building a counit = the full
  ts219 internal-hom block (out of scope).
- **Decision 3 — `homMk` does not help (PROCEED).** `PresheafOfModules.homMk` delegates
  naturality to an underlying `Ab`-presheaf morphism's `naturality` — the same square one level
  down, minus the module structure. The project's `Hom.mk app + (by … tensor_ext)` is already
  the correct per-section reduction; the gap is transparency control, not the builder.
- **Defeq, not an iso (answers question 2's sub-question).** Mathlib provides no
  `𝟙_ ≅ unit` iso because `tensorUnit := unit _` makes them defeq; the prover's noted
  `rw [show 𝟙_ = unit from rfl]` bombs precisely because the *rewrite* (kabstract over `𝟙_`)
  is the toxic step. The fix is to never introduce `𝟙_` (Decision 2), not to rewrite it away.
- **Honest residual risk / fallback.** iter-223 made only `dual`/`internalHomEvalApp`
  irreducible — never `internalHom`/`internalHomPresheaf`/`internalHomObjModule`/`ofPresheaf` —
  so the evidence does not cleanly separate "the bomb is the `𝟙_` projection" from "the bomb is
  the `internalHom`/`ofPresheaf` body's defeq cost." `with_reducible` (Decision 4) folds ALL of
  them and is therefore the decisive experiment. If `with_reducible` still bombs, no whnf-free
  close exists at the current object shape, and the held fallback fires: **revert
  `internalHomEval` to ABSENT** (global sorry 81→80) rather than carry a stubbed morphism.

## Persistent file
- `analogies/ts224dual.md` — design-rationale captured for future iters (full decision blocks,
  citations, and the two-fix recipe).

Overall verdict: ALIGN_WITH_MATHLIB — the `𝟙_` literal in `dual` is a deviation from Mathlib's
explicit-`unit R` idiom and is the direct cause of the whnf bomb; try `with_reducible` on the
rewrites first (cheap, monoidal-coherence precedent), then re-shape `dual`/`internalHomEval` onto
`unit` (robust), with revert-to-absent as the principled fallback if both fail.
