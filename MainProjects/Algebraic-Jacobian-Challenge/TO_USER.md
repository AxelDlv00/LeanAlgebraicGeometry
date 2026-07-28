<!-- Shared notice board. Keep to at most three short bullets. -->

- **Your étale-sheafify decision is EXECUTED** (inbox `I-0372`, protection
  `I-0491`, roadmap `AJC.picrep.rational-point`).  Nothing is waiting on you here.
  The Jacobian headline now carries **no** rational-point hypothesis — exactly the
  three challenge hypotheses and nothing else — and what gets represented is the
  étale-sheafified relative Picard functor.  Four things landed: the functor itself
  with its sheaf property **proved** (`Picard/PicEtSheaf.lean`, `sorry`-free, on
  Mathlib v4.31's étale site localised at `Spec k`); the representability obligation
  restated for it as one named `sorry`
  (`Scheme.fgaPicardRepresentability`) which is expected to stay open; the false leaf
  `hasRationalPoint_of_curve` **deleted**, never proved; and
  `picardJacobianWitness` reassembled on `Pic⁰` in its étale form.  The two
  conditional results are kept and relabelled as such —
  `picardJacobianWitnessOfHasRationalPoint` (true under a section, strictly weaker
  than the challenge) and `picardJacobianWitnessOfIsAlgClosed` (a genuine `k̄`
  theorem) — and neither is presented as the headline.  **The obligation count is
  still five, and that is the deliverable**: what changed is that none of the five is
  a *false* statement any more, so nothing downstream rests on an inconsistent
  hypothesis.  The five are `fgaPicardRepresentability`,
  `Pic0Et.geometricallyReduced`, `Pic0Et.universallyClosed`,
  `smoothOfRelativeDimension_genus_pic0Et` and `isAlbanese_pic0Et`.  That the
  headline carries no rational-point binder is checked rather than asserted: the
  `HeadlineBinders` section of `scripts/axiom-frontier.lean` stops elaborating if one
  ever returns.  Route choice unaffected: Milne–Kollár stays committed, Quot stays
  retained-not-revived.

- **Sorry-free is not axiom-clean, and there are eight separate ways to be misled.**
  Run `lake env lean scripts/axiom-frontier.lean` before believing any completeness
  number; it probes 147 declarations, 95 clean and 52 carrying `sorryAx` as last
  measured (2026-07-28, `lake build AlgebraicJacobian.Jacobian` green at 8,657 jobs).
  (1) A `sorry`-bodied *instance* leaks through synthesis, so a theorem reports
  clean axioms while every real consumer depends on `sorryAx`.  As of 2026-07-28 there
  are **none left**, which is worth stating precisely because this trap has been the
  headline caveat for months: `instHasPicScheme` was demoted to the named theorem
  `picSchemeOfHasRationalPoint` by the étale rewire (so it cannot fire by synthesis at
  all), and `pullback_preservesFiniteLimits` was proved by `ajc-fbc`.  Measured, not
  assumed: of the tree's 28 `sorry` carriers, zero are instances.  The trap remains
  worth understanding — it costs nothing to re-check and a reintroduced sorried
  instance would be invisible again — and the probe's §2 and §8/§8b are where to
  check it.
  (2) An *unproved*
  named hypothesis in a statement is invisible to the check.  (3) So is a *false*
  one — which makes the theorem vacuously true and perfectly clean; this was found
  in the rigid-pushforward cone, not hypothesised.  (4) So is an *instance binder
  nothing can instantiate* for the object actually used; this cost a claimed
  discharge in the Riemann–Roch lane this week, caught and retracted.  (5) An
  unrooted module is not probed at all, because the root import never reaches it.
  (6) Two different *instances* can supply one binder without being equal, so a file
  can prove correct-looking theorems about a definition pinned to the wrong one; this
  one survives both the axiom check and an instantiability probe.  (7) A hypothesis can
  be *refutable*: its negation already derivable in the tree at every instance anyone
  would use, so the project proves both `H → C` and `¬H` and the theorem is true,
  clean, consistent, instantiable and empty.  Found this session in the χ-ledger lane
  and reported to its owner; it defeats every check above, including a consistency
  witness.  (8) A hypothesis can be *equivalent* to the conclusion it is supposed to buy,
  making `H → C` a restatement rather than a reduction; this is the cheapest of the eight
  to check and the one to check first — attempt `C → H`.
  Genuinely clean and unconditional, verified: the adelic genus lane, degree-1
  affine vanishing, the Čech higher-direct-image comparison, and — new this week —
  the **whole B3 rigid-pushforward gate**, which now carries a real instance for
  every curve satisfying the challenge hypotheses.  That last one is measured at
  the synthesis site, not merely as stated, which is the only check that
  distinguishes it from case (1) above.

- **The headline is wired, and rests on five stated obligations — over `k̄`, five true ones.**
  `picardJacobianWitness` is built from `Pic⁰_{C/k}` and reaches 98 project
  modules, up from 8; the whole committed tree is reachable from the project root.
  Two of its four structural fields are proved upstream (`Pic0.grpObj`,
  `Pic0.geometricallyIrreducible`); the other two, `Pic0.smooth` and `Pic0.proper`,
  are still `sorry` — but `Pic0.smooth` got materially smaller this week, in a way no
  axiom count shows.  Its whole remaining content is geometric reducedness of `Pic⁰`:
  Mathlib's public `smooth_of_grpObj` already performs the translation argument over an
  arbitrary field, and the two other inputs it needs are landed here.  So that obligation
  is Cartier's theorem in characteristic zero, and a genuine characteristic-`p` statement
  otherwise — not the tangent-space-plus-translation construction its own docstring
  planned.  `Pic0.proper` is unaffected.  Added to those are three named leaves in
  `Jacobian.lean`: the
  rational point above, refining smoothness of `Pic⁰` to relative dimension
  `genus C`, and the Albanese property over an arbitrary base field.  Both of the
  latter two now have their landed half stated at the headline as a compiled theorem,
  so what each still owes is checkable rather than described: the *dimension count*
  `dim T_e Pic⁰ = genus C` holds already, and so does the Albanese property in the
  algebraically closed, positive-genus case.  The rational-point leaf is the one whose
  algebraically closed case is a full discharge, so over `k̄` the witness
  (`picardJacobianWitnessOfIsAlgClosed`) rests on no false hypothesis, unlike the general
  one.  The *number* of obligations does not drop either way — it is five before and
  after the étale rewire — and the difference is that all five are now true.  That
  distinction is not visible in any axiom count: a witness resting on an inconsistent
  leaf reports exactly what an honest one does, which is why the headline's binders are
  checked by elaboration instead (`HeadlineBinders` in the probe).  The protected
  `Jacobian` declarations now route through the étale witness, so they no longer
  depend on a false statement.
