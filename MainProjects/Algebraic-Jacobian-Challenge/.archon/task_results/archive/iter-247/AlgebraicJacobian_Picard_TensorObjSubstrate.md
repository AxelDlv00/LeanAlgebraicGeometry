# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (2, both axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `presheafUnit_comp_map_eta` (~L1494) — the **presheaf-side mate identity** driving the η-bridge.
  - `isIso_sheafifyEta_of_unitSquare` (~L1510) — axiom-clean **IsIso plumbing** reducing the
    η-bridge `IsIso (a_Y.map (η (pullback φ')))` to the single unit-comparison **square equation**.
- **Declarations blocked (0 added):** the unconditional η-bridge / the square equation itself — see
  "Why I stopped".
- **Sorry count across file: 1 → 1** (unchanged; only the pre-existing tracked
  `exists_tensorObj_inverse` at L692). **No new sorry pins.**

## `presheafUnit_comp_map_eta` (~L1494) — RESOLVED, axiom-clean
- **Statement:** `presheafAdj.unit.app 𝟙_ ≫ (pushforward φ').map (η (pullback φ')) = ε (pushforward φ')`
  (presheaf level), `φ' = f.toRingCatSheafHom.hom`.
- **Approach:** This is Mathlib's `Adjunction.unit_app_unit_comp_map_η` instantiated at
  `PresheafOfModules.pullbackPushforwardAdjunction φ'`. The non-trivial content is that it
  *typechecks* for THIS adjunction: it forces Lean to confirm the project's
  `presheafPushforwardLaxMonoidal` (G.LaxMonoidal) and `presheafPullbackOplaxMonoidal`
  (F.OplaxMonoidal = `leftAdjointOplaxMonoidal`) instances are `Adjunction.IsMonoidal`-compatible.
  Needs `haveI : (pushforward φ').IsRightAdjoint := (pullbackPushforwardAdjunction φ').isRightAdjoint`
  in scope so the `OplaxMonoidal (pullback φ')` instance fires.
- **Why it matters:** this is the **unit-side analog of `pullbackObjUnitToUnit_comp`** at the
  presheaf level — the genuinely-new mathematical driver of the η-bridge. The η-bridge close is its
  sheafification transport (see below).

## `isIso_sheafifyEta_of_unitSquare` (~L1510) — RESOLVED, axiom-clean
- **Statement:** given the square
  `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom
     = pullbackObjUnitToUnit f.toRingCatSheafHom`,
  concludes `IsIso (a_Y.map (η (pullback φ')))`.
- **Approach:** `pullbackObjUnitToUnit φ` is iso (`isIso_pbu_of_final`, since `Opens.map f.base` is
  always `Final`); `pullbackValIso`, `sheafifyUnitIso` are isos. Rearrange via `Iso.inv_comp_eq` /
  `Iso.eq_comp_inv`, then `IsIso.comp_isIso'`. Fully mechanical, verified axiom-clean.
- **Why it matters:** isolates the SOLE remaining content of the η-bridge as the **square equation**
  hypothesis `hsq`. Chains: prove the square ⟹ this lemma ⟹ `IsIso (a_Y.map η)` (the hypothesis
  consumed by the iter-246 `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`) ⟹ D2'.

## The square equation (NOT added) — the remaining η-bridge content
The single remaining obligation is the **unit-comparison square** `hsq`:
```
(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom
  = pullbackObjUnitToUnit f.toRingCatSheafHom
```
Transposing across `SheafOfModules.pullbackPushforwardAdjunction φ` (`.homEquiv.injective`, then
`pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit` + `homEquiv_unit`) reduces it to the
**concrete pushforward-side identity (∗∗)** (verified live this iter — exact goal captured):
```
sheafAdj.unit.app 𝒪_X ≫ (pushforward_sheaf φ).map (
    (pullback_sheaf φ).map (sheafCounit_X.inv)
    ≫ (sheafificationCompPullback φ).hom.app 𝟙ᵖ_X
    ≫ a_Y.map (η (pullback φ'))
    ≫ sheafCounit_Y.hom )
  = unitToPushforwardObjUnit φ
```
(`sheafCounit_• = (PresheafOfModules.sheafificationAdjunction (𝟙 •.ringCatSheaf.val)).counit`.)

### DERIVED telescoping recipe for (∗∗) (paper-complete; NOT yet encoded)
By `homEquiv_unit`, (∗∗) is `homEquiv_sheaf(m) = unitToPushforwardObjUnit φ` with
`m = pullback_sheaf.map(sheafCounit_X.inv) ≫ scp.hom.app 𝟙ᵖ_X ≫ a_Y.map(η_pre) ≫ sheafCounit_Y.hom`,
`scp = sheafificationCompPullback φ = Adjunction.leftAdjointUniq A B`, where
- `A = (sheafificationAdjunction (𝟙 X.rcs.val)).comp (pullbackPushforwardAdjunction_sheaf φ)`
      (left adjoint `sheafification_X ⋙ pullback_sheaf`),
- `B = (PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp (sheafificationAdjunction (𝟙 Y.rcs.val))`
      (left adjoint `pullback_pre φ' ⋙ sheafification_Y`).

