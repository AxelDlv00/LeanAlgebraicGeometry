# Strategy-critic directive — sc264

Fresh-context audit of the project strategy. You have NO iter history; judge the strategy as a
mathematician seeing it cold. STRATEGY.md changed since the last audit: the A.2.c-engine row and the
engine open-question were updated to reflect a NEW finding — the `Rⁱf_*` Čech push-pull functor laws
are DE-COUPLED from the Picard substrate Sq1 (provable from Mathlib's pseudofunctor coherences alone),
refuting a prior "engine coupled to D3′" belief. Please re-verify the still-live questions below.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine protected
declarations headed by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — an
Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C/k` (`[Field k]` only; no `C(k)≠∅`, no `CharZero`). `J := Pic⁰_{C/k}` is built
unconditionally; only `isAlbaneseFor` is quantified over the pointing. End-state: zero inline `sorry`
in the dependency cone of each protected decl, 0 project axioms, kernel-only axioms.

## STRATEGY.md (verbatim)
See `.archon/logs/iter-264/_strategy_snapshot.md` (full current file, 150 lines).

## Reference index
See `references/summary.md` (the table of available sources: challenge.lean.ref [authoritative
signatures], Kleiman "Picard scheme" FGA, Nitsure Quot/Hilbert FGA, Milne "Abelian Varieties", Mumford
"Abelian Varieties", Stacks chapters varieties/fields/algebra/coherent/constructions).

## Blueprint chapter topics (one line each, active + adjacent)
- Picard_TensorObjSubstrate — relative Picard sheaf `Scheme.Modules.tensorObj`; the A.1.c.sub comparison
  iso + DUAL inverse (route-2).
- Picard_LineBundleCoherence — coherence of loc-triv line bundles (engine on-path entry; DONE).
- Cohomology_CechHigherDirectImage — relative Čech complex / `Rⁱf_*` (engine dominant pole).
- Cohomology_{FlatBaseChange, HigherDirectImage} — `Rⁱf_*` foundations (held).
- Picard_{RelPicFunctor, FGAPicRepresentability, QuotScheme, FlatteningStratification, IdentityComponent,
  Pic0AbelianVariety, RelativeSpec, LineBundlePullback, SheafOverEquivalence} — A.1.c.fun / A.2.c
  representability scaffold.
- Albanese_{AlbaneseUP, CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum} — A.4 Albanese UP.
- AbelianVarietyRigidity, RigidityKbar, Rigidity — Milne rigidity (A.4).
- RiemannRoch_* — Route C (PAUSED by user).
- Genus0BaseObjects_*, Jacobian, AbelJacobi, Differentials, Genus — downstream / base objects.

## Still-live questions to re-verify
1. The engine de-coupling: is it strategically sound to run the `Rⁱf_*` Čech lane fully concurrently
   with the Picard substrate now (no Sq1 gate)? Any hidden re-coupling I am missing?
2. Is route-2 (`sliceDualTransport` by-hand `≃ₗ`) still the cheapest path to the RPF group inverse, or
   is there a cheaper architecture I am over-investing past? (It has run many iters as a monolithic
   decl; the sub-holes are closing one per iter.)
3. The RR-free critical path A.1.c.sub → A.1.c.fun → A.2.c with the dominant `Rⁱf_*` engine pole — is
   the phase ordering and the bottom-up posture (no A.3+ before A.2.c, per USER directive) still the
   right global arc, or should the engine pole be front-loaded harder given it is now decoupled?

Return SOUND / CHALLENGE / REJECT per question with concrete reasoning grounded in the references.
