# Blueprint Review Report

## Slug
ts231

## Iteration
231

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:dual_isLocallyTrivial`: the proof body (lines 3013–3038) still describes the OLD recipe routing through `lem:open_immersion_slice_sheaf_equiv` (overSliceSheafEquiv). A `% NOTE (iter-230 review, EMPIRICALLY FALSIFIED — pending blueprint-writer rewrite)` comment at line 3002 explicitly marks that paragraph WRONG but the rewrite has NOT happened. The directive claims this was corrected this iter with "the minimal objectwise V⊆U route"; it was not. The corrected recipe is absent.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:dual_isLocallyTrivial`: after H1, the proof claims the residual
  `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)`
  is discharged by the shared slice-site sheaf equivalence
  `lem:open_immersion_slice_sheaf_equiv`. The iter-230 NOTE (lines 3002–3012) explicitly refutes this: the residual is presheaf-level + varying-ring module, while `overSliceSheafEquiv` is sheaf-level + fixed-value-cat — three mismatches confirmed by live `lean_goal`. The new "minimal objectwise V⊆U route" that the analogist ts231ih confirms is near-definitional is NOT written in the proof body. A prover receiving this chapter will attempt the refuted recipe.

### Multi-route coverage

The only multi-route strategy element is the C-bridge (`dual_restrict_iso` / `lem:dual_isLocallyTrivial`):
- **Objectwise V⊆U route (new; prover target)**: MISSING — no proof block contains this route.
- **overSliceSheafEquiv route (old; empirically falsified)**: present in proof body but explicitly marked wrong.
- **Object-level descent fallback (`rem:dual_via_stack`)**: PRESENT — `rem:dual_via_stack` documents this as a standalone fallback.

### Citation discipline

No new citation violations found on this pass. Existing `% SOURCE:` blocks (with `(read from ...)` parentheticals) verified for the chapters audited in depth.

## Unstarted-phase blueprint proposals

The A.2.c-engine phase (HOLD) has thin blueprint coverage: the `Picard_QuotScheme.tex` chapter USES R^i f_* and Castelnuovo–Mumford m-regularity as black boxes (in `lem:quot_boundedness` and `thm:flat_base_change_cohomology`) but no dedicated blueprint chapters exist for the underlying machinery. Three foundational engine sub-phases have zero blueprint coverage.

---

### Proposed chapter: `blueprint/src/chapters/Picard_HigherDirectImages.tex`

