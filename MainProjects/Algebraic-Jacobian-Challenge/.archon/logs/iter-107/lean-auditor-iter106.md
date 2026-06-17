# Lean Audit Report

## Slug
iter106

## Iteration
106

## Scope
- files audited: 16 (all `.lean` under project tree excluding `.lake/`, `.archon/`)
- files skipped (per directive): 0

Audited paths:
- `AlgebraicJacobian.lean`
- `AlgebraicJacobian/AbelJacobi.lean`
- `AlgebraicJacobian/Differentials.lean`
- `AlgebraicJacobian/Genus.lean`
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/Rigidity.lean`
- `AlgebraicJacobian/Modules/Monoidal.lean`
- `AlgebraicJacobian/Picard/Functor.lean`
- `AlgebraicJacobian/Picard/FunctorAb.lean`
- `AlgebraicJacobian/Picard/LineBundle.lean`
- `AlgebraicJacobian/Cohomology/SheafCompose.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- (`references/challenge.lean` is the user-frozen problem-statement file; treated as out-of-scope for prover quality.)

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Plain import roster, 15 lines. Mirrors the project module graph. No issues.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14–28 `## Status` block is current: the three protected declarations all reduce via the `JacobianWitness` projection at L51, L62, L82. Bodies are closed (no `sorry`).
  - The dependence on `nonempty_jacobianWitness` (single existence sorry in `Jacobian.lean`) is correctly named in the docstring.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 (L29 `## Status (iteration 064 — scaffold)` followed by "All main declarations have `sorry` bodies. Closure trajectory is estimated at ~10 iterations" — see Excuse-comments section)
- **notes**:
  - Five sorries surface: L122 (`relativeDifferentialsPresheaf_isSheaf`), L636 (`cotangentExactSeq_structure.h_exact`), L718 (`smooth_iff_locally_free_omega`), L735 (`cotangent_at_section`), L877 (`serre_duality_genus`).
  - The two completed pieces of `cotangentExactSeq_structure` are mathematically substantive: `h_zero` (Route (c), uses the iter-082 `Derivation.postcomp_comp` helper) and `h_epi` (Option (c), uses `KaehlerDifferential.span_range_derivation`). Both proofs are internally consistent and the prerequisite helpers (`SheafOfModules.epi_of_epi_presheaf`, `Derivation.postcomp_comp`, `cotangentExactSeqBeta_hη`) are honestly closed.
  - `cotangentExactSeqAlpha` / `cotangentExactSeqBeta` bodies (L188–463) are substantial (hundreds of lines) but follow the universal property of `relativeDifferentials'`; they are not pseudo-proofs.
  - Minor: `set_option maxHeartbeats 16000000` recurs (L185, L338, L424, L501) — extreme but each appearance has a per-iteration explanation pointing at specific elaboration costs. Acceptable.
  - Minor: the `moduleKPresheafOfModules` / `moduleKSheafOfModules` block (L741–861) is closed and tidy; the `convert M.isSheaf using 1` at L852 is honest.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 (L39–61 dead-code sketch block — see Major)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The actual `genus` def at L65–68 is closed honestly via the project's `Scheme.HModule k (Scheme.toModuleKSheaf C) 1` (iter-009 carrier).
  - The L14–28 `## Status` block is accurate for the current body.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 (the L162–175 docstring for `nonempty_jacobianWitness` is a load-bearing `sorry` with an "assumed and the proof is deferred" rationale — see Excuse-comments section)
