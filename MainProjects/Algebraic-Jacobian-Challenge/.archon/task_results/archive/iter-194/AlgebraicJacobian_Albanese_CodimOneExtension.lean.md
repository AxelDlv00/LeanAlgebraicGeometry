# AlgebraicJacobian/Albanese/CodimOneExtension.lean — iter-194 Lane M↓

## Summary

- **Mode**: `prove` (per PROGRESS.md task #3); helper budget = 1.
- **Sorry count**: 3 → 3 (unchanged).
- **Axioms**: 0 (kernel-only).
- **HARD BAR status**: **MET (precise gap surface route)** — per
  PROGRESS.md objective #3: *"HARD BAR: EITHER ≥1 axiom-clean closure of
  one of the 3 headline sorries, OR a precise gap surface (the latter is
  acceptable — iter-200 mathlib-analogist sweep covers the gap)."*
- **Helpers added**: **0** (kept under directive budget = 1; no new
  helper #7 introduced per progress-critic STUCK must-fix).

## Per-sorry status

### L434 — `isRegularLocalRing_stalk_of_smooth` (Stage 6 Mathlib gap)

#### Attempt 1
- **Approach:** Extend body with Stage 5b
  (`rank_kaehlerDifferential_localization_eq_relativeDimension`)
  instantiation.
- **Result:** FAILED — Stage 5b requires
  `[IsStandardSmoothOfRelativeDimension n R S]` with a *specific* `n`,
  but Stage 3 only yields `Algebra.IsStandardSmooth R S`. Lifting to
  `OfRelativeDimension n` requires either (a) knowing `Module.rank S
  Ω[S⁄R] = n` for a *specific* finite `n` (circular: needs the
  smooth-algebra dimension formula) or (b) reading off `n` from the
  underlying `SubmersivePresentation`, which is not exposed by
  `Algebra.IsStandardSmooth`.
- **Dead end:** Stage 5b instantiation without prior relative-dimension
  extraction.

#### Attempt 2 (LANDED)
- **Approach:** Update gap docstring (L480-514) to reflect actual
  iter-194 state: split the remaining gap into two named sub-gaps with
  concrete Mathlib path references.
- **Result:** RESOLVED (docstring-level) — the Stage 6 gap is now
  structured as:
  - **Sub-gap (i):** Relative-dimension `n` determination from
    `IsStandardSmooth` (no specific `n` extractable at the algebra
    layer; needs `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`
    + dimension formula).
  - **Sub-gap (ii):** Smooth-algebra Krull-dimension formula (Stacks
    00OE): empirical Mathlib search at commit `b80f227` finds no
    declaration relating `IsStandardSmooth(OfRelativeDimension)` to
    `ringKrullDim`. Estimated ~300-500 LOC project-side build on top of
    `IsLocalization.AtPrime.ringKrullDim_eq_height` (Mathlib
    `RingTheory/Ideal/Height.lean`).
- **Key insight:** The Mathlib smooth-algebra API gives free Kähler
  differentials of a specific rank, but NOT a `ringKrullDim` value. The
  Stacks 00OE bridge is genuinely missing.

### L684 — `extend_of_codimOneFree_of_smooth` (Milne 3.1)

#### Attempt 1 (LANDED)
- **Approach:** Convert bare `sorry` to a `by` block; add the
  axiom-clean derivation `Y.left.IsSeparated` (via
  `terminal.from Y.left = Y.hom ≫ terminal.from (Spec kbar)` +
  `Spec kbar.IsSeparated` from affine).
- **Result:** PARTIAL — one axiom-clean instance derivation added; the
  main sorry remains. The body now has a precise inline gap statement
  (Stacks 0AVF depth-≥2 H¹ vanishing) + a concrete roadmap for the
  morphism extraction once `Dom(f) = ⊤` lands
  (`X.left.topIso.inv ≫ (X.left.isoOfEq h).inv ≫ f.toPartialMap.hom`).
- **Next step:** Once
  - (a) `isRegularLocalRing_stalk_of_smooth`'s Stage 6 lands
    (unblocks `localRing_dvr_of_codim_one` for Step 1's valuative
    criterion application), AND
  - (b) Stacks 0AVF depth-≥2 H¹ vanishing lands (Mathlib gap; tracked
    iter-200+ mathlib-analogist sweep),
  the body closes via the explicit `topIso.inv ≫ isoOfEq.inv ≫
  toPartialMap.hom` extraction. Uniqueness follows from
  `PartialMap.equiv_iff_of_isSeparated`.

#### Attempt 2 (BACKED OFF)
- **Approach:** Refactor body to expose `f.toPartialMap.domain = ⊤` as
  a single typed sorry, with the morphism extraction and uniqueness
  axiom-clean.
- **Result:** FAILED — the refactor increased sorry count from 1 to 3
  (the morphism-equation proof and uniqueness branch both required
  additional `subst hdom` + `simp` chains that did not close on
  attempted tactics). Net regression on sorry-count metric. Backed off
  to leave the original sorry structure intact.
- **Dead end:** Full structural refactor that exposes `domain = ⊤` as
  the sole gap; the surrounding glue (`X.topIso.hom ≫ g = ...`) does
  not simplify cleanly without `Subsingleton.elim` / `subst`-style
  manipulations that compete with `let g := ...` definitions.

### L752 — `indeterminacy_pure_codim_one_into_grpScheme` (Milne Lemma 3.3)

#### Attempt 1 (LANDED)
- **Approach:** Convert bare `sorry` to `by` block; add 4-substep
  precise gap surface with each substep's Mathlib API status.
- **Result:** PARTIAL — substantive content now documented in 4
  substeps (difference map construction, definedness equivalence,
  function-field pullback, codim-1 pole-divisor intersection with the
  diagonal). The 2 substantive Mathlib gaps are now named:
  - (a) Function-field-pullback bridge for `Scheme.RationalMap`
    (also blocks `thm:weil_divisor_obstruction` at the blueprint level
    — see `RationalMap.mem_domain_iff_exists_partialMap_through_point`
    at L818 docstring for the related "weakened reshuffle" already
    landed iter-179).
  - (b) Scheme-level codim-1 pole-divisor / diagonal intersection
    lemma (Hartshorne AG 9.2 scheme-level form); not in Mathlib at
    `b80f227`.

## Mathlib lemmas verified during this iteration

- `Scheme.isSeparated_iff` (Mathlib
  `AlgebraicGeometry/Morphisms/Separated.lean`):
  `X.IsSeparated ↔ IsSeparated (terminal.from X)`. Used in L684 for the
  `Y.left.IsSeparated` derivation.
- `IsSeparated.of_comp` /  `IsSeparated` composition instance: gives
  `IsSeparated (Y.hom ≫ terminal.from)` from
  `[IsSeparated Y.hom]` + `[IsSeparated (terminal.from (Spec kbar))]`.
  The latter follows automatically from `Spec kbar` being affine.
- `Scheme.topIso : (⊤ : X.Opens).toScheme ≅ X` (Mathlib
  `AlgebraicGeometry/Restrict.lean` L390). Available for the eventual
  morphism extraction.
- `RationalMap.toPartialMap` + `RationalMap.toRationalMap_toPartialMap`
  (Mathlib `AlgebraicGeometry/RationalMap.lean`): the canonical
  `PartialMap` representative whose domain equals `f.domain`. Available
  for the eventual extension construction.
- `PartialMap.equiv_iff_of_isSeparated_of_le` /
  `PartialMap.equiv_toPartialMap_iff_of_isSeparated` (same file):
  the reduced + separated agreement principles for the eventual
  uniqueness proof.

## Mathlib gaps confirmed at `b80f227`

1. **Stacks 00OE** — smooth-algebra Krull-dimension formula. Empirical
   search of `Mathlib/RingTheory/Smooth/*.lean` +
   `Mathlib/RingTheory/KrullDimension/*.lean` finds no declaration
   relating `IsStandardSmooth(OfRelativeDimension n) R S` to
   `ringKrullDim Sₘ`. The only relevant Krull-dim API is
   `IsLocalization.AtPrime.ringKrullDim_eq_height` which is
   prime-height-based, not smooth-algebra-relative-dimension-based.
2. **Stacks 02JK** — cotangent / Kähler-over-a-field bridge:
   `m_p / m_p² ↪ Ω[Aₚ⁄R] ⊗ κ(p) ↠ Ω[κ(p)⁄R]` with the first map
   injective when `κ(p)/R` is separable. Over `R = kbar` algebraically
   closed and `z` a closed point, immediate (`Ω[kbar⁄kbar] = 0`); for
   non-closed `z`, the residue extension is transcendental and full
   conormal apparatus is needed.
3. **Stacks 0AVF** — depth-≥2 local-cohomology vanishing for the
   `extend_of_codimOneFree_of_smooth` Step 2.
4. **Scheme.RationalMap-to-function-field pullback** — also blocks
   `thm:weil_divisor_obstruction` at the blueprint level; needed for
   substep 3 of `indeterminacy_pure_codim_one_into_grpScheme`.
5. **Hartshorne AG 9.2 scheme-level form** — pole divisor on a smooth
   surface meets the diagonal in pure codim-1; needed for substep 4 of
   `indeterminacy_pure_codim_one_into_grpScheme`.

## Blueprint marker status (for `sync_leanok`)

No new statements added; the chapter's `\leanok` markers are
unchanged. The existing `\leanok` on:
- `def:indeterminacy_locus` (L94): already in place.
- `def:codim_one_indeterminacy` (L135): already in place.
- `lem:smooth_codim_one_dvr` (L366): already in place (only the inner
  Stacks 00TT half remains — covered by
  `isRegularLocalRing_stalk_of_smooth`).
- `thm:codim_one_extension` (L442): already in place (the Lean decl
  exists, sorry-only).
- `lem:milne_codim1_indeterminacy` (L566): already in place.
- `lem:mem_domain_partial_map_reshuffle` (L850): already in place
  (sorry-free since iter-179).

The remaining `\leanok` gates are downstream of the 3 Mathlib gaps
listed above; `sync_leanok` should leave them alone.

## Concrete next-iter recipe

Per the progress-critic STUCK verdict for this lane, iter-194 was the
last "more helper layers" iter; iter-195+ depends on the iter-200
mathlib-analogist sweep verdict. The clean iter-195 dispatch (if any)
would be:

1. **If iter-200 mathlib-analogist verdict lands Stacks 00OE bridge**:
   close `isRegularLocalRing_stalk_of_smooth` via
   ```
   Stage 4 → IsStandardSmoothOfRelativeDimension.iff (extract n) →
   Stage 5b → rank Ω[stalk⁄Γ(Spec, U)] = n →
   cotangent-residue-field tensor identity →
   Module.finrank κ(p) (CotangentSpace _) = n →
   ringKrullDim (stalk z) = n (00OE) →
   IsRegularLocalRing.iff_finrank_cotangentSpace
   ```
2. **If iter-200 verdict lands Stacks 0AVF (depth-≥2 H¹ vanishing)**:
   close `extend_of_codimOneFree_of_smooth` via the documented
   `topIso.inv ≫ isoOfEq.inv ≫ toPartialMap.hom` extraction.
3. **If iter-200 verdict lands `Scheme.RationalMap` function-field
   pullback bridge**: close
   `indeterminacy_pure_codim_one_into_grpScheme` via the 4-substep
   chain documented inline.

Without any iter-200 verdict, this lane stays at 3 sorries.

## Files changed

- `AlgebraicJacobian/Albanese/CodimOneExtension.lean`:
  - L480-514 (inside `isRegularLocalRing_stalk_of_smooth`): updated
    gap docstring to enumerate 2 specific sub-gaps with Mathlib path
    references.
  - L684 (`extend_of_codimOneFree_of_smooth`): converted bare `sorry`
    to `by` block with axiom-clean `Y.left.IsSeparated` derivation +
    precise gap commentary + morphism-extraction recipe.
  - L752 (`indeterminacy_pure_codim_one_into_grpScheme`): converted
    bare `sorry` to `by` block with 4-substep precise gap surface.

No new declarations, no new helpers, no axioms introduced.
