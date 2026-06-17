# Lean ↔ Blueprint Check Report

## Slug
basicopencech-iter106

## Iteration
106

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (1812 LOC)
- Blueprint: `blueprint/src/chapters/Cohomology_MayerVietoris.tex`, focused on
  §"Čech acyclicity for the structure sheaf on affine basic-open covers"
  (L1110–L1180) and the upstream Basic-open / Intersection-helper subsections
  (L941–L1108) the chapter references.

## Per-declaration

Only declarations the blueprint chapter explicitly references via `\lean{...}`
are listed; everything else (the R-linearity engine + named-family glue +
auxiliary `presheafMap_restrict_collapse`) is part of the known iter-104/105
carry-over and is treated under "Blueprint adequacy" below per directive.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover}` (chapter: def:Scheme_basicOpenCover)
- **Lean target exists**: yes (`basicOpenCover`, L55).
- **Signature matches**: yes — `(s : Set Γ(C.left, U)) : s → Opens` with body
  `f ↦ C.left.basicOpen f.1`. Prose: "sends $f \in s$ to $D(f)$." ✓
- **Proof follows sketch**: N/A (definition, no proof body).
- **Notes**: thin Mathlib wrapper, matches prose verbatim.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top}` (chapter: thm:Scheme_basicOpenCover_supr_of_span_eq_top)
- **Lean target exists**: yes (L73).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — direct call to
  `hU.iSup_basicOpen_eq_self_iff.mpr hs`. ✓

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_isAffineOpen}` (chapter: thm:Scheme_basicOpenCover_isAffineOpen)
- **Lean target exists**: yes (L91). Matches prose.

### `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen}` (chapter: thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen)
- **Lean target exists**: yes (L117). Body bundles the four-tuple per prose.

### `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve}` (chapter: thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen_curve)
- **Lean target exists**: yes (L139). Matches "direct specialisation."

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_inter_eq_basicOpen_mul}` (chapter: thm:Scheme_basicOpenCover_inter_eq_basicOpen_mul)
- **Lean target exists**: yes (L164). ✓

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_inter_isAffineOpen}` (chapter: thm:Scheme_basicOpenCover_inter_isAffineOpen)
- **Lean target exists**: yes (L187). ✓

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_eq_basicOpen_prod}` (chapter: thm:Scheme_basicOpenCover_finset_inf_eq_basicOpen_prod)
- **Lean target exists**: yes (L222).
- **Proof follows sketch**: yes — `Finset.cons_induction`, matching "by
  induction on the finite subset, using the binary case." ✓

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isAffineOpen}` (chapter: thm:Scheme_basicOpenCover_finset_inf_isAffineOpen)
- **Lean target exists**: yes (L261).

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le}` (chapter: thm:Scheme_basicOpenCover_finset_inf_le)
- **Lean target exists**: yes (L296).

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization}` (chapter: thm:Scheme_basicOpenCover_finset_inf_isLocalization)
- **Lean target exists**: yes (L330).
- **Signature matches**: yes — `IsLocalization.Away (∏ i ∈ t, i.1)` with
  algebra structure threaded explicitly via `homOfLE _.op.toAlgebra`. The
  blueprint prose specifies "the algebra structure given by the presheaf
  restriction map", which matches the `@`-binding the Lean uses. ✓

### `\lean{AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective}` (chapter: def:Scheme_splitEpi_pi_lift_of_injective)
- **Lean target exists**: yes (L362, `noncomputable def`).
- **Signature matches**: yes — `Pi.lift (fun b => Pi.π M (f b))` admits a
  `SplitEpi`. Prose previews the section via "extend families on $B$ to
  families on $A$ by the chosen values on the complement" — the Lean
  implementation uses `Classical.dec` + `h.choose_spec ▸ Pi.π ...` on the image
  and `0` on the complement, mathematically equivalent. ✓
- **Proof follows sketch**: yes; the verification identity uses injectivity to
  collapse the transport, mirroring the prose's "verify the section identity
  pointwise."

### `\lean{AlgebraicGeometry.Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt}` (chapter: thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt)
- **Lean target exists**: yes (L404).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — two-step `isZero_homology` →
  `subsingleton_of_isZero` chain, matching "n-cocycles equal n-coboundaries,
  so the quotient has at most one element." ✓

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}` (chapter: thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf)
- **Lean target exists**: yes (L1170).
- **Signature matches**: yes — `IsCechAcyclicCover (toModuleKSheaf C)
  (basicOpenCover s)` under `(hU : IsAffineOpen U)` and `(hs : Ideal.span s =
  ⊤)`. ✓
