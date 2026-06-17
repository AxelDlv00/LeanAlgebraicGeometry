# Lean Audit Report

## Slug
review140

## Iteration
140

## Scope
- files audited: 13
- files skipped (per directive): 0 — directive scopes the audit to `AlgebraicJacobian/**` plus `AlgebraicJacobian.lean`; `.archon/multilane/lanes/**`, `.archon/lanes/**`, `.lake/`, and `lake-packages/` are excluded as per directive.

Files (in scope):
1. `AlgebraicJacobian.lean` (12 LOC)
2. `AlgebraicJacobian/AbelJacobi.lean` (94 LOC)
3. `AlgebraicJacobian/Differentials.lean` (144 LOC)
4. `AlgebraicJacobian/Genus.lean` (45 LOC)
5. `AlgebraicJacobian/Jacobian.lean` (301 LOC)
6. `AlgebraicJacobian/Rigidity.lean` (123 LOC)
7. `AlgebraicJacobian/RigidityKbar.lean` (89 LOC)
8. `AlgebraicJacobian/Cohomology/SheafCompose.lean` (49 LOC)
9. `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (63 LOC)
10. `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (877 LOC)
11. `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (627 LOC)
12. `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (711 LOC)
13. `AlgebraicJacobian/Cotangent/GrpObj.lean` (819 LOC)

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import-aggregator (12 lines). Twelve imports, lexically grouped (cohomology files first, then cotangent / differentials / rigidity / genus / jacobian / abel-jacobi). No code content to flag.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve` L51, `comp_ofCurve` L62, `exists_unique_ofCurve_comp` L82) uniformly project from the iter-073 `jacobianWitness C`. Bodies are 4-line `letI`-instance preamble + 1-line projection. Clean.
  - The status docstring (L14–29) is accurate w.r.t. the live `Jacobian.lean` API (`jacobianWitness`, `isAlbaneseFor`); no drift detected.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `relativeDifferentialsPresheaf` (L51): honest construction via `pullbackPushforwardAdjunction.homEquiv.symm` + Mathlib `relativeDifferentials'`. Body 3 lines.
  - `kaehler_localization_subsingleton` (L70) and `kaehler_quotient_localization_iso` (L86): substantive proofs (`FormallyUnramified` + `LinearEquiv.ofBijective` with explicit subsingleton-of-tensor-product chain). Body looks mathematically right (uses `KaehlerDifferential.exact_mapBaseChange_map` for surjectivity, `map_surjective` for injectivity).
  - `smooth_locally_free_omega` (L124): forward-direction Jacobian criterion. Statement carefully documents that the reverse direction is *false* without `Algebra.H1Cotangent` input (L118–123). Body uses `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` and chains free/rank conclusions via `algebraize`. Reasonable.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (heavy `import Mathlib`; minor)
