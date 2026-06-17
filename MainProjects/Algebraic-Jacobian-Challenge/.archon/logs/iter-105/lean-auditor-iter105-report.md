# Lean Audit Report

## Slug
iter105

## Iteration
105

## Scope
- files audited: 16 (15 project sources + 1 reference)
- files skipped (per directive): 0

Audited files (project source):
1. `AlgebraicJacobian.lean` (15 lines, imports only)
2. `AlgebraicJacobian/AbelJacobi.lean` (94)
3. `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (1793)
4. `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` (629)
5. `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (713)
6. `AlgebraicJacobian/Cohomology/SheafCompose.lean` (49)
7. `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (63)
8. `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (931)
9. `AlgebraicJacobian/Differentials.lean` (879)
10. `AlgebraicJacobian/Genus.lean` (70)
11. `AlgebraicJacobian/Jacobian.lean` (225)
12. `AlgebraicJacobian/Modules/Monoidal.lean` (195)
13. `AlgebraicJacobian/Picard/Functor.lean` (192)
14. `AlgebraicJacobian/Picard/FunctorAb.lean` (116)
15. `AlgebraicJacobian/Picard/LineBundle.lean` (153)
16. `AlgebraicJacobian/Rigidity.lean` (114)

Read-only reference (not subject to project rules):
- `references/challenge.lean` (109) — the unchanged baseline `sorry`-skeleton; not audited.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import re-export. Nothing to flag.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project from `(jacobianWitness C).isAlbaneseFor P`. Honest delegation, no sorries here; the load-bearing existence is in `Jacobian.lean:nonempty_jacobianWitness`.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: 0 critical (iter-104 stale "Body left as sorry" docstrings have been cleaned — grep for "Body left as" returns nothing)
- **suspect definitions**: none
- **dead-end proofs**: none — all sorries are at sites the directive flags as long-standing deferred + the active-prover target
- **bad practices**: see notes (residual iter-XXX scaffolding comments throughout the file)
- **excuse-comments**: none meeting the must-fix bar after re-reading per directive
- **notes**:
  - L1115–1117 — `cechCofaceMap_pi_smul` partial-scaffold comment ("iter-107 option 3 PARTIAL: iter-104 R-linearity staged in scope as `h_iter104`; full closure blocked by smul + eqToHom bridge"). Per directive, the sorry at L1120 is the active prover target; this comment is honest in-flight status (specific technical blocker named, helper lemma `cechCofaceMap_summand_family_R_linear` is concretely staged at L1119). Not an excuse-comment.
  - L605-637 — `cechCofaceMap_summand_family'` plus `cechCofaceMap_summand_family'_R_linear` (iter-105 wrappers) are new this iter; docstrings are accurate.
  - Multiple `set_option maxHeartbeats <large>` (e.g. 800000 at L1128, 1600000 at L908, 12800000 implied) — heartbeat-budget bumps are justified inline. Acceptable but a long-term refactor target.
  - Several iteration-history scaffolding comments (e.g. L1037–1051, L1093–1108, L1234–1417, L1700–1755) preserved verbatim across iters. Helpful for the active prover but accumulate noise; should be triaged once the corresponding sorry is closed.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Mathlib gap-fills (`Abelian.Ext.chgUnivLinearEquiv`, `Functor.const_additive`/`_linear`, `Adjunction.left_adjoint_linear`/`right_adjoint_linear`/`homLinearEquiv`, `ModuleCat_free_isLeftAdjoint`, `ModuleCat_free_preservesMonomorphisms`) are documented as "Mathlib doesn't yet expose this for `ModuleCat`, only `AddCommGrpCat`" and are bridges, not parallel-API duplication.
  - `HModule'_*` declarations are explicit `ModuleCat`-flavoured mirrors of Mathlib's `AddCommGrpCat`-only Mayer-Vietoris API. The docstrings cite the Mathlib lines being mirrored, so the parallel API is justified. Long-term: upstream candidate (see Major below).

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Bundled `AffineCoverMVSquare`, curve specialisations, and `IsCechAcyclicCover` / `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` infrastructure are all closed. Comments are accurate.
  - L506-507 — references `propext, Classical.choice, Quot.sound` as Lean's standard kernel axiom set, not a project-local axiom; correct.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single `instance instHasSheafCompose_forget_CommRing_AddCommGrp` is honestly closed; docstring is accurate.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three declarations all closed (`instHasSheafify_Opens_AddCommGrp`, `instHasExt_Sheaf_Opens_AddCommGrp`, `toAbSheaf`). Docstring at L18-22 ("All three declarations are honestly closed by the iter-004 multilane prover round") is accurate.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 1 — file-status docstring lies about progress
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 0 (but see the stale status block below)
- **notes**:
  - L27-31 — **Stale status docstring**: `"## Status (iteration 006 — refactor scaffold) … The eight Phase A step 5 main declarations are scaffolded as `sorry`. The iter-006 prover round is responsible for filling them."` All eight Phase-A-step-5 declarations are honestly filled in the current file (`kToSection`, `algebraSection`, `algebraMap_eq_kToSection`, `kToSection_naturality`, `algebraMap_naturality`, `toModuleKPresheaf`, `toModuleKPresheaf_isSheaf`, `toModuleKSheaf`). The status block was never updated after closure. Flag in Major.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 1 — file-status docstring under-reports closure progress
