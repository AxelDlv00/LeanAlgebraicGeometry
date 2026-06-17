# Lean ↔ Blueprint Check Report

## Slug
dualinverse

## Iteration
001

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (1195 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (checked `sec:tensorobj_dual_bridge` region, L4472–L5236, plus helper subsection L4650–L4848)

---

## Per-declaration

Sixteen `\lean{...}` pins were found in the relevant chapter region. Each is checked below.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` (lem:slice_dual_transport)

- **Lean target exists**: yes (L407, `noncomputable def sliceDualTransport`)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) (V : (Opens Y)ᵒᵖ)` returning a `ModuleIso` between the two pushforward-dual section values. Matches the blueprint's `O_Y(V)`-linear iso statement.
- **Proof follows sketch**: partial — leg (A) (categorical `restrictScalars.map` reindexing) is closed; leg (B) (`dualUnitRingSwap`) is closed; `map_add'` and `map_smul'` are closed. Three fields remain as known-open sorries:
  - L525: `naturality` of the `toFun` section family (requires ε-naturality of `restrictScalars` along the structure-ring iso — the genuine `sliceDualTransport.naturality` obligation)
  - L627: `left_inv` (round-trip, blocked on sorried `sliceDualTransportInv.naturality`)
  - L629: `right_inv` (mirror of L627)
- **notes**: Blueprint proof block has **no** proof-block `\leanok`, so none of these fields are claimed closed. The 3 sorries are the known-open frontier per directive. No must-fix.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv}` (lem:slice_dual_transport_inv)

- **Lean target exists**: yes (L298, `noncomputable def sliceDualTransportInv`)
- **Signature matches**: yes — takes `f`, `M`, `V`, `β`, `hβ` (β-compatibility), and `ψ` (a dual section over `Over V`), returns a section over `Over fV`. Matches the blueprint's reverse-transport description.
- **Proof follows sketch**: partial — `app` component is fully closed (axiom-clean per L322–378), including the cross-fiber transport, collapse, and `unitRelabelSwap`. One known-open sorry:
  - L388: `naturality` of the reverse component (thin-poset `Subsingleton.elim` + ε-naturality paste, mirrors the still-open forward `sliceDualTransport.naturality`)
- **notes**: Blueprint proof block has **no** proof-block `\leanok`. The 1 sorry is the known-open frontier.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (lem:dual_restrict_iso)

- **Lean target exists**: yes (L728, `noncomputable def dual_restrict_iso`)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules)` → `(dual M).restrict f ≅ dual (M.restrict f)`. Matches the blueprint iso statement exactly.
- **Proof follows sketch**: yes — follows the four-step H1→Step4 recipe (Step 1: `restrictFunctorIsoPullback`, Step 2: `sheafificationCompPullback`, Step 3: `sheafification.mapIso`, Step 4: `PresheafOfModules.isoMk` applied to `sliceDualTransport`). The outer `isoMk` naturality is closed by `subsingleton` (thin-poset coherence). Transitively inherits the `sliceDualTransport` sorries but has no direct sorry of its own.
- **notes**: Blueprint has statement-block `\leanok` (declaration formalized). No proof-block `\leanok` (proof not claimed closed). Consistent with transitively-partial status.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (lem:dual_isLocallyTrivial)

- **Lean target exists**: yes (L838, `lemma dual_isLocallyTrivial`)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) → LineBundle.IsLocallyTrivial (dual L)`. Matches blueprint.
- **Proof follows sketch**: yes — exactly the three-step chain from the blueprint: `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` at L847. No direct sorry.
- **notes**: Transitively depends on `dual_restrict_iso` (which depends on `sliceDualTransport`). Blueprint has statement-block `\leanok`; no proof-block `\leanok`. Consistent.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` (lem:isiso_eps_restrictscalars_appiso)

