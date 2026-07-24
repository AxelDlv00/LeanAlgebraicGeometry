---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechSectionHomotopyZero
docstring: 'The bottom homotopy component `Č⁰ ⟶ Γ(V, F)`: project onto the `i_fix`-coordinate
  and

  restrict along `V ≤ U''_{i_fix}` (the `π_{i_fix}` of the Stacks projection homotopy).'
file: AlgebraicJacobian/Cohomology/CechSectionContractibilityCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechSectionHomotopyZero
type: lean
updated: '2026-07-24T10:02:45'
---
noncomputable def cechSectionHomotopyZero :
    (cechSectionAugComplex 𝒰 F V).X 1 ⟶ (cechSectionAugComplex 𝒰 F V).X 0 :=
  Pi.π (fun τ : Fin 1 → 𝒰.I₀ =>
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
        (Opposite.op (⨅ l, (coverOpen 𝒰 (τ l) ⊓ V)))) (Fin.cons i_fix Fin.elim0) ≫
    ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.map
      (homOfLE (homotopyOpen_le_prepend 𝒰 V i_fix hiV Fin.elim0)).op