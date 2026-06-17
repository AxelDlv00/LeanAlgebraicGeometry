# Lean ↔ Blueprint Check Report

## Slug
ts211

## Iteration
211

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Scope of this check

Per the directive, this iter's focus is the **five newly proved/created declarations**:
1. `PresheafOfModules.W_whiskerLeft_of_flat` (`lem:flat_whisker_localizer`)
2. `AlgebraicGeometry.Scheme.Modules.IsInvertible` (`def:scheme_modules_isinvertible`)
3. `AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor` (`lem:tensorobj_unit_iso`, left)
4. `AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor` (`lem:tensorobj_unit_iso`, right)
5. `AlgebraicGeometry.Scheme.Modules.tensorObj_braiding` (`lem:tensorobj_comm_iso`)

Known-issue declarations (`tensorObj_restrict_iso`, `exists_tensorObj_inverse`,
`addCommGroup_via_tensorObj`, `tensorObj_assoc_iso`) are acknowledged and not re-reported.

---

## Per-declaration

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat}` (chapter: `lem:flat_whisker_localizer`)

- **Lean target exists**: yes — confirmed by hover at L332; namespace `PresheafOfModules` as corrected
- **Signature matches**: yes

  Lean (from hover):
  ```
  {J : GrothendieckTopology C} [J.WEqualsLocallyBijective Ab]
  (F : PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat))
  [∀ X, Module.Flat ↑(R.obj X) ↑(F.obj X)]
  {M N : PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)}
  (g : M ⟶ N) (hg : J.W ((toPresheaf _).map g))
  : J.W ((toPresheaf _).map (F ◁ g))
  ```

  Blueprint: "for sectionwise-flat F, if g ∈ J.W then F ◁ g ∈ J.W". Exact match.
  The blueprint also states the right-whiskered corollary in prose ("by symmetry…
  g ▷ F likewise lies in J.W"). No separate `\lean{...}` pin for the right-whiskered
  version — the single left-whiskered declaration is what the chapter pins, and the
  right-whiskered corollary is described as an immediate consequence. This is consistent:
  the associator recipe only invokes the left-whiskered form directly (`W_whiskerLeft_of_flat`)
  and conjugates to get the right-whiskered step.

- **Proof follows sketch**: yes, with one minor difference

  Blueprint proof sketch (surjectivity half): "tensoring is right exact, so the cokernel
  of g maps to the cokernel of F ◁ g; since g is locally surjective its cokernel is
  locally zero."
  Blueprint proof sketch (injectivity half): "each F(U) is flat, so F(U) ⊗ - preserves
  injective linear maps (Mathlib `Module.Flat.lTensor_preserves_injective_linearMap`)."

  Lean proof:
  - Surjectivity half (`isLocallySurjective_whiskerLeft`, L222–247): straightforward
    element-chase on a tmul/induction_on. Matches the right-exactness argument.
  - Injectivity half (`isLocallyInjective_whiskerLeft_of_flat`, L255–321): uses
    `Module.Flat.lTensor_exact` (L278) on the kernel exact sequence, rather than the
    blueprint's suggested `Module.Flat.lTensor_preserves_injective_linearMap`.
    **Mathematically equivalent**: both routes encode "F flat ⇒ F ⊗ - preserves
    injections." The Lean route works via the exact sequence `ker(g) ↪ M → N`
    tensored with F to get `ker(F ⊗ g) = im(F ⊗ ker.subtype)`, then induction on
    the TensorProduct witness ζ. The mathematical content matches the blueprint's
    local-injectivity argument exactly.

- **No sorry in body**: confirmed — proof closes with real tactic blocks (L337–340
  dispatch the two halves via a `rw [GrothendieckTopology.W_iff_isLocallyBijective]`
  and `⟨…, …⟩` pair).

- **notes**: Blueprint `lem:flat_whisker_localizer` block has **no `\leanok` marker**.
  The proof is a real non-sorry proof — `sync_leanok` should have added `\leanok`
  at the statement block. This is in `sync_leanok`'s domain, not an action for review.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)

- **Lean target exists**: yes — hover at L394 confirms `AlgebraicGeometry.Scheme.Modules.IsInvertible`
- **Signature matches**: yes

  Lean (from hover): `{X : Scheme} (M : X.Modules) : Prop`
  Lean body (L395): `∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`

  Blueprint (`def:scheme_modules_isinvertible`, L1018–1020):
  `IsInvertible(M) :≡ ∃ N, Nonempty(M ⊗_X N ≅ SheafOfModules.unit X.ringCatSheaf)`.
  Perfect match in both type and body.

- **Proof follows sketch**: N/A — this is a Prop-valued `def`, no proof obligation.

- **No sorry in body**: N/A — the `def` body is an existential `Prop`, no tactic proof.

- **Blueprint `\leanok` present**: yes — blueprint L964 shows `\begin{definition}\leanok`.
  Consistent with the declaration being formalized.

- **notes**: The definition correctly uses `SheafOfModules.unit X.ringCatSheaf` as the
  designated unit, matching the post-iter-206 flat-pivot convention (not the formerly
  planned `MonoidalCategory` unit `𝟙_`).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor}` (chapter: `lem:tensorobj_unit_iso`, left half)

- **Lean target exists**: yes — hover at L455 confirms
  `AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor`
- **Signature matches**: yes

  Lean (from hover):
  `(M : X.Modules) : tensorObj (SheafOfModules.unit X.ringCatSheaf) M ≅ M`

  Blueprint (`lem:tensorobj_unit_iso`): `𝒪_X ⊗_X M ≅ M` with `𝒪_X = SheafOfModules.unit X.ringCatSheaf`.
  Exact match.

- **Proof follows sketch**: yes

  Blueprint (L748–756): "sheafification of the presheaf-level left unitor λ_ M.val,
  composed with the sheafification counit identifying sheafification M.val with
  (already-sheaf) M. The cheap mapIso pattern."

  Lean (L456–459):
  ```lean
  (PresheafOfModules.sheafification …).mapIso
      ((PresheafOfModules.monoidalCategoryStruct …).leftUnitor M.val) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction …).counit).app M
  ```
  Exactly matches the blueprint's two-step description.

- **No sorry in body**: confirmed.

- **Blueprint `\leanok` on `lem:tensorobj_unit_iso`**: **absent** — the lemma block
  (L730–757) has no `\leanok`. Both left and right unitor proofs are real.
  `sync_leanok` domain — will be added automatically.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`, right half)

- **Lean target exists**: yes — hover at L465 confirms
  `AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor`
- **Signature matches**: yes

  Lean (from hover):
  `(M : X.Modules) : M.tensorObj (SheafOfModules.unit X.ringCatSheaf) ≅ M`
  (`M.tensorObj N` is dot notation for `tensorObj M N`)

  Blueprint (`lem:tensorobj_unit_iso`): `M ⊗_X 𝒪_X ≅ M`. Exact match.

- **Proof follows sketch**: yes — same mapIso + counit pattern as the left unitor,
  using `rightUnitor` in place of `leftUnitor` (L467–469). Blueprint specifies the same
  cheap pattern for both.

- **No sorry in body**: confirmed.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)

- **Lean target exists**: yes — hover at L475 confirms
  `AlgebraicGeometry.Scheme.Modules.tensorObj_braiding`
- **Signature matches**: yes

  Lean (from hover): `(M N : X.Modules) : M.tensorObj N ≅ N.tensorObj M`

  Blueprint (`lem:tensorobj_comm_iso`, L763–770): `M ⊗_X N ≅ N ⊗_X M`. Exact match.

- **Proof follows sketch**: yes

  Blueprint (L773–779): "The presheaf-of-modules monoidal category is symmetric,
  so it carries a braiding β at the presheaf level. Its sheafification
  `sheafification.mapIso(β)` is the asserted isomorphism, again by the cheap
  mapIso pattern."

  Lean (L477–479):
  ```lean
  (PresheafOfModules.sheafification …).mapIso
    (BraidedCategory.braiding
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
      M.val N.val)
  ```
  Exactly matches.

- **No sorry in body**: confirmed.

- **Blueprint `\leanok` present**: yes — L761–762 shows `\leanok` before the lemma text.
  Consistent.

---

## Red flags

No red flags on the five newly proved declarations:
- No `:= sorry` bodies.
- No excuse-comments.
- No axioms.
- No weakened-wrong definitions.

---

## Unreferenced declarations (informational)

Declarations in the Lean file that have no `\lean{...}` reference in the blueprint:

- `PresheafOfModules.restrictScalarsLaxε` (L114) — helper for `restrictScalarsLaxMonoidal`; the blueprint `lem:restrictscalars_laxmonoidal` pins `PresheafOfModules.restrictScalarsLaxMonoidal` (the instance), not the constituent ε/μ pieces. Acceptable.
- `PresheafOfModules.restrictScalarsLaxμ` (L130) — same.
- `PresheafOfModules.toPresheaf_whiskerLeft_app_tmul` (L201) — internal lemma for the FlatWhisker section. Not blueprint-pinned; helper for `W_whiskerLeft_of_flat`.
- `PresheafOfModules.toPresheaf_whiskerLeft_app_apply` (L211) — same.
- `PresheafOfModules.isLocallySurjective_whiskerLeft` (L222) — half-lemma feeding `W_whiskerLeft_of_flat`; the blueprint singles out the composite result via the single `\lean{...}` pin.
- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_flat` (L255) — other half-lemma.
- `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` (L426) — helper for `tensorObj_isLocallyTrivial`; not pinned. Acceptable helper.
- `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` (L442) — this is a special case (𝒪 ⊗ 𝒪 ≅ 𝒪) not separately pinned in the blueprint. Acceptable helper.
- `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` (L521) — helper for `tensorObj_isLocallyTrivial`. Not blueprint-pinned. Acceptable.

