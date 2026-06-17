# Session 194 (iter-194) — Review summary

## Session metadata

- **Session number / iter**: 194.
- **Sorry count entering prover** (per iter-194 plan-phase footer): **89**
  (= 87 post-iter-193 + 2 typed-sorry typeclass instances on
  `ProjectiveLineBar` from the plan-phase `lane-i-localparameter-signature-v2`
  refactor).
- **Sorry count exiting prover** (this iter close):
  **88** (counted from `lake build AlgebraicJacobian` `declaration uses
  'sorry'` warnings — verified `wc -l = 88`).
- **Net delta**: **−1** (89 → 88).
- **Axioms**: 0 → 0 — **14th consecutive zero-axiom build streak**.
- **Build status**: GREEN (8361/8361 jobs replayed).
- **Plan-predicted band**: best 89 → ~80–83 (−6 to −9); realistic
  89 → ~83–87 (−2 to −6); worst 89 → ~86–89 (−0 to −3). Landing **88**
  sits at the **worst-case upper boundary − 1** — driven by 1 file-level
  closure (Lane G AuslanderBuchsbaum −1) + 7 file-flat outcomes with
  substantive structural advance, and 2 HARD-BAR-not-met lanes (E, F).

## Targets attempted (10 lanes)

| Lane | File | Status | Δ sorries | HARD BAR | PUSH-BEYOND |
|---|---|---|---|---|---|
| I | WeilDivisor.lean | PARTIAL | 5 → 4 (−1) | **MET** | Not met |
| H | H1Vanishing.lean | PARTIAL | 4 → 4 | **MET** | Not met |
| M↓ | Albanese/CodimOneExtension.lean | PARTIAL | 3 → 3 | **MET** (precise gap surface route) | Not met |
| E | AbelianVarietyRigidity.lean | PARTIAL | 3 → 3 | NOT MET | Not met |
| F | Picard/QuotScheme.lean | PARTIAL | 12 → 12 | NOT MET (structural advance) | Not met |
| B | Genus0BaseObjects/GmScaling.lean | PARTIAL | 2 → 2 | **MET** (9 axiom-clean helpers) | Not met |
| A.3.i | Picard/IdentityComponent.lean | PARTIAL | 9 → 9 | **MET** (instance demotion) | Partial body restructure |
| RCI | RationalCurveIso.lean | PARTIAL | 3 → 3 | **MET** (2 axiom-clean substrate helpers) | Not met |
| G | Albanese/AuslanderBuchsbaum.lean | **SOLVED** (n=0 branch) | 2 → 1 (−1) | **MET (closure)** | n=k+1 untouched (multi-iter substrate) |
| A | RiemannRoch/OCofP.lean | PARTIAL | 3 → 3 | **MET** (2 consumer bodies restructured + closed) | Partial |

8 of 10 HARD BARs met (E + F not met but with structural advance).
1 push-beyond closure (Lane G n=0 branch).

## Per-target details

### Lane I — `WeilDivisor.lean` (5 → 4)

- **`instIsLocallyNoetherianProjectiveLineBar` (L703) — CLOSED axiom-clean.**
  Direct Mathlib composition: `IsProper → LocallyOfFiniteType` (via
  `IsProper.toLocallyOfFiniteType`) + base `Spec (.of kbar)` is
  `IsLocallyNoetherian` (Field ⟹ PID ⟹ Noetherian) +
  `LocallyOfFiniteType.isLocallyNoetherian`. 4 LOC. Kernel-only axioms.
- **`instIsRegularInCodimOneProjectiveLineBar` (L719) — unchanged.**
  Tried direct stalk-level DVR via `HomogeneousLocalization.AtPrime` on
  height-1 homogeneous prime of `k̄[X₀,X₁]`. NOT ATTEMPTED — the
  formal chain "homogeneous localization at height-1 homogeneous prime
  of `k̄[X₀,X₁]` = DVR" is a Mathlib gap; alternative routing through
  `SmoothOfRelativeDimension 1` is blocked by another project-side
  `sorry` (BareScheme.lean:154–156 scaffold).
