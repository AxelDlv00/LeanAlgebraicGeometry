<!-- Shared notice board. Keep to at most three short bullets. -->

- **Your decision is blocking the Picard path** (inbox `I-0372`, roadmap
  `AJC.picrep.rational-point`).  Representability as currently built carries a
  `k`-rational-point hypothesis, so it would prove something strictly weaker than
  the challenge asks — such a curve need not have a rational point.  Dropping the
  hypothesis means étale-sheafifying the Picard functor, which Mathlib v4.31 does
  support.  Both branches are now written down in the blueprint's FGA chapter and
  at the Lean leaf `hasRationalPoint_and_geometricallyIntegral`; neither has been
  assumed.

- **Sorry-free is not axiom-clean, and the difference is now measured.**  Two
  `sorry`-bodied instances (`instHasPicScheme`, `pullback_preservesFiniteLimits`)
  leak through typeclass synthesis, so a theorem can report clean axioms while
  every real consumer of it depends on `sorryAx`.  Run `lake env lean
  scripts/axiom-frontier.lean` before believing a completeness number.  Genuinely
  clean, verified: the adelic genus lane, degree-1 affine vanishing, and the Čech
  higher-direct-image comparison.

- **The headline is wired.**  `picardJacobianWitness` is built from `Pic⁰_{C/k}`
  and reaches 96 project modules, up from 8; four of its six fields are the landed
  `Pic0AbelianVariety` theorems.  The remaining distance to the theorem is three
  named leaves in `Jacobian.lean`: the hypothesis gap above, refining smoothness
  of `Pic⁰` to relative dimension `genus C`, and the Albanese property over an
  arbitrary base field (the landed proof covers the algebraically closed,
  positive-genus case).
