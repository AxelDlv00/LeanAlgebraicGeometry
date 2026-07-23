---
author: sync
content_type: theorem
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.exists_snd_mem_of_fst_eq_of_mem
docstring: "**Milne Lemma 3.3, Substep 2 topological half (`[2-topo-a]`), abstract\
  \ form.**\n\nOn the smooth self-product `X ×_{k̄} X` of a geometrically irreducible\
  \ variety,\nlet `V` be any open set meeting the fibre `pr₁⁻¹{x}` (via a point `p₀`\
  \ with\n`pr₁ p₀ = x`, `p₀ ∈ V`) and let `D` be any *dense* open of `X`. Then there\
  \ is a\npoint `p` of the fibre with `pr₁ p = x`, `p ∈ V`, and `pr₂ p ∈ D`.\n\nThis\
  \ is the point-set core of Milne's slice argument: with `V = Dom(Φ)` (met at\nthe\
  \ diagonal point `(x, x) ∈ Dom(Φ)`) and `D = Dom(f)`, it produces Milne's\n`u :=\
  \ pr₂ p ∈ Dom(f)` with `(x, u) ∈ Dom(Φ)`. The proof combines:\n* irreducibility\
  \ of the fibre `pr₁⁻¹{x}` (geometric irreducibility of `X.hom`,\n  `Scheme.Hom.isIrreducible_preimage`,\
  \ since `pr₁ = pullback.fst` is\n  geometrically irreducible and open);\n* surjectivity\
  \ of `pr₂` onto `X` *along the fibre*, via a scheme-theoretic point\n  over `(x,\
  \ u)` for any chosen `u ∈ D` (`Scheme.Pullback.exists_preimage_pullback`,\n  using\
  \ that the base `Spec k̄` is a single point)."
file: AlgebraicJacobian/Albanese/Milne33Substeps.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_snd_mem_of_fst_eq_of_mem
type: lean
updated: '2026-07-16T21:14:25'
---
theorem exists_snd_mem_of_fst_eq_of_mem
    {kbar : Type u} [Field kbar]
    (X : Over (Spec (.of kbar))) [Smooth X.hom] [GeometricallyIrreducible X.hom]
    (V : (pullback X.hom X.hom).Opens) (D : X.left.Opens)
    (hD : Dense (D : Set X.left))
    (x : X.left) (p₀ : ↥(pullback X.hom X.hom))
    (hfst : (pullback.fst X.hom X.hom).base p₀ = x) (hp₀V : p₀ ∈ V) :
    ∃ p : ↥(pullback X.hom X.hom),
      (pullback.fst X.hom X.hom).base p = x ∧ p ∈ V ∧
      (pullback.snd X.hom X.hom).base p ∈ D := by
  -- The fibre `pr₁⁻¹{x}` is irreducible.
  have hopen : IsOpenMap (pullback.fst X.hom X.hom).base := isOpenMap_pullback_fst_self X
  have hirr : IsIrreducible ((pullback.fst X.hom X.hom).base ⁻¹' {x}) :=
    (pullback.fst X.hom X.hom).isIrreducible_preimage hopen isIrreducible_singleton
  -- `V` meets the fibre (at `p₀`).
  have hAne : (((pullback.fst X.hom X.hom).base ⁻¹' {x}) ∩ (V : Set _)).Nonempty :=
    ⟨p₀, hfst, hp₀V⟩
  -- `pr₂⁻¹(D)` meets the fibre: pick `u ∈ D` and a point over `(x, u)`.
  haveI : Nonempty X.left := ⟨x⟩
  obtain ⟨u, huD⟩ := hD.nonempty
  obtain ⟨q, hq1, hq2⟩ :=
    Scheme.Pullback.exists_preimage_pullback (f := X.hom) (g := X.hom) x u
      (Subsingleton.elim _ _)
  have hBne :
      (((pullback.fst X.hom X.hom).base ⁻¹' {x}) ∩
        ((pullback.snd X.hom X.hom).base ⁻¹' (D : Set _))).Nonempty :=
    ⟨q, hq1, by rw [Set.mem_preimage, hq2]; exact huD⟩
  -- Preirreducibility: the two opens meet the fibre simultaneously.
  obtain ⟨p, hpfib, hpV, hpD⟩ :=
    hirr.2 (V : Set _) ((pullback.snd X.hom X.hom).base ⁻¹' (D : Set _))
      V.isOpen (D.isOpen.preimage (pullback.snd X.hom X.hom).continuous) hAne hBne
  exact ⟨p, hpfib, hpV, hpD⟩