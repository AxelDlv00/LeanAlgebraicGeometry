# blueprint-reviewer — iter-195 Report

**Date:** 2026-05-27  
**Iter:** 195  
**Slug:** blueprint-reviewer-iter195  
**Directive:** `.archon/logs/iter-195/blueprint-reviewer-iter195-directive.md`

---

## Executive summary

32 chapters audited. **1 must-fix-this-iter finding** (blocks iter-195 BareScheme.lean NEW LANE
dispatch per HARD GATE rule). All other active-prover chapters pass. 5 unstarted-phase blueprint
proposals identified.

---

## Must-fix finding (HARD GATE blocker)

### [BLOCKING] `AbelianVarietyRigidity.tex` — missing `\lean{...}` pins for BareScheme.lean:151–163

**Chapter:** `blueprint/src/chapters/AbelianVarietyRigidity.tex`  
**Lean files blocked:** `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` (via `archon:covers`)  
**Sorrys targeted by NEW LANE:** `projectiveLineBar_smoothOfRelDim` and `projectiveLineBar_geomIrred`

**Finding:** The chapter contains a bundled `def:genus0_base_objects` block that describes
`ProjectiveLineBar` as "smooth proper geometrically irreducible" in informal prose and pins
`\lean{AlgebraicGeometry.ProjectiveLineBar}` for the *object* definition. However, there are no
dedicated `\begin{theorem}` / `\begin{lemma}` blocks for the two instance/theorem proofs that live
at `BareScheme.lean:151–163`:
- `AlgebraicGeometry.ProjectiveLineBar.instSmoothOfRelDim` (or equivalent; `projectiveLineBar_smoothOfRelDim`)
- `AlgebraicGeometry.ProjectiveLineBar.instGeometricallyIrreducible` (or equivalent; `projectiveLineBar_geomIrred`)

Per HARD GATE: a chapter covering a Lean file must be `complete: true` AND `correct: true` AND
have no must-fix-this-iter finding. The absence of any `\lean{...}` block for these two
scaffold sorrys constitutes a must-fix-this-iter finding. The iter-195 BareScheme.lean NEW LANE
is **blocked** until the fix lands.

**Required fix (plan agent action, NOT prover):**

Add two dedicated declaration blocks inside `AbelianVarietyRigidity.tex`, within or immediately
after `def:genus0_base_objects`. Example placement:

```latex
\begin{lemma}\leanok
  \label{lem:projectiveLineBar_smoothOfRelDim}
  \lean{AlgebraicGeometry.ProjectiveLineBar.instSmoothOfRelDim}
  $\mathbb{P}^1_\mathbb{Z} \to \Spec\mathbb{Z}$ is smooth of relative dimension $1$.
  Specialised to the base field $k$, this gives the smooth-of-rel-dim-1 instance on
  $\mathbb{P}^1_k = \mathrm{ProjectiveLineBar} \times_{\Spec\mathbb{Z}} \Spec k$.
\end{lemma}

\begin{lemma}\leanok
  \label{lem:projectiveLineBar_geomIrred}
  \lean{AlgebraicGeometry.ProjectiveLineBar.instGeometricallyIrreducible}
  $\mathbb{P}^1_k \to \Spec k$ is geometrically irreducible: the base change
  $\mathbb{P}^1_K$ is irreducible for every field extension $K/k$. This follows from
  the fact that $\mathbb{P}^1_\mathbb{Z}$ is irreducible and the base change of an
  irreducible projective space to any field is irreducible (projective space over a
  field is integral).
\end{lemma}
```

Lean declaration names should be verified against the current `BareScheme.lean:151–163` before
adding. The plan agent should read the current file to confirm exact names before writing.

**Severity:** HARD GATE BLOCKER — blocks BareScheme.lean NEW LANE dispatch for iter-195.

---

## Per-chapter checklist (32 chapters)

Columns: **complete** = all relevant declarations pinned; **correct** = `\lean{...}` names
match current Lean files + math sound; **must-fix** = blocking this iter.

---

### Chapters under active prover work (iter-195)

