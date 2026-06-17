# Refactor result — thread `_hf` through the Rigidity-Lemma helpers (iter-158)

**Status: COMPLETE. Build GREEN, axioms as required, `_hf` genuinely consumed.**

## What changed (sole file: `AlgebraicJacobian/AbelianVarietyRigidity.lean`)

Three signature edits + two docstring updates, exactly per directive. No proofs filled.

### 1. `rigidity_eqOn_dense_open` (re-signed, body stays `sorry`)
Brought up to the full instance set and threaded the collapse data:
```
theorem rigidity_eqOn_dense_open
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (y₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Y)
    (z₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Z)
    (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀) :
    ∃ U : (X ⊗ Y).left.Opens, (U : Set (X ⊗ Y).left).Nonempty ∧ …
```
Existential conclusion unchanged. Docstring updated to record that the lemma now carries the
collapse hypothesis `_hf : f(X × {y₀}) = {z₀}` (the thing that makes Mumford's `V := Y∖G`
non-empty, `y₀ ∉ G`) and is false without it.

### 2. `rigidity_core` (re-signed; gluing proof unchanged except the threaded call)
Added `y₀ z₀ _hf` after `f` and `x₀`:
```
theorem rigidity_core
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (y₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Y)
    (z₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Z)
    (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀) :
    f = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f := by
```
Proof call updated: `obtain ⟨U, hU, h⟩ := rigidity_eqOn_dense_open f x₀ y₀ z₀ _hf`. The rest of
the gluing (`irreducibleSpace_of_subsingleton`, `isDominant_ι`, `Over.OverMorphism.ext`,
`ext_of_isDominant_of_isSeparated'`) is verbatim. Docstring updated to note `_hf` is passed
straight through.

### 3. `rigidity_lemma` (signature untouched; proof now consumes `_hf`)
Final proof line changed from `exact rigidity_core f x₀` to
`exact rigidity_core f x₀ y₀ z₀ _hf`. The `refine ⟨…⟩; rw [← Category.assoc,
rigidity_snd_lift]` prefix is verbatim.

## Verification
- `lake build`: **GREEN** (8332 jobs, `AlgebraicJacobian.AbelianVarietyRigidity` built clean).
- **Exactly four `sorry`** in the file: L89 `rigidity_eqOn_dense_open` (now honest, carries
  `_hf`), L280 `morphism_P1_to_grpScheme_const`, L304 `genusZero_curve_iso_P1`, L329
  `rigidity_genus0_curve_to_grpScheme`. No new sorries.
- **`_hf` consumed**: no dead-hypothesis warning on `rigidity_lemma` (none emitted by the
  build; the `_`-prefix is retained but the value flows into `rigidity_core`).
- **Axiom sets** (`lean_verify`):
  - `AlgebraicGeometry.rigidity_lemma` → `{propext, sorryAx, Classical.choice, Quot.sound}` ✓
  - `AlgebraicGeometry.rigidity_core` → `{propext, sorryAx, Classical.choice, Quot.sound}` ✓
    (sorryAx enters only via the honest `rigidity_eqOn_dense_open`)
  - `AlgebraicGeometry.rigidity_snd_lift` → `{propext, Classical.choice, Quot.sound}` —
    **sorryAx-free** ✓
- No new axioms. The three deferred scaffolds' docstrings were left untouched. No `.tex` edits.

The unsound decomposition is now sound: the genuine geometric obligation lives in
`rigidity_eqOn_dense_open`, which now carries the rigidifying `_hf` that makes its (still
deferred) statement *true*. That single honest sorry is next iteration's prover lane.
