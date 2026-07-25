---
author: sync
content_type: theorem
created: '2026-07-16T21:14:29'
decl: AlgebraicGeometry.Scheme.PrimeDivisor.functionFieldIso_compat
docstring: "**Morphism-level compatibility for the function-field iso.** For an integral\n\
  scheme `X`, a nonempty integral open `U`, and a prime divisor `Y` of `X` with\n\
  `Y.point ∈ U`, the square\n```\n  stalk_U Y  --stalkSpec_U-->  functionField U\n\
  \      |                              |\n   stalkIso                     functionFieldIso\n\
  \      v                              v\n  stalk_X Y  --stalkSpec_X-->  functionField\
  \ X\n```\ncommutes in `CommRingCat`, where the horizontal maps are the canonical\n\
  `stalkSpecializes` maps to the respective generic points (i.e. the algebra\nmaps\
  \ `O_{·,Y} → K(·)`)."
file: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PrimeDivisor.functionFieldIso_compat
type: lean
updated: '2026-07-26T02:25:43'
---
theorem Scheme.PrimeDivisor.functionFieldIso_compat {X : Scheme.{u}} [IsIntegral X]
    (U : X.Opens) [Nonempty U] [IsIntegral U.toScheme]
    (Y : X.PrimeDivisor) (hYU : Y.point ∈ U) :
    U.toScheme.presheaf.stalkSpecializes
        ((genericPoint_spec U.toScheme).specializes (Set.mem_univ
          (Scheme.PrimeDivisor.restrictToOpen U Y hYU).point)) ≫
        (Scheme.Opens.functionFieldIso U).hom =
      (Scheme.PrimeDivisor.stalkIso U Y hYU).hom ≫
        X.presheaf.stalkSpecializes
          ((genericPoint_spec X).specializes (Set.mem_univ Y.point)) := by
  apply TopCat.Presheaf.stalk_hom_ext
  intro V hxV
  have hcongr : ∀ {a b : X} (e : Inseparable a b),
      (X.presheaf.stalkCongr e).hom = X.presheaf.stalkSpecializes e.ge := by
    intros; rfl
  simp only [Scheme.PrimeDivisor.stalkIso, Scheme.Opens.functionFieldIso, Iso.trans_hom,
    restrictToOpen_point, hcongr]
  simp only [TopCat.Presheaf.germ_stalkSpecializes_assoc,
    Scheme.Opens.germ_stalkIso_hom_assoc]
  exact (TopCat.Presheaf.germ_stalkSpecializes _ _ _).trans
    (TopCat.Presheaf.germ_stalkSpecializes _ _ _).symm