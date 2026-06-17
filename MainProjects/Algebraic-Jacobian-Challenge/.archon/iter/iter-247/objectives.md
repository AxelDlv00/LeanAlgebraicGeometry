# Iter-247 — prover objectives (full recipes, reuse maps, guardrails, reversing signals)

Two parallel lanes, both now unblocked by the iter-247 import-cycle refactor (dependency now flows
`LineBundlePullback → TensorObjSubstrate → RelPicFunctor`).

---

## Lane TS — `Picard/TensorObjSubstrate.lean` — the η-bridge (D2' completion), then D3'/D4'

**Mode:** `mathlib-build`. **Critical path (A.1.c.sub).** Blueprint:
`chapters/Picard_TensorObjSubstrate.tex` § `sec:tensorobj_pullback_monoidality`.

### HARD closure requirement (progress-critic ts247, CHURNING corrective)
Route TS is CHURNING by the PARTIAL×5 metric (offset by genuine sequential structural progress + no
new Mathlib-absent blocker). The sorry-stasis exemption is now in its LAST permitted application.
**This iter the η-bridge MUST close the goal `IsIso (a_Y.map (η (pullback φ')))` outright OR land an
axiom-clean D3' brick.** "Another named concrete residual remains, additional setup needed" is NOT an
acceptable PARTIAL outcome again — per the critic, a 4th such PARTIAL forces iter-248 to classify STUCK
with user escalation. Push to close; leave real partial tactic state if genuinely stuck, not a fresh
typed-sorry pin.

### The η-bridge — API CONFIRMED accessible (mathlib-analogist eta247: PROCEED)
Target: `IsIso (a_Y.map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))`. It is the
**unit-side mirror** of the ALREADY-PROVEN axiom-clean `pullbackObjUnitToUnit_comp`
(TensorObjSubstrate.lean ~L904–990, the δ/counit-side mate transport). Same machinery.

The δ-wrapping + assembly landed iter-246 (axiom-clean): `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`,
`isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`, `W_of_isIso_sheafification`, `sheafifyUnitIso`.
So `IsIso (pullbackTensorMap f 𝒪 𝒪)` reduces UNCONDITIONALLY to this single η-goal.

**Route (transpose to the pushforward-side mate identity):** the η-bridge is the square
```
a_Y.map (η F) ≫ sheafifyUnitIso.hom = (pullbackValIso f 𝒪_X).hom ≫ pullbackObjUnitToUnit φ
```
(all three of `pullbackValIso`, `sheafifyUnitIso`, `pullbackObjUnitToUnit φ` = `pullbackUnitIso` are
isos ⟹ `IsIso (a_Y.map (η F))`). Transpose via
`apply (SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv _ _ |>.injective`, then rewrite with
`Adjunction.homEquiv_unit`, `Adjunction.leftAdjointOplaxMonoidal_η`, `Adjunction.homEquiv_counit`, to
the concrete pushforward-side identity
```
sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map (
    (pullbackValIso f 𝒪_X).inv ≫ a_Y.map (pullback_pre.map ε_pre ≫ presheafAdj.counit.app 𝟙_)
    ≫ sheafifyUnitIso.hom) = unitToPushforwardObjUnit φ
```

**Glue lemmas — VERIFIED to exist at the pinned commit (analogist eta247):**
- `CategoryTheory.Adjunction.homEquiv_leftAdjointUniq_hom_app`
- `CategoryTheory.Adjunction.unit_leftAdjointUniq_hom_app`  (+ `_assoc` variant — NEEDED under composites)
- `CategoryTheory.Adjunction.leftAdjointUniq_hom_app_counit` (+ `_assoc` variant — NEEDED)
- `CategoryTheory.Adjunction.leftAdjointUniq_trans_app_assoc`
- `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal_η`, `homEquiv_unit`, `homEquiv_counit`
- `Functor.LaxMonoidal.ε (SheafOfModules.pushforward φ) = unitToPushforwardObjUnit φ` by `rfl`
  (`pullbackValIso` is built from `SheafOfModules.sheafificationCompPullback` =
  `Adjunction.leftAdjointUniq` of two composite adjunctions; the `leftAdjointUniq_*_app` lemmas relate
  its components to the presheaf/sheaf adjunction units/counits.)

**No shorter idiom (analogist Q3):** `Functor.Monoidal.instIsIsoη` does NOT apply (goal is `a_Y.map (η F)`,
not `η` of one strong-monoidal functor; `F = pullback φ'` is only oplax). The mate chase IS the canonical
route. Expect the same `erw`-driven defeq friction `pullbackObjUnitToUnit_comp` absorbed
(`Scheme.Modules.pullback f` vs `SheafOfModules.pullback f.toRingCatSheafHom`, plus
`sheafificationCompPullback` unfolding to `leftAdjointUniq`) — an elaboration nuisance, NOT an API gap.
Full rationale: `analogies/eta247.md`.

