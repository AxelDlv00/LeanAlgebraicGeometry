# Blueprint Review Report

## Slug
iter057

## Iteration
057

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:cechSection_complex_iso`: statement is
  mis-specified (see "Proofs lacking detail" and "Dependency & isolation findings" below for
  the corrected form). The proof sketch is internally consistent with the *wrong* statement
  but does not address the augmentation mismatch.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cechSection_contractible`: statement is
  provably false as written; proof sketch is silent on the degree-0 augmentation node.
  Both of these blocks need full re-statement *and* extended proof sketches before a prover
  can dispatch.
- `Cohomology_CechHigherDirectImage.tex` / `lem:affine_serre_vanishing_general_open`:
  condition (3) in the proof claims "same quasi-coherent seed as `lem:affine_serre_vanishing`"
  but the seed for a general affine open V ≅ Spec Γ(V) is a *change-of-ring* Čech vanishing
  (seed over base ring Γ(V), not a localization of R) — the seed
  `sectionCech_homology_exact_of_localizationAway` used for D(f) does NOT apply. A new
  lemma block is required before the general Serre vanishing can be dispatched.
- `Cohomology_CechHigherDirectImage.tex`: 9 prover-built helpers are isolated
  `lean_aux` nodes with no blueprint coverage. Of these, 7 need new blocks; 1 can be disposed
  as a `\mathlibok` anchor; 1 (`jShriekOU_homEquiv_nat`, private) needs a wire-up.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cechSection_contractible`: The proof sketch
  invokes `depHomotopy`/`depHomotopy_spec` (which covers degrees ≥ 1) but never addresses the
  augmentation node (degree 0 ↔ degree −1 edge). The correct proof must spell out: (i) the
  `h^{−1}` component sends `s ∈ ∏_i Γ(U_i∩V,F)` to its `i_fix`-th component in Γ(V,F); (ii)
  the identity `d^{−1} ∘ h^{−1} + h^0 ∘ d^0 = id` at degree 0 reduces to the sheaf-equalizer
  identity (the restriction of any section on ∏_i Γ(U_i∩V,F) agrees with the augmentation of
  its i_fix-th component, using V ≤ U_{i_fix}). This is the canonical sheaf-equalizer argument
  that is *absent* from the current sketch.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cechSection_complex_iso`: The current proof
  sketch matches D evaluated at V (through toPresheaf) against the *non-augmented* D'; but D
  has degree 0 = Γ(V, pushPullObj F Y_0) while D' has degree 0 = ∏_i Γ(U_i∩V,F). The
  corrected proof must additionally show the degree-(-1) terms agree via the identity map
  Γ(V,F) = Γ(V,F) and that the augmentation maps correspond. The degreewise differential match
  argument is otherwise unchanged.
- `Cohomology_CechHigherDirectImage.tex` / `lem:affine_serre_vanishing_general_open`: Condition
  (3) in the proof ("holds by the same quasi-coherent seed") needs to be replaced by a reference
  to a new `lem:affine_cech_vanishing_general_seed` block that spells out the change-of-ring
  route: (a) V ≅ Spec Γ(V) via `Scheme.isoSpec`; (b) the standard cover {D_V(g_i)} transports
  to a spanning cover of Spec Γ(V); (c) `sectionCech_affine_vanishing` runs over ring Γ(V);
  (d) vanishing transports back. This new seed is categorically different from the D(f) seed.

### Dependency & isolation findings

From `leandag build --json` (0 unknown_uses, 63 unmatched_lean, 9 isolated lean_aux nodes):

**Isolated lean_aux nodes — dispositions:**

- `lean:AlgebraicGeometry.CechAcyclic.affine` (has sorry; CechAcyclic.lean, STRATEGY
  marks it "dead shared acyclicity"): **keep** — it is the sorry placeholder for the dead
  sibling of `cechAugmented_exact`; STRATEGY notes it explicitly. Add a `% NOTE:` in the
  chapter acknowledging the sorry and that this route is subsumed. No blueprint block needed.

