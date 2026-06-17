# Lean Audit Report

## Slug
review142

## Iteration
142

## Scope
- files audited: 12 (all `.lean` under the project)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Plain import barrel; nothing to audit beyond import ordering, which is fine (cohomology / cotangent / differentials precede rigidity / genus / jacobian / abel-jacobi).

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - L124–143: `smooth_locally_free_omega` honestly states it's the **forward** direction only and the docstring contains the explicit converse-failure counterexample (`Spec k → Spec k[t]`, `t ↦ 0`). This is exemplary — flags the project's awareness that the easy-looking converse is false.
  - L135: the `<;>` combinator after `refine ⟨…, ?_, ?_⟩` runs `first | exact … | exact …` on two unrelated goals (`Module.Free` and `Module.rank … = n`); the `first | …` chooses which closer fires on each leg. Mathematically correct but reads as a clever convergence trick; an `exact ⟨A.IsStandardSmooth.free_kaehlerDifferential, A.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential n⟩`-style two-prong term would be more direct. **Minor**, not a real concern.
  - L86–109: `kaehler_quotient_localization_iso` flagged in its own docstring as upstream-Mathlib-PR candidate (`KaehlerDifferential.equivOfFormallyUnramified`); no excuse content.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 0–1 (see notes)
- **suspect definitions**: 1 (see notes — L719–721 IsIso build from `(fun _ => sorry)`)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 0 (re-confirming iter-140 read; see flagged-issues discussion)
- **notes**:
  - L36–67 (`cotangentSpaceAtIdentity` outer file docstring): describes iter-128 → iter-129 → iter-130 → iter-131 → iter-132 evolution of the body shape. ~32 lines of "what changed when". This is project-archeology; the substantive content (Replacement (B), affine-chart base change, `Classical.choose`-chain) is present, but reading the file fresh in 20 iters one will find the iter-NN cross-references uninformative. **Re-confirm iter-140**: this is design analysis, not an excuse-comment.
  - L96–161 (`cotangentSpaceAtIdentity` declaration docstring): ~66 lines. The "Caveat on canonicity" block (L138–153) is genuine mathematical content — explains *why* the body uses `Classical.choose` and that the chart-canonicity is not load-bearing for the live consumer. Good docstring; not an excuse-comment.
  - L162–201: body of `cotangentSpaceAtIdentity`. The `Classical.choose`-chain (`h.choose`, `h.choose_spec.choose`, …) is structurally opaque but consciously chosen per the iter-131 design; the outer head symbol stays `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])` so downstream theorems can rewrite against it. Body is honest and lemma `cotangentSpaceAtIdentity_eq_extendScalars` (L211–232) witnesses the structural shape.
  - L211–232 (`cotangentSpaceAtIdentity_eq_extendScalars`): the existential RHS is re-extracted by the same `.choose_spec.choose_spec…` chain — the proof relies on definitional equality at every component (`refine ⟨…, …, …, …, rfl⟩` with one `change` + `rw` for the `htop` field). This is a self-witnessing lemma; reads cleanly.
  - L257–295 (`cotangentSpaceAtIdentity_finrank_eq`): same `Classical.choose`-chain pattern; closes via `change` to push to `TensorProduct …`-form then `rw [Module.finrank_baseChange]` + `exact Module.finrank_eq_of_rank_eq hrank`. Crisp.
  - L297–327: section header introducing piece (i.b) Step 1/2/3 + Compose plan. ~30 lines; informative but iter-NN-references will date.
  - L350–384 (`shearMulRight`): clean structural construction. The `hom_inv_id` proof uses two `rw [show … from by …]`-style explicit rewriters to handle the trickier `lift_lift_assoc`-direction step. Reads well.
  - L386–394: `@[reassoc (attr := simp)] lemma shearMulRight_hom_fst/_snd` — standard Mathlib idiom.
  - L408–426 (`schemeHomRingCompatibility`): docstring carefully distinguishes this from `(Scheme.Hom.toRingCatSheafHom f).hom` (the φ used by `PresheafOfModules.pullback`). Good — explicitly addresses a foot-gun.
  - L428–451: section header for the three piece-(i.b) closures (Step 2 / Step 3 / Compose). Status block names which are closed (Step 3 iter-136) and which are PARTIAL (Step 2 iter-137+) — reads as honest project state, not an excuse-comment.
  - L453–463 (`section_snd_eq_identity_struct`): direct 2-line proof. Clean.
  - L465–525: docstring for piece (i.b) Step 2 (60 lines). Describes "Iter-135 honest scaffold; iter-137 PARTIAL; iter-138 PARTIAL with substantive Route (b) skeleton landed" + three remaining sub-goals. Long but tracks the actual decomposition of the load-bearing sorry into three concrete sub-pieces. Re-confirm iter-140: this is proof-design analysis.
  - L527–550 (`isIso_of_app_iso_module`): private theorem, upstream-PR candidate per docstring. The 4-line proof chains `isIso_iff_of_reflects_iso`, `NatTrans.isIso_iff_isIso_app`, and `Functor.map_isIso`. Looks like a genuine reusable lemma; carry-over from iter-140 audit, still clean.
  - L552–674 (`basechange_along_proj_two_inv_derivation`): the closures of `d_add` and `d_mul` (L587–601) chain `RingHom.map_add` / `RingHom.map_mul` + `change` + `rw` + `exact ModuleCat.Derivation.d_add/d_mul`. These are honest. The `d_app` sorry (L637) is documented in the inline comment block L602–636 as "iter-142+ residual gap"; the comment block describes the *intended* recipe (factoring through a ring map `h`) and explicitly states why Mathlib defaults fail. This is documentation of a sub-goal that genuinely needs bespoke ~40–80 LOC of categorical chase — not "this is wrong but works". The `d_map` closure (L638–674) is the substantive iter-142 deliverable: the `change` is fully spelled (per the L641–645 negative-lesson note from iter-140's `pushforward₀`-whnf timeout), then `rw [show …_naturality_apply …]` lines up the kernel form, and `exact (relativeDifferentials'_map_d _ _ _).symm` discharges. Reads cleanly. **The use of `show … = … from NatTrans.naturality_apply …` to rewrite is a tactic-shape choice that documents-itself**: the inline comment at L654–657 explains *why* the bare `NatTrans.naturality_apply` form would not match the goal's `RingCat.Hom.hom`/`CommRingCat.Hom.hom` mix. Justified.
  - L676–699 (`basechange_along_proj_two_inv`): clean term-level construction; transposes a universal-property-derived morphism through `pullbackPushforwardAdjunction.homEquiv.symm`. No surprises.
  - L701–721 (`relativeDifferentialsPresheaf_basechange_along_proj_two`): **suspect body**. The `letI : IsIso … := isIso_of_app_iso_module _ (fun _ => sorry)` builds an `IsIso` instance from `sorry`, then uses `(asIso _).symm` to deliver the named iso. This makes the iso a `sorry`-derived value. The docstring on the parent declaration (L465–525) clearly flags this and identifies it as a "third concrete sub-piece" remaining. So the declaration is an *honest* scaffold delivering the typed signature with a tracked sorry inside — but consumers reading `relativeDifferentialsPresheaf_basechange_along_proj_two G` get a `sorry`-tainted iso. Flag as major below (not must-fix: declaration is sorry-bodied honestly, not an excuse-comment), with note that downstream `simp`-rewriting against this iso will silently consume sorry. The L709–718 inline comment is design analysis of two closure routes — re-confirm iter-140.
  - L723–784 (`relativeDifferentialsPresheaf_restrict_along_identity_section`): closed (Step 3, iter-136). Uses two `pullbackComp` applications + an `eqToIso` bridge + final `rw [section_snd_eq_identity_struct]`. Reads cleanly.
  - L786–836 (`mulRight_globalises_cotangent` docstring): ~50 lines. Composition plan + status block (Step 1 / Step 2 / Step 3 status). Body is `sorry` (L848), waiting on Step 2 closure. Documentation matches the file's status. Honest scaffold.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (full-`Mathlib` import)
- **excuse-comments**: none
- **notes**:
  - L6: `import Mathlib`. The blanket import inflates rebuild times for the whole downstream chain. Should be narrowed to the actual `Mathlib.*` modules consumed (`Module.finrank` lives in `Mathlib.LinearAlgebra.Dimension.Finrank`; `Scheme`/`Spec`/`Over` in `Mathlib.AlgebraicGeometry.Scheme` + adjacents). **Minor** (not load-bearing on correctness; affects iter cycle time).
  - L40–43: one-liner body `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. This IS the honest mathematical definition; relies on `Module.finrank` returning 0 sensibly for infinite-dimensional carriers. Clean.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 minor (iter-073 cross-ref in the docstring at L188; the file does not have such old artefacts anymore)
