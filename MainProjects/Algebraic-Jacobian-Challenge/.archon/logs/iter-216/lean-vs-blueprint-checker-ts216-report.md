# Lean ↔ Blueprint Check Report

## Slug
ts216

## Iteration
216

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1274 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2128 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:scheme_modules_tensorobj)
- **Lean target exists**: yes
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules`; body sheafifies `PresheafOfModules.Monoidal.tensorObj M.val N.val`
- **Proof follows sketch**: yes (exact match: sheafification of presheaf-level tensor)
- **notes**: `\leanok` on statement; no sorry. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes
- **Signature matches**: yes — maps a pair of module morphisms through the sheafification of the presheaf bifunctor
- **Proof follows sketch**: yes
- **notes**: `\leanok`; no sorry. Consistent.

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (lem:restrictscalars_laxmonoidal)
- **Lean target exists**: yes (`instance restrictScalarsLaxMonoidal`)
- **Signature matches**: yes — `(PresheafOfModules.restrictScalars α).LaxMonoidal` for a morphism of presheaves of commutative rings
- **Proof follows sketch**: yes — assembled sectionwise from `ModuleCat.restrictScalars (α.app X).hom` lax structure
- **notes**: `\leanok`; no sorry; has `set_option backward.isDefEq.respectTransparency false` guards. Helper declarations `restrictScalarsLaxε`, `restrictScalarsLaxμ` are unpinned (minor).

### `\lean{restrictScalarsRingIsoTensorEquiv}` (lem:restrictscalars_ringiso_tensorequiv)
- **Lean target exists**: yes
- **Signature matches**: yes — `(e : R ≃+* S) (A B : Type u) [...] : TensorProduct R A B ≃ₗ[R] TensorProduct S A B`; forward map is `a ⊗ₜ[R] b ↦ a ⊗ₜ[S] b`
- **Proof follows sketch**: yes — forward built via `TensorProduct.lift`, inverse as additive lift via `liftAddHom` then promoted to R-linear; the non-S-linearity of the inverse is handled exactly as described
- **notes**: `\leanok`; full proof present, no sorry. Blueprint description of "inverse only additive" exactly matches the Lean construction. This is the iter-215 result; see **Unreferenced declarations** for the 6 iter-216 companions.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (lem:tensorobj_restrict_iso)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`
- **Proof follows sketch**: partial — Steps 1–3 of the blueprint are present in the Lean (reduce to pullback, move pullback inside sheafification via `SheafOfModules.sheafificationCompPullback`, strip outer sheafification). Step 4 is `sorry` with a detailed comment identifying the residual (H1: `pushforward β ≃ pullback φ`)
- **notes**: `\leanok` on statement; sorry in proof body. The iter-216 comment (lines 1162–1176) adds a **make-or-break finding** that contradicts the blueprint's "free-cover avoids H1" claim — see **Red flags** and **Blueprint adequacy** below.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (lem:tensorobj_preserves_locally_trivial)
- **Lean target exists**: yes
- **Signature matches**: yes — for locally trivial `M, N`, `tensorObj M N` is locally trivial
- **Proof follows sketch**: yes (in structure: find common affine open, restrict, use `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`)
- **notes**: `\leanok`; proof is structurally real but transitively sorry through `tensorObj_restrict_iso`. Key: the proof calls `tensorObj_restrict_iso W.ι M N` with GLOBAL arbitrary `M N` — not with free restrictions — confirming the make-or-break finding.

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat, PresheafOfModules.W_whiskerRight_of_flat}` (lem:flat_whisker_localizer)
- **Lean target exists**: yes (both)
- **Signature matches**: yes
- **Proof follows sketch**: yes — local surjectivity by right-exactness (no flatness), local injectivity via `Module.Flat.lTensor_exact`; braiding conjugation for the right-whiskered variant
- **notes**: No `\leanok` in blueprint (superseded route, off-path). Lean has full proofs. Consistent — no must-fix.

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (lem:isiso_sheafification_map_of_W)
- **Lean target exists**: yes
- **Signature matches**: yes — `hf : J.W (toPresheaf R₀).map f` → `IsIso (sheafification α).map f`
- **Proof follows sketch**: yes — one-morphism reading of `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`
- **notes**: `\leanok` on statement; full proof, no sorry. Consistent.

### `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (lem:islocallyinjective_whisker_of_W)
- **Lean target exists**: yes
- **Signature matches**: yes — `hg : J.W ((toPresheaf _).map g)` → `IsLocallyInjective J (F ◁ g)` (arbitrary F, no flatness)
- **Proof follows sketch**: N/A — sorry body; the Lean comment at lines 605–632 identifies the two open residuals (d.1-bridge, d.2) in detail
- **notes**: `\leanok` on statement (sorry present). Blueprint labels this "superseded route, off path". The sorry and the detailed residual comment are consistent with the blueprint's description. Not a must-fix contradiction.