- `lean:AlgebraicGeometry.isAffineOpen_specBasicOpen` (proved 2-line wrap of
  `basicOpenIsoSpecAway`; AffineSerreVanishing.lean): **wire-up** — this is a trivial corollary
  of Mathlib. Add a `\mathlibok` anchor `lem:isAffineOpen_specBasicOpen` with
  `\lean{AlgebraicGeometry.isAffineOpen_specBasicOpen}` stating that every basic open
  D(r) ⊆ Spec R is affine. Pin it near `def:affine_cover_system_general` (see below). If the
  declaration is confirmed to be just a wrapper, the mathlib name is
  `AlgebraicGeometry.isAffine_basicOpen` or similar — verify before writing.

- `lean:AlgebraicGeometry.jShriekOU_homEquiv_nat` (private lemma; OpenImmersionPushforward.lean):
  **wire-up** — this is a *private* helper lemma for the naturality of the jShriekOU hom-equiv;
  `jShriekOU_homEquiv_naturality` is already listed in `lem:absolute_cohomology_zero_natural`
  (line 3138). Add `AlgebraicGeometry.jShriekOU_homEquiv_nat` to that block's `\lean{...}` list.
  No new block needed; it is the private precursor of the public naturality declaration.

- `lean:AlgebraicGeometry.affineCoverSystemGeneral` (proved; AffineSerreVanishing.lean):
  **wire-up** — needs a NEW blueprint definition block `def:affine_cover_system_general`
  (`\lean{AlgebraicGeometry.affineCoverSystemGeneral}`) stating that `affineCoverSystemGeneral R`
  is a `BasisCovSystem` whose basis is all affine opens of Spec R and whose covers are finite
  standard covers {D(g_i)} of those opens. This is the generalisation of `def:affine_cover_system`
  and is the main structural fact enabling `lem:affine_serre_vanishing_general_open`.

- `lean:AlgebraicGeometry.standard_cover_cofinal_affine` (proved; AffineSerreVanishing.lean):
  **wire-up** — needs a NEW blueprint lemma block `lem:standard_cover_cofinal_affine`
  (`\lean{AlgebraicGeometry.standard_cover_cofinal_affine}`) stating that for any affine open
  V ⊆ Spec R and any open cover {W_α} of V, there exist a standard cover {D(g_i)} of V that
  refines {W_α}. This is the general-affine companion of `lem:standard_cover_cofinal` (which
  covers only D(f) opens); distinct statement and proof.

- `lean:AlgebraicGeometry.affine_surj_of_vanishing_affine` (proved; AffineSerreVanishing.lean):
  **wire-up** — needs a NEW blueprint lemma block `lem:affine_surj_of_vanishing_affine`
  (`\lean{AlgebraicGeometry.affine_surj_of_vanishing_affine}`) stating the surjectivity-of-sections
  field for the general affine cover system: for a short exact sequence S in (Spec R).Modules,
  if every higher Čech cohomology of any standard cover of any affine open vanishes, then H^0
  sections surjection holds. This is the `surj_of_vanishing` field of
  `affineCoverSystemGeneral`.

- `lean:AlgebraicGeometry.affine_cech_vanishing_qcoh_general_of_tildeVanishing` (proved;
  AffineSerreVanishing.lean): **wire-up** — needs a NEW blueprint lemma block
  `lem:affine_cech_vanishing_general_of_tildeVanishing` stating the reduction from
  quasi-coherent general-affine Čech vanishing to the tilde case via `qcoh_iso_tilde_sections`.
  This is the analogue of `lem:affine_cech_vanishing_qcoh_of_tildeVanishing` but for arbitrary
  affine opens (not just D(f)).

- `lean:AlgebraicGeometry.affine_serre_vanishing_general_of_seed` (proved; AffineSerreVanishing.lean):
  **wire-up** — needs a NEW blueprint lemma block `lem:affine_serre_vanishing_general_of_seed`
  (`\lean{AlgebraicGeometry.affine_serre_vanishing_general_of_seed}`) stating that
  `HasVanishingHigherCech (affineCoverSystemGeneral R) F` implies affine Serre vanishing for every
  affine open V. This is the application of `cech_eq_cohomology_of_basis` to the general cover system.

- `lean:AlgebraicGeometry.affine_serre_vanishing_general_of_tildeVanishing` (proved;
  AffineSerreVanishing.lean): **wire-up** — needs a NEW blueprint lemma block
  `lem:affine_serre_vanishing_general_of_tildeVanishing` assembling the general-affine Serre
  vanishing from the tilde vanishing via the chain
  `affine_cech_vanishing_qcoh_general_of_tildeVanishing` + `affine_serre_vanishing_general_of_seed`.
  This is the top-level public form for `lem:affine_serre_vanishing_general_open`.

