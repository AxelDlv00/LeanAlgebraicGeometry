# Lean ↔ Blueprint Check Report

## Slug
iter197-h1v

## Iteration
197

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.IsFlasque}` (def:isFlasque_sheaf)
- **Lean target exists**: yes — L98–103
- **Signature matches**: yes — `∀ ⦃U V⦄ (h : V ≤ U), Function.Surjective ((F.val.map (homOfLE h).op).hom)` matches blueprint "restriction map is surjective for every V ⊆ U"
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean; `\leanok` on statement correct.

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.pushforward}` (lem:isFlasque_pushforward)
- **Lean target exists**: yes — L118–125
- **Signature matches**: yes
- **Proof follows sketch**: yes — blueprint says "restriction of f_*F along V ⊆ U is by definition restriction of F along f⁻¹V ⊆ f⁻¹U"; Lean proof is exactly `hF ((Opens.map f).map (homOfLE h)).le`. Axiom-clean.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.constant_of_irreducible}` (lem:isFlasque_constant_irreducible)
- **Lean target exists**: yes — L138–178
- **Signature matches**: yes
- **Proof follows sketch**: partial — empty branch closed axiom-clean at L156–176; non-empty branch is `:= sorry` at L178.
- **notes**: Pre-existing standing sorry (not new from iter-197). Authorized and documented in blueprint `% NOTE (iter-197 lean-vs-blueprint-checker M-1)` at lines 183–219, which describes Routes A and B. Statement has `\leanok`; proof block does not. **See Strategy-modifying finding below: prover's Route C recommendation not yet in blueprint.**

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque}` (lem:flasque_cokernel_short_exact)
- **Lean target exists**: yes — L578–595
- **Signature matches**: yes — blueprint's lift-via-h_b / extend-via-hI / naturality-pushthrough matches the Lean proof exactly.
- **Proof follows sketch**: yes. Axiom-clean.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.ext_succ_eq_zero_of_injective_of_lower_zero}` (lem:ext_succ_zero_of_injective_lower_zero)
- **Lean target exists**: yes — L307–321
- **Signature matches**: yes
- **Proof follows sketch**: yes — degree-shift via `HasInjectiveDimensionLT.subsingleton` + `covariant_sequence_exact₁` matches blueprint sketch. Axiom-clean.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.injective_flasque}` (lem:isFlasque_injective)
- **Lean target exists**: yes — L613–618
- **Signature matches**: yes
- **Proof follows sketch**: no — body is `:= sorry`
- **notes**: Pre-existing standing sorry (not new from iter-197). j_! gap documented in blueprint `% NOTE (iter-197 lean-vs-blueprint-checker J-2)` at lines 347–366. Statement has `\leanok`; proof block does not.

---

### `\lean{AlgebraicGeometry.Scheme.HModule_flasque_eq_zero}` (thm:H1_vanishing_flasque)
- **Lean target exists**: yes — L768–778
- **Signature matches**: yes
- **Proof follows sketch**: yes — Hartshorne III.2.5 induction delegated to private `HModule_flasque_subsingleton_aux`; the i=1 case uses `ext_one_eq_zero_of_hom_surjective_of_injective`, the i≥2 case uses `ext_succ_eq_zero_of_injective_of_lower_zero`. Structure mirrors blueprint Steps 1–4 exactly.
- **notes**: No sorry in this declaration itself. Transitive sorry dependency via `injective_flasque` (authorized). Statement and proof blocks both have `\leanok` consistent with axiom-clean structural body.

---

### `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_eq_pushforward_const}` (lem:skyscraperSheaf_eq_pushforward)
- **Lean target exists**: yes — L1015–1058
- **Signature matches**: partial — blueprint prose says "is isomorphic to"; Lean conclusion is `Nonempty (skyscraperSheaf P A ≅ ...)`. This wrapper is documented in blueprint `% NOTE (iter-197 lean-vs-blueprint-checker M-2)` at lines 517–534.
- **Proof follows sketch**: yes — outer presheaf equality via `ObjectProperty.FullSubcategory.ext` (L1034–1040) and inner iso via `Scheme.skyscraperSheaf_iso_constantSheaf_punit` (L1051) exactly match the blueprint's two-step structure.
- **notes**: **Now fully axiom-clean** per iter-197 (inner sorry closed by `skyscraperSheaf_iso_constantSheaf_punit`). `\leanok` on both statement and proof blocks is correct. However the blueprint's `% NOTE M-2` (lines 517–534) contains a stale clause — see Red Flags below.