- **notes**:
  - Single project sorry at L179 (`nonempty_jacobianWitness`), packaging the four downstream protected instances. Acknowledged in the strategy.
  - L29–38 "Forbidden shortcut (sanity check)" block correctly identifies the terminal-object substitution as mathematically wrong for genus ≥ 1; this is healthy explicit anti-pattern documentation.
  - `IsAlbanese.unique` (L88–114) is fully closed; the bookkeeping with `g₁_eq_id` / `k₂_eq_id` is standard.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L19–26 new `## Status` block accurately states that `eq_of_eqOnOpen` is closed; corresponds to the body at L79–114 which uses `ext_of_isDominant_of_isSeparated'` honestly.
  - L38–69 "Hypothesis correction (iter 003 prover)" block is technical history but is informative for a reader and does not contradict current state. Acceptable.
  - The retained unused class hypotheses (L62–67 comment + L82–87 in the signature) are correctly flagged in the docstring as forward-compatibility carriers.

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (L166–173 `instIsMonoidal_W` body terminates in `sorry`)
- **bad practices**: none
- **excuse-comments**: 1 (L161–165 admits the sorry "does NOT block downstream consumers" — argues for keeping it; see Excuse-comments)
- **notes**:
  - **Same critical finding as iter-105: `instIsMonoidal_W := ... sorry` at L173.** Per directive, re-flag at the same severity (critical). The docstring at L100–165 documents the substantive Mathlib gap (stalk-of-presheaf-tensor in the varying-ring setting) and rules out three alternative routes; the math is honestly described, but the Lean obligation remains open.
  - `instMonoidalCategoryStruct` (L183–186) and `instMonoidalCategory` (L190–193) are honestly closed using `LocalizedMonoidal` — these are fine.
  - The "load-bearing" defence (L161–165) — that no current consumer takes `(W X).IsMonoidal` as an explicit hypothesis — is correct as of this audit (`grep -nE "\(W X\)\.IsMonoidal|W .*IsMonoidal" AlgebraicJacobian/` confirms no consumer references it). But the instance itself **is** a load-bearing typeclass synthesis target: any future code that depends on `MonoidalCategory X.Modules` going through the localization machinery requires `(W X).IsMonoidal` to be inferable, and `sorry` here propagates non-trivially. Keep as must-fix.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 (L185–190 `PicardFunctor.representable := sorry`)
- **bad practices**: none
- **excuse-comments**: 1 (L26–36 explicitly justifies keeping `PicardFunctor.representable` as `sorry` — see Excuse-comments)
- **notes**:
  - `PicardFunctor` itself (L158–174) is honestly closed.
  - The `fiberMap` / `quotMap` helpers (L67–142) are tight and well-tested. No suspect bodies.
  - `representable` is "intentionally deferred" because it sits on top of `LineBundle` defined as a global-sections approximation (see LineBundle.lean entry). The deferral logic ("closing on the wrong functor would silently assert representability of the wrong functor and is a forbidden shortcut") is sound *given* the current weakened def, but it is a downstream symptom of the L85 weakened-wrong `LineBundle`.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `PicardFunctorAb` (L59–76), `forgetCompare` (L84–87), `PicardFunctorAb_forget_obj` (L94–98), and `etaleSheafified` (L109–114) are all honestly closed.
  - L100–108 docstring's universe annotation `AddCommGrpCat.{max u (u+1)}` matches the body at L112; coherent.
  - One mild nit: `AddCommGrpCat.{max u (u+1)}` is `AddCommGrpCat.{u+1}` (since `max u (u+1) = u+1`); using the simpler form would aid readability. Minor only.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: none
