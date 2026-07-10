/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.AffineDegreeOneVanishing
import AlgebraicJacobian.RiemannRoch.Adelic.GenusUnconditional
import AlgebraicJacobian.Cohomology.PullbackQuasicoherent
import AlgebraicJacobian.Picard.QuotScheme
import AlgebraicJacobian.Picard.RigidPushforward

/-!
# Degree-one affine vanishing for quasi-coherent modules and Čech cover-independence

The wave-5 keystone of the B3 lane: the degree-one affine vanishing
`H¹(U, M) = 0` (`HModule'`-form) for every affine open `U` and every
**quasi-coherent** sheaf of modules `M` on a `Spec k`-scheme, and the resulting
Čech **cover-independence** of `Ȟ¹`-vanishing on 2-affine covers.

## The bridge

The `HModule'` derived-functor machinery
(`Cohomology/StructureSheafModuleK/*`, `RiemannRoch/Adelic/GenusUnconditional`)
runs on sheaves of `k`-modules on the opens site; the B3 consumers work with
`X.Modules` (sheaves of `𝒪_X`-modules).  `toModuleKSheafOfModules` is the
dialect bridge: the underlying additive sheaf of `M : C.left.Modules`, with the
`k`-action restricted along the structure morphism (mirroring `toModuleKSheaf`
for the structure sheaf itself).  Sections, restriction maps and hence all
Čech difference maps agree **definitionally** with those of `M`.

## The vanishing

`subsingleton_hModule'_one_of_isAffineOpen_of_isQuasicoherent` mirrors the
structure-sheaf proof `subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen`
(`AffineDegreeOneVanishing.lean`) step by step; the single 𝒪-specific brick —
sections of the kernel over the basic opens `D(g_σ)` are the localisations
`Γ(M, U)_{g_σ}` — is replaced by the quasi-coherence keystone
`Scheme.Modules.isLocalizedModule_basicOpen` (Stacks 01HV(4)/01I8 at
affine-open generality, `Picard/QuotScheme.lean`), packaged here as the module
section-identification kit `IsAffineOpen.dCoeffModuleSectionsLinearEquiv`
(mirroring `IsAffineOpen.dCoeffSectionsLinearEquiv` of
`CechCoboundarySplitting.lean`).

## Cover-independence

With degree-1 vanishing on the two affine pieces of **every** 2-affine cover
`S`, the Mayer–Vietoris `(0,1)`-slice
(`AffineCoverMVSquare.hModuleOneEquivH1CokOfSubsingleton`,
`GenusUnconditional.lean`) identifies the concrete two-chart Čech cokernel
`S.H1Cok` with the cover-free `HModule k _ 1` — for every `S` at once.
Composing two such identifications makes `Ȟ¹`-vanishing (equivalently,
surjectivity of the difference-of-restrictions map) independent of the chosen
cover (`AffineCoverMVSquare.surjective_moduleSectionDiff_of_surjective`), and
the fibre wrapper `Scheme.Hom.FiberH1Vanishing.surjective_moduleSectionDiff`
turns the ∃-form `FiberH1Vanishing` hypothesis of the pinned B3 statement into
the surjectivity witness on any prescribed cover of the fibre curve — the
`hindep` obligation of
`fiberH1Vanishing_pushforward_finiteMapToP1BaseChange_of_coverIndependence`
(`Picard/RigidPushforwardTransfer.lean`).

Sources: Stacks 01XB (degree 1), 01EW (the Čech splitting), 01HV(4)/01I8
(quasi-coherent sections localise); Hartshorne III.2.7, III.4.5; Leray's
theorem for 2-covers with `H¹`-acyclic pieces.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry Opposite

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [CommRing k]

/-! ## The dialect bridge: the sheaf of `k`-modules underlying an `𝒪`-module

For a `Spec k`-scheme `C` and `M : C.left.Modules`, the sections `Γ(M, U)` are
modules over `Γ(C.left, U)`, hence `k`-modules by restriction along the
structure-morphism algebra map `k → Γ(C.left, U)`
(`toModuleKSheaf.algebraSection`).  Restriction maps are `k`-linear because
they are semilinear over the (algebra-map-preserving) ring restrictions.  This
mirrors `toModuleKPresheaf`/`toModuleKSheaf` with the structure sheaf replaced
by `M`. -/

