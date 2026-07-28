import AlgebraicJacobian.Albanese.AlbaneseFromData

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

universe v u
variable {K : Type u} [Category.{v} K] [CartesianMonoidalCategory K]
  [HasFiniteProducts K] [BraidedCategory K]

/-- FINDING: at the ONLY exhibited inhabitant (n = 1), `symAVMap φ = φ`
(the carrier is C itself, so `Sym^1 φ` is φ on the nose). -/
theorem symAVMapOne (C A : K) [MonObj A] [IsCommMonObj A] (φ : C ⟶ A) :
    (symPowDataOne C).symAVMap φ = φ := by
  refine ((symPowDataOne C).symAVMap_unique φ φ ?_).symm
  show Pi.π (fun _ : Fin 1 => C) 0 ≫ φ = powSum 1 φ
  rw [powSum, Finset.prod_eq_single (0 : Fin 1)]
  · intro b _ hb; exact absurd (Subsingleton.elim b 0) hb
  · intro h; exact absurd (Finset.mem_univ (0 : Fin 1)) h

/-- Hence at n = 1 `hdesc` is the conclusion with `f` in place of `aj`:
the theorem's whole content collapses to `f = aj`. -/
theorem hdesc_is_conclusion_at_one (C : K) [MonObj C] [IsCommMonObj C]
    (A : K) [MonObj A] [IsCommMonObj A]
    (f : C ⟶ A) (φ : C ⟶ A) :
    (∃! ψ : A ⟶ A, (symPowDataOne C).symAVMap φ = f ≫ ψ)
      ↔ (∃! ψ : A ⟶ A, φ = f ≫ ψ) := by
  rw [symAVMapOne]