- **suspect definitions**: 1 (L85–86 `def LineBundle X := CommRing.Pic (Γ(X, ⊤))`)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 (L18–60 + L71–84 docstrings explicitly call this a "stand-in", "first-approximation", "image of the natural map", "strict subgroup in general" — see Excuse-comments section)
- **notes**:
  - **Same critical finding as iter-105: the weakened-wrong definition of `LineBundle X` at L85–86 stands.** Per directive, re-flag at the same severity (critical). The file docstring is admirably honest about the mismatch — the def fails on projective space (Pic = ℤ vs. global-sections Pic = trivial) — but the definition is still installed under the canonical name `AlgebraicGeometry.Scheme.LineBundle` and consumed downstream by `Picard/Functor.lean`'s `PicardFunctor.representable`. Every theorem stated *about* `LineBundle X` is therefore a theorem about the wrong object on non-affine schemes.
  - The group structure (`instCommGroupLineBundle`, L96–98), `Pic.pullback` (L120–122), `Pic.pullback_id` (L136–140), `Pic.pullback_comp` (L145–151) are all closed honestly *against this weakened def* — they are not themselves wrong, but they are downstream of a wrong def.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Closed file. `instHasSheafCompose_forget_CommRing_AddCommGrp` (L39–47) is a tight 4-line term-mode body. Status block accurate.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three declarations closed via `inferInstance` / `HasExt.standard` / `sheafCompose.obj`. Status block accurate.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **New L27–34 `## Status` block is accurate:** the (1)–(8) helpers (L135–225) are all closed; downstream extensions iter-009+ (HModule, HModule', cohomology-presheaf, finite-transport scaffolding) are downstream content, and the new block correctly limits its scope to Phase A step 5.
  - The earlier inline Mathlib gap-fills `Functor.const_additive` / `Functor.const_linear` / `Adjunction.left_adjoint_linear` / `right_adjoint_linear` / `homLinearEquiv` (L50–98) live in `namespace CategoryTheory`. They are mechanical generalisations of Mathlib's `Adjunction.left_adjoint_additive` / `right_adjoint_additive` to the `Linear R` enrichment. Bodies use `(adj.homEquiv _ _).injective` + `simp [adj.homEquiv_unit]` honestly; not suspect.
  - The iter-046 producer `instIsHModuleHomFinite_toModuleKSheaf` (L765–777) is honestly closed by the four-step chain documented in the docstring. The chain hinges on iter-044's `module_finite_globalSections_of_isProper` (L605–641), which uses the Mathlib `finite_appTop_of_universallyClosed` for proper integral schemes — a legitimate use.
  - Iter-009 `HModule` (L248–253) and iter-014 `HModule'` (L295–301) are `noncomputable abbrev` (not `def`) for instance-synthesis reasons that are explicitly justified in their docstrings (instance synthesis must see through to find `Module k`). The choice is correct.
  - Several typeclass carriers (`IsAffineHModuleVanishing`, `IsAffineHModuleHomFinite`, `IsHModuleHomFinite`, `IsCechAcyclicCover`) are declared but no project-level *producer* instance exists for `IsAffineHModuleVanishing` / `IsCechAcyclicCover` *for the structure sheaf in general*. This is a scaffolding pattern (the producer arrives only from `BasicOpenCech.lean`'s substantive theorem chain), not a defect. Note: the `IsAffineHModuleHomFinite` class is explicitly **deprecated** in its L527–542 docstring as "dead scaffolding" because it would require `Γ(U, O_C)` finite over `k` on every affine cover member, which fails on `ℙ¹`. The class is *kept* and an honest pivot to `IsHModuleHomFinite` is documented — fine, but the leftover class is unconsumed code (no producer, no consumer that depends on it beyond L476–488's `module_finite_HModule'_zero_of_isAffineHModuleHomFinite`). See Minor.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No `sorry`. Iter-034 gap-fill `Abelian.Ext.chgUnivLinearEquiv` (L103–112) wraps Mathlib's `chgUniv : Ext.{w} X Y n ≃ Ext.{w'} X Y n` (a bare `Equiv`) into a `LinearEquiv` honestly via two private helpers (`chgUniv_add`, `chgUniv_smul`).
  - Iter-016 → iter-026 abstract MV LES infrastructure (`HModule'_cohomologyPresheaf`, `HModule'_toBiprod`, `HModule'_fromBiprod`, `HModule'_isPushoutModuleCatFreeSheaf`, `HModule'_shortComplex_*`, `HModule'_δ`, `HModule'_sequence`, `HModule'_sequenceIso`, `HModule'_sequence_exact`, `HModule'_δ_toBiprod`, `HModule'_fromBiprod_δ`) — all closed, mirroring the Mathlib `AddCommGrpCat`-flavour proofs at the analogous lines. Mechanical but correct.
  - Two minor Mathlib gap-fill instances are registered locally: `ModuleCat_free_isLeftAdjoint` (L252–254) and `ModuleCat_free_preservesMonomorphisms` (L343–348). Both have short honest proofs.
  - `set_option backward.isDefEq.respectTransparency false in` recurs (L356, L525, L541, L567). This is the standard escape hatch when matching Mathlib's MV.lean proofs; not new and not abusable here.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No `sorry` in this file. Iter-028 `AffineCoverMVSquare` carrier + iter-029 specialisations + iter-030 curve wrappers + iter-031 → iter-037 cover-totality bridges + iter-049/050/051/052 `IsCechAcyclicCover` / `HasCechToHModuleIso` consumers + iter-053 `HasAffineCechAcyclicCover` carrier + iter-053 producer `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` are all honestly closed.
  - The L506–507 "since iter-048; no new axiom introduced" inline note is informative and accurate (the kernel-only axiom set `{propext, Classical.choice, Quot.sound}` is what Mathlib's `Classical.choice` uses).
  - One typeclass design comment: `HasCechToHModuleIso` (L492–500) wraps a `Nonempty (∀ n, LinearEquiv)` because the comparison-iso is data. The downstream `cechToHModuleIso` (L508–516) extracts via `Classical.choice`. Standard pattern; fine.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 (sorries at L1120, L1212, L1536, L1564, L1754, L1802 — total 6 `sorry` tactic invocations in this file, plus a 7th referenced as "currently sorry" in the docstring of `cechCofaceMap_pi_smul` at L928 → its actual sorry at L1120)
- **bad practices**: none egregious — see notes
- **excuse-comments**: 0 directly; see Minor for indirect "deferred" framing on labelled sorries
- **notes**:
  - **Per directive: do NOT re-report L1120 (`cechCofaceMap_pi_smul` partial proof body sorry) or L1802 (`h_loc_exact` partial-proof sorry) UNLESS mathematically wrong. They are intentional plan-blessed WIP.** I have inspected both and they are *not* mathematically wrong as Lean: each sorry sits in a body whose preceding tactic chain is structurally consistent with the stated goal, and the surrounding scaffolding (helper lemmas `cechCofaceMap_summand_family`, `_R_linear`, `_R_linear`, the wrapper `cechCofaceMap_summand_family'`, the structural lemmas `alternating_sum_pi_smul_aux`, `_sum_comp`, `alternating_zsmul_pi_smul_aux_sum_comp`, etc.) is honest project-local plumbing — closed (apart from `cechCofaceMap_pi_smul` itself) and mathematically defensible.
  - **Re-flagging the OTHER four sorries** in this file (not exempt under the directive):
    - **L1212** (`h_a`): substep (a) — extra-degeneracy on the slice cover. Body is `sorry` with detailed comment pointing at `FormalCoproduct.extraDegeneracyCech` + `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv` + `CochainComplex.opEquivalence`. Substantive math content, intentional decomposition. Plausible but pending.
    - **L1536** (`h_transport`): Čech-cohomology refinement transport from `s` to a finite subspanning `s₀`. The body sets up `π : K ⟶ K₀` and proves it is a split-epi at each degree (using `splitEpi_pi_lift_of_injective` helper), then sorries at the diagram-chase step that lifts `K₀`-exactness to `K`-exactness through the kernel complex.
    - **L1564** (`h_a₀`): substep (a) for the `s₀`-indexed cover (same extra-degeneracy story as `h_a` at L1212, applied to the finite cover). Mathematically the same content.
    - **L1754** (`g_R.map_smul'`): R-linearity of the second Čech differential as a literal `LinearMap` builder. Comment at L1744–1753 explicitly says `f_R` was closed but `g_R` blocked on `Eq.mpr`-transport through `CochainComplex.next`. Plausibly resolvable by the same `change` + `e_i.injective` + helper invocation as `f_R`, but not done yet.
  - **The two directive-exempt sorries (L1120, L1802)** are intentionally scaffolded work in progress. I confirm they are not "fake" sorries (no `:= rfl` on non-trivial claims; no axiomatic injection). They block the file but they are project-blessed.
  - Aggressive `set_option maxHeartbeats` ladder: `800000` at L1128 (`cechCofaceMap_pi_smul`) and `1600000` at L908 (a sister theorem); the L908 lift is justified by the unfinished body. Once L1120 closes the heartbeats should be revisited.
  - `attribute [local simp] sub_eq_add_neg in` (L542) and `attribute [local simp] HModule'_toBiprod_apply in` (L526) appear in `MayerVietorisCore.lean` already — but BasicOpenCech.lean uses them via the imported file; no double-registration here.

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/LineBundle.lean:85` — `def LineBundle (X : Scheme.{u}) : Type u := CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))`. **Weakened-wrong definition** standing in for "invertible quasi-coherent O_X-module". The file docstring itself documents the mismatch (strict subgroup on non-affine `X`; gets `Pic ℙ¹ = trivial` whereas the true `Pic ℙ¹ = ℤ`). Why must-fix: per directive item (1) and the must-fix verbatim rule, weakened-wrong definitions land here regardless of how thoroughly they are documented as "stand-ins" — the documentation makes the wrongness explicit, it does not absolve it. Severity: **critical** (carried forward from iter-105).
- `AlgebraicJacobian/Modules/Monoidal.lean:166-173` — `instIsMonoidal_W : (W X).IsMonoidal := by … sorry`. **Sorry-bodied typeclass instance on a substantive claim.** Why must-fix: a `sorry`-bodied `instance` is a typeclass-search-visible declaration; even if no current consumer dispatches on it, it is registered for synthesis and propagates the sorry into any future code that asks for `MonoidalCategory X.Modules` via the localization route. The defence "does NOT block downstream consumers" (L161–164) is a deferral excuse, not a correctness argument. Severity: **critical** (carried forward from iter-105).
- `AlgebraicJacobian/Picard/Functor.lean:190` — `PicardFunctor.representable := sorry` on a load-bearing existence claim. The file docstring (L26–36) explicitly states keeping it as sorry "to avoid asserting representability of the wrong functor". Why must-fix: the rationale is correct but it documents a *downstream* symptom of the LineBundle weakened-wrong def; the sorry will only become honestly closeable once `LineBundle` is fixed. Counted at must-fix to keep the dependency on the LineBundle fix visible — once LineBundle is the invertible-quasi-coherent-sheaf object, this representability can either close (FGA / Mathlib) or remain as a clearly-labelled Phase-C deferral whose obstruction is no longer the wrong def. Severity: **major** (downstream of the critical LineBundle issue, not independently load-bearing).

## Major

- `AlgebraicJacobian/Genus.lean:39-61` — **Dead-code sketch block** preserved as a multi-line `/- … -/` comment. Reproduces an old proof outline (`OXAsAddCommGrpSheaf`, `H1OC`) that has been entirely replaced by the iter-009 `HModule` route. Stale; should be deleted or replaced with a one-line note pointing at the current body. Severity: major (genuinely outdated comment, not just stylistic noise).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1212` — `h_a := sorry` (substep (a), extra-degeneracy on slice cover). Substantive, not WIP-exempt per the directive (only L1120 and L1802 are exempt). Severity: major (scaffolded, mathematically defensible, but open).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1536` — `h_transport := sorry` (Čech-cohomology refinement transport). Substantive. Same severity.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1564` — `h_a₀ := sorry` (substep (a) on `s₀`-indexed cover). Substantive. Same severity.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1754` — `g_R.map_smul' := sorry`. The mirror of `f_R.map_smul'` (closed). The comment at L1744–1753 is concrete about the blocker (`Eq.mpr`-transport through `CochainComplex.next`); resolvable next iter. Severity: major.
- `AlgebraicJacobian/Differentials.lean:122` — `relativeDifferentialsPresheaf_isSheaf := sorry`. The Phase B step 1 main gap. Comment at L98–112 lays out the proof outline (Substep 1 `KaehlerDifferential.isLocalizedModule`, Substep 2 basis sheaf condition, Substep 3 globalisation). Honest scaffolding sorry, not flagged as critical because Phase B is acknowledged as a multi-iteration project, but it is still load-bearing for downstream Differentials consumers (`relativeDifferentials` at L128 and `cotangentExactSeq_structure` exactness at L636). Severity: major.
- `AlgebraicJacobian/Differentials.lean:636` — `cotangentExactSeq_structure.h_exact := sorry`. Documented as requiring `SheafOfModules.exact_iff_stalkwise` (multi-iteration). Severity: major.
- `AlgebraicJacobian/Differentials.lean:718, 735, 877` — three more Phase B step-2 sorries (`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`). Phase B headline obligations. Severity: major.
- `AlgebraicJacobian/Jacobian.lean:179` — `nonempty_jacobianWitness := sorry`. The single Phase C existence-of-Albanese sorry, packaging the four downstream `Jacobian C` instances. Major (it is the single project sorry that the entire Phase E reduction depends on; the L162–175 docstring documents the mathematical content honestly).

## Minor

- `AlgebraicJacobian/Picard/FunctorAb.lean:111-112` — universe annotation `AddCommGrpCat.{max u (u+1)}` is needlessly verbose; `AddCommGrpCat.{u+1}` is equivalent (since `max u (u+1) = u+1`). Optional readability cleanup.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:458-466` (`IsAffineHModuleHomFinite`) and L476–488 (`module_finite_HModule'_zero_of_isAffineHModuleHomFinite`) — the class itself is documented at L527–542 as "dead scaffolding" (incompatible with non-trivial proper curves: `Γ(U, O_C)` is not k-finite on affine opens of `ℙ¹`). The pivot to `IsHModuleHomFinite` (iter-043, L544–549) is correct, but the dead class and its consumer remain in the file. Removing them would tighten the API.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — heartbeat ladder (`maxHeartbeats 800000` at L1128, `1600000` at L908) is high. Once L1120 closes, revisit budget.
- `AlgebraicJacobian/Modules/Monoidal.lean:120-159` — the in-docstring "Iter-080 investigation (stalks-level route)" block embeds the prover's diagnostic narrative. Helpful for continuity but tightens the file. Optional refactor into `analogies/` or `.archon/logs/`.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:343-348` (`ModuleCat_free_preservesMonomorphisms`) — fine as-is, but a one-line PR to upstream Mathlib's `ModuleCat/Adjunctions.lean` would remove this project-local instance entirely. Track as upstream candidate.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1622-1700` — the `letI perI₁`, `letI h_mod_pi₁`, ... block is reconstructed body-locally in `cechCofaceMap_summand_family_R_linear` (L547–566), `cechCofaceMap_summand_family'_R_linear` (L689–708), and `cechCofaceMap_pi_smul` itself (L972–991). Could be extracted to a single helper definition. Not breaking, but noisy.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/LineBundle.lean:18-60, 71-84`: extensive "*first-approximation*" / "*non-vacuous stand-in*" / "*strict subgroup in general*" framing around the L85–86 weakened-wrong `def LineBundle`. The docstring is intellectually honest about the mismatch, but it is precisely the kind of declaration the lean-auditor flags as a critical excuse-comment: an admission, attached to a load-bearing definition, that the definition is wrong on non-affine `X`. Severity: **critical**.
- `AlgebraicJacobian/Modules/Monoidal.lean:161-165`: "this sorry does NOT block downstream consumers, … Phase C step C1 (LineBundle refinement) is unblocked." This is a deferral excuse attached to a load-bearing sorry-bodied `instance`. Severity: **critical**.
- `AlgebraicJacobian/Picard/Functor.lean:26-36`: "intentionally left as `sorry` — … forbidden shortcut: keep it as `sorry`." Mathematically the rationale is correct (closing on the weakened-LineBundle `PicardFunctor` would assert representability of the wrong functor). But the comment frames a sorry-on-load-bearing-claim as a workflow rule, which the lean-auditor lint identifies as an excuse-comment. Severity: **major** (downstream of LineBundle).
- `AlgebraicJacobian/Differentials.lean:27-31`: "**Status (iteration 064 — scaffold)** All main declarations have `sorry` bodies. Closure trajectory is estimated at ~10 iterations." Multi-sorry status block. Each individual sorry is mathematically defensible but the *aggregate* framing — "this whole file is scaffold for ten more iterations" — is the kind of comment that normalises sorries as workflow. Severity: **major**.
- `AlgebraicJacobian/Jacobian.lean:162-175` (`nonempty_jacobianWitness` docstring): "the existence is assumed and the proof is deferred to a future iteration." Severity: **major** (single high-impact deferral, plan-bless­ed by strategy).

