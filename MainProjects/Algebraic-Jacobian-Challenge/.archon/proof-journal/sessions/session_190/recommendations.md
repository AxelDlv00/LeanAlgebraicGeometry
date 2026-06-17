# Recommendations for iter-191 plan-phase

## CRITICAL — must address before any other prover dispatch

### 1. Resolve the `Scheme.WeilDivisor.positivePart` naming clash (integration build RED)

`lake build AlgebraicJacobian` exits 1 on:

```
AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:416:26:
  a non-private declaration `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`
  has already been declared
```

The iter-190 paired Lane I prover dispatch landed the SAME name in two
files:

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:502` —
  `noncomputable def positivePart` (public).
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:416` —
  `private noncomputable def WeilDivisor.positivePart` (file-local fallback).

Since `RationalCurveIso.lean` imports `WeilDivisor.lean` and Lean
resolves both into the same fully-qualified
`AlgebraicGeometry.Scheme.WeilDivisor.positivePart`, the file-local
`private` declaration is rejected as a redeclaration of a non-private
name. The fact that the file-local one is private does NOT shadow the
imported public one — Lean enforces uniqueness at the fully-qualified
level.

**Required iter-191 plan-phase action (refactor subagent or in-file
direct edit)**:

1. In `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`, delete:
   - Lines 416-418 (the file-local `private noncomputable def
     WeilDivisor.positivePart`).
   - Lines 420-461ish (the file-local `private theorem
     WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`).
2. Rewrite the `Hom.poleDivisor` body (around L504-L556) to use the
   *public* `Scheme.WeilDivisor.positivePart` from `WeilDivisor.lean`
   directly. The body becomes:
   ```
   Scheme.WeilDivisor.positivePart
     (Scheme.WeilDivisor.principal (algebraMap _ _ (localParameterAtInfty kbar).val) halg)
   ```
   (no namespace prefix needed if the file opens
   `AlgebraicGeometry.Scheme`).
3. Rewrite `Hom.poleDivisor_degree_eq_finrank` (around L585) to consume
   the public *existential* pin
   `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` —
   extract the existential witness via `Classical.choose`. Sketch:
   ```
   theorem Hom.poleDivisor_degree_eq_finrank ... :
       (Hom.poleDivisor φ).degree = Module.finrank K(ℙ¹) K(C) := by
     -- pre-existing setup binds halg, t := localParameterAtInfty kbar
     -- The public pin gives a witness t' for the equation.
     obtain ⟨t', halg', heq⟩ :=
       Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank K(ℙ¹) C.left
     -- problem: heq holds for t', not for our t = localParameterAtInfty kbar
     sorry  -- residual: bridge from chosen witness t' to localParameterAtInfty
   ```
   The bridge from the chosen witness `t'` to `localParameterAtInfty kbar`
   is non-trivial (the existential pin asserts existence of *some* witness
   without naming it). The cleanest resolution is **option (i)**: refactor
   the public pin signature to take an explicit local-parameter hypothesis
   (this aligns with the WeilDivisor prover's "Mismatch flag for review
   agent" suggestion); **option (ii)**: refactor `Hom.poleDivisor` itself
   to be defined via `Classical.choose`-extracted witness (semantics
   shifts away from "evaluate at localParameterAtInfty kbar").

   **Recommendation**: option (i). The blueprint label
   `lem:degree_positivePart_principal_eq_finrank` (in
   `RiemannRoch_WeilDivisor.tex` §6) reads as an equation; reshape the
   Lean signature to match (e.g. take an explicit
   `hpar : isLocalParameter t at_∞` hypothesis). The current existential
   form preserves soundness but creates a mismatch with both the
   blueprint prose AND the canonical consumer site.

4. After the rewrite, run `lake build AlgebraicJacobian` and confirm
   integration GREEN. Then re-run `lean_verify` on
   `AlgebraicGeometry.Scheme.Hom.poleDivisor_degree_eq_finrank` to
   confirm kernel-only axioms `{propext, Classical.choice, Quot.sound,
   sorryAx}` (the `sorryAx` is from the public pin).

5. Update PROJECT_STATUS.md `Last Updated` footer to note clash
   resolution.

**Time/scope estimate**: 1 prover lane, ~50 LOC change in
`RationalCurveIso.lean` plus possibly the signature reshape in
`WeilDivisor.lean` (option (i)). HARD BAR: integration build GREEN.

### 2. Prevent future paired-prover collisions

The root cause of finding §1 is the iter-190 plan's instruction "the
positivePart def lands in WeilDivisor.lean; the Pin 2 body close lands
in RationalCurveIso.lean after the dependency lands" — paired across
two files in the same iter, dispatched in parallel. Each prover saw
only its own file's snapshot.

**Recommendation to the plan agent**: when a refactor depends on a NEW
public symbol introduced in another file the same iter, ALWAYS
serialise:

- Iter-(N): land the public symbol in file A. Do NOT dispatch file B's
  consumer in the same iter (defer to iter-(N+1)).
- Iter-(N+1): consumer in file B sees the public symbol in its
  imports and can consume directly.

Alternatively, mandate the file-B prover to use a clearly-distinguished
private name (e.g. `_positivePartLocal`) for any fallback, with an
explicit comment "iter-(N+1) refactor: replace with public
Scheme.WeilDivisor.positivePart". This eliminates the namespace
collision risk.

The KB pattern entry "parallel-paired prover dispatch collision" is
added to PROJECT_STATUS.md.

## HIGH — chapter-level finding

### 3. Blueprint chapter `RiemannRoch_H1Vanishing.tex` covers a non-existent Lean file

`blueprint-doctor` (iter-190) flagged:

> chapter `RiemannRoch_H1Vanishing.tex` covers
> `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`, which does not exist

The blueprint chapter was landed iter-190 plan-phase (via
`blueprint-writer rr-h1vanishing-skeleton`, 560 lines) ahead of the
Lean file. Resolutions for iter-191 plan-phase:

- **Recommended**: have a refactor subagent create
  `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` as a skeleton (def
  signatures + `sorry` bodies, mirroring the chapter's `\lean{...}`
  pins). Then dispatch the iter-191 Lane H prover on those new sorries.
- **Alternative**: drop the `% archon:covers` line from the chapter
  until the Lean file exists. This loses the HARD GATE coverage check
  for Lane H but keeps the doctor clean.

The first option is consistent with the iter-190 plan §HALTED rationale
that the chapter "LANDED iter-190 plan-phase" exists to unblock
iter-191+ scaffolding.

### 4. Blueprint mismatch on `lem:degree_positivePart_principal_eq_finrank`

WeilDivisor prover's task report explicitly flags:

> The blueprint label `lem:degree_positivePart_principal_eq_finrank`
> reads as an *equation* statement (`deg(...) = finrank`), but the
> Lean pin is in *existential* form for soundness.

This is the same issue addressed in finding §1 option (i) above. The
plan agent should either:
- Re-tighten the Lean signature to take an explicit "local parameter
  at ∞" hypothesis (making the equation form true), OR
- Re-write the blueprint prose to match the existential phrasing
  ("there exists a local parameter at ∞ such that ...").

Doing this iter-191 plan-phase as a direct chapter edit + Lean
signature refactor (combined with finding §1 resolution) is cleaner
than letting the mismatch propagate.

## MEDIUM — converging routes ready for prover dispatch (post-clash-fix)

### 5. Lane F — `pullback_of_openImmersion_iso_restrict` (QuotScheme L650) ready to close

Per the QuotScheme task report: the AddEquiv is fully built, the
smul through `Hom.app` is migrated correctly. The residual gap is
reduced to a single Mathlib API-level chain (NO upstream PR needed):

- `Scheme.Hom.appLE_appIso_inv` (OpenImmersion.lean:229)
- `IsAffineOpen.fromSpec_app_self` (AffineScheme.lean:561)
- `ModuleCat.restrictScalars.smul_def` (ChangeOfRings.lean)

Estimated 30-60 LOC iter-191 closure. Reverses the iter-190
progress-critic CHURNING verdict to CONVERGING upon clean closure.

**Important update to iter-190 plan's escalation rule**: the iter-190
plan said "If Step 3 fails axiom-clean, route escalates iter-191 to
user-escalation for Mathlib upstream PR on Stacks 01I8". This rule
does NOT apply because the failure is on Stacks 01HH-style structure-
sheaf compatibility, not Stacks 01I8. Both ingredients are in Mathlib
b80f227. Re-evaluate the escalation rule and dispatch a normal prover
lane.

### 6. Lane G — `isDomain_of_regularLocal` residual case `x ∈ 𝔭`

Strategy decision deferred to iter-191 plan-phase. Three options
documented in the AuslanderBuchsbaum task report:

- **(a)** Project-side `gr_𝔪(R) ≅ κ[X₁,...,X_d]` standalone formalization
  (~500-800 LOC, reusable for many regular-local results).
- **(b)** Mathlib upstream PR for Stacks 00NQ (estimated 4-8 weeks).
- **(c)** Direct bypass via Cohen structure theorem + completion (Mathlib
  has IsAdicComplete infrastructure but likely not Cohen structure).

The iter-190 plan-phase already committed to project-side Stacks 00NQ
build (Option (a) variant). The iter-190 prover narrowed the substrate
dramatically (full induction scaffold + base case + inductive prep +
`x ∉ 𝔭` branch all axiom-clean); the residual is concentrated in the
`(x) ∈ minimalPrimes R` contradiction step. Plan agent should EITHER
authorise the ~500-800 LOC graded-ring build (multi-iter), or pivot
to a `mathlib-analogist` dispatch to find a cross-domain analog that
might short-circuit (e.g. "regular sequence of length ≥1 in regular
local ⟹ R/(x) is regular local of dim −1 implies no minimal prime
collapses").

### 7. Lane E — `iotaGm_chart1_composition_isOpenImmersion` (AVR L261)

Per AVR task report: approach (b) preferred — refactor
`iotaGm_chart1_composition_isOpenImmersion` + downstream
`iotaGm_chart1_section` to specialise on `iotaGm_r_1` / `iotaGm_r_1_fac`
directly (drop abstract `r_1, h_r_1` parameters). Then
`IsOpenImmersion.lift_app` applies via `unfold iotaGm_r_1` without
`cancel_mono`. Estimated ~30 LOC refactor + ~80 LOC closure = ~110 LOC
over 1-2 iters.

Best dispatched as a refactor subagent first, then prover on the
specialised body.

### 8. Lane B — GmScaling consumers ready to close

iter-190 closed Substrate 2. Per `analogies/lane-b-substrate.md` §3,
Substrate 1 + Substrate 2 now unblock 3 GmScaling consumer sorries:
`gmScalingP1_chart_agreement_cross01`, `gm_geomIrred`, `projGm_isReduced`.
Dispatch a `GmScaling.lean` prover iter-191 with the two substrates
as authorised premises (file is not in iter-190's edit list — clean
target).

## DO NOT RETRY

### Same as iter-190 deferrals (carry forward to iter-191)

- **Lane A.3.i `Picard/IdentityComponent.lean`**: HALTED iter-190; the
  `mathlib-analogist lane-a3i-isconnected-prod` directive was prepared
  but DISPATCH DEFERRED to iter-191 plan-phase per max_parallel
  semaphore. Dispatch first thing iter-191; do NOT dispatch prover until
  the analogist returns. Per progress-critic iter-190: HARD SCOPE CAP
  fired iter-189 (0 closures vs ≥2 target; 16 helpers across 4 iters;
  net +3 sorries since phase entry).
- **Lane H `RiemannRoch/RRFormula.lean`**: continue HALT iter-191
  prover until `RiemannRoch/H1Vanishing.lean` skeleton exists (finding
  §3) AND prover closes ≥1 substantive sorry there.
- **Lane J `Picard/QuotScheme.lean` Step 1 (Stacks 01XJ pushforward
  quasicoherence)**: do NOT retry without a fresh `mathlib-analogist`
  consult on Stacks 01XJ. iter-188 marked as complete-except-upstream-gap.
- **Lane M↓ `Albanese/CodimOneExtension.lean` (iter-188 Option (c) →
  iter-190 Option (a))**: re-opened iter-190 plan-phase per strategy-
  critic REJECT on permanent typed sorry; iter-191+ first prover
  dispatch on the project-side Stacks 00TT proof chain. Do NOT skip the
  re-open — iter-190 plan-phase committed to it.

## Reusable proof patterns (for KB)

Captured in `summary.md` "Key findings" and added to PROJECT_STATUS.md
Knowledge Base:

1. Parallel-paired prover dispatch across two files (introduce-public
   in A, consume in B) is unsafe — serialise across iters.
2. Existential vs equational typed-sorry pins: prefer existential when
   the equation is false-as-stated for free parameters.
3. `change`-based defeq reshape beats `rw`-based pattern match for
   `OverClass.asOver` carrier identifications (re-confirmed iter-190).
4. `ringKrullDim_le_ringKrullDim_quotient_add_encard` (Krull's height)
   sidesteps `IsSMulRegular` requirement in the regular-quotient half.
