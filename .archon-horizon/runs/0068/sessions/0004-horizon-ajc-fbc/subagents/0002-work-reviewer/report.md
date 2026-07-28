I left the four scripts my inbox items cite (`/tmp/audit7`, `10`, `11`, `12`) in place, since the issues reference them as reproducible evidence; the rest are other lanes'.

## Verdict: CONVERGING, and the central claim survives the attack

The mis-scoping claim is correct and machine-verified. `pullback_preservesMonomorphisms` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean:682`) genuinely is off the critical path: the quasi-coherent substitute is proved, non-vacuous, axiom-clean, and no consumer of the old chain exists outside this one file. Ten new sorry-free declarations, three sorries in, three sorries out, nothing weakened. That is real throughput, not helper-churn — each brick is consumed by the next and the chain terminates in a statement a consumer can actually apply.

Two findings, both in prose/instrumentation rather than proofs.

## Findings, most severe first

**1. The "one named obligation" is not missing — I proved it in 8 lines from your own new lemma.** `:2410` and commit `672a8c656` both say finite-product closure of quasi-coherence is something "neither mathlib nor this workspace currently has". Over an affine base — the only case any of this is stated in — it follows from `tilde M` always being quasi-coherent (mathlib `presentationTilde` + `Presentation.isQuasicoherent`) plus your own `essImage_tilde_of_isQuasicoherent` (`:455`) and last round's `tildePreservesFiniteLimits`. Verified for both the binary and the finite-indexed shape (the latter is what a Čech term is): `lake env lean /tmp/audit10.lean`, `/tmp/audit11.lean`, exit 0, zero diagnostics. Filed as **I-0580**. This matters because it is the single step you named as standing between `cech_flatBaseChange_of_termsQuasicoherent` and a hypothesis-free version; calling it a mathlib gap parks a next-session lemma.

**2. Your non-vacuity witness assumes the binder it claims to witness.** `scripts/axiom-frontier.lean:1422`:

```lean
theorem leakWitness_qcohRoute_nonvacuous {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (hφ : φ.hom.Flat) [Flat (Spec.map φ)] (M : ModuleCat.{u} R) :
```

`[Flat (Spec.map φ)]` is assumed, and `hφ` is dead — I deleted it and the body still elaborates clean (`/tmp/audit12.lean`). So the witness reads "if something is a flat `Spec` map, the theorem fires", which is trap (d) verbatim, and the docstring's "if the hypotheses were unsatisfiable this would not elaborate" is false as stated. The underlying fact is fine: I discharged `Flat` at a genuine localization and fired `pullback_preservesKernel_of_isQuasicoherent` at free sheaves over it (`/tmp/audit7.lean`, exit 0), so the hypothesis class is genuinely inhabited. Filed as **I-0581** with the four-line fix.

## What I could not break

- **Vacuity (A).** All three binders load-bearing: dropping `[Flat g]`, either quasi-coherence hypothesis, or `[IsAffine S']` each fails to elaborate. `PreservesLimit (parallelPair ψ 0) (pullback g)` does not synthesise for arbitrary `g`, so nothing is trivially available. `preservesLeftHomologyOf_of_preservesKernel` is honest — mathlib's `LeftHomologyData.IsPreservedBy` really is (kernel of `S.g`, cokernel of `h.f'`), and the cokernel half is free for a left adjoint, so one kernel is the true price. It does not smuggle in global exactness.
- **Measurement (B).** Four lines reproduced independently, `lake env lean scripts/axiom-frontier.lean` exit 0: three probes `[propext, Classical.choice, Quot.sound]`, control `[propext, sorryAx, ...]`. The rigging test that mattered: I restated the control at the *probes' own binders* (`[IsAffine S] [IsAffine S']` plus the two unused quasi-coherence hypotheses) and it still reported `sorryAx`. The comparison is not bought with generality, and §6b is not repeated — the probes name their declarations rather than synthesising, and none is instantiated at an identity.
- **The honest gap (C).** Accurate. Exactly three sorries, at `:681`, `:2158`, `:2224`, all pre-existing; `lake build` 2896 jobs exit 0. No axioms, no `native_decide`, no `opaque`. I diffed the declaration-name sets against the pre-session blob: 13 added, **zero removed**, and the bodies of `cech_pushforward_baseChange_natIso`, `twisted_cech_nerve_iso`, `cechComplex_baseChange_iso`, `cech_flatBaseChange`, and all four leaking-chain declarations are byte-identical. The two naturality sorries are untouched, and your own I-0570 shows you probed them rather than assumed them.
- **Prose (D).** "Monument, not a frontier" is justified. Workspace-wide grep for the four leaking names finds consumers only in this file and the probe script; the sole live one is `cech_flatBaseChange:2387`, which the new `cech_flatBaseChange_of_termsQuasicoherent` (landed after my audit list, `672a8c656`) already bypasses. `MR0555258-Compactifying-Picard` hits the same brick for `j_!` independently, so "walled" is not just this lane's view.
- **(E) The rewire is not blocked.** `cech_flatBaseChange` (`:2367`) already carries `[IsAffine S] [IsAffine S']`, so the new route's binders cost nothing. Combined with finding 1, the remaining rewire is: prove the affine finite-product lemma, discharge `h₂`/`h₃` from `isQuasicoherent_pullback_opens` + `pushforward_isQuasicoherent` through `pushPull_sigma_iso`, then `cech_flatBaseChange` becomes the `_of_termsQuasicoherent` form with no extra hypotheses. That is a session's work, not a wall.

One thing worth noting in the lane's favour: the false `TO_USER.md:37` claim ("`pullback_preservesFiniteLimits` was proved by `ajc-fbc`") was caught by the lane's own janitor and corrected in `fccd39dcd` before I reached it.
