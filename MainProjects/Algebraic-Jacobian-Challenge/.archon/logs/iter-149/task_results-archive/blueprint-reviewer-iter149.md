# Blueprint Review Report

## Slug
iter149

## Iteration
149

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / proof body of `lem:constants_integral_over_base_field`: the iter-148 path (b) SMART PROOF route names four load-bearing sub-claims `(S3.pi.1)` flat-base-change-of-$\Gamma$, `(S3.pi.2)` purely-inseparable assembly, `(S3.sep.1)` Smooth $\Rightarrow$ geom-reduced, `(S3.sep.2)` geom-reduced $\Rightarrow$ separable — but these live as a `%`-prefixed `NOTE iter-148` comment block inside the proof body (L2030–2066), not as first-class blueprint declarations with `\label{}` and `\lean{}` hints. An iter-149+ prover targeting them has no canonical blueprint reference to attach the resulting Lean lemma against; downstream `\uses{}` cross-references are also unavailable.
- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` proof block: the (p2) char-0 typeclass-bridge body is articulated as a single coherent ~80–150 LOC chain (basis projection $\partial_i$ + `ContainConstants` discharge) but does NOT adopt the `(BR.1)`–`(BR.5)` labelling the iter-149 plan-agent directive references. Content is sufficient for an honest prover, but the directive's promised cross-reference granularity is absent.
- `RigidityKbar.tex` / `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` (L2092): the helper has neither `\lean{...}` nor `\leanok`, and is consumed only by the (p1) char-$p$ alternative of KDM. As a non-Lean-targeted scaffolding lemma it is fine, but it leaves the (p1) path with no concrete target should a future iter pivot to it.

### Proofs lacking detail

- None at the level of "the proof exists but isn't enough". The substantive must-fix items above concern blueprint structure (first-class vs. NOTE-comment scaffolding), not under-specified prose.

### Lean difficulty quality

- All currently-active `\lean{...}` hints reference declarations that exist (or, for the iter-149 lane's new targets, will be created by the prover). The five iter-146-flagged broken hints (`cotangentSpaceAtIdentity_iso_localRingCotangent`, `omega_free`, `omega_rank_eq_dim`, `mulRight_globalises_cotangent`, `relativeDifferentialsPresheaf_basechange_along_proj_two`, plus the three `basechange_along_proj_two_*` sister hints) have been deactivated — every remaining mention is inside a `%`-prefixed LaTeX comment (iter-146 disposition lines or historical NOTE blocks). The dependency graph is clean of these. The iter-149 plan-agent's grep concern is therefore satisfied.

### Multi-route coverage

- **Route M3.A (Picard scheme via FGA)**: PASS — covered in `Jacobian.tex` § "Existence of an Albanese variety" with the four sub-step decomposition A.1 (relative Picard functor), A.2 (FGA representability), A.3 (identity component), A.4 (Abel–Jacobi universal morphism). Each sub-step has its Mathlib-status analysis. Sufficient for an iter-170+ Route A prover lane to enter with a concrete starting point (smallest entry: `RelativeSpec` functor at ~700–1100 LOC).
- **Route M3.B (symmetric powers + Stein factorisation)**: PASS (historical only) — documented in `Jacobian.tex` § "Route B — Symmetric powers and Stein factorisation (historical alternative; not pursued)" with the iter-144 disposition note that the project will not gate any deliverable on this route. Adequate for scholarly continuity.
- **Route M2.C (chart-algebra rigidity, iter-144 pivot)**: PARTIAL — covered in `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" via five named declaration blocks ($\alpha$ pushout, $\beta$-core df=0 chart-factorisation, $\beta$-aux constants integral, $\beta$-aux-chart constants-in-chart, $\beta$-core ring-side KDM, scheme-level lift). However, the iter-149 plan's targeted sub-lanes (S3.sep.1, S3.pi.1, S3.pi.2, S3.sep.2 for the constants substep 3, plus the BR.*-labelled (p2) bridge body for KDM) are scaffolded as inline NOTE comments rather than first-class declarations — see the "Incomplete parts" summary. Cleared for *coarse* iter-149 dispatch on `ChartAlgebra.lean`; the writer dispatch noted below would tighten cross-referenceability.
- **Genus-0 witness route (M2.b)**: PASS — `Jacobian.tex` § `def:genusZeroWitness` constructs the witness explicitly with the trivial `\mathbf{1} = \Spec k` underlying scheme and the `isAlbaneseFor` field reduced to `\thm:rigidity_over_kbar`; the body-closure gating onto chart-algebra is recorded correctly.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 40-line phase-A gateway chapter; single theorem `\thm:HasSheafCompose_forget` correctly anchors the limit-preservation chain. Cross-references to downstream chapters are intact.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Sheafification + Ext + structure-sheaf-as-abelian-group trio, all `\leanok` at statement and proof. Phase-A step 4 first half is delivered as advertised.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655-line chapter, 66 `\leanok` markers. Phase-A step 5 fully discharged through the producer instance `inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf`. The deferred Čech-comparison portion of step 6 is honestly labelled as carrier-class-conditional (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`), parallel to the `nonempty_jacobianWitness` foundational hypothesis.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 942-line chapter, 103 `\leanok` markers. Mayer–Vietoris LES, comparison-iso bridge, and two-affine-cover specialisation are all in place. The "Producer status" paragraph (L942) cleanly documents the two carrier classes as currently unproduced — the conditional shape of the downstream genus-0 finiteness theorem is therefore correctly framed.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Forward direction `\thm:smooth_locally_free_omega` closed iter-120 with five named Mathlib closure pieces. iter-126 M1 excise is documented with the surviving standalone Kähler-localization utilities (`kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`). The converse-direction (M4) out-of-scope discussion is honest: counterexample + Mathlib converse-lemma-hypothesis comparison.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 69-line chapter; single definition `\def:genus` honestly anchored on Module.finrank of the project's `HModule` cohomology. The iter-148+ "Genus.lean's $H^{1}(C, \mathcal O_C)$ computation as a running model" citation that an earlier RigidityKbar draft made is correctly disclaimed in the iter-146 erratum inside `RigidityKbar.tex` L1966 (Genus.lean is 45 LOC and only defines the genus; no $H^{1}$ vanishing computation is in tree).

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Build-fix verified.** The iter-149 patch at L243 removes `\uses{def:Jacobian}` from `\thm:nonempty_jacobianWitness`'s statement block. The fix is mathematically correct: `\def:Jacobian` (L109) explicitly lists `thm:nonempty_jacobianWitness` in its own `\uses{...}`, so the existence theorem must precede the definition that selects a particular witness from its conclusion. The previous mis-wiring was a genuine 2-cycle in the depgraph (def:Jacobian ↔ thm:nonempty_jacobianWitness); the cycle-fix comment block L243–250 articulates the reasoning clearly and matches the user-supplied prose at L257–261 (route 0 reduction to a $P$-independent witness).
  - M3 Route A four-sub-step decomposition (A.1–A.4) is comprehensive: each sub-step names a Mathlib-prerequisite tier and a smallest entry point (`RelativeSpec` functor for A.1; FGA representability for A.2; identity-component + degree-map for A.3; Albanese functoriality for A.4). An iter-170+ Route A prover lane has a concrete starting point.
  - Route B is correctly framed as historical-only per iter-144 disposition; the LOC midpoint figure (~9000 LOC) is cited from the iter-123 audit.
  - Genus-0 sub-case (C.1–C.3) and the iter-127 over-k commitment (C.2.f DROPPED) are coherently articulated.
  - `def:genusZeroWitness` and `def:positiveGenusWitness` are first-class declarations with their `sorry`-body closure paths documented (iter-151+ via chart-algebra; iter-170+ via Route A).

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 71-line chapter; the scheme-level `\thm:GrpObj_eq_of_eqOnOpen` (`AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`) is documented with its three load-bearing instance derivations and the iter-125 refactor history (8 hypotheses dropped, IsProper → IsSeparated). Mathlib infrastructure list is verified.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **Stripped \lean{...} hints verified.** All five iter-146-flagged broken hints (`cotangentSpaceAtIdentity_iso_localRingCotangent`, `omega_free`, `omega_rank_eq_dim`, `mulRight_globalises_cotangent`, `relativeDifferentialsPresheaf_basechange_along_proj_two`, plus the four `basechange_along_proj_two_*` sister hints) appear only inside `%`-prefixed comment blocks. The iter-146 report's claim was correct; the iter-149 plan-agent's grep concern is satisfied — comment-only mentions are exactly what's expected after the iter-145 chart-algebra pivot. No active `\lean{...}` hint in this chapter points at a non-existent declaration.
  - **Chart-algebra piece (ii) first-class decomposition (§L1828–2216).** All five envelope sub-pieces have first-class blueprint declarations with `\lean{...}` hints: `lem:chart_algebra_isPushout_of_affine_product` (α; closed via inferInstance iter-146), `lem:chart_algebra_df_zero_factors_through_constant_on_chart` (β-core; iter-147 thin-wrapper closure to KDM; substantive five-step recipe carried in prose for iter-149+), `lem:constants_integral_over_base_field` (β-aux constants; \leanok with residual sorry, dual path (a) BUILD-IT/(b) SMART-PROOF documented), `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (β-core ring-side KDM; (p1)+(p2) decomposition), `lem:Scheme_Over_ext_of_diff_zero` (scheme-level lift; iter-146 thin renaming over `ext_of_eqOnOpen`).
  - **(S3.*) sub-claim scaffolding gap (must-fix-iter-149).** Path (b) SMART-PROOF for constants is decomposed into four sub-claims `(S3.pi.1)` `(S3.pi.2)` `(S3.sep.1)` `(S3.sep.2)` (L2044–2059) but they live as a `%`-prefixed `NOTE iter-148` comment block inside the proof body of `lem:constants_integral_over_base_field`, NOT as first-class lemma blocks with their own `\label{}`, `\lean{}`, and `\uses{}` fields. An iter-149+ prover targeting these as a multi-lane build (per the directive: S3.sep.1 bridge ~120–180 LOC; S3.pi bridge ~150–250 LOC) has no blueprint citation to attach each landed Lean lemma against, and downstream `\uses{lem:...}` cross-references cannot reach them. Promotion to first-class declarations is the recommended must-fix.
  - **(BR.1)–(BR.5) labelling absent for KDM (p2).** The iter-149 directive references "(BR.1)–(BR.5) bridge body" for the KDM char-0 path's `[CharZero k] + [Algebra.IsStandardSmoothOfRelativeDimension k B]`-inflated build. The chapter's (p2) prose (L2133) decomposes the bridge as a single coherent chain: standard-smooth free basis → basis-coefficient projection $\partial_i$ → `Differential.ContainConstants` typeclass closure. The decomposition is mathematically adequate (~80–150 LOC) but does not adopt the BR.* labelling the directive expects; an iter-149 prover working from the directive will need to reconcile the prose-vs-label mismatch by hand. Soon-severity (labelling, not content).
  - **Unleaned helper.** `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` (L2092) has no `\lean{...}` and is consumed only by the (p1) char-$p$ alternative path. Acceptable as a documentation-only blueprint citizen so long as (p1) is not on the iter-149 critical path. Informational.
  - **Iter-144 chart-algebra pivot disposition.** The DESCOPED Route (b'2) bundled-route declarations (`lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`, etc.) are kept as `\notready` blueprint citizens with detailed prover-ready recipes in their (long) NOTE blocks. This is per the iter-145 EXCISE disposition at L489–490. The auditable record is preserved correctly; no action needed.
  - **Other.** The strategy-critic Q3 honesty note (L1833) and its prose echo inside `lem:chart_algebra_df_zero_factors_through_constant_on_chart` (L1921, L1966) correctly articulate that the chart-Čech invocation of $H^0(C, \Omega_{C/k}^{\oplus g}) = 0$ is honest and uses the project's own MV infrastructure (`thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`) rather than naming Serre duality.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 87-line pointer chapter; no protected declarations introduced (by design). The post-iter-145 disposition is correctly recorded: piece (i.a) trio (`cotangentSpaceAtIdentity`, `_eq_extendScalars`, `_finrank_eq`) closed, the surviving iter-134–iter-136 orphan helpers (`shearMulRight` + companions, `schemeHomRingCompatibility`, `relativeDifferentialsPresheaf_restrict_along_identity_section`) catalogued. Iter-146+ cleanup candidates are flagged.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 89-line chapter; the Albanese-projection trio (`\def:ofCurve`, `\lem:comp_ofCurve`, `\thm:exists_unique_ofCurve_comp`) is each a one-line projection from the Albanese predicate of `\def:IsAlbanese` and is `\leanok` on both statement and proof. The classical Pic-scheme line-bundle descriptions are recorded as remarks, correctly marked as not-replayed-in-Lean. The iter-127 over-k commitment + DROPPED Galois descent are reflected consistently with the upstream Jacobian.tex framing.

## Cross-chapter notes

- The iter-127 over-k commitment is consistently invoked across `Jacobian.tex` (§C.2.f DROPPED), `AbelJacobi.tex` (§"Universal (Albanese) property" classical-description block), and `RigidityKbar.tex` (chapter introduction + §"Use in the project"). The chapter prose framings agree on: `\thm:rigidity_over_kbar` is established directly over $k$; no Galois descent of morphism equality enters M2 critical path; the Lean variable name `kbar` is a legacy from iter-126 framing with a low-priority cleanup-rename scheduled.
- `\thm:GrpObj_eq_of_eqOnOpen` (in `Rigidity.tex`) is correctly cross-referenced from `Jacobian.tex` (sub-step C.2.b), `RigidityKbar.tex` (sub-step C.2.b + §"Proof decomposition"), `AbelJacobi.tex` (uniqueness half), and `RigidityKbar.tex` `lem:Scheme_Over_ext_of_diff_zero` (the iter-146 thin-renaming consumer). All cross-references resolve to the live target name `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` (post-iter-125 refactor).
- `def:JacobianWitness` is consistently consumed by `def:Jacobian` (its `\uses{}` lists it correctly post-iter-149 patch), the four protected projection theorems (`Jacobian.tex` §"Group scheme structure and abelian-variety properties"), and the witness-existence theorem `\thm:nonempty_jacobianWitness` (which produces a non-empty witness uniformly in $P$). Quantifier-order reversal (iter-rectified) is articulated in `\rem:JacobianWitness_quantifier_order` and is mathematically sound.
- The chart-algebra ($\alpha$) `lem:chart_algebra_isPushout_of_affine_product` is cross-referenced by both `lem:chart_algebra_df_zero_factors_through_constant_on_chart` (β-core consumer, via Step 3 chart-Čech) and `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (KDM consumer, via standard-smooth chart presentation in (p1.b)). The shared use is documented; the dependency graph is sound.

## Strategy-modifying findings (if any)

None this iter. The iter-148 commitment to path (b) SMART PROOF for constants_integral and the iter-144 chart-algebra pivot are both already reflected in `STRATEGY.md` per the chapter prose; the iter-149 plan agent's directive does not reveal any new strategy conflict.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` is `complete: partial`. Per the dispatcher_notes rule, any `partial | false` chapter triggers must-fix. The concrete remediation is **promote the four (S3.\*) sub-claims to first-class blueprint declarations** with `\label{}` and `\lean{}` hints — currently they live as a NOTE comment inside the proof body of `lem:constants_integral_over_base_field` (L2030–2066). The iter-149 plan agent's working-hypothesis prover lane (S3.sep.1 + S3.pi + KDM (p2), ~370–610 aggregate LOC) targets them directly; without first-class status, downstream `\uses{}` and the dependency graph cannot reach them and the prover has no canonical citation to attach landed Lean lemmas against.
- **soon**:
  - `RigidityKbar.tex` — adopt the `(BR.1)`–`(BR.5)` labelling for the KDM (p2) char-0 bridge body that the iter-149 directive expects, OR update the directive's framing to match the chapter's existing single-chain decomposition. Either fix unblocks cross-referenceability; the underlying content is adequate.
  - `RigidityKbar.tex` — `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` (L2092) is the one chart-algebra block without a `\lean{...}` hint. Either land a thin Lean target (~80–150 LOC per the lemma's prose) or downgrade to a `\begin{remark}` since it's only consumed by the (p1) alternative path; the (p2) primary path is independent of it.
- **informational**:
  - `Cohomology_MayerVietoris.tex` `def:Abelian_Ext_chgUnivLinearEquiv` (L627) has no `\leanok` on either statement or proof. If the underlying Lean declaration exists (`CategoryTheory.Abelian.Ext.chgUnivLinearEquiv`), the sync_leanok phase should pick this up next iter; if not, the universe-bump bridge is currently scaffolding-only. Low priority.
  - `RigidityKbar.tex` `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (L1725) is the lone surviving live `\lean{...}` hint among the iter-134–iter-136 orphan helpers. The chapter at L77–84 of `AlgebraicJacobian_Cotangent_GrpObj.tex` flags it as an iter-146+ cleanup candidate. Optional follow-up.

## HARD GATE per-file decision

The iter-149 plan agent's working hypothesis lists `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` as the candidate file for the iter-149 prover dispatch (~370–610 aggregate LOC across the S3.sep.1, S3.pi, KDM (p2) lanes). The blueprint chapter corresponding to this Lean file is `RigidityKbar.tex` (Chart-algebra piece (ii) first-class decomposition section).

`RigidityKbar.tex` is classified above as `complete: partial, correct: true` — the `partial` rating is driven specifically by the (S3.*) sub-claim scaffolding gap, which directly affects the proposed iter-149 prover lane.

Per the descriptor's HARD GATE rule, applied verbatim: **DROP `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` from this iter's objectives. Dispatch the blueprint-writing subagent for `RigidityKbar.tex` THIS iter with a directive promoting the four `(S3.pi.1)`, `(S3.pi.2)`, `(S3.sep.1)`, `(S3.sep.2)` sub-claims from the NOTE comment block at L2030–2066 to first-class blueprint declarations, each carrying its own `\label{lem:S3_*}`, `\lean{AlgebraicGeometry.constants_*}` hint, and `\uses{...}` field.** Re-dispatching this reviewer after the writer returns is optional within the same iter; iter-150's mandatory reviewer pass will green-light ChartAlgebra.lean for prover dispatch then.

Rationale: the iter-149 prover-lane budget (~370–610 aggregate LOC) is materially larger than the iter-146/iter-147/iter-148 envelope, and is broken into multiple independent sub-lanes (S3.sep.1, S3.pi.1 flat-base-change, S3.pi.2 purely-inseparable assembly, S3.sep.2 geom-reduced-to-separable). Each sub-lane's eventual Lean declaration needs to attach to a canonical blueprint label for downstream traceability; without first-class blueprint status, the prover may either (a) land Lean lemmas with ad-hoc names that future iters re-classify, or (b) inline-prove inside `constants_integral_over_base_field`'s body, losing the sub-lane independence the iter-149 plan agent designed for. The one-iter latency cost of a writer dispatch is small compared to either failure mode.

Overall verdict: 11 chapters audited, 10 chapters at `complete: true / correct: true`, 1 chapter (`RigidityKbar.tex`) at `complete: partial / correct: true` driven by an iter-149-specific must-fix on the (S3.*) chart-algebra sub-claim scaffolding — defer `ChartAlgebra.lean` prover dispatch one iter for a targeted blueprint-writer round.