- **suspect definitions**: none (sorries are honest scaffolds)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L13–53 file docstring: lists the two `sorry`-bodied scaffolds (`genusZeroWitness`, `positiveGenusWitness`) and the Forbidden Shortcut sanity check (`Jacobian C := 𝟙_ (Over (Spec (.of k)))` compiles but breaks `SmoothOfRelativeDimension (genus C)` for `genus C > 0`). This is excellent defensive documentation — explicitly warns future authors that a tempting wrong definition exists.
  - L132–140 (`geometricallyIrreducible_id_Spec`): small targeted helper, proof is clean.
  - L142–174 (`JacobianWitness` structure): bundles the universal-property data for an Albanese candidate uniformly over all choices of marked point. Docstring is precise.
  - L193–197 (`genusZeroWitness`): body `sorry` — honestly flagged.
  - L219–223 (`positiveGenusWitness`): body `sorry` — honestly flagged.
  - L249–254 (`nonempty_jacobianWitness`): the by_cases body delegating to the two scaffolds is the iter-135 honest restructure; no inline sorry here, just delegation. Clean.
  - L259–262 (`jacobianWitness`): `Classical.choice (nonempty_jacobianWitness C)` — standard `noncomputable def` pattern.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L14–29 file docstring: clean explanation of "iter-073 Phase E closes by reduction" via uniform `(jacobianWitness C).isAlbaneseFor P` projection. Honest about *what* moved (the sorry burden shifted to `nonempty_jacobianWitness` in `Jacobian.lean`), not project lying to itself.
  - L51–90 (three protected projections `ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp`): uniform structure — `letI`-load four implicit class instances from the witness, then call the corresponding `IsAlbanese.*` projection. Mechanical, clean.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L43–79 "Hypothesis history" block: extensive but justified — documents the **mathematical lesson** that point-wise topological equality on `U` is too weak (Frobenius counter-example) and why the hypothesis was strengthened to scheme-level equality. Not bookkeeping; this is content future readers will appreciate.
  - L91–121 (`Scheme.Over.ext_of_eqOnOpen`): the proof is a 4-step `haveI` chain that surfaces the `IrreducibleSpace`, `IsSeparated`, and `IsDominant` typeclass facts so that `ext_of_isDominant_of_isSeparated'` fires. Clean and honest.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L31–46 "Encoding choice" block: documents that the directive's offered Option A (literal `Spec MvPolynomial`) was mathematically wrong (affine ≠ projective line) and the refactor agent took Option B (abstract genus-0 curve). This is excellent self-aware project history.
  - L75–87 (`rigidity_over_kbar`): sorry — honestly flagged as iter-126 scaffold gated on the cotangent-vanishing pile.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L39–47: one-instance file. Body is a tight `haveI : PreservesLimitsOfSize := …` + `hasSheafCompose_of_preservesLimitsOfSize`. Closed cleanly.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 3 declarations, each a one-line term. Universe annotations are tracked in docstring (L43: `HasExt.{u+1}` is forced by the morphism universe). Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0–1 minor
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (deep iter-NN cross-references)
- **excuse-comments**: none
- **notes**:
  - Large file (~877 lines) with iter-005 → iter-053 incremental scaffolding. Heavy use of iter-NN markers in docstrings; readers in 30 iters will struggle to navigate the cross-references. **Minor** code-smell.
  - L57–115: `CategoryTheory.Functor.const_*`, `Adjunction.left/right_adjoint_linear`, `Adjunction.homLinearEquiv` — all marked as Mathlib gap-fills with clean derivations. Upstream-PR candidates.
  - L142–186 (`Scheme.toModuleKSheaf` helpers (1)–(5)): clean construction of the `k`-algebra structure on `Γ(C, U)` from the structure morphism.
  - L188–239 (`toModuleKPresheaf`, `toModuleKSheaf`): straight presheaf/sheaf construction; `map_id`/`map_comp` proofs reduce via `congrFun (congrArg (·.hom) (presheaf.map_id/comp …)) x` — standard pattern, clean.
  - L241–252 (`toModuleKSheaf_forgetCompare`): body `Iso.refl _` — probe-verified that the iter-006 and iter-004 sheaves agree on the nose at the underlying-presheaf level. This is a load-bearing `rfl`-witness for downstream interoperability.
  - L341–462 (`IsAffineHModuleVanishing`, `IsHModuleHomFinite`, `module_finite_*_curve`): the carrier-class + transport pattern. L462–486 contains the **valuable** "abandoned per-affine-open variant" historical note explaining why the original iter-041 approach was wrong (`Γ(U, O_C)` not finite for proper affine opens of curves). This is the kind of historical commentary that prevents reintroducing a fixed mistake.
  - L703–721 (`instIsHModuleHomFinite_toModuleKSheaf`): producer instance with all five steps numbered in the docstring. Body chains `Module.Finite.equiv (LE1.trans LE2).symm`. Clean.
  - L725–810: `Scheme.cechCochain_OC`, `cechCohomology_OC`, `cechCochain`, `cechCohomology`, `cechCochain_OC_eq`, `cechCohomology_OC_eq` — two parallel APIs (one for the structure sheaf, one parameterised over `F`) bridged via `rfl`. The parallel split is **deliberate** (per iter-047 docstring) since downstream comparison theorem is naturally parameterised; the `_eq` bridges show no semantic loss. Acceptable.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (multiple `set_option backward.isDefEq.respectTransparency false in`)