- **Lean target exists**: yes (L179)
- **Signature matches**: yes — `IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom))`.
- **Proof follows sketch**: yes — one-liner via `restrictScalars_isIso_ε_of_bijective` + `ConcreteCategory.bijective_of_isIso`. No sorry.
- **notes**: `\leanok` on both statement and proof blocks in blueprint. Verified clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom}` (lem:isiso_eps_restrictscalars_appiso_hom)

- **Lean target exists**: yes (L237)
- **Signature matches**: yes — `.hom.hom` direction of `appIso`. Mirror of the above.
- **Proof follows sketch**: yes — identical proof pattern. No sorry.
- **notes**: `\leanok` on both blocks in blueprint.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` (def:dual_unit_ring_swap)

- **Lean target exists**: yes (L193)
- **Signature matches**: yes — `(ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom).obj (𝟙_ ...) ⟶ 𝟙_ (ModuleCat ↑(Y.presheaf.obj (op W')))`. Matches blueprint's `restrictScalars (f.appIso W')⁻¹ (1_X(fW')) → 1_Y(W')`.
- **Proof follows sketch**: yes — `inv(ε(...))` via `isIso_ε_restrictScalars_appIso`. No sorry.
- **notes**: `\leanok` on both blocks in blueprint.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv}` (def:dual_unit_ring_swap_inv)

- **Lean target exists**: yes (L208)
- **Signature matches**: yes — `𝟙_ (ModuleCat Y.presheaf(W')) ⟶ restrictScalars(appIso.inv.hom)(1_X(fW'))`. Matches blueprint.
- **Proof follows sketch**: yes — `Functor.LaxMonoidal.ε(...)` directly. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom}` (def:dual_unit_ring_swap_hom)

- **Lean target exists**: yes (L249)
- **Signature matches**: yes — `.hom.hom` direction codomain swap, `restrictScalars(appIso.hom.hom)(1_Y(W')) ⟶ 1_X(fW')`. Matches blueprint.
- **Proof follows sketch**: yes — `inv(ε(restrictScalars(appIso.hom.hom)))`. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_comp_dualUnitRingSwapInv}` (lem:dual_unit_ring_swap_comp_inv)

- **Lean target exists**: yes (L225)
- **Signature matches**: yes — `dualUnitRingSwap f W' ≫ dualUnitRingSwapInv f W' = 𝟙 _` (Swap ∘ Inv = id). Matches.
- **Proof follows sketch**: yes — `simp [dualUnitRingSwapInv, dualUnitRingSwap]`. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapInv_comp_dualUnitRingSwap}` (lem:dual_unit_ring_swap_inv_comp)

- **Lean target exists**: yes (L217)
- **Signature matches**: yes — `dualUnitRingSwapInv f W' ≫ dualUnitRingSwap f W' = 𝟙 _` (Inv ∘ Swap = id). Matches.
- **Proof follows sketch**: yes — same `simp` pattern. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{PresheafOfModules.unitDualSectionEquiv}` (def:unit_dual_section_equiv)

- **Lean target exists**: yes (L84)
- **Signature matches**: yes — `(restr X.unop 1 ⟶ restr X.unop 1) ≃ₗ[R₀.obj (op X.unop)] R₀.obj (op X.unop)`. Matches blueprint's R₀(X)-linear equivalence identifying unit endomorphisms with the ground ring.
- **Proof follows sketch**: yes — `toFun = evalLin(1)`, `invFun = globalSMul`, `left_inv` via `naturality_apply` + terminal-map uniqueness. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{PresheafOfModules.dualUnitIsoGen}` (def:dual_unit_iso_gen)

- **Lean target exists**: yes (L126)
- **Signature matches**: yes — `dual (1_ PresheafOfModules) ≅ 1_ PresheafOfModules` over general `R₀`. Assembled sectionwise from `unitDualSectionEquiv` via `isoMk`.
- **Proof follows sketch**: yes — `PresheafOfModules.isoMk (fun X => (unitDualSectionEquiv X).toModuleIso) (naturality proof)`. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso}` (def:presheaf_dual_unit_iso)

- **Lean target exists**: yes (L769)
- **Signature matches**: yes — `PresheafOfModules.dualUnitIsoGen (R₀ := Y.presheaf)`. Matches blueprint's scheme-level instance.
- **Proof follows sketch**: yes — one-liner. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (lem:dual_unit_iso)