- **Proof follows sketch**: PARTIAL — three transient sorries (Lean L1212
  `h_a`, L1536 `h_transport`, L1564 `h_a₀`, L1802 `h_loc_exact`) plus the
  L1120 sorry inside the cited helper `cechCofaceMap_pi_smul`. The
  four-step blueprint sketch is faithfully reproduced in the Lean's
  step-by-step comment scaffolding (L1186–L1809). Each blueprint step has a
  matching Lean phase:
  * Blueprint Step 1 (Reduction to per-generator local exactness) ↔ Lean
    L1180–L1185 reduction via
    `cechCohomology_subsingleton_of_cechCochain_exactAt`.
  * Blueprint Step 3 (Contraction by extra degeneracy) ↔ Lean `h_a` /
    `h_a₀` (slice-cover `ExactAt n` via extra-degeneracy; both sorries).
  * Blueprint Remark (Finite-subspanning) ↔ Lean L1377–L1405 `hs_fin` +
    `h_transport`.
  * Blueprint Step 2 (Identification of localized complex) ↔ Lean
    `h_loc_X_i` + the iter-108 `h_loc_exact` recipe (L1781–L1802):
    `h_V_le_U`, `h_slice_eq` via `Scheme.basicOpen_res`, deferred glue.
  * Blueprint Step 4 (Globalization) ↔ Lean L1805
    `exact_of_localized_span (↑s₀ : Set R) h_top f_R g_R h_loc_exact`.
- **Notes**: The remaining sorries are the iter-104/105/108 carry-overs the
  directive explicitly tells me NOT to re-flag. No prose-vs-Lean
  contradiction was found.

## Red flags

None this iteration. The remaining sorries are paused-by-directive
infrastructure (L1120 inside `cechCofaceMap_pi_smul`, L1802 inside
`h_loc_exact`, and the iter-066 split-epi assembly + the iter-061/064 `h_a` /
`h_a₀` extra-degeneracy stubs). Each is annotated with a multi-paragraph
comment block stating the Mathlib API targeted (`Scheme.basicOpen_res`,
`isLocalization_of_eq_basicOpen`, `IsLocalizedModule.pi`, `IsLocalizedModule.iso`,
`Function.Exact.iff_of_ladder_linearEquiv`, `exact_of_localized_span`,
`FormalCoproduct.extraDegeneracyCech`,
`SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`). No excuse-comments,
no weakened-wrong definitions, no `:= True` placeholders, no `axiom`
introductions, no `Classical.choice _` patterns on substantive claims.

## Unreferenced declarations (informational)

The following Lean declarations have no corresponding `\lean{...}` block in
the chapter. All are part of the iter-087/096/098/102/104/105 R-linearity
engine + named-family + auxiliary glue, which is the **known
"soon" carry-over** flagged by blueprint-reviewer-iter106 (per directive).

* `presheafMap_restrict_collapse` (L425) — iter-087 helper for nested
  restriction collapse.
* `cechCofaceMap_summand_family` (L454) — iter-102 named-family head for the
  sign-free Čech coface morphism components.
* `cechCofaceMap_summand_family_R_linear` (L502) — iter-104 R-linearity at
  binder level.
* `cechCofaceMap_summand_family'` (L612) — iter-105 `Fin (n+1)`-indexed
  wrapper.
* `cechCofaceMap_summand_family'_R_linear` (L642) — iter-105 R-linearity of
  the wrapper.
* `alternating_sum_pi_smul_aux` (L764) — iter-096/097 structural lemma.
* `alternating_sum_pi_smul_aux_sum_comp` (L813) — iter-098/099 sum-through-
  composition variant.
* `alternating_zsmul_pi_smul_aux_sum_comp` (L863) — iter-102/103 zsmul-through-
  composition variant.
* `cechCofaceMap_pi_smul` (L928) — iter-087 corrective R-linearity claim
  specialised to the project's Čech-cochain context (body has the L1120
  paused sorry).

Per directive: do not re-flag.

## Blueprint adequacy for this file

