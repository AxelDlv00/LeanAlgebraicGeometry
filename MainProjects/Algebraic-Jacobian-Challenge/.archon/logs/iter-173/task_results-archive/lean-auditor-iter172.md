# Lean Audit Report

## Slug
iter172

## Iteration
172

## Scope
- files audited: 17 (every `.lean` under the project tree + the umbrella)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none (umbrella imports only)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 17 imports, all paths resolve to existing files; iter-172 added one line for `AlgebraicJacobian.RiemannRoch.WeilDivisor`. Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The "iteration 073 — Phase E" status block (L14–29) is old but documents a stable design (Albanese-witness projection) and is not contradicted by current code; not stale.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none (iter-166/167 status tags accurately describe the present state)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `iotaGm_isDominant` (L86–89) is `sorry`; well-documented as a private bridge gated on Lane A's concrete `gmScalingP1` body.
  - `genusZero_curve_iso_P1` (L290–296) is `sorry`; documented RR bridge.
  - `morphism_P1_to_grpScheme_const_aux` (L113–229) is body-closed, threading 5 product-instance bridges through Lane A exports + the `iotaGm_isDominant` bridge — no inline scaffolds remain.
  - `rigidity_genus0_curve_to_grpScheme` (L315–351) is body-closed, transports through `genusZero_curve_iso_P1` + `morphism_P1_to_grpScheme_const`. Honest propagation of upstream sorry.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Multiple `set_option backward.isDefEq.respectTransparency false in` (L354, L523, L539, L565) — each labelled with mirror to specific Mathlib L#; the use is intentional and matches Mathlib's own discipline at the mirrored sites. Acceptable.
  - All declarations are closed (no `sorry`).

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations are closed. The Čech-acyclicity carrier classes (`IsCechAcyclicCover`, `HasCechToHModuleIso`, `HasAffineCechAcyclicCover`) are honest `Prop` carriers — they package the substantive iter-051+ comparison work behind producer instances.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - One instance, honestly closed. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations, all honestly closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 27 declarations spread across iter-005..iter-048; all closed. Heavily commented but accurate.
  - `Functor.const_additive` / `Functor.const_linear` / `Adjunction.left_adjoint_linear` / `Adjunction.right_adjoint_linear` / `Adjunction.homLinearEquiv` are honest Mathlib gap-fills with short, tight bodies.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L36–79 header presents "iter-144 chart-algebra pivot route" as the active scope. Per memory `[[route-c-cube-not-needed-iter163]]`, this whole route was demoted off-path at iter-163; the file remains in tree but its declarations are now off-critical-path. Header narrative is **stale** — see Major below.
  - All 5 closed scaffold pieces (α, β-aux, KDM, β-core, lift) are honestly closed; no body-rot.
  - L20–34 module-level "NOTE" blocks document import decisions transparently. OK.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File header (L14–83) opens with "Cotangent space at the identity of a group scheme" and announces "Piece (i.a) of the shared cotangent-vanishing pile". Per memory `[[route-c-cube-not-needed-iter163]]`, the cotangent-vanishing pile route was demoted off-path. Stale narrative — Major below.
  - L297–326 still presents "Piece (i.b)" as work-in-progress. The load-bearing `mulRight_globalises_cotangent` was excised iter-145; this leaves the file's piece (i.b) narrative dangling. Stale narrative — Major below.
  - `cotangentSpaceAtIdentity` (L162–201) is honestly closed via the iter-131 pure-term `Classical.choose`-chain. The "Caveat on canonicity" docstring at L138–153 is candid.
  - `cotangentSpaceAtIdentity_finrank_eq` (L257–295) is honestly closed.
  - `shearMulRight` (L350–384) is honestly closed.
  - `relativeDifferentialsPresheaf_restrict_along_identity_section` (L579–622) is honestly closed.
  - The excise comments at L552 and L624 document why two declarations were removed — these are file-level explanatory notes, not excuse-comments on live declarations. Acceptable.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 5 declarations, all closed. The disclosure of the reverse-direction-of-Jacobian-criterion failure in the `smooth_locally_free_omega` docstring (L119–131) is mathematically honest.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - One `noncomputable def`, one line body. Clean.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none (the long iter-172 status blocks on `gmScalingP1_chart` etc. correctly reflect what landed and what remains)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - PRIMARY 1 of iter-172 (`mvPolyToHomogeneousLocalizationAway_surjective`, L379–519, ~140 LOC) — the proof structure looks sound: `MvPolynomial.induction_on` for the `adjoin = ⊤` step, `Away.adjoin_mk_prod_pow_eq_top` + `Algebra.adjoin_induction` for the surjectivity payload. The `gen_eq_pow` helper (L434–478) is intricate but well-organised — uses `Localization.mk_eq_mk_iff` + `Localization.r_iff_exists` + `Fin.ext + omega` case-split + `pow_add; ring`. No red flags.
  - 9 scaffold `sorry`s remain (L188, L195, L768, L847, L861, L877, L916, L994, L1026); each carries a precise status block + a clear gating description. Honest scaffolding, none excuse-comment in shape.
  - `push Not at h` (L237) is the modern Mathlib generalisation of `push_neg`; valid syntax, not a typo.
  - `gmScalingP1_chart` (L845–847) is a top-level `sorry` (good — no buried sorry); the body-skeleton iter-170 commitment is honoured (≤3 named top-level sorries: chart, agreement, coherence).
  - `pointOfVec` (L603–633) is kernel-clean; the three `k̄`-point witnesses `zeroPt`/`onePt`/`inftyPt` (L637–651) cleanly delegate to it.
  - L237 typo check: confirmed `push Not at h` is intentional (Mathlib's `Mathlib.Tactic.Push` extension).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none — *iter-171 finding is resolved.*
- **notes**:
  - The post-refactor `genusZeroWitness` docstring (L176–197) is professional and informative: it lays out the witness construction, names the route-C consumer (`rigidity_genus0_curve_to_grpScheme`), names the `k → k̄` descent step, and ends with a clean "**Status (iter-172):**" block.
  - The in-proof comment for `key : f = toUnit C ≫ η[A]` (L221–234) describes exactly what the residual `sorry` needs (`Spec k̄ → Spec k` pullback + descent of morphism equality). This is honest gating documentation, not an excuse-comment.
  - The in-proof comment for the uniqueness clause (L237–242) precisely cites the cancellation tools (`Flat.epi_of_flat_of_surjective`, `Over.epi_of_epi_left`). Excellent.
  - `positiveGenusWitness := sorry` (L274) is the M3 off-critical-path arm, well-documented at L250–269.
  - `nonempty_jacobianWitness` (L300–305) is honest dispatch to the two arms.
  - **The L237–263 excuse-comment block called out by iter-171 lean-auditor is gone.** Successful cleanup.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged
- **dead-end proofs**: none (the 6 `sorry`s are honest scaffold declarations)
- **bad practices**: none
- **excuse-comments**: 1 flagged (on `PrimeDivisor.isCodim1AndIntegral`)
- **notes**:
  - File-skeleton landing (iter-172 Lane C). 9 pinned declarations + 1 struct.
  - `Scheme.PrimeDivisor.isCodim1AndIntegral : True := trivial` (L90) is a **weakened-wrong definition**: the field is supposed to be `Order.coheight point = 1 ∧ IsIntegral (closure)` but is currently the unconditional `True`. The docstring (L87–90) and the `## §1` block (L62–77) openly mark this as a "placeholder ... iter-173+ refines this to the genuine [...]" — that *is* an excuse-comment by the lean-auditor rubric. **Verified not load-bearing:** `WeilDivisor`/`PrimeDivisor` are imported only by the umbrella; no project file currently consumes them (confirmed via Grep). The file is a clean Lane C skeleton.
  - The remaining 6 sorry-bodied declarations (`order` L135, `ofClosedPoint` L165, `degree_hom` L198, `principal` L220, `principal_hom` L235, `principal_degree_zero` L259) are open scaffold declarations with clear blueprint references + iter-173+ closure paths in their docstrings. None are excuse-comments; they are honest declared obligations.
  - `degree` (L184–185) is closed (delegates to `Finsupp.sum`).
  - `WeilDivisor` (L98) is well-typed but inherits the `PrimeDivisor` definitional weakness — until the `True` placeholder is replaced with the real conjunction, `WeilDivisor` is structurally `X →₀ ℤ` instead of "free abelian group on codim-1 integral closed subschemes". Captured under must-fix below.
  - `LinearEquivalence` (L278–279) is closed.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` is honestly closed. The "Hypothesis history" block (L43–79) is a useful historical record explaining iter-003 and iter-125 changes; not stale.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: 1 (the headline `rigidity_over_kbar := sorry`)
- **bad practices**: none
- **excuse-comments**: none in declaration-attached comments
- **notes**:
  - The whole file is the **fallback route (a)** artifact per memory `[[route-c-cube-not-needed-iter163]]`. `AbelianVarietyRigidity.lean` L17 correctly describes this as "fallback route (a) artifact". The file's own header (L8–46) however still presents the declaration as "the keystone classical input for the M2.a sub-step" gated on the "shared cotangent-vanishing Mathlib pile (`analogies/cotangent-vanishing-pile.md`, iter-129+)". That whole framing was demoted at iter-163. Stale narrative — Major below.
  - `rigidity_over_kbar := sorry` (L75–88) is the unresolved sorry on the fallback route — acceptable as long as the file is correctly marked as fallback (which the header currently doesn't do).

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The full Rigidity-Lemma chain is closed axiom-clean (iter-162) per memory `[[rigidity-chain-closed-iter162]]`.
  - 11 closed theorems spanning the chain + the two Milne corollaries (`hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`) at L806/L876. All consume only sound infrastructure; the proofs are substantive (Mumford constructions threaded through `IsClosedMap`, `ext_of_isDominant_of_isSeparated'`, `eq_comp_of_isAffine_of_properIntegral`, `isIntegral_of_retract`, etc.).
  - Long docstrings (especially L470–668) document the route and what each piece provides; accurate.

## Must-fix-this-iter

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:90` — `isCodim1AndIntegral : True := trivial` on `Scheme.PrimeDivisor`. **Why must-fix:** this is a weakened-wrong definition per rubric — the field is supposed to capture `Order.coheight point = 1 ∧ IsIntegral (closure)` but currently stands in as the unconditional `True`, which makes `Scheme.WeilDivisor X := PrimeDivisor →₀ ℤ` structurally a free abelian group on *all* points of `X` rather than on prime divisors. The docstring openly admits "iter-173+ will refine this to the genuine [...]" — that is an excuse-comment by the strict rubric. **Mitigation context (per directive instruction to verify load-bearing):** confirmed via Grep — no project file currently consumes `WeilDivisor`/`PrimeDivisor` (only the umbrella imports the chapter). So the wrongness is not poisoning downstream proofs *yet*, but the lean-auditor rubric is explicit that severity not be downgraded on this basis. Two acceptable resolutions: (a) replace `True := trivial` with the real `Order.coheight point = 1 ∧ IsIntegral ...` conjunction the moment iter-173 picks it up (must happen before any other file imports `RiemannRoch.WeilDivisor`); or (b) widen the placeholder to a `sorry` on a `Prop`-valued field so the wrongness surfaces as a kernel obligation rather than hiding silently behind `True`.

## Major

- `AlgebraicJacobian/RigidityKbar.lean:8–46` — header status block presents this as the live M2.a keystone "gated on the shared cotangent-vanishing Mathlib pile (iter-129+)". Per memory `[[route-c-cube-not-needed-iter163]]` the whole cotangent-vanishing-pile / Serre framing was demoted to fallback at iter-163; `AbelianVarietyRigidity.lean:14–17` correctly tags this file as "the fallback route (a) artifact". The file's own narrative still describes itself as the *committed* route, and the `## Status (iter-126 scaffold)` block at L20–29 reads as current. Recommendation: prepend a "Status (iter-163: route-(a) FALLBACK)" block making the demotion explicit, OR delete the file outright if the route is unambiguously off-path. (Same iter-171 finding the directive flagged for re-check — still present.)
- `AlgebraicJacobian/Cotangent/GrpObj.lean:14–83` + `:297–326` — file header presents the cotangent space as "piece (i.a) of the shared cotangent-vanishing pile" and the "Piece (i.b)" section presents Step 2 / main lemma as in-progress for "iter-134+". The route was demoted at iter-163; the load-bearing piece-(i.b) main lemma `mulRight_globalises_cotangent` was excised at iter-145 (the L624 EXCISE comment notes this). The file's own opening narrative does not reflect either the demotion or the excise. Recommendation: refresh the header status block ("Status (iter-163: cotangent-vanishing pile demoted off-path)") and either retitle "Piece (i.b)" to "Helpers retained from the demoted piece (i.b) work" or excise the dangling iter-134+ narrative entirely. (Same iter-171 finding the directive flagged for re-check — still present.)
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36–79` — header presents the file as "scaffolds the five sub-pieces of the iter-144 chart-algebra pivot route for piece (ii) of the M2.body-pile" with all 5 pieces closed. The chart-algebra route was demoted off-path at iter-163. The file's narrative still treats the route as live. Recommendation: prepend an iter-163 demotion notice and either keep the closed pieces as off-path archive (with header tag) or excise the file. (Same iter-171 finding the directive flagged for re-check — still present.)

## Minor

- `AlgebraicJacobian/Genus0BaseObjects.lean:237` — `push Not at h` is valid via Mathlib's generalised `push` tactic, but it is unidiomatic compared with the much more familiar `push_neg at h`. Consider standardising to `push_neg at h` for readability.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:138–161` — the "Caveat on canonicity" docstring is mathematically honest but unusually long for a definition-level docstring. Could be moved to the file-level header or trimmed once a follow-up `cotangentSpaceAtIdentity_isCanonical` lemma lands.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:6` — `import Mathlib` is the all-of-Mathlib import. For an RR scaffold chapter that's defensible, but a per-need set of imports (`Mathlib.AlgebraicGeometry.Scheme.Basic`, `Mathlib.RingTheory.DiscreteValuationRing.Basic`, etc.) would make the file's intended Mathlib surface explicit and speed builds. Defer to iter-173 when the bodies land.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:74` (file-level `## §1` note) + `:87–90` (field docstring) — "placeholder `True` that iter-173+ will refine to the genuine `Order.coheight x = 1 ∧ IsIntegral (X.closedSubschemeOfPoint x)` once those notions are extracted". This is the rubric's archetypal "TODO: replace before merging" pattern; attached to the load-bearing `PrimeDivisor.isCodim1AndIntegral` field that determines the structural correctness of `Scheme.WeilDivisor`. Severity: **critical** (lands as must-fix above, called out here separately per rubric).

## Severity summary

- **must-fix-this-iter**: 1 — blocks downstream RR work in `RiemannRoch/WeilDivisor.lean` until addressed (the moment a sibling file in `RiemannRoch/` starts consuming `PrimeDivisor`/`WeilDivisor`, the `True` placeholder will silently let through codim-≠-1 / non-integral points).
- **major**: 3
- **minor**: 3
- **excuse-comments**: 1 (also counted under must-fix-this-iter above; called out separately because it documents the project lying to itself).

Overall verdict: iter-171's headline finding (the `Jacobian.lean` excuse-comment block) was fully resolved by the refactor agent; iter-172's PRIMARY 1 closure in `Genus0BaseObjects.lean` looks sound; the new `WeilDivisor.lean` scaffold introduces one weakened-wrong definition that must be repaired before any sibling RR chapter consumes it; the four iter-171 stale-narrative blocks remain partially unaddressed (3 of the original 4 still need a header refresh).
