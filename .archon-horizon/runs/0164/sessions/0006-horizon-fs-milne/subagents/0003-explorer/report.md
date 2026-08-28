Read-only reconnaissance is complete. The immediate, small candidate is the local Nakayama core for `I.5.11`:

```lean
import Mathlib.RingTheory.Nakayama

namespace MilneLib

theorem LinearMap.surjective_of_surjective_residue
    {R M N : Type*} [CommRing R] [IsLocalRing R]
    [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] [Module.Finite R N]
    (f : M →ₗ[R] N)
    (hf : Function.Surjective
      (((IsLocalRing.maximalIdeal R) • (⊤ : Submodule R N)).mkQ ∘ₗ f)) :
    Function.Surjective f := by
  exact LinearMap.surjective_of_surjective_comp_mkQ f _
    (IsLocalRing.maximalIdeal_le_jacobson _) hf

end MilneLib
```

I verified this signature with `lake env lean --stdin`. It should live in `MilneLib/Nakayama.lean`, with `import MilneLib.Nakayama` added to `MilneLib.lean`. The likely graph link is `lem:milne-5-11` (`8206e8e8e5b5`), as a partial/core `\lean` link rather than `\leanok`, because the localization and coherent-sheaf clauses remain.

The chapter-3 node `prop:milne-descent-varieties` (`6d39f3916095`) is still empty; full quasi-projective scheme/coherent-sheaf descent is not a bounded next unit. AJCR’s `Module.DescentDatum` API is a useful model but is a roughly 330-line project-local development and should not be imported wholesale into Milne.
