# iter-059 review

## Overall progress this iter
- **Total sorry:** 10 → **11** (`+1`). The increase is an **intentional factoring**, not a regression and **not papering**: the single *opaque* `Ext`-vanishing residual at the `higherDirectImage_openImmersion_acyclic` leaf was replaced by the typechecking assembly `ext_jShriekOU_eq_zero_of_specIso … hjt hqc`, leaving exactly two *blueprint-named geometric* hypotheses (`hjt`, `hqc`) still `sorry`. Open holes: `CechSectionIdentification:537/586/673/737/804` (Stubs 1,2,4,5,6), `OpenImmersionPushforward:484/485` (hjt/hqc) + `551` (`_comp`), `CechAugmentedResolution:229`, `CechHigherDirectImage:780` (frozen P5b), `CechAcyclic:110` (dead).
- **Build:** GREEN. Review re-verified first-hand — `lake env lean` EXIT 0 on both prover files; `#print axioms` = `{propext, Classical.choice, Quot.sound}` on all 5 keystones.
- **Lanes planned 2, ran 2.** Both PARTIAL-with-major-progress. **+13 axiom-clean decls** (5 OpenImm + 8 CSI).
- **dag-query:** gaps = 0; unmatched = 12 (11 new helpers + dead `affine`). sync_leanok ran iter-059 (sha `0b5f5b5`, +1/−3). **blueprint-doctor: no findings.**

## Headline 1 — Open-immersion acyclicity: the homological half (Bridge (1)/(2) remainder) is DONE
Lane 1 discharged the entire homological obstruction of Need #1's open-immersion acyclicity. The decisive find: `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` computes the right-derived object of `preadditiveCoyoneda(op P)` via `InjectiveResolution.isoRightDerivedObj` and reads off vanishing from `InjectiveResolution.extMk_eq_zero_iff` — **on the ℕ-indexed `cocomplex`**, so it sidesteps both the planner's ℤ-indexed `extAddEquivCohomologyClass∘homologyAddEquiv` route *and* the nonexistent `Functor.rightDerived ≅ Ext` lemma. The Bridge-(2) assembly `ext_jShriekOU_eq_zero_of_specIso` then composes spectrum-transport (`pushforwardExtAddEquiv`), Spec-side enough injectives, first-arg `Ext`-subsingleton transfer, and the now-unconditional Need #2 (`affine_serre_vanishing_general_open`). What remains is **purely geometric**: `hjt` (jShriekOU natural-iso under the scheme iso) and `hqc` (qcoh along the iso). The leaf is reduced to two named, correctly-typed hypotheses — auditor + lvb both confirmed the factoring is faithful and Subsingleton-laundering-free.

## Headline 2 — Stub-1 backbone: both blueprint build-targets PROVED; lane is one universe-reduction from closing
Lane 2 proved the two blueprint-named distributivity build-targets axiom-clean — `overProd_coproduct_distrib` (the `Over S` binary keystone, ~80 LOC) and `widePullback_coproduct_iso` (the full `p`-induction). Every categorical brick the Stub-1 consumer `cechBackbone_left_sigma` composes now exists. The consumer stays a sorry because of one well-understood obstacle: the universe reduction (`𝒰.I₀ : Type u` vs the Type-0-only bricks). The iter-058 auditor's "trivial widen `{ι:Type}→{ι:Type*}`" was wrong — the iter-059 planner *and* this iter's auditor both confirm it does not compile (`isIso_sigmaDesc_fst` is Type-0). The prover left a precise `Fin n`-reindex handoff; this is a clean frontier-ready next-iter unit (~80–150 LOC).

## Soundness — confirmed three ways, no papering
- **Review first-hand:** both `lake env lean` EXIT 0; 5 keystones kernel-clean.
- **lean-auditor `iter059`** (0 must-fix / 1 major / 9 minor): both files clean; all 8 sorries honest + correctly typed; no Subsingleton-laundering (the `Ext`-subsingleton flows from `affine_serre_vanishing_general_open` via genuine bijectivity of `pushforwardExtAddEquiv`); Stubs 5/6 use the corrected augmented `D'_aug`; **no excuse-comments**. The 1 major is code duplication (`isZero_of_faithful_preservesZeroMorphisms` copied from `CechAugmentedResolution.lean`, docstring-documented — maintenance only).
- **lvb-openimm** (1 must-fix) + **lvb-csi** (1 must-fix): both must-fixes are *blueprint-coverage / placeholder-flag* matters, not Lean unsoundness (details below).

## The lvb must-fixes — neither is iter-059 unsoundness
1. **lvb-openimm:** `higherDirectImage_openImmersion_comp` (line 527) body is `sorry` against a full blueprint sketch. This is a **pre-existing** honest hole, not new breakage; it is the *next* open-immersion piece after hjt/hqc. Recorded as recommendation #3.
2. **lvb-csi:** a flagged universe/`\leanok` interaction on `cechSection_complex_iso` / the two proved-but-unmarked bricks. Root cause is the prover `.lean` files being git-untracked when sync_leanok ran (whole tree = one commit) — a sync attribution artifact, not laundering and not mine to fix. Recorded for re-confirmation after the next commit/sync.

## Blueprint debt is the dominant follow-up (not a math wall)
11 new lean_aux helpers lack blueprint blocks (5 OpenImm + 6 CSI); `coprodFirst_distrib` and the `pcd/cf/overSigma` plumbing should be bundled into existing `\lean{}` pins; `overProd_coproduct_distrib_right` needs its own one-line block. Prose fixes: the σ-normal-form bridge note (carried from iter-058) and the under-specified `lem:pushforward_iso_preserves_qcoh` (qcoh-along-iso). All in `recommendations.md`.

## Markers I changed
- Stripped 2 stale `% NOTE: build target. The Lean declaration does not exist yet` on `lem:overProd_coproduct_distrib` and `lem:coproduct_distrib_fibrePower` (both decls now proved axiom-clean). Kept the 5 NOTEs on the genuinely-unbuilt `lem:pushforward_commutes_*`/`lem:jshriek_transport_along_iso`/`lem:pushforward_iso_preserves_qcoh` blocks and the 2 augmented-form NOTEs on Stubs 5/6.
- No `\mathlibok` / `\lean{}` rename / `\notready` changes.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor `iter059`, lean-vs-blueprint-checker ×2 [`openimm`, `csi`], one per prover-touched file.)
