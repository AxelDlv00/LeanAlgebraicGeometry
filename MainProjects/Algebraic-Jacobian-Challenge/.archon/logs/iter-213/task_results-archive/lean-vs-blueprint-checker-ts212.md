# Lean ↔ Blueprint Check Report

## Slug
ts212

## Iteration
212

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (791 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (1380 lines)

---

## Focus findings (directive questions answered first)

### Q1. Is the blueprint's "Flatness is free" step actually a real gap?

**Yes — the gap is real and the prover's assessment is correct.**

The key Lean signature of `W_whiskerLeft_of_flat` (lines 332–340):

```lean
lemma W_whiskerLeft_of_flat [J.WEqualsLocallyBijective Ab.{u}]
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    [∀ X, Module.Flat (R.obj X) (F.obj X)]
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : J.W ((toPresheaf _).map g)) :
    J.W ((toPresheaf _).map (F ◁ g))
```

The flatness hypothesis is `[∀ X, Module.Flat (R.obj X) (F.obj X)]` — **sectionwise flatness over ALL objects X of the site** (all open subsets U of the scheme). For `W_whiskerRight_of_flat` (lines 348–363) the requirement is identical (it conjugates by the braiding and inherits the same hypothesis from `W_whiskerLeft_of_flat`).

The blueprint's "Flatness is free" step (chapter lines 659–664) asserts:

> "Since M, N, P are ⊗-invertible they are projective, hence flat (Mathlib `Module.Invertible ⇒ Projective ⇒ Flat`, via `Module.Flat.of_projective`)."

### Q2. Does `IsInvertible` supply that hypothesis?

**No.** The Lean definition is:
```lean
def IsInvertible {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)
```

This is a **global / sheaf-level** existential. To apply `W_whiskerLeft_of_flat` to `M.val` one needs
`[∀ U : (Opens X)ᵒᵖ, Module.Flat (𝒪_X(U)) (M.val.obj U)]`
for **every** open `U` of `X`, including non-affine ones.

The Mathlib route `Module.Invertible R M → Projective → Flat` operates at the
**single-ring** level: it requires `M.val.obj U` to be an invertible `𝒪_X(U)`-module for
every U.  `IsInvertible M` does NOT supply this: it only says there exists a global sheaf N
with `tensorObj M N ≅ 𝒪_X` as **sheaves**; since `tensorObj` is the sheafification of the
presheaf tensor, this is weaker than `(M.val ⊗ᵖ N.val)(U) ≅ O_X(U)` sectionwise, and in
particular does not give `Module.Invertible (O_X(U)) (M.val.obj U)` for non-affine U.

The blueprint's claim "invertible ⇒ projective ⇒ flat" conflates:
- **global/sheaf-level** `IsInvertible M` (project definition), with
- **sectionwise** `Module.Invertible (O_X(U)) (M.val.obj U)` (what `Module.Flat.of_projective` needs).

**The prover's "false in general" assessment is mathematically well-founded.** For non-affine
opens U, the sections functor Γ(U, –) is not exact; there is no Mathlib path from
`IsInvertible M` to `Module.Flat (O_X(U)) (M.val.obj U)` without a separate argument
(e.g., showing `IsLocallyTrivial → IsLocallyFlat sectionwise`, which requires additional
infrastructure absent from Mathlib).

### Q3. Is the three-step composite otherwise sound?

**Yes — modulo the flatness feeder.** The structure:
1. `a(η_{M⊗N} ▷ P)` iso from `W_whiskerRight_of_flat` + `isIso_sheafification_map_of_W`
2. `a.mapIso α` (presheaf associator)
3. `a(M ◁ η_{N⊗P})` iso from `W_whiskerLeft_of_flat` + `isIso_sheafification_map_of_W`

is logically sound: each step uses an available lemma correctly once flatness of P (step 1) and
M (step 3) are available. The sole invalid premise is the "Flatness is free" step that feeds P.val
and M.val into `W_whiskerRight/Left_of_flat`. The sorry body in `tensorObj_assac_iso` correctly
reflects this status.

### Q4. Are the two new helpers faithful to the chapter?

**Yes — both are consistent and sound.**

- **`PresheafOfModules.isIso_sheafification_map_of_W`** (lines 373–383): Implements the
  go/no-go bridge `J.W f → IsIso (sheafification.map f)` via
  `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`. No sorry, proof is a straightforward
  rewrite of the localization identity. Consistent with the chapter's unnamed claim "Applying
  sheafification inverts it" (chapter lines ~685–688). ✓

- **`PresheafOfModules.W_whiskerRight_of_flat`** (lines 348–363): Derives the right-whisker
  variant from `W_whiskerLeft_of_flat` by conjugating with the braiding via
  `BraidedCategory.braiding_naturality_left` and `(J.W).cancel_left/right_of_respectsIso`.
  Matches the blueprint's `lem:flat_whisker_localizer` statement ("the right-whiskered morphism
  g ▷ F likewise lies in J.W when F is flat"). ✓

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 408)
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules` via
  `sheafification.obj (PresheafOfModules.Monoidal.tensorObj M.val N.val)`. ✓
- **Proof follows sketch**: yes — body is the sheafification-of-presheaf-tensor construction
  described in the blueprint. ✓
- **notes**: Non-sorry body. `\leanok` in chapter is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 424)
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
  via `sheafification.map (tensorHom f.val g.val)`. ✓
- **Proof follows sketch**: yes — blueprint says "inherited from `PresheafOfModules.Monoidal.tensorObj`
  under sheafification". ✓
- **notes**: Non-sorry body. `\leanok` in chapter is correct.

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (`lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes (line 147)
- **Signature matches**: yes — `instance restrictScalarsLaxMonoidal (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ ...) : (restrictScalars α).LaxMonoidal`. ✓
- **Proof follows sketch**: yes — blueprint says "sectionwise lift" of `ModuleCat.restrictScalars.LaxMonoidal`; the Lean proof exactly assembles `ε := restrictScalarsLaxε`, `μ := restrictScalarsLaxμ` and discharges the six coherence laws sectionwise. ✓
- **notes**: Non-sorry body. Off-critical-path supplement as noted in chapter. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (`lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 633)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`. ✓
- **Proof follows sketch**: partial — steps 1–3 of the blueprint's proof sketch are implemented
  in the Lean via `restrictFunctorIsoPullback`, `sheafificationCompPullback`, and `sheafification.mapIso`.
  Step 4 (the presheaf-level pullback–tensor comparison) is `sorry` with a ~200-LOC analysis in
  the inline comment documenting two absent Mathlib ingredients (H1: presheaf-level pushforward
  adjunction; H2: strong monoidal upgrade of `restrictScalars` along ring iso). The analysis is
  correct and consistent with the chapter's step-3 "genuine residual" note.
- **notes**: Off the critical path per blueprint `rem:scheme_modules_monoidal_off_path`. `\leanok`
  in chapter is correct (sorry body present).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (`lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 715)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`. ✓
- **Proof follows sketch**: partial — the proof body is a genuine construction that picks a common
  affine open, refines via `restrictIsoUnitOfLE`, and chains through `tensorObj_restrict_iso ≪≫
  tensorObjIsoOfIso ≪≫ tensorObj_unit_iso`. The proof is structurally complete but inherits the
  sorry from `tensorObj_restrict_iso`. Consistent with blueprint "only residual gap is the
  substrate-restriction compatibility `tensorObj_restrict_iso`". ✓
- **notes**: `\leanok` in chapter is correct.

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat}` (`lem:flat_whisker_localizer`)
- **Lean target exists**: yes (line 332)
- **Signature matches**: yes — matches blueprint statement exactly; flatness is `[∀ X, Module.Flat (R.obj X) (F.obj X)]` (sectionwise), `g ∈ J.W` inputs, `F ◁ g ∈ J.W` output. ✓
- **Proof follows sketch**: yes — two halves: `isLocallySurjective_whiskerLeft` (no flatness, right-exactness) and `isLocallyInjective_whiskerLeft_of_flat` (flatness via `Module.Flat.lTensor_exact`). Blueprint says "local surjectivity from right-exactness, local injectivity from flatness" — matches exactly. ✓
- **notes**: Non-sorry body. The sectionwise flatness hypothesis `[∀ X, Module.Flat (R.obj X) (F.obj X)]` is the critical constraint that the blueprint's "Flatness is free" step fails to supply (see Q1–Q2 above).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assac_iso}` (`lem:tensorobj_assac_iso`)
- **Lean target exists**: yes (line 568)
- **Signature matches**: yes — `(hM : IsInvertible M) (hN : IsInvertible N) (hP : IsInvertible P) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`. ✓
- **Proof follows sketch**: **no** — body is `sorry`. The blueprint's proof sketch claims "Flatness is free" (invertible ⇒ projective ⇒ flat), but the Lean lemma needed (`W_whiskerLeft/Right_of_flat`) requires **sectionwise** flatness over all opens, which `IsInvertible` does not supply (see Q1–Q2). The docstring accurately documents the gap.
- **notes**: **[must-fix-this-iter]** Blueprint proof sketch is INCORRECT at the "Flatness is free" step. The blueprint must be corrected: the correct route is via local-triviality whiskering (`IsInvertible → IsLocallyTrivial → sectionwise flatness over affine opens → local whisker argument`), which requires new bridging lemmas not yet in the file. The current sorry in the Lean file is CORRECT (reflecting the real residual), but the blueprint's claimed proof route is invalid.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor}` and `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (`lem:tensorobj_unit_iso`)
- **Lean target exists**: yes — `tensorObj_left_unitor` (line 498) and `tensorObj_right_unitor` (line 508). ✓
- **Signature matches**: yes — left: `tensorObj 𝒪_X M ≅ M`; right: `tensorObj M 𝒪_X ≅ M` via `sheafification.mapIso (leftUnitor M.val)` and `sheafification.mapIso (rightUnitor M.val)` composed with the sheafification counit. ✓
- **Proof follows sketch**: yes — blueprint says "presheaf-level left/right unitors λ, ρ sheafified via `sheafification.mapIso`, composed with counit". ✓
- **notes**: Both have non-sorry bodies. The chapter block `lem:tensorobj_unit_iso` is **missing `\leanok`** despite both declarations having sorry-free bodies. Minor — sync_leanok should fix.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (`lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (line 518)
- **Signature matches**: yes — `(M N : X.Modules) : tensorObj M N ≅ tensorObj N M` via `sheafification.mapIso (BraidedCategory.braiding M.val N.val)`. ✓
- **Proof follows sketch**: yes — blueprint: "presheaf monoidal braiding β sheafified by mapIso". ✓
- **notes**: Non-sorry body. `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 741)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`. ✓
- **Proof follows sketch**: N/A — body is `sorry`; off the critical path per blueprint notes.
- **notes**: `\leanok` correct (sorry body). Off-critical-path per blueprint.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (`lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes — `(L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT` via
  `⟨tensorObj L.carrier L'.carrier, tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩`. ✓
- **Proof follows sketch**: partial — blueprint claims this needs `IsInvertible` closure, but the
  Lean uses `IsLocallyTrivial` closure instead, building on `tensorObj_isLocallyTrivial`. This is
  a **slight divergence**: the blueprint's `lem:tensorobj_lift_onproduct` uses `IsInvertible`
  carrier; the Lean uses `LineBundle.IsLocallyTrivial`. The Lean is consistent at the current
  development stage where `IsInvertible ↔ IsLocallyTrivial` equivalence is not yet proven.
- **notes**: Non-sorry body. Minor mismatch in which predicate is used for the carrier.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (`def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (line 437)
- **Signature matches**: yes — `∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`. Matches blueprint definition exactly. ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (`lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: **NO** — this declaration does not appear anywhere in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **[must-fix-this-iter]** The blueprint's group-law engine is pinned as
  `tensorObjIsoclassCommMonoid` but the declaration is absent from the Lean file. This is not
  a helper omission — it is the declaration that `lem:tensorobj_lift_onproduct` and
  `thm:rel_pic_addcommgroup_via_tensorobj` depend on for the commutative monoid / abelian-group
  law. No `\leanok` in the chapter (correctly reflecting absence). Must be added to the Lean
  file before `addCommGroup_via_tensorObj` can close.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (`thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (line 781)
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`. ✓
- **Proof follows sketch**: N/A — body is `sorry`; iter-204+ target per the module header.
- **notes**: `\leanok` in chapter is correct (sorry body). Blocked on `tensorObjIsoclassCommMonoid`.

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.Scheme.Modules.tensorObj_assac_iso` (line 575): `:= sorry`. The blueprint
  claims a substantive three-step composite, but the key step ("Flatness is free") is
  **mathematically incorrect** (see Q1–Q2). The sorry is _correct_ — do not fill it via the
  blueprint's invalid route.
- `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` (line 702): terminates in `sorry`
  after partial elaboration. Off the critical path; sorry is expected and correctly documented.
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` (line 745): `:= sorry`. Off
  the critical path; sorry is expected.
- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (line 784): `:= sorry`.
  Expected iter-204+ target; sorry is expected.

None of the above sorry bodies constitutes an "excuse comment" or a wrong statement — each is
accompanied by an accurate docstring describing the residual obstacles. The sorry bodies are
correctly scoped.

### Excuse-comments
None found. The docstrings are engineering status notes, not excuses for wrong code. The
`tensorObj_assac_iso` docstring explicitly documents the real residual and flags the blueprint's
"Flatness is free" step as the incorrect argument — this is appropriate and helpful.

### Axioms / Classical.choice
None found. All declarations are `noncomputable def / lemma / instance`. No `axiom` declarations.

---

## Unreferenced declarations (informational)

The following declarations are in the Lean file but have no `\lean{...}` pin in the chapter:

| Declaration | Nature |
|---|---|
| `PresheafOfModules.restrictScalarsLaxε` | Helper for `restrictScalarsLaxMonoidal`; fine |
| `PresheafOfModules.restrictScalarsLaxμ` | Helper for `restrictScalarsLaxMonoidal`; fine |
| `PresheafOfModules.toPresheaf_whiskerLeft_app_tmul` | Helper for `W_whiskerLeft_of_flat`; fine |
| `PresheafOfModules.toPresheaf_whiskerLeft_app_apply` | Helper for `W_whiskerLeft_of_flat`; fine |
| `PresheafOfModules.isLocallySurjective_whiskerLeft` | Split-out half of `W_whiskerLeft_of_flat`; fine |
| `PresheafOfModules.isLocallyInjective_whiskerLeft_of_flat` | Split-out half; fine |
| **`PresheafOfModules.W_whiskerRight_of_flat`** | **Substantive** sorry-free lemma (right-whisker variant of `lem:flat_whisker_localizer`); should get `\lean{...}` pin — see major finding below |
| **`PresheafOfModules.isIso_sheafification_map_of_W`** | **Substantive** sorry-free bridge lemma; chapter text relies on it but no pin — see major finding below |
| `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` | Helper for `tensorObj_isLocallyTrivial`; fine |
| `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` | Helper (𝒪 ⊗ 𝒪 ≅ 𝒪); distinct from `lem:tensorobj_unit_iso` (𝒪 ⊗ M ≅ M); fine |
| `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` | Helper for `tensorObj_isLocallyTrivial`; fine |

---

## Blueprint adequacy for this file

- **Coverage**: 13/14 blueprint `\lean{...}` blocks have a corresponding Lean declaration.
  Missing: `tensorObjIsoclassCommMonoid` (critical). The two new sorry-free helpers
  (`W_whiskerRight_of_flat`, `isIso_sheafification_map_of_W`) are in the Lean file but not
  pinned in the chapter (2 substantive unpinned declarations).

- **Proof-sketch depth**: **inadequate** for `lem:tensorobj_assac_iso`. The "Flatness is free"
  step is a false claim (blueprint lines 659–664). The chapter must be corrected to supply the
  genuine route:
  - Option A (recommended): Replace "invertible ⇒ projective ⇒ flat" with a local-triviality
    argument: on the cover where M ≅ 𝒪, `η ▷ M ≅ η`, so the whisker is locally J.W; glue
    via a sheaf-theoretic argument. This requires a new lemma
    `IsLocallyTrivial.whiskerLeft_of_W` (or similar).
  - Option B: Add `lem:isinvertible_implies_sectionwise_flat` (if true — but this is
    not an obvious Mathlib consequence; evidence suggests it is false for non-affine opens).
  
  All other proof sketches (restrictScalarsLaxMonoidal, W_whiskerLeft_of_flat, unitors,
  braiding, tensorObj_restrict_iso) are adequate.

- **Hint precision**: adequate for 13/14 blocks. The `lem:flat_whisker_localizer` block
  correctly pins `W_whiskerLeft_of_flat`; the right-whisker variant `W_whiskerRight_of_flat`
  is mentioned in prose but not pinned.

- **Generality**: matches need — the blueprint's definition of `IsInvertible` is correctly
  abstract. The mismatch in `tensorObjOnProduct` (using `IsLocallyTrivial` vs. `IsInvertible`
  in the Lean) is a development-stage convenience, not a generality failure.

- **Recommended chapter-side actions**:
  1. **[must-fix]** Correct the "Flatness is free" step in `lem:tensorobj_assac_iso` proof.
     Replace with the local-triviality whiskering route (or add the missing bridge lemma).
  2. **[must-fix]** Add `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}`
     once the declaration is added to the Lean file.
  3. **[major]** Add `\lean{PresheafOfModules.W_whiskerRight_of_flat}` to the
     `lem:flat_whisker_localizer` block (both halves are now proven; the chapter prose already
     states the right-whisker result).
  4. **[major]** Add a new (small) block for `PresheafOfModules.isIso_sheafification_map_of_W`
     — this is the go/no-go bridge that closes `isIso (sheafification.map f)` from `J.W f`
     and is consumed explicitly by `tensorObj_assac_iso` steps 1 and 3.
  5. **[minor]** Add `\leanok` to the statement block of `lem:tensorobj_unit_iso` — both
     `tensorObj_left_unitor` and `tensorObj_right_unitor` have sorry-free bodies (sync_leanok
     should pick this up).

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint proof of `lem:tensorobj_assac_iso` — "Flatness is free" step is mathematically incorrect: `IsInvertible` does not imply sectionwise flatness `∀ U, Module.Flat (O_X(U)) (M.val.obj U)` required by `W_whiskerLeft/Right_of_flat` | **must-fix-this-iter** |
| `AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid` missing from Lean file; blueprint `lem:tensorobj_isoclass_commgroup` pins it and downstream declarations depend on it | **must-fix-this-iter** |
| `PresheafOfModules.W_whiskerRight_of_flat` (sorry-free, substantive) has no `\lean{...}` pin in chapter; mentioned in prose but not pinned | **major** |
| `PresheafOfModules.isIso_sheafification_map_of_W` (sorry-free, substantive) not referenced by any `\lean{...}` in chapter; consumed by the associator proof | **major** |
| `lem:tensorobj_unit_iso` chapter block missing `\leanok` despite both declared with non-sorry bodies | **minor** |
| `tensorObjOnProduct` uses `LineBundle.IsLocallyTrivial` carrier where blueprint uses `IsInvertible`; diverges from blueprint spec (developmentally OK but technically a carrier mismatch) | **minor** |

**Overall verdict**: Two must-fix-this-iter findings — a critical missing Lean declaration (`tensorObjIsoclassCommMonoid`) and a mathematically incorrect proof step in the blueprint's `lem:tensorobj_assac_iso` ("Flatness is free"); 14 declarations checked, 6 red flags (2 must-fix, 2 major, 2 minor).
