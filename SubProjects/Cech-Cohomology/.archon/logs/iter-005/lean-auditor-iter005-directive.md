# Audit directive — iter-005

## Files to audit (absolute paths)

- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

This file received heavy prover work this iteration (≈27 new declarations added). It now
compiles with 0 sorries and 0 errors (only style/long-line and unused-section-variable
warnings reported by the prover).

## Focus areas

1. **Non-vacuity of the new declarations.** The new block builds the "dual Horseshoe Lemma"
   core: a twisted-biproduct cochain complex (`twistedBiprod`, `twistedBiprodD`,
   `twistedBiprodD_comp`, `twistedBiprodSplitting`, `twistedBiprodInl/Snd`), a degree-recursive
   off-diagonal twist family (`horseshoeτ`, `twistPair`, `horseshoeτ_cocycle`, `horseshoeτZero`,
   `horseshoeβ₁`, `horseshoeH`), the middle complex (`horseshoeMid`), and a degreewise-split
   short exact sequence of complexes (`horseshoeSES`, `horseshoeSES_splitting`,
   `horseshoeSES_shortExact`). Confirm each genuinely consumes its stated hypotheses (e.g. the
   cocycle hypothesis `hτ` in `twistedBiprodD_comp`; `descToInjective` against real exactness in
   `twistPair`) and is not trivially/vacuously true.

2. **Workaround hygiene.** The prover reported several workarounds: explicit `@Injective.factorThru`
   with the mono passed positionally; a clean-domain wrapper `ιC0 := I_C.ι.f 0`; standalone
   side-condition lemmas (`horseshoeτZero_hf`) to dodge universe-metavariable `rw` flakiness.
   Check these are sound and not masking a real gap — in particular that `ιC0` is truly defeq to
   `I_C.ι.f 0` and not a re-definition that changes meaning.

3. **Outdated comments / dead code.** The file carries large `/-! ... -/` strategy/status comment
   blocks (a "Status (iter-005)" block, "Dead-ends" notes). Flag any comment that now contradicts
   the code, any commented-out declaration, or any `def`/`example` inside a comment fence that the
   `sync_leanok` matcher could misread as a real declaration (this trap poisoned the DAG in
   iter-004 — verify it is NOT reintroduced).

4. **Bad Lean practice** — improper `@[simp]` on non-confluent lemmas, `sorry`-free but circular
   reasoning, axioms beyond `propext / Classical.choice / Quot.sound`.

## What I do NOT need

No strategy framing, no blueprint content, no "what we are trying to prove". Audit the Lean as
Lean. Report a per-file checklist plus a flagged-issues block with severities.
