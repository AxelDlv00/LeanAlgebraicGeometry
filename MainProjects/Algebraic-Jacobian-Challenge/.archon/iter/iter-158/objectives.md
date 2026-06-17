# Iter-158 objectives (detail)

## Lane: `AlgebraicJacobian/AbelianVarietyRigidity.lean` — `rigidity_eqOn_dense_open`

Single DEEP lane. Target: the body of `rigidity_eqOn_dense_open` (L89; `sorry` at L104),
the sole genuine geometric gap of the now-sound Rigidity-Lemma chain.

### Why this is the right target (not `rigidity_lemma`)
- iter-158 `refactor thread-hf` already closed `rigidity_lemma` + `rigidity_core` (proofs
  compile, consume `_hf`, axiom-clean modulo the one honest sorry below). A prover at
  `rigidity_lemma` would no-op.
- The corrected `rigidity_eqOn_dense_open` carries the collapse data `(y₀) (z₀) (_hf)` and
  is TRUE as stated (the iter-157 version dropped `_hf` and was false — `f=fst`).

### Statement (current, post-refactor)
Instances `[IsProper X.hom] [GeometricallyIrreducible (X⊗Y).hom] [IsReduced (X⊗Y).left]
[IsSeparated Z.hom]`; `(f : X⊗Y ⟶ Z)`, `(x₀ : 𝟙_ ⟶ X)`, `(y₀ : 𝟙_ ⟶ Y)`, `(z₀ : 𝟙_ ⟶ Z)`,
`(_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀)`. Conclusion: `∃ U : (X⊗Y).left.Opens`,
`U` non-empty ∧ `U.ι ≫ f.left = U.ι ≫ (lift (toUnit (X⊗Y) ≫ x₀) (snd X Y) ≫ f).left`.

### Proof recipe (Mumford, Abelian Varieties, Ch. II §4, p. 43)
`U₀` affine open ∋ `z₀`; `F = Z∖U₀`; `G = snd '' (f⁻¹ F)`. `X` complete ⟹ `snd` closed map
⟹ `G` closed; `_hf` ⟹ `f(X×{y₀}) = {z₀} ⊆ U₀` ⟹ `y₀ ∉ G` ⟹ `V := Y∖G` non-empty open;
`U := X × V`; for `y ∈ V`, proper integral slice `X×{y}` → affine `U₀` ⟹ image a point ⟹
`f(x,y) = f(x₀,y) = (retract ≫ f)(x,y)`.

### Two char-free Mathlib bridges (located iter-157, not yet wired)
1. closed-map: `IsProper.toUniversallyClosed` + `UniversallyClosed.universally_isClosedMap`
   `[verified-exist]`. **Assembly obstruction:** identify monoidal `snd X Y` in
   `Over (Spec k̄)` with `Limits.pullback.snd X.hom Y.hom`; transport `IsClosedMap`. Search
   `MorphismProperty.pullback`, `Over.tensor`, `Limits.pullback.snd`.
2. affine-constancy: `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed`
   `[verified-exist]` + `[IsAlgClosed kbar]` ⟹ slice → point.

### Stop condition / fallback
If bridge 1 (the monoidal-`snd`-as-pullback identification) needs a BUILT lemma rather than
a located one, STOP and report it precisely. iter-159 dispatches a `mathlib-analogist`
consult scoped to that identification (progress-critic's binding fallback) rather than a
blind re-run. Partial progress (one bridge, or the identification) is a legitimate result.

### Do NOT touch
`rigidity_lemma`, `rigidity_core`, `rigidity_snd_lift` (closed); the three deferred siblings
(`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`).