- **excuse-comments**: none
- **notes**:
  - L33–110 (`Abelian.Ext.chgUniv_add`, `_smul`, `chgUnivLinearEquiv`): three Mathlib gap-fills upgrading the bare-`Equiv` `chgUniv` to a `LinearEquiv`. Clean derivations referencing concrete Mathlib lemmas (`Ext.homEquiv_chgUniv` at file:L543–545, etc.). Upstream-PR candidates.
  - L354 + L523 + L539 + L565: `set_option backward.isDefEq.respectTransparency false in` is used 4 times to force the typeclass-search engine to unfold structure-literal projections. This is a kernel-option workaround that documents itself but is **fragile** — if Mathlib's transparency policy changes, these will silently fail. **Minor**.
  - L302–323 (`HModule'_shortComplex`): structure-literal mirror of Mathlib's `MayerVietorisSquare.shortComplex` for the `ModuleCat k` flavour; the iter-019 plan-agent probe-verified the field projections.
  - L341–346 (`ModuleCat_free_preservesMonomorphisms`): Mathlib gap-fill for the missing `(ModuleCat.free k).PreservesMonomorphisms` instance; chains `mono_iff_injective` ↔ `Finsupp.mapDomain_injective`. Clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (iter-NN dense cross-references)
- **excuse-comments**: none
- **notes**:
  - Cohort-2 file split out of the old `MayerVietoris.lean`. Heavy iter-NN cross-references in docstrings; same project-archeology smell as `StructureSheafModuleK.lean`. **Minor**.
  - L50–62 (`AffineCoverMVSquare`): clean structure bundling a 2-affine cover + intersection-affineness + cover-totality. Field docstrings are crisp.
  - L77–101: four `_X₁/_X₂/_X₃/_X₄` `@[simp]` corner-identifications; first three are `rfl`, the fourth `X₄ = ⊤` consumes the `cover` field. Clean.
  - L173–192 (`HModule'_top_sourceIso`): 3-step composite iso assembled from `yoneda.obj T ≅ const PUnit` + `constComp` + `finsuppUnique`. Probe-verified shape. Clean.
  - L215–240 (`HModule_top_linearEquiv` at universe `u+1`) and L264–288 (`HModule'_top_linearEquiv` at universe `u`): parallel constructions differing only in the universe of the Ext on the LHS. The duplication is intentional per the iter-032/iter-033 docstrings (universe alignment with `HModule'` vs `HModule`). Acceptable.
  - L300–308 (`HModule'_eq_HModule_linearEquiv`): composes the iter-033 universe-`u` form with the iter-034 `chgUnivLinearEquiv` universe shift. Single line. Clean.
  - L675–710 (`HasAffineCechAcyclicCover` class + `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` instance): typeclass-driven chain `[HasAffineCechAcyclicCover] → [IsAffineHModuleVanishing]`. The instance unpacks the existential and chains iter-052. Clean.