**THEN as far as reachable:** D3' (`lem:pullback_tensor_map_basechange` / the δ-vs-open-immersion
base-change-square coherence, tensorator analog of `pullbackObjUnitToUnit_comp`) → D4'
(`lem:pullback_tensor_iso_loctriv`, chart-chase via `isIso_of_isIso_restrict` ~L548) →
`IsInvertible.pullback` (3-line Stacks corollary `lemma-pullback-invertible`).

**Reversing signal (armed):** if D3' proves materially harder than its proven unit analog
`pullbackObjUnitToUnit_comp`, decompose D3' further — do NOT revive the abandoned general Lan build.

**Guardrails:** do NOT touch the deferred sorry `exists_tensorObj_inverse` (~L696). No new sorry pins
(mathlib-build). The file's import block changed this iter (now imports `LineBundlePullback` directly,
no longer `RelPicFunctor`); the η-bridge decls are unaffected.

---

## Lane RPF — `Picard/RelPicFunctor.lean` — rewire the 4 bridges to the upstream substrate

**Mode:** `prove`. **A.1.c.fun (feeds A.2.c).** Blueprint: `chapters/Picard_RelPicFunctor.tex`
§ `lem:rel_pic_sharp_groupoid` (HARD GATE CLEARS — blueprint-reviewer rpf-fastpath247, complete+correct).

### Context — the import cycle is RESOLVED (iter-247 refactor)
`RelPicFunctor.lean` now imports `TensorObjSubstrate` (and transitively `LineBundlePullback`). The real
upstream substrate decls are directly citable. `tensorObjOnProduct` was moved into this file
(`namespace Modules`, sorry-free). The 4 typed-sorry bridges the iter-246 prover built from local
pure-Mathlib copies are now REWIREABLE to the real proofs:

| Local bridge (current sorry) | Upstream replacement (now importable) |
|---|---|
| `pTensor_isLocallyTrivial` | `tensorObj_isLocallyTrivial` (TensorObjSubstrate) |
| `pAssoc` | `tensorObj_assoc_iso` (TensorObjSubstrate) |
| `isLocallyTrivial_unit` | the loc-triv unit fact used inside `IsLocallyTrivial.pullback` (LineBundlePullback ~L192) / `pullbackUnitIso` |
| `exists_pTensor_inverse` | `exists_tensorObj_inverse` (TensorObjSubstrate, itself a genuine project sorry) |

### Objective
1. Replace the local `private` pure-Mathlib substrate copies (`pTensor`, `pAssoc`, `pLeftUnitor`,
   `pRightUnitor`, `pBraiding`, `pTensor_isLocallyTrivial`, `isLocallyTrivial_unit`, …) and the 4
   bridges with direct citations of the upstream substrate (`tensorObj`, `tensorObjIsoOfIso`,
   `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding`, `tensorObj_assoc_iso`,
   `tensorObj_isLocallyTrivial`, `tensorObj_unit_iso`, `exists_tensorObj_inverse`, `pullbackUnitIso`).
2. **Target sorry count: 4 → 1** (only `exists_tensorObj_inverse` should remain — and that one is a
   genuine upstream project-deferred sorry, so RPF's `addCommGroup` becomes a real construction modulo
   exactly that one tracked reverse bridge). This is the progress-critic ts247 CONVERGING monitoring
   condition for Lane RPF (sorry returns to ≤1).
3. `isLocallyTrivial_unit` was blocked iter-246 by an undiagnosed `IsIso (pullbackObjUnitToUnit φ)`
   instance-resolution quirk; the identical `asIso (pullbackObjUnitToUnit g.toRingCatSheafHom)` compiles
   inside `IsLocallyTrivial.pullback` (LineBundlePullback ~L192) — cite/route through that proven path
   rather than re-synthesizing the instance.
4. If reachable: upgrade `PicSharp.functorial` off the `0` stub — `map_zero ← pullbackUnitIso`,
   `map_add ←` the loc-triv comparison iso (Lane TS D4', not yet landed) → keep `map_add` as ONE typed
   bridge `pullback_tensor_iso_loctriv` (sanctioned: it is the explicit Lane TS objective). Do NOT add
   more than this one forward bridge.

**Guardrails:** do NOT edit `TensorObjSubstrate.lean` / `LineBundlePullback.lean` (cite, don't copy).
The `addCommGroup` body must remain a real construction — collapse bridges to upstream citations, do not
re-introduce local duplications. Informal-agent is unavailable (key 401); rely on Lean LSP search.
