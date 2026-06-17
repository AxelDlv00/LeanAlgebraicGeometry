# strategy-critic sc262 — directive

Fresh-eyes critique of the project strategy. You see ONLY: STRATEGY.md (verbatim
below), the reference index (`references/summary.md` — read it), and the blueprint
chapter list (`blueprint/src/chapters/*.tex` — read titles/first lines for a
one-line topic each). Do NOT read PROGRESS.md, iter sidecars, task files, or any
per-iter narrative.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`):
nine protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the
k-rational pointing of a smooth proper geometrically irreducible curve C/k
([Field k] only). `J := Pic⁰_{C/k}` built unconditionally. End state: zero inline
sorry in each protected decl's cone, kernel-only axioms.

## Specific question to weigh (in addition to your standard SOUND/CHALLENGE/REJECT)

The critical-path sub-phase A.1.c.sub has a workstream "dual inverse"
(`exists_tensorObj_inverse` → RPF group inverse) whose linchpin is
`dual_restrict_iso`, built via `sliceDualTransport`. STRATEGY commits this to
"route-2" (build `sliceDualTransport` sectionwise by hand: leg-A slice-Hom
base-change ∘ leg-B `restrictScalarsRingIsoDualEquiv`), with a stalkwise
evaluation-iso route named only as a Plan-B. This route-2 has now spent multiple
iters with no formal sorry closed (the construction is monolithic; real
structural progress — leg-A built, an instance wall resolved — is masked by the
single-decl metric). Two named tactical frictions remain on leg-B (a CommRing
instance recovery and a unit-section defeq bridge).

Is the route-2-primary / stalk-Plan-B ordering still the soundest call, or does
the evidence in the references favour pivoting? Is the dual inverse even on the
true critical path to the goal, or is there a cheaper architecture for the RPF
group inverse that STRATEGY is missing? Challenge the A.2.c-engine sizing
(~3400–5500 LOC, the dominant pole) and whether the RR-free architecture is the
right bet given the permanent USER Route-C (Riemann–Roch) pause.

## STRATEGY.md (verbatim)

<<<
(see /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md — read it verbatim; it is the current strategy)
>>>

Read STRATEGY.md directly from the path above (it is the authoritative current
copy), then `references/summary.md`, then skim the chapter list. Return your
verdict and any CHALLENGE/REJECT with the specific strategic claim you dispute and
the reference evidence.