None of these suggest a blueprint coverage gap — all are helpers or intermediate results feeding blueprint-pinned declarations.

---

## Blueprint adequacy for this file

- **Coverage**: The five declarations audited have corresponding `\lean{...}` blocks in the chapter. The helper declarations not pinned are all clearly auxiliary (half-lemmas, ε/μ components, sub-results). Coverage is adequate.

- **Proof-sketch depth**: **adequate** for all five. Each blueprint block gave the level of detail the Lean proof consumed:
  - `W_whiskerLeft_of_flat`: Two-half structure (local inject + local surject) and the role of flatness clearly described; the Lean proof follows this exactly. The specific Mathlib lemma named (`lTensor_preserves_injective_linearMap`) differs from what the proof ultimately used (`lTensor_exact`), but this is a minor hint imprecision — both encode the same mathematical fact and a prover would not be misled.
  - `IsInvertible`: The blueprint gives the exact formula in displaymath. Perfect guidance.
  - `tensorObj_left_unitor`, `tensorObj_right_unitor`: The "cheap mapIso + counit" recipe is explicit. Adequate.
  - `tensorObj_braiding`: The "mapIso of presheaf braiding" route is explicit. Adequate.

- **Hint precision**: **precise** for the four `AlgebraicGeometry.Scheme.Modules.*` declarations and `PresheafOfModules.W_whiskerLeft_of_flat`. The corrected `\lean{...}` name for `W_whiskerLeft_of_flat` is in the right namespace.

- **Generality**: **matches need** — all five declarations are at exactly the generality the downstream consumer uses.

- **Recommended chapter-side actions**: One informational item:
  - The blueprint proof sketch for `lem:flat_whisker_localizer` cites `Module.Flat.lTensor_preserves_injective_linearMap` as the Mathlib ingredient for local injectivity. The actual Lean proof uses `Module.Flat.lTensor_exact` (the exact sequence version). Consider updating the blueprint's prose to cite `Module.Flat.lTensor_exact` (or note both are available) to reduce future confusion for provers. This is **minor** — a cosmetic prose update, not a mathematical error.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1 — blueprint `lem:flat_whisker_localizer` proof sketch cites `Module.Flat.lTensor_preserves_injective_linearMap` but the proof uses the equivalent `Module.Flat.lTensor_exact`; blueprint prose could be updated to match (cosmetic)
- **informational**: Two `\leanok` markers missing from `lem:flat_whisker_localizer` and `lem:tensorobj_unit_iso` statement blocks; both proofs are real — these are `sync_leanok` domain and should self-correct.

**Overall verdict**: All five newly proved declarations exist under the correct names, carry signatures that match their blueprint blocks exactly, and have real non-sorry proof bodies following the described construction. No blocking findings.
