# Mathlib Analogist Report

## Slug
bridge-iter121

## Iteration
121

## Question

How should the bridge between the presheaf-section module of
`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf` and the
appLE-algebra Kähler module `Ω[B/A]` on an affine chart be designed
in Lean? Three sub-questions: (1) statement shape (`LinearEquiv` vs
`ModuleCat.Iso` vs `PresheafOfModules` natural iso); (2)
`IsLocalization` packaging for `A → A_colim`; (3) cofinality
argument packaging for "directed colimit over `M`-localizations is
the localization at `M`".

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Statement shape: `LinearEquiv ≃ₗ[B]` (not `Iso`, not global natural iso) | ALIGN_WITH_MATHLIB | major |
| `IsLocalization` packaging for `A → A_colim`: bare theorem giving `IsLocalization M A_colim` | ALIGN_WITH_MATHLIB | major |
| Cofinality framing: avoid `Functor.Final` colim-comparison; use cocone-universal-property + `IsLocalization.of_le` | NEEDS_MATHLIB_GAP_FILL (with redesigned approach) | major |
| M1.c (`kaehler_localization_subsingleton`) — NOT a Mathlib gap | ALIGN_WITH_MATHLIB | informational |
| M1.d (`kaehler_quotient_localization_iso`) — small inline LinearEquiv build | ALIGN_WITH_MATHLIB | informational |
| Naming: `_iso_` vs `_equiv_` suffix | ALIGN_WITH_MATHLIB | informational |
| Namespace: `Scheme.appLE_isLocalization` → `IsAffineOpen.appLE_isLocalization` | ALIGN_WITH_MATHLIB | informational |

## Must-fix-this-iter

None — the bridge declaration has not yet shipped. All findings are
proposal-stage. They become Must-fix only if the proposal-stage
shape is committed to PROGRESS.md / Differentials.lean without
absorbing the alignments below.

## Major (proposal-stage alignments — adopt now, not later)

1. **Statement shape**: package the bridge as `LinearEquiv` (`≃ₗ[B]`)
   with `@[simps]`, mirroring
   `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`
   (`.lake/packages/mathlib/Mathlib/RingTheory/Etale/Kaehler.lean:37-46`).
   The `ModuleCat.Iso` form derives freely via
   `LinearEquiv.toModuleIso`. Do NOT package as a `PresheafOfModules`
   global natural iso this iter — current consumers are pointwise.

2. **`appLE_isLocalization` shape**: state as a bare theorem giving
   `IsLocalization M A_colim` predicate on the canonical algebra
   structure (the cocone-leg algebraMap of
   `TopCat.Presheaf.pullback`). DO NOT also state an
   `AlgEquiv L ≃ₐ[A] A_colim`. The canonical Mathlib precedent is
   `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`
   (`AffineScheme.lean:~640`) which uses exactly this shape:
   bare-theorem with `IsAffineOpen` hypotheses.

3. **M1.b cofinality re-framing**: re-state the M1.b argument in
   the blueprint to AVOID a `CategoryTheory.Functor.Final` /
   `colimitIso` colim-comparison framing. Mathlib has NO off-the-shelf
   "colim of localizations is localization at M" lemma (verified via
   `lean_leansearch`, `lean_loogle`, `lean_local_search` on multiple
   variants). The cleaner Mathlib-aligned path:
   (a) construct `A_M → A_colim` from `Localization M` universal
       property (after showing each `g ∈ M` is a unit in `A_colim`),
   (b) construct `A_colim → A_M` from the colim cocone universal
       property, picking basic-open refinements `D(g) ⊆ W` on each
       open, mapping via `Γ(S, W) → Γ(S, D(g)) = A_g → A_M`,
   (c) verify composites are identity via `IsLocalization.ringHom_ext`,
   (d) conclude `IsLocalization M A_colim` via
       `IsLocalization.isLocalization_iff_of_ringEquiv` or directly
       construct the structure.
   Cost estimate: 100-250 LOC, comparable to but no worse than the
   colim-comparison framing. The key Mathlib workhorse is
   `IsLocalization.of_le`
   (`Mathlib.RingTheory.Localization.Defs`):
   `[IsLocalization M S] → (h : ∀ n ∈ N, IsUnit (algebraMap n)) →
   IsLocalization N S`.

