---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.flatteningStratification
docstring: '**Flattening stratification existence theorem** [Nitsure §4 main /

  Stacks 052H].


  For a noetherian scheme `S`, a proper morphism `π : X ⟶ S`, and a

  coherent `𝓞_X`-module `𝓕`, there exists a finite locally-closed

  stratification `{S_f}` of `S` indexed by a finite set `I` such that

  - each `ι : S_f ⟶ S` is a (locally-closed) immersion;

  - the underlying sets `|S_f|` partition `|S|` (disjoint and covering);

  - the pullback `𝓕|_{X ×_S S_f}` is flat over `S_f` for each `f`.


  The (intended) substantive refinement is that the index set `I` is in

  bijection with the set of Hilbert polynomials arising on fibres, and

  that each `S_f` is uniquely determined by its Hilbert polynomial. For

  the iter-176 file-skeleton the substantive type captures the

  stratification + flatness; the Hilbert-polynomial labeling is encoded

  in `flatLocusAssembly`''s `P : I → ℕ → ℤ` injection but elided here for

  type-clarity.


  Proof status (run 0010, T12 r2): the conclusion as typed is exactly the

  conclusion of `flatLocusReduction` (Lemma 6) up to conjunct order, so the

  theorem is proved below by that reduction; the remaining mathematical

  content of this cone therefore lives in `flatLocusReduction` (Noetherian

  induction on `genericFlatness`) and `genericFlatness` itself. The

  Hilbert-polynomial-indexed refinement (which would need relative

  projective space `ℙⁿ_S`, Castelnuovo–Mumford regularity, direct-image

  base change 02KH) is deliberately not part of this statement; see

  `flatLocusAssembly` and the blueprint chapter §`Mathlib status`.'
file: AlgebraicJacobian/Picard/GenericFlatnessGeometric.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.flatteningStratification
type: lean
updated: '2026-07-16T21:14:27'
---
theorem flatteningStratification {S X : Scheme.{u}} [IsNoetherian S]
    (π : X ⟶ S) [IsProper π] (F : X.Modules) [F.IsFinitePresentation] :
    ∃ (I : Type u) (_ : Finite I) (S_ : I → Scheme.{u}) (ι : ∀ f, S_ f ⟶ S),
      (∀ f, IsImmersion (ι f)) ∧
      (∀ s : S, ∃ f, s ∈ Set.range (ι f).base) ∧
      (∀ f g, f ≠ g → Disjoint (Set.range (ι f).base) (Set.range (ι g).base)) ∧
      (∀ f, Scheme.CoherentSheafFlat (pullback.snd π (ι f))
        ((Scheme.Modules.pullback (pullback.fst π (ι f))).obj F)) := by
  obtain ⟨I, hI, V_, ι, himm, hdisj, hcov, hflat⟩ := flatLocusReduction π F
  exact ⟨I, hI, V_, ι, himm, hcov, hdisj, hflat⟩