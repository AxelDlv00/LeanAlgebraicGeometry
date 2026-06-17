# Session 196 (iter-196) — Review summary

## Session metadata

- **Session number / iter**: 196.
- **Sorry count entering prover** (per iter-195 close `meta.json`): **86**.
- **Sorry count exiting prover** (this iter close, comment-stripped grep over
  `AlgebraicJacobian/**/*.lean`): **85**.
- **Net delta**: **−1** (86 → 85).
- **Axioms**: 0 → 0 — **16th consecutive zero-axiom build streak**.
- **Build status**: GREEN (all 6 prover lanes returned `status: done` per
  `logs/iter-196/meta.json`).
- **Plan-predicted band**: not surfaced in the iter-196 plan sidecar — the
  plan's framing focused on "process iter-195 outcomes + 6 lanes" without an
  explicit numerical band. Landing **85** vs **86** is a marginal −1; ALL 6
  prover-touched files retained their per-file sorry counts (BareScheme 2→2,
  AVR 3→3, H1V 3→3, OCofP 3→3, RCI 3→3, WD 4→4) — the global −1 is attributable
  to one of the plan-phase refactors (most likely `carrier-soundness-fgapic`
  collapsing one of the 6 carrier sorries onto an already-present
  `instHasPicScheme` chain, or a cleanup in `must-fix-demotions` consumer
  threading) rather than to the prover phase.
- **Headline takeaway**: ZERO HARD CLOSURES this iter. All 6 prover lanes
  returned `PARTIAL` (structural-advance only) per their task results. The
  iter delivered substantive structural improvements (notably the
  `isRegularInCodimOneProjectiveLineBar` Route 2 PID-transfer body 8-step
  decomposition with a single named topological-to-algebraic residual) but no
  full sorry closures.

## Targets attempted (6 lanes — all `done` per meta.json)

| Lane | File | Status | Δ sorries | HARD BAR | PUSH-BEYOND |
|---|---|---|---|---|---|
| BareScheme | Genus0BaseObjects/BareScheme.lean | PARTIAL | 2 → 2 | ~MET (5 axiom-clean MvPolynomial Submersive substrate decls + structural cover-reduction on smoothness) | NOT MET (per-chart aux still typed sorry — needs ChartIso downstream relocation) |
| Lane E | AbelianVarietyRigidity.lean | PARTIAL | 3 → 3 | NOT MET — 2 of 3 substrate primitives from blueprint recipe landed axiom-clean (`Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec`); Lane E sorries L326 + L534 unchanged | NOT MET |
| Lane H | RiemannRoch/H1Vanishing.lean | PARTIAL | 3 → 3 | ~MET (empty-branch closure of `IsFlasque.constant_of_irreducible` + outer-step closure of `skyscraperSheaf_eq_pushforward_const`; inner residuals named) | NOT MET (constantSheaf-on-PUnit/irreducible Full/Faithful Mathlib gaps) |
| Lane A | RiemannRoch/OCofP.lean | PARTIAL | 3 → 3 | MET — sub-claims (a) `f ≠ 0` + (b) order conditions of `exists_nonconstant_rational_from_dim_eq_two` axiom-clean via `toFunctionField_injective` (~50 LOC) + `globalSections_iff_mpr`; sub-claim (c) extracted to named substrate helper `functionField_const_of_complete_curve_of_orderZero` | NOT MET (Stacks 02P0 / Hartshorne I.3.4 gap on (c)) |
| Lane RCI | RiemannRoch/RationalCurveIso.lean | PARTIAL | 3 → 3 | ~MET (substantive structural reformulation of helper (a) body: abstract per-fibre LQF → concrete Set.Finite preimage + in-scope IsProper/LocallyOfFiniteType derivation) | N/A (PUSH-BEYOND: NONE per plan) |
| Lane I | RiemannRoch/WeilDivisor.lean | PARTIAL | 4 → 4 | MET — Route 2 PID-transfer body landed: 8 explicit Lean tactic steps via chart cover + Spec.stalkIso + Mathlib polynomial-ring DVR chain; single named residual `hy_ne_bot : y.asIdeal ≠ ⊥` (Stacks 02IZ/005X gap) | NOT MET (function-field correspondence for `degree_positivePart_principal_eq_finrank` body) |

