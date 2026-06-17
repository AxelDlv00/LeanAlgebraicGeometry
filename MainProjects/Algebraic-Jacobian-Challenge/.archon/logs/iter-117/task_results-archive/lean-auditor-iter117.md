# Lean Audit Report

## Slug

iter117

## Iteration

117

## Scope

- files audited: 16
- files skipped (per directive): 1 — `references/challenge.lean` (placeholder by design)

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Umbrella module: 15 `import`s, no declarations.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) are honest projections from `(jacobianWitness C).isAlbaneseFor P`. No sorries here; sorry is concentrated upstream in `Jacobian.nonempty_jacobianWitness`.
  - Status docstring (L14–28) accurately describes the current reduction-to-witness shape.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 6 known inline sorries (L1120, L1212, L1536, L1564, L1754, L1846), all on statements that are mathematically true under the stated hypotheses (Stacks 01ED Čech-acyclicity, R-linearity of a Čech differential, finite-product/localisation-commutation).
  - L909–921 explicitly documents an earlier abstraction (iter-087) that was "mathematically false for arbitrary `scK₀_f`" and has been **replaced** by the current corrective `cechCofaceMap_pi_smul` specialised to the project's Čech-cochain context. This is a fixed-and-replaced false signature, not a current issue — flagged here so reviewers know the prior history is acknowledged.
  - `set_option maxHeartbeats 1600000`/`800000` lifts are present at L908, L1128, L736, L908 (heartbeats budget overrun for elaboration of let-blocks). All are local `in`-form, not file-wide. Not a smell given the file's scale.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Mathlib gap-fills `Functor.const_additive`, `Functor.const_linear`, `Adjunction.left_adjoint_linear`, `Adjunction.right_adjoint_linear`, `Adjunction.homLinearEquiv` (top of file) and `Abelian.Ext.chgUniv_add`/`_smul`/`chgUnivLinearEquiv` are all honestly closed.
  - MV LES core (`HModule'_*`) is fully closed end-to-end.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Classical.choice` is used legitimately at L516 to extract the comparison iso from `HasCechToHModuleIso.nonempty_compIso`; the surrounding comment (L504–507) accurately notes it adds no new axioms (only the kernel-standard `propext / Classical.choice / Quot.sound`).
  - `AffineCoverMVSquare` structure (L52–64) bundles the 2-affine cover hypotheses cleanly.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single instance fully closed.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three declarations closed.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Producer instance `instIsHModuleHomFinite_toModuleKSheaf` (L765) chains iter-044 Stein-finiteness + iter-045/046 linear-equiv bridges into a typeclass-driven finiteness witness for the structure-sheaf-as-`ModuleCat k`. Honestly closed end-to-end.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor (statement-shape, see notes)
- **excuse-comments**: none
- **notes**:
  - 5 known inline sorries (L191/233, L737/856, L931/938, L947/955, L1091/1097). All on statements that are mathematically true under the stated hypotheses:
    * `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` — Kähler differentials commute with localisation.
    * `cotangentExactSeq_structure` `h_exact` branch — exactness of `f^*Ω_{Y/S} → Ω_{X/S} → Ω_{X/Y}` follows from `KaehlerDifferential.exact_mapBaseChange_map` glued affine-locally.
    * `smooth_iff_locally_free_omega` — standard characterisation of smoothness for finitely-presented morphisms.
    * `cotangent_at_section` — standard local-freeness of the pullback differential at a section.
    * `serre_duality_genus` — dim $H^0(C, \Omega_{C/k})$ = dim $H^1(C, \mathcal O_C)$ on a smooth proper integral curve.
  - Substantial inline helper bodies (`cotangentExactSeqAlpha`, `cotangentExactSeqBeta`, `cotangentExactSeqBeta_hη`, `cotangentExactSeq_structure` h_zero / h_epi, the `moduleKPresheafOfModules` family) are honestly closed.
  - **Minor — statement shape.** `serre_duality_genus` (L1091) uses `Module.rank k (...)` (Cardinal-valued) on both sides rather than `Module.finrank k (...)` (ℕ-valued). The statement is mathematically true either way, but `genus C : ℕ` (Genus.lean) is defined via `Module.finrank`, so the natural composition into the genus identity downstream would use `Module.finrank` to avoid a Cardinal↔ℕ bridge. Not blocking; recording as a small naming/finiteness opportunity.
  - The 2 deprecation warnings on L933/L950 (`IsSmoothOfRelativeDimension`) and the L846 line-length linter are explicitly listed in the directive as known and are not re-reported.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` — honest definition of dim_k H^1(C, O_C). Marked `noncomputable` correctly.
  - The L39–61 block-comment "Sketch of the route once Phase A is available" is a historical sketch of an alternative `OXAsAddCommGrpSheaf` route that is no longer used; the live route goes through `Scheme.toModuleKSheaf`. The comment is non-actionable and labelled "Sketch"; not stale enough to flag as outdated since it documents the abandoned alternative for archaeological context.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 known inline sorry (`nonempty_jacobianWitness`, L179). Mathematically true under the stated hypotheses (Albanese variety of a smooth proper geometrically irreducible curve; classically constructed via symmetric powers + Abel-Jacobi).
  - L30–38 "Forbidden shortcut (sanity check)" comment explicitly discusses why a wrong shortcut (`Jacobian C := 𝟙_ _`) would fail. This is **documentation of a counterexample**, not an excuse-comment for the current code; the current `Jacobian C := (jacobianWitness C).J` is the correct witness-based definition.
  - All four `Jacobian` instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) are honest projections from the witness. `Classical.choice` usage at L187 in `jacobianWitness` is the standard `Nonempty → choice` extraction.

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 known inline sorry (`instIsMonoidal_W`, L173). The statement (`(W X).IsMonoidal`) is mathematically true: sheafification is monoidal because the inverted-by-sheafification class is stable under tensor product. Documented in detail at L100–165 as a Mathlib gap awaiting closure (no project-local bridge per user policy 2026-05-11).
  - The L161–165 note: closure of this sorry "does NOT block downstream consumers" of `MonoidalCategory X.Modules` (which is fully built via `LocalizedMonoidal`). The instance is preserved as a future Mathlib refresh hook.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 known inline sorry (`PicardFunctor.representable`, L181). The statement is the classical FGA representability for the relative Picard functor — mathematically true; honestly deferred.
  - `PicardFunctor C` body (L149–165) is fully closed: cokernel of pullback along projection, via `QuotientGroup.lift` / `QuotientGroup.mk'`. Functoriality discharged via `PicardFunctor.quotMap_id` / `_comp`.
  - Source-category discussion (L30–40) honestly explains the choice `(Over (Spec k))ᵒᵖ` vs. raw `Schemeᵒᵖ`.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `PicardFunctorAb`, `forgetCompare`, the `_forget_obj` simp lemma, and `etaleSheafified` all honestly closed.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 2 known inline sorries on `noncomputable def` bodies (L82 `SheafOfModules.pullback_tensorObj`, L96 `SheafOfModules.pullback_oneIso`). Both define a canonical iso whose existence is mathematically standard (pullback functor is monoidal); the body is `sorry` only because Mathlib b80f227 does not yet register `Functor.Monoidal (SheafOfModules.pullback _)`. The signatures correctly name the tensor-preservation and unit-preservation isos of the pullback functor — these are **not** stand-in placeholders; they are well-defined data isomorphisms whose canonical construction is awaited from Mathlib.
  - `LineBundle X := (Skeleton X.Modules)ˣ` (L52). This is the iter-077+ refactor target replacing the older `CommRing.Pic Γ(X, ⊤)` global-sections approximation. The definition mirrors the ring-side `CommRing.Pic` idiom and matches the standard categorical Picard-group construction (units of the symmetric monoidal skeleton). Not a placeholder.
  - `Pic.pullback` (L108), `Pic.pullback_id` (L131), `Pic.pullback_comp` (L147) all honestly closed (modulo the two sorry-bodied iso defs above).

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `GrpObj.eq_of_eqOnOpen` honestly closed via `ext_of_isDominant_of_isSeparated'` + dominant-open-immersion + `IsProper.toIsSeparated`.
  - L39–69 "Hypothesis correction (iter 003 prover)" comment block honestly documents the **strengthening of the hypothesis from point-wise to scheme-level equality on U**, with the explicit Frobenius counter-example showing why the point-wise form is false in characteristic p. This is a **defensible signature correction**, not a weakened-wrong def. The unused `[GrpObj X]`, `[GrpObj Y]`, etc. instance arguments are explicitly retained as forward-compatibility scaffolding (acknowledged as redundant with the strengthened hypothesis) — could be cleaned up later, but harmless.

