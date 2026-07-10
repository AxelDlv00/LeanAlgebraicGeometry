/-
Copyright (c) 2026 The Algebraic-Jacobian-Challenge contributors.
Released under Apache 2.0 license.
-/
import Mathlib
import AlgebraicJacobian.RiemannRoch.CurveBaseChange
import AlgebraicJacobian.RiemannRoch.Adelic.GenusUnconditional
import AlgebraicJacobian.Genus

/-!
# The P2 cohomology kit: `h⁰`, `h¹`, `χ` on a 2-affine Čech cover

Campaign **P2**, definitions layer (wave 4).  For a scheme `C` over a base
ring `k` (structure morphism `C.hom : C.left ⟶ Spec k`; in the campaign `k`
is a field, but the carrier layer is stated over any commutative ring so the
same kit serves the B2/B3 noetherian-base extensions), a sheaf of modules
`M : C.left.Modules`, and a bundled 2-affine Mayer–Vietoris cover
`S : C.left.AffineCoverMVSquare`, this file upgrades the `AddMonoidHom`-level
Čech vocabulary `AffineCoverMVSquare.moduleSectionDiff` /
`AffineCoverMVSquare.moduleH1Cok` (`Picard/RigidPushforward.lean`) to
`k`-linear form and defines the numerical invariants:

* `Scheme.BaseSections C M U` — the sections `Γ(M, U)` as a `k`-module, the
  `k`-structure being restriction of scalars along the structure ring map
  `k → Γ(C, U)` (`toModuleKSheaf.kToSection`, the same scalar path as the
  sheaf-of-`k`-modules dialect `toModuleKSheaf`, so the two dialects agree on
  the nose for the structure sheaf).  The module-instance path is pinned
  ONCE, on this type synonym: `Module.compHom` along `kToSection C (op U)`.
* `AffineCoverMVSquare.sectionDiffₗ` — the difference-of-restrictions map as
  a `k`-linear map (same underlying function as `moduleSectionDiff`);
* `AffineCoverMVSquare.H0ₗ` (kernel submodule), `AffineCoverMVSquare.H1Cokₗ`
  (cokernel `k`-module, same underlying group as `moduleH1Cok`);
* `AffineCoverMVSquare.h0`, `.h1` (`Module.finrank`s), `.chi := h0 - h1`.

**Cover discipline (the P2 plan).**  All invariants are pinned **on a chosen
cover `S`**.  Cover-independence is deliberately OUT of scope of this wave:
it will be discharged Čech-to-Čech (comparing two 2-affine covers through
their common refinement, exactly as `hModuleOneEquivH1Cok_curve` compares
Čech to derived `H¹` through the Mayer–Vietoris `(0,1)`-slice) — **never**
through the `HasCechToHModuleIso` comparison gate, which remains
instance-free.  For `H⁰` cover-independence is already trivial and proved
here (`globalSectionsEquivH0ₗ`: the kernel is the global sections, by the
sheaf condition); for `H¹` of the structure sheaf it is inherited from the
gate-free derived comparison (`hModuleOneEquivH1Cokₗ_unit` below, both sides
being `H¹(C, 𝒪_C)`).

## The `𝒪_C` base case (the P3 χ-ledger seed)

For `M = 𝒪_C` (the rank-one free module `SheafOfModules.unit`) over a field:

* `unitH1CokₗEquiv` / `hModuleOneEquivH1Cokₗ_unit` — the `X.Modules`-dialect
  Čech `Ȟ¹(S, 𝒪)` agrees with the sheaf-of-`k`-modules dialect and hence,
  gate-free, with the genus carrier `H¹(C, 𝒪_C) = HModule k (toModuleKSheaf C) 1`
  (`hModuleOneEquivH1Cok_curve`, `RiemannRoch/Adelic/GenusUnconditional.lean`)
  — for EVERY field `k` (imperfect included) and every cover `S`;
* `h1_unit_eq_genus` — `h¹(𝒪_C) = genus C` on every cover;
* `h0_unit_eq_one` — `h⁰(𝒪_C) = 1` (sheaf gluing + the unconditional
  field-of-constants theorem `Γ(C, 𝒪_C) ≃ₐ[k] k`,
  `Picard/SectionRingUniversal.lean`);
