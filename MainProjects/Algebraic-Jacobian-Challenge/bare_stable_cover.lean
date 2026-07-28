import AlgebraicJacobian.Picard.StableAffineCover
open AlgebraicGeometry CategoryTheory AlgebraicJacobian.GaloisDescent
universe u
set_option autoImplicit false

namespace BareTest
variable {G : Type u} [Group G] [Fintype G] {X : Scheme.{u}} (act : G →* Aut X)

def OrbitsInAff : Prop := ∀ x : X, ∃ U : X.affineOpens, ∀ g : G, (act g).hom.base x ∈ U.1
def IsStableOpen (U : X.Opens) : Prop := ∀ g : G, (act g).hom ⁻¹ᵁ U = U

lemma act_one_hom' : (act 1).hom = 𝟙 X := by rw [map_one]; rfl
lemma act_mul_hom' (g t : G) : (act (g * t)).hom = (act t).hom ≫ (act g).hom := by
  rw [map_mul]; rfl

theorem exists_stable_affineOpen_bare (h : OrbitsInAff act) (x : X) :
    ∃ U : X.Opens, IsAffineOpen U ∧ x ∈ U ∧ IsStableOpen act U := by
  classical
  obtain ⟨U, hxU⟩ := h x
  have horb : ∀ t g : G, (act g).hom.base ((act t).hom.base x) ∈ U.1 := by
    intro t g
    have hh : (act g).hom.base ((act t).hom.base x) = (act (g * t)).hom.base x := by
      rw [act_mul_hom' act g t]; rfl
    rw [hh]; exact hxU (g * t)
  obtain ⟨s, hs_mem, hs_le⟩ := exists_basicOpen_le_of_finite U.2
    (fun g : G => (act g).hom.base x) hxU
    (V := Finset.univ.inf fun g : G => (act g).hom ⁻¹ᵁ U.1)
    (fun t => mem_finset_inf.mpr fun g _ => horb t g)
  have hWle : ∀ g : G,
      (Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) ≤ (act g).hom ⁻¹ᵁ U.1 :=
    fun g => Finset.inf_le (Finset.mem_univ g)
  set t : G → Γ(X, Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) :=
    fun g => X.presheaf.map (homOfLE (hWle g)).op ((act g).hom.app U.1 s) with ht
  set N : Γ(X, Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) := ∏ g : G, t g with hN
  have hbo_t : ∀ g : G, X.basicOpen (t g) =
      (Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) ⊓ (act g).hom ⁻¹ᵁ X.basicOpen s := by
    intro g
    rw [ht, Scheme.basicOpen_res, ← Scheme.preimage_basicOpen]
  have hP1 : (act (1 : G)).hom ⁻¹ᵁ X.basicOpen s = X.basicOpen s := by
    rw [act_one_hom' act]; rfl
  have hbo_N : X.basicOpen N = Finset.univ.inf fun g : G => (act g).hom ⁻¹ᵁ X.basicOpen s := by
    rw [hN, basicOpen_finset_prod ⟨1, Finset.mem_univ 1⟩,
      Finset.inf_congr rfl fun g _ => hbo_t g]
    refine le_antisymm
      (Finset.le_inf fun g _ => (Finset.inf_le (Finset.mem_univ g)).trans inf_le_right)
      (Finset.le_inf fun g _ => le_inf (le_trans ?_ hs_le)
        (Finset.inf_le (Finset.mem_univ g)))
    exact le_of_le_of_eq (Finset.inf_le (Finset.mem_univ 1)) hP1
  have hNs : X.basicOpen N ≤ X.basicOpen s := by
    rw [hbo_N]
    exact le_of_le_of_eq (Finset.inf_le (Finset.mem_univ 1)) hP1
  refine ⟨X.basicOpen N, ?_, ?_, ?_⟩
  · have heq : X.basicOpen (X.presheaf.map (homOfLE hs_le).op N) = X.basicOpen N := by
      rw [Scheme.basicOpen_res]
      exact inf_eq_right.mpr hNs
    rw [← heq]
    exact (U.2.basicOpen s).basicOpen _
  · rw [hbo_N, mem_finset_inf]
    intro g _
    change (act g).hom.base x ∈ X.basicOpen s
    exact hs_mem g
  · intro tau
    rw [hbo_N, preimage_finset_inf]
    have hPt : ∀ g : G, (act tau).hom ⁻¹ᵁ ((act g).hom ⁻¹ᵁ X.basicOpen s)
        = (act (g * tau)).hom ⁻¹ᵁ X.basicOpen s := by
      intro g
      rw [act_mul_hom' act]; rfl
    rw [Finset.inf_congr rfl fun g _ => hPt g]
    refine le_antisymm (Finset.le_inf fun d _ => ?_) (Finset.le_inf fun d _ => ?_)
    · have hh := Finset.inf_le (s := Finset.univ)
        (f := fun g : G => (act (g * tau)).hom ⁻¹ᵁ X.basicOpen s)
        (Finset.mem_univ (d * tau⁻¹))
      rwa [inv_mul_cancel_right] at hh
    · exact Finset.inf_le (Finset.mem_univ (d * tau))

end BareTest