## Must-fix-this-iter

None. After auditing the 16 inline sorry sites identified in the directive plus the surrounding signatures, **no declaration carries a mathematically false statement**, **no `def := <stand-in>` body**, **no `axiom` declaration**, and **no excuse-comments** (`-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`, `-- will fix later`) on any active code. All sorries are on true mathematical claims awaiting closure.

## Major

None.

## Minor

- `AlgebraicJacobian/Differentials.lean:1094` — `serre_duality_genus` uses `Module.rank k (...)` (Cardinal-valued) on both sides. The statement is mathematically true, but downstream `genus C : ℕ` (Genus.lean) uses `Module.finrank` (ℕ-valued); a future polish step could restate this lemma in `Module.finrank` form to avoid a Cardinal↔ℕ bridge when chaining the two.
- `AlgebraicJacobian/Rigidity.lean:80–86` — the `[GrpObj X]`, `[GrpObj Y]`, `[SmoothOfRelativeDimension n X.hom]`, `[SmoothOfRelativeDimension m Y.hom]`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]` instance arguments are explicitly noted as **redundant** with the strengthened hypothesis (L60–67 of the docstring), but kept for forward-compatibility with the informal Mumford-rigidity statement. Could be slimmed at a later cleanup pass.
- `AlgebraicJacobian/Genus.lean:39–61` — block-comment "Sketch of the route once Phase A is available" describes an abandoned alternative route via `OXAsAddCommGrpSheaf`. The live route is `Scheme.toModuleKSheaf`. The sketch is labelled non-actionable; consider deleting at a later cleanup pass.

## Excuse-comments (always called out separately)

None found. Grep over `wrong | placeholder | temporary | TODO | fix.*later | will fix | stand-in | hack | workaround | stub` across `AlgebraicJacobian/` produced:
- `Jacobian.lean:35` — "is mathematically wrong" (describing a *forbidden* counterexample, not the current definition).
- `Differentials.lean:912` — "nested `by sorry` placeholder" (describing a *removed* prior placeholder).
- `BasicOpenCech.lean:1050,1073` — uses of the word "placeholder" referring to Miller-pattern unification slots, not code-quality placeholders.

No excuse-comments on any active declaration.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: the project is mathematically honest — every sorry site corresponds to a true statement awaiting closure, no axioms, no stand-in definitions, no excuse-comments on active code.