* `chi_unit_eq_one_sub_genus` — **`χ(𝒪_C) = 1 - g`**, the first honest entry
  of the P3 `χ`-ledger.

## Base-change finiteness transport for `𝒪` (Λ-stability consumers)

The wave-3 substrate (`RiemannRoch/CurveBaseChange.lean`) makes
`C_κ := Scheme.baseChangeField C κ` an AJC curve over any field extension
`κ/k` by *named instances*, so the general-field statements above apply to
`C_κ` verbatim at base field `κ`.  The named transports are
`module_finite_H0ₗ_unit_baseChangeField`,
`module_finite_H1Cokₗ_unit_baseChangeField`, `h0_unit_baseChangeField_eq_one`
and `h1_unit_baseChangeField_eq_genus`.

Statement discipline: every statement quantifies over ALL base fields
(no perfectness, no algebraic closedness); everything is cover-parameterized;
no `Prop`-class gate is consumed or instantiated.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. Sections of a sheaf of modules as modules over the base ring

The base-ring structure on `Γ(M, U)` comes from the structure morphism
`C.hom : C.left ⟶ Spec k` through the per-open structure ring map
`toModuleKSheaf.kToSection C (op U) : k →+* Γ(C, U)`
(`Cohomology/StructureSheafModuleK/Presheaf.lean`) — the SAME scalar path as
the sheaf-of-`k`-modules dialect `toModuleKSheaf`, which is what makes the
`𝒪_C` comparison below definitional.  The instance path is pinned once, on
the type synonym `BaseSections`. -/

section BaseSections

variable {k : Type u} [CommRing k]

/-- The sections `Γ(M, U)` of a sheaf of modules `M` on a `k`-scheme `C`,
as a module over the base ring `k` (type synonym; the `k`-module instance
below is restriction of scalars along the structure ring map
`k → Γ(C, U)`).  The scheme is carried as an object `C : Over (Spec k)` so
that the structure morphism — hence the `k`-action — is part of the data. -/
@[nolint unusedArguments]
def BaseSections (C : Over (Spec (CommRingCat.of k))) (M : C.left.Modules)
    (U : C.left.Opens) : Type u :=
  Γ(M, U)

noncomputable instance (C : Over (Spec (CommRingCat.of k))) (M : C.left.Modules)
    (U : C.left.Opens) : AddCommGroup (BaseSections C M U) :=
  inferInstanceAs (AddCommGroup Γ(M, U))

/-- The per-open structure ring map `k →+* Γ(C, U)` of a `k`-scheme `C`,
respelled on the scheme-sections notation `Γ(C.left, U)` (so that the
tautological module instance `Module Γ(C.left, U) Γ(M, U)` is keyed
correctly).  Definitional: it IS `toModuleKSheaf.kToSection C (op U)`
(`baseRingMap_eq_kToSection`), the scalar path of the sheaf-of-`k`-modules
dialect. -/
noncomputable def baseRingMap (C : Over (Spec (CommRingCat.of k))) (U : C.left.Opens) :
    k →+* Γ(C.left, U) :=
  (toModuleKSheaf.kToSection C (Opposite.op U)).hom

/-- `baseRingMap` is the structure ring map of the `toModuleKSheaf` dialect. -/
lemma baseRingMap_eq_kToSection (C : Over (Spec (CommRingCat.of k))) (U : C.left.Opens) :
    baseRingMap C U = (toModuleKSheaf.kToSection C (Opposite.op U)).hom :=
  rfl

/-- `baseRingMap` commutes with restriction: restriction of the constant `c`
from `U` to `V ≤ U` is the constant `c` (`toModuleKSheaf.algebraMap_naturality`). -/
lemma baseRingMap_naturality (C : Over (Spec (CommRingCat.of k))) {U V : C.left.Opens}
    (h : V ≤ U) (c : k) :
    (C.left.presheaf.map (homOfLE h).op).hom (baseRingMap C U c) = baseRingMap C V c :=
  toModuleKSheaf.algebraMap_naturality (C := C) ((homOfLE h).op) c

