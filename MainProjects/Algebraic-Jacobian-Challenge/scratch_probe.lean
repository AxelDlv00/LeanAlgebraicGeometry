/- SCRATCH probe (session 0003-horizon-T2) — DELETE BEFORE COMMIT. -/
import Mathlib

universe u

open CategoryTheory AlgebraicGeometry

-- probe 1: eqToHom iso in a general category
example {C : Type} [Category C] {X Y : C} (h : X = Y) : IsIso (eqToHom h) := inferInstance

-- probe 2: presheaf.map of eqToHom for a sheaf of modules
example {W : Scheme.{u}} (K : W.Modules) {A B : (TopologicalSpace.Opens W)ᵒᵖ} (h : A = B) :
    IsIso (K.presheaf.map (eqToHom h)) := inferInstance

-- probe 3: composite of a map-iso with a map-of-eqToHom
example {W : Scheme.{u}} (M N : W.Modules) (φ : M ⟶ N)
    {A B : (TopologicalSpace.Opens W)ᵒᵖ} (h : A = B)
    (ψ : M.presheaf.obj A ⟶ M.presheaf.obj A) (hψ : IsIso ψ) :
    IsIso (ψ ≫ M.presheaf.map (eqToHom h)) := by
  haveI := hψ
  infer_instance

-- probe 4: the pushforward-map composite of the leftAdjointUniq transport
example {X' V' : Scheme.{u}} (p' : V' ⟶ X') [IsOpenImmersion p'] (M : X'.Modules)
    (hsite : IsIso ((Scheme.Modules.restrictAdjunction p').unit.app M)) :
    IsIso ((Scheme.Modules.restrictAdjunction p').unit.app M ≫
      (Scheme.Modules.pushforward p').map
        ((Adjunction.leftAdjointUniq (Scheme.Modules.restrictAdjunction p')
          (Scheme.Modules.pullbackPushforwardAdjunction p')).hom.app M)) := by
  haveI := hsite
  infer_instance