**Unmatched `\lean{}` nodes (63 total):** These are `\mathlibok` nodes whose `\lean{...}` names
are not found in Mathlib (most likely because leandag does not scan transitive Mathlib imports at
DAG-build time). `leandag build --json` reports `unknown_uses: []` so no broken `\uses{}` edges
exist. The 63 unmatched are all `\mathlibok` declarations — they are Mathlib-backed by design and
the count is expected. No action required.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:horseshoe_twist`, `lem:horseshoe_chainMap`, `lem:horseshoe_resolvesMiddle`,
    `lem:right_derived_shift_split_resolution`, `lem:cosyzygy_ses`, `lem:applied_cosyzygy_cycles`,
    `lem:cohomology_of_applied_resolution` lack `\leanok` on their statement blocks. The `sync_leanok`
    phase controls these; P4 is COMPLETED in STRATEGY so these may carry sorrys in intermediate
    declarations or the markers may not have synced. Not a blueprint correctness issue, informational
    only.
  - All proof sketches are mathematically detailed and adequate for a prover.
  - All `\uses{}` edges appear correct (no unknown_uses from leandag).
  - All `\mathlibok` anchors look faithful to standard Mathlib (horseshoe biproduct injectivity,
    split biproduct SES, right-derived injection vanishing, etc.).

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: partial
- **notes**:

  **HARD FAILURES — must-fix before prover dispatch:**

  1. **`lem:cechSection_complex_iso` (line 7667) — mis-specified statement.**
     The current statement reads "the augmented Čech complex of `def:cech_augmented_complex`
     evaluated at V … is isomorphic to the concrete section Čech complex D'^\bullet … with
     D'^p = ∏_σ Γ(U_σ∩V, F)". This is FALSE: the augmented D has degree −1 term Γ(V,F) while
     the non-augmented D' starts at degree 0. The two differ at degree 0 even for a trivial
     cover.
     **Corrected statement:** D (augmented) is isomorphic to D'_aug := (sectionCechComplex
     U'·).augment ε hε, where U'_σ = U_σ∩V, ε: Γ(V,F) → ∏_i Γ(U_i∩V,F) is the restriction
     product map (the evaluation at V of the Čech augmentation), and hε: ε ≫ d^0 = 0. The
     degree-(−1) isomorphism is the identity Γ(V,F)=Γ(V,F); the degree-p isomorphisms (p ≥ 0)
     are `lem:pushPull_eval_prod_iso`; the augmentation maps correspond by construction of
     `def:cech_augmentation`. The `\lean{}` hint should target a declaration that builds this
     augmented iso, not the current (incorrect) bare D ≅ D'.

  2. **`lem:cechSection_contractible` (line 7709) — provably false + incomplete proof sketch.**
     The current statement claims id_{D'^\bullet} ≃ 0 (contractibility of the NON-augmented
     section Čech complex). This is FALSE: for a one-member cover {V}, D'^0 = Γ(V,F), d^0 = 0,
     so H^0(D') = Γ(V,F) ≠ 0.
     **Corrected statement:** There is a contracting homotopy Homotopy (𝟙 D'_aug) 0 on the
     AUGMENTED complex D'_aug = D'.augment ε hε. The homotopy data:
     - For p ≥ 1: the degree-(p−1)→p component h^{p−1} prepends i_fix to each multi-index σ;
       since V ≤ U_{i_fix}, U_{i_fix,σ}∩V = U_σ∩V, so h^{p−1} is the identity on each
       coefficient and the depHomotopy engine supplies dh + hd = id for these degrees.
     - **Augmentation node (must be added to proof sketch):** The degree-(−1)/0 homotopy
       component h^{−1}: D'^{aug,0} = ∏_i Γ(U_i∩V,F) → Γ(V,F) = D'^{aug,−1} is the
       i_fix-th coordinate projection π_{i_fix}. Verification: for any s ∈ ∏_i Γ(U_i∩V,F),
       (d^{−1} ∘ h^{−1} + h^0 ∘ d^0)(s)_j = ε(π_{i_fix}(s))_j + h^0(d^0(s))_j. Because
       V ≤ U_{i_fix}, the restriction of s_{i_fix} to U_j∩V is the j-th component of ε(s_{i_fix});
       this plus the depHomotopy contribution for the non-augmented part yields s_j. The formal
       verification is the sheaf-equalizer identity: Γ is a sheaf, so s_{i_fix}|_{U_j∩V} is fully
       determined by the intersections, and the identity dh + hd = id at degree 0 follows.
       This argument CANNOT be delegated to the depHomotopy engine (which handles only degrees
       ≥ 1 of the non-augmented complex); it needs an explicit augmentation-node computation
       in the proof sketch and in the Lean proof.

  3. **`lem:affine_serre_vanishing_general_open` (line 8323) — incorrect seed claim.**
     The proof at line 8366: "condition (3) of `lem:cech_to_cohomology_on_basis` (standard-cover
     Čech vanishing) holds by the same quasi-coherent seed as in `lem:affine_serre_vanishing`."
     This is INACCURATE. For `lem:affine_serre_vanishing`, the seed is
     `sectionCech_homology_exact_of_localizationAway`, which works by: (a) D(f) ≅ Spec R_f with
     R_f a localization of R; (b) the covering elements g_i/1 span the unit ideal of R_f; (c) run
     the polymorphic standard-cover exactness over R_f. For a GENERAL affine open V of Spec R:
     — Γ(V) is NOT a localization of R in general (V is not D(f) for any single f ∈ R);
     — there is no element f ∈ R such that V = D(f), so
       `sectionCech_homology_exact_of_localizationAway` does not apply directly.
     **A NEW lemma block is required:**
     `lem:affine_cech_vanishing_general_seed` (or a renamed sub-block within the proof):
     Let R be a ring, V any affine open of Spec R, and g: Fin n → Γ(V) a spanning family
     (Ideal.span(range g) = ⊤ in Γ(V)) such that V = ⊔_i D_V(g_i). Then for any quasi-coherent
     F and p ≥ 1, Ȟ^p({D_V(g_i)}, F) = 0.
     Proof sketch: (a) V ≅ Spec Γ(V) by `lem:isoSpec_scheme_mathlib`; transport the cover
     {D_V(g_i)} to the standard cover {D(g_i)} of Spec Γ(V) (spanning hypothesis holds in
     Γ(V) by assumption); (b) apply `sectionCech_affine_vanishing` / `affine_cech_vanishing_qcoh`
     over the base ring Γ(V) (NOT over R, and NOT via localization at a single f); (c) transport
     vanishing back. The Lean implementation of this route is
     `affine_cech_vanishing_qcoh_general_of_tildeVanishing` (iter-056, isolated), which uses
     `qcoh_iso_tilde_sections` and the polymorphic `dDiff_exact` over Γ(V).

  4. **Coverage debt — 7 isolated lean_aux nodes need new blueprint blocks** (detailed under
     "Dependency & isolation findings" above): `affineCoverSystemGeneral`,
     `standard_cover_cofinal_affine`, `affine_surj_of_vanishing_affine`,
     `affine_cech_vanishing_qcoh_general_of_tildeVanishing`, `affine_serre_vanishing_general_of_seed`,
     `affine_serre_vanishing_general_of_tildeVanishing`, and `jShriekOU_homEquiv_nat` (wire-up
     to existing block). Additionally `isAffineOpen_specBasicOpen` needs a `\mathlibok` anchor.
     And `CechAcyclic.affine` (sorry-bearing, dead route) needs a `% NOTE:` acknowledgement in
     the chapter text.

  **Correct parts of the chapter (informational):**
  - All `\uses{}` cross-references are valid (leandag reports 0 unknown_uses).
  - The blueprint-doctor reports no broken refs, no malformed_refs, no undefined macros,
    no orphan chapters, no math-delim errors.
  - The main argument structure (`lem:cech_augmented_resolution`, the toSheaf-reflect bridge,
    `lem:affine_serre_vanishing`, `lem:cech_term_pushforward_acyclic`, `lem:cech_acyclic_affine`,
    the P3b free-presheaf machinery) is mathematically sound and well-specified.
  - `lem:affine_serre_vanishing` (line 3211) and its proof are correct and self-contained;
    the distinguished-D(f) route is properly documented.
  - The `lem:modules_isoSpec_ext_transport` (Need#1) block is present, correctly stated, and
    its proof sketch is sound (Scheme.isoSpec + Ext.mapExactFunctor).
  - `def:affine_cover_system` (`affineCoverSystem`, basis = D(f) opens) is correctly specified
    and distinct from the general `affineCoverSystemGeneral` that needs a new block.

## Cross-chapter notes

- `Cohomology_HigherDirectImage.tex` / `def:higher_direct_image` is used by
  `Cohomology_CechHigherDirectImage.tex` / `lem:cech_computes_cohomology` (the main theorem,
  not yet in the blueprint). No missing edge; the dependency flows from the consolidated chapter's
  `\uses{}` to the `def:higher_direct_image` label from the companion chapter. No action needed.

## Severity summary

### must-fix-this-iter

1. **`lem:cechSection_complex_iso` mis-specified** — incorrect iso target (D ≅ D' is false;
   correct target is D ≅ D'_aug). Blocks `CechSectionIdentification.lean` prover dispatch.
   Writer directive: re-state to target D ≅ D'_aug; extend proof sketch to cover degree-(−1)
   augmentation iso and map correspondence.

2. **`lem:cechSection_contractible` provably false + incomplete** — non-augmented D' is not
   contractible; correct target is `Homotopy (𝟙 D'_aug) 0`. Proof sketch silent on degree-0
   augmentation node. Blocks `CechSectionIdentification.lean` prover dispatch.
   Writer directive: re-state to target augmented D'_aug; extend proof sketch to include explicit
   sheaf-equalizer argument for the (−1)/0 augmentation homotopy component (see "Proofs lacking
   detail" above for exact content required).

3. **`lem:affine_serre_vanishing_general_open` proof claims incorrect seed** — the general-affine
   seed is a change-of-ring Čech vanishing over Γ(V), NOT the localization-away seed. Blocks
   `AffineSerreVanishing.lean` prover dispatch.
   Writer directive: (a) add a NEW lemma block `lem:affine_cech_vanishing_general_seed` with the
   change-of-ring proof sketch (V ≅ Spec Γ(V), standard cover of Spec Γ(V), run vanilla seed
   over Γ(V)); (b) revise condition (3) of `lem:affine_serre_vanishing_general_open` to cite this
   new block; (c) add a new `def:affine_cover_system_general` block for
   `affineCoverSystemGeneral`; (d) add new lemma blocks for the 6 other isolated helpers.

4. **7 isolated lean_aux nodes without blueprint entries** — `affineCoverSystemGeneral`,
   `standard_cover_cofinal_affine`, `affine_surj_of_vanishing_affine`,
   `affine_cech_vanishing_qcoh_general_of_tildeVanishing`,
   `affine_serre_vanishing_general_of_seed`,
   `affine_serre_vanishing_general_of_tildeVanishing`, `jShriekOU_homEquiv_nat`.
   All live in `AffineSerreVanishing.lean` / `OpenImmersionPushforward.lean`, both covered by
   `Cohomology_CechHigherDirectImage.tex`. Missing edges make the DAG incomplete and deprive
   the plan agent of a coherent completeness view.

### soon

- `isAffineOpen_specBasicOpen` — isolated lean_aux node; add `\mathlibok` anchor.
- `CechAcyclic.affine` — sorry-bearing isolated node on a dead sub-route; add a `% NOTE:`
  in the chapter text clarifying its status (dead sibling of the cechAugmented_exact route,
  subsumed by iter-053's toSheaf bridge). No new block required; the note prevents stale
  confusion.
- Several lemmas in `Cohomology_AcyclicResolution.tex` lack `\leanok` markers on their statement
  blocks (horseshoe_twist, horseshoe_chainMap, horseshoe_resolvesMiddle,
  right_derived_shift_split_resolution, cosyzygy_ses, applied_cosyzygy_cycles,
  cohomology_of_applied_resolution). This is a sync_leanok bookkeeping gap — not a blueprint
  error, since P4 is COMPLETED. Review after next sync_leanok pass.

Overall verdict: **3 chapters audited, 4 must-fix findings, 0 unstarted-phase proposals.** The
consolidated chapter `Cohomology_CechHigherDirectImage.tex` has `correct: partial` and `complete:
partial`; the HARD GATE blocks both `CechSectionIdentification.lean` and `AffineSerreVanishing.lean`
from prover dispatch until a blueprint-writer re-specs Stubs 5/6 (augmented complex correction +
augmentation-node proof sketch) and authors the change-of-ring seed block + 7 isolation wire-ups.
