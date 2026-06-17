# Lean ↔ Blueprint Check Report

## Slug
ts-iter202

## Iteration
202

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: def:scheme_modules_tensorobj)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.tensorObj` at L113
- **Signature matches**: yes
  - Blueprint: "For M, N ∈ Scheme.Modules X, define M ⊗_X N ∈ Scheme.Modules X"
  - Lean: `{X : Scheme.{u}} (M N : X.Modules) : X.Modules` ✓
- **Proof follows sketch**: N/A — scaffold; typed `:= sorry` expected; body is iter-203+ work
- **Notes**: `\leanok` on the blueprint statement block is correct (typed sorry present). Blueprint's construction description (sheafification of the presheaf-level tensor) is the intended body; no mismatch in intent.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` at L127
- **Signature matches**: yes — for the morphism-action part
  - Blueprint: "a pair of morphisms f : M → M' and g : N → N' determines a morphism f ⊗ g : M ⊗_X N → M' ⊗_X N'"
  - Lean: `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'` ✓
- **Proof follows sketch**: N/A — scaffold
- **Notes**: The blueprint's `lem:scheme_modules_tensorobj_functoriality` statement also lists the natural isomorphisms (associator α, unitors λ, ρ, and braiding β) alongside the morphism action. In Lean convention these structural isos belong in the monoidal-category instance, not in a separate `def`; the decomposition (morphism action here, structural data in `monoidalCategory`) is standard and defensible. Blueprint uses `\begin{lemma}` but Lean uses `def` — correct in Lean because the target type is a morphism, not a Prop.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` (chapter: thm:scheme_modules_monoidal)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.monoidalCategory` at L146 (instance)
- **Signature matches**: **partial** — see major finding below
  - Blueprint claims: "canonical **symmetric** MonoidalCategory structure" satisfying "the pentagon, triangle, and **hexagon** axioms of a symmetric monoidal category," with braiding β_{M,N} and the symmetric monoidal variant.
  - Lean provides: `MonoidalCategory X.Modules` — the basic monoidal structure only (tensor, unit, associator, left/right unitors, pentagon + triangle axioms).
  - **Missing**: braiding β and hexagon axioms (= the `BraidedMonoidalCategory` / `SymmetricMonoidalCategory` layer). No stub for a `braidedMonoidalCategory` or `symmetricMonoidalCategory` instance exists anywhere in the file.