- **excuse-comments**: none
- **notes**:
  - `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` (L40–43). Honest definition of `dim_k H^1(C, O_C)`. Clean.
  - L6 `import Mathlib` is heavy; would be tighter as targeted imports, but not wrong. Minor style.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: 2 sorry-bodied scaffolds (in scope; documented)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `IsAlbanese` (L71–77): standard universal-property `Prop`. Three field accessors `ofCurve`/`comp_ofCurve`/`exists_unique_ofCurve_comp` in the `IsAlbanese` namespace, each one-line `Classical.choose`/`Classical.choose_spec` extraction. Standard.
  - `IsAlbanese.unique` (L102): substantive proof — uses the universal property twice to extract `g`, `h` then squeeze identities out via two `hg₁_unique` / `hk₂_unique` applications. Body looks honest.
  - `geometricallyIrreducible_id_Spec` (L134): claims `GeometricallyIrreducible (𝟙 (Spec k))`. Body: pulls back along an identity arrow ⇒ `snd` is iso ⇒ `Z ≅ Spec K` ⇒ `IrreducibleSpace Z`. Mathematically correct.
  - `JacobianWitness` (L157): structure bundling `J`, group-/proper-/smooth-/irred-instances, and a `∀ P, IsAlbanese …` field. Holds *uniformly* over the marked point — load-bearing for `AbelJacobi.ofCurve` projection at arbitrary `P`.
  - `genusZeroWitness` L193 body `sorry`: documented as iter-127 scaffold, body closure iter-138+ pending shared cotangent-vanishing pile. Honest scaffold.
  - `positiveGenusWitness` L219 body `sorry`: documented as iter-134 scaffold (off-critical-path until M2 closes). Honest scaffold.
  - `nonempty_jacobianWitness` (L249): iter-135 genus-stratified delegation `by_cases h : genus C = 0` → `genusZeroWitness` / `positiveGenusWitness`. No inline `sorry` here — the body is honest delegation; the substance lives in the two arms.
  - `Jacobian C := (jacobianWitness C).J` (L275): one-line projection from `Classical.choice`-extracted witness. Documented "forbidden shortcut" block (L44–52) explicitly rules out the `:= 𝟙_ (Over (Spec (.of k)))` terminal-object cheat. Good defensive design.
  - The four protected instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) at L285–297 are one-line projections from the witness.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` (L91): closed. Body is a 4-step assembly (separatedness via `Y.left ↘ Spec`, irreducibility via `subsingleton` base, dominance of dense open immersion, then `Over.OverMorphism.ext` + Mathlib `ext_of_isDominant_of_isSeparated'`). Clean.
  - The "Hypothesis history" block (L43–78) is honest — explains *why* the original point-wise topological hypothesis was strengthened to scheme-level (Frobenius counterexample in char p), and documents the iter-125 hypothesis cleanup. Not an excuse-comment; it's a design-rationale block.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: 1 sorry-bodied scaffold (in scope; documented)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `rigidity_over_kbar` (L75–87) body `sorry`: documented as iter-126 scaffold, closure gated on shared cotangent-vanishing pile (iter-129+) per blueprint and STRATEGY §M2.a / §M2.d-alt. Honest scaffold.
  - The "Encoding choice" docstring (L32–46) records why Option B (abstract curve) was chosen over the literal `Spec(MvPolynomial …)` Option A (which would be the *affine*, not projective, line and is therefore mathematically wrong as a `ℙ¹` encoding). This is a substantive correctness note, not an excuse — kept the refactor from landing a wrong literal.
  - The `_hgenus` and `_hf` hypothesis names start with underscores (unused in current sorry-body). Consistent with scaffold status; once the body lands they will be used.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (heavy `import Mathlib`; minor)