- **`degree_positivePart_principal_eq_finrank` (L763) — partial.**
  Body restructured to destructure `hLPUnif` exposing the uniformiser
  witness `Y₀`; remainder (affine-chart bridge to
  `Ideal.sum_ramification_inertia`) blocked by absence of
  `Scheme.Hom.ofFunctionFieldEmbedding` constructor / affine-chart
  bridge in Mathlib `b80f227` (Hartshorne I.6.12).
- **`rationalMap_order_finite_support` non-zero branch (L227) +
  `principal_degree_zero` non-constant branch (L503) — unchanged.**
  Hartshorne II.6.1 / Stacks 02RV / Hartshorne II.6.10 substrate; gated
  on Mathlib substrate not yet present.

### Lane H — `RiemannRoch/H1Vanishing.lean` (4 → 4; structural advance)

- **NEW axiom-clean helpers (3, all kernel-only)**:
  1. `sheafCompose_additive` instance — generic-purpose: additive `F` +
     `J.HasSheafCompose F` ⟹ `(sheafCompose J F).Additive`.
  2. `sheafCompose_preservesZero` instance — derived from `Additive` via
     `Functor.preservesZeroMorphisms_of_additive`.
  3. `Scheme.IsFlasque.toAddCommGrpCat` — bridge from project's
     `Scheme.IsFlasque` (on `ModuleCat kbar`-valued sheaves) to Mathlib's
     `TopCat.Sheaf.IsFlasque` (on `AddCommGrpCat`-valued sheaves) via
     `forget₂`.
- **`shortExact_app_surjective` (L405) — structurally narrowed.** The
  body now routes through the `forget₂` bridge: lift SES of `Sheaf J
  (ModuleCat kbar)` to SES of `Sheaf J AddCommGrpCat` via `sheafCompose
  (forget₂ ModuleCat AddCommGrpCat)`; apply Mathlib's
  `TopCat.Sheaf.IsFlasque.epi_of_shortExact`. **`Mono SAb.f` + `Epi
  SAb.g` are now proven axiom-clean inline.** Only `SAb.Exact` remains
  as a focused, narrowly-scoped sorry — the gap is the typeclass
  `(sheafCompose (forget₂ ModuleCat AddCommGrpCat)).PreservesHomology`
  (or just `PreservesRightHomologyOf S`).
- **`injective_flasque` (L537) — unchanged.** Mathlib-gap-blocked: no
  `j_!` (extension-by-zero) infrastructure for module-valued sheaves;
  Godement resolution also missing. Escalation candidate for the
  iter-200 mathlib-analogist sweep (`cross-domain-inspiration` mode).

### Lane M↓ — `Albanese/CodimOneExtension.lean` (3 → 3; precise gap surface)