- **Proof follows sketch**: N/A — scaffold
- **Notes**: The blueprint's proof sketch references "hexagon for the braiding" and "Symmetry of β." The downstream consumer `addCommGroup_via_tensorObj` needs commutativity on isomorphism classes of line bundles (`[L] + [L'] = [L'] + [L]`), which in the formal setting derives from the symmetric monoidal axioms. Without a `SymmetricMonoidalCategory` (or at minimum `BraidedMonoidalCategory`) instance, the consumer's iter-204 body cannot appeal to this structure. The Lean instance name `monoidalCategory` is appropriate for the basic monoidal part, but the braiding layer needs a second instance (e.g., `symmetricMonoidalCategory`) or the `monoidalCategory` instance should be changed to `SymmetricMonoidalCategory`.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: thm:rel_pic_addcommgroup_via_tensorobj)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` at L217
- **Signature matches**: yes
  - Blueprint: AddCommGroup on `Pic(C ×_k T) / π_T^* Pic(T)`
  - Lean: `{S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` ✓
  - The Lean generalises `k` to an arbitrary base scheme `S`; the blueprint fixes a field `k` in its motivation text but the algebraic structure applies at this generality. Defensible.
- **Proof follows sketch**: N/A — scaffold
- **Notes**: Blueprint expects `thm:rel_pic_addcommgroup_via_tensorobj` to use `lem:pullback_compatible_with_tensorobj` (Piece 3d) in its proof (appears in the `\uses{}` block). The Lean body is a typed sorry, so no incompatibility now, but the iter-204 body will require Piece 3d to exist.

  **`def` vs `instance` choice is defensible**: the docstring correctly explains the diamond-avoidance reason (the typed-sorry `PicSharp.addCommGroup` instance in `RelPicFunctor.lean` L235 would conflict). The blueprint does not mandate an `instance` vs `def` distinction; a `def` returning an `AddCommGroup` structure faithfully embodies the blueprint claim.

---

## Red flags

No must-fix-this-iter red flags. Typed `:= sorry` bodies are expected for the scaffold lane; none of the sorry'd declarations have the excuse-comment patterns (`-- TODO replace`, `-- temporary`, `-- wrong but works`). The docstrings are honest about iter status.

### Structural gap (not a sorry issue, but flagged for tracking)
- **`monoidalCategory` at L146**: instance type is `MonoidalCategory X.Modules` but blueprint claims a symmetric monoidal structure. No `BraidedMonoidalCategory` or `SymmetricMonoidalCategory` stub exists anywhere in the file. **See major finding under severity.**

---

## Unreferenced declarations (informational)

Three helper declarations have no `\lean{...}` pin in the blueprint (they are documented as PUSH-BEYOND in the blueprint's §4 / LOC estimate section but not given a pin):

| Lean declaration | Blueprint lemma | Comment |
|---|---|---|
| `Scheme.Modules.tensorObj_isLocallyTrivial` (L165) | `lem:tensorobj_preserves_locally_trivial` | Helper; no pin; acceptable |
| `Scheme.Modules.exists_tensorObj_inverse` (L178) | `lem:tensorobj_inverse_invertible` | Helper; no pin; acceptable |
| `Scheme.Modules.tensorObjOnProduct` (L190) | `lem:tensorobj_lift_onproduct` | Has a non-sorry body (uses sorry'd `tensorObj_isLocallyTrivial`); the explicit struct construction is ahead of the blueprint description but correct in spirit |

These are all in the PUSH-BEYOND zone and their absence from `\lean{...}` pins is expected.

**Notable absent stub:** `lem:pullback_compatible_with_tensorobj` (Piece 3d, "π_T^* is a tensor functor") — see Blueprint adequacy below.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 `\lean{...}`-pinned declarations have stubs. The 3 helper lemmas (Pieces 3a–3c) have stubs without blueprint pins — acceptable for PUSH-BEYOND helpers. **Piece 3d (`lem:pullback_compatible_with_tensorobj`) has neither a `\lean{...}` pin nor a Lean stub** — see below.
- **Proof-sketch depth**: **adequate**. All four pinned blocks have explicit proof sketches with clear mathematical steps (affine descent, sheafification functor argument, standard ring-module tensor identities). The LOC estimates and sequencing section (§5) is unusually detailed and gives the iter-203 prover clear entry points.
- **Hint precision**: **loose on one point**. The `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` hint pins the name but does not specify whether the Lean typeclass target is `MonoidalCategory`, `BraidedMonoidalCategory`, or `SymmetricMonoidalCategory`. The blueprint prose says "symmetric MonoidalCategory" — the hint should either name `SymmetricMonoidalCategory` or note that a companion `symmetricMonoidalCategory` instance will be added.
- **Generality**: matches need — the constructions are at the right level of generality (`Scheme.{u}`, general `S`).
- **Recommended chapter-side actions**:
  1. **Add a `\lean{...}` pin for `lem:pullback_compatible_with_tensorobj`** (Piece 3d), or add a `% NOTE:` annotation explaining it will be introduced without a pin. Without this, the blueprint's `\uses{}` graph for `thm:rel_pic_addcommgroup_via_tensorobj` references a block with no Lean target.
  2. **Clarify the Lean typeclass** for `thm:scheme_modules_monoidal`: change the prose "canonical symmetric MonoidalCategory structure" to explicitly name `SymmetricMonoidalCategory` (or describe that the skeleton lands as `MonoidalCategory` now and a `SymmetricMonoidalCategory` companion follows in iter-203).

---

## Severity summary

### Major
- **`monoidalCategory` instance type is `MonoidalCategory X.Modules`, not `SymmetricMonoidalCategory X.Modules`.**
  The blueprint's `thm:scheme_modules_monoidal` claims "canonical symmetric MonoidalCategory structure" and explicitly includes braiding β and hexagon axioms. The Lean instance captures only the basic monoidal structure (pentagon + triangle). No `BraidedMonoidalCategory` or `SymmetricMonoidalCategory` stub exists in the file. The downstream consumer `addCommGroup_via_tensorObj` needs commutativity, which ultimately requires the symmetric layer. Fixable in-place: either (a) change the instance head to `SymmetricMonoidalCategory X.Modules` (which extends `MonoidalCategory`) and add the sorry'd braiding/symmetry fields, or (b) add a second `noncomputable instance symmetricMonoidalCategory {X : Scheme.{u}} : SymmetricMonoidalCategory (X.Modules) := sorry` stub alongside the existing one. Option (b) keeps the name `monoidalCategory` aligned with the blueprint pin.

### Informational
- **`lem:pullback_compatible_with_tensorobj` (Piece 3d) has no Lean stub.** Explicitly a scaffold gap (helper budget 0, PUSH-BEYOND); not a must-fix for iter-202. Must land before the iter-204 consumer body can close: `addCommGroup_via_tensorObj`'s proof sketch uses `lem:pullback_compatible_with_tensorobj` to establish that `π_T^*` is a group homomorphism (needed to show `π_T^* Pic(T)` is a subgroup of an abelian group). Adding a typed-sorry stub for this in iter-203 is recommended.
- **Blueprint `\lean{...}` hint precision for `monoidalCategory`**: the blueprint should name the target typeclass explicitly (see chapter-side actions above). Low urgency in the scaffold phase; becomes critical before iter-203 prover work on Piece 2.

### No must-fix-this-iter findings
All sorries are expected (scaffold lane). No excuse-comments, no axioms, no trivially-satisfiable bodies, no weakened-wrong definitions.

---

**Overall verdict**: The scaffold file is faithful for 3 of the 4 pinned declarations; the `monoidalCategory` instance is a partial signature mismatch (major) because it omits the braiding/symmetry layer the blueprint claims, which the iter-204 consumer will require — a `SymmetricMonoidalCategory` stub should be added in iter-203 alongside or instead of the current `MonoidalCategory` instance. The missing `lem:pullback_compatible_with_tensorobj` stub is a known gap (PUSH-BEYOND, informational). No must-fix-this-iter findings. — 4 declarations checked, 1 major finding (signature partial mismatch on `monoidalCategory`), 1 informational (missing Piece 3d stub).