4. **Rename**: `relativeDifferentialsPresheaf_iso_kaehler_appLE` →
   `relativeDifferentialsPresheaf_equiv_kaehler_appLE`. The blueprint
   `\lean{...}` hint must follow. Matches
   `tensorKaehlerEquivOfFormallyEtale` Mathlib naming.

5. **Namespace**: prefer
   `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` over
   `AlgebraicGeometry.Scheme.appLE_isLocalization`, mirroring
   `IsAffineOpen.isLocalization_basicOpen` and
   `IsAffineOpen.appLE_eq_away_map` (both in
   `AffineScheme.lean`).

## Informational

### M1.c — NOT a Mathlib gap, blueprint claim is wrong

The blueprint asserts that "Mathlib b80f227 has no off-the-shelf
bare lemma for ‘Ω[L/A] is subsingleton when A → L is a localization’".
This is **incorrect**. The composition

```
[IsLocalization M L]
  → Algebra.FormallyUnramified.of_isLocalization M
       (Mathlib.RingTheory.Unramified.Basic:303)
  → Algebra.FormallyUnramified.subsingleton_kaehlerDifferential
       (Mathlib.RingTheory.Unramified.Basic:57-59, an instance)
```

gives `Subsingleton Ω[L⁄A]` in 2 lines of Lean. The blueprint's
`lem:kaehler_localization_subsingleton` statement-block should be
dropped and the conclusion inlined at its M1.d call site. Saves a
`\lean{...}` declaration with no semantic loss.

### M1.d — small in-file build, not a standalone gap

`lem:kaehler_quotient_localization_iso` is correctly identified but
mis-priced. With `Subsingleton Ω[L⁄A]` in hand (M1.c) and
`KaehlerDifferential.exact_mapBaseChange_map`
(`Mathlib.RingTheory.Kaehler.Basic:753`) +
`KaehlerDifferential.map_surjective`
(`Mathlib.RingTheory.Kaehler.Basic:710`), the LinearEquiv
`Ω[B⁄A] ≃ₗ[B] Ω[B⁄L]` is a ~10-30 LOC body following the
`tensorKaehlerEquivOfFormallyEtale` proof template (`Etale/Kaehler.lean:37-46`).
This is also the most extractable Mathlib contribution candidate
from this iter (the "only lower step is formally unramified"
generalisation).

### M1.e — already in place

The `rfl`-identification `relativeDifferentialsPresheaf_obj_kaehler`
(`Differentials.lean:58-64`) makes M1.e a `change`/`letI` orchestration
at the call site, not new infrastructure.

### `LinearEquiv ↔ ModuleCat.Iso` bridge

Mathlib provides `LinearEquiv.toModuleIso` and `Iso.toLinearEquiv`
(`Algebra.Category.ModuleCat.Basic:277, 288`) plus the categorical
equivalence
`(X ≃ₗ[R] Y) ≅ (ModuleCat.of R X ≅ ModuleCat.of R Y)` (line 301).
A LinearEquiv-shaped statement freely produces the `Iso` form on
demand.

## Persistent file
- `analogies/relative-differentials-presheaf-bridge.md` — design
  rationale, full Mathlib-precedent catalog, concrete API shape and
  blueprint-refactoring checklist captured for future iters.

Overall verdict: ALIGN_WITH_MATHLIB on shape, naming, and namespacing;
re-frame the M1.b argument to use cocone universality +
`IsLocalization.of_le` instead of a `Functor.Final` colim-comparison;
drop M1.c as a standalone lemma since Mathlib already supplies it
via `FormallyUnramified.of_isLocalization`.
