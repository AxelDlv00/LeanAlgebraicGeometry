# Lean Audit Report

## Slug
quot-iter044

## Iteration
044

## Scope
- files audited: 8
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 126, 165, 201, 228: four `sorry` bodies on `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. All four are explicitly documented as "iter-177+ file-skeleton" placeholders with clear descriptions of what the body should do. Not alarm-worthy; honest stubs waiting on infrastructure (`χ` of coherent sheaf, Snapper's Lemma). The "iter-177" label is from the upstream repo of origin — no confusion, since the docstrings name both iter-176 (skeleton state) and iter-177+ (fill-in state).
  - Lines 2560–2564: `overRestrictUnitIsoInv` — correct. Transports `(overRestrictUnitIso V).symm` through the inverse functor and collapses the round-trip via `unitIso.symm.app`. Type trace: `inverse.obj (unit V.ringCatSheaf) ≅ unit (X.ringCatSheaf.over V)`. ✓
  - Lines 2572–2578: `overRestrictPresentationInv` — correct three-step chain: `ofIsIso` across `(overRestrictPullbackIso V M).inv`, then `Presentation.map` along the inverse functor with `overRestrictUnitIsoInv V`, then `ofIsIso` across the equivalence unit-iso. The `.{u}` universe annotations match the forward direction at lines 1097–1098. ✓
  - Lines 2586–2595: `pullbackOpenImmersionUnitIso` — correct. Route: `IsOpenImmersion → isOpenEmbedding.isOpenMap → IsOpenMap.adjunction → IsRightAdjoint (Opens.map k.base) → Final → asIso (pullbackObjUnitToUnit)`. All steps are logically chained; `inferInstance` at line 2594 synthesizes `IsRightAdjoint (pushforward k.toRingCatSheafHom)` from `IsOpenImmersion`. ✓
  - Lines 2603–2612: `pullbackPreimageιIso` — clean pseudofunctoriality assembly: `pullbackComp ≪≫ pullbackCongr ≪≫ pullbackComp.symm`. Correct. ✓
  - Lines 2614–2639: `presentationPullbackιPreimage` — heartbeat settings (`maxHeartbeats 2000000`, `synthInstance.maxHeartbeats 800000`, `backward.isDefEq.respectTransparency false`) consistent with the same pattern at lines 1100–1102 and 1163–1165. The `delta Scheme.Hom.resLE; infer_instance` route for `hk : IsOpenImmersion (g.resLE ...)` is the expected tactic for unfolding a definition before instance search. `PreservesColimitsOfSize` via `leftAdjoint_preservesColimits` is standard. The two-step `ofIsIso`/`map` chain is structurally identical to `overRestrictPresentationInv`. ✓
  - Lines 2649–2653: `isQuasicoherent_over_preimage` — direct application of `overRestrictPresentationInv` + `presentationPullbackιPreimage` + `Presentation.isQuasicoherent`. Clean. ✓
  - Lines 2660–2671: `coversTop_preimage` — covering proof. Uses `q.coversTop` to find a cover element, maps back through `g.base`, uses `Sieve.mem_ofObjects_iff`. Correct. ✓
  - Lines 2673–2691: `isQuasicoherent_pullback_of_isOpenImmersion` — `q.shrink` is correctly applied (required for `of_coversTop` universe compatibility, as documented in project memory). `qs` is used consistently throughout. ✓
  - Lines 2693–2701: `isQuasicoherent_pullback_fromSpec` — one-liner reduction of the preceding to the `hU.fromSpec` case. Correct. ✓
  - Lines 2709–2716: `isLocalizedModule_basicOpen` — gap2 keystone. Chain: `isQuasicoherent_pullback_fromSpec M hU` (Piece A) → `isIso_fromTildeΓ_of_isQuasicoherent` (gap1) → `isLocalizedModule_basicOpen_of_hP1 M hU … f` (Piece B eqToHom bridge). All three inputs are axiom-clean in this file. The `[Module Γ(X, U) Γ(M, X.basicOpen f)]` and `[IsScalarTower ...]` instance arguments match `restrictBasicOpenₗ`'s signature (lines 2267–2277). ✓
  - No `eqToHom`/`Subsingleton.elim` shortcuts found in any of the 11 new declarations.
  - The dot-notation `.IsQuasicoherent` is used correctly in theorem conclusions (`isQuasicoherent_over_preimage`, `isQuasicoherent_pullback_of_isOpenImmersion`).

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 1 flagged (MINOR — status comments at lines ~1808–1811 reference "iter-039" and "iter-041" for work that is confirmed done; at iter-044 these are accurate history but could be pruned)
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (MINOR — `adjL`/`hunitL` at lines 1870–1880 are local definitions in the body of a `sorry`-closed proof; they type-check and encode verified structure but are not syntactically consumed by the `sorry` tactic)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 1891, 2358, 2539, 2561: four active `sorry` bodies. Each is accounted for:
    - Line 1891 (`base_change_mate_fstar_reindex_legs_conj`): the remaining `_legs_conj` crux (the "7-iter" cross-layer core). Documented extensively.
    - Line 2358 (`base_change_mate_gstar_counit_transport`): the counit transport crux. Documented.
    - Line 2539 (`affineBaseChange_pushforward_iso`): affine reduction compatibility (naturality of adjunction transpose + pushforward-restriction commutation). Documented.
    - Line 2561 (`flatBaseChange_pushforward_isIso`): outer shell pending Čech-cohomology infrastructure. Documented.
  - Lines 1862–1880: `adjL`/`hunitL` scaffolding. The comment explicitly says "iter-044 VERIFIED SCAFFOLDING (baked in; type-checks & proves)". Both `adjL` and `hunitL` type-check correctly:
    - `adjL = (tilde.adjunction (R := A)).comp (pullbackPushforwardAdjunction (e.hom ≫ Spec.map inclA))` — depth-2 composite adjunction, same depth as `conj-2d`.
    - `hunitL` splits `adjL.unit.app M` via `Adjunction.comp_unit_app` + `rfl`, giving the tilde–Γ_A unit followed by the `g'`-unit under `moduleSpecΓFunctor`.
    - Both are UNUSED by the subsequent `sorry` (which is expected and fine for scaffolding). The progress is real: the adjunction depth correction ("depth-2, NOT depth-3") eliminates a prior blind alley.
  - The long comment chains embedded in proof bodies (50–80 lines in `base_change_mate_fstar_reindex_legs_conj`, `base_change_mate_gstar_counit_transport`) are engineering-notebook style. These are not "excuse-comments" (they don't claim proofs are correct when they're not) but will accumulate technical debt if left after closure.
  - Line 2280: comment references "the sorry-backed `base_change_mate_fstar_reindex`" — accurate statement of the transitive sorry dependency.
  - Lines 2379–2381: docstring for `base_change_mate_section_identity` accurately states "body has no inline `sorry` ... but transitively `sorry`-backed through `base_change_mate_gstar_transpose`". Honest.

