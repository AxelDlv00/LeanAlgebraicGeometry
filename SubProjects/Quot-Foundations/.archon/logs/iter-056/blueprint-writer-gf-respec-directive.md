Target chapter: blueprint/src/chapters/Picard_FlatteningStratification.tex

## Context
`genericFlatness` (Nitsure §4 geometric form) is reduced to ONE remaining sorry: the per-piece
flatness `Module.Flat Γ(S,U) Γ(F, D g)` for an arbitrary AFFINE open `U ≤ V = D(f)` of the base.
The construction naturally produces flatness over `Γ(S,V) = A_f`; the final step descends the base
along the open immersion `U ↪ V`. The prior handoff (`informal/gf_openImmersion_isBaseChange.md`)
declared this base change "absent from Mathlib". THAT IS WRONG — the planner located it. Re-spec the
chapter's final-step around the real Mathlib API.

## Verified Mathlib API (author a \mathlibok dependency-anchor block stating these in project notation)
- `Algebra.IsEpi R A` (`Mathlib.Algebra.Algebra.Epi`) — the ring-epimorphism typeclass.
- `TensorProduct.lid' R A M : TensorProduct R A M ≃ₗ[A] M` for `[Algebra.IsEpi R A]`, `M` an `A`-module
  with `[IsScalarTower R A M]` (`Mathlib.Algebra.Algebra.Epi`). This IS the base-change iso
  `A ⊗_R M ≅ M` for a ring epimorphism `R → A`.
- `CommRingCat.epi_iff_isEpi` (a.k.a. `epi_iff_epi`): `Epi (CommRingCat.ofHom (algebraMap R S)) ↔ Algebra.IsEpi R S` (`Mathlib.Algebra.Category.Ring.Epi`).
- `AlgebraicGeometry.IsOpenImmersion.mono`, `AlgebraicGeometry.Spec.fullyFaithful`,
  `IsAffineOpen.isoSpec`.
Mark the anchor block \mathlibok and give it `\lean{}` targets on the real Mathlib names above.

## Required new/edited blocks
1. NEW bridge lemma `lem:gf_openImmersion_isEpi`: for affine opens `U ≤ V` of a scheme `S`,
   the structure-sheaf restriction `Γ(S,V) → Γ(S,U)` is a ring epimorphism, i.e.
   `Algebra.IsEpi Γ(S,V) Γ(S,U)`. Informal proof: the inclusion `U ↪ V` of affine opens is an
   OPEN IMMERSION hence a MONOMORPHISM of schemes; both `U`,`V` are affine, so this is `Spec` of the
   ring map `Γ(S,V) → Γ(S,U)`; `Spec` is fully faithful, so a mono of affines corresponds to a ring
   EPIMORPHISM `Γ(S,V) → Γ(S,U)`; `CommRingCat.epi_iff_isEpi` repackages categorical epi as
   `Algebra.IsEpi`. (NO source citation needed — standard scheme-theory fact; this is project-bespoke.)
2. NEW descent consumer `lem:gf_flat_descend_isEpi` (replaces the IsBaseChange route): given a tower
   `Γ(S,V) → Γ(S,U) → M`, `Algebra.IsEpi Γ(S,V) Γ(S,U)`, and `Module.Flat Γ(S,V) M`, conclude
   `Module.Flat Γ(S,U) M`. Proof: `Γ(S,U) ⊗_{Γ(S,V)} M` is `Γ(S,U)`-flat (base change of a flat module
   is flat); `TensorProduct.lid'` gives `Γ(S,U) ⊗_{Γ(S,V)} M ≅ M` as `Γ(S,U)`-modules; transport
   flatness across the iso. `\uses{}` the anchor block.
3. EDIT `genericFlatness`/`thm:generic_flatness` final-step prose: the per-piece flatness now closes via
   `lem:gf_openImmersion_isEpi` + `lem:gf_flat_descend_isEpi` (no Mathlib gap remains). Update its
   `\uses{}` to cite the two new labels. Drop language calling the base change "absent from Mathlib".

## Cleanup (stale pins flagged iter-055 — fix or delete)
- `lem:gf_stalk_flat_over_base`, `lem:gf_stalk_flat_localBase`: dead STALK route (`SheafOfModules.stalk`
  absent). DELETE both blocks and any `\uses{}` referencing them.
- `lem:gf_flat_locality_assembly`: the decl was dissolved into the `genericFlatness` body and does NOT
  exist. DELETE this block; repoint dependents to `thm:generic_flatness` / the actual helper labels.
- `lem:gf_section_localization_flat_descent`: pins a non-existent decl. REPOINT its `\lean{}` to the real
  decl `AlgebraicGeometry.gf_section_span_flat_descent` (or rename the label to
  `lem:gf_section_span_flat_descent`), and fix the `\uses{}` referencing it elsewhere.
- Coverage debt: ensure `AlgebraicGeometry.gf_section_span_flat_descent` and
  `AlgebraicGeometry.gf_flat_of_isBaseChange_id` each have a blueprint block with `\lean{}` + accurate
  `\uses{}` + a one-line informal proof. (`gf_flat_of_isBaseChange_id` may be retired in favour of
  `lem:gf_flat_descend_isEpi`; if you keep it, give it an entry — do not leave it isolated.)

## Out of scope
Do NOT touch any other chapter. Do NOT add `\leanok`. Do NOT re-prove the algebraic core
(`genericFlatnessAlgebraic`) or the B1/B2 bricks — they are DONE; only the final descent step changes.
