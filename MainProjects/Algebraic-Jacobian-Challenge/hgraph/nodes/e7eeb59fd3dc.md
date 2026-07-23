---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.tautologicalRankQuotient
docstring: '**The tautological point of the Grassmannian**: the rank-`d` locally free
  quotient

  `u : O^r ↠ U` on `Gr(d,r)` itself, packaged as a `RankQuotient`. Pulling it back
  along

  `ψ : T ⟶ Gr(d,r)` realizes the forward direction of the universal property.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.tautologicalRankQuotient
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def tautologicalRankQuotient (d r : ℕ) : RankQuotient r d (scheme d r) where
  F := universalQuotient d r
  q := tautologicalQuotient d r
  epi := tautologicalQuotient_epi d r
  locFree := universalQuotient_isLocallyFreeOfRank d r

/-! ### The Nitsure §1 inverse construction: chart loci, chart matrices, chart morphisms

For a rank-`d` quotient `x = ⟨F, q⟩` on `T` and a size-`d` subset `I ⊆ Fin r`, the
*chart composite* is `s_I ≫ q : O_T^d ⟶ F` (the `I`-indexed coordinate inclusion
followed by the quotient map) and the *chart locus* `T_I ⊆ T` is the largest open on
which it restricts to an isomorphism. The loci are open by construction (a supremum of
opens), cover `T` (Nakayama at each point), and over `T_I` the quotient is presented by
a `d × r` matrix of sections whose `I`-minor is the identity — its complementary
entries determine a ring map `R^I ⟶ Γ(T_I, O)` and hence a morphism `T_I ⟶ U^I` by the
Γ–Spec adjunction. These glue to the inverse `grPointOfRankQuotient` of the universal
property. -/