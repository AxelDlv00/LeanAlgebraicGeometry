Read-only scan complete; no files were edited.

The current bounded target is the already-added `Isogeny.comp_of_finite` in [MilneLib/Isogeny.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/Isogeny.lean:67):

```lean
theorem Isogeny.comp_of_finite
    {C : Over (Spec (.of K))} [GrpObj C]
    (f : A ⟶ B) (g : B ⟶ C) [IsMonHom f] [IsMonHom g]
    [IsFinite f.left] [IsFinite g.left]
    (hf : Isogeny f) (hg : Isogeny g) :
    Isogeny (f ≫ g)
```

It compiles cleanly. The proof requires explicit `Surjective` instances from `hf.1` and `hg.1`, rewriting with `Over.comp_left`, and Mathlib’s finite pullback-projection instance. This remains stronger than the source theorem because Mathlib currently lacks a finite-kernel-to-finite-underlying-map result.

Another directly provable helper is:

```lean
theorem isFinite_isogenyKernelToBase_of_isFinite
    (f : A ⟶ B) [IsMonHom f] [IsFinite f.left] :
    IsFinite (isogenyKernelToBase f)
```

with `dsimp [isogenyKernelToBase, isogenyKernel]; infer_instance`.

`Basic.lean` is empty. `GroupScheme.lean` is axiom-free and already contains the rigidity and translation APIs. The blueprint’s isogeny characterization and dual existence/exact-sequence nodes remain unbounded due to missing dimension, Picard, and Cartier-dual infrastructure.