/-- The pinned `k`-module instance path on sections: restriction of scalars
along the structure ring map `baseRingMap C U : k →+* Γ(C, U)`, acting
through the tautological `Γ(C, U)`-module structure on `Γ(M, U)`. -/
noncomputable instance (C : Over (Spec (CommRingCat.of k))) (M : C.left.Modules)
    (U : C.left.Opens) : Module k (BaseSections C M U) :=
  Module.compHom Γ(M, U) (baseRingMap C U)

/-- Reinterpret an element of `BaseSections C M U` as a raw section of the
abelian presheaf of `M` (the identity function; the definitional bridge
between the `k`-module synonym and the `Γ(C, U)`-module of sections). -/
def BaseSections.val {C : Over (Spec (CommRingCat.of k))} {M : C.left.Modules}
    {U : C.left.Opens} (m : BaseSections C M U) : Γ(M, U) := m

/-- The definitional spelling of the `k`-action on `BaseSections`: scalars act
through the structure ring map.  (`rfl`; stated so consumers never unfold the
`Module.compHom` instance by hand.) -/
lemma BaseSections.smul_def (C : Over (Spec (CommRingCat.of k))) (M : C.left.Modules)
    (U : C.left.Opens) (c : k) (m : BaseSections C M U) :
    (c • m).val = baseRingMap C U c • m.val :=
  rfl

/-- The restriction map `Γ(M, U) → Γ(M, V)` (`V ≤ U`) of a sheaf of modules is
`k`-linear for the base-ring structure of `BaseSections`: restriction is
semilinear over the structure-sheaf restriction, and the structure ring maps
are compatible with restriction (`toModuleKSheaf.algebraMap_naturality`). -/
noncomputable def BaseSections.restrictₗ (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) {U V : C.left.Opens} (h : V ≤ U) :
    BaseSections C M U →ₗ[k] BaseSections C M V where
  toFun := (M.presheaf.map (homOfLE h).op).hom
  map_add' := map_add _
  map_smul' c x := by
    change (M.presheaf.map (homOfLE h).op).hom (baseRingMap C U c • BaseSections.val x) =
      baseRingMap C V c • (M.presheaf.map (homOfLE h).op).hom (BaseSections.val x)
    rw [← baseRingMap_naturality C h c]
    exact Modules.map_smul M (homOfLE h) (baseRingMap C U c) (BaseSections.val x)

@[simp] lemma BaseSections.restrictₗ_apply (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) {U V : C.left.Opens} (h : V ≤ U) (x : BaseSections C M U) :
    BaseSections.restrictₗ C M h x = (M.presheaf.map (homOfLE h).op).hom x :=
  rfl

end BaseSections

/-! ## §2. The `k`-linear Čech kit on a 2-affine cover: `H⁰ₗ`, `Ȟ¹ₗ`, `h⁰`, `h¹`, `χ` -/

section CechKit

variable {k : Type u} [CommRing k]
variable (C : Over (Spec (CommRingCat.of k)))

/-- **The difference-of-restrictions map, `k`-linear form**: the base-ring
linear upgrade of `AffineCoverMVSquare.moduleSectionDiff`
(`Picard/RigidPushforward.lean`) for a sheaf of modules `M` on a `k`-scheme
`C`:
`Γ(U₁, M) × Γ(U₂, M) →ₗ[k] Γ(U₁ ⊓ U₂, M)`, `(a, b) ↦ a|₁₂ − b|₁₂`.
Same underlying function as `moduleSectionDiff`
(`sectionDiffₗ_coe_moduleSectionDiff`). -/
noncomputable def AffineCoverMVSquare.sectionDiffₗ (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) :
    BaseSections C M S.U₁ × BaseSections C M S.U₂ →ₗ[k]
      BaseSections C M (S.U₁ ⊓ S.U₂) :=
  (BaseSections.restrictₗ C M inf_le_left).comp (LinearMap.fst k _ _) -
    (BaseSections.restrictₗ C M inf_le_right).comp (LinearMap.snd k _ _)

/-- The value of the `k`-linear difference map. -/
lemma AffineCoverMVSquare.sectionDiffₗ_apply (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) (p : BaseSections C M S.U₁ × BaseSections C M S.U₂) :
    S.sectionDiffₗ C M p =
      (M.presheaf.map (homOfLE (inf_le_left : S.U₁ ⊓ S.U₂ ≤ S.U₁)).op).hom p.1 -
        (M.presheaf.map (homOfLE (inf_le_right : S.U₁ ⊓ S.U₂ ≤ S.U₂)).op).hom p.2 :=
  rfl

/-- The `k`-linear difference map has the same underlying function as the
`AddMonoidHom`-level `moduleSectionDiff`; this is what transports every
statement about the additive kit to the `k`-linear kit and back. -/
lemma AffineCoverMVSquare.sectionDiffₗ_coe_moduleSectionDiff
    (S : C.left.AffineCoverMVSquare) (M : C.left.Modules) :
    ⇑(S.sectionDiffₗ C M) = ⇑(S.moduleSectionDiff M) :=
  rfl

/-- **`H⁰` on the cover, as a submodule**: the kernel of the `k`-linear
difference map — pairs of sections agreeing on the overlap.  By the sheaf
condition this is the global sections (`globalSectionsEquivH0ₗ`), which is
why `h0` is honestly cover-independent already at this wave. -/
noncomputable def AffineCoverMVSquare.H0ₗ (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) :
    Submodule k (BaseSections C M S.U₁ × BaseSections C M S.U₂) :=
  LinearMap.ker (S.sectionDiffₗ C M)

/-- **The concrete Čech `Ȟ¹` of the cover, as a `k`-module**: the cokernel
`Γ(U₁ ⊓ U₂, M) ⧸ im(sectionDiffₗ)`.  Same underlying abelian group as
`AffineCoverMVSquare.moduleH1Cok` (the ranges of `sectionDiffₗ` and
`moduleSectionDiff` coincide, `sectionDiffₗ_coe_moduleSectionDiff`). -/
noncomputable def AffineCoverMVSquare.H1Cokₗ (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) : Type u :=
  BaseSections C M (S.U₁ ⊓ S.U₂) ⧸ LinearMap.range (S.sectionDiffₗ C M)

noncomputable instance (S : C.left.AffineCoverMVSquare) (M : C.left.Modules) :
    AddCommGroup (S.H1Cokₗ C M) :=
  inferInstanceAs (AddCommGroup (_ ⧸ LinearMap.range (S.sectionDiffₗ C M)))

noncomputable instance (S : C.left.AffineCoverMVSquare) (M : C.left.Modules) :
    Module k (S.H1Cokₗ C M) :=
  inferInstanceAs (Module k (_ ⧸ LinearMap.range (S.sectionDiffₗ C M)))

/-- **`h⁰(M)` on the cover `S`**: the `k`-dimension of the kernel of the
difference map (junk value `0` when infinite-dimensional; finiteness for
general coherent `M` is a later P2 wave). -/
noncomputable def AffineCoverMVSquare.h0 (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) : ℕ :=
  Module.finrank k (S.H0ₗ C M)

/-- **`h¹(M)` on the cover `S`**: the `k`-dimension of the concrete Čech
cokernel (junk value `0` when infinite-dimensional). -/
noncomputable def AffineCoverMVSquare.h1 (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) : ℕ :=
  Module.finrank k (S.H1Cokₗ C M)

/-- **The Euler characteristic `χ(M) = h⁰(M) − h¹(M)` on the cover `S`** —
the P3 `χ`-ledger anchor shape.  Honest (i.e. equal to the sheaf-theoretic
`χ`) whenever both `h⁰` and `h¹` are finite and the cover computes them,
which for the campaign's curves is every 2-affine cover. -/
noncomputable def AffineCoverMVSquare.chi (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) : ℤ :=
  (S.h0 C M : ℤ) - (S.h1 C M : ℤ)

lemma AffineCoverMVSquare.chi_def (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) :
    S.chi C M = (S.h0 C M : ℤ) - (S.h1 C M : ℤ) :=
  rfl

end CechKit

/-! ## §3. `H⁰` is the global sections (sheaf gluing on the 2-cover)