## Severity summary

- **must-fix-this-iter**: 3 — `LineBundle` weakened-wrong def (critical), `instIsMonoidal_W := sorry` (critical), `PicardFunctor.representable := sorry` (major, downstream of LineBundle).
- **major**: 11 — `Genus.lean` dead-code sketch; the four non-exempt BasicOpenCech sorries (L1212, L1536, L1564, L1754); five Differentials sorries (L122, L636, L718, L735, L877); `Jacobian.lean:179` (`nonempty_jacobianWitness`).
- **minor**: 6 — universe-annotation simplification (`FunctorAb.lean`); dead `IsAffineHModuleHomFinite` class (`StructureSheafModuleK.lean`); BasicOpenCech heartbeat ladder; in-docstring diagnostic narrative (`Modules/Monoidal.lean`); upstream-Mathlib candidate (`ModuleCat_free_preservesMonomorphisms`); repeated local `letI` blocks in `BasicOpenCech.lean`.
- **excuse-comments**: 5 (also counted under must-fix-this-iter / major above; the LineBundle one and the `instIsMonoidal_W` one alone are critical; the others are major).

Overall verdict: two long-standing critical structural defects (the weakened-wrong `LineBundle` and `instIsMonoidal_W := sorry`) remain exactly as flagged in iter-105 and continue to dictate downstream deferrals (`PicardFunctor.representable`); the iter-108-cleanup refactor of the `## Status` blocks in `StructureSheafModuleK.lean` and `Rigidity.lean` is accurate and the directive-exempt iter-106 prover work in `BasicOpenCech.lean` (L1120 `cechCofaceMap_pi_smul` and L1802 `h_loc_exact`) is mathematically defensible plan-blessed WIP.