- **suspect definitions**: none
- **dead-end proofs**: none (sorries at L122/L636/L718/L735/L877 are long-standing deferred sites the directive instructs not to flag; comment blocks surrounding them are accurate status, not excuse-comments)
- **bad practices**: none
- **excuse-comments**: 0
- **notes**:
  - L27-30 — **Stale status docstring**: `"## Status (iteration 064 — scaffold)\n\nAll main declarations have `sorry` bodies. Closure trajectory is estimated at ~10 iterations per `STRATEGY.md`."` Many declarations are now closed (`cotangentExactSeqAlpha`, `cotangentExactSeqBeta_hη`, `cotangentExactSeqBeta`, `cotangentExactSeq_structure.h_zero`, `cotangentExactSeq_structure.h_epi`, `cotangent_exact_sequence`, the entire `moduleKPresheafOfModules` chain L741-861). Flag in Major.
  - Iter-104 lean-auditor flagged "Body left as 'sorry' for iter-XXX prover" docstrings at L488 / L760 / L823 / L871. Verified: these have all been removed or rewritten with accurate prose. L488 is now `@[simp]` on a closed lemma; L760 is inside a closed proof body; L823 is inside the closed `moduleKPresheafOfModules` docstring; L871 is the `serre_duality_genus` docstring referring to honest dimension-one Serre-duality content. **All four prior stale docstrings are resolved.**
  - Iter-104 lean-auditor also flagged "large dead-code block at L675–L912." The current file ends at L879 and the L675+ range is the closed `cotangent_exact_sequence` theorem plus the `smooth_iff_locally_free_omega`, `cotangent_at_section`, `moduleKPresheafOfModules_*`, and `serre_duality_genus` declarations — all live code, no dead block. **Resolved.**
  - L633-636 — `h_exact` deferred-route comment with sorry is accurate status, not excuse.
  - L692 — comment "eliminating the iter-064/065 nested `by sorry` placeholder inside `ShortComplex.mk`" — accurate history, not stale.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1 — large commented-out sketch block
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 0
- **notes**:
  - L39-61 — commented-out "Sketch of the route once Phase A is available" with embedded `sorry⟩` placeholder text. The iter-011 closure made this archeological. Minor; should be removed.
  - `genus` itself (L65-68) is honestly defined as `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` — the standard $\dim_k H^1(C, \mathcal{O}_C)$ definition. Protected declaration (per `archon-protected.yaml`); signature is correct.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 — `nonempty_jacobianWitness := sorry` at L179, but this is the designed Phase-C single-sorry pattern, not a defect (see notes)
