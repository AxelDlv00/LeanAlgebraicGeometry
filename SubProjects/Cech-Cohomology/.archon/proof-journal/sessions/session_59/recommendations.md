# Recommendations for the next plan iteration (post-iter-059)

## Soundness gate: PASS
Build GREEN (review-verified `lake env lean` EXIT 0 on both prover files); 5 keystones `#print axioms` kernel-only. Sorry 10→11 is an **intentional factoring** (single opaque `Ext` residual → two named geometric hypotheses `hjt`/`hqc`, assembly typechecks). No forced math, no papering (auditor + 2 lvb concur). gaps = 0. blueprint-doctor clean.

## CLOSEST TO COMPLETION — prioritize

### 1. Lane 2: `cechBackbone_left_sigma` universe reduction (FRONTIER-READY)
All categorical bricks now exist axiom-clean (`overProd_coproduct_distrib`, `widePullback_coproduct_iso`, `widePullback_overX_eq_prod`, `cechBackbone_obj_widePullback`). The **only** remaining work is the universe reduction: `𝒰.I₀ : Type u`, but `widePullback_coproduct_iso` is `{ι : Type}` = Type 0 only.
- **DO NOT** retry the `{ι:Type}→{ι:Type*}` widen — it **does not compile** (`isIso_sigmaDesc_fst` is Type-0-only; confirmed empirically by the iter-059 planner *and* by lean-auditor's universe-trap flag). The iter-058 auditor's "trivial widen" call was wrong.
- **DO:** pick `e : 𝒰.I₀ ≃ Fin (Nat.card 𝒰.I₀)` (`Finite.equivFin`), instantiate `widePullback_coproduct_iso (f := 𝒰.f ∘ e.symm) p` over `Fin n`, then transport: **(LHS)** `∐ 𝒰.X ≅ ∐ (𝒰.X∘e.symm)` (`Limits.Sigma.reindex` / `Sigma.whiskerEquiv e`) compatible with both `Sigma.desc` + `WidePullback.base` functoriality; **(RHS)** reindex `(Fin(p+1)→Fin n) ≃ (Fin(p+1)→𝒰.I₀)` (`Equiv.arrowCongr (Equiv.refl _) e`), per-component `∏ᶜ` matches by `(𝒰.f∘e.symm)(σ'k)=𝒰.f(e.symm(σ'k))`; then per-σ `Sigma.mapIso (widePullback_overX_eq_prod.symm ≪≫ widePullback_openImm_inter + eqToIso)`. ~80–150 LOC; the two reindex transports are load-bearing. **The iter-059 prover left a precise step-by-step handoff in `task_results/CechSectionIdentification.md` — feed it to the prover.**
- HARD-GATE note: chapter `Cohomology_CechHigherDirectImage.tex` was complete+correct at iter-059 plan; re-confirm next iter (mandatory blueprint-reviewer dispatch).

## PROMISING — needs decomposition first

### 2. Lane 1: `hjt` / `hqc` geometric transport (the last two open-immersion-acyclicity sorries)
The homological half is DONE; only these two geometric isos remain. **Decompose before prover** (lvb-openimm: `hjt` is a 4-deep chain of unbuilt declarations).
- `hjt` = `lem:jshriek_transport_along_iso`: needs `pushforward_commutes_free`, `pushforward_commutes_sheafify`, `yoneda_transport_along_homeo` — all unbuilt. The blueprint has a 3-step sketch but the three prerequisites are bare build-targets. **effort-break `lem:jshriek_transport_along_iso` into those three sub-lemmas + Mathlib adjunction-mate anchors before dispatching.**
- `hqc` = `lem:pushforward_iso_preserves_qcoh`: **blueprint is under-specified** (lvb-openimm: "transports verbatim" prose gives no Lean API). This is qcoh-preservation along an **iso** (not a general wall — pushforward along an iso preserves qcoh). **Dispatch a blueprint-writer** to give the `QuasicoherentData`-transport recipe (how to carry the local presentation across the iso of ringed spaces), optionally a mathlib-analogist consult first (is there an `IsIso`/equivalence qcoh-transport idiom?).

### 3. `higherDirectImage_openImmersion_comp` (line 527) — pre-existing honest hole, full blueprint sketch exists
lvb-openimm flagged the `sorry` body as a "must-fix placeholder," but it is a **pre-existing** honest hole (not iter-059 breakage) with a complete blueprint sketch (`rightDerivedIsoOfAcyclicResolution` + `pushforwardComp`; sub-obligations = resolution exactness + `f_*`-acyclicity of `j_*Iⁿ`). Schedule **after** `hjt`/`hqc` land — it is the remaining open-immersion piece, frontier-ready once the chapter sketch is confirmed adequate.

## BLOCKED / DO-NOT-RETRY
- **Lane-2 universe widen `{ι:Type}→{ι:Type*}`** — does not compile (Type-0-only `isIso_sigmaDesc_fst`). Two iters now confirm this. Use the `Fin n` reindex instead (item 1).
- **`Functor.rightDerived ≅ Ext` lemma** — does not exist in Mathlib (Ext is derived-category based). The `extMk_eq_zero_iff` route (item built this iter) is the correct replacement; do not search for the iso.
- `CechAcyclic.affine` (line 110), `CechHigherDirectImage` line 780 (frozen P5b), `CechAugmentedResolution` line 229 (`hSec`) — pre-existing/frozen, not this lane's work.

## BLUEPRINT COVERAGE DEBT (1-to-1) — `archon dag-query unmatched` = 12 (11 new + 1 dead)
The planner must author blueprint blocks (or bundle helper names into a related decl's `\lean{...}`) for the 11 new helpers. All are `proved:true, has_sorry:false`:

**OpenImmersionPushforward.lean (5):**
- `AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` — deps `InjectiveResolution.isoRightDerivedObj`, `.extMk_eq_zero_iff`, `ShortComplex.ab_exact_iff`, `HomologicalComplex.exactAt_iff'`. Natural anchor: new `lem:ext_vanishing_coyoneda_rightDerived` (the Bridge-(1)/(2) remainder).
- `AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions` — connector `HasInjectiveResolutions C → EnoughInjectives C`.
- `AlgebraicGeometry.subsingleton_ext_of_iso_fst` — `Ext.mk₀_comp_mk₀_assoc` + `Ext.mk₀_id_comp` + `Ext.comp_zero`.
- `AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso` — assembly; relies on `pushforwardExtAddEquiv`, `affine_serre_vanishing_general_open`, `EnoughInjectives.of_equivalence`, + (as hyps) `lem:jshriek_transport_along_iso` + `lem:pushforward_iso_preserves_qcoh`. Natural anchor extending `lem:open_immersion_pushforward_comp` Bridge (2).
- `AlgebraicGeometry.preadditiveCoyoneda_mapHomologicalComplex_d_apply` (private apply-lemma — bundle name into the `isZero_coyoneda…` block's `\lean{}`).

**CechSectionIdentification.lean (6):**
- `CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib_right` — **NEW, needs its own block** (braided twin of `lem:overProd_coproduct_distrib`; one-line `\uses{lem:overProd_coproduct_distrib}`).
- `…coprodFirst_distrib` — the coproduct-FIRST form; **add to the `lem:prod_coproduct_distrib` block's `\lean{}` pin** (lvb-csi: the block currently pins only the second form). 
- `…pcd_hom_fst` / `…pcd_hom_snd` / `…cf_hom_fst` / `…overSigma_hom_eq` (private) — proof-internal plumbing for `lem:overProd_coproduct_distrib`; **bundle their names into that lemma's `\lean{...}`** to clear `unmatched`.

(`overProd_coproduct_distrib` and `widePullback_coproduct_iso` are already matched — no action.)

## BLUEPRINT PROSE FIXES (from lvb)
- **σ-normal-form bridge note (lvb-csi, MAJOR — carried from iter-058):** Lean uses the slice product `∏ᶜ fun k => Over.mk (f (σ k))` in `Over S`; blueprint prose for `lem:coproduct_distrib_fibrePower` / `lem:cech_backbone_left_sigma` writes the wide-pullback `X_{σ(0)} ×_S ⋯` form. They are iso via `widePullback_overX_eq_prod` but a consumer needs that intermediate step, which the sketch omits. **blueprint-writer: add the bridge note.**
- `lem:pushforward_iso_preserves_qcoh` under-specified (item 2 above).

## MARKERS I (review) ALREADY APPLIED — do not redo
- Stripped the 2 stale `% NOTE: build target …` on `lem:overProd_coproduct_distrib` and `lem:coproduct_distrib_fibrePower` (decls now proved).

## PROCESS NOTE
- `\leanok` ambiguity on `widePullback_overX_eq_prod` / `widePullback_coproduct_iso` (proved+clean but unmarked) likely stems from the prover `.lean` files being git-untracked when sync_leanok ran. Re-confirm after the next commit/sync — not a correctness issue.
- Both lanes are file-split (no shared file); 2-lane parallelism remains correct next iter (Lane-2 reduction is the cheapest closeout; Lane-1 needs an effort-break/blueprint-writer round before its prover).
