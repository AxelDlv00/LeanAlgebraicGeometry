# Recommendations for iter-247 (from session 246 review)

## CRITICAL / HIGH

### 1. Resolve the RPF ↔ TensorObjSubstrate architecture BEFORE any further RPF proof work
The iter-246 RPF objectives were **infeasible as written**: they directed the lane to cite
`tensorObjOnProduct` / `exists_tensorObj_inverse` / unitors-braiding-associator from
`Picard/TensorObjSubstrate.lean`, but `TensorObjSubstrate.lean:9` **imports** `RelPicFunctor`, so the
tensor substrate is strictly downstream (citing it = import cycle). The prover worked around it with a
local pure-Mathlib substrate modulo 4 bridges — **but it itself flags this as ~200 LOC of fragile
duplication, "the wrong fix."**

**Do NOT re-dispatch RPF to extend the local-duplicate substrate.** Instead dispatch a **refactor
subagent** to pick one of:
- **(a) PREFERRED — relocate the tensor substrate upstream of `RelPicFunctor`.** Split a new file
  (e.g. `Picard/TensorSubstrate.lean`) holding `tensorObj`, `tensorObjIsoOfIso`, the unitors,
  `tensorObj_braiding`, `tensorObj_assoc_iso`, `tensorObj_isLocallyTrivial`, `tensorObjOnProduct`,
  `exists_tensorObj_inverse`, importable by `LineBundlePullback`-level files. Then the four RPF
  bridges collapse to direct citations and only `exists_tensorObj_inverse` remains a sorry. Keeps the
  blueprint pin (`lem:rel_pic_sharp_groupoid`) in the RPF chapter's file.
- **(b) relocate `PicSharp.addCommGroup` downstream** into `TensorObjSubstrate` next to
  `addCommGroup_via_tensorObj` (a structural subagent may move a non-protected declaration). Simpler
  move but splits the blueprint pin from its chapter.

Either way, this is a **structural decision the plan agent must make** (spans >1 file, outside the
prover's write-domain). Run `mathlib-analogist` (api-alignment) if uncertain whether the RPF local
`pTensor*` copies should be unified with the Mathlib `Scheme.Modules` tensor API rather than the
project substrate — the duplication smell is exactly its trigger. Memory: `rpf-import-cycle-blocks-tensorobj`.

### 2. Lane TS — finish the η-bridge mate chase (route is CONVERGING)
D2' δ-wrapping + assembly landed axiom-clean; `IsIso (pullbackTensorMap f 𝒪 𝒪)` now reduces
unconditionally to one residual: `IsIso (a_Y.map (η (pullback φ')))`. The prover already transposed it
to **one concrete pushforward-side mate identity** that typechecks, with all glue lemmas confirmed
present (`Adjunction.homEquiv_leftAdjointUniq_hom_app`, `unit_leftAdjointUniq_hom_app`,
`leftAdjointUniq_hom_app_counit`; `ε (pushforward φ) = unitToPushforwardObjUnit φ` by `rfl`). This is a
~60–120 LOC manual mate chase, the unit-side analog of the **proven** `pullbackObjUnitToUnit_comp`
(L904) crossing the presheaf↔sheaf boundary. **Re-dispatch this single, bounded target.** This is the
critical path; it is converging, not churning.
- After D2' closes: D3' (`pullbackTensorMap_restrict`, blueprint `lem:pullback_tensor_map_basechange`),
  then D4' (`pullbackTensorIsoOfLocallyTrivial`), then `IsInvertible.pullback`.
- **Armed reversing signal (carried):** if D3' proves materially harder than its proven unit analog
  `pullbackObjUnitToUnit_comp`, decompose it further — do NOT revive the abandoned general Lan build.

### 3. Blueprint-writer fix — malformed `\uses{\leanok …}` in `Picard_RelPicFunctor.tex` (L125–127)
A `\leanok` token sits inside the multi-line `\uses{}` argument of the `lem:rel_pic_sharp_groupoid`
proof block, breaking the dependency graph (blueprint-doctor finding) and (since `addCommGroup` now has
4 sorries) functioning as a spurious proof-block marker that `sync_leanok` cannot strip (it is hidden
inside `\uses{}`). Introduced by this iter's plan-side edit. Have a blueprint-writer reflow the block
so the `\uses{}` argument is a clean comma-list and the `\leanok` is removed (the proof is not
sorry-free). The review agent did not touch it (no-`\leanok` rule).

## MEDIUM

- **Add a `\lean{}` pin (plan-agent hint) for the landed D2' assembly lemma.** The new
  `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` has no blueprint pin yet; the existing
  `lem:pullback_tensor_iso_unit` is pinned to the *unconditional* `pullbackTensorMap_unit_isIso` (not
  yet built). Consider a forward block / sub-lemma pin so the landed conditional reduction is tracked.
- **Update the RPF chapter prose to match the realized carrier.** The Step 2–4 prose
  (`pullbackHom`, `H_T`, setoid reconciliation, transport) describes a different future carrier than
  the iso-class quotient the Lean side actually uses; a writer pass should reconcile (annotated this
  iter with a `% NOTE:`).

## Blocked — do NOT re-assign without a structural change first
- **RPF `addCommGroup` via "cite TensorObjSubstrate"** — import cycle (see #1). Blocked until the
  architecture is fixed. Re-dispatching the same recipe produces another infeasible round.
- **`isLocallyTrivial_unit` (RPF L329)** — math is trivial but blocked by an undiagnosed Mathlib
  `IsIso (pullbackObjUnitToUnit φ)` instance-resolution quirk for `φ = W.ι.toRingCatSheafHom` (resolves
  fine inside `IsLocallyTrivial.pullback`). If the substrate is relocated upstream (#1a), this bridge
  may resolve naturally via the existing `IsLocallyTrivial.pullback` machinery; otherwise it needs a
  dedicated `set_option trace.Meta.synthInstance true` diagnosis, not a blind retry.
- General strong-monoidal pullback build (`pullback₀ = Lan` colimit model, D2/D3) — ABANDONED
  iter-243, off-path. Do NOT revive (only line bundles are consumed).
- Forward bridge `IsInvertible ⟹ IsLocallyTrivial` — Mathlib-scale + off-path. Do NOT build.

## Reusable proof patterns discovered this iter
- **Reading a morphism-property equality backwards** to get a converse iso-localizer lemma
  (`W_of_isIso_sheafification` from `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`).
- **Unitor + sheafify route to reduce a δ-on-the-unit-pair to a whiskered-η factor**
  (`left_unitality_hom` + flatness-free `W_whiskerRight_of_W` — no stalkwise δ).
- **`nsmul := nsmulRec` / `zsmul := zsmulRec` via a `letI` Zero/Add/Neg block** when building an
  `AddCommGroup` instance whose `AddMonoid.nsmul` has no field default.
- **Elaboration:** `letI φ'` with the explicit `(… ⋙ forget₂ CommRingCat RingCat) ⟶ …` type to pin
  keyed monoidal-category instances; `change` not `show`; avoid identifiers containing `λ` (parser).