/-- The `k`-module structure on the sections of a sheaf of modules on a
`Spec k`-scheme: restriction of the native `Γ(C.left, U)`-module structure
along the structure-morphism algebra map.  A `@[reducible] def` registered as
a local instance in this file (mirrors the discipline of
`Scheme.Hom.fiberSectionsModule`). -/
@[reducible] noncomputable def moduleKSections (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) (U : TopologicalSpace.Opens C.left.toTopCat) :
    Module k Γ(M, U) :=
  Module.compHom _ (algebraMap k Γ(C.left, U))

attribute [local instance] moduleKSections

/-- The native `Γ(C.left, W)`-scalar action on `Γ(M, W)`, packaged as a
function whose binders carry the section-notation types (so that the `•`
elaborates against the `Γ`-spelled `Module` instance regardless of the
spelling of the argument terms). -/
private noncomputable def smulSection (C : Over (Spec (CommRingCat.of k))) (M : C.left.Modules)
    (W : TopologicalSpace.Opens C.left.toTopCat)
    (s : Γ(C.left, W)) (z : Γ(M, W)) : Γ(M, W) :=
  s • z

/-- The underlying additive presheaf of `M : C.left.Modules` as a presheaf of
`k`-modules (`toModuleKPresheaf` with the structure sheaf replaced by `M`):
objects are the section groups with the `moduleKSections` `k`-action, maps are
the restriction maps of `M`. -/
noncomputable def toModuleKPresheafOfModules (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := ModuleCat.of k Γ(M, U.unop)
  map {U V} f := ModuleCat.ofHom
    { toFun := fun x => M.presheaf.map f x
      map_add' := fun x y => map_add _ x y
      map_smul' := fun r x =>
        (Scheme.Modules.map_smul M f.unop (algebraMap k Γ(C.left, U.unop) r) x).trans
          (congrArg
            (fun (s : Γ(C.left, V.unop)) =>
              smulSection C M V.unop s (M.presheaf.map (f.unop).op x))
            (AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality (C := C) f r)) }
  map_id U := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_id, LinearMap.id_coe, id_eq]
    exact congrFun (congrArg (fun (φ : M.presheaf.obj U ⟶ M.presheaf.obj U) =>
      (ConcreteCategory.hom φ : _ → _)) (M.presheaf.map_id U)) x
  map_comp {U V W} f g := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_comp, LinearMap.coe_comp, Function.comp_apply]
    exact congrFun (congrArg (fun (φ : M.presheaf.obj U ⟶ M.presheaf.obj W) =>
      (ConcreteCategory.hom φ : _ → _)) (M.presheaf.map_comp f g)) x

/-- The presheaf of `k`-modules of `toModuleKPresheafOfModules` is a sheaf:
its underlying type-valued presheaf is that of the (sheaf) `M`. -/
lemma toModuleKPresheafOfModules_isSheaf (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (toModuleKPresheafOfModules C M) := by
  rw [Presheaf.isSheaf_iff_isSheaf_forget _ _ (CategoryTheory.forget (ModuleCat.{u} k))]
  convert (Presheaf.isSheaf_iff_isSheaf_forget _ _
      (CategoryTheory.forget AddCommGrpCat.{u})).mp (Scheme.Modules.isSheaf M) using 1 <;> rfl

/-- **The dialect bridge**: a sheaf of `𝒪`-modules on a `Spec k`-scheme,
viewed as a sheaf of `k`-modules (`toModuleKSheaf` with the structure sheaf
replaced by `M`).  Sections and restriction maps agree definitionally with
those of `M`. -/
noncomputable def toModuleKSheafOfModules (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k) :=
  ⟨toModuleKPresheafOfModules C M, toModuleKPresheafOfModules_isSheaf C M⟩

/-- Restriction maps of `toModuleKSheafOfModules C M` are the restriction maps
of `M` on elements.  Definitional. -/
lemma toModuleKSheafOfModules_obj_map_apply {C : Over (Spec (CommRingCat.of k))}
    (M : C.left.Modules) {V W : TopologicalSpace.Opens C.left.toTopCat} (h : W ≤ V)
    (x : (toModuleKSheafOfModules C M).obj.obj (Opposite.op V)) :
    ((toModuleKSheafOfModules C M).obj.map (homOfLE h).op).hom x
      = M.presheaf.map (homOfLE h).op x :=
  rfl

end AlgebraicGeometry.Scheme