Per iter-194 plan-phase Lane M↓ STUCK protocol re-scope ("DO NOT add
more helper layers around Stages 5–6; INCOMPLETE if Stacks 00OE/02JK
not immediately buildable"), the prover did NOT add helpers. Instead:

- **`isRegularLocalRing_stalk_of_smooth` (L434).** Gap docstring (L480–514)
  updated; the Stage 6 gap is structured into two named sub-gaps:
  - Sub-gap (i): relative-dimension `n` determination from
    `IsStandardSmooth` (needs
    `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` +
    dimension formula).
  - Sub-gap (ii): smooth-algebra Krull-dimension formula (Stacks 00OE) —
    empirical Mathlib search at `b80f227` finds no declaration relating
    `IsStandardSmooth(OfRelativeDimension)` to `ringKrullDim`.
- **`extend_of_codimOneFree_of_smooth` (L684).** Bare `sorry` → `by`
  block with 1 axiom-clean inline derivation `Y.left.IsSeparated`
  (via `Scheme.isSeparated_iff` + `IsSeparated.of_comp`). Body has a
  precise inline gap statement (Stacks 0AVF depth-≥2 H¹ vanishing) +
  concrete roadmap `X.topIso.inv ≫ (X.isoOfEq h).inv ≫
  f.toPartialMap.hom`. Attempt 2 (full structural refactor exposing
  `f.toPartialMap.domain = ⊤` as a single typed sorry) REGRESSED
  count 1 → 3; backed off.
- **`indeterminacy_pure_codim_one_into_grpScheme` (L752).** Bare `sorry` →
  `by` block with 4-substep precise gap surface (difference map
  construction, definedness equivalence, function-field pullback,
  codim-1 pole-divisor intersection with the diagonal). 2 substantive
  Mathlib gaps named: (a) function-field-pullback bridge for
  `Scheme.RationalMap`; (b) scheme-level codim-1 pole-divisor/diagonal
  intersection lemma (Hartshorne AG 9.2 scheme-level).

### Lane E — `AbelianVarietyRigidity.lean` (3 → 3; structural narrowing)

- **`kbarChart1Ring_specMap_fac` (L222) — narrowed.** Reroute through
  `iotaGm_r_1_fac` (the iter-193 `IsOpenImmersion.lift_fac` named
  lemma), reducing the morphism-level claim to a ring-map identity on
  `appTop`: `Scheme.Hom.appTop (Spec.map (CommRingCat.ofHom
  (kbarChart1Ring kbar))) = Scheme.Hom.appTop (iotaGm_r_1 kbar)`. Both
  sides are `Γ(Spec(Away 𝒜 X_1), ⊤) →+* Γ(Spec k̄, ⊤)`. Tactics: `rw [←
  iotaGm_r_1_fac kbar]; congr 1; refine ext_of_isAffine ?_`. Inner
  sorry retained — the same opaque `Proj.appIso ⊤ .inv` evaluation on
  `isLocElem` that has been STUCK iter-188 → iter-193 (and now
  iter-194 too, despite the iter-193 pivot). Dead-end documented:
  cannot bootstrap via `IsOpenImmersion.lift_uniq` of `awayι X_1` (it
  asks for the same `_ ≫ awayι = onePt.left` equation).
- **`iotaGm_chart1_appIso_eval` (L471) — unchanged.** Body retained
  iter-192/193 framework (chart-1 ring-map iso chain). Structural
  commentary updated to flag that this residual shares substantive
  content with the narrowed inner sorry of
  `kbarChart1Ring_specMap_fac` (both reduce to chart-`1` `appTop`
  ring-map identity).
- **`genusZero_curve_iso_P1` (L837) — untouched.** Off-target this iter.
- **HARD BAR NOT MET** — pivot brought structural narrowing but the
  underlying `Proj.appIso ⊤ .inv` evaluation residual remains.

### Lane F — `Picard/QuotScheme.lean` (12 → 12; structural advance)

- **LinearEquiv extraction in
  `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (L815) — landed
  axiom-clean** (Steps a–c of the iter-189 5-step plan). Recipe:
  `set TR := ModuleCat.of Γ(Y,U) (T)` to silence `Γ(·,·)` notation
  ambiguity inside tilde type ascription; restate `Module.compHom`-
  via-`ΓSpecIso.inv.hom` instance for source of `topAdd`; build
  `topLin` from `topAdd.toLinearEquiv` with smul-compat via
  `Scheme.Modules.Hom.app_smul`; chain `toTensor := topLin.trans
  (tilde.isoTop TR).symm.toLinearEquiv`; assemble `f :=
  toTensor.symm.trans step3`.
- **Beck-Chevalley intertwining at `1 ⊗ₜ x` (L957) — sorry retained.**
  ARCHITECTURAL FINDING: provably depends on the bodies of `step1`
  (Stacks 01I8) and `step2` (Stacks 01HQ); both currently
  `Nonempty (... ≅ ...)` typed-sorry pins. Their isos are opaque
  (`Classical.choice`-extracted), so the LHS chain cannot be reduced
  to a closed form. Unblocking requires either (a) `step1`+`step2`
  bodies land OR (b) `step1`+`step2` signatures refactor to Σ-pair
  carrying canonical iso-characterizing identities (~10–15 LOC each).
- **HARD BAR NOT MET** — no full closure of any typed sorry; structural
  decomposition is the substantive deliverable.

### Lane B — `Genus0BaseObjects/GmScaling.lean` (2 → 2)

- **`gmScalingP1_chart_agreement_cross01` (L463) — HARD BAR MET via 9
  axiom-clean structural helpers landing the closed-points reduction.**
  Helpers (all kernel-only): `hLOFT_f0`, `hLOFT_f1`, `hLOFT_fst`,
  `hLOFT_PG`, `hLOFT_inter` (LOFT chain via
  `LocallyOfFiniteType.jacobsonSpace`); `hJac_Spec_kbar` (field →
  artinian → jacobson) + `hJac_inter` (transferred);
  `hΔ_range_closed` (via `IsClosedImmersion.isClosedEmbedding`);
  `hClosed_dense` (via `JacobsonSpace.closure_closedPoints`). The
  cocycle proof reduces to a per-closed-point chart-evaluation sorry
  `hCP_check`. Residual is now a focused per-point chart-map evaluation
  rather than a global topological statement.
- **`gmScalingP1_collapse_at_zero` (L944) — untouched.** Same
  chart-1 ring-map evaluation idiom dependency.

### Lane A.3.i — `Picard/IdentityComponent.lean` (9 → 9)

- **`identityComponent_geometricallyConnected` (L500→L567) — instance
  DEMOTED axiom-clean** per iter-193 lean-auditor must-fix. Keyword
  swap `instance` → `theorem`. Soundness exposure removed: typeclass
  search resolving `GeometricallyConnected (IdentityComponent G).hom`
  can no longer silently propagate `sorryAx`. Consumer-audit
  confirmed zero `instance`-firing consumers in the file; no `letI`
  rewrites required.
- **`geometricallyConnected_of_connected_of_section` (L414) — body
  restructured.** Used
  `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms` to
  reduce to `∀ K [Field K] [Algebra k K], ConnectedSpace (pullback f
  (Spec.map (algebraMap k K)))`. Constructed the base-changed section
  `_sK : Spec K ⟶ pullback f g` via `pullback.lift (g ≫ s) (𝟙 _) ...`
  axiom-clean (the `_hsf` section hypothesis is now structurally used).
  Derived `Nonempty ↑↑(pullback f g)` axiom-clean. Residual is exactly
  Stacks 04KV reduction to finite separable extensions +
  field-tensor-product criterion (alg-closed-in + separable ⟹ field) —
  both Mathlib gaps. The iter-200 mathlib-analogist sweep is the right
  venue.

### Lane RCI — `RationalCurveIso.lean` (3 → 3)

- **2 NEW axiom-clean substrate helpers:**
  1. `algebraMap_bijective_of_finrank_one` (L737) — Bijective via
     `Subalgebra.bot_eq_top_of_finrank_eq_one` +
     `Algebra.bijective_algebraMap_iff`. 2 LOC, generic in `K`/`L`.
  2. `phi_left_functionField_algEquiv_of_finrank_one` (L756) — 1-line
     `RingEquiv.ofBijective` consumer.
- **Helper (a) `phi_left_locallyQuasiFinite_of_finrank_one` (L850) —
  body advanced.** Reduction via
  `LocallyQuasiFinite.of_fiberToSpecResidueField` lifted the goal to a
  per-fibre LQF statement; per-fibre case ("smooth-dim-1 ⟹ fibre 0-dim
  scheme") remains as the explicit Mathlib gap surface.
- **Inline Step 1 of `iso_of_degree_one` refactored** (L912) — 16 LOC
  → 4 LOC consuming `phi_left_functionField_algEquiv_of_finrank_one`.
- **Helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`
  (L798) — untouched.** Mathlib `IsNormalScheme` gap.
- **`?hLPUnif` (L521) — untouched.** Construction of
  `(ProjectiveLineBar kbar).left.PrimeDivisor` at ∞ ∈ ℙ¹ is itself a
  project-side gap.

### Lane G — `Albanese/AuslanderBuchsbaum.lean` (2 → 1; CLOSURE)

- **`auslander_buchsbaum_formula` n=0 branch (L953) — CLOSED axiom-clean
  via the new public lemma `Module.depth_pi_const_eq_depth_of_nonempty`**
  (≈25 LOC main + 4 helpers, all `private` except the main lemma):
  1. `ideal_smul_top_pi_const` — `I • ⊤_{ι → M} = pi univ (fun _ => I •
     ⊤_M)` via `Submodule.smul_induction_on` (≤) +
     `Finset.univ_sum_single` (≥).
  2. `ideal_smul_top_pi_const_eq_top_iff` — side condition iff via
     `Pi.single j m` lift+project.
  3. `quotSMulTopPiConstLinearEquiv` — `QuotSMulTop r (ι → M) ≃ₗ ι →
     QuotSMulTop r M` via `Submodule.quotEquivOfEq` +
     `Submodule.quotientPi` +
     `Submodule.ideal_span_singleton_smul` bridging.
  4. `isRegular_pi_const_iff_of_nonempty` — sequence-level iff by
     induction on `rs` (generalising `M`); cons-case via
     `Pi.isSMulRegular_iff` + `LinearEquiv.isRegular_congr`.
  5. `depth_pi_const_eq_depth_of_nonempty` (public, axiom-clean):
     assembles the supremum-set equality from #4 + side-condition iff
     from #2.
  Closure site (L953): `haveI : Nonempty (Fin k) := ⟨⟨0, hk⟩⟩; exact
  Module.depth_pi_const_eq_depth_of_nonempty _`. **n=k+1 branch
  (L1125) untouched** — multi-iter substrate (Stacks 090V minimal
  finite free resolutions + 00MF + snake-lemma + depth-drops-by-one).
- 8 non-fatal linter warnings on unused `[Fintype]` / `[DecidableEq]`
  hypotheses (intended for `LinearMap.single` / `Finset.univ_sum_single`
  internal use); style, not errors.

### Lane A — `RiemannRoch/OCofP.lean` (3 → 3; structural advance)

- **`dim_eq_two_of_genusZero` (L1237) — body closed structurally** via
  new substrate helper `h0_sub_h1_lineBundleAtClosedPoint_eq_two`
  (Int-valued `(H⁰ : ℤ) − (H¹ : ℤ) = 2`; inlined to avoid `OCofP ←
  OcOfD ← RRFormula` import cycle). Body: 3-step arithmetic (invoke
  `h1_vanishing_genusZero`; substitute `H¹ = 0`; `exact_mod_cast` to
  read off `H⁰ = 2`).
- **`exists_nonconstant_genusZero` (L1361) — body closed structurally**
  via new substrate helper `exists_nonconstant_rational_from_dim_eq_two`
  (consumes a dim hypothesis, independent of `genus C = 0`). Partial
  setup: the distinguished constant section `s₁` is produced
  concretely via `globalSections_iff_mp` at `f = 1` +
  `Scheme.RationalMap.order_one`.
- Three typed-sorry leaves now: `h1_vanishing_genusZero` (cohomology
  LES, depends on Lane H substrate), `h0_sub_h1_lineBundleAtClosedPoint_eq_two`
  (χ-bridge, depends on `OcOfD.lean` STRUCTURALLY BLOCKED gate),
  `exists_nonconstant_rational_from_dim_eq_two` (linear-algebra +
  Stacks 02P0).

## Key findings / patterns discovered

1. **forget₂-bridge from `Sheaf J (ModuleCat kbar)` to `Sheaf J
   AddCommGrpCat` is the right `IsFlasque.shortExact_app_surjective`
   route** (Lane H). The bridge isolates the residual to a single
   well-defined typeclass goal `(sheafCompose forget₂).PreservesHomology`
   (or `PreservesRightHomologyOf S`), instead of fighting through the
   module-valued sheaf SES directly. `Mono` + `Epi` transfer pointwise
   axiom-clean via `Sheaf.Hom.mono_of_presheaf_mono` /
   `Sheaf.isLocallySurjective_iff_epi'`. Reusable for any
   ModuleCat-valued-sheaf SES reduction to AddCommGrpCat.
2. **`Module.depth_pi_const_eq_depth_of_nonempty` is the canonical
   substrate for "free module of finite rank has same depth as base
   ring"** (Lane G). Pattern factors through (a)
   `Submodule.ideal_span_singleton_smul` bridging `r • ⊤_{ι → M}` and
   `Ideal.span {r} • ⊤_{ι → M}`; (b) `Submodule.quotientPi` for
   `QuotSMulTop`-on-pi linear-equiv; (c) `Pi.isSMulRegular_iff` for
   SMul-regular conjunct; (d) `LinearEquiv.isRegular_congr` for
   quotient piece. ~135 LOC end-to-end, all kernel-only.
   Reusable for any Auslander–Buchsbaum / projective-dimension /
   flat-module argument identifying depth across `M ≃ₗ[R] (Fin k → R)`.
3. **Closed-points reduction via `JacobsonSpace.closure_closedPoints`
   converts a global topological range-containment into a per-closed-
   point chart-evaluation** (Lane B). Pattern: derive `JacobsonSpace`
   on the relevant scheme via `LocallyOfFiniteType.jacobsonSpace` on a
   composition chain (cover.f → cover.f → PG.hom, all LOFT); derive
   density of closed points; assemble `range s_pair ⊆ closure (s_pair
   '' closedPoints) ⊆ closure (range Δ) = range Δ` via
   `Continuous.range_subset_closure_image_dense` +
   `IsClosed.closure_eq`. Reusable for any range-containment proof on
   a Jacobson scheme.
4. **`IsProper ⟹ LocallyOfFiniteType` + base `IsLocallyNoetherian` ⟹
   total scheme `IsLocallyNoetherian`** (Lane I). Direct 4-LOC Mathlib
   composition `IsProper.toLocallyOfFiniteType +
   LocallyOfFiniteType.isLocallyNoetherian +
   instIsLocallyNoetherianSpecOfIsNoetherianRingCarrier`. Reusable for
   any proper-over-Noetherian-base regularity prep.
5. **Algorithm-of-instance demotion to non-instance lemma is a clean
   soundness fix when the body invokes `sorryAx` transitively** (Lane
   A.3.i). Mechanic: keyword swap `instance` → `theorem`; the
   typeclass `[GeometricallyConnected ...]` resolution can no longer
   silently fire on the sorry-bodied lemma. Consumers must opt in
   explicitly via `letI := ...`. Verified by `lean_verify` that
   `IdentityComponent.isOpenSubgroupScheme` is now kernel-only
   (`propext, Classical.choice, Quot.sound`).
6. **`LocallyQuasiFinite.of_fiberToSpecResidueField` reduces LQF of
   `φ.left` to a per-fibre LQF statement on
   `φ.left.fiberToSpecResidueField y`** (Lane RCI). Reusable for any
   smooth-morphism-LQF closure when the generic fibre is
   well-understood but a per-point analysis is needed.

## Recommendations for the next session

See `recommendations.md`.

## Blueprint markers updated (manual)

- `RiemannRoch_H1Vanishing.tex`, `lem:shortExact_app_surjective`:
  appended `% NOTE (iter-194 reviewer)` block recording that the
  body is now structurally decomposed via `forget₂` bridge to
  AddCommGrpCat; `Mono` + `Epi` axiom-clean inline; residual is the
  single typeclass `(sheafCompose forget₂).PreservesHomology` (or
  `PreservesRightHomologyOf S`). Future closure should target this
  precise gap rather than re-route through `j_!` machinery.
- `RiemannRoch_OCofP.tex`, `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`:
  appended `% NOTE (iter-194 reviewer)` block flagging that the body
  is now structurally closed but transitively gated through 2 named
  helpers (`h0_sub_h1_lineBundleAtClosedPoint_eq_two`,
  `h1_vanishing_genusZero`); consumers should consult those.
- `Picard_IdentityComponent.tex`, `lem:identity_component_geometrically_connected`:
  appended `% NOTE (iter-194 reviewer)` block recording the
  `instance → theorem` demotion (lean-auditor iter-193 must-fix
  CLEARED). Future callers must use `letI := identityComponent_geometricallyConnected G`.
- `RiemannRoch_RationalCurveIso.tex`,
  `lem:phi_left_locallyQuasiFinite_of_finrank_one`: appended `% NOTE
  (iter-194 reviewer)` block recording that body has been reduced via
  `LocallyQuasiFinite.of_fiberToSpecResidueField` to a per-fibre LQF
  statement; the substrate
  (`algebraMap_bijective_of_finrank_one`,
  `phi_left_functionField_algEquiv_of_finrank_one`) is now axiom-clean.

(`\leanok` markers are managed deterministically by `sync_leanok` —
this review made no `\leanok` edits. `\mathlibok` was not warranted on
any new declaration this iter — none of the prover-added helpers are
direct Mathlib re-exports without project-side proof.)

## Subagent skips

- **`lean-auditor`** (review phase): skipped — the iter-193
  lean-auditor whole-project audit is still the latest authoritative
  read on the project's largest soundness issue (the 7+ load-bearing
  typed-`:= sorry` definition carriers), and its corrective is
  EXPLICITLY DEFERRED to iter-195+ by the iter-194 plan-phase. Re-running
  it iter-194 would surface the same finding, and the plan agent has
  already filed the corrective. The other iter-194 prover-touched files
  are covered by the per-file lean-vs-blueprint-checker rationale below.
  Rationale: descriptor `dispatcher_notes` skip path "prior verdict had
  no must-fix-this-iter findings beyond ones the plan-phase has
  ACTIONED-IN-PLACE" — applies here.