**1. `AbelianVarietyRigidity.tex`**  
Covers: `AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean`, `BareScheme.lean` (NEW LANE),
`ChartIso.lean`, `Points.lean`, `GmScaling.lean`, `RigidityLemma.lean`

| | |
|---|---|
| complete | **false** — `projectiveLineBar_smoothOfRelDim` and `projectiveLineBar_geomIrred` have no dedicated `\lean{...}` blocks |
| correct | true for all other pins |
| must-fix | **YES** — blocks BareScheme.lean NEW LANE |

Notes:
- `rigidity_lemma` (Mumford Form I), `av_regularMap_isHom_of_zero`, `hom_additive_decomp_of_rigidity`, `hom_from_Ga_trivial`, `morphism_P1_to_AV_constant`, `hom_from_Gm_trivial_of_hom_from_Ga_trivial`, `rational_map_to_av_extends`, `rigidity_genus0_curve_to_AV` — all pinned and well-documented
- `gm_geomIrred` and `projGm_isReduced` documented as typed sorrys gated on `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` (absent at Mathlib b80f227) — correctly flagged
- `gmScalingP1_chart_agreement` has residual sorry; (III.c) separated-locus alternative is live route (~150–200 LOC over 3–5 iters) — correctly documented
- iter-195 must-fix: add two `\lean{...}` blocks for the BareScheme instance sorrys (see Must-fix section above)

---

**2. `RiemannRoch_H1Vanishing.tex`**  
Covers: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes:
- NOTE at lines 182–193 documents iter-194 decomposition: 3 axiom-clean substrate helpers
  (`shortExact_app_surjective` substrate, stalkwise helper, `SAb.Exact` wrapper) — 3 closed
- Iter-195 closure target: `(sheafCompose (forget₂ ModuleCat AddCommGrpCat)).PreservesHomology`
  — documented explicitly as single remaining sorry inside `shortExact_app_surjective`
- PreservesHomology / stalkwise approach IS documented; prover has a clear charter
- **PASSES HARD GATE**

---

**3. `Picard_QuotScheme.tex`**  
Covers: `AlgebraicJacobian/Picard/QuotScheme.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes:
- `def:pullback_app_isoTensor_sigma` with `\lean{AlgebraicGeometry.pullback_app_isoTensor_baseMap_sectionLinearEquiv}` carries both the LinearEquiv AND the intertwining identity — Σ-pair form for `IsBaseChange.of_equiv` consumption is present
- `lem:tildeIso_of_isQuasicoherent_isAffineOpen` (Stacks 01I8) and `lem:pullback_tildeIso` (Stacks 01HQ) both pinned
- **PASSES HARD GATE** for lane-f-step12-sigma-pair dispatch

---

**4. `Picard_Pic0AbelianVariety.tex`**  
Covers: `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes: 5 pinned declarations verified current against file:
1. `\lean{AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso}` — thm:pic0_tangent_space_iso
2. `\lean{AlgebraicGeometry.Scheme.Pic0.smooth}` — thm:pic0_smooth
3. `\lean{AlgebraicGeometry.Scheme.Pic0.proper}` — thm:pic0_proper
4. `\lean{AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible}` — thm:pic0_geom_irred
5. `\lean{AlgebraicGeometry.Scheme.Pic0.isAbelianVariety}` — thm:pic0_isAbelianVariety

WD-4 iter-194 fix (stale-note removal + AddEquiv/LinearEquiv gap documentation) present.
`identityComponent_geometricallyConnected` demotion from `private instance` to `private theorem`
documented (prevents sorryAx propagation). **PASSES HARD GATE** for explore-and-commit-partial dispatch.

---

**5. `RiemannRoch_WeilDivisor.tex`**  
Covers: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes: Weil divisor on a smooth curve, positive/negative part split, divisor degree, closed-point
order function — all pinned. Hartshorne II.6.9 body infrastructure documented. **PASSES HARD GATE**.

---

