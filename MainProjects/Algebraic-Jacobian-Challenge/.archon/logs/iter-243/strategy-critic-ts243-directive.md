# strategy-critic directive — iter-243

Read `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim) and
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`. For a blueprint
summary, you may read the one-line `\chapter`/section titles under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/` if useful, but do
NOT read iter sidecars, task files, or recent prover/review narrative.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform
over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`. `J := Pic⁰_{C/k}`.
End-state: zero inline `sorry` in the dependency cone of each protected decl, 0 project axioms.

## The live strategic change this iter (please verify)
STRATEGY.md was edited this iter to **pivot the A.1.c substrate route** for `IsInvertible.pullback`
(pullback preserves tensor-invertibility). The prior route (iter-242) was the "concrete strong-monoidal
pullback `P` / Mathlib PR #36599 mirror" to build the GENERAL `pullbackTensorIso` (`f^*(M⊗N)≅f^*M⊗f^*N`
for arbitrary `M,N`). A prover attempt empirically confirmed that route is **Mathlib-scale**: it needs
`PresheafOfModules.extendScalars` and a topological inverse-image (left Kan extension), both absent at the
pinned commit. The new route (see the A.1.c paragraph + the "RPF consumer re-base" open question):

1. Transport the now-landed presheaf comparison map `δ` to a sheaf-level MAP `δ_sheaf : f^*(M⊗N) ⟶ f^*M ⊗ f^*N`.
2. Build the forward bridge `IsInvertible M ⟹ IsLocallyTrivial M` (invertible ⟹ locally free of rank 1).
3. For the INVERTIBLE pair only, show `δ_sheaf` is iso on a trivialising cover (everything `≅𝒪`) → globalise
   by `isIso_of_isIso_restrict`.
4. `IsInvertible.pullback` = witness `f^*N` with iso `δ_sheaf⁻¹ ≫ f^*e ≫ pullbackUnitIso`.

The general `pullbackTensorIso` is DESCOPED (only the invertible case is ever needed downstream; the A.2.c
path pulls back only invertible modules).

## Questions
1. Is descoping the general `pullbackTensorIso` to the invertible-only case SOUND — i.e. does anything on the
   critical path (A.1.c → A.2.c → A.3 → A.4) ever need `f^*` to commute with `⊗` for NON-invertible modules?
   (Check against the references: Kleiman, Nitsure, Milne.)
2. Is the local-trivialization route's dependency on the forward bridge `IsInvertible⇒IsLocallyTrivial`
   (invertible ⟹ locally-free-rank-1, Stacks 01CV/0B8M) a genuine reduction in difficulty vs. the abandoned
   concrete-`P` build, or does it merely relocate the same Mathlib-scale obstacle? Note: `IsLocallyTrivial.pullback`
   and `tensorObj_isLocallyTrivial` are already proven in-tree.
3. The forward bridge `IsInvertible⇒IsLocallyTrivial` is ALSO listed as the scheduled A.2.c Quot-embedding
   prerequisite (`IsInvertible ⟹ locally-free-rank-1`). Pulling it forward to A.1.c now — does that create any
   ordering problem, or is it a free double-serve?
4. Any other CHALLENGE or REJECT on the current strategy spine (carrier pivot, Route Y, RR-free engine,
   the Albanese two-route fork)?

Be a fresh skeptic. Sunk cost on the concrete-`P` route is exactly what you should challenge if the pivot is
itself unsound.
