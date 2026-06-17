# Lean ↔ Blueprint Check Report

## Slug
ts238

## Iteration
238

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `\lem:tensorobj_assoc_iso`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, lines 341–382)
- **Signature matches**: yes — the formal statement in the chapter says "Let M, N, P ∈ Scheme.Modules X. There is an isomorphism (M ⊗_X N) ⊗_X P ≅ M ⊗_X (N ⊗_X P)" with no hypotheses. The Lean signature `{M N P : X.Modules}` is unconditional, matching the body text.
- **Proof follows sketch**: partial — the proof text describes the route-(d) sheafification-transport approach (W_whiskerRight_of_W, W_whiskerLeft_of_W, isIso_sheafification_map_of_W, presheaf associator). The Lean proof follows exactly this route. ✓

  **However: the `\uses` clause lists `lem:tensorobj_restrict_iso`, but the Lean proof does NOT use `tensorObj_restrict_iso`.** Route-(d) bypasses the restriction-compatibility isomorphism entirely; the proof text confirms this ("unconditional via d.2"). The `\uses` reference to `lem:tensorobj_restrict_iso` is stale.

- **notes**:
  1. **STALE NOTE (major)**: Blueprint lines 1452–1456 say: *"The current Lean pin additionally carries **locally trivial** (LineBundle.IsLocallyTrivial, def:IsLocallyTrivial) hypotheses on M, N, P."* This is **false after iter-238**. The Lean declaration has NO `IsLocallyTrivial` hypotheses; they were dropped this iteration. The blueprint prose immediately says "The construction below produces the isomorphism for arbitrary O_X-modules; the hypotheses are retained only to match the carrier" — this sentence's premise is now false.
  2. **STALE TITLE**: Blueprint label reads "Associator for $\otimes_X$ on **locally trivial objects**". The declaration is now unconditional; "on locally trivial objects" is inaccurate.
  3. **Stale `\uses`**: `lem:tensorobj_restrict_iso` is not used in the actual proof path.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (chapter: `\lem:tensorobj_assoc_iso_invertible`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, lines 742–745)