**6. `RiemannRoch_OCofP.tex`**  
Covers: `AlgebraicJacobian/RiemannRoch/OCofP.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes: `h0_sub_h1_lineBundleAtClosedPoint_eq_two` and `h1_vanishing_genusZero` gating `OC(P)` body
are typed sorrys on the H1Vanishing substrate — correctly documented. Structurally sorry-free
for this chapter's own declarations. **PASSES HARD GATE**.

---

**7. `RiemannRoch_RRFormula.tex`**  
Covers: `AlgebraicJacobian/RiemannRoch/RRFormula.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes: `lem:H1_skyscraperSheaf_finrank_eq_zero` is a typed-sorry blocker gated on H1Vanishing
substrate — correctly documented. All declarations well-pinned. **PASSES HARD GATE**.

---

**8. `RiemannRoch_RationalCurveIso.tex`**  
Covers: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

| | |
|---|---|
| complete | true |
| correct | true |
| must-fix | no |

Notes: 4 pinned declarations (all `\leanok`). NOTE (iter-194): `iso_of_degree_one` body
inline Step 2 (scheme-level lift via Normalization) remains typed sorry; 4 sub-obligations (a)–(d)
documented inline; per-fibre LQF step is Mathlib gap (iter-200 sweep candidate). Well documented.
**PASSES HARD GATE**.

---

### Chapters not under active prover work this iter

**9. `RiemannRoch_OcOfD.tex`**  
Covers: `AlgebraicJacobian/RiemannRoch/OcOfD.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 4 pinned declarations, all `\leanok`. Covers subsheaf-of-K_C recipe from iter-182.

---

**10. `Picard_RelativeSpec.tex`**  
Covers: `AlgebraicJacobian/Picard/RelativeSpec.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: Iter-179 Block A refactor upgraded carrier to 3-field structure using
`NatTrans.Coequifibered`. Lane D HARD-BAR closed both Mathlib-gap sorrys axiom-clean iter-185.
Signature refinement (Yoneda-bijection / canonical iso) pending iter-180+; documented as advisory.

---

**11. `Picard_LineBundlePullback.tex`**  
Covers: `AlgebraicJacobian/Picard/LineBundlePullback.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: `lem:IsLocallyTrivial_pullback` lands with 1 narrow named typed sorry on chart-iso
composition (iter-188+ closure ~30–50 LOC). `IsLocallyTrivial` definition well-pinned.
DONE iter-188 (axiom-clean for main declarations).

---

**12. `Picard_IdentityComponent.tex`**  
Covers: `AlgebraicJacobian/Picard/IdentityComponent.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 10 pinned declarations. Stacks 037Q lemma
(`lem:geometricallyConnected_of_connected_of_section`) added iter-194 as first-class blueprint
obligation. `identityComponent_geometricallyConnected` demotion documented.
`IdentityComponent.isOpenSubgroupScheme` kernel-only.

---

**13. `Picard_FGAPicRepresentability.tex`**  
Covers: `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 5 pinned declarations for the Route A assembly chapter. All typed sorrys gated on
upstream Route A infrastructure — documented.

---

**14. `Picard_FlatteningStratification.tex`**  
Covers: `AlgebraicJacobian/Picard/FlatteningStratification.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 4 pinned declarations, all `\leanok`. Substantial Mathlib gaps (Castelnuovo-Mumford
regularity, relative forms) documented. Stacks 052H coverage present.

---

**15. `Picard_RelPicFunctor.tex`**  
Covers: `AlgebraicJacobian/Picard/RelPicFunctor.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 5 pinned declarations. iter-176 rename `PicScheme` → `PicSharp.etSheaf` documented.
Advisory: exact Mathlib declaration name for étale-Grothendieck-topology on Sch/k not pinned
(verification flag for prover).

---

**16. `Genus.tex`**  
Covers: `AlgebraicGeometry.genus`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: Single definition with `\lean{AlgebraicGeometry.genus}` and `\leanok`.
User authorised `noncomputable` modifier. Serre finiteness gap (carrier predicate approach) documented.

---

**17. `Differentials.tex`**  
Covers: Kähler differentials / localization utilities

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 5 pinned declarations, all `\leanok`. Post-iter-126 M1 excise state documented.
Bridge declaration removed; only standalone K-ähler-localization utilities remain.

---

**18. `Genus0BaseObjects_Cross01Substrate.tex`**  
Covers: `AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 2 pinned declarations, both `\leanok`. Substrate for Lane B GmScaling cocycle and
off-target instances `gm_geomIrred`, `projGm_isReduced`.

---

**19. `Albanese_AlbaneseUP.tex`**  
Covers: `AlgebraicJacobian/Albanese/AlbaneseUP.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 6 pinned declarations, all `\leanok`. Symmetric-power route (not autoduality/cube).
`SymmetricPower` has no Mathlib analogue (project-side sub-build) — documented.
Retired moduli/autoduality route preserved as `% NOTE` comment.

---

**20. `Albanese_AuslanderBuchsbaum.tex`**  
Covers: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 6 pinned declarations, all `\leanok`. NOTE (iter-184): 4 core AB-formula proof
ingredients absent in Mathlib b80f227; `exists_isRegular_of_regularLocal` is the `of_regular`
blocker (Stacks 00NQ ~300 LOC). AB formula NON-BLOCKING for A.4.a. Body has load-bearing
typed sorry on `regularLocal_inductive_step`.

---

**21. `Albanese_CodimOneExtension.tex`**  
Covers: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true (with 1 advisory) | no |

Notes:
- `lem:smooth_to_regular_local_ring` (Stacks 00TT) typed sorry — Stage 6 open Mathlib gap documented
- `thm:weil_divisor_obstruction` has DETACHED `\lean{...}` pin (iter-179 detach, requires
  `Scheme.RationalMap`-to-function-field pullback machinery not in Mathlib) — correctly flagged
- Stage 5a + 5b axiom-clean since iter-193 documented
- Advisory: detached pin at `thm:weil_divisor_obstruction` should be reviewed when
  function-field pullback lands

---

**22. `Albanese_CoheightBridge.tex`**  
Covers: `AlgebraicJacobian/Albanese/CoheightBridge.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 4 pinned declarations, all `\leanok`. Closes Krull-dim half of `hreg_dim` obligation.
IsRegularLocalRing half (Stacks 00TT) remains in CodimOneExtension.

---

**23. `Albanese_Thm32RationalMapExtension.tex`**  
Covers: `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: Single declaration `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` (`\leanok`).
Milne Theorem 3.2 char-free, consumes thm:codim_one_extension (Milne 3.1) and
lem:milne_codim1_indeterminacy (Milne 3.3).

---

**24. `AbelJacobi.tex`**  
Covers: `AlgebraicJacobian/AbelJacobi.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 3 pinned declarations, all `\leanok`:
- `\lean{AlgebraicGeometry.Jacobian.ofCurve}` — def:ofCurve
- `\lean{AlgebraicGeometry.Jacobian.comp_ofCurve}` — lem:comp_ofCurve
- `\lean{AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp}` — thm:exists_unique_ofCurve_comp

All proved as projections from the Albanese witness. Well-documented Layer II API.

---

**25. `Jacobian.tex`**  
Covers: `AlgebraicJacobian/Jacobian.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: Extremely detailed chapter (601 lines). Key declarations:
- `\lean{AlgebraicGeometry.IsAlbanese}`, `\lean{AlgebraicGeometry.JacobianWitness}` (`\leanok`)
- `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (`\leanok`, body sorry — documented as
  explicit foundational hypothesis, single remaining gap)
- `\lean{AlgebraicGeometry.genusZeroWitness}` (`\leanok`, body sorry — gated on
  `prop:rigidity_genus0_curve_to_AV` upstream keystone)
- `\lean{AlgebraicGeometry.positiveGenusWitness}` (`\leanok`, body sorry — gated on Route A)
- `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` (Route A.4; body sorry — gated on Thm 3.2)
- `\lean{AlgebraicGeometry.Jacobian}` (`\leanok`) and 4 protected instances (`\leanok`)

