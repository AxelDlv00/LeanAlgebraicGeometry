# Blueprint Reviewer Directive

## Slug
iter153

## Strategy snapshot

End-state: formalize Christian Merten's Jacobian challenge — nine protected
declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` (existence of an Albanese/Jacobian object
uniform over the k-rational pointing of a smooth proper geometrically
irreducible curve C/k, with NO `C(k) ≠ ∅` hypothesis). Zero inline `sorry`,
kernel-only axioms.

Spine = **pointed vs. unpointed** (not genus-0-vs-positive): the witness OBJECT
`J` is always real; only `isAlbaneseFor` is universally quantified over the
pointing `P`. Genus-0 rigidity content is now proved **over an algebraically
closed base field k̄** and descended to a general base `k` along
`Spec k̄ → Spec k`.

**Iter-152 `[IsAlgClosed]` architectural pivot (the thing you must re-confirm).**
The chart-algebra core lemma `mem_range_algebraMap_of_D_eq_zero` was proven
mathematically FALSE as a bare `B`-only algebra lemma at iter-151 (counterexamples
`B = k×k`, `ℚ(√2)/ℚ`). The fix, landed iter-152: add `[IsAlgClosed kbar]` +
`[CharZero kbar]` to `rigidity_over_kbar` (not protected; matches its own "over
k̄" intent) and propagate `[IsAlgClosed k]` + `[IsDomain B]` to the chart-algebra
chain. Effects:
- KDM `mem_range_algebraMap_of_D_eq_zero` is now TRUE (residual = a genuine
  field-of-fractions transfer step, not a false-statement sorry).
- `constants_integral_over_base_field` COLLAPSES under `[IsAlgClosed k]` to a
  ~15-LOC proof via `IsAlgClosed.algebraMap_bijective_of_isIntegral` [verified,
  Mathlib.FieldTheory.IsAlgClosed.Basic]. The `(S3.sep.1/2)+(S3.pi.1/2)`
  decomposition + the ~150–250 LOC flat-base-change-of-Γ Mathlib gap are
  DESCOPED off the critical path.
- Cost displaced: a 2-line `k̄→k` descent in `genusZeroWitness`.

This iter (153) is the **prover-validation iter** for that pivot: a prover will
close `constants_integral_over_base_field` over k̄ in
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (blueprint: `RigidityKbar.tex`
§ "Chart-algebra piece (ii)"). **Your job is the HARD-GATE re-confirmation:
is `RigidityKbar.tex` now `complete:true / correct:true` for the chart-algebra
declarations the prover will touch?** At iter-152 you reported it `correct:false`
(before the 4 writers rewrote it); the lean-vs-blueprint-checker subsequently
confirmed the rewrite is faithful. Confirm or refute that the gate now clears.

## Routes

- **Route C (M2 critical path)** — chart-algebra piece (ii), over `[IsAlgClosed kbar]`.
  Lean: `Cotangent/ChartAlgebra.lean`. Blueprint: `RigidityKbar.tex` §
  "Chart-algebra piece (ii)". This is the active prover route this iter.
- **Route A (M3 off-critical-path)** — Picard scheme via FGA (Kleiman/Nitsure).
  Blueprint: `Jacobian.tex` § "Route A". No prover work; coverage check only.

## References
- `references/stacks-algebra.md` → Stacks ch.10, tag 00T7 (standard smooth ⇒ Ω free) — backs the KDM polynomial-ring layer in `RigidityKbar.tex`.
- `references/kleiman-picard.md`, `references/nitsure-hilbert-quot.md` — back `Jacobian.tex` Route A.
- `references/stacks-varieties.md` — geometrically reduced/normal, backs `ChartAlgebraS3.tex` (off-path scaffolds).

## Focus areas
- `RigidityKbar.tex` — the chart-algebra declarations `mem_range_algebraMap_of_D_eq_zero`,
  `constants_integral_over_base_field`, `df_zero_factors_through_constant_on_chart`,
  `ext_of_diff_zero`. Confirm: alg-closed hypotheses present on both sides; the
  KDM sketch matches the now-TRUE field-of-fractions statement; the constants
  sketch matches the alg-closed `IsAlgClosed.algebraMap_bijective_of_isIntegral`
  collapse (and is NOT contradicted by a stale base-change-to-k̄ recipe in the
  PROSE — note: the Lean docstring is stale here but that's the prover's to fix,
  not yours; flag only chapter-side issues).
- `Jacobian.tex` — confirm the over-k→alg-closed+descent reconciliation reads
  coherently and Route A coverage exists.

## Known issues (do not re-report)
- Stale Lean-side docstrings/comments in `ChartAlgebra.lean` (3-substep recipe;
  iter-149 framing) — these are Lean-source, will be cleaned by this iter's
  prover; out of your scope.
- `\leanok` marker lag on the two sorry-bearing proof blocks — owned by the
  deterministic `sync_leanok` phase; not a finding for you.
- ChartAlgebraS3.tex is intentionally off-critical-path (descoped); its lemmas
  are retained as valid general-over-k scaffolds. Do not flag it as "should feed
  a prover" — confirm only that it is internally coherent and its cref targets
  resolve.