---

### `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_iso_constantSheaf_punit}` (lem:skyscraperSheaf_iso_constantSheaf_punit) — **NEW iter-197**
- **Lean target exists**: yes — L907–977 (`noncomputable def Scheme.skyscraperSheaf_iso_constantSheaf_punit`)
- **Signature matches**: yes — returns `skyscraperSheaf PUnit.unit A ≅ (constantSheaf ...).obj A` exactly as the blueprint states.
- **Proof follows sketch**: partial — blueprint describes Route A (preferred: `constantSheafAdj.homEquiv.symm`) as the forward map; the Lean proof uses Route B: direct presheaf morphisms `betaSkyToConstPUnit` (hom direction) and `sheafifyLift (alphaConstToSkyPUnit)` (inv direction), with the composition identity `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` as the key lemma. Mathematical content is correct; proof-strategy divergence from blueprint's preferred route.
- **notes**: Axiom-clean. Blueprint `\leanok` on both statement and proof blocks correct. Minor: the three helper declarations (`alphaConstToSkyPUnit`, `betaSkyToConstPUnit`, `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify`) used in this proof are not `\lean{...}`-pinned in the blueprint — acceptable as helpers, but the blueprint proof sketch should reference them by name.

---

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.closure_isIrreducible}` (lem:closedPoint_closure_irreducible)
- **Lean target exists**: yes — L1072–1075
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-liner `isIrreducible_singleton.closure`. Axiom-clean.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_isFlasque}` (lem:skyscraperSheaf_isFlasque)
- **Lean target exists**: yes — L1099–1135
- **Signature matches**: yes
- **Proof follows sketch**: partial — blueprint describes four-lemma chain; Lean uses direct `skyscraperPresheaf_map` case split (P∈V: eqToHom iso → surjective; P∉V: codomain terminal → Subsingleton). Divergence documented in blueprint `% NOTE (iter-197 lean-vs-blueprint-checker J-1)` at lines 711–726.
- **notes**: Axiom-clean. `\leanok` on statement and proof blocks consistent with Lean state. Proof-route divergence is minor and documented.

---

### `\lean{AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero}` (lem:H1_skyscraperSheaf_finrank_eq_zero_main)
- **Lean target exists**: yes — L1161–1172
- **Signature matches**: yes
- **Proof follows sketch**: yes — single-line `Scheme.HModule_flasque_eq_zero (Scheme.skyscraperSheaf_isFlasque C P) 1 le_rfl`. Axiom-clean at this declaration.
- **notes**: Clean.

---

## Red Flags

### Placeholder / suspect bodies

**`Scheme.IsFlasque.constant_of_irreducible` — L178: non-empty branch `:= sorry`**
- Blueprint claims substantive proof; proof block lacks `\leanok`. Standing sorry, authorized/documented (Routes A and B in `% NOTE` lines 183–219). Pre-existing; not introduced in iter-197. The iter-197 prover's Route C recommendation (stalk-based) is not yet in the blueprint — see Strategy-modifying finding.

**`Scheme.IsFlasque.injective_flasque` — L613–618: body `:= sorry`**
- Blueprint claims substantive proof (Hartshorne III Lemma 2.4); proof block lacks `\leanok`. Standing sorry, authorized/documented (j_! gap, `% NOTE` lines 347–366). Pre-existing; not introduced in iter-197.

### Stale-note findings (minor)

**Blueprint `% NOTE (iter-197 lean-vs-blueprint-checker M-2)` (lines 517–534) — partially stale**

The clause "which itself carries a typed sorry pending the Mathlib gap discussed there" is now incorrect: `Scheme.skyscraperSheaf_iso_constantSheaf_punit` was constructed axiom-clean in iter-197 (no sorry). The `Nonempty` wrapper part of the note remains accurate. Also, the line-number reference "L818" is stale; the declaration is at L1015 in the current file.

*Recommended blueprint action*: Update the `% NOTE M-2` clause to read "which is now constructed axiom-clean in iter-197 via `alphaConstToSkyPUnit` / `betaSkyToConstPUnit`" and correct the line number.