All typed sorrys are properly documented with explicit gate chains. iter-172 audit of Route A.4
(bypass-FAILS, Milne autoduality bypass failure) documented. iter-135 body restructure documented.

---

**26. `Rigidity.tex`**  
Covers: `AlgebraicJacobian/RigidityLemma.lean` (via AbelianVarietyRigidity.tex archon:covers;
this chapter has no standalone `archon:covers` tag — advisory)

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 1 pinned declaration:
- `\lean{AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen}` (`\leanok`) — scheme-level rigidity
  theorem (Mumford Form I, iter-125 refactor dropping 8 unused hypotheses)

Advisory: chapter lacks its own `% archon:covers` tag. Coverage for `RigidityLemma.lean` flows
through AbelianVarietyRigidity.tex's archon:covers. This is not blocking (RigidityLemma.lean is
not under active prover work this iter) but should be noted.

---

**27. `RigidityKbar.tex`**  
Covers: `AlgebraicJacobian/RigidityKbar.lean`, `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
(per `% archon:covers` line 4)

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes:
- `\lean{AlgebraicGeometry.rigidity_over_kbar}` (`\leanok`, body sorry — correctly documented as
  named gap with `[CharZero kbar]` + `[IsAlgClosed kbar]`)
- Fallback route (a) — df=0 / cotangent-triviality decomposition documented; chart-algebra
  envelope supplies only the converse implication
- iter-152 alg-closed pivot documented; Iter-157 committed-route disposition documented
- The committed route is `prop:rigidity_genus0_curve_to_AV` in AbelianVarietyRigidity.tex
  (not this chapter); this chapter is correctly framed as the fallback-(a) artifact
- ChartAlgebra.lean coverage: KDM lemma, constants-integral-over-base-field,
  chart_algebra_df_zero_factors_through_constant_on_chart — all closed axiom-clean (documented)
- Advisory: `[CharZero kbar]` hypothesis on `rigidity_over_kbar` makes it a non-committed path;
  this is correctly documented. No action required.

---

**28. `Cohomology_StructureSheafAb.tex`**  
Covers: `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (no explicit `archon:covers` tag)

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 3 pinned declarations, all `\leanok`:
- `\lean{AlgebraicGeometry.Cohomology.instHasSheafify_Opens_AddCommGrp}`
- `\lean{AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_AddCommGrp}`
- `\lean{AlgebraicGeometry.Scheme.toAbSheaf}`

Phase A step 2–4. Advisory: no `archon:covers` tag (not blocking).

---

**29. `Cohomology_SheafCompose.tex`**  
Covers: `AlgebraicJacobian/Cohomology/SheafCompose.lean` (no explicit `archon:covers` tag)

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: 1 pinned declaration, `\leanok`:
- `\lean{AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp}`

Phase A step 1. Advisory: no `archon:covers` tag (not blocking).

---

**30. `Cohomology_StructureSheafModuleK.tex`**  
Covers: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (no explicit `archon:covers` tag)

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: ~25 pinned declarations, all `\leanok`. Phase A step 5. Key declarations:
`toModuleKSheaf`, `HModule`, `HModule_zero_linearEquiv`, `instIsHModuleHomFinite_toModuleKSheaf`,
`cechCochain`, `cechCohomology`, `HasCechToHModuleIso`, `HasAffineCechAcyclicCover`.

Carrier classes `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` correctly documented as
having no producers (conditional theorems — honest disclosure). Advisory: no `archon:covers` tag.

---

**31. `Cohomology_MayerVietoris.tex`**  
Covers: `AlgebraicJacobian/Cohomology/MayerVietoris.lean` (no explicit `archon:covers` tag)

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: ~40 pinned declarations, all `\leanok`. Mayer–Vietoris LES for sheaves of k-modules,
two-affine cover bundles, Čech acyclicity carrier, cover-totality bridge H'→H. All correctly
documented. Advisory: no `archon:covers` tag.

---

**32. `AlgebraicJacobian_Cotangent_GrpObj.tex`**  
Covers: `AlgebraicJacobian/Cotangent/GrpObj.lean`