- **excuse-comments**: none
- **notes**:
  - Single instance `instHasSheafCompose_forget_CommRing_AddCommGrp` (L39). 5-line body chaining `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`. Closed iteration 003. Clean.
  - L7 `import Mathlib` is heavy; minor style.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations (`instHasSheafify_Opens_AddCommGrp` L34, `instHasExt_Sheaf_Opens_AddCommGrp` L43, `toAbSheaf` L56). All one-line bodies. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Largest file in scope (877 LOC). All declarations have honest bodies. Long structurally — many `_curve` dot-notation wrappers and class predicates around `Module.Finite k` transports through linear equivalences.
  - **Mathlib gap-fills** (project-local additions, ostensibly upstream candidates): `Functor.const_additive` (L64), `Functor.const_linear` (L71), `Adjunction.left_adjoint_linear` (L89), `Adjunction.right_adjoint_linear` (L95), `Adjunction.homLinearEquiv` (L105). Bodies are short, principled. These look like legitimate Mathlib-contribution candidates.
  - `class IsAffineHModuleVanishing` (L432): existential predicate over affine opens. Class-style packaging is standard.
  - `class IsHModuleHomFinite` (L487): wholespace H⁰ Hom-finiteness. Has a *real* producer `instIsHModuleHomFinite_toModuleKSheaf` at L708 (assembled from `module_finite_gammaObj_of_isProper` + `constantSheafGammaHom_linearEquiv` + `homFromOne_linearEquiv`). Honest.
  - The "Historical note on the abandoned per-affine-open variant" (L475–486) explains that the per-affine-open `IsAffineHModuleHomFinite` class was dropped because $\Gamma(U, O_C)$ is not finite over $k$ on a proper affine open of a non-trivial curve (e.g.\ $\Gamma(U_i, O_{\mathbb{P}^1}) = k[t]$). This is honest mathematical retraction documentation, not an excuse-comment — the wrong scaffold has been removed and replaced.
  - `module_finite_globalSections_of_isProper` (L548): substantive proof. Uses `finite_appTop_of_universallyClosed`, `Module.Finite.of_equiv_equiv` along `ΓSpecIso`, and a `calc` chain to compatibilise the algebra maps. Looks correct.
  - Čech-side scaffolding (`Scheme.cechCochain_OC`, `Scheme.cechCohomology_OC`, `Scheme.cechCochain`, `Scheme.cechCohomology`, parameterised + structure-sheaf, with `_eq` bridging lemmas at L796/L804). Routine specialisations of Mathlib's `cechComplexFunctor`. Clean.
  - `Scheme.IsCechAcyclicCover` (L822): Prop class with single `Subsingleton`-of-positive-cohomology field. Standard.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Iter-034 Mathlib gap-fill: `Abelian.Ext.chgUniv_add` (L60), `Abelian.Ext.chgUniv_smul` (L79), `Abelian.Ext.chgUnivLinearEquiv` (L101). All private/short. Bodies use `ext` + `homEquiv_chgUniv` chain, standard pattern. Legitimate upstream-PR candidates.
  - Iter-016 → iter-026 MV LES core (`HModule'_cohomologyPresheafFunctor`, `_toBiprod`, `_fromBiprod`, `_toBiprod_fromBiprod`, `_isPushoutModuleCatFreeSheaf`, `_shortComplex`, `_shortComplex_f_mono`, `_shortComplex_g_epi`, `_shortComplex_exact`, `_shortComplex_shortExact`, `_δ`, `_sequence`, `_sequenceIso`, `_sequence_exact`, `_δ_toBiprod`, `_fromBiprod_δ`). All bodies probe-confirmed mirrors of Mathlib's `AddCommGrpCat`-flavoured `MayerVietorisSquare.lean`. Hot spots: `set_option backward.isDefEq.respectTransparency false in` is used at L354, L523, L539, L565 — these are localised tactic option overrides for definitional-equality leniency at structure-literal projection. Documented in comments.
  - `ModuleCat_free_isLeftAdjoint` (L250), `ModuleCat_free_preservesMonomorphisms` (L341): Mathlib gap-fills. Short, honest.
  - Iter-023 aux lemmas 1–4 (L479, L502, L525, L541) bridge `AddCommGrpCat`-side `biprodIsoProd` with `Ext`-side `biprodAddEquiv`. Bodies use `cat_disch` + `simp`. Reasonable.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: 1 class without a producer instance yet (minor — see notes)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `AffineCoverMVSquare` structure (L50) + four corner-identification simp lemmas (L79, L85, L91, L98) + curve-specialisations (`HModule'_sequence_curve` L135, `_sequence_curve_exact` L146, `_X₄_linearEquiv_curve` L339, `_finrank_HModule_eq_HModule'_X₄_curve` L371, `module_finite_HModule_of_HModule'_X₄_curve` L407). All routine dot-notation wrappers.
  - Iter-031 `HModule'_top_sourceIso` (L173): three-piece composition via terminal-collapse of yoneda, `Functor.constComp`, and `finsuppUnique`. Honest.
  - Iter-032 `HModule_top_linearEquiv` (L215): universe-`u+1` Ext transport via `precompOfLinear`. Body uses `LinearEquiv.ofLinear` with two-direction precomp; round-trip closes via `comp_assoc_of_second_deg_zero` + `mk₀_comp_mk₀` + `mk₀_id_comp`. Substantive.
  - Iter-033 `HModule'_top_linearEquiv` (L264): parallel at universe `u`. Same proof shape.
  - Iter-034 universe-bridge `HModule'_eq_HModule_linearEquiv` (L300): composes iter-033 + `Abelian.Ext.chgUnivLinearEquiv`. Substantive.
  - `class HasCechToHModuleIso` (L490): Prop class with `Nonempty (∀ n, …)` field. The extractor `cechToHModuleIso` (L506) uses `Classical.choice` — *documented* in its docstring (L500–505): "no new axiom introduced" since `Classical.choice` is already in the kernel-only axiom set. Honest.
  - **`class HasAffineCechAcyclicCover`** (L675) and its `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699) producer: the class wraps an existential of `(ι, 𝒰, ⨆𝒰 = U, IsCechAcyclicCover, HasCechToHModuleIso)` for every affine open. *No producer instance* for the class itself exists in scope — the docstring says "iter-053 is a thin scaffolding step — the existence is asserted, not constructed. The substantive iter-054+ work will instantiate". This has been pending since iter-053 with no instance landing in scope. Not a wrong definition (the class faithfully encodes a real geometric statement), but downstream `Module.Finite k (HModule k (toModuleKSheaf C) 1)` (the genus carrier) is gated through this class via the consumer producer chain — until an instance lands, the chain doesn't fire. Worth tracking as a structural gap. **Minor** (not must-fix): the file does not lie about its content; the docstring is candid.
  - `subsingleton_HModule_of_isCechAcyclicCover_top` (L433), `_curve` (L458), `_hasCechToHModuleIso_top` (L530), `_hasCechToHModuleIso_top_curve` (L548), `subsingleton_HModule'_supr_of_hasCechToHModuleIso` (L580), `_curve` (L597), `subsingleton_HModule'_of_hasCechToHModuleIso` (L627), `_curve` (L647). All routine wrappers chaining iter-048/049/050/051/052 consumers. Honest.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: 3 sorry-containing declarations (in scope; documented)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `cotangentSpaceAtIdentity` (L162): Replacement (B) construction. Body uses a `Classical.choose`-chain on `smooth_locally_free_omega` to extract chart `(U, V, e, x₀ ∈ V)`, then base-changes the algebraic Kähler module to `k` via `extendScalars ψV.hom`. The chart-non-canonicity caveat is *explicitly documented* in the docstring (L138–151). Companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (L257) pins `finrank k = n` via a parallel `Classical.choose`-chain reproducing the same witnesses. The whole construction is mathematically grounded — the meaningful invariant (rank) is proved. Honest.
  - `cotangentSpaceAtIdentity_eq_extendScalars` (L211): defensive structural-shape lemma. Body uses a parallel `Classical.choose`-chain to construct the existential witnesses then closes with `rfl`/`refine`. Clean.
  - `cotangentSpaceAtIdentity_finrank_eq` (L257): substantive — reproduces the body's `Classical.choose`-chain, sets up `Nontrivial Γ(G, V)` from the ring map `ψV` into the field `k`, applies `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq hrank`. Closed iter-132. Honest.
  - **Piece (i.b) Step 1** — `shearMulRight` (L350): binary-product shear iso in any cartesian-monoidal `GrpObj` category. Body is honest — closes both `hom_inv_id` and `inv_hom_id` via `lift_lift_assoc` chains + `lift_comp_inv_left`/`lift_comp_inv_right`. The `@[simps]` attribute and the two reassoc-tagged `shearMulRight_hom_fst`/`shearMulRight_hom_snd` simp companions look right. Closed.
  - **Iter-140 new helper** — `private theorem isIso_of_app_iso_module` (L544): iso-reflection bridge for `PresheafOfModules` morphisms. Mirrors `AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_app`. Body is 4-line proof using `isIso_iff_of_reflects_iso _ (PresheafOfModules.toPresheaf R)` + `NatTrans.isIso_iff_isIso_app` + `Functor.map_isIso`. Marked `private`; docstring says "Upstream-PR candidate". Clean.
  - **Iter-138 PARTIAL** — `basechange_along_proj_two_inv_derivation` (L573): the inverse-direction derivation. Body uses `PresheafOfModules.Derivation'.mk` + `ModuleCat.Derivation.mk` with pointwise rule `d_X(b) := KaehlerDifferential.D ((ψ.app X).hom b)`. The `d_add` and `d_mul` laws are closed (via `RingHom.map_add` / `RingHom.map_mul`). The `d_app` law (L602–624) and `d_map` cross-open naturality (L625–643) remain `sorry`-bodied, with detailed proof-design comments naming the categorical witness (`(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` factoring + `Derivation.map_algebraMap` for `d_app`; `Scheme.Hom.c.naturality` + `KaehlerDifferential.map_d` chase for `d_map`). The iter-140 prover's note "validated this pattern on a stand-alone example" (L613) is a useful auditing breadcrumb. These are honest forward-looking proof-design notes, not excuses.
  - **Inverse-direction morphism** — `basechange_along_proj_two_inv` (L654): transposes the universal-property-derived map along `pullbackPushforwardAdjunction`. 6-line `let`-chain. Honest, no `sorry` in this body.
  - **Step 2 (PARTIAL)** — `relativeDifferentialsPresheaf_basechange_along_proj_two` (L670): main piece (i.b) Step 2 iso. Body builds the iso via `(asIso (basechange_along_proj_two_inv G)).symm` after registering `IsIso` of the inverse via `isIso_of_app_iso_module (...) (fun _ => sorry)` at L688–689. So the `IsIso`-per-open check is the residual sorry — narrow, single-residue. Documented in the L526–688 block of docstrings.
  - **Step 3 (closed iter-136)** — `relativeDifferentialsPresheaf_restrict_along_identity_section` (L710): substantive proof closed using `PresheafOfModules.pullbackComp` on both sides + the categorical identity `section_snd_eq_identity_struct` (L458) + `eqToIso` bridge. No sorry. Honest.
  - **Compose main lemma** — `mulRight_globalises_cotangent` (L806–817): body `sorry`. Documented as iter-135 honest scaffold pending Step 2 closure. Honest.
  - **Re-flag check on directive's prior judgement**: iter-137/138/139 lean-auditors judged the docstrings on `_basechange_along_proj_two` (L465–525) and `_basechange_along_proj_two_inv_derivation` (L552–571) as proof-design analysis, not excuse-comments. **Confirmed**: I re-read those blocks. They are forward-looking technical sub-goal documentation naming specific Mathlib lemmas, categorical witnesses, and proof-strategy paths (Route (a) chart-unfolding vs Route (b) inverse-direction-via-adjunction-transpose). They do NOT say "this is wrong" or "stand-in" or "will fix later" in the excuse sense — they say "this PARTIAL sub-piece breaks into d_app + d_map + IsIso; here are the closure paths". This is healthy progress documentation and should remain.