Telescope `homEquiv_sheaf(m) = sheafAdj.unit.app 𝒪_X ≫ pushforward_sheaf.map(m)`:
1. `Functor.map_comp` (distribute `pushforward_sheaf.map` over the 4-fold composite of `m`).
2. `Adjunction.unit_naturality` of `sheafAdj` at `sheafCounit_X.inv` ⟹ pull
   `sheafCounit_X.inv` to the front: leaves `sheafAdj.unit.app(a_X 𝟙ᵖ_X) ≫ pushforward_sheaf.map(scp.app …)`.
3. That head is `A.homEquiv(scp.hom.app 𝟙ᵖ_X)` *up to the composite-adjunction `homEquiv` factorisation*:
   for `Adjunction.comp adj1 adj2`, `(adj1.comp adj2).homEquiv = adj2.homEquiv` then `adj1.homEquiv`
   (i.e. `A.homEquiv(g) = sheafAdj_pre_X.homEquiv (homEquiv_sheaf g)`). So
   `homEquiv_sheaf(scp.app) = (sheafAdj_pre_X.homEquiv).symm (A.homEquiv(scp.app))`.
4. `Adjunction.homEquiv_leftAdjointUniq_hom_app A B 𝟙ᵖ_X`:  `A.homEquiv(scp.app 𝟙ᵖ_X) = B.unit.app 𝟙ᵖ_X`.
5. `Adjunction.comp_unit_app` on `B`: `B.unit.app 𝟙ᵖ_X
     = presheafAdj.unit.app 𝟙ᵖ_X ≫ pushforward_pre.map (sheafAdj_pre_Y.unit.app (F.obj 𝟙ᵖ_X))`
   (`sheafAdj_pre_Y.unit = toSheafify_Y`).
6. Use `presheafUnit_comp_map_eta` (THIS ITER) to rewrite `presheafAdj.unit ≫ pushforward_pre.map(η_pre)`
   ⟹ `ε_pre = Functor.LaxMonoidal.ε (pushforward_pre φ')`. (η_pre enters via `a_Y.map(η_pre)` in `m`
   together with the sheafification counits / `toSheafify` cancelling through `sheafCounit_Y`.)
7. Reconcile `ε_pre` with `ε_sheaf = unitToPushforwardObjUnit φ` (objectives: `ε_sheaf` is
   `unitToPushforwardObjUnit φ` by `rfl`; the presheaf `ε_pre` maps to it under sheafification via
   the `pushforward` ↔ sheafification compatibility used to build the adjunctions).

Each step is a named Mathlib lemma. Expect the documented `erw` defeq friction
(`Scheme.Modules.pullback f` vs `SheafOfModules.pullback f.toRingCatSheafHom`,
`Sheaf.val •.ringCatSheaf` vs `•.presheaf ⋙ forget₂ CommRingCat RingCat`,
`sheafificationCompPullback` unfolding to `leftAdjointUniq` of two composite adjunctions).

## Why I stopped — PARTIAL (honest)
- **Real progress:** 2 axiom-clean declarations added — `presheafUnit_comp_map_eta` (~L1494, the
  genuinely-new presheaf-side mate driver) and `isIso_sheafifyEta_of_unitSquare` (~L1510, the IsIso
  reduction to the square). Plus the η-bridge is now reduced to a single **morphism equation** (the
  square), and the full transposed goal (∗∗) + a paper-complete 7-step telescoping recipe driven by
  the new brick are captured above.
- **Not closed:** the square equation `hsq` / (∗∗) itself. It is NOT a Mathlib gap — every lemma in
  the recipe exists (`unit_naturality`, `homEquiv_leftAdjointUniq_hom_app`, `comp_unit_app`,
  `leftAdjointOplaxMonoidal_η`, `presheafUnit_comp_map_eta`). It is a **long, ordered, defeq-friction
  -laden manual mate-telescope** (~15 rewrite steps across three nested adjunction layers:
  sheaf pullback-pushforward, presheaf pullback-pushforward, and two sheafification adjunctions glued
  by `sheafificationCompPullback = leftAdjointUniq`). Heavy `simp`/`aesop_cat`/targeted `simp only`
  with the exact glue lemmas were all tried and make NO progress (the lemmas' syntactic preconditions
  require prior ordered massaging — confirmed via `lean_multi_attempt`). I could not encode the full
  telescope reliably within budget, and the mathlib-build mode forbids leaving a `sorry` pin, so the
  square is left to the next session rather than pinned.
- **Informal agent:** unavailable (key 401, per memory `informal-agent-key-invalid`); relied on Lean
  LSP search throughout.

## Next step (precise)
Add a standalone lemma `unitSquare : hsq` proving the square via the 7-step telescope above
(transpose with `pullbackPushforwardAdjunction (f.toRingCatSheafHom) |>.homEquiv.injective`, then
execute steps 1–7), then close the η-bridge as
`isIso_sheafifyEta_of_unitSquare f unitSquare`, and feed it into
`isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (already in file) to finish D2'.
The hardest sub-step is #3 (the composite-adjunction `homEquiv` factorisation) — verify the exact
Mathlib form of `(adj1.comp adj2).homEquiv` first via `lean_hover_info` on `Adjunction.comp`.

## Blueprint markers
- `presheafUnit_comp_map_eta` and `isIso_sheafifyEta_of_unitSquare` are project-local supplements
  (no blueprint `\lean{}` pin); they are building blocks toward `lem:pullback_tensor_iso_unit` (D2').
  No `\leanok` action needed from me (sync_leanok handles pinned decls).