### `\lean{PresheafOfModules.W_whiskerLeft_of_W, PresheafOfModules.W_whiskerRight_of_W}` (lem:whisker_of_W)
- **Lean target exists**: yes (both)
- **Signature matches**: yes — `hg : J.W (.map g)` → `J.W (.map (F ◁ g))`, same for right
- **Proof follows sketch**: partial — local surjectivity via `isLocallySurjective_whiskerLeft` (full proof), local injectivity via `isLocallyInjective_whiskerLeft_of_W` (sorry); braiding conjugation for right-whiskered variant
- **notes**: No `\leanok` in blueprint (superseded route). Lean proofs are real except for the sorry-dependency. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (lem:tensorobj_assoc_iso)
- **Lean target exists**: yes
- **Signature matches**: yes — `(hM hN hP : LineBundle.IsLocallyTrivial _) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`
- **Proof follows sketch**: **NO** — critical divergence; see **Red flags**
- **notes**: `\leanok` on statement. The Lean proof uses the ROUTE (d) three-step composite (`W_whiskerRight_of_W` / `W_whiskerLeft_of_W` / `isIso_sheafification_map_of_W` / presheaf associator). The current blueprint proof (rewritten this iter) describes DIRECT GLUING via two applications of `tensorobj_restrict_iso` plus the presheaf associator, explicitly stating "The construction rests on *no* whiskering of the sheafification localizer, *no* instance J.W.IsMonoidal". The Lean uses EXACTLY those whiskering lemmas. This is a **must-fix-this-iter** divergence.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (lem:tensorobj_unit_iso)
- **Lean target exists**: yes (both)
- **Signature matches**: yes
- **Proof follows sketch**: yes — cheap `mapIso` pattern using presheaf-level unitors + sheafification counit
- **notes**: No `\leanok` in blueprint (likely a sync_leanok timing issue — both have full proofs). Minor.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (lem:tensorobj_comm_iso)
- **Lean target exists**: yes
- **Signature matches**: yes — `tensorObj M N ≅ tensorObj N M`
- **Proof follows sketch**: yes — `mapIso` of the presheaf-level braiding
- **notes**: `\leanok` on statement; full proof, no sorry. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (lem:tensorobj_inverse_invertible)
- **Lean target exists**: yes
- **Signature matches**: yes — `hL : LineBundle.IsLocallyTrivial L` → `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit ...)`
- **Proof follows sketch**: N/A — sorry body; blueprint says "iter-202 scaffold"
- **notes**: `\leanok` on statement; sorry in body. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (lem:tensorobj_lift_onproduct)
- **Lean target exists**: yes
- **Signature matches**: yes — restriction of `tensorObj` to `LineBundle.OnProduct` subtype
- **Proof follows sketch**: yes — directly wraps `tensorObj` with `tensorObj_isLocallyTrivial`
- **notes**: `\leanok` on statement; no sorry (transitively sorry through `tensorObj_isLocallyTrivial`→`tensorObj_restrict_iso`). Consistent.

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (lem:pullback_compatible_with_tensorobj)
- **Lean target exists**: **no** — declaration not found in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` in blueprint (expected: not formalized). No must-fix.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (def:scheme_modules_isinvertible)
- **Lean target exists**: yes
- **Signature matches**: yes — `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement; no sorry. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (lem:tensorobj_isoclass_commgroup)
- **Lean target exists**: **no** — declaration absent from file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` in blueprint (expected: unformalized). Consistent.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (thm:rel_pic_addcommgroup_via_tensorobj)
- **Lean target exists**: yes
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`
- **Proof follows sketch**: N/A — sorry body (iter-202 scaffold)
- **notes**: `\leanok` on statement; sorry body. Blueprint has `\leanok` on statement block. Consistent.

