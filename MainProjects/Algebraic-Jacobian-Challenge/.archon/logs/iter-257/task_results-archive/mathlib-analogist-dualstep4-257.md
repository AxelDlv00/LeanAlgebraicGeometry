# Mathlib Analogist Report

## Mode
api-alignment

## Slug
dualstep4-257

## Iteration
257

## Question
(1) Can `dual_restrict_iso`'s Step-4 residual be derived from the CLOSED `tensorObj_restrict_iso`
via uniqueness of monoidal inverses, using a Mathlib "right duals unique / strong-monoidal functor
preserves right duals" idiom, WITHOUT a registered `MonoidalCategory` + rigid/`MonoidalClosed`
structure on `PresheafOfModules`? (2) If leg (A) is unavoidable, the cleanest Mathlib idiom for the
slice Beck–Chevalley and the minimal `sliceDualTransport` skeleton.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Route (1): inverse-uniqueness shortcut | NEEDS_MATHLIB_GAP_FILL (not viable) | informational |
| Route (2): leg-(A) slice transport atom | NEEDS_MATHLIB_GAP_FILL (build it) | informational |

## Informational

**Route (1) is NOT viable — commit to leg (A).** The abstract statements exist
(`CategoryTheory.hasRightDualOfEquivalence`, `Mathlib.CategoryTheory.Monoidal.Rigid.OfEquivalence`;
`CategoryTheory.rightDualIso`, `Mathlib.CategoryTheory.Monoidal.Rigid.Basic`) but
`hasRightDualOfEquivalence` requires **four** structures the project lacks, simultaneously:
1. `[MonoidalCategory (PresheafOfModules R)]` — ABSENT (`loogle` for both `MonoidalCategory` and
   `MonoidalClosed (PresheafOfModules ?R)` returns nothing; the project builds `tensorObj` by hand
   precisely because of this).
2. `[F.Monoidal]` (strong) for the restriction functor — the project only has lax/oplax; the
   comparison `δ` is not iso in general.
3. `[F.IsEquivalence]` — restriction along a non-surjective open immersion is a localization, not
   an equivalence.
4. `HasRightDual M` / `ExactPairing M (dual M)` — `dual = internalHom(–,𝟙_)` has an evaluation but
   no coevaluation/zig-zag for general M, and `dual_restrict_iso` is stated for **general M** where
   inverse-uniqueness is not even mathematically valid.
Even narrowing to the invertible-`L` consumer (`dual_isLocallyTrivial`), registering a
`MonoidalCategory`, building the coevaluation, and proving the zig-zags is strictly more work than
leg (A).

**Route (2) — the named atoms for leg (A):**
- Engine: `CategoryTheory.Functor.FullyFaithful.homEquiv` (`Mathlib.CategoryTheory.Functor.FullyFaithful`),
  `(X ⟶ Y) ≃ (F.obj X ⟶ F.obj Y)` — the Hom-set bijection for the fully faithful `f.opensFunctor`.
- Off-the-shelf slice equivalence: `TopologicalSpace.Opens.overEquivalence` (`Mathlib.Topology.Sheaves.Over`),
  `Over U ≌ Opens ↥U` — but its unit/counit are all `eqToHom`, so it adds no leverage over writing
  the `eqToHom`-conjugation directly.
- Scalar reconciliation (leg B): `restrictScalarsRingIsoDualEquiv` (project, CLOSED).
- **Recommended assembly**: because `Opens X`/`Over V` are thin posets, leg (A) collapses to a
  near-copy of the project's already-axiom-clean `homLocalSection` (`DualInverse.lean:358`):
  conjugate slice-Hom components by `eqToHom` along `image_preimage_of_le` (`DualInverse.lean:439`),
  naturality by `Subsingleton.elim`, wrapped in `PresheafOfModules.isoMk` (as in `dualUnitIsoGen` /
  `dualIsoOfIso`). Compose with `restrictScalarsRingIsoDualEquiv`. Build `sliceDualTransport` as a
  standalone verified `def` first, then assemble the residual via `isoMk`. Do NOT route through
  `overSliceSheafEquiv` (Sheaf / fixed-value-cat, proven inapplicable) nor a full `Over V ≌ Over fV`
  object. The `sliceDualTransport` skeleton is in the persistent file.

## Persistent file
- `analogies/dualstep4-257.md` — full decision blocks, the four route-(1) blockers, and the
  `sliceDualTransport` + `isoMk` skeleton for leg (A).

Overall verdict: route (1) is dead (rigid machinery needs a `MonoidalCategory` instance, a strong
functor, an equivalence, and an `ExactPairing` — none of which the project has, and the last is
impossible for general M), so commit to leg (A), built as a `homLocalSection`-style thin-poset
`eqToHom`-conjugation (`Functor.FullyFaithful.homEquiv` ∘ `restrictScalarsRingIsoDualEquiv`).
