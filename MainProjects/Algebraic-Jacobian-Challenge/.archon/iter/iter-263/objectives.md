# Iter-263 objectives (dispatch detail)

3 prover lanes (all HARD-GATE-CLEARED via br263 fast-path). Picard import coupling
(`DualInverse → TensorObjSubstrate`) mitigated by maintain-compilable; engine import-independent.

## Lane 1 — `Picard/TensorObjSubstrate/DualInverse.lean` [fine-grained]
- Target: `sliceDualTransport` (L184) `≃ₗ` packaging — close `map_add'` + `map_smul'`, then `invFun`.
- Recipe (VERIFIED, `analogies/ma-ihom263.md`):
  - `map_add'` closes outright: `change (ModuleCat.restrictScalars _).map ((x+y).app _) ≫ _ = _`
    (LOAD-BEARING) → `rw [show (x+y).app … = x.app … + y.app … from rfl, Functor.map_add,
    Preadditive.add_comp]` (ran to goals `[]` at L343).
  - `map_smul'`: same `change` opener, then `homModule.smul`/`globalSMul` unfold (naive scalar bridge
    FAILS — verified).
  - `invFun` (~150–250 LOC reverse build) → `left_inv`/`right_inv` round-trips → `dual_restrict_iso`
    `isoMk` naturality.
- Bar: `map_add'`+`map_smul'` (6→4). Reversing signal: structural wall on smul/invFun ⇒ report, no
  unilateral stalk pivot.
- Housekeeping: stale STATUS NOTE (~L289–292) + docstring/`/- Planner strategy -/` relocation (aud262).

## Lane 2 — `Picard/TensorObjSubstrate.lean` [prove]
- Target: `sheafificationCompPullback_comp` (L2480) — EXTRACT the R1/R5 collapse tail as a NAMED lemma,
  then consume it (NOT inline a 3rd time; pc263 one-from-STUCK).
- Building blocks: `homEquiv_leftAdjointUniq_hom_app`, `pushforwardComp.hom.naturality`,
  `comp_unit_app`/`Adjunction.unit_naturality`. δ-free twin of `pullbackObjUnitToUnit_comp` L969–996.
- Bar: 3→2. RACE: keep file compilable (DualInverse imports it); retain typed sorry if it won't close;
  report the exact blocking transport step (3rd PARTIAL ⇒ STUCK ⇒ iter-264 fine-grain).
- Do NOT touch `pullbackTensorMap_restrict` (L2598), `exists_tensorObj_inverse` (L715, gated).

## Lane 3 — `Cohomology/CechHigherDirectImage.lean` [mathlib-build]
- Target: the independent `Gobj`/`Gmap` brick of the push-pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`,
  `(Y,p) ↦ (pushforward p).obj ((Scheme.Modules.pullback p).obj F)`.
  - `Gobj Y := (pushforward Y.hom).obj ((Scheme.Modules.pullback Y.hom).obj F)`.
  - `Gmap g` = 3-step composite (`η_h`; `(pushforwardComp h Y1.hom).hom`; `(pushforward Y2.hom).map
    ((pullbackComp h Y1.hom).hom.app F)`) + 2 `eqToHom` along `Over.w g`. No functor laws.
- DEFER `Gmap_id`/`Gmap_comp` (consume D3′ Sq1 composition coherence — sc263: bare comp iso, NOT tensor
  δ/μ). NOT the downstream theorems.
- Bar (mathlib-build): `Gobj`+`Gmap` axiom-clean; hand off the `Gmap_id`/`Gmap_comp` decomposition.
  NON-PREEMPTIVE (idle capacity; do not displace lanes 1–2).

## Held
- `Picard/LineBundleCoherence.lean` — DONE, axiom-clean. No edits.