- **bad practices**: none
- **excuse-comments**: 0 (the docstring at L165-175 honestly names the deferral)
- **notes**:
  - `Jacobian C := (jacobianWitness C).J` (L199-201) projects from `Classical.choice (nonempty_jacobianWitness C)`. The single sorry at L179 is load-bearing in the sense that ALL Phase-C content depends on it, but it represents a real mathematical theorem (existence of the Albanese variety of a smooth proper geometrically irreducible curve) explicitly deferred per the project's iter-073 refactor. The "forbidden shortcut" sanity-check block (L30-38) actively guards against substituting a wrong terminal-object definition. This is well-disciplined deferral, not an excuse.
  - The four protected instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) all project from the witness. Signatures match `archon-protected.yaml`.

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: 0
- **suspect definitions**: 1 — `instIsMonoidal_W` (instance with `sorry` body, see below)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1 — L100-165 docstring of `instIsMonoidal_W`
- **notes**:
  - L166-173 — **`noncomputable instance instIsMonoidal_W : (W X).IsMonoidal := by ... sorry`**. This is a **`sorry`-bodied instance**, not a theorem. The 60+ line preceding docstring is an extended excuse: "Marked sorry until the upstream gap … is filled" / "no project-local helper lemma may be introduced to bridge it" / "this sorry does NOT block downstream consumers".
  - **The "does not block downstream consumers" claim is incorrect.** The same file's L183-186 `instMonoidalCategoryStruct` and L190-193 `instMonoidalCategory` are defined as `inferInstanceAs (MonoidalCategoryStruct (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))`. Lean's `LocalizedMonoidal _ _ _` requires `(W X).IsMonoidal` to provide the monoidal structure, so the project's `MonoidalCategory X.Modules` instance is synthesised via `instIsMonoidal_W`. Any proof using the monoidal structure on `X.Modules` therefore transitively depends on the `sorry` body of `instIsMonoidal_W`. This is a load-bearing sorry on an `instance`. Flag at must-fix.

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: none
- **suspect definitions**: 1 — `PicardFunctor.representable` is `:= sorry` (L190); see notes
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1 — the file docstring's "Forward-compatibility note" at L29-36
- **notes**:
  - L184-190 — `theorem PicardFunctor.representable ... := sorry`. The file's docstring (L26-36) says: "PicardFunctor.representable is intentionally left as sorry … Closing `representable` on top of this approximation would silently assert representability of the wrong functor and is therefore a forbidden shortcut: keep it as `sorry`." This is the *correct* response GIVEN the upstream wrongness in `LineBundle`. The excuse-comment is acknowledging that the root issue is the LineBundle definition (see LineBundle.lean must-fix), not creating a new wrongness. Documentation, not coverup. List at Major (it documents the dependency cleanly).
  - `PicardFunctor` itself (L158-174) and `fiberMap`/`quotMap` (L67-142) are honestly built on top of `LineBundle X` and `Pic.pullback`. They inherit whatever correctness `LineBundle` has — currently the global-sections approximation.

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three closed declarations (`PicardFunctorAb`, `PicardFunctorAb.forgetCompare`, `PicardFunctorAb.etaleSheafified`). Same caveat as `Functor.lean`: built on `LineBundle` which is currently the global-sections approximation. The wrongness is upstream, not here.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: 0
- **suspect definitions**: 1 — `LineBundle` itself, see below
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1 — the entire status / forward-compatibility block at L17-61 and the docstring at L71-84
- **notes**:
  - L85-86 — **`def LineBundle (X : Scheme.{u}) : Type u := CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))`**. This is the iter-104 critical finding STILL UNFIXED. The docstring explicitly admits:
    - L36 "we adopt a *first-approximation* definition"
    - L46-52 "For non-affine schemes this is the image of the natural map `CommRing.Pic Γ(X, ⊤) → Pic(X)` (the line bundles with a global trivialisation of their structure-sheaf component) and is therefore **a strict subgroup of the true Picard group (e.g. it is trivial for projective space whereas the true Pic is `ℤ`)**."
    - L83 "is a genuine, non-vacuous *stand-in* that suffices to set up the type theory needed by `Jacobian.lean`."
  - These are textbook "Weakened-wrong definition" + "stand-in definition until we figure out the right one" excuse-comments per the auditor descriptor's must-fix list. The wrong definition propagates to `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, and the deferred `PicardFunctor.representable` (which is honestly `sorry`'d because closing it on this stand-in would compound the wrongness). The mathematician's docstring is the audit's smoking gun: the author KNOWS the definition is wrong. Flag at must-fix.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 1 — file-status docstring lies about closure
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 0 (but the stale status reads as one — see notes)
- **notes**:
  - L19-23 — **Stale status docstring**: `"## Status (iteration 002 — refactor scaffold)\n\nThis file is a scaffold. The body of `eq_of_eqOnOpen` is `sorry`. Subsequent prover iterations are responsible for filling this sorry (Phase E of `STRATEGY.md`)."` The body of `eq_of_eqOnOpen` (L88-112) is a clean ~25-line proof using `IsProper.toIsSeparated`, `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `Scheme.PartialMap.Opens.isDominant_ι`, and `ext_of_isDominant_of_isSeparated'`. The status is **at least 80+ iterations out of date**. Flag in Major.
  - The "Hypothesis correction (iter 003 prover)" block at L36-68 is accurate technical record of the strengthening from topological-equality to scheme-level-equality, explaining the addition of `[IsReduced X.left]`. Useful documentation, not stale.

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/LineBundle.lean:85-86` — **Weakened-wrong definition** `def LineBundle (X : Scheme.{u}) : Type u := CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))`. The author's own docstring (L46-52) admits this is "a strict subgroup of the true Picard group (e.g. it is trivial for projective space whereas the true Pic is `ℤ`)" — i.e. the definition is mathematically wrong on the central use case the project targets (smooth proper curves of positive genus are not affine). Why must-fix: a wrong `def` masquerading under the standard name `LineBundle` propagates to `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, and ultimately the existence claim `nonempty_jacobianWitness`; any "honest closure" using these names is asserting something different from what readers will believe.
- `AlgebraicJacobian/Modules/Monoidal.lean:166-173` — **`noncomputable instance instIsMonoidal_W : (W X).IsMonoidal := by … sorry`**, a load-bearing **instance** with `sorry` body. The 60+ line preceding docstring explicitly markets this as "Marked sorry until the upstream gap is filled" and claims "no consumers in the project" — but the same file's `instMonoidalCategoryStruct` (L183) and `instMonoidalCategory` (L190) consume `(W X).IsMonoidal` via `LocalizedMonoidal`'s instance signature. The project's `MonoidalCategory X.Modules` therefore transitively depends on the `sorry` body. Why must-fix: sorries on `instance` declarations leak into typeclass-synthesised proofs without flagging at the consumer; this is exactly the "Suspect bodies on substantive claims" entry from the auditor descriptor.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:27-31` — **Stale status block** claims "The eight Phase A step 5 main declarations are scaffolded as `sorry`. The iter-006 prover round is responsible for filling them." All eight are closed. Why must-fix: the block actively misleads future readers about the file's state and runs counter to the iter-005/006 closure that actually happened ~100 iterations ago.
- `AlgebraicJacobian/Rigidity.lean:19-23` — **Stale status block** claims `eq_of_eqOnOpen` body is `sorry`. The body is a closed ~25-line proof. Why must-fix: same pattern — the block lies about the file's state to a depth of 80+ iterations.

