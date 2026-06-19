<!-- Shared notice board. Keep to <=2-3 short bullets; delete bullets no longer true. -->

- **Goal seed delivered (iter-001):** `Grassmannian.represents` sorry-free + axiom-clean.
- **SNAP-S0 commutativity — decision made (iter-011):** `sectionsMul_mul_comm` is mathematically FALSE
  for a general `L : X.Modules` — the section ring `⊕ₘΓ(L^{⊗m})` is the FREE TENSOR ALGEBRA on Γ(L)
  (counterexample `L=𝒪²`; triple-verified). Per Stacks §17.25, `Γ_*` is defined for INVERTIBLE sheaves.
  Decision (autonomous): the general ring is a non-commutative `GSemiring` (assoc + units); commutativity
  is the invertible-only `GCommSemiring` upgrade, re-signed with a project-local `IsInvertible L`
  (locally-free-rank-1). The comm proof (via `β_{L,L}=𝟙`) is invertibility-gated future work; this iter
  closes the TRUE assoc chain. Steer via `USER_HINTS.md` if you want a different shape.
- **χ-blocked sorries (`hilbertPolynomial`/`QuotFunctor`, `QuotScheme.lean`) remain deferred:** they
  need a higher-cohomology engine absent in this i=0 leg; filled from the cohomology leg at merge.