| complete | correct | must-fix |
|---|---|---|
| true | true | no |

Notes: Pointer chapter with no `\lean{...}` declaration blocks. Lists the surviving declarations
by name with their closure history. All 6 named declarations are closed (zero sorry-bodied per
iter-145 refactor). Orphan helpers (`shearMulRight`, `schemeHomRingCompatibility`,
`relativeDifferentialsPresheaf_restrict_along_identity_section`) are iter-146+ cleanup candidates
but are not blocking.

---

## Severity summary

| Severity | Count | Chapters |
|---|---|---|
| HARD GATE BLOCKER (must-fix-this-iter) | 1 | AbelianVarietyRigidity.tex |
| ADVISORY (no gate impact) | 4 | Rigidity.tex (no archon:covers), CodimOneExtension.tex (detached pin), Cohomology_* (4 chapters, no archon:covers), RelPicFunctor.tex (unverified étale name) |
| INFORMATIONAL | 2 | Picard_RelativeSpec.tex (signature refinement pending), RigidityKbar.tex (CharZero hypothesis) |
| PASS (no finding) | 25 | all others |

---

## Overall verdict

**CONDITIONAL PASS** — 31/32 chapters pass the HARD GATE for iter-195. One chapter
(`AbelianVarietyRigidity.tex`) has a must-fix-this-iter finding that blocks the iter-195
BareScheme.lean NEW LANE dispatch. The fix is a targeted blueprint edit (add two
`\begin{lemma}` blocks with `\lean{...}` pins for `projectiveLineBar_smoothOfRelDim` and
`projectiveLineBar_geomIrred`). All other 9 active-prover lanes pass.

**Action required before iter-195 BareScheme.lean prover dispatch:**
Plan agent must add the two missing declaration blocks to `AbelianVarietyRigidity.tex` as
described in the Must-fix section above.

---

## Unstarted-phase blueprint proposals

Phases in `STRATEGY.md` that currently have no dedicated blueprint chapter. These are not
blocking iter-195 (no active prover lanes gated on them this iter) but represent coverage gaps
for future iterations.

---

### Proposal 1: `Picard_TangentSpace_Substrate.tex` — Phase A.3.0

**STRATEGY.md row:** `A.3.0 — Scheme-level tangent space ↔ first-order deformations`  
**Status:** substrate unowned  
**Blocked phases:** A.3.iii (tangent iso H¹(O_C) ≅ T₀ Pic⁰), A.3.iv (Pic⁰ smoothness)

**Proposed chapter content:**
- `def:firstOrderDeformation_schemeHom` — first-order deformation of a scheme morphism as an
  element of `T₀Hom(C, A)` (Hom into `A[ε]/(ε²)`)
- `def:tangentSpaceAtPoint_of_schemeHom` — tangent space at identity of a group scheme via
  Kähler differentials at the identity section
- `lem:cotangentAtIdentity_from_derivations` — bridge between cotangent space at identity and
  module of derivations (`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` in
  `Cotangent/GrpObj.lean`)
- `lem:deformation_theory_H1_identification` — identification T₀Pic⁰_{C/k} ≅ H¹(C, O_C) via
  first-order deformation theory

Note: `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` is already closed in
`Cotangent/GrpObj.lean` (iter-128–132). The substrate chapter should pin the already-closed
declarations and document the deformation-theory bridge that A.3.iii consumes.

---

### Proposal 2: `Picard_DivisorMapAlbanese.tex` — Phase A.4.d

**STRATEGY.md row:** `A.4.d — divisor-map Albanese UP`  
**Status:** "chapter pending (divisor-map pivot)"  
**Blocked phases:** `nonempty_jacobianWitness` positive-genus arm (Route A.4)

**Proposed chapter content:**
- `def:divisorMap_Alb` — the universal morphism from `C` to `Pic⁰_{C/k}` via divisors of degree 0
- `lem:divisorMap_pointsOf_Pic0` — the morphism `C^(g) → Pic^g` factors through the degree-g
  component of Pic
