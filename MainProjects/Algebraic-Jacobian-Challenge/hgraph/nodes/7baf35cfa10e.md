---
author: sync
content_type: theorem
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.cechCosimplicial_δ_π
docstring: '**Single-coface component of the Čech cosimplicial object.** The `i₀`-th
  coface map

  `Yδ_{i₀} : Č^n ⟶ Č^{n+1}`, projected to the factor indexed by `j : Fin (n+2) → ι`,
  is the factor

  `j ∘ δ_{i₀}` of the source followed by the reindexing restriction

  `Γ(⨅ₐ 𝒰(j(δ_{i₀} a))) ⟶ Γ(⨅ₐ 𝒰(j a))`.  Derived by unfolding

  `cosimplicialObjectFunctor` (`evalOp` of the Čech nerve) and `Pi.lift ≫ Pi.π`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.cechCosimplicial_δ_π
type: lean
updated: '2026-07-24T17:02:57'
---
theorem cechCosimplicial_δ_π (n : ℕ) (i₀ : Fin (n + 2)) (j : Fin (n + 2) → ι) :
    (cechCosimplicial 𝒰 F).δ i₀ ≫ Pi.π _ j
      = Pi.π _ (j ∘ (Fin.succAboveOrderEmb i₀)) ≫
          ((sheafToPresheaf _ _).obj F).map
            (Pi.lift (fun a => Pi.π ((FormalCoproduct.mk _ 𝒰).obj ∘ j)
              ((Fin.succAboveOrderEmb i₀) a))).op := by
  simp only [cechCosimplicial, CosimplicialObject.δ,
    FormalCoproduct.cosimplicialObjectFunctor_obj_map]
  erw [Limits.Pi.lift_π]
  rfl