The kernel of the difference map is `Γ(C, M)`: restriction into the pair is
injective (separatedness) and hits every agreeing pair (gluing), both through
the sheaf property of `M.presheaf` on the cover `{U₁, U₂}` of `⊤`.  This is
the trivial half of cover-independence, done at this wave because the `𝒪`
base case needs it. -/

section Gluing

variable {k : Type u} [CommRing k]
variable (C : Over (Spec (CommRingCat.of k)))

/-- The pair-of-restrictions map `Γ(M, ⊤) →ₗ[k] Γ(U₁, M) × Γ(U₂, M)`, the
`k`-linear upgrade of `AffineCoverMVSquare.moduleSectionRes`. -/
noncomputable def AffineCoverMVSquare.sectionResₗ (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) :
    BaseSections C M (⊤ : C.left.Opens) →ₗ[k]
      BaseSections C M S.U₁ × BaseSections C M S.U₂ :=
  (BaseSections.restrictₗ C M le_top).prod (BaseSections.restrictₗ C M le_top)

/-- The pair of restrictions of a global section agrees on the overlap: the
two-term complex property, `k`-linear form. -/
lemma AffineCoverMVSquare.sectionDiffₗ_sectionResₗ (S : C.left.AffineCoverMVSquare)
    (M : C.left.Modules) (s : BaseSections C M (⊤ : C.left.Opens)) :
    S.sectionDiffₗ C M (S.sectionResₗ C M s) = 0 := by
  have h := congrArg (fun f => f s) (S.moduleSectionDiff_comp_moduleSectionRes M)
  exact h

/-- The two-element indexed family `{U₁, U₂}` of a 2-affine cover square, used
to feed the Mathlib sheaf-condition API. -/
noncomputable def AffineCoverMVSquare.pairFamily {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) : ULift.{u} Bool → X.Opens :=
  fun i => bif i.down then S.U₁ else S.U₂

lemma AffineCoverMVSquare.le_iSup_pairFamily {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) : (⊤ : X.Opens) ≤ iSup S.pairFamily := by
  rw [← S.cover]
  exact sup_le (le_iSup S.pairFamily ⟨true⟩) (le_iSup S.pairFamily ⟨false⟩)