- **Signature matches**: yes — blueprint says "M, N, P ⊗-invertible, there is an isomorphism (M ⊗ N) ⊗ P ≅ M ⊗ (N ⊗ P)". Lean: `(_hM : IsInvertible M) (_hN : IsInvertible N) (_hP : IsInvertible P) : tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`. ✓
- **Proof follows sketch**: yes — blueprint says "immediate specialisation of the unconditional associator; no hypothesis used". Lean body is exactly `tensorObj_assoc_iso` (the hypotheses are dummy-named with underscore prefix confirming they're unused). ✓
- **notes**: Completely faithful. The blueprint proof note records that the old "invertible ⇒ locally free ⇒ sectionwise flat" route was false; the Lean bypasses it correctly.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (chapter: `\lem:isinvertible_tensor`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, lines 764–771)
- **Signature matches**: yes — blueprint: "If IsInvertible M and IsInvertible M', then IsInvertible (M ⊗_X M')". Lean: `theorem IsInvertible.tensorObj (hM : IsInvertible M) (hM' : IsInvertible M') : IsInvertible (Scheme.Modules.tensorObj M M')`. ✓
- **Proof follows sketch**: yes — blueprint says "N ⊗ N' is a tensor inverse, proved by middle-four interchange using associator, braiding, and witness isos". Lean uses `tensorObj_middleFour` (a private helper that assembles the middle-four interchange from `tensorObj_assoc_iso` and `tensorObj_braiding`), then `tensorObjIsoOfIso e e'`, then `tensorObj_unit_iso`. Mathematical content matches. ✓
- **notes**: `tensorObj_middleFour` is a private helper not pinned in the blueprint; acceptable since it's an implementation detail.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` (chapter: `\lem:isinvertible_unit`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, lines 774–776)
- **Signature matches**: yes — blueprint: "IsInvertible (SheafOfModules.unit X.ringCatSheaf)". Lean: `theorem isInvertible_unit {X : Scheme.{u}} : IsInvertible (SheafOfModules.unit X.ringCatSheaf)`. ✓
- **Proof follows sketch**: yes — blueprint says "take N := O_X; right unitor gives O_X ⊗ O_X ≅ O_X". Lean: `⟨SheafOfModules.unit X.ringCatSheaf, ⟨tensorObj_unit_iso⟩⟩`. ✓
- **notes**: Perfect match.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (chapter: `\lem:isinvertible_inverse_welldef`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, lines 781–789)
- **Signature matches**: yes — blueprint: "If M ⊗ N ≅ O_X and M ⊗ N' ≅ O_X then N ≅ N'". Lean: `(e : Scheme.Modules.tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf) (e' : ...) : Nonempty (N ≅ N')`. ✓
- **Proof follows sketch**: yes — blueprint sketches the chain N ≅ N⊗O_X ≅ N⊗(M⊗N') ≅ (N⊗M)⊗N' ≅ O_X⊗N' ≅ N'. Lean constructs exactly this chain using `tensorObj_right_unitor`, `tensorObjIsoOfIso`, `tensorObj_assoc_iso.symm`, `tensorObjIsoOfIso (tensorObj_braiding N M ≪≫ e)`, `tensorObj_left_unitor`. ✓
- **notes**: Blueprint `\uses` cites `lem:tensorobj_assoc_iso_invertible` but the Lean uses `tensorObj_assoc_iso` (the unconditional version, which is strictly stronger). This is mathematically correct and not a problem — using the more general lemma subsumes the specialized one. Minor `\uses` discrepancy.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (chapter: `\def:pic_carrier`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, line 800)
- **Signature matches**: yes — blueprint: quotient of `{M : Scheme.Modules X // IsInvertible M}` under `M ∼ M' :\equiv Nonempty (M ≅ M')`. Lean: `def PicGroup (X : Scheme.{u}) : Type _ := Quotient (picSetoid X)` where `picSetoid` has `r M M' := Nonempty ((M : X.Modules) ≅ (M' : X.Modules))`. ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: The `picSetoid` auxiliary instance is not separately `\lean{...}`-pinned but is fully described in the blueprint's prose. Acceptable.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `\thm:pic_commgroup`)

- **Lean target exists**: yes (`TensorObjSubstrate.lean`, lines 834–862)
- **Signature matches**: yes — blueprint: "PicGroup X is a CommGroup with [M]·[M'] := [M ⊗_X M'], 1 := [O_X], [M]^{-1} := [N] for any witness". Lean: `noncomputable instance picCommGroup (X : Scheme.{u}) : CommGroup (PicGroup X)` with `mul := picMul`, `one := Quotient.mk _ ⟨SheafOfModules.unit X.ringCatSheaf, isInvertible_unit⟩`, `inv := picInv`. ✓
- **Proof follows sketch**: yes — blueprint says each group axiom is a single existence-of-isomorphism: `mul_assoc` ← associator, `one_mul`/`mul_one` ← unitors, `inv_mul_cancel` ← witness iso, `mul_comm` ← braiding. Lean fields:
  - `mul_assoc`: `Quotient.sound ⟨tensorObj_assoc_iso⟩` ✓
  - `one_mul`: `Quotient.sound ⟨tensorObj_left_unitor a.1⟩` ✓
  - `mul_one`: `Quotient.sound ⟨tensorObj_right_unitor a.1⟩` ✓
  - `inv_mul_cancel`: `Quotient.sound ⟨tensorObj_braiding … ≪≫ (Classical.choose_spec a.2).some⟩` ✓
  - `mul_comm`: `Quotient.sound ⟨tensorObj_braiding a.1 b.1⟩` ✓
- **notes**: Implementation helpers `picMul`, `picInv` are not `\lean{...}`-pinned but are described in blueprint prose. The instance is declared as `noncomputable instance` (not `def`), matching the blueprint which says "the carrier Pic X is an abelian group" (not explicitly "instance vs def"). The Lean file comment notes `@[implicit_reducible]` is retained for the linter; this is an implementation detail not covered in the blueprint, acceptable.

---

## Red flags

### Placeholder / suspect bodies

- `exists_tensorObj_inverse` (line 715): body is `sorry`. Blueprint `lem:tensorobj_inverse_invertible` has `\leanok` on the **statement block only** (no proof-block `\leanok`), explicitly acknowledging the proof is open. Not a red flag — the sorry is declared and tracked. The blueprint body comment acknowledges two remaining bridges (C and A). ✓

- `addCommGroup_via_tensorObj` (line 894): body is `sorry`. Blueprint `thm:rel_pic_addcommgroup_via_tensorobj` has `\leanok` on the **statement block only**. Same situation — openly tracked open obligation. ✓

### Excuse-comments
None. The comments in both Lean and blueprint accurately describe the mathematical situation and open obligations.

### Axioms / Classical.choice on non-trivial claims
- `picInv` uses `Classical.choose a.2` to extract the inverse witness. This is correct and expected: `IsInvertible M` is existentially defined (`∃ N, …`), so `Classical.choice` is the canonical way to extract `N`. Blueprint explicitly says "the inverse is carried by the membership witness itself". No red flag.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no direct `\lean{...}` blueprint pin but are implementation helpers:

- `picSetoid` (line 793) — helper instance for `PicGroup`; described in the prose of `def:pic_carrier`.
- `picMul` (line 805) — operation for `picCommGroup`; described in prose of `thm:pic_commgroup`.
- `picInv` (line 814) — operation for `picCommGroup`; described in prose of `thm:pic_commgroup`.
- `tensorObj_middleFour` (line 751, `private`) — private helper for `IsInvertible.tensorObj`; not blueprint-pinned (private; expected).

These are all subordinate to blueprint-pinned declarations and require no separate pins.

---

## Blueprint adequacy for this file

- **Coverage**: 7/7 checked declarations have a `\lean{...}` block in the chapter (all checked declarations matched). The un-pinned declarations are helpers or private. Coverage adequate.

- **Proof-sketch depth**: adequate for the §5 declarations (`tensorObj_assoc_iso_invertible`, `IsInvertible.tensorObj`, `isInvertible_unit`, `IsInvertible.inverse_unique`, `PicGroup`, `picCommGroup`). The blueprints for all these are detailed enough that a prover could reconstruct them.

  For `lem:tensorobj_assoc_iso`: the proof sketch is accurate and detailed for the route-(d) approach. The stale note (below) is a adequacy failure at the *description-of-current-state* level, not at the proof-sketch level.

- **Hint precision**: precise. All `\lean{...}` hints name exactly the correct Lean declarations.

- **Generality**: matches need. The invertibility-carrier group law in §5 is correctly identified as the closure target; the blueprint accurately describes why the `IsInvertible` predicate is better than `IsLocallyTrivial` for this group law (inverse-free).

- **Recommended chapter-side actions**:
  1. **(Major — must update)** Remove or update the stale note in `lem:tensorobj_assoc_iso` (blueprint lines 1452–1456): delete the sentence "The current Lean pin additionally carries locally trivial (LineBundle.IsLocallyTrivial) hypotheses on M, N, P. The construction below produces the isomorphism for arbitrary O_X-modules; the hypotheses are retained only to match the carrier the group law multiplies on, and are not used in the gluing." The hypotheses no longer exist in the Lean. Replace with something like "The Lean pin is unconditional (iter-238); no local-triviality hypothesis is present."
  2. **(Major)** Update the title of `lem:tensorobj_assoc_iso` from "Associator for $\otimes_X$ on locally trivial objects" to "Associator for $\otimes_X$ (unconditional)" or similar.
  3. **(Minor)** Remove `lem:tensorobj_restrict_iso` from the `\uses` of `lem:tensorobj_assoc_iso`; route-(d) does not consume it.
  4. **(Minor)** The `\uses` of `lem:isinvertible_inverse_welldef` cites `lem:tensorobj_assoc_iso_invertible` but the Lean uses `tensorObj_assoc_iso` directly. Update `\uses` to reference `lem:tensorobj_assoc_iso`.
  5. **(Informational / deferred)** The `thm:rel_pic_addcommgroup_via_tensorobj` `\uses` still points to `lem:tensorobj_isoclass_commgroup` rather than `thm:pic_commgroup`. The blueprint has a NOTE acknowledging this is deferred. When the consumer closes, update `\uses` to reference `thm:pic_commgroup`.

---

## Severity summary

| Finding | Classification |
|---|---|
| Stale note in `lem:tensorobj_assoc_iso` claiming Lean still has `IsLocallyTrivial` hypotheses (dropped in iter-238) | **major** |
| Stale title "on locally trivial objects" for `lem:tensorobj_assoc_iso` | **major** |
| Stale `\uses{lem:tensorobj_restrict_iso}` in `lem:tensorobj_assoc_iso` (not used in route-(d) proof) | **minor** |
| `\uses` in `lem:isinvertible_inverse_welldef` cites `assoc_iso_invertible`; Lean uses `assoc_iso` | **minor** |
| Deferred `\uses` update in `thm:rel_pic_addcommgroup_via_tensorobj` (blueprint-noted) | informational |

**Overall verdict**: The 7 declared pinned declarations all exist with correct signatures and faithful proofs; no must-fix blocking findings. Two major items require blueprint-side note/title updates to remove stale claims about `IsLocallyTrivial` hypotheses that no longer exist in the Lean after iter-238.