## Must-fix-this-iter

(none — see Major and discussion below for the closest call)

## Major

- `AlgebraicJacobian/Cotangent/GrpObj.lean:719–721` — `letI : IsIso (basechange_along_proj_two_inv G) := isIso_of_app_iso_module … (fun _ => sorry)` constructs an `IsIso` instance from `sorry` and returns `(asIso _).symm` as the named iso. Every downstream consumer of `relativeDifferentialsPresheaf_basechange_along_proj_two G` (the named iso) will silently propagate this sorry; `simp`-rewriting against this iso typechecks but is unsound. The docstring (L709–718) is honest about it being a "third concrete sub-piece" remaining and the L487 "Net change this iter" line explicitly tracks "1 hollow scaffold sorry → 3 narrowly-scoped concrete sorries". So this is honest scaffolding, not an excuse — but downstream `simp` users should be wary. Does **not** rise to must-fix because the declaration's docstring is explicit and the body is genuinely a scaffold with tracked sorry. Recommend a separate `theorem` carrying the `IsIso` claim explicitly (and itself `sorry`-bodied), so accidental `apply`/`simp` use against the iso becomes a more visible audit target.
- `AlgebraicJacobian/Genus.lean:6` — blanket `import Mathlib`. Should be narrowed; affects compile time across the whole project (Genus is imported by Jacobian, AbelJacobi, Rigidity, RigidityKbar). The downstream tax compounds.