- **Lean target exists**: yes (L780)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`. Matches.
- **Proof follows sketch**: yes — `sheafification.mapIso presheafDualUnitIso ≪≫ asIso(counit).app unit`. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` (lem:image_preimage_of_le)

- **Lean target exists**: yes (L942)
- **Signature matches**: yes — `(hV : V ≤ W) → W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`. Matches.
- **Proof follows sketch**: yes — `simp + inf_eq_right.mpr hV`. No sorry.
- **notes**: `\leanok` on both blocks.

---

### `lem:sheafofmodules_hom_of_local_compat` → `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat`

- **Lean target exists**: yes (L1019, `noncomputable def homOfLocalCompat`, ~170 lines, no sorry)
- **Blueprint `\lean{}` pin exists**: **NO** — there is no `\label{lem:sheafofmodules_hom_of_local_compat}` or `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` anywhere in the blueprint `.tex` source.
- **Blueprint reference**: `homOfLocalCompat` appears only as `\texttt{sheafofmodules\_hom\_of\_local\_compat}` in prose at `rem:dual_discharges_inverse` (L5255), and as an auto-scanned entry in `blueprint/lean_decls:502` and the dep-graph HTML. No formal blueprint block exists.
- **Stale docstring cross-reference**: The Lean docstring for `homOfLocalCompat` states "Blueprint `lem:sheafofmodules_hom_of_local_compat` (~L5592)". But L5592 in the blueprint is `lem:toringcatsheafhom_comp_hom_reconcile` — an entirely different lemma about composite ring-map reconciliation. The line number is stale/wrong.
- **Signature check**: N/A (no blueprint statement to compare against).
- **Proof follows sketch**: N/A (no blueprint proof sketch to compare against).
- **notes**: This is a **major** blueprint adequacy failure — see below.

---

## Red flags

### Placeholder / suspect bodies

None. The four known-open sorries (L388, L525, L627, L629) are in `sliceDualTransportInv.naturality` and `sliceDualTransport.{naturality,left_inv,right_inv}`. The blueprint does **not** claim these fields are closed (no proof-block `\leanok` on any of these lemmas). Per directive, these are tracked open frontier and are not reportable as placeholders.

No `:= sorry` or `:= True`-style bodies appear on declarations whose blueprint entries claim substantive closure.

### Excuse-comments

None. The file carries extensive planning commentary (strategy notes, iter numbers, route descriptions). These document proof strategy and progress; none claim a definition is intentionally wrong or temporary.

One stale comment at L754–757 says `sliceDualTransport`'s `.hom` is "currently a `sorry`" and the `isoMk` naturality square "cannot be discharged yet." The square is then discharged by `subsingleton` on L762. This is documentation drift (the comment predates the successful tactic), not an excuse-comment on a wrong definition.

### Axioms / Classical.choice on non-trivial claims

None found. No `axiom` declarations in the file. No suspicious `Classical.choice _` patterns on substantive claims.

---

## Unreferenced declarations (informational)

| Declaration | Line | Assessment |
|---|---|---|
| `isIso_ε_restrictScalars_presheafMap` | L262 | Internal helper for `unitRelabelSwap`; analogous to the pinned `isIso_ε_restrictScalars_appIso`. Acceptable as unpinned sub-helper. |
| `unitRelabelSwap` | L274 | Internal helper: `inv(ε(restrictScalars(presheaf.map(eqToHom e))))`. Used in `sliceDualTransportInv`'s `?unit` case. Analogous to `dualUnitRingSwap` but for `eqToHom`-induced ring maps. No blueprint entry; `lem:slice_dual_transport_inv`'s proof sketch implicitly covers it. Acceptable as unpinned sub-helper. |
| `homLocalSection` | L861 | Non-trivial helper (~50 lines). Blueprint mentions it as `\mathtt{homLocalSection}` in the proof prose of `lem:slice_dual_transport_inv` (L4884) and `lem:image_preimage_of_le` (L5229) but no formal `\lean{}` pin exists. Should have a blueprint pin given its role in the `homOfLocalCompat` gluing argument. |
| `topSectionToHom` | L918 | Helper converting a `presheafHom` section over `⊤` to a global morphism. No blueprint pin. |
| `topSectionToHom_app` | L931 | Sectionwise evaluation lemma for `topSectionToHom`. No blueprint pin. |

The last three (`homLocalSection`, `topSectionToHom`, `topSectionToHom_app`) are the building blocks of `homOfLocalCompat` and their absence from the blueprint is part of the same gap identified in the per-declaration section.

---

## Blueprint adequacy for this file

- **Coverage**: 16 / ~22 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 2 internal sub-helpers (acceptable), 3 notable helpers + 1 substantive declaration missing pins (flagged).

- **Proof-sketch depth**: **adequate** for all 16 pinned declarations. The proof sketches for `lem:slice_dual_transport` and `lem:slice_dual_transport_inv` are exceptionally detailed (full leg decomposition, instance obstacle notes, scalar-identity step-by-step breakdown). A prover can follow them directly.

- **Hint precision**: **precise**. Every `\lean{...}` hint names the correct fully-qualified Lean declaration. No ambiguity in predicate choice.

- **Generality**: **matches need**. The declarations are phrased at the right level of generality throughout.

- **Blueprint adequacy gap — `homOfLocalCompat`**: The declaration at L1019 is a 170-line gluing engine (the A-bridge: compatible local `𝒪_X`-module morphisms → global morphism). It has no `\label` or `\lean{}` entry in the blueprint chapter. The blueprint mentions it only by `\texttt{...}` name in a remark. A prover approaching this file from the blueprint would find no guidance for this substantial declaration. Given that the blueprint is otherwise very detailed, this omission is notable.

- **Recommended chapter-side actions**:
  1. Add a formal blueprint block for `homOfLocalCompat`: `\label{lem:sheafofmodules_hom_of_local_compat}`, `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}`, and a proof sketch covering the two-step gluing argument (sheaf-of-types gluing of the ab-presheaf morphism via `presheafHom`/`existsUnique_gluing`, then `homMk` for `𝒪_X`-linearity).
  2. Optionally add `\lean{}` pins for `homLocalSection` and `topSectionToHom` (they are referenced by name in the chapter prose and are substantive enough to warrant formal tracking).
  3. Correct the stale line-number reference in the `homOfLocalCompat` docstring: "Blueprint `lem:sheafofmodules_hom_of_local_compat` (~L5592)" should be updated once the blueprint entry is created.

---

## Severity summary

### must-fix-this-iter

None.

- The 4 sorries (L388, L525, L627, L629) are the known-open tracked frontier. Blueprint does not claim these fields closed (no proof-block `\leanok`).
- No signature mismatches with blueprint prose.
- No axioms.
- No excuse-comments on claimed-closed declarations.
- No weakened/wrong definitions.

### major

- **`homOfLocalCompat` missing blueprint pin**: The declaration `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` (L1019, ~170 lines, no sorry, axiom-clean) has no `\label{...}` / `\lean{...}` entry in the blueprint. A blueprint-writing subagent should add the missing block. The stale `~L5592` cross-reference in the Lean docstring should be corrected simultaneously.

### minor

- **Stale in-file comment** at L754–757: documents `sliceDualTransport`'s naturality as "cannot be discharged yet" but the outer `isoMk` naturality is immediately discharged by `subsingleton` on L762. The comment predates the successful tactic and should be pruned.
- **`homLocalSection`, `topSectionToHom`, `topSectionToHom_app`** have no blueprint `\lean{}` pins despite being mentioned by name in the chapter prose. They are helpers that support `homOfLocalCompat`. Adding them to the blueprint (alongside the `homOfLocalCompat` block) would complete coverage.

---

**Overall verdict**: 16 of 16 pinned declarations verified correct; the Lean file faithfully follows the blueprint for all pinned entries, with 4 tracked-open sorries in fields the blueprint does not claim closed. One major blueprint adequacy gap: `homOfLocalCompat` is a substantive 170-line sorry-free declaration with no blueprint entry.
