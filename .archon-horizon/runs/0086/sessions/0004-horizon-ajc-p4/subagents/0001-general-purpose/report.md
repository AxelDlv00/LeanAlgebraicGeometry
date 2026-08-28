You are auditing three Lean modules just landed by lane `ajc-p4` in the project at
/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge
(a Lean 4 + mathlib project). Work from the STATEMENTS, not the docstrings. Be adversarial:
the workspace's standing bar is that an audit on 2026-07-29 refuted 99 of 101 sampled
representability claims (67 sorry-reachable, 17 VACUOUS, 12 proved something adjacent to
what was claimed).

The three files (read them in full):
1. AlgebraicJacobian/Picard/FiberRankSemicontinuity.lean  — `Ideal.isOpen_fiberRank_le`,
   `Ideal.isClosed_le_fiberRank`
2. AlgebraicJacobian/Picard/TwoTermKernelSemicontinuity.lean — namespace
   `AlgebraicJacobian.TwoTerm`: `fiberRank_quotRange_eq_finrank_quot_baseChange`,
   `finrank_ker_baseChange_add_eq`, `finitePresentation_quotRange`,
   `isOpen_finrank_ker_baseChange_le`, `isClosed_le_finrank_ker_baseChange`
3. AlgebraicJacobian/Picard/FiberH0CechKernel.lean —
   `AlgebraicGeometry.finrank_ker_moduleSectionDiffBase_baseChange_eq_fiberH0`

To run Lean: `cd` to the project dir and use
`timeout 1800 env -u LEAN_PATH lake env lean <file-or-tmpfile>`; the build is current, so
`import AlgebraicJacobian.Picard.<Mod>` works in a scratch file under /tmp. `#print axioms`
works. Do NOT edit any file in the project; write scratch probes to /tmp only.

Check these specific claims, and report each as CONFIRMED or REFUTED with the probe you ran:

(A) VACUITY. For each theorem, are its hypotheses inhabitable by data where the conclusion
    is NOT trivially true? Specifically:
    - `isOpen_fiberRank_le`: is there an `R`, `M` finitely presented, where the sublevel
      locus is a PROPER nonempty open subset (so the statement is not "IsOpen univ" in
      disguise)? I claim R = ℤ, M = ZMod 2, e = 0.
    - `isOpen_finrank_ker_baseChange_le`: same question. I claim A = ℤ, K = ℤ, n = 1,
      k = multiplication by 2, where coker k = ℤ/2 and the fibrewise kernel dimension is
      0 at the generic point and 1 at (2). VERIFY THE JUMP IS REAL — actually compute or
      bound both fibres, do not take my word.
    - Does any of the three theorems hold vacuously because a `finrank` is a junk `0` on
      both sides? The junk-value hazard is real in this file family (Module.finrank returns
      0 in the infinite-dimensional case).

(B) DID I PROVE WHAT I CLAIMED, or something adjacent? In particular:
    - `finrank_ker_baseChange_add_eq` claims `dim ker (k ⊗ κ(t)) + n = fiberRank K +
      fiberRank (coker k)`. Is `n` really the dimension of the fibre of the target `Fin n → A`,
      and is the identity the honest rank-nullity rather than something weaker?
    - `isOpen_finrank_ker_baseChange_le` — is `Module.Projective A K` load-bearing, or is it
      decorative? Try removing it (state the theorem without it in a scratch file with
      `sorry` and see whether the proof's local-constancy step can still be obtained;
      also think about whether the statement is FALSE without it — if K is not flat, does
      the sublevel locus of dim ker stay open? Give a counterexample or say you could not
      find one).
    - `finrank_ker_moduteSectionDiffBase_baseChange_eq_fiberH0`: I claim this needs NO
      `hbc` hypothesis, where the pre-existing `fiberRank_gammaTop_eq_fiberH0` in
      AlgebraicJacobian/Picard/FiberH0Comparison.lean DOES take `hbc`. Verify that my
      theorem's statement genuinely has no such hypothesis (check every binder, including
      instance binders and `letI`s), and that its conclusion really is about
      `p.fiberH0 M t` and not about a different object.

(C) THE REPRICING CLAIM, which is the load-bearing prose claim. I assert in commit
    42c586ff1 and in the corrected docstring of FiberH0Comparison.lean that `hbc` in
    `fiberRank_gammaTop_eq_fiberH0` is consumed in "step 3 only", and that steps 4-6
    alone reach `fiberH0`. Read that proof and confirm or refute: is `hbc` (bound as
    `hbcK` at line ~190) used anywhere other than `step3`? Is the conclusion of my new
    theorem genuinely the LHS of step 4 rather than a restatement of the original's
    conclusion?

(D) Do any of my five/one declarations depend on `sorryAx`? Run `#print axioms` on all of
    them yourself.

Report concisely: a numbered list of findings, each CONFIRMED/REFUTED, with the probe text
and its exit status. If you find a defect, state precisely which sentence or which theorem
is wrong and what the truth is. Do not fix anything.