## Major

- `AlgebraicJacobian/Differentials.lean:27-31` — Stale status block: "All main declarations have `sorry` bodies. Closure trajectory is estimated at ~10 iterations." Many declarations are closed (cotangentExactSeqAlpha, cotangentExactSeqBeta_hη, cotangentExactSeqBeta, cotangent_exact_sequence, moduleKPresheafOfModules*); only 5 sorries remain (`relativeDifferentialsPresheaf_isSheaf` at L122, `h_exact` at L636, `smooth_iff_locally_free_omega` at L718, `cotangent_at_section` at L735, `serre_duality_genus` at L877). Update to reflect actual progress.
- `AlgebraicJacobian/Picard/Functor.lean:26-36, 181-185` — File docstring and `representable` docstring frankly admit "PicardFunctor.representable is intentionally left as sorry — Closing `representable` on top of this approximation would silently assert representability of the wrong functor and is therefore a forbidden shortcut: keep it as `sorry`." The sorry IS the correct response given the upstream `LineBundle` wrongness, so this is documentation, not an excuse. But the documentation must be kept in lockstep with the LineBundle fix: as soon as LineBundle is replaced with the invertible-sheaf definition, this sorry's "intentional" framing also needs to be lifted.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` — `HModule'_*` parallel-API of Mathlib's `MayerVietorisSquare`/`MayerVietoris` Ext-LES infrastructure. Mathlib only has the `AddCommGrpCat.free`-flavored versions; the project mirrors them with `ModuleCat.free k`. Real Mathlib gap (filed inline as `ModuleCat_free_isLeftAdjoint`, `ModuleCat_free_preservesMonomorphisms` gap-fill instances). Long-term: upstream candidate; short-term: acceptable bridge code, but the duplication will accumulate maintenance cost.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1115-1117` — comment "iter-107 option 3 PARTIAL: iter-104 R-linearity staged in scope as `h_iter104`; full closure blocked by smul + eqToHom bridge". Per directive, the L1120 sorry is the active prover target — flagging the comment block only. The comment is accurate in-flight status (specific technical blocker named, helper lemma concretely staged), not a "will fix later" excuse. Borderline; leaving as major-status-comment.