### `\lean{PresheafOfModules.stalkLinearMap, ...stalkLinearMap_germ, ...stalkLinearMap_bijective_of_isIso, ...stalkLinearEquivOfIsIso}` (lem:stalk_linear_map)
- **Lean target exists**: yes (all four)
- **Signature matches**: yes
- **Proof follows sketch**: yes — linearity of stalk map assembled from `germ_smul`, bijectivity from `ConcreteCategory.bijective_of_isIso`, bundled as `LinearEquiv`
- **notes**: No `\leanok` in blueprint (superseded route, retained for record). All four have full proofs (no sorry). Consistent.

---

## Red flags

### Proof-method divergence on `tensorObj_assoc_iso` (must-fix)

**`AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` at lines 989–1032**: The current blueprint proof for `lem:tensorobj_assoc_iso` (rewritten this iter) says:

> "The isomorphism is assembled by *gluing canonical local isomorphisms*. The construction rests on *no* whiskering of the sheafification localizer, *no* instance J.W.IsMonoidal, and *no* stalk computation. [...] the first arrow is two applications of the restriction-compatibility isomorphism `lem:tensorobj_restrict_iso`."

The Lean proof does the OPPOSITE: it uses `W_whiskerRight_of_W` and `W_whiskerLeft_of_W` (the sheafification-localizer whiskering lemmas), `isIso_sheafification_map_of_W`, and the presheaf associator — the OLD route (d) three-step composite. It does NOT invoke `tensorObj_restrict_iso` at all. The prover comment acknowledges "ROUTE (d) three-step composite" but claims this matches the blueprint; it does not match the current (iter-216) blueprint.

Classification: **must-fix-this-iter** — the `\leanok`'d statement has a proof whose mathematical route (whiskering) directly contradicts the blueprint's stated proof method ("no whiskering"). A blueprint-writer correction is required to align the proof sketch with the actual Lean implementation (or vice versa).

### Blueprint adequacy failure — "free-cover avoids H1" claim contradicted by the make-or-break finding

The blueprint's proof for `lem:tensorobj_restrict_iso` says:
> "The PRIMARY proof obligation of the construction is therefore the free-cover specialisation of this lemma, to be discharged *without* H1."

The blueprint's proof for `lem:tensorobj_assoc_iso` says:
> "The PRIMARY proof obligation of this construction is therefore the free-cover specialisation of `lem:tensorobj_restrict_iso`, established *without* the Mathlib-absent general adjunction (H1)."

The iter-216 make-or-break comment at lines 1162–1176 of the Lean file states explicitly:
> "MAKE-OR-BREAK FINDING (iter-216): the planner's 'free-cover avoids H1' route does NOT discharge this lemma. Its consumer `tensorObj_isLocallyTrivial` applies `tensorObj_restrict_iso W.ι M N` to ARBITRARY `M N` (the `restrict` is commuted past the sheafified tensor BEFORE triviality `eM, eN` is used)."

This is confirmed by the Lean code for `tensorObj_isLocallyTrivial` (lines 1208–1211):
```lean
exact tensorObj_restrict_iso W.ι M N ≪≫
  tensorObjIsoOfIso (restrictIsoUnitOfLE hWU eM) (restrictIsoUnitOfLE hWU' eN) ≪≫
  tensorObj_unit_iso
```
`tensorObj_restrict_iso W.ι M N` is applied to the GLOBAL `M N : X.Modules`. The triviality witnesses `eM`, `eN` are only applied after `tensorObj_restrict_iso` delivers the iso of the already-globally-tensor'd object. The free-cover shortcut would require restructuring `tensorObj_isLocallyTrivial` so that triviality is applied *before* commuting the restriction — but that is not possible with the current statement of `tensorObj_restrict_iso` (the restriction lands on the GLOBAL `tensorObj M N`).