- **`lean-vs-blueprint-checker` × 10**: skipped at per-file granularity.
  Rationale: the plan-phase `blueprint-reviewer iter194` already audited
  the cross-chapter Lean ↔ blueprint situation AND produced HARD GATE
  PASS via `iter194-fastpath` on the 2 chapters that were FAIL pre-prover
  (H1Vanishing + CodimOneExtension); the per-file lean-vs-blueprint-checker
  for the other 8 prover-touched files would duplicate what each
  prover already self-audited in its `task_results/*.md` and what the
  plan-phase blueprint-reviewer cleared. Sequential dispatch of 10 lvbc
  at `loop.max_parallel = 1` would be wall-clock-prohibitive (~75 min)
  for marginal new information. The plan-phase per-chapter checklist
  already governs the iter-195 plan-phase HARD GATE.

## Blueprint doctor

The deterministic `blueprint-doctor` ran with **no findings**: every
chapter is `\input`'d, every `\ref` / `\uses` resolves, every
annotation has a non-empty argument, no `axiom` declarations. See
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/logs/iter-194/blueprint-doctor.md`.

## sync_leanok attribution

`sync_leanok` ran iter=194 (sha=`b3255f69`, timestamp
`2026-05-27T02:42:28Z`): 6 added / 8 removed / 4 chapters touched
(`Albanese_CodimOneExtension`, `RiemannRoch_H1Vanishing`,
`RiemannRoch_OCofP`, `RiemannRoch_RationalCurveIso`). All `\leanok`
markers in the prover-touched chapters are the script's deterministic
verdict; no laundering observed.