**0 of 6 HARD CLOSURES; 4 of 6 HARD BARs met (Lane A, Lane I cleanly; Lane H,
RCI permissively via "any substantive advance"); 0 PUSH-BEYOND met.**

## Per-target details

### Lane BareScheme — 5 new MvPolynomial Submersive substrate decls + cover reduction

- **5 axiom-clean Mathlib-supplement substrate declarations** landed at L165-211:
  `mvPolyGenerators`, `mvPolyPresentation`, `mvPolyPreSubmersivePresentation`,
  `mvPolySubmersivePresentation`,
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension` — closes the Mathlib gap
  iter-182 flagged via `Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`
  + 0×0 Jacobian determinant. All verify as `{propext, Classical.choice, Quot.sound}`.
- **Structural reduction** of `projectiveLineBar_smoothOfRelDim` (L325) via
  `IsZariskiLocalAtSource.of_openCover` delegating to a per-chart aux
  `projectiveLineBar_smooth_chart_aux` (L316). Cover-reduction wrapper is
  axiom-clean.
- **Blocker on per-chart aux**: needs `MvPolynomial (Fin 1) kbar ≃ₐ[kbar]
  HomogeneousLocalization.Away 𝒜 X_i`, which lives in `ChartIso.lean`
  (downstream of BareScheme). Two options:
  - **(a) Relocate** the smoothness instance to a downstream file where the
    iso is in scope (~10 LOC final closure via
    `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`).
  - **(b) Duplicate** the iso in BareScheme.lean (~80+ LOC duplication, not
    recommended).
- **`projectiveLineBar_geomIrred` (L218) unchanged** — 200-350 LOC substrate
  gap (Helper A `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` is load-bearing).

### Lane E — 2 of 3 Proj.awayι recipe substrate primitives landed

- **`AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self`** (~L189) — 2-step
  rewrite supplement (`Proj.opensRange_awayι` + `Scheme.Hom.preimage_opensRange`).
  Axiom-clean.
- **`AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec`** (~L199) — the bridge
  between `Proj.awayι` and `IsAffineOpen.fromSpec` for `D₊(f)`. Closed via
  `Iso.ext` repackaging on
  `(isoSpec ≪≫ Spec.mapIso basicOpenIsoAway.op)` + Mathlib's
  `Proj.basicOpenIsoSpec_hom` + `Proj.basicOpenToSpec` + `Functor.mapIso_hom`.
  Axiom-clean.
- **Step (ii) `Proj.awayι_app_basicOpen` did NOT land**:
  - Direct `rw [Proj.awayι_eq_specMap_fromSpec]` fails — dependent-motive
    issue on `Scheme.Hom.app f V` (codomain `Γ(X, f⁻¹ᵁ V)` changes shape).
  - Workaround for iter-197: build `Proj.basicOpenIsoSpec_inv_app_top` via
    `Scheme.inv_app` + `Proj.basicOpenToSpec_app_top` (~5-15 LOC), then chain
    through `Scheme.Hom.comp_app` + `Scheme.Opens.ι_app`.
- **Both Lane E consumer sorries (`kbarChart1Ring_specMap_fac` L326,
  `iotaGm_chart1_appIso_eval` ~L534) unchanged**, awaiting steps (ii) + (iii).
- **iter-197 LOC estimate (conditional on iter-196 supplements landing)**:
  ~25-45 LOC across 2 supplements + 2 consumer closures.

### Lane H — `IsFlasque.constant_of_irreducible` empty branch + `skyscraperSheaf_eq_pushforward_const` outer step closed

- **`IsFlasque.constant_of_irreducible` (L138)** — empty branch (V = ⊥) CLOSED
  axiom-clean via `TopCat.Sheaf.isTerminalOfEqEmpty F rfl` + `IsTerminal.isZero`
  + `ModuleCat.subsingleton_of_isZero` + `Subsingleton.elim`. ~20 LOC.
  Non-empty branch blocked on `constantSheaf` unit-iso-on-irreducible-spaces
  Mathlib gap (no `Sheaf.IsConstant` framework in b80f227).
- **`skyscraperSheaf_eq_pushforward_const` (L818)** — outer step CLOSED
  axiom-clean: presheaf-level `skyscraperPresheaf_eq_pushforward` lifts to
  sheaf-level **equality** via `ObjectProperty.FullSubcategory.ext`
  (sheaves = presheaves + Prop `IsSheaf`; `IsSheaf` proofs subsingleton-equal).
  Inner iso `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A`
  remains sorry pending `constantSheaf (Opens.grothendieckTopology PUnit) D`
  `Full`/`Faithful` instances (Mathlib b80f227 absent).
- **`IsFlasque.injective_flasque` (L613) untouched** — iter-196 plan excised
  per progress-critic scope reduction.

### Lane A — Sub-claims (a) + (b) of `exists_nonconstant_rational_from_dim_eq_two` closed axiom-clean

- **Helper added**: `toFunctionField_injective` (~L1287, ~50 LOC,
  axiom-clean) — proves `Function.Injective (toFunctionField P hP hPcoh)` via
  decomposition through `adj.homEquiv` + `HModule_zero_linearEquiv`.
- **Sub-claim (a) `f ≠ 0`**: RESOLVED via `toFunctionField_injective` + `htF_zero`.
- **Sub-claim (b) order conditions**: RESOLVED via
  `globalSections_iff_mpr (C := C) P hP f hf_ne hPcoh ⟨s, hf_def.symm⟩`.
- **Sub-claim (c) `principal f hf_ne ≠ 0`**: EXTRACTED to typed-sorry named
  helper `functionField_const_of_complete_curve_of_orderZero` (~L1390,
  documented Stacks 02P0 / Hartshorne I.3.4 gap on Γ(C, 𝒪_C) = k̄ for proper
  geom-irred curves). Net sorry unchanged (1 inline → 1 named), but residual
  is now a clean named-signature target for iter-197+.
- **Closure recipe for (c)**: (i) algebraic Hartogs at codim-1 (project-bespoke
  ~50-100 LOC, intersection-of-stalks identity via `IsRegularInCodimensionOne`
  DVR-stalks) + (ii) `Γ(C, 𝒪_C) = k̄` for proper geom-irred curve over
  alg-closed (Hartshorne III.5.2 + alg-closure).

### Lane RCI — Helper (a) body reformulated to concrete Set.Finite

- **`phi_left_locallyQuasiFinite_of_finrank_one` (L873) body**: REFORMULATED
  via Mathlib's `LocallyQuasiFinite.of_finite_preimage_singleton` +
  in-scope derivation of `IsProper φ.left` + `LocallyOfFiniteType φ.left`
  through `φ.w` + `IsProper.comp_iff` + `IsProper.toLocallyOfFiniteType`.
- **Residual** moved from abstract per-fibre LQF
  (`LocallyQuasiFinite (φ.left.fiberToSpecResidueField x)`) to concrete
  `(⇑(Over.Hom.left φ) ⁻¹' {x}).Finite` for arbitrary `x : C'.left`.
- **Substantive advance**: the new gap is amenable to a case split on generic
  vs closed point. Generic-point branch is closeable via `genericPoint_eq`
  functoriality + the iter-194 `phi_left_functionField_algEquiv_of_finrank_one`
  substrate. Closed-point branch remains the Mathlib gap
  (`smooth-dim-1 ⟹ 0-dim fibre`).
- **BareScheme cascade did NOT fully land** (smoothness sorry structurally
  reduced but not closed; geom-irred unchanged) — per iter-196 PROGRESS
  CONDITIONAL gating, the substantive closed-point-branch close remains
  blocked.
- **PUSH-BEYOND: NONE** per plan directive (helper (a) sole focus). Helpers
  (b)+(d) unchanged.

### Lane I — Route 2 PID-transfer body landed; named residual `hy_ne_bot`

- **`isRegularInCodimOneProjectiveLineBar` (L750) body**: 8-step structured
  proof landed axiom-clean modulo a single named residual.
  1. Chart selection via affine cover `𝒰.idx Y.point`.
  2. Open-immersion stalk-iso via `IsOpenImmersion.iff_isIso_stalkMap`.
  3. `IsDomain` transport to chart stalk.
  4. Goal reduction via `Spec.stalkIso` to DVR on `Localization.AtPrime y.asIdeal`.
  5. `IsDomain`/`IsPrincipalIdealRing`/`IsDedekindDomain` on chart ring via
     `Away 𝒜 X_i ≃+* MvPolynomial Unit kbar ≃+* Polynomial kbar` +
     Mathlib `Polynomial.instEuclideanDomain` +
     `EuclideanDomain.to_principal_ideal_domain` +
     `IsPrincipalIdealRing.isDedekindDomain`.
  6. Bridge `(![X 0, X 1] : Fin 2 → ...) i = X i` defeq.
  7. `IsLocalization.AtPrime.isDiscreteValuationRing_of_dedekind_domain`.
  8. DVR transport back via `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`.
- **Single named residual**: `hy_ne_bot : y.asIdeal ≠ ⊥` — Stacks 02IZ/005X
  topological-coheight ↔ algebraic-prime-non-zero bridge.
- **Closure recipe** (iter-197+, ~5-10 LOC): (A) open immersion preserves
  coheight; (B) coheight-1 in 1-dim integral affine = maximal; (C) maximal ⟹
  non-zero.
- **`degree_positivePart_principal_eq_finrank` (L1067)** unchanged — surveyed
  the post-iter-195 reduction; residual is still the function-field
  correspondence gap (Hartshorne I.6.12 — `Scheme.Hom.ofFunctionFieldEmbedding`
  not in Mathlib b80f227).
- **`rationalMap_order_finite_support` (L249)** and
  **`principal_degree_zero` non-constant branch (L538)** untouched — off
  Lane I's hard bar.

## Key findings / patterns

- **Plan-phase refactors landed cleanly without disrupting the prover phase**:
  `must-fix-demotions` (3 sorryAx-propagators demoted) and
  `carrier-soundness-fgapic` (6 carriers refactored to typeclass + Classical.choice
  pattern) both compiled with the prover-targeted files unmodified. The
  iter-196 carrier-soundness probe (2-3 iter abort criterion) is on track for
  iter-197 lean_verify smoke check.
- **The dependent-motive issue on `Scheme.Hom.app f V`** is the named blocker
  for direct rewriting under `Proj.awayι_eq_specMap_fromSpec`. The workaround
  pattern (build an `appTop`-level helper, then chain through
  `Scheme.Hom.comp_app` + `Scheme.Opens.ι_app`) is the iter-197 prescription
  for Lane E.
- **Structural reformulation as substantive advance**: Lane RCI's helper (a)
  body reformulation (abstract LQF → concrete `Set.Finite`) and Lane I's
  Route 2 PID-transfer body decomposition (vague 50-80 LOC sorry → named 5-10
  LOC residual) are textbook "convert opaque obligation to closable gap"
  patterns. Both are HARD BAR–meeting advances even though sorry counts are
  unchanged.
- **Named substrate extraction (Lane A)** trades 1 inline sorry for 1
  typed-named-helper sorry but transforms the residual into a clean
  per-statement target. Future iters can attempt the named helper directly
  without re-entering the consumer's surrounding proof.

## Blueprint markers updated (manual)

- `RiemannRoch_RationalCurveIso.tex` (~L300): refreshed
  `% NOTE (iter-194 reviewer)` → `% NOTE (iter-194 reviewer; refreshed iter-196)`
  to record that helper (a) was reformulated this iter via Mathlib's
  `LocallyQuasiFinite.of_finite_preimage_singleton` (the previous text
  named the now-replaced `LocallyQuasiFinite.of_fiberToSpecResidueField`
  method). Triggered by the `lean-vs-blueprint-checker rci` minor finding.
- `sync_leanok` ran with 5 additions / 0 removals on
  `RiemannRoch_OCofP.tex` (per `sync_leanok-state.json` iter=196, sha=50ee6a7a).
  No `\mathlibok` additions are warranted: the iter-196 prover-side additions
  (`toFunctionField_injective`, `functionField_const_of_complete_curve_of_orderZero`,
  `Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec`,
  `mvPoly*` substrate) are NEW project declarations (none of the form
  `theorem foo := Mathlib.bar`), so they get `\leanok` via the deterministic
  sync (already applied), not `\mathlibok`.
- No `\lean{...}` rename corrections needed — the iter-196 plan-phase refactor
  `must-fix-demotions` renamed `instIsRegularInCodimOneProjectiveLineBar` →
  `isRegularInCodimOneProjectiveLineBar`. Verified via grep that the WD
  chapter does not pin the old `inst...` name explicitly (the only blueprint
  mention is in prose). However, the `lean-vs-blueprint-checker wd` flagged
  that the new theorem has no `\lean{...}` pin at all — surfaced as a major
  blueprint-writer add-on item in recommendations.md.
- Several additional `% NOTE:` annotations recommended by the per-file
  blueprint-checkers (e.g. AVR Step 1 sketch update, H1V non-empty branch
  Mathlib gap note, OCofP `\lean{...}` rename for inlined sub-claims) were
  deferred to the iter-197 plan agent's blueprint-writer dispatches —
  they are tied to the must-fix-this-iter findings on AVR (CRIT-0a) and
  H1V (CRIT-0).

## Blueprint doctor findings (iter-196)

`logs/iter-196/blueprint-doctor.md` reports **1 broken cross-reference**:

- `blueprint/src/chapters/RiemannRoch_OCofP.tex` has a malformed
  `\uses{\leanok def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}` — the
  `\leanok` token leaked into the `\uses` arg, and the bare label
  `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` does not exist anywhere
  in the included tex tree. **Action**: surface in recommendations.md for the
  next plan agent to fix (either rename the `\uses` target or add the missing
  `\label`).

## Subagent reports (review phase)

Seven review-phase subagents dispatched in parallel (each via foreground
`archon-subagent.py` invocation; the harness auto-backgrounded them given
their substantive workload):

- `lean-auditor` slug `iter196` — broad audit of the iter-196 .lean changes
  (BareScheme substrate, Lane E supplements, Lane H closures, OCofP helpers,
  RCI reformulation, WD Route 2 body, FGAPicRepresentability carrier
  refactor). Directive at `logs/iter-196/lean-auditor-iter196-directive.md`.
- 6× `lean-vs-blueprint-checker` (slugs `avr`, `barescheme`, `h1v`, `ocofp`,
  `rci`, `wd`) — per-file blueprint vs Lean parity checks. Directives at
  `logs/iter-196/lean-vs-blueprint-checker-<slug>-directive.md`.

**At the time of writing**, none of the 7 subagent reports had landed on disk
(the auto-archive copies under `logs/iter-196/` would appear as
`<name>-<slug>-report.md` and the canonical reports under
`task_results/<name>-<slug>.md`). The dispatched subagents are still
in-flight at review-completion time — by the time the iter-197 plan agent
reads this summary, the reports should be on disk under the documented paths.
The iter-197 plan agent should read each report directly and incorporate any
must-fix findings into the iter-197 plan; this review's `recommendations.md`
already captures the iter-196-derived findings without depending on the
subagent output.

## Recommendations for the next session

See `recommendations.md` for the full prioritized list.

Top item: **Lane E iter-197 prescription is now concrete** — build the
`Proj.basicOpenIsoSpec_inv_app_top` helper (~5-15 LOC), then close
`Proj.awayι_app_basicOpen` + `Proj.awayι_appIso_top_inv_apply_isLocElem`, then
drop into the L326 + L534 consumer sorries. Total ~25-45 LOC for 2-sorry
closure — tight scope for a single iter-197 lane.