**Covers**: `AlgebraicJacobian/Picard/HigherDirectImages.lean` (new file)
**Strategy phase**: A.2.c-engine (Quot/Cartier, RR-free)
**Why now**: R^i f_* (i≥1) is the deepest root of the engine — every downstream piece (m-regularity, semi-continuity, the Quot boundedness step) invokes it. Writing this chapter now lets parallel provers target it independently of the RelPic/substrate work, and the USER standing parallelism directive makes early blueprinting directly actionable.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:higher_direct_images}` — For a qcqs morphism f : X → S of schemes and a quasi-coherent sheaf F on X, define R^i f_* F as the i-th right derived functor of the direct-image functor f_*. `\lean{AlgebraicGeometry.Scheme.higherDirectImage}` [expected]. Source: `references/stacks-coherent.md` → stacks-coherent.tex §02KH; Nitsure §3.
2. `\lemma` `\label{lem:higher_direct_image_zero}` — R^0 f_* F = f_* F (the zeroth direct image is the ordinary pushforward). `\lean{AlgebraicGeometry.Scheme.higherDirectImage_zero}` [expected]. Source: standard, Stacks 02KH.
3. `\lemma` `\label{lem:higher_direct_image_vanishing_affine}` — If f : X → S is affine and F quasi-coherent, then R^i f_* F = 0 for i ≥ 1. `\lean{AlgebraicGeometry.Scheme.higherDirectImage_vanishing_affine}` [expected]. Source: `references/stacks-coherent.md` → cohomology of affine schemes.
4. `\theorem` `\label{thm:higher_direct_image_base_change_flat}` — (Flat base change, Stacks 02KH) For a cartesian square with g flat and f qcqs, the canonical map g* R^i f_* F → R^i f'_* (g')* F is an isomorphism. `\lean{AlgebraicGeometry.flatBaseChangeCohomology}` [already in `Picard_QuotScheme.tex` as `thm:flat_base_change_cohomology` — consolidate here as primary home]. Source: `references/stacks-coherent.md` → stacks-coherent.tex §02KH.
5. `\lemma` `\label{lem:higher_direct_image_locally_free_of_flat_cohomology}` — If f is proper flat and F is coherent flat over S, the sheaves R^i f_* F are locally free on S (cohomology and base change). `\lean{AlgebraicGeometry.higherDirectImage_locally_free}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §3.
6. `\lemma` `\label{lem:higher_direct_image_surjection_of_generators}` — When R^i f_* F is locally free and the canonical evaluation map π* π_* F(r) → F(r) is surjective for r ≥ m, the map π^* (π_* F(r)) → F(r) is a surjection. `\lean{AlgebraicGeometry.higherDirectImage_generatorsMap_surjective}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §5.

**`\uses` skeleton**:
- `thm:higher_direct_image_base_change_flat` uses `def:higher_direct_images`
- `lem:higher_direct_image_locally_free_of_flat_cohomology` uses `thm:higher_direct_image_base_change_flat`
- `lem:higher_direct_image_surjection_of_generators` uses `lem:higher_direct_image_locally_free_of_flat_cohomology`

**Main theorem proof strategy**: The flat base-change result (Stacks 02KH) is already blueprinted in `Picard_QuotScheme.tex`; this chapter should move that declaration here as its primary home and cross-reference it from QuotScheme. The vanishing-on-affines result follows from the vanishing of sheaf cohomology on affine schemes (Serre's theorem, Stacks 01XT), which requires showing R^i f_* for affine f factors through the affine global-sections exact functor. The locally-free result (item 5) is the hard piece: it needs the Grauert cohomology-and-base-change theorem (Nitsure §3) which is itself Mathlib-absent; that theorem should be pinned as a named sorry in this chapter.

**References for writer**:
- `references/stacks-coherent.md` → stacks-coherent.tex, §02KH — primary source for flat base-change statement and proof sketch
- `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex, §3 "Semi-continuity and base-change" — Grauert's base-change and the locally-free result
- `references/stacks-constructions.md` → stacks-constructions.tex — for qcqs morphism API

**Subphase choices exposed**:
- Construction via Čech cohomology vs. injective-resolution derived category: Čech is easier to formalize for qcqs morphisms on schemes but requires a separate "Čech = sheaf cohomology on separated qcqs" theorem. Derived category approach is Mathlib-native (Ext on abelian categories) but requires ∞-categorical machinery. **Recommendation**: Čech approach for this project, with a sorry for the Čech-vs-sheaf comparison, matching the project's cohomology conventions in `Cohomology_MayerVietoris.tex`.

---

### Proposed chapter: `blueprint/src/chapters/Picard_CMRegularity.tex`

