# Lean ↔ Blueprint Check Report

## Slug
ts-iter206

## Iteration
206

## Files audited
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (L113)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`; matches the blueprint's definition of `M ⊗_X N ∈ Scheme.Modules X`.
- **Proof follows sketch**: yes — body applies `PresheafOfModules.sheafification` to `PresheafOfModules.Monoidal.tensorObj M.val N.val`, exactly as the blueprint describes.
- **Notes**: Non-sorry. `\leanok` in blueprint is correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (L129)
- **Signature matches**: partial — the Lean declaration provides only the morphism action `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'` (the bifunctoriality part). The blueprint *statement* additionally claims four named natural isos λ, ρ, α, β are provided; none of these has a corresponding Lean declaration. The body of `tensorObj_functoriality` is non-sorry and correct for what it covers.
- **Proof follows sketch**: yes for the bifunctor action; N/A for λ, ρ, α, β (not formalised, not sorry-scaffolded either).
- **Notes**: The `rem:scheme_modules_monoidal_off_path` block correctly records that the full MonoidalCategory is off the critical path, but the *statement* of `lem:scheme_modules_tensorobj_functoriality` still claims λ, ρ, α, β are present outputs of this lemma. This is a prose-vs-Lean scope mismatch: the blueprint overpromises the scope of the Lean declaration. `\leanok` on this block is technically correct (the declaration compiles), but a reader of the statement would expect separate named Lean declarations for the natural isos. **See major finding M2.**

---

### `lem:tensorobj_restrict_iso` (chapter: `lem:tensorobj_restrict_iso`) — NO `\lean{...}` pin
- **Lean target exists**: yes, named in prose as `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` (L244), but no `\lean{...}` marker in the chapter.
- **Signature matches**: yes — the Lean signature `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` matches the blueprint's "the canonical comparison morphism (L ⊗ M)|_f → L|_f ⊗_U M|_f is an isomorphism."  Note: the Lean signature is *general* (all `X.Modules`, not just line bundles), which is correct even though the blueprint statement (and its title) specifies line bundles. The Lean declaration is therefore at the *right* or *broader* level of generality, which is acceptable.
- **Proof follows sketch**: **no — the blueprint proof sketch is not formalizable as written** (see must-fix F1 and the detailed blueprint-adequacy section).
- **Notes**: Body ends with `sorry` after two genuine Mathlib reduction steps (`restrictFunctorIsoPullback` + `sheafificationCompPullback`). This sorry is correctly documented and its residual is precisely identified. **The \lean{...} pin is missing — see major finding M1.**

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (L294)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`.
- **Proof follows sketch**: yes structurally — picks a common affine W inside trivialising opens for M and N, refines trivialisations via `restrictIsoUnitOfLE`, chains through `tensorObj_restrict_iso` (sorry) → `tensorObjIsoOfIso` → `tensorObj_unit_iso`. The proof is tactic-complete and compiles green; it depends transitively on the `tensorObj_restrict_iso` sorry but is not itself sorry-tagged.
- **Notes**: `\leanok` in blueprint is correct per project conventions (declaration compiles). Dependency on the open sorry in `tensorObj_restrict_iso` is acceptable as the known scaffold state.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (L320)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`. Matches the blueprint's "the dual L^{-1} is a line bundle and there is a canonical iso L ⊗ L^{-1} ≅ O_X."
- **Proof follows sketch**: N/A — body is `:= sorry` (acknowledged scaffold).
- **Notes**: `\leanok` on the statement block is correct per convention (declaration exists with sorry body). Proof block correctly lacks `\leanok`. Acknowledged per directive.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (L332)
- **Signature matches**: partial — the Lean declaration provides the *operation* on the subtype: `(L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT`. The blueprint lemma additionally asserts the unit `O_{C×T}` belongs to the subtype and the dual provides a two-sided tensor inverse within the subtype. These additional claims have no Lean declarations (they are blocked on `tensorObj_restrict_iso`). The `\lean{...}` pin therefore covers only part of what `lem:tensorobj_lift_onproduct` claims.
- **Proof follows sketch**: yes for the part that is present — `⟨tensorObj L.carrier L'.carrier, tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩` is a correct non-sorry proof of the operation-closure statement.
- **Notes**: `\leanok` on the statement block is correct per convention. The scope mismatch (blueprint claims more than the Lean target delivers) is a **major** finding M3.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (L360)
- **Signature matches**: yes — `(πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`.
- **Proof follows sketch**: N/A — body is `:= sorry` (acknowledged scaffold).
- **Notes**: `\leanok` on the statement block is correct per convention. Proof block correctly lacks `\leanok`. Acknowledged per directive.

---

## Red flags

### Placeholder / suspect bodies
- `tensorObj_restrict_iso` at L244: body ends in `sorry` after two genuine Mathlib reduction steps. The sorry is acknowledged, explicitly documented with the exact residual (missing `PresheafOfModules.pullback.Monoidal` instance), and is correctly scaffolded. Not a new finding per directive; recorded here for completeness.
- `exists_tensorObj_inverse` at L320: body `:= sorry`. Acknowledged scaffold.
- `addCommGroup_via_tensorObj` at L360: body `:= sorry`. Acknowledged scaffold.

### Excuse-comments
None. The comments throughout the file correctly document the scaffold state and the infrastructure gap; they are accurate (verified against the prover's task result) and do not excuse wrong code.

### Axioms / Classical.choice on non-trivial claims
None. Zero `axiom` declarations; zero `Classical.choice` on substantive claims. Confirmed by the task results' "zero axioms introduced."

---

## Unreferenced declarations (informational)

Three Lean declarations have no `\lean{...}` reference in the blueprint:

1. `tensorObjIsoOfIso` (L164) — helper lifting an iso-pair to a tensorObj iso via `sheafification.mapIso`; feeds `tensorObj_isLocallyTrivial`. Legitimate helper; the name is descriptive and it would be worth a bullet under a "supporting helpers" note in the blueprint, but not a primary pin.

2. `tensorObj_unit_iso` (L180) — special case iso `tensorObj O_X O_X ≅ O_X` built from the presheaf left unitor + sheafification-adjunction counit; feeds `tensorObj_isLocallyTrivial` as the O⊗O ≅ O step. Distinct from (and narrower than) the blueprint's `lem:tensorobj_unit_iso` (which is about O ⊗ L ≅ L for arbitrary line bundle L). Should not be confused with that lemma. Not a must-pin but worth distinguishing in the blueprint prose to avoid ambiguity.

3. `restrictIsoUnitOfLE` (L198) — helper for refining a trivialisation to a smaller open; feeds `tensorObj_isLocallyTrivial`. Legitimate helper; the Lean proof comments already describe it fully.

---

## Blueprint adequacy for this file

### Coverage
6/7 `\lean{...}`-pinned declarations have a corresponding Lean target. The seventh (the critical `lem:tensorobj_restrict_iso`) is mentioned only in prose with no `\lean{...}` pin.

Four blueprint blocks — `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:pullback_compatible_with_tensorobj` — have proof sketches but neither a `\lean{...}` pin nor a Lean counterpart. They are correctly blocked on `tensorObj_restrict_iso`; the prover deliberately withheld scaffold sorries for them. The blueprint does not currently signal this blocking relationship inline on those blocks.

### Proof-sketch depth: **under-specified for `lem:tensorobj_restrict_iso` (MUST-FIX)**

The proof sketch for `lem:tensorobj_restrict_iso` (blueprint lines 346–380) is the central adequacy failure. It describes a flat-exactness argument with three narrative steps:

> "The statement is local on X, so it suffices to verify it on affine opens, where both line bundles are presented by A-modules L, M over a commutative ring A and **the comparison is a map of A-modules** whose formation commutes with L ⊗_A (-). ... For a flat module the comparison is then an isomorphism by ordinary exactness. ... The affine isomorphisms are compatible along an affine cover, so they glue to the global isomorphism."

The claimed Mathlib citations are `Module.Flat.lTensor_preserves_injective_linearMap` and `Module.Invertible.lTensor_bijective_iff`.

**Why this proof sketch is not formalizable as written:**

The sketch asserts "the comparison is a map of A-modules" and then applies flatness to upgrade it to an iso. But in Mathlib at `b80f227`, `PresheafOfModules.pullback φ` is defined as an **abstract left adjoint** (`(pushforward φ).leftAdjoint`, `Mathlib/.../Presheaf/Pullback.lean:44`) with **no sectionwise formula**. Therefore:

- There is **no comparison map** `(PresheafOfModules.pullback φ.hom).obj (M.val ⊗ N.val) → (PresheafOfModules.pullback φ.hom).obj M.val ⊗ (PresheafOfModules.pullback φ.hom).obj N.val` in Mathlib.
- The comparison map is the **oplax-monoidal structure** (the mate of the strong-monoidal `pushforward`) of this functor, and it has not been constructed in Mathlib.
- Flatness would only upgrade this map from a map to an iso **after** it exists; it does not construct it.
- **Re-scoping the signature to line bundles does not unblock this**: flatness is downstream of the map construction, not a bypass of it.

The prover's two genuine reduction steps (`restrictFunctorIsoPullback` + `sheafificationCompPullback`) already discharge the "sheafification commutes with pullback" part that was previously an obstacle, leaving the goal as exactly this comparison-map construction. The prover verified that `sheafificationCompPullback` IS in Mathlib (correcting the old docstring), but the comparison at the presheaf level is not.

**What the blueprint proof sketch should say instead:**
The proof sketch should acknowledge that:
1. Step 1 (localization + gluing) is available.
2. Step 2 (sheafification commutes with pullback) is dischargeable via `SheafOfModules.sheafificationCompPullback`.
3. Step 3 (the presheaf-level base-change iso `pullback(A ⊗ B) ≅ pullback A ⊗ pullback B`) requires a project-side construction: an oplax-monoidal (or Monoidal) instance for `PresheafOfModules.pullback φ` lifting `ModuleCat.extendScalars.Monoidal` (which IS in Mathlib sectionwise at `Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction:42`) through the partial-left-adjoint construction. This is a `mathlib-build` task, not a single-lane close.
4. Only after step 3 does flatness become relevant (to confirm the resulting map is an iso for line bundles — though in fact the same argument works for all flat modules, and `PresheafOfModules.pullback φ` is strong-monoidal for flat maps, so the comparison would be an iso without the line-bundle restriction).

**Lean → blueprint assessment:** The Lean code is correctly advancing; the sorry placement and the precise residual documented in L260–281 and in `informal/tensorObj_restrict_iso.md` are accurate and well-diagnosed.

**Blueprint → Lean assessment:** The proof sketch misleads a future prover into believing flat-exactness Mathlib lemmas close the goal directly, when those lemmas are downstream of a comparison-map construction that is absent from Mathlib. A prover following the sketch would not understand why `Module.Invertible.lTensor_bijective_iff` cannot be applied to the current Lean goal. **This is a must-fix blueprint adequacy failure.**

### Hint precision: **loose for four blocked blocks / wrong on `lem:tensorobj_restrict_iso` missing pin**

- `lem:tensorobj_restrict_iso`: **no `\lean{...}` pin** despite being the most critical lemma in the chapter. The Lean name `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` appears only in prose. This should be a `\lean{...}` pin.
- `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:pullback_compatible_with_tensorobj`: no `\lean{...}` pin, no Lean declaration. These should either get pins (once scaffold sorries are added) or carry an explicit blocking note: "pending `lem:tensorobj_restrict_iso`".
- `lem:scheme_modules_tensorobj_functoriality`: the statement claims λ, ρ, α, β are outputs, but only the bifunctor morphism-action is pinned in Lean. The four natural isos have no declarations. The `rem:scheme_modules_monoidal_off_path` remark explains the policy but does not fix the overspecification in the lemma statement itself.

### Generality: **matches need / slightly over-narrow `lem:tensorobj_lift_onproduct`**

`tensorObjOnProduct` (the Lean target for `lem:tensorobj_lift_onproduct`) provides the operation but not the unit, inverse, or group-law data claimed in the blueprint lemma. The `\lean{...}` pin is therefore pointing at a narrower declaration than the full lemma scope — not a generality mismatch, but a scope mismatch of the pin.

### Recommended chapter-side actions for the blueprint-writing subagent

1. **(Must-fix)** Rewrite the proof of `lem:tensorobj_restrict_iso` (blueprint lines 346–380). Remove the assertion that flat-exactness is "elementary ... already available in Mathlib" and replace with an accurate three-step description:
   - Step 1: `restrictFunctorIsoPullback` reduces restriction to pullback (present).
   - Step 2: `SheafOfModules.sheafificationCompPullback` moves pullback inside sheafification (present — correcting the former claim of absence).
   - Step 3: The presheaf-level base-change iso `(PresheafOfModules.pullback φ.hom).obj (M ⊗ N) ≅ (PresheafOfModules.pullback φ.hom).obj M ⊗ (PresheafOfModules.pullback φ.hom).obj N` requires a project-side `Monoidal` (or explicit comparison) instance for `PresheafOfModules.pullback`, lifting `ModuleCat.extendScalars.Monoidal` through the abstract left adjoint; this is a `mathlib-build`-mode task. Once constructed, flatness of line bundles confirms the comparison is an iso, but the flatness step is downstream of, not a replacement for, the construction.
   - Add a `% NOTE: Step 3 is the open blocker as of iter-206; see informal/tensorObj_restrict_iso.md for the precise missing instance.` annotation.

2. **(Major)** Add `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` to the `lem:tensorobj_restrict_iso` block (replacing the prose-only mention).

3. **(Major)** On `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:pullback_compatible_with_tensorobj`: add a `% NOTE: no Lean declaration yet; blocked on lem:tensorobj_restrict_iso` annotation to each proof block, and (if scaffold sorries are added in a future iter) add `\lean{...}` pins.

4. **(Major)** Narrow the statement of `lem:scheme_modules_tensorobj_functoriality` to match what the Lean declaration actually provides (the bifunctor morphism action `f ⊗ g`). Move the claims about λ, ρ, α, β into a separate remark or note them as consequences following from the monoidal structure — either pointing to `rem:scheme_modules_monoidal_off_path` or marking them as off-critical-path items with no current Lean declaration.

5. **(Major)** Narrow or annotate `lem:tensorobj_lift_onproduct` to reflect that `tensorObjOnProduct` provides the operation closure on the subtype, while the unit, inverse, and group-law existence-of-iso data are separate blocked items.

6. **(Minor)** Add a brief "Supporting helpers" subsection listing `tensorObjIsoOfIso`, `tensorObj_unit_iso` (the O⊗O ≅ O helper), and `restrictIsoUnitOfLE` with a sentence each, to help readers distinguish them from the similarly-named blocked blueprint lemmas (`lem:tensorobj_unit_iso`, which is O⊗L ≅ L).

---

## Severity summary

### must-fix-this-iter

**F1 — Blueprint adequacy failure: `lem:tensorobj_restrict_iso` proof sketch is not formalizable as written.**
The proof claims "elementary flat-exactness already available in Mathlib" closes the goal, but the actual obstacle is the absence of a comparison MAP (the oplax-monoidal structure of `PresheafOfModules.pullback φ`) in Mathlib. Flatness can only upgrade an existing map to an iso; it cannot construct the map. A prover following the blueprint sketch would apply `Module.Invertible.lTensor_bijective_iff` to a goal where there is no map to apply it to. The blueprint must be rewritten to describe the actual three-step route and identify step 3 as the `mathlib-build` blocker.

### major

**M1 — Missing `\lean{...}` pin on `lem:tensorobj_restrict_iso`.**
This is the most critical lemma in the chapter and is referenced in nearly every proof sketch. Its Lean target (`AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso`) is named only in prose. A `\lean{...}` pin should be added (the directive's note confirms this recommendation).

**M2 — `lem:scheme_modules_tensorobj_functoriality` overpromises: blueprint statement claims λ, ρ, α, β but no Lean declarations for these natural isos exist.**
The Lean `tensorObj_functoriality` provides the morphism action only. The `rem:scheme_modules_monoidal_off_path` explains the policy but does not retroactively fix the lemma statement's scope mismatch.

**M3 — `lem:tensorobj_lift_onproduct` scope mismatch: blueprint claims unit + inverse + group-law data on the subtype, but `tensorObjOnProduct` only provides the operation closure.**
The four existence-of-iso group-law facts (`lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:tensorobj_inverse_invertible` restricted to the subtype) have no Lean counterparts and are blocked on `tensorObj_restrict_iso`. The `\lean{...}` pin `tensorObjOnProduct` does not adequately represent the full statement.

**M4 — Blueprint blocks `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:pullback_compatible_with_tensorobj` have no `\lean{...}` pins and no Lean declarations, and no blocking annotation.**
These are legitimately deferred (the prover correctly withheld scaffold sorries to avoid noise), but the blueprint should annotate each block with its dependency on `lem:tensorobj_restrict_iso` so future provers understand the sequencing.

### minor

**m1 — Three unreferenced helpers (`tensorObjIsoOfIso`, `tensorObj_unit_iso` at L180, `restrictIsoUnitOfLE`) are not mentioned in the blueprint.** These are legitimate; the `tensorObj_unit_iso` helper could cause confusion with the blueprint's `lem:tensorobj_unit_iso` (which is a different, broader statement). Worth a brief distinction in the blueprint prose.

---

**Overall verdict:** The Lean file is advancing correctly — three acknowledged sorries on known-blocked declarations, two substantive sorry-free constructions (`tensorObj`, `tensorObj_functoriality`) matching the blueprint, and `tensorObj_restrict_iso` correctly performing two genuine Mathlib reduction steps before a precisely-documented residual sorry. The critical failure is on the blueprint side: the proof sketch for `lem:tensorobj_restrict_iso` is not formalizable as written (must-fix), and three major scope-mismatch issues mean the chapter overstates what current Lean code provides — 7 declarations checked, 1 must-fix blueprint adequacy failure, 3 major blueprint scope mismatches, 1 major missing pin.
