# Pending Tasks
<!-- Current open-task set, last-known state only. Per-attempt detail → iter sidecars. -->

## Seed 1 — `pullbackTensorIsoOfLocallyTrivial` (D4′ chart-chase) — `TensorObjSubstrate.lean` — DEFERRED iter-030
STATE: body CLOSED. K1 residual `hmon` DECOMPOSED; **η-side CLOSED iter-028**; μ-side RHS + comparison-assembly
CLOSED iter-029 (`pushforward_lax_mu_comparison_rhs_tmul` PROVEN green; parent `pushforward_lax_mu_comparison`
body sorry-free via `hom_ext` delegation — both in task_done). **TWO residual sorries remain, both deferred to
iter-031 as a SOLO root-churning lane** (Substrate is the import-chain ROOT; editing it in parallel with the
DualInverse/TensorObjInverse lanes caused the iter-029 build-race that lost all work — see ARCHON_MEMORY).
**HARD (pc030): lhs_tmul gets its solo lane iter-031 — a 2nd consecutive deferral trips CHURNING-by-avoidance.**
- **`pushforward_lax_mu_comparison_lhs_tmul`** (`lem:pushforward_lax_mu_comparison_lhs_tmul`, L4303 sorry@L4353)
  — THE genuine residual (multi-hundred-LOC mate seam, flagged since iter-026). Packaged as the per-section
  comparison (let-chain + fixed `W`, `tensor_ext` INSIDE so `m,n` carry correct module instances — UNSTATABLE
  as a standalone pure-tensor lemma, module-instance trap). iter-029 committed `tensor_ext` +
  `rw [Adjunction.rightAdjointLaxMonoidal_μ, Adjunction.homEquiv_unit]` (mate → explicit
  `unit ≫ G.map(δGβ ≫ counit⊗counit)`). Residual = sectionwise value of the unfolded mate on `m⊗ₜn`: unit leg →
  `pushforwardPushforwardAdj_unit_app_app_apply`; δGβ leg → `Functor.OplaxMonoidal.comp_δ` +
  `restrictScalars_μ_app_tmul`/`forget₂_restrictScalars_μ_hom_tmul`; counit pair → bijective `f.appIso`. All
  via `erw` (no whnf on heavy sections), mirroring `pushforwardComp_lax_μ` leg calculus but for a MATE LHS.
  Routing through `hadj'.IsMonoidal` is CIRCULAR.
- **`pushforward_mu_appIso_collapse`** (`lem:pushforward_mu_appiso_collapse`, L4410 sorry@L4506): downstream;
  rewire to the 4-step mate reduction CALLING the now-assembled comparison once `lhs_tmul` closes.
- Pin: `AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial`. Blueprint §"K1 monoidal-mate
  bridge". Reference: Stacks `lemma-tensor-product-pullback` — `references/stacks-modules.tex`.

## Terminal — `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`) — ACTIVE, DECOUPLED
STATE: descent skeleton BUILT; collapse MECHANISM PROVEN mod B1 (iter-028). iter-029 (RED, lands on the
iter-030 build-fix): **eval-core `presheafDualUnitIso_naturality` (DualInverse.lean) WRITTEN + verified
`goals:[]`** — file sorry-free except ONE compile error at L219 (one-token name-shadow `← map_smul` →
`Scheme.Modules.map_smul`; fix = `← LinearMap.map_smul`, confirmed closing iter-030); **hN
`dualUnitIso_dualIsoOfIso` CLOSED + verified `goals:[]`** (assembled from the eval-core via `sheafification`
`erw` + counit naturality — `tensorObj_unit_self_duality_collapse` now fully sorry-free). Neither committed
green in iter-029 (build-race). Two genuine open sorries, BOTH this-iter targets (pc030: close BOTH, NO new
helpers — a 3rd PARTIAL = STUCK):
- **`trivialisation_restrict_compat` (`TensorObjInverse.lean` L183 sorry@L211)** — restriction-functor
  naturality of the trivialisation iso-chain; mirror `restrictIsoUnitOfLE` (`analogies/cocycle-a.md` §A);
  memory [[restrictfunctor-glued-morphism-pattern]] (`SheafOfModules.Hom.ext` before `PresheafOfModules.hom_ext`;
  `eqToHom_comp_iff`+`exact`-matched naturality; forward `rw [naturality]` fails on X-vs-restrict defeq).
  iter-029 NOT typed (no green build window — build-race).
- **Cocycle `exists_tensorObj_inverse` (`TensorObjInverse.lean` L302 sorry@L434)** — **FULL iso-algebra
  reduction DERIVED + written in-code iter-029** (paper-validated `/- Planner strategy -/` block): `erw
  [trivialisation_restrict_compat …]` reduces both overlap legs to one `t`; `dualIsoOfIso_trans` + insert
  `dual_unit_iso ≪≫ dual_unit_iso.symm = 𝟙` ⇒ `dualLeg eMj = dualLeg eMi ≪≫ sConj`; `tensorObjIsoOfIso_trans`
  factors RHS; `tensorObjIsoOfIso t sConj ≪≫ tensorObj_unit_iso = tensorObj_unit_iso` is EXACTLY
  `tensorObj_unit_self_duality_collapse t` (sorry-free). Just needs TYPING in a green window. NEVER
  sheafify-the-eval (d.2 dead-end).
- **Residual B** — CLOSED iter-026. Recipe `rem:dual_discharges_inverse`. Non-critical branch (seed-3
  `map_add` rides seed-1→K1).

## Scaffold target — seed 3 `PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`)
STATE: not in Lean. Gated on seed-1 (map_add ← comparison iso) + `exists_tensorObj_inverse` (group inverse).

## Tracked debt
- Coverage: 5 iter-019 helpers are `private` generic plumbing (no node owed) except
  `sheafificationCompPullback_comp_inv` (pinned `lem:pullback_val_iso_comp_scpb`). Bulk ~99 `lean_aux`
  decls remain; scheduled `Coverage + file-split` phase.
- File-split: `TensorObjSubstrate.lean` >3600 LOC (over 1000-LOC policy) — split scheduled after the
  active seed-1 lane lands (avoid disrupting the warm file).

## Completeness audit (user-requested) — DONE
3-seed cone COMPLETE vs AJC: 108/108 nodes, cone sizes 52/36/32 exact. Diffs = AJC dead-code Lan block
(not ported) + out-of-scope Route-A. Nothing required missing.