**Covers**: `AlgebraicJacobian/Picard/CMRegularity.lean` (new file)
**Strategy phase**: A.2.c-engine (Quot/Cartier, RR-free)
**Why now**: The Castelnuovo–Mumford m-regularity bound is the load-bearing step in `lem:quot_boundedness` (already in `Picard_QuotScheme.tex`), which is cited there as a black box. Without a blueprint, the prover has no guidance on what needs to be built. Writing this chapter now unblocks parallel prover lanes on the engine sub-pieces.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:cm_regularity}` — A coherent sheaf F on P^n_k is m-regular (Castelnuovo–Mumford) if H^i(P^n, F(m-i)) = 0 for all i > 0. `\lean{AlgebraicGeometry.Scheme.IsCMRegular}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §2.
2. `\lemma` `\label{lem:cm_regular_global_generation}` — If F is m-regular then F(m) is globally generated, and for j ≥ m, F(j) is globally generated. `\lean{AlgebraicGeometry.Scheme.CMRegular.globally_generated}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §2 (Castelnuovo Lemma).
3. `\lemma` `\label{lem:cm_regular_vanishing}` — If F is m-regular, then H^i(P^n, F(j)) = 0 for i > 0, j ≥ m. `\lean{AlgebraicGeometry.Scheme.CMRegular.cohomology_vanishing}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §2.
4. `\theorem` `\label{thm:mumford_uniform_bound}` — (Mumford's theorem, Nitsure §2) For fixed n, p ∈ ℤ_{≥0}, and Φ ∈ ℚ[λ], there exists m = m(n, p, Φ) such that every coherent quotient F of O^⊕p on P^n with Hilbert polynomial Φ is m-regular. `\lean{AlgebraicGeometry.Scheme.mumfordUniformBound}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §2.

**`\uses` skeleton**:
- `lem:cm_regular_global_generation` uses `def:cm_regularity`, `lem:cm_regular_vanishing`
- `thm:mumford_uniform_bound` uses `def:cm_regularity`, `lem:cm_regular_global_generation`

**Main theorem proof strategy**: The definition and the vanishing lemma are the key pieces; both require H^i computations on projective space, which can be done via Čech cohomology. The uniform-bound theorem (Mumford) is more involved — it uses induction on n and the long exact sequence; it may need to be pinned as a sorry initially with a detailed sketch. The chapter should annotate `thm:mumford_uniform_bound` as the primary sorry target feeding `lem:quot_boundedness` in `Picard_QuotScheme.tex`.

**References for writer**:
- `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex, §2 "Castelnuovo–Mumford Regularity" — primary source; verbatim theorem statements available
- `references/fga-explained.md` → FGA Explained Ch. 5 — supplementary context

**Subphase choices exposed**:
- Intrinsic vs. extrinsic m-regularity: Nitsure defines regularity intrinsically for P^n (no ambient embedding needed for quotients of O^⊕p). The project can use the same approach. No fundamental choice needed here.

---

### Proposed chapter: `blueprint/src/chapters/Picard_SemiContinuity.tex`

**Covers**: `AlgebraicJacobian/Picard/SemiContinuity.lean` (new file)
**Strategy phase**: A.2.c-engine (Quot/Cartier, RR-free)
**Why now**: Nitsure §3 (semi-continuity and base-change for flat families) is cited in `lem:quot_boundedness` as "Base-change for flat sheaves" without a dedicated blueprint. The result that cohomology commutes with flat base-change (and the locally-free statement when higher cohomology vanishes) is central to the entire Quot engine. Blueprinting it now separates it from `Picard_HigherDirectImages.tex` and lets two provers work in parallel.

**Key declarations** (in dependency order):
1. `\theorem` `\label{thm:semi_continuity_upper}` — For a proper flat morphism f : X → S of noetherian schemes and a coherent F on X, the function s ↦ dim H^i(X_s, F_s) is upper semi-continuous on S. `\lean{AlgebraicGeometry.higherDirectImage_upperSemiContinuous}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §3.
2. `\theorem` `\label{thm:grauert_direct_image}` — (Grauert's theorem) In the same setup, if s ↦ dim H^i(X_s, F_s) is locally constant on S, then R^i f_* F is locally free and the base-change map κ(s) ⊗ R^i f_* F → H^i(X_s, F_s) is an isomorphism. `\lean{AlgebraicGeometry.grauertDirectImage}` [expected]. Source: `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §3.
3. `\theorem` `\label{thm:cohomology_commutes_flat_base_change}` — (= `thm:flat_base_change_cohomology` from `Picard_QuotScheme.tex`, Stacks 02KH) For a cartesian square with g flat and f qcqs, the canonical base-change map g* R^i f_* F → R^i f'_* (g')* F is an isomorphism. This is the version consumed by `lem:quot_boundedness`. `\lean{AlgebraicGeometry.flatBaseChangeCohomology}` [already declared]. Source: `references/stacks-coherent.md` → stacks-coherent.tex §02KH.

**`\uses` skeleton**:
- `thm:grauert_direct_image` uses `thm:semi_continuity_upper`, `def:higher_direct_images` (from `Picard_HigherDirectImages.tex`)
- `thm:cohomology_commutes_flat_base_change` uses `def:higher_direct_images`

**Main theorem proof strategy**: Semi-continuity and Grauert's theorem are major results that are Mathlib-absent. Both should initially be pinned as named sorries with detailed proof sketches following Nitsure §3. The critical link for the Quot engine is `thm:cohomology_commutes_flat_base_change` (= Stacks 02KH, already in QuotScheme as a `\leanok` sorry); this chapter consolidates the source references and gives a proof outline via the Čech complex.

**References for writer**:
- `references/nitsure-hilbert-quot.md` → nitsure-hilbert-quot.tex §3 "Semi-Continuity and Base-Change" — primary; contains verbatim theorem statements
- `references/stacks-coherent.md` → stacks-coherent.tex §02KH — Stacks flat base change
- `references/fga-explained.md` → FGA Explained Ch. 5 §5.2 — supplementary

**Subphase choices exposed**:
- Grauert as a sorry vs. Grauert proof-first: Given the engine is on HOLD (USER RR pause), the semi-continuity chapter should use named sorries for `thm:semi_continuity_upper` and `thm:grauert_direct_image`, with the `thm:cohomology_commutes_flat_base_change` (Stacks 02KH) as the piece with the lowest sorry-debt and the best chance of landing axiom-clean via the affine Čech argument. Recommendation: sorry-first for Grauert, attempt Stacks 02KH directly.

---

**Engine gating summary** (per directive item 2):

Pieces **ungated** (buildable now from Mathlib + existing project infra):
- `R^i f_*` functor construction (Stacks 02KH base change) — no project dependency
- Castelnuovo-Mumford m-regularity (Nitsure §2) — depends only on R^i f_* and projective-space cohomology
- Semi-continuity / Grauert (Nitsure §3) — depends only on R^i f_*
- Grassmannian representability — ALREADY BLUEPRINTED in `Picard_QuotScheme.tex`
- Flattening stratification — ALREADY BLUEPRINTED in `Picard_FlatteningStratification.tex`

Pieces **gated behind substrate/RelPic** (cannot land until the ⊗-group law lands):
- Abel map representability (`lem:line_bundle_quot_correspondence`) — needs `etSheaf`
- Full Picard scheme assembly (`thm:fga_pic_representability`) — needs RelPic + substrate
- Group-scheme structure on Pic — needs the abelian-group structure from TensorObjSubstrate

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - informational: Lean bodies for `PicSharp`, `PicSharp.functorial`, `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure` are placeholder implementations (constant-PUnit functor, zero maps) gated on the substrate. The blueprint correctly documents this with explicit DO-NOT-promote notes at each block. No blueprint correctness issue; documented state is accurate.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - informational: `lem:quot_boundedness` invokes the Castelnuovo–Mumford m-regularity theorem of Nitsure §2 and "Base-change for flat sheaves" (Nitsure §3) as black-box citations without dedicated blueprint chapters. This is now addressed by the three unstarted-phase proposals above. No correctness issue in the existing chapter.
  - informational: `thm:flat_base_change_cohomology` is blueprinted here; the three proposed new chapters should designate `Picard_HigherDirectImages.tex` as its primary home and cross-reference from here.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - informational: Seven sorries all documented with sorry-by-sorry analysis (rank 1/2/3). Sorries 5, 6, 7 are Route-C-blocked and correctly marked. No blueprint issue.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: true
- **notes**:
  - informational: Notes "Lean target file does not yet exist" — correct statement of current state for an A.3 specification chapter; no blueprint problem.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: true
- **notes**:
  - informational: Notes "Lean target file does not yet exist" — correct for an A.3 specification chapter.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **MUST-FIX (hard gate)**: `lem:dual_isLocallyTrivial` proof body (lines 3013–3038) describes the OLD route: after H1 the residual is "discharged by the shared slice-site sheaf equivalence `lem:open_immersion_slice_sheaf_equiv`." The iter-230 NOTE at lines 3002–3012 explicitly marks this "EMPIRICALLY FALSIFIED — pending blueprint-writer rewrite." The rewrite has NOT been done. The proof body as written will misdirect the prover.
  - **MUST-FIX (hard gate)**: The directive refers to `lem:dual_restrict_iso` as a blueprint label — this label does NOT exist in the chapter. The closest declaration is `lem:dual_isLocallyTrivial`. If the plan intends a new declaration named `lem:dual_restrict_iso`, it must be added. If the intent is to correct `lem:dual_isLocallyTrivial`'s proof body, that correction must replace lines 3013–3038 with the new "minimal objectwise V⊆U route" (near-definitional identity-on-values + O(V)-linearity, no global slice-site machinery).
  - **MUST-FIX (hard gate)**: The new minimal objectwise route must blueprint: (a) for V⊆U open in X, restriction along V⊆U followed by dual equals dual followed by restriction (near-definitional since the dual presheaf formula `(M|_V → R|_V)` is the value of the dual at V); (b) O(V)-linearity of the comparison (trivial by construction of the scalar action); (c) assembly into the locally-trivial proof (trivialise L on U, restrict to V, identity-of-duals, restrict trivialisation).
  - missing: the label `lem:dual_restrict_iso` (referenced in analogist notes and strategy discussion) should appear as a named lemma if it is intended as a separate declaration from `lem:dual_isLocallyTrivial`, or the two names should be resolved.
  - informational: `lem:tensorobj_assoc_iso` proof body is marked "Status (route mismatch, deferred)" — the correct description of the current sorry state; no additional must-fix.
  - informational: `lem:tensorobj_unit_iso` has no `\leanok` marker — consistent with the unit's current sorry state; not a must-fix.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

## Severity summary

### must-fix-this-iter

1. **`Picard_TensorObjSubstrate.tex` / `lem:dual_isLocallyTrivial` proof body**: proof text starting at line 3013 is empirically falsified (iter-230 NOTE). Blueprint-writer must replace with the minimal objectwise V⊆U route before any prover dispatch on `Picard/TensorObjSubstrate.lean`. Gate FAILS — chapter is `correct: partial`.

2. **`Picard_TensorObjSubstrate.tex` / `lem:dual_restrict_iso` label resolution**: the label referenced in the directive does not exist in the chapter. Writer must either (a) add a distinct `lem:dual_restrict_iso` declaration for the minimal objectwise comparison, or (b) rename/correct `lem:dual_isLocallyTrivial`'s proof to incorporate the new route and annotate accordingly.

3. **unstarted-phase proposal: A.2.c-engine / R^i f_*** — dispatch blueprint-writer for `Picard_HigherDirectImages.tex` or record explicit deferral.

4. **unstarted-phase proposal: A.2.c-engine / CM-regularity** — dispatch blueprint-writer for `Picard_CMRegularity.tex` or record explicit deferral.

5. **unstarted-phase proposal: A.2.c-engine / semi-continuity** — dispatch blueprint-writer for `Picard_SemiContinuity.tex` or record explicit deferral.

### soon

- `Picard_QuotScheme.tex` / `thm:flat_base_change_cohomology`: once `Picard_HigherDirectImages.tex` exists, the primary home of this declaration should move there (cross-ref from QuotScheme). Not urgent while the engine is on HOLD.
- `Picard_RelPicFunctor.tex` / `thm:rel_pic_etale_sheaf_unit_canonical`: the forward-looking canonical sheafification unit theorem has no `\lean{}` pin. Once the substrate lands, the plan agent should add the pin. Not blocking any current prover lane.

Overall verdict: **`Picard_TensorObjSubstrate.tex` is `correct: partial` — the proof body of `lem:dual_isLocallyTrivial` is empirically falsified and not yet corrected; the prover gate FAILS for `Picard/TensorObjSubstrate.lean` until the blueprint-writer delivers the minimal objectwise V⊆U recipe. 3 unstarted-phase proposals provided for the A.2.c engine; 33 chapters audited, 3 must-fix findings (1 hard gate + 2 unstarted-phase), 2 soon-severity findings.**