## Minor

- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:354,523,539,565` — four uses of `set_option backward.isDefEq.respectTransparency false in` to compensate for typeclass-search struggles through structure-literal projections. Each is self-documenting; treat as fragile bridge.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` and `MayerVietorisCover.lean` — heavy iter-NN cross-references (`iter-027`, `iter-028`, …, `iter-053`) used as the dominant navigation idiom inside docstrings. In ~30 iters these become opaque; mention only the *latest* state + an `analogies/` pointer in long-lived files.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:36–67,116–161,297–327,428–451,465–525,786–836` — accumulated ~180 lines of proof-design analysis distributed across the file (slightly more than the directive's ~150 LOC estimate). **Re-confirming iter-140's defensive read**: these are proof-design analysis (Replacement (B) construction, Caveat on canonicity, piece-(i.b) decomposition + closure routes, three-sub-goal narrative), not excuse-comments. The risk is *not* that they hide wrong code; it is that future readers spend extra cycles navigating iter-128 → iter-142 archeology. Recommend a one-time consolidation pass once piece (i.b) closes: keep the mathematical content (caveats, design rationale, route comparisons), drop the iter-NN markers.
- `AlgebraicJacobian/Differentials.lean:135` — `refine … <;> first | exact … | exact …`. Direct two-prong `exact ⟨…, …⟩` would read more straightforwardly.

## Excuse-comments (always called out separately)

None found. All `sorry`-bodied declarations carry honest "status: iter-NNN scaffold, body `sorry`, closure plan: …" docstrings; the inline comment blocks around the residual sub-goals (notably the d_app L602–636 block) describe what was attempted, why standard tactics fail, and what construction is needed — proof-design analysis, not "this works for now".

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The iter-142 prover deliverable (d_map closure in `basechange_along_proj_two_inv_derivation` plus the d_app `change` skeleton) lands cleanly with no excuse-comments and no new wrong-code; the file's open work is honestly scaffolded with sorries tracked explicitly. The one durable concern is the IsIso-from-sorry pattern at `Cotangent/GrpObj.lean:719–721`, which is a known-scaffold rather than a freshly-introduced defect.