/-- **`H⁰ₗ` is the global sections.**  The corestriction of the
pair-of-restrictions map is a `k`-linear equivalence
`Γ(C, M) ≃ₗ[k] H⁰ₗ(S, M)`: injective by separatedness of the sheaf
`M.presheaf`, surjective onto the kernel by the gluing axiom, both on the
2-element cover `{U₁, U₂}` of `⊤`.  In particular `h0` does not depend on
the cover. -/
noncomputable def AffineCoverMVSquare.globalSectionsEquivH0ₗ
    (S : C.left.AffineCoverMVSquare) (M : C.left.Modules) :
    BaseSections C M (⊤ : C.left.Opens) ≃ₗ[k] S.H0ₗ C M :=
  LinearEquiv.ofBijective
    ((S.sectionResₗ C M).codRestrict (S.H0ₗ C M) fun s =>
      LinearMap.mem_ker.mpr (S.sectionDiffₗ_sectionResₗ C M s))
    (by
      constructor
      · intro s t hst
        have h := Subtype.ext_iff.mp hst
        have h1 : (M.presheaf.map (homOfLE (le_top : S.U₁ ≤ ⊤)).op).hom s =
            (M.presheaf.map (homOfLE (le_top : S.U₁ ≤ ⊤)).op).hom t :=
          congrArg Prod.fst h
        have h2 : (M.presheaf.map (homOfLE (le_top : S.U₂ ≤ ⊤)).op).hom s =
            (M.presheaf.map (homOfLE (le_top : S.U₂ ≤ ⊤)).op).hom t :=
          congrArg Prod.snd h
        refine TopCat.Sheaf.eq_of_locally_eq'
          (⟨M.presheaf, M.isSheaf⟩ : TopCat.Sheaf Ab C.left)
          S.pairFamily ⊤ (fun i => homOfLE le_top) S.le_iSup_pairFamily s t ?_
        rintro ⟨(_ | _)⟩
        · exact h2
        · exact h1
      · rintro ⟨⟨a, b⟩, hab⟩
        have hab' : (M.presheaf.map
              (homOfLE (inf_le_left : S.U₁ ⊓ S.U₂ ≤ S.U₁)).op).hom a =
            (M.presheaf.map
              (homOfLE (inf_le_right : S.U₁ ⊓ S.U₂ ≤ S.U₂)).op).hom b := by
          have := LinearMap.mem_ker.mp hab
          rw [S.sectionDiffₗ_apply C M] at this
          exact sub_eq_zero.mp this
        -- the compatible family indexed by `{U₁, U₂}`
        set sf : ∀ i : ULift.{u} Bool, Γ(M, S.pairFamily i) :=
          fun i => match i with
            | ⟨true⟩ => a
            | ⟨false⟩ => b with hsf
        have hcompat : TopCat.Presheaf.IsCompatible M.presheaf S.pairFamily sf := by
          intro i j
          have key : ∀ {U V W : C.left.Opens} (hUV : W ≤ U ⊓ V)
              (x : Γ(M, U)) (y : Γ(M, V)),
              (M.presheaf.map (homOfLE (inf_le_left : U ⊓ V ≤ U)).op).hom x =
                (M.presheaf.map (homOfLE (inf_le_right : U ⊓ V ≤ V)).op).hom y →
              (M.presheaf.map (homOfLE (hUV.trans inf_le_left)).op).hom x =
                (M.presheaf.map (homOfLE (hUV.trans inf_le_right)).op).hom y := by
            intro U V W hUV x y hxy
            have hx : (M.presheaf.map (homOfLE (hUV.trans inf_le_left)).op).hom x =
                (M.presheaf.map (homOfLE hUV).op).hom
                  ((M.presheaf.map (homOfLE (inf_le_left : U ⊓ V ≤ U)).op).hom x) := by
              have := M.presheaf.map_comp
                (homOfLE (inf_le_left : U ⊓ V ≤ U)).op (homOfLE hUV).op
              exact (congrArg (fun f => (ConcreteCategory.hom f) x) this).trans rfl
            have hy : (M.presheaf.map (homOfLE (hUV.trans inf_le_right)).op).hom y =
                (M.presheaf.map (homOfLE hUV).op).hom
                  ((M.presheaf.map (homOfLE (inf_le_right : U ⊓ V ≤ V)).op).hom y) := by
              have := M.presheaf.map_comp
                (homOfLE (inf_le_right : U ⊓ V ≤ V)).op (homOfLE hUV).op
              exact (congrArg (fun f => (ConcreteCategory.hom f) y) this).trans rfl
            rw [hx, hy, hxy]
          obtain ⟨bi⟩ := i
          obtain ⟨bj⟩ := j
          cases bi <;> cases bj
          · -- (U₂, U₂): both maps agree by proof irrelevance of `≤`
            exact congrArg
              (fun g => (ConcreteCategory.hom (M.presheaf.map (Quiver.Hom.op g))) b)
              (Subsingleton.elim _ _)
          · -- (U₂, U₁): restrict the overlap agreement along `U₂ ⊓ U₁ ≤ U₁ ⊓ U₂`
            exact (key (le_inf inf_le_right inf_le_left) a b hab').symm
          · -- (U₁, U₂): the overlap agreement itself
            exact key le_rfl a b hab'
          · -- (U₁, U₁): both maps agree by proof irrelevance of `≤`
            exact congrArg
              (fun g => (ConcreteCategory.hom (M.presheaf.map (Quiver.Hom.op g))) a)
              (Subsingleton.elim _ _)
        obtain ⟨s, hs, -⟩ := TopCat.Sheaf.existsUnique_gluing'
          (⟨M.presheaf, M.isSheaf⟩ : TopCat.Sheaf Ab C.left)
          S.pairFamily ⊤ (fun _ => homOfLE le_top) S.le_iSup_pairFamily sf hcompat
        refine ⟨s, ?_⟩
        apply Subtype.ext
        exact Prod.ext (hs ⟨true⟩) (hs ⟨false⟩))