**Lean file docstring for `Scheme.skyscraperSheaf_eq_pushforward_const` (L994–1013) — stale iter-196 note**

The Lean docstring contains "**iter-196 Lane H prover attempt** — partial structural skeleton" and "The remaining gap is the inner iso, which needs ~50-80 LOC." Both are stale: the inner iso gap was closed axiom-clean in iter-197 by `Scheme.skyscraperSheaf_iso_constantSheaf_punit`.

*Note*: This is in the Lean file docstring, not the blueprint. Since this checker is read-only, it cannot update the Lean file; flagged here for the review agent.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` pin. Most are helpers; those whose names suggest blueprint-worthy status are noted:

| Declaration | Lines | Status |
|---|---|---|
| `Scheme.HModule_injective_finrank_eq_zero` | L198–207 | Helper for flasque-subsingleton-aux |
| `Scheme.injectiveSES` | L215–223 | Helper |
| `Scheme.injectiveSES_shortExact` | L226–234 | Helper |
| `ext_one_eq_zero_of_hom_surjective_of_injective` | L258–288 | ~30-line LES lemma; substantive, used in aux |
| `sheafCompose_additive` | L348–363 | Infrastructure |
| `sheafCompose_preservesZero` | L366–372 | Infrastructure |
| `sheafCompose_preservesFiniteLimits` | L390–410 | Infrastructure |
| `Scheme.IsFlasque.toAddCommGrpCat` | L422–436 | Bridge helper |
| **`Scheme.IsFlasque.shortExact_app_surjective`** | L477–551 | **75-line Zorn-Lemma proof (II.1.16(b)); substantive** |
| `Scheme.HModule_flasque_subsingleton_aux` (private) | L632–728 | Private auxiliary; acceptable |
| `alphaConstToSkyPUnit` | L810–828 | Iter-197 helper for inner iso |
| `betaSkyToConstPUnit` | L831–873 | Iter-197 helper for inner iso |
| `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` | L878–901 | Iter-197 composition key lemma |

**Notable**: `Scheme.IsFlasque.shortExact_app_surjective` (the Hartshorne II.1 Ex 1.16(b) sections-surjectivity lemma) is the heaviest unpin declaration (75 lines, Zorn-based). It is referenced informally in the blueprint's proof of `thm:H1_vanishing_flasque` ("Since the leftmost term F is flasque, the long exact sequence of cohomology starts with a short exact sequence on global sections") but has no `\lean{...}` pin. Worth adding a pin in a future blueprint update.

The 3 iter-197 inner-iso helpers (`alphaConstToSkyPUnit`, `betaSkyToConstPUnit`, `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify`) are acceptable as helpers to the pinned `skyscraperSheaf_iso_constantSheaf_punit`. The blueprint's proof sketch for `lem:skyscraperSheaf_iso_constantSheaf_punit` should at minimum name them so future readers can match the Lean to the sketch.

---

## Blueprint adequacy for this file

- **Coverage**: 12/12 `\lean{...}`-pinned declarations have correct Lean implementations. 11 additional helper declarations are not pinned; only `Scheme.IsFlasque.shortExact_app_surjective` is substantive enough to warrant eventual pinning (minor).
- **Proof-sketch depth**: adequate overall. Two sorry-gated proofs (`constant_of_irreducible`, `injective_flasque`) have detailed route descriptions. The proof sketch for `skyscraperSheaf_isFlasque` diverges from the Lean (4-lemma chain vs direct presheaf-map case split) but is documented via `% NOTE J-1`.
- **Hint precision**: precise — all 12 `\lean{...}` pins name the correct Lean declaration.
- **Generality**: matches need for all declarations.
- **Recommended chapter-side actions**:
  1. (**minor**) Update `% NOTE (iter-197 lean-vs-blueprint-checker M-2)` (lines 517–534): replace "which itself carries a typed sorry pending the Mathlib gap" with "which is now constructed axiom-clean in iter-197"; correct stale line number L818 → L1015.
  2. (**minor**) Add `\lean{...}` pin or named reference to `Scheme.IsFlasque.shortExact_app_surjective` in the proof of `thm:H1_vanishing_flasque`.
  3. (**minor**) Name `alphaConstToSkyPUnit`, `betaSkyToConstPUnit`, and `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` in the proof sketch of `lem:skyscraperSheaf_iso_constantSheaf_punit` so the Route B construction is traceable.
  4. (**strategy-modifying**) Update `% NOTE (iter-197 lean-vs-blueprint-checker M-1)` (lines 183–219) for `lem:isFlasque_constant_irreducible` to document Route C — see below.

---

## ⚑ Strategy-modifying finding

**Route C for `Scheme.IsFlasque.constant_of_irreducible` — stalk-based iso bridge via `isIso_iff_stalkFunctor_map_iso`**

The blueprint's `% NOTE` for `lem:isFlasque_constant_irreducible` (lines 183–219) currently documents:
- **Route A** (preferred): provide `Full` and `Faithful` instances for `constantSheaf J D` on an irreducible space, turning the non-empty branch into a single rewrite through the unit iso.
- **Route B** (fallback): build an alternate sheaf `P'` with explicit restriction maps and exhibit an iso to `(constantSheaf J D).obj A` via universal property.

