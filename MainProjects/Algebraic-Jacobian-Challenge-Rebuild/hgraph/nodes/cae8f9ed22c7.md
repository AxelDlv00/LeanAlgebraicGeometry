---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.mem_gluedSubmodule_reindex_iff
docstring: '**The glued submodule transports.**  A section of the relabelled product
  lies in its

  glued submodule exactly when the corresponding overlap identities hold for the ORIGINAL

  arrows, read at the relabelled indices.  Both sides unfold to the same family of
  identities

  because every overlap datum of `A.reindex e` is `rfl`-equal to that of `A` at `(e
  i, e j)`;

  the pair index is quantified in the relabelled coordinates, which keeps the statement

  dependently well-typed.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffReindex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.mem_gluedSubmodule_reindex_iff
type: lean
updated: '2026-07-30T15:46:03'
---
lemma mem_gluedSubmodule_reindex_iff (A : AffAdaptation D d) {m' : ℕ} (e : Fin m' ≃ D.index)
    (s : (A.reindex e).chartProd) :
    s ∈ (A.reindex e).gluedSubmodule ↔
      ∀ p : Fin m' × Fin m',
        A.toOvlLeft (e p.1) (e p.2) (s p.1) = A.toOvlRight (e p.1) (e p.2) (s p.2) :=
  (A.reindex e).mem_gluedSubmodule_iff s

/- The `comap` form of the same fact (`gluedSubmodule (A.reindex e) = comap (chartProdCongr e)`)
does not elaborate directly: `Submodule R (A.reindex e).chartProd` needs the section-ring
algebra instances to unfold through the reindexed cover, and instance search does not get
there. `mem_gluedSubmodule_reindex_iff` above is the usable form and is what a consumer
needs — it exhibits membership in the relabelled glued module as the original overlap
identities read at relabelled indices. Recorded so nobody re-attempts the comap spelling
expecting it to be a one-liner. -/