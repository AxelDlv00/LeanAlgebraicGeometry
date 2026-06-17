# strategy-critic sc263 — fresh-view audit of STRATEGY.md

You see only: the current STRATEGY.md (verbatim below), the references index, a blueprint chapter
map, and the project goal. No iter history, no prover narrative. Challenge the strategy as a fresh
mathematician would — sunk cost is exactly what you should question.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only; no `C(k)≠∅`, no `CharZero`). `J := Pic⁰_{C/k}` is built unconditionally; only
`isAlbaneseFor` is quantified over the pointing. End-state: zero inline `sorry` in the dependency
cone of each protected decl, 0 project axioms, kernel-only axioms.

## Specific question for this audit
STRATEGY was just refined with one finding: the A.2.c-engine `Rⁱf_*` Čech lane — opened last iter as a
"group-law-independent PARALLEL pole" — turns out to have its lone hard step (the push-pull functor
`CechNerve.G`'s functor laws) COUPLED to the A.1.c.sub D3′ coherence machinery
(`pullbackComp`/`pushforwardComp`). The strategy now says: land the independent backbone/brick in
parallel, but sequence `G`'s coherence AFTER D3′ (consume, don't re-derive). **Is this the right
call, or does the coupling argue the engine `Rⁱf_*` lane should NOT be billed as a parallel pole at
all until D3′ lands — i.e., is parallel-opening it now genuine throughput or busywork?** Also
re-verify (fresh) that the dual route-2 (`sliceDualTransport` by-hand) is still the cheapest path to
the RPF group inverse, and that no row's Iters-left/LOC is fantasy.

## STRATEGY.md (verbatim)
Read it in full at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
(148 lines). That file plus this directive's goal/references/blueprint-map is your ENTIRE context —
do not read any iter sidecar, task_result, PROGRESS.md, or review file.

## References index (references/summary.md — abbreviated)
- challenge.lean.ref — authoritative protected signatures.
- kleiman-picard / fga-explained Ch.9 — Picard scheme (§4 existence, §5 Pic⁰).
- nitsure-hilbert-quot / fga-explained Ch.5 — Quot/Hilbert engine.
- abelian-varieties (Milne) — rigidity Thm 1.1, Thm 3.2/Prop 3.10 (Mor(ℙ¹,A) constant, no Serre
  duality), Albanese UP Prop 6.1/6.4.
- mumford-abelian-varieties — rigidity lemma, theorem of the cube.
- stacks-modules (01CR/0B8K/01CX) — invertible modules, Pic group. stacks-coherent (02KH) — flat
  base change of Rⁱf_*. stacks-schemes (01I9) — affine pullback of tilde.
- hartshorne / matsumura / atiyah-macdonald — genus-0≅ℙ¹, Auslander–Buchsbaum, codim-1.

## Blueprint chapter map (one line each, active-route chapters)
- Picard_TensorObjSubstrate — A.1.c.sub ⊗ substrate (covers TensorObjSubstrate.lean + DualInverse.lean
  + StalkTensor + Vestigial): comparison iso `f^*(M⊗N)≅f^*M⊗f^*N`, dual inverse `exists_tensorObj_inverse`.
- Picard_SheafOverEquivalence — shared slice root (closed).
- Picard_LineBundleCoherence — IsLocallyTrivial⟹IsFinitePresentation (closed).
- Picard_RelPicFunctor — relative Picard functor + ét sheafification (A.1.c.fun).
- Cohomology_CechHigherDirectImage — Čech Rⁱf_* (A.2.c-engine dominant pole).
- Cohomology_{FlatBaseChange,HigherDirectImage,MayerVietoris,SheafCompose,StructureSheaf*} — engine support.
- Picard_{FGAPicRepresentability,IdentityComponent,Pic0AbelianVariety,QuotScheme,FlatteningStratification,
  RelativeSpec,LineBundlePullback} — A.2.c representability.
- Albanese_{AlbaneseUP,CodimOneExtension,Thm32RationalMapExtension,AuslanderBuchsbaum,CoheightBridge} — A.4.
- AbelianVarietyRigidity, RigidityKbar, Rigidity, Genus*, Differentials — rigidity + genus-0 + cotangent.
- RiemannRoch_* — Route C (PAUSED, USER).
- Jacobian, AbelJacobi — top-level targets (gated).

## Output
SOUND / CHALLENGE / REJECT per the engine-coupling question + the dual-route + any fantasy estimate,
with concrete reasoning. If CHALLENGE/REJECT, name the specific row/route and the alternative.