The iter-197 prover delta (from directive) reports a **fresh-approach pivot recommendation**: close the non-empty branch via a **stalk-based iso bridge using `isIso_iff_stalkFunctor_map_iso`**. The argument: to show the sheafification unit `η_U : A → ((constantSheaf J D).obj A).val.obj (op U)` is an isomorphism for non-empty `U` on an irreducible space, one shows all stalks of the two sides are isomorphic (the stalk of `(constantSheaf J D).obj A` at any point `x ∈ U` equals `A` — computed as the filtered colimit over opens containing `x`, all of which have value `A` after sheafification on an irreducible base). The Mathlib lemma `isIso_iff_stalkFunctor_map_iso` then upgrades the stalkwise-iso to a sheaf iso. This route:
  - Avoids the Mathlib `Full`/`Faithful` upstream gap (Route A's blocker)
  - Avoids the ~150-200 LOC standalone sheaf construction of Route B
  - Requires a focused stalk-colimit computation on an irreducible base (estimated ~50-80 LOC)

**Recommended iter-198 plan-agent action**: Update the `% NOTE` at lines 183–219 of `RiemannRoch_H1Vanishing.tex` to add Route C as a candidate approach (and potentially demote Route A from "preferred" given its Mathlib-upstream dependency). Assign a prover task for `constant_of_irreducible` non-empty branch targeting Route C.

---

## Severity summary

- **must-fix-this-iter**: none. Both standing sorries are authorized and correctly tracked in the blueprint; no new placeholder bodies were introduced in iter-197.
- **major**:
  - `Scheme.IsFlasque.constant_of_irreducible` L178 — standing sorry, non-empty branch. Blueprint routes A+B documented; Route C not yet added. Blocks `HModule_flasque_eq_zero` transitively.
  - `Scheme.IsFlasque.injective_flasque` L617 — standing sorry, j_! gap. Blocks higher-degree induction in `HModule_flasque_subsingleton_aux`.
- **minor**:
  - Blueprint `% NOTE M-2` (lines 517–534): stale "typed sorry" clause and line number (now closed in iter-197).
  - Lean docstring for `skyscraperSheaf_eq_pushforward_const` (L994–1013): stale iter-196 "remaining gap" language.
  - `Scheme.skyscraperSheaf_iso_constantSheaf_punit` proof uses Route B while blueprint describes Route A as preferred — mathematical content correct, route divergence undocumented.
  - `Scheme.IsFlasque.shortExact_app_surjective` (L477–551) is a substantive declaration lacking `\lean{...}` pin.
  - 3 iter-197 helpers (`alphaConstToSkyPUnit`, `betaSkyToConstPUnit`, `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify`) unnamed in blueprint proof sketch for `lem:skyscraperSheaf_iso_constantSheaf_punit`.

**Overall verdict**: The 4 new iter-197 declarations (`alphaConstToSkyPUnit`, `betaSkyToConstPUnit`, `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify`, `Scheme.skyscraperSheaf_iso_constantSheaf_punit`) are correctly implemented and axiom-clean; `Scheme.skyscraperSheaf_eq_pushforward_const` is now fully axiom-clean; the 2 pre-existing standing sorries are authorized and correctly tracked; one strategy-modifying finding (Route C for `constant_of_irreducible`) requires blueprint annotation for iter-198 planning.