- `thm:albanese_UP_via_divisorMap` — Albanese universal property of `Pic⁰_{C/k}` via the
  divisor-map approach (replaces Sym^g/S_g quotient)
- Document explicit dependency on A.4.d.0 (universal effective divisor)

The iter-192 strategy-critic recommended the Cartier-divisor route (`𝓛 ↦ Div(𝓛)` on `C × Pic^d`)
to avoid gating on A.2.b (Quot + Grassmannian). This chapter should document which route is chosen.

---

### Proposal 3: `Picard_PicdComponent.tex` — Phase A.4.d.0

**STRATEGY.md row:** `A.4.d.0 — Pic^d component + universal effective divisor`  
**Status:** substrate unowned; iter-192 Cartier-divisor route alternative opened  
**Blocked phases:** A.4.d (divisor-map Albanese UP)

**Proposed chapter content:**
- `def:PicdComponent` — the degree-d component `Pic^d_{C/k}` of the Picard scheme
- `lem:picd_translate_iso_pic0` — translation isomorphism `Pic^d_{C/k} ≅ Pic⁰_{C/k}`
  after choosing a degree-d divisor
- (Cartier-divisor route) `def:universalCartierDivisor` — the universal Cartier divisor
  `𝓛 ↦ Div(𝓛)` on `C × Pic^d`, avoiding Hilb-of-points
- (Hilb route alternative) `def:universalEffectiveDivisor` — universal effective divisor
  via `Hilb^d(C) → Pic^d`

Note: This chapter should commit to one of the two routes (Cartier-divisor vs. Hilb) per the
iter-195+ decision point, once Lane I body progress confirms viability. The strategy-critic
recommendation is the Cartier-divisor route.

---

### Proposal 4: `Picard_AbelJacobiSym.tex` — Phase A.4.d.0.AJ

**STRATEGY.md row:** `A.4.d.0.AJ — Abel-Jacobi morphism Hilb^d(C) → Pic^d`  
**Status:** substrate unowned (only needed if Hilb route chosen)  
**Blocked phases:** A.4.d via Hilb route

**Proposed chapter content (only if Hilb route chosen):**
- `def:abelJacobi_Hilb` — the Abel-Jacobi map `Hilb^d(C) → Pic^d` defined by pull-push
  of the universal line bundle along the Hilbert structure morphism
- `lem:abelJacobi_Hilb_surjective` — surjectivity for `d ≥ g`

**Note:** If the iter-195+ route decision commits to Cartier-divisors (avoiding Hilb), this
chapter is unnecessary and the proposal should be dropped.

---

### Proposal 5: `Picard_DegreeMap.tex` — Phase A.3.vii

**STRATEGY.md row:** `A.3.vii — degree map Pic → ℤ`  
**Status:** skeleton landed; body gated  
**Blocked phases:** A.3.ii (Pic⁰ definition — identity component = kernel of degree map)

**Proposed chapter content:**
- `def:degreeMap_Pic` — the degree map `Pic_{C/k} → ℤ` defined by the degree of the
  corresponding line bundle on the geometric fibre
- `lem:degreeMap_Pic_isLocallyCst` — the degree map is locally constant (i.e., a morphism
  of group schemes to the constant group scheme `ℤ`)
- `lem:degreeZero_component_eq_Pic0` — the degree-zero component `ker(degreeMap)` equals `Pic⁰_{C/k}`

Note: The degree map is currently used implicitly in Jacobian.tex and IdentityComponent.tex
but has no dedicated blueprint chapter or `\lean{...}` pin. Adding this chapter unlocks
the identity-component A.3.ii connection.

---

## Return value

`blueprint-reviewer-iter195: CONDITIONAL PASS — 32 chapters audited, 1 must-fix finding
(AbelianVarietyRigidity.tex blocks BareScheme.lean NEW LANE; fix = add 2 lean-pinned declaration
blocks for projectiveLineBar_smoothOfRelDim + projectiveLineBar_geomIrred), 5 unstarted-phase
proposals`