### AlgebraicJacobian/Cohomology/RegroupHelper.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: No sorry bodies. Axiom-clean. Compact file with a single declaration (`base_change_regroup_linearEquiv`) and its supporting algebra.

### AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: No sorry bodies. Contains the global sections equalizer and finite-cover infrastructure for FBC-B. Axiom-clean.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 2264: one sorry body. The enclosing comment (lines 2261–2263) says "The witness `V` cannot be produced soundly until G1 is available (it feeds the per-patch `f_j`), so the construction terminates in an honest `sorry` here rather than committing to an unjustified open." This is an honest and accurate statement of a genuine dependency; not a red flag.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: No actual sorry bodies (lines 18–20 reference sorry in the module-level doc comment, not in proofs). File is axiom-clean. The `QcohAlgebra` structure (iter-179 Block A encoding) and `RelativeSpec`/`structureMorphism` bodies are Mathlib-aligned.

### AlgebraicJacobian/Picard/GradedHilbertSerre.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: No sorry bodies. Axiom-clean.

### AlgebraicJacobian/Picard/GrassmannianCells.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: No sorry bodies. Axiom-clean.

---

## Must-fix-this-iter

None.

The 11 new declarations in QuotScheme.lean (lines 2553–2716) are all axiom-clean, have honest non-vacuous statements, and use the infrastructure correctly (correct `Presentation.ofIsIso`/`Presentation.map`/`.{u}` annotations, correct `q.shrink` universe move, correct `IsOpenImmersion → Final → pullbackObjUnitToUnit` route, correct dot-notation `.IsQuasicoherent` conclusions). No weakened definitions, no parallel API, no excuse-comments, no suspect bodies. The `adjL`/`hunitL` scaffolding in FlatBaseChange.lean is verified first-rung progress, not dead/illusory. The sorry bodies in FlatBaseChange.lean and FlatteningStratification.lean are openly documented gaps with clear statements of what remains.

---

## Major

None.

---

## Minor

- `FlatBaseChange.lean:1808–1811` — Status comments ("STATUS (iter-039)", "iter-041 PARTIAL") embedded in a proof body. Accurate at the time written; now historical. Will accumulate noise as the proof evolves. Suggest pruning once the enclosing sorry is closed.
- `FlatBaseChange.lean:1870–1891` — `adjL`/`hunitL` are defined in the body of `base_change_mate_fstar_reindex_legs_conj` but not syntactically consumed by the closing `sorry`. They are verified (type-check + proof of `hunitL`) and represent genuine progress on the adjunction-depth question, but the Lean elaborator gains nothing from them until the `sorry` is replaced. This is expected for scaffolding; note for completeness.
- `FlatBaseChange.lean` generally — the long in-proof comment chains (50–80+ lines per proof body, mixing iter-history, strategy, and routing notes) are engineering-notebook style. Not problematic now, but will need cleanup once proofs close; future auditors reading a closed proof will find these comments confusing.

---

## Excuse-comments (always called out separately)

None found. All `sorry` bodies are accompanied by accurate, technically honest statements of what is blocked and why. No comment claims a definition or proof is correct when it is not.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: The 11 new QuotScheme.lean declarations are axiom-clean with honest statements and correct infrastructure use; the FlatBaseChange.lean `adjL`/`hunitL` scaffolding is genuine verified progress; the project's sorry inventory is openly documented with no red flags.
