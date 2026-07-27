<!-- Shared notice board. Keep to at most three short bullets. -->

- **Your decision is blocking the Picard path** (inbox `I-0372`, roadmap
  `AJC.picrep.rational-point`).  Representability as currently built carries a
  `k`-rational-point hypothesis, so it would prove something strictly weaker than
  the challenge asks — such a curve need not have a rational point.  Dropping the
  hypothesis means étale-sheafifying the Picard functor, which Mathlib v4.31 does
  support.  Both branches are now written down in the blueprint's FGA chapter and
  at the Lean leaf `hasRationalPoint_of_curve`; neither has been assumed.  The
  decision is now *exactly* the rational point: the leaf used to bundle geometric
  integrality with it, and that half turned out to be a theorem, now proved
  (`geometricallyIntegral_of_curve`).

- **Sorry-free is not axiom-clean, and there are six separate ways to be misled.**
  Run `lake env lean scripts/axiom-frontier.lean` before believing any completeness
  number; it probes 107 declarations, 70 clean and 37 carrying `sorryAx` as last
  measured (2026-07-28, root build green at 8,744 jobs).
  (1) Two `sorry`-bodied *instances* (`instHasPicScheme`,
  `pullback_preservesFiniteLimits`) leak through synthesis, so a theorem reports
  clean axioms while every real consumer depends on `sorryAx`.  Those two are the
  *whole* synthesis-leak surface, now measured rather than assumed: of the tree's 26
  `sorry` carriers exactly two are instances, and the probe's §2 lists all 26.
  (2) An *unproved*
  named hypothesis in a statement is invisible to the check.  (3) So is a *false*
  one — which makes the theorem vacuously true and perfectly clean; this was found
  in the rigid-pushforward cone, not hypothesised.  (4) So is an *instance binder
  nothing can instantiate* for the object actually used; this cost a claimed
  discharge in the Riemann–Roch lane this week, caught and retracted.  (5) An
  unrooted module is not probed at all, because the root import never reaches it.
  (6) Two different *instances* can supply one binder without being equal, so a file
  can prove correct-looking theorems about a definition pinned to the wrong one; this
  one survives both the axiom check and an instantiability probe.
  Genuinely clean and unconditional, verified: the adelic genus lane, degree-1
  affine vanishing, the Čech higher-direct-image comparison, and — new this week —
  the **whole B3 rigid-pushforward gate**, which now carries a real instance for
  every curve satisfying the challenge hypotheses.  That last one is measured at
  the synthesis site, not merely as stated, which is the only check that
  distinguishes it from case (1) above.

- **The headline is wired, and now rests on five stated obligations.**
  `picardJacobianWitness` is built from `Pic⁰_{C/k}` and reaches 98 project
  modules, up from 8; the whole committed tree is reachable from the project root.
  Two of its four structural fields are proved upstream (`Pic0.grpObj`,
  `Pic0.geometricallyIrreducible`); the other two, `Pic0.smooth` and `Pic0.proper`,
  are still `sorry`.  Added to those are three named leaves in `Jacobian.lean`: the
  rational point above, refining smoothness of `Pic⁰` to relative dimension
  `genus C`, and the Albanese property over an arbitrary base field.  Both of the
  latter two now have their landed half stated at the headline as a compiled theorem,
  so what each still owes is checkable rather than described: the *dimension count*
  `dim T_e Pic⁰ = genus C` holds already, and so does the Albanese property in the
  algebraically closed, positive-genus case.
