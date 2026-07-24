---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.cechCochain_d12_π
docstring: '**Componentwise degree-`1` Čech differential.**  The `x`-component of
  `d¹` is the

  alternating sum of the three coface restrictions.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.cechCochain_d12_π
type: lean
updated: '2026-07-24T17:02:57'
---
lemma cechCochain_d12_π (x : Fin 3 → ι) :
    (Scheme.cechCochain C F 𝒰).d 1 2 ≫ Pi.π (cechTerm 𝒰 F 3) x
      = Pi.π (cechTerm 𝒰 F 2) (x ∘ Fin.succAboveOrderEmb 0)
          ≫ F.obj.map (homOfLE (prodOpens_δ_le 𝒰 0 x)).op
        - Pi.π (cechTerm 𝒰 F 2) (x ∘ Fin.succAboveOrderEmb 1)
          ≫ F.obj.map (homOfLE (prodOpens_δ_le 𝒰 1 x)).op
        + Pi.π (cechTerm 𝒰 F 2) (x ∘ Fin.succAboveOrderEmb 2)
          ≫ F.obj.map (homOfLE (prodOpens_δ_le 𝒰 2 x)).op := by
  have h0 := cechCosimplicial_δ_π_restrict 𝒰 F 1 0 x
  have h1 := cechCosimplicial_δ_π_restrict 𝒰 F 1 1 x
  have h2 := cechCosimplicial_δ_π_restrict 𝒰 F 1 2 x
  have hd : (Scheme.cechCochain C F 𝒰).d 1 2 ≫ Pi.π (cechTerm 𝒰 F 3) x
      = ((cechCosimplicial 𝒰 F).δ 0 - (cechCosimplicial 𝒰 F).δ 1 + (cechCosimplicial 𝒰 F).δ 2)
          ≫ Pi.π (cechTerm 𝒰 F 3) x :=
    congrArg (· ≫ Pi.π (cechTerm 𝒰 F 3) x) (cechCochain_d12_eq 𝒰 F)
  exact hd.trans ((Preadditive.add_comp _ _ _ _ _ _).trans
    (congrArg₂ (· + ·) ((Preadditive.sub_comp _ _ _).trans (congrArg₂ (· - ·) h0 h1)) h2))