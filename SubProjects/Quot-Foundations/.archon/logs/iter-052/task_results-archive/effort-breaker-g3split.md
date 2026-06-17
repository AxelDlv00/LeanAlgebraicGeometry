# Effort Breaker Report

## Slug
g3split

## Target
`lem:gf_flat_locality_assembly` (`AlgebraicGeometry.gf_flat_locality_assembly`) in
`blueprint/src/chapters/Picard_FlatteningStratification.tex`.

## Status
COMPLETE — target re-expressed as a `\uses`-linked chain of 4 project sub-lemmas over
6 Mathlib anchors. **Key finding: the "deep" Source-reduction step IS in Mathlib**
(`Module.flat_of_isLocalized_maximal`), so it needed no further break and no
project-side mathlib-build — it became a `\mathlibok` anchor.

## Effort before → after
- target `effort_local`: 3957 → **2459**
- sub-lemmas added: 4 project lemmas + 6 Mathlib anchors (10 new blocks)
- new sub-lemma efforts: gf_patch_free_imp_flat=210, gf_stalk_flat_over_base=1244,
  gf_flat_base_local_on_source=806, gf_stalk_flat_localBase=584. All Mathlib anchors=0.

## Mathlib anchors verified (loogle) and added with `\mathlibok`
- `lem:mathlib_flat_of_free` → `Module.Flat.of_free` (Flat.Basic) — free ⇒ flat.
- `lem:mathlib_flat_localization_preserves` → `Module.Flat.of_isLocalizedModule`
  (Flat.Stability) — localization preserves flatness (the Step-2 anchor; the directive's
  three candidate names were all wrong, this is the real one).
- `lem:mathlib_localization_flat` → `IsLocalization.flat` (Flat.Localization) — a
  localization is a flat module (used in Step-3 transitivity).
- `lem:mathlib_flat_of_localized_maximal` → `Module.flat_of_localized_maximal`
  (Flat.Localization) — base-maximal locality.
- `lem:mathlib_flat_of_isLocalized_maximal` → `Module.flat_of_isLocalized_maximal`
  (Flat.Localization) — **the Source-reduction anchor**: `S` an `R`-algebra, `M` an
  `S`-module flat over `R` iff `M_q` flat over `R` for every maximal `q ⊂ S`. Exactly the
  "flatness over a base is local on the source" the directive feared absent. Present.
- `lem:mathlib_flat_trans` → `Module.Flat.trans` (Flat.Stability) — transitivity.

## Chain added (target ← L_n ← … ← L1)
- `lem:gf_patch_free_imp_flat` `\lean{…gf_patch_free_imp_flat}` — each `(M_j)_f` flat over
  `A_f` (Step 1). `\uses{lem:mathlib_flat_of_free}` (effort ≈ 210).
- `lem:gf_stalk_flat_over_base` `\lean{…gf_stalk_flat_over_base}` — `F_x` flat over
  `O_{S,p(x)}` for `x ∈ p⁻¹(V)` (Step 2).
  `\uses{lem:gf_patch_free_imp_flat, lem:mathlib_flat_localization_preserves,
  lem:qcoh_section_localization_basicOpen, lem:gf_qcoh_fintype_finite_sections}`.
- `lem:gf_flat_base_local_on_source` `\lean{…gf_flat_base_local_on_source}` — **the deep
  Source-reduction step**: `B` an `R`-algebra, `N` a `B`-module, `N` flat over `R` if
  `N_q` flat over `R` for every maximal `q ⊂ B`. Now a thin specialization of the Mathlib
  anchor. `\uses{lem:mathlib_flat_of_isLocalized_maximal}` (effort ≈ 806).
- `lem:gf_stalk_flat_localBase` `\lean{…gf_stalk_flat_localBase}` — `F_y` flat over
  `O_{S,x}` via transitivity along the localization `O_{S,x} → O_{S,p(y)}` (Step 3).
  `\uses{lem:gf_stalk_flat_over_base, lem:mathlib_localization_flat, lem:mathlib_flat_trans}`.
- Target `lem:gf_flat_locality_assembly` proof rewritten to the synthesis:
  `\uses{lem:gf_patch_free_imp_flat, lem:gf_stalk_flat_over_base,
  lem:gf_flat_base_local_on_source, lem:gf_stalk_flat_localBase,
  lem:mathlib_flat_of_localized_maximal, lem:gf_qcoh_fintype_finite_sections,
  lem:qcoh_section_localization_basicOpen}`. Statement and `\lean{}` unchanged.

## Graph verification
- `archon dag-query node` — target effort 3957 → 2459, dep_count 2 → 7.
- `archon dag-query ancestors` — all 10 new nodes resolve into the cone; no broken `\uses`.
- `archon dag-query unmatched` — 4 unmatched nodes, all pre-existing/unrelated (Grassmannian
  + module_finite); none of the new blocks are unmatched.

## Still hard (re-break candidates)
- `lem:gf_stalk_flat_over_base` (effort 1244) is the largest remaining piece: it bundles
  the quasi-coherence stalk-as-localization identification with the `f`-invertibility
  re-localization and the localization-preserves-flatness application. If the prover stalls,
  re-dispatch at fine granularity to split (a) stalk = localization of `(M_j)_f`, from
  (b) flatness transport. Not done now since directive asked one level except Source.

## Could not decompose (strategy items)
- None. Every seam in the original proof maps to a sub-lemma; the one feared-absent piece
  turned out to be a genuine Mathlib lemma.

## References consulted
- No new reference file needed: the four (now six) anchors are Mathlib decls verified via
  loogle, and the existing Nitsure §4 / Stacks 01PB citations in the chapter already cover
  the surrounding context. Source-reduction read directly from
  `Mathlib/RingTheory/Flat/Localization.lean` (decls `flat_of_isLocalized_maximal`,
  `flat_of_localized_maximal`).

## Notes for dispatcher
- `\lean{}` names assigned by convention (confirm/scaffold): `AlgebraicGeometry.gf_patch_free_imp_flat`,
  `AlgebraicGeometry.gf_stalk_flat_over_base`, `AlgebraicGeometry.gf_flat_base_local_on_source`,
  `AlgebraicGeometry.gf_stalk_flat_localBase` (all Lean decls do NOT exist yet — build targets).
- The Mathlib anchors reuse exact Mathlib decl names (`Module.Flat.of_free`, etc.) — no scaffold needed.
- The source-reduction `lem:gf_flat_base_local_on_source` is NOT a project mathlib-build as
  the directive anticipated; it is a one-step instantiation of `Module.flat_of_isLocalized_maximal`.
- No new macros required.
