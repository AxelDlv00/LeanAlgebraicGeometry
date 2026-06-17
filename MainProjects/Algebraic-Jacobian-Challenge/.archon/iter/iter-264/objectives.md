# Iter-264 objectives (dispatch detail)

3 prover lanes (all gate-cleared via br264 fast-path).

## 1. DualInverse.lean [fine-grained] — CHURNING corrective (scope-down)
- Close ONLY `map_smul'` of `sliceDualTransport` (L383). Crux `d.hom (s•u)=c•d.hom u`:
  `hring : s=(β.app W').hom c` (`termRingMap_naturality`+`β.naturality`) → `← restrictScalars.smul_def'`
  +`map_smul` → projection-tolerant `exact hcrux` (RHS `{app}.app W` defeq-not-syntactic).
- If it closes, optionally `naturality` (L335, ε-naturality `erw` paste). DEFER `invFun`/round-trips to iter-265.
- Bar: internal holes 5→4. Reversing signal: no-close with named route ⇒ report failing step (granularity reassess).

## 2. TensorObjSubstrate.lean [fine-grained] — STUCK corrective (recipe in hand)
- Close `sheafificationCompPullback_comp_tail` (L2519) via ma-d3264's 6-step recipe (`analogies/ma-d3264.md`),
  mirroring `pullbackObjUnitToUnit_comp` (L952–1001) one composite-adjunction level up.
- Steps: `homEquiv_leftAdjointUniq_hom_app` → `comp_unit_app` → `homEquiv_unit`/`_naturality_*` →
  `pushforwardComp.hom.naturality` → `unit_naturality`+`erw[assoc]`; δ_pre via `conjugateEquiv_leftAdjointCompIso_inv`.
- Dead-end: do NOT re-transpose the whole equation (circular). Keep LHS concrete, assemble RHS. `erw` not `rw`.
- RACE: keep file compilable (DualInverse imports it). Bar: file-sorry 3→2.

## 3. CechHigherDirectImage.lean [mathlib-build] — DOMINANT POLE (de-coupled)
- Introduce + close `pushPullMap_id`/`pushPullMap_comp` via Mathlib pseudofunctor coherences
  (`conjugateEquiv_pullbackComp_inv` → `pseudofunctor_right_unitality`/`_associativity` +
  `conjugateEquiv_pullbackId_hom` + `Adjunction.unit_naturality`); `eqToHom`-glued composites as
  fully-applied forward terms w/ explicit `congrArg`; `respectTransparency false`.
- Then assemble `pushPullFunctor` (G); if budget, discharge `CechNerve` (L97). Do NOT touch the 3
  infra-gated sorries. Bar: 2 laws axiom-clean; stretch file-sorry 4→3.