## Minor

- `AlgebraicJacobian/Genus.lean:39-61` — large commented-out "Sketch of the route once Phase A is available" block with embedded `sorry⟩` placeholder text. The iter-011 closure made the sketch archeological. Remove.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — many iter-XXX scaffolding comments preserved verbatim across iters (e.g. L1037-1051, L1093-1108, L1234-1417, L1700-1755). Useful for the active prover, but accumulate as noise post-closure. Triage when each enclosing sorry closes.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — many `set_option maxHeartbeats <large>` (800000 at L1128, 1600000 at L908, etc.). Each is justified inline by the named scaffold, but the budget bumps will need a profile-and-shrink pass once the proofs stabilise.
- `AlgebraicJacobian/Differentials.lean:633-636, 692` — accurate historical/status comments around the `h_exact` sorry and the `cotangent_exact_sequence` packaging. Not stale, but verbose. Optional cleanup.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/LineBundle.lean:17-61, 71-84`: the entire file-status block + `def LineBundle` docstring are an extended excuse for a "first-approximation" definition that the author explicitly knows is mathematically wrong on non-affine schemes ("trivial for projective space whereas the true Pic is `ℤ`"). Attached to a load-bearing definition consumed by Picard.Functor, Picard.FunctorAb, and (via the deferred-`sorry`) the Phase-C Jacobian existence. Severity: **critical**.
- `AlgebraicJacobian/Modules/Monoidal.lean:100-165`: extended docstring on `instIsMonoidal_W` markets the `sorry` body as "Marked sorry until the upstream gap is filled" while wrongly claiming "no consumers in the project". The instance is consumed transitively by `instMonoidalCategoryStruct` / `instMonoidalCategory` in the same file. Severity: **critical**.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:27-31`: stale status block lying that eight closed declarations are still `sorry`. Severity: **major** (per the must-fix rule, classify higher when in doubt — promoted to must-fix above).
- `AlgebraicJacobian/Rigidity.lean:19-23`: stale status block lying that a closed proof is `sorry`. Severity: **major** (promoted to must-fix above).

(`Picard/Functor.lean:26-36, 181-185`'s "intentionally left as sorry" comment is **not** an excuse-comment in the usual sense — it's an honest admission that closing `representable` on top of a wrong `LineBundle` would compound the wrongness. Listed in Major as documentation that must move when the LineBundle issue is fixed.)

## Severity summary

- **must-fix-this-iter**: 4 — LineBundle weakened-wrong def (LineBundle.lean:85-86); sorry-bodied instance (Monoidal.lean:166-173); stale status docstrings actively lying about closure (StructureSheafModuleK.lean:27-31, Rigidity.lean:19-23).
- **major**: 4 — Differentials status staleness; Picard/Functor "intentionally sorry" doc dependency; MayerVietorisCore parallel-API; BasicOpenCech active-prover scaffold comment.
- **minor**: 4 — Genus dead-code sketch; BasicOpenCech accumulating iter-history comments; heartbeat-budget bumps; verbose status comments in Differentials.
- **excuse-comments**: 4 (two critical, two stale-status — all already counted under must-fix-this-iter above; called out separately because they document the project lying to itself).

Overall verdict: The iter-104 critical findings on `LineBundle` (weakened-wrong def) and `instIsMonoidal_W` (sorry on an instance, falsely advertised as not blocking consumers) **still stand uncorrected**, and two new stale-status docstrings (StructureSheafModuleK and Rigidity) actively misrepresent closed declarations as `sorry`; the new iter-105 partial scaffold around L1119 in BasicOpenCech is honest in-flight status and the previously-flagged Differentials L488/L760/L823/L871 stale docstrings + dead-code block have been cleaned, but the load-bearing wrongness flagged at iter-104 has not.