The blueprint therefore gives actively incorrect guidance: a prover reading it would believe H1 can be deferred or avoided by specialising to the free-cover case; the actual Lean code shows this is false. The chapter needs a writer correction acknowledging H1 as being on the critical path.

Classification: **must-fix-this-iter** — blueprint adequacy failure; the chapter's primary-obligation guidance directly contradicts the formalized code's consumption pattern.

### Placeholder bodies (acceptable given `\leanok` semantics)
- `tensorObj_restrict_iso` L1185: `:= sorry` — blueprint `\leanok` on statement only; proof block unmarks. Expected.
- `isLocallyInjective_whiskerLeft_of_W` L632: `:= sorry` — blueprint's superseded route. Expected.
- `exists_tensorObj_inverse` L1228: `:= sorry` — iter-202 scaffold. Expected.
- `addCommGroup_via_tensorObj` L1267: `:= sorry` — iter-202 scaffold. Expected.

None of these are "fake" in a misleading sense; all are correctly labelled in the blueprint as open obligations or scaffolds.

---

## Unreferenced declarations (informational)

The 6 new iter-216 `RestrictScalarsRingIsoTensor` section declarations have **no** `\lean{...}` pin in the blueprint. Five are substantive:

| Declaration | Nature | Classification |
|---|---|---|
| `restrictScalars_isIso_μ` (L219) | `IsIso` of the lax tensorator for `restrictScalars e.toRingHom` | **major** — pinnable in `lem:restrictscalars_ringiso_tensorequiv` |
| `restrictScalars_isIso_ε` (L237) | `IsIso` of the lax unit for `restrictScalars e.toRingHom` | **major** |
| `restrictScalarsMonoidalOfRingEquiv` (L253) | `(ModuleCat.restrictScalars e.toRingHom).Monoidal` — strong-monoidal packaging | **major** — the form consumed by the presheaf lift (next H2 step) |
| `restrictScalars_isIso_μ_of_bijective` (L266) | Bijective-ring-hom form of `restrictScalars_isIso_μ` | **major** — directly needed for presheaf NatIso componentwise application |
| `restrictScalars_isIso_ε_of_bijective` (L274) | Bijective-ring-hom form of `restrictScalars_isIso_ε` | **major** |
| `restrictScalarsRingIsoTensorEquiv_apply_tmul` (L197) | `@[simp]` lemma for forward map on simple tensors | minor (helper for above) |

Additional unpinned helpers (all minor / acceptable):
- `restrictScalarsLaxε`, `restrictScalarsLaxμ` (helpers for the pinned `restrictScalarsLaxMonoidal`)
- `toPresheaf_whiskerLeft_app_tmul`, `toPresheaf_whiskerLeft_app_apply` (helpers for the pinned flat-whisker lemmas)
- `isLocallySurjective_whiskerLeft`, `isLocallyInjective_whiskerLeft_of_flat` (named sub-steps of `W_whiskerLeft_of_flat`, arguably should be pinned in `lem:flat_whisker_localizer`)
- `tensorObjIsoOfIso` (helper for `tensorObj_isLocallyTrivial`)
- `tensorObj_unit_iso` (distinct from the pinned `tensorObj_left_unitor`/`tensorObj_right_unitor`; the O_X⊗O_X≅O_X special case)
- `restrictIsoUnitOfLE` (helper for the local triviality proof)
- `W_whiskerLeft_of_W`/`W_whiskerRight_of_W` ARE pinned (`lem:whisker_of_W`). ✓

---

## Blueprint adequacy for this file

- **Coverage**: 20/20 blueprint `\lean{...}` targets are either present in the Lean file or correctly marked as unformalized. 6 new Lean declarations from iter-216 have no blueprint pin (5 substantive, 1 simp lemma).
- **Proof-sketch depth**: **WRONG** in two places:
  1. `lem:tensorobj_assoc_iso` proof describes direct-gluing via `tensorobj_restrict_iso`; the Lean uses route (d) whiskering. The blueprint says "no whiskering"; the Lean uses exactly the whiskering lemmas.
  2. `lem:tensorobj_restrict_iso` proof claims "free-cover avoids H1 for the primary obligation"; the actual Lean consumer `tensorObj_isLocallyTrivial` applies `tensorObj_restrict_iso` to arbitrary modules, meaning H1 is on the critical path.