- **Coverage**: 13/22 substantive declarations carry a `\lean{...}` block
  in the chapter (counting `def`/`theorem`/`lemma` with non-trivial bodies).
  Unreferenced: 9 substantive declarations (the iter-087/096/098/102/104/105
  R-linearity + named-family engine). All 9 are tagged in
  blueprint-reviewer-iter106's "soon" carry-over.
- **Proof-sketch depth**: **adequate-but-thin** for the iter-108 partial
  setup. The blueprint's four-step sketch (Step 1 reduction, Step 2
  identification, Step 3 contraction, Step 4 globalization) correctly
  previews the *high-level* mathematical content of the L1170 theorem. A
  prover reading the sketch alone would:
  * Understand the four-step decomposition.
  * Know that the Remark sanctions a finite-subspanning reduction.
  * Recognise that Step 2's "identification" is the per-coordinate
    `O_X(V_x)[1/f] ≅ O_X(V_x ∩ D(f))` identification.
  * Need to **discover independently** the specific Mathlib API used
    (`Scheme.basicOpen_res`, `IsLocalizedModule.pi`,
    `Function.Exact.iff_of_ladder_linearEquiv`,
    `IsLocalizedModule.iso`, `LocalizedModule.map_exact`), because the
    sketch names none of these by Mathlib identifier. This is normal for
    a sketch at this level.
  * Need to discover independently the SplitEpi-on-each-degree refinement
    transport for `h_transport` — the Remark says "the refinement map is a
    quasi-isomorphism" but does not preview the specific argument the Lean
    is building (build `π : K ⟶ K₀` via `cechFunctor.map` + `whiskerLeft` +
    `whiskeringLeft`, show each `π.f i` is a split epi via
    `splitEpi_pi_lift_of_injective`, then short-exact-of-complexes
    diagram-chase from kernel acyclicity). This is **the largest** sketch
    gap I observe.
  * Need to discover independently the R-linearity engine
    (`cechCofaceMap_pi_smul` + named-family + sum-aux glue). The blueprint
    does not preview this at all — it is the known carry-over.
- **Hint precision**: **precise**. Every `\lean{...}` hint in the chapter
  pins exactly one Lean identifier and that identifier exists at the right
  signature in `BasicOpenCech.lean`. No "loose" or "wrong" hints.
- **Generality**: **matches need**. The chapter's declarations are stated at
  the universal level the project consumes (over arbitrary `(C : Over (Spec
  (.of k)))`, arbitrary affine `U`, arbitrary spanning subset `s`). No
  parallel API was forced by under-specified blueprint definitions.
- **Recommended chapter-side actions**: All of the following are
  blueprint-reviewer-iter106's "soon" carry-over. Restated here for
  visibility, NOT as new flags:
  1. Add blueprint blocks (or a §"R-linearity infrastructure" subsection)
     for the named-family + R-linearity engine
     (`cechCofaceMap_summand_family`, `cechCofaceMap_summand_family'`,
     `cechCofaceMap_summand_family_R_linear`,
     `cechCofaceMap_summand_family'_R_linear`,
     `cechCofaceMap_pi_smul`, `alternating_sum_pi_smul_aux` family).
  2. Expand the four-step proof sketch to preview Mathlib API at the
     level of detail iter-108's `h_loc_exact` recipe uses
     (`Scheme.basicOpen_res`, `isLocalization_of_eq_basicOpen`,
     `IsLocalizedModule.pi`, the algebra-adapter bridge between
     `IsLocalization.Away` and `IsLocalizedModule.Away`).
  3. Add a paragraph previewing the `h_transport` SplitEpi route (or
     replace it with a quasi-iso route if the project decides to switch
     strategy in iter-109+).

## Severity summary

- **must-fix-this-iter**: 0.
- **major**: 0 (the three "Recommended chapter-side actions" above are the
  iter-104/105 named-family carry-over + iter-108 sketch-expansion carry-over
  flagged by blueprint-reviewer-iter106; per directive, not re-flagged).
- **minor**: 0.

**Overall verdict**: The Čech-acyclicity section's four-step sketch
adequately previews the high-level mathematical structure that
`BasicOpenCech.lean` L1170–L1809 is implementing; no prose-vs-Lean
contradiction was found, the "soon" carry-over remains appropriate, and the
drift has not hardened to a blocking level.

---

`basicopencech-iter106: PASS — 13 declarations checked, 0 red flags`
