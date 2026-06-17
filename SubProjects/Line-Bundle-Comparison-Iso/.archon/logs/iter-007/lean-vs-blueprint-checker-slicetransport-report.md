# Lean ↔ Blueprint Check Report

## Slug
slicetransport

## Iteration
007

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` (lem:isiso_eps_restrictscalars_appiso)
- **Lean target exists**: yes (L137)
- **Signature matches**: yes — `IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom))` matches "ε of restrictScalars at the inv-direction ring map is an isomorphism"
- **Proof follows sketch**: yes — uses `restrictScalars_isIso_ε_of_bijective` fed `ConcreteCategory.bijective_of_isIso`, exactly as the blueprint sketches
- **notes**: Blueprint has `\leanok` on statement and proof blocks; consistent with a fully closed proof (no sorry).

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom}` (lem:isiso_eps_restrictscalars_appiso_hom)
- **Lean target exists**: yes (L214)
- **Signature matches**: yes — `.hom.hom` direction variant matching the blueprint description
- **Proof follows sketch**: yes — identical structure to the inv-direction; blueprint says "identical … with hom-direction"
- **notes**: Fully closed, no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` (def:dual_unit_ring_swap)
- **Lean target exists**: yes (L151)
- **Signature matches**: yes — `(ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom).obj (𝟙_ ...) ⟶ 𝟙_ ...` matches blueprint `inv(ε(restrictScalars (f.appIso W').inv.hom)) : restrictScalars(f.appIso W')⁻¹(𝟙_X(fW')) → 𝟙_Y(W')`
- **Proof follows sketch**: yes — `CategoryTheory.inv` of the lax-monoidal unit, using `isIso_ε_restrictScalars_appIso`
- **notes**: Fully closed. `\leanok` on statement and proof blocks.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv}` (def:dual_unit_ring_swap_inv)
- **Lean target exists**: yes (L166)
- **Signature matches**: yes — `𝟙_ ... ⟶ (ModuleCat.restrictScalars ...).obj (𝟙_ ...)` is the reverse direction ε itself
- **Proof follows sketch**: yes — body is `Functor.LaxMonoidal.ε (...)` directly
- **notes**: Fully closed.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` (def:dual_unit_ring_swap_hom)
- **Lean target exists**: yes (L226)
- **Signature matches**: yes — `(ModuleCat.restrictScalars (Scheme.Hom.appIso f W').hom.hom).obj (𝟙_ (ModuleCat ↑Y.presheaf(W'))) ⟶ 𝟙_ (ModuleCat ↑X.presheaf(fW'))` matches the hom-direction blueprint formula
- **Proof follows sketch**: yes — same `inv ε` pattern using `isIso_ε_restrictScalars_appIso_hom`
- **notes**: Fully closed.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_comp_dualUnitRingSwapInv}` (lem:dual_unit_ring_swap_comp_inv)
- **Lean target exists**: yes (L183, `@[simp]`)
- **Signature matches**: yes — `dualUnitRingSwap f W' ≫ dualUnitRingSwapInv f W' = 𝟙 _`
- **Proof follows sketch**: yes — `IsIso.inv_hom_id` cancellation
- **notes**: Fully closed.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv_comp_dualUnitRingSwap}` (lem:dual_unit_ring_swap_inv_comp)
- **Lean target exists**: yes (L175, `@[simp]`)
- **Signature matches**: yes — `dualUnitRingSwapInv f W' ≫ dualUnitRingSwap f W' = 𝟙 _`
- **Proof follows sketch**: yes — `IsIso.hom_inv_id` cancellation
- **notes**: Fully closed.

### `\lean{PresheafOfModules.unitDualSectionEquiv}` (def:unit_dual_section_equiv)
- **Lean target exists**: yes (L42, `namespace PresheafOfModules`)
- **Signature matches**: yes — `(restr X.unop 𝟙_ ⟶ restr X.unop 𝟙_) ≃ₗ[R₀.obj (op X.unop)] (R₀.obj (op X.unop))` matches "endomorphisms of the unit ≃ R₀(X) via evaluation at 1"
- **Proof follows sketch**: yes — `toFun = evalLin ... 1`, `invFun = globalSMul`, `left_inv` uses `naturality_apply` toward the terminal object of the slice
- **notes**: Fully closed.

### `\lean{PresheafOfModules.dualUnitIsoGen}` (def:dual_unit_iso_gen)
- **Lean target exists**: yes (L84)
- **Signature matches**: yes — `PresheafOfModules.dual (𝟙_ ...) ≅ 𝟙_ ...` over a general single-universe base `R₀`
- **Proof follows sketch**: yes — `PresheafOfModules.isoMk` applied to `unitDualSectionEquiv`, with naturality closed using `naturality_apply` at `M = 𝟙_`
- **notes**: Fully closed.

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv}` (lem:slice_dual_transport_inv)
- **Lean target exists**: yes (L354)
- **Signature matches**: **partial** — see major finding below
- **Proof follows sketch**: partial — `app` component is closed (the 4-piece composite `M.val.map(eqToHom) ≫ restrictScalars(hom).map(ψ.app) ≫ dualUnitRingSwapHom` matches the blueprint formula); `naturality` has the **known** open sorry (L444)
- **notes**: The Lean signature takes two extra parameters vs. the blueprint: an explicit `β : Y.ringCatSheaf.obj ⟶ ...` and a compatibility hypothesis `hβ : ∀ P, ((β.app (op P)).hom).comp ((f.appIso P).hom.hom) = RingHom.id _`. The blueprint fixes β as "the open-immersion structure ring morphism" and never mentions `hβ`. See major finding under Blueprint adequacy.

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (lem:slice_dual_transport)
- **Lean target exists**: yes (L499)
- **Signature matches**: yes — `(((PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)).obj V) ≅ ((PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)).obj V)` with β set locally from f; matches blueprint's O_Y(V)-linear isomorphism between the two section values
- **Proof follows sketch**: partial — `toFun` (L587–605), `map_add'` (L628–636), `map_smul'` (L658–690), `invFun` (L713–721) are closed; `left_inv` (L724) and `right_inv` (L726) have the **known** open sorries
- **notes**: Naturality closed in iter-007 via extracted `sliceDualTransport_naturality_apply`. `\leanok` on statement block only (no `\leanok` on proof block); consistent with open sorries.

---

## Red flags

### Placeholder / suspect bodies
All three `sorry`s are pre-reported known open holes:
- `sliceDualTransportInv` L444: naturality (known open, `fill via analogies/dualnat006.md`)
- `sliceDualTransport` L724: `left_inv` (known open, `fill via analogies/dualnat006.md`)
- `sliceDualTransport` L726: `right_inv` (known open, `fill via analogies/dualnat006.md`)

No unexpected sorries found. No axioms, no `Classical.choice` on non-trivial claims.

### Excuse-comments
None of the `-- REPAIR: sorry inserted at broken proof site` comments exceed the pre-reported scope. The comments clearly label these as known open holes, not as wrong permanent code. No "wrong but works for now" or "replace with real def" patterns.

---

## Unreferenced declarations (informational)

The following declarations in SliceTransport.lean have no `\lean{...}` reference in the blueprint chapter. All are purely internal helpers:

| Declaration | Line | Notes |
|---|---|---|
| `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_apply` | 192 | Pointwise computation lemma; feeds `sliceDualTransport_naturality_apply` |
| `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_presheafMap` | 263 | ε-invertibility for eqToHom relabel; feeds `unitRelabelSwap` |
| `AlgebraicGeometry.Scheme.Modules.unitRelabelSwap` | 275 | Unit codomain transport for the cross-fiber relabel in `sliceDualTransportInv` |
| `AlgebraicGeometry.Scheme.Modules.unitRelabelSwap_apply` | 287 | Pointwise computation for `unitRelabelSwap` |
| `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom_apply` | 239 | Pointwise computation for `dualUnitRingSwapHom` |
| `AlgebraicGeometry.Scheme.Modules.appIso_hom_naturality_apply` | 315 | Ring-level naturality square for `(f.appIso).hom`; feeds `sliceDualTransport_naturality_apply` |
| `AlgebraicGeometry.Scheme.Modules.sliceDualTransport_naturality_apply` | 453 | Extracted standalone naturality lemma for `sliceDualTransport.toFun`; split out for heartbeat reasons |

Of these, `unitRelabelSwap` and `appIso_hom_naturality_apply` are substantive enough to warrant a brief mention in the blueprint (they are load-bearing sub-constructions, not merely arithmetic lemmas). `sliceDualTransport_naturality_apply` was explicitly extracted for elaboration-budget reasons and should ideally be documented.

---

## Blueprint adequacy for this file

- **Coverage**: 11/11 blueprint-referenced `\lean{...}` declarations present. 7 unreferenced helper declarations (all acceptable helpers, 2–3 potentially worth brief blueprint mentions).
- **Proof-sketch depth**: **under-specified** on two points (see below); otherwise adequate. The main constructions (`sliceDualTransport` forward path, helper lemmas) are well-sketched.
- **Hint precision**: **precise** — `\lean{...}` names are exact and all resolve.
- **Generality**: **partial mismatch** — `sliceDualTransportInv` is more general in the Lean (parametrized by `β` + `hβ`) than described in the blueprint (where β is treated as fixed). The blueprint is too narrow.

### Blueprint adequacy findings

**Finding B1 — `sliceDualTransportInv` missing `hβ` hypothesis (major)**

The blueprint (lem:slice_dual_transport_inv, lines 4974–5031) describes `sliceDualTransportInv` as taking `f`, `M`, `V`, `β`, `ψ` with `β` fixed as "the open-immersion structure ring morphism". The Lean signature additionally takes:
```lean
(hβ : ∀ (P : TopologicalSpace.Opens ↥Y),
    ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
```
This `hβ` is the condition that the `restrictScalarsComp'App` double-restrict collapse works, i.e., that `(β.app P) ∘ (f.appIso P).hom = id`. It is logically essential (the Lean comment notes it is "FALSE for an arbitrary β") and is explicitly discharged at the only call site via `Iso.hom_inv_id`. A blueprint reader would not anticipate this parameter and could not arrive at the parametrized form from the prose. The blueprint should add a sentence documenting that the construction requires β to satisfy the compatibility identity `(β.app P).hom ≫ (f.appIso P).hom.hom = id`, supplied as an explicit hypothesis `hβ`.

**Finding B2 — Stale `% NOTE:` comment naming wrong Lean helper for naturality (minor)**

Blueprint line 4764:
```tex
% NOTE: the Lean helper that delivers step (b) is
% `PresheafOfModules.restrictScalarsLaxε`.
```
The Lean does **not** use `PresheafOfModules.restrictScalarsLaxε` for the naturality closure. It uses the extracted lemma `sliceDualTransport_naturality_apply` (L453), which in turn uses `appIso_hom_naturality_apply` and `dualUnitRingSwap_apply`. The `% NOTE:` comment is stale and names a non-existent (or at least unused) Lean name. A prover following this note would search for `PresheafOfModules.restrictScalarsLaxε` and not find it.

**Finding B3 — `unitRelabelSwap` not mentioned in blueprint (minor)**

`unitRelabelSwap` (L275) is a substantive helper — `inv(ε(restrictScalars(X.presheaf.map(eqToHom e))))` — that provides the codomain unit transport for the cross-fiber relabel step in `sliceDualTransportInv`. The blueprint's description of the reverse component (lines 5003–5008) mentions `M.val(eqToHom)`, `restrictScalars(f.appIso P).hom.map(ψ.app)`, and `dualUnitRingSwapHom`, but does not mention the `unitRelabelSwap` that handles the target-side relabel. This omission means the blueprint's component formula is incomplete (it describes 3 of the 4 legs).

**Finding B4 — `sliceDualTransport_naturality_apply` extraction not mentioned in blueprint (minor)**

The blueprint describes naturality of `sliceDualTransport.toFun` as a single obligation (lines 4748–4774). The Lean had to extract this as a standalone top-level lemma `sliceDualTransport_naturality_apply` (L453) because the parent definition `sliceDualTransport` hit its elaboration heartbeat limit. The blueprint does not mention this split. This is acceptable (the split is an implementation detail), but the `% NOTE:` correction in B2 should reference this lemma instead of `restrictScalarsLaxε`.

### Recommended chapter-side actions

1. **[major / B1]** In `lem:slice_dual_transport_inv`, add a sentence after the formula (line ~5008) documenting the `hβ` compatibility hypothesis: "`sliceDualTransportInv` takes an explicit ring-compatibility hypothesis `hβ : ∀ P, (β.app (op P)).hom ∘ (f.appIso P).hom.hom = id` (discharged at the call site via `Iso.hom_inv_id` when β is the open-immersion structure map)."
2. **[minor / B2]** Replace the stale `% NOTE:` at line 4764 with the correct Lean names: `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport_naturality_apply}` (which uses `appIso_hom_naturality_apply` and `dualUnitRingSwap_apply`).
3. **[minor / B3]** Add a brief mention of `unitRelabelSwap` to the component formula of `lem:slice_dual_transport_inv`, as the 4th leg `unitRelabelSwap(eqToHom he.symm)` carrying the codomain unit across the cross-fiber relabel.

---

## Severity summary

- **must-fix-this-iter**: none (all open sorries are pre-reported; no wrong signatures, no placeholder bodies on substantive claims, no unauthorized axioms)
- **major**: 1 — blueprint for `sliceDualTransportInv` omits `hβ` compatibility hypothesis (B1), making the blueprint inadequate for arriving at the correct Lean API
- **minor**: 3 — stale `% NOTE:` naming wrong Lean helper (B2); `unitRelabelSwap` 4th leg missing from component formula (B3); `sliceDualTransport_naturality_apply` extraction unmentioned (B4)

**Overall verdict**: The Lean file faithfully implements the blueprint mathematics with all declared signatures correct and the 3 known open sorries pre-reported; the blueprint is adequate for the main constructions but under-documents `sliceDualTransportInv`'s `hβ` hypothesis and carries a stale `% NOTE:` naming a non-existent Lean helper.