- **Hint precision**: **loose** for `lem:restrictscalars_ringiso_tensorequiv` — the blueprint pins `restrictScalarsRingIsoTensorEquiv` but the H2 residual involves `restrictScalarsMonoidalOfRingEquiv` (strong-monoidal packaging) and the bijective-hom forms, which are the bridge to the presheaf lift; without these being named, a blueprint reader cannot identify what remains to close H2.
- **Generality**: matches need for the pinned declarations; the strong-monoidal packaging (`restrictScalarsMonoidalOfRingEquiv`) is present in the Lean but not reflected in the blueprint.
- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. **MUST FIX**: Correct the "free-cover avoids H1" claim in `lem:tensorobj_restrict_iso` proof and `lem:tensorobj_assoc_iso` proof. Replace with: "H1 (presheaf-level `pushforward β ≃ pullback φ` adjunction) is on the critical path because `tensorObj_isLocallyTrivial` calls `tensorObj_restrict_iso W.ι M N` on ARBITRARY `M N`; the free-cover shortcut fails because restriction commutes past the sheafified tensor before triviality is known."
  2. **MUST FIX**: Correct `lem:tensorobj_assoc_iso` proof sketch to describe the route-(d) three-step composite actually used (whiskered sheafification units + `isIso_sheafification_map_of_W` + presheaf associator), not direct gluing. Remove the claim "no whiskering of the sheafification localizer."
  3. **MAJOR**: Add `\lean{...}` pins for the 5 substantive iter-216 declarations in the `RestrictScalarsRingIsoTensor` section. Suggested: extend `lem:restrictscalars_ringiso_tensorequiv` to list `restrictScalars_isIso_μ`, `restrictScalars_isIso_ε`, `restrictScalarsMonoidalOfRingEquiv`, `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective`, and explain what they provide (the ModuleCat-level H2 core needed for the presheaf lift).
  4. Minor: Add `\lean{...}` pin for `isLocallySurjective_whiskerLeft` (a named sub-lemma of `lem:flat_whisker_localizer`).
  5. Minor: Add `\leanok` for `lem:tensorobj_unit_iso` (both `tensorObj_left_unitor` and `tensorObj_right_unitor` have full proofs; the `sync_leanok` phase should handle this next run).

---

## Severity summary

| Finding | Severity |
|---|---|
| `tensorObj_assoc_iso` Lean proof uses whiskering; blueprint (rewritten iter-216) says "no whiskering / direct gluing" | **must-fix-this-iter** |
| Blueprint "free-cover avoids H1" claim wrong; `tensorObj_isLocallyTrivial` calls `tensorObj_restrict_iso` on arbitrary M N | **must-fix-this-iter** |
| 5 substantive iter-216 declarations (`restrictScalars_isIso_{μ,ε}`, `restrictScalarsMonoidalOfRingEquiv`, `_of_bijective` variants) missing `\lean{...}` pins | **major** |
| Blueprint `lem:restrictscalars_ringiso_tensorequiv` does not describe the strong-monoidal packaging step needed for the presheaf lift | **major** |
| `lem:tensorobj_unit_iso` missing `\leanok` (proofs present, sync_leanok timing) | **minor** |
| Various helper declarations unpinned (`restrictScalarsLaxε/μ`, `toPresheaf_whiskerLeft_*`, `tensorObjIsoOfIso`, `restrictIsoUnitOfLE`) | **minor** |

**Overall verdict**: Two must-fix-this-iter findings — the blueprint was rewritten this iter to describe a proof strategy (direct-gluing, no whiskering) that the Lean does not follow, and the chapter's "free-cover avoids H1" guidance actively contradicts the actual consumption pattern of `tensorObj_isLocallyTrivial`; a blueprint-writer dispatch is required before the prover works on `tensorObj_restrict_iso`.