## Must-fix-this-iter

(none — the 6 sorry-containing declarations are all documented honest scaffolds in the project's existing per-blueprint plan, per the directive's explicit "do NOT report each as must-fix UNLESS the body/comments cross into excuse-comment territory" guidance; no excuse-comments were found; no wrong definitions surfaced; no parallel-Mathlib APIs or axioms.)

## Major

(none.)

## Minor

- `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:675` — `class HasAffineCechAcyclicCover` has been awaiting a producer instance since iter-053 (now iter-140, 87 iterations later). Until an `instance HasAffineCechAcyclicCover (Scheme.toModuleKSheaf C)` lands for a proper smooth `Spec k`-curve, the consumer chain `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (L699) cannot fire, leaving the H>0 affine cohomology vanishing input unprovided. The docstring is candid about this ("the existence is asserted, not constructed"). Not a wrong definition; a structural gap worth tracking in the plan agent's deferred-work queue.
- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` is wide; project could tighten to targeted imports for compile-time. Pure style.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:7` — same `import Mathlib` style remark.
- `AlgebraicJacobian/RigidityKbar.lean:80,86` — hypotheses `_hgenus`, `_hf`, `p` are unused under the current `sorry` body; expected to be used once the body lands. Not a finding, just a tracking note for when the body closes (delete underscores).

## Excuse-comments (always called out separately)

(none — zero excuse-comments project-wide.)

A defensive scan for excuse-vocabulary (`TODO`, `placeholder`, `temporary`, `wrong but works`, `will fix later`, `stand-in`, `FIXME`, `XXX`) over `AlgebraicJacobian/**` returned no matches. All references to "sorry" in source comments are descriptive (e.g.\ "no sorry", "remains `sorry`-bodied", "Status: body is `sorry`") rather than excusing the sorry away.

Re-examined per directive: the iter-137/138/139 auditors' judgement that the long docstrings on `Cotangent/GrpObj.lean`'s `_basechange_along_proj_two` (L465–525, ~60 lines) and `_basechange_along_proj_two_inv_derivation` (L552–571, ~20 lines) blocks are *proof-design analysis*, not excuse-comments, is **confirmed**. They document the concrete remaining sub-goals (d_app coherence, d_map naturality, IsIso check) with specific Mathlib lemma names and two named closure routes (Route (a) chart-unfolding-helper, Route (b) inverse-direction-via-adjunction). This is the right kind of technical exposition; it should not be flagged.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 4 (one structural gap re `HasAffineCechAcyclicCover`'s missing producer, three style-only `import Mathlib` / unused-underscore notes)
- **excuse-comments**: 0

Overall verdict: project's Lean is in healthy shape — six `sorry`-bodied scaffolds (3 in `Cotangent/GrpObj.lean`, 2 in `Jacobian.lean`, 1 in `RigidityKbar.lean`) are all documented honest pieces of the blueprint-driven Phase-C / piece-(i.b) plan, no excuse-comments anywhere, no wrong definitions, no parallel-Mathlib APIs, and the iter-140 new helper `isIso_of_app_iso_module` is clean and honestly marked as upstream-PR-candidate.
