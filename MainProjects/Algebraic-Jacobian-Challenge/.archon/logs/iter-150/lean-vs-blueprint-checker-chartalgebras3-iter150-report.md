# Lean ↔ Blueprint Check Report

## Slug

chartalgebras3-iter150

## Iteration

150

## Files audited

- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`
- Blueprint (pointer): `blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`
- Blueprint (canonical statements): `blueprint/src/chapters/RigidityKbar.tex`, lines 1988–2091

This is a **pointer chapter** (per directive: thin redirector to `RigidityKbar.tex`). All four `\lean{...}` blocks for the (S3.\*) lemmas live in the canonical chapter; the pointer chapter only enumerates them and contributes (S3.\*)-specific prose. Cross-checks of `\lean{...}` ↔ Lean signature were carried out against `RigidityKbar.tex`.

## Build / sorry state (sanity check)

`lean_diagnostic_messages` on the target file: **no errors**; four `declaration uses 'sorry'` warnings at lines 180, 243, 324, 389 — i.e. the four (S3.\*) bodies. The new helper at L435–443 (`Algebra.IsSeparable.of_finite_of_perfectField`) compiles **sorry-free** (one-liner via `Algebra.IsAlgebraic.isSeparable_of_perfectField`).

## Per-declaration

### `\lean{AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth}` (canonical: \lem:S3_sep_1_smooth_geometrically_reduced_Gamma, RigidityKbar.tex:1992–2012)

- **Lean target exists**: yes, `ChartAlgebraS3.lean:180`
- **Signature matches**: yes. `{k : Type u} [Field k] {X : Scheme} [X.Over (Spec (CommRingCat.of k))] [IsProper …] [Smooth …] : letI := gammaAlgebra k X; Algebra.IsGeometricallyReduced k ↥(Γ(X,⊤))`. The blueprint prose ("smooth proper scheme over a field $k$ → `Algebra.IsGeometricallyReduced k Γ(X,O_X)`") aligns exactly.
- **Proof follows sketch**: N/A — Lean body is `sorry`. Blueprint proof (RigidityKbar.tex:1999–2012) sketches Stacks 035U + 04QM → reducedness of $X_K$ → injection into stalks → \cref{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}. The Lean body's in-source comment encodes a 4-step plan that follows this sketch faithfully.
- **`\leanok` desync (informational only)**: RigidityKbar.tex:1990 has `\leanok` on the statement block and L2001 has `\leanok` on the proof block, while the Lean body is `sorry`. This is the standard tri-state ("statement formalised, proof open"). The `sync_leanok` deterministic phase manages these markers — agents must not edit them. Flagged here as informational, not as a Lean ↔ blueprint mismatch.
- **Signature drift check**: iter-150 prover-lane HYBRID part (B) attempted to inflate this signature with `[CharZero k]` / `[PerfectField k]`. The current source has **no such typeclass in the signature** — the revert landed cleanly. Confirmed.
- **Iter-150 docstring**: large new "Iter-150 prover-lane status (HYBRID part (B) attempted; consumer-blocked)" block at L148–179 added; consistent with the iter-150 task_result narrative. Mentions consumer-compatibility blocker on `ChartAlgebra.lean:L431` and the missing Mathlib bridge `Algebra.IsSeparable ⇒ Algebra.IsGeometricallyReduced`.

### `\lean{Algebra.IsSeparable.of_isGeometricallyReduced_of_finite}` (canonical: \lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable, RigidityKbar.tex:2016–2035)

- **Lean target exists**: yes, `ChartAlgebraS3.lean:324` (declared in the `_root_.Algebra.IsSeparable` namespace).
- **Signature matches**: yes. `(k F : Type u) [Field k] [Field F] [Algebra k F] [Algebra.IsGeometricallyReduced k F] [FiniteDimensional k F] : Algebra.IsSeparable k F`. Blueprint prose ("Let $F/k$ be a finite field extension. If $F$ is geometrically reduced over $k$, then $F/k$ is separable") aligns.
- **Proof follows sketch**: N/A — `sorry`. Blueprint proof body (RigidityKbar.tex:2024–2034) sketches the Artinian-product chase ($F \otimes_k \bar k$ finite-dim reduced ⇒ product of fields ⇒ each factor = $\bar k$ ⇒ embedding count = degree ⇒ separable). The Lean body's in-source comment plan (steps (a)–(d) at L333–341) matches this sketch step-for-step.
- **No `\leanok` desync**: statement and proof blocks both unmarked. Consistent.
- **Signature drift check**: iter-150 prover-lane HYBRID part (B) attempted to add `[PerfectField k]` and discharge via `Algebra.IsAlgebraic.isSeparable_of_perfectField`. The current source has **no such typeclass in the signature** — revert landed cleanly.
- **Iter-150 docstring**: large new "Iter-150 prover-lane partial progress (HYBRID part (B) attempted)" block at L306–323; cross-references the consumer signature at `ChartAlgebra.lean:L457` and the analogist consult.

### `\lean{AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper}` (canonical: \lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper, RigidityKbar.tex:2041–2064)

- **Lean target exists**: yes, `ChartAlgebraS3.lean:243`.
- **Signature matches**: **partial**. Blueprint prose ("the canonical comparison map $\Gamma(X,O_X) \otimes_k K \to \Gamma(X_K, O_{X_K})$ is an isomorphism of $K$-algebras") asserts a specific named map is iso; Lean states `Nonempty (TensorProduct k Γ K ≃ₐ[K] Γ(X_K))` (some such iso exists). The "Signature note" docstring block at L213–218 explicitly acknowledges this packaging choice. The downstream call-site consumes `Nonempty.choose`, which is acceptable for the project-internal target, but blueprint readers should note that the prose's claim is strictly stronger than the formalised statement. **Severity: minor** — packaging difference, mathematical content matches.
- **Proof follows sketch**: N/A — `sorry`. Blueprint proof body (RigidityKbar.tex:2052–2064) sketches the 5-step Čech-equaliser + flat-tensor exchange chase (Stacks 02KH/00DS specialised to $H^0$). The Lean body's in-source comment (L260–275) is a faithful 5-step plan matching the blueprint sketch.
- **`\leanok` desync (informational only)**: RigidityKbar.tex:2039 has `\leanok` on the statement block and L2054 has `\leanok` on the proof block, but the Lean body is `sorry`. Same tri-state pattern as (S3.sep.1). `sync_leanok` owns this; informational only.
- **Signature drift check**: no iter-150 inflation attempted on this lemma per the task_result. Current source matches iter-149 baseline. Confirmed.
- **Iter-150 docstring**: new "HYBRID-DEFERRED" block at L220–242 explaining the iter-150 pivot (descoping to upstream-Mathlib-PR work; the M2.a consumer reformulates over $\bar k$ via `IsAlgClosed.algebraMap_bijective_of_isIntegral` and bypasses this lemma).

### `\lean{Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange}` (canonical: \lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange, RigidityKbar.tex:2068–2091)

- **Lean target exists**: yes, `ChartAlgebraS3.lean:389` (declared in `_root_.Algebra.IsPurelyInseparable`).
- **Signature matches**: yes. `(k F : Type u) [Field k] [Field F] [Algebra k F] [FiniteDimensional k F] (h : (minimalPrimes (TensorProduct k (AlgebraicClosure k) F)).Subsingleton) : IsPurelyInseparable k F`. Blueprint prose ("$F \otimes_k \bar k$ has a unique minimal prime") matches `(minimalPrimes (... ⊗ ...)).Subsingleton`.
- **Proof follows sketch**: N/A — `sorry`. Blueprint proof body (RigidityKbar.tex:2076–2091) sketches Artinian + unique minimal prime ⇒ local ⇒ residue field $\bar k$ ⇒ Stacks 030K ⇒ purely inseparable. Lean body comment (L394–402) matches.
- **No `\leanok` desync**: statement and proof blocks both unmarked. Consistent.
- **Signature drift check**: no inflation attempted. Source matches iter-149 baseline.
- **Iter-150 docstring**: new "HYBRID-DEFERRED" block at L358–367 mirroring the (S3.pi.1) descope rationale (consumer reformulates over $\bar k$, descoping (S3.pi.\*) jointly).

## Unreferenced declarations (informational)

- `AlgebraicGeometry.gammaAlgebraMap` (L91–94) — helper, not blueprinted by `\lean{...}`. Mentioned in the pointer chapter's prose at L26–31 ("shared algebra-instance helper") without a `\lean{...}` block. Acceptable as project-private infrastructure.
- `AlgebraicGeometry.gammaAlgebra` (L99–103) — same status as above. Acceptable.
- **`Algebra.IsSeparable.of_finite_of_perfectField` (L435–443)** — NEW in iter-150 per the directive. One-liner: `Algebra.IsAlgebraic.isSeparable_of_perfectField`. Per the docstring block at L421–434, this is explicitly the "HYBRID part (B) CharZero collapse variant" of (S3.sep.2), intended for iter-151+ wiring into `constants_integral_over_base_field`. It is project-private infrastructure: not on any blueprint declaration's critical path, no Stacks Tag attached, and gated behind `[PerfectField k]` which the consumer does not yet carry. **Recommendation: acceptable as unblueprinted, BUT one-line acknowledgement in the pointer chapter would help future readers connect the iter-150 HYBRID part (B) work to a concrete project-side artefact.** See minor finding below.

## Red flags

### Placeholder / suspect bodies

None that are not blueprint-authorised. The four `sorry` bodies on the (S3.\*) lemmas are explicitly sanctioned by the canonical chapter ("All four declarations are present with their correct first-class signatures; bodies are structured `sorry`s with documented closure paths inline", pointer chapter L34–35), and the iter-150 plan explicitly DEFERS (S3.pi.\*) indefinitely and accepts iter-150 PARTIAL on (S3.sep.\*).

### Excuse-comments

None of the iter-150 docstring updates are excuse-comments. They are structured project-state documentation (iter-NNN status, consumer-compatibility blockers, M2.a-critical-path scheduling) — exactly the kind of documentation the workflow expects, NOT "we are using a wrong def for now" red flags.

### Axioms / `Classical.choice` on non-trivial claims

None. No `axiom` declarations in the file; no `Classical.choice _` patterns.

## Major findings (chapter side — blueprint adequacy)

### MAJOR-1 — Pointer-chapter stale Stacks Tags (directive-flagged, confirmed)

The pointer chapter `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` carries Stacks Tag references that the iter-150 render-fix writer round corrected on the canonical side (`RigidityKbar.tex`) but did NOT propagate to the pointer chapter:

| Pointer | tag cited | canonical chapter now uses | notes |
|--------|-----------|---------------------------|-------|
| L42 (S3.sep.1) | `0334 + 04QM` | `035U + 04QM + 030V` | `0334` is Nagata rings — wrong. `035U` is the "geometrically reduced schemes" section per `references/stacks-0334.md`. |
| L46 (S3.sep.2) | `0BJF` | `0BUG` part (4) | `0BJF` is discriminant ⇔ étale — wrong. `0BUG` is the actual "geom-reduced finite ⇒ separable" packaging per `references/stacks-0BJF.md` / `references/stacks-0BUG.md`. |
| L51 (S3.pi.2) | `05DH` | `030K` | `05DH` is universally injective — wrong. `030K` is the actual "finite extension is purely inseparable iff $F \otimes_k \bar k$ is local" lemma per `references/stacks-05DH.md`. |

`02KH` at pointer L48–49 (for S3.pi.1) is correct and unchanged across both chapters.

**Severity: major.** Incorrect literature citations in the chapter that a future reader (or formalizer) will consult when trying to close the (S3.\*) lemmas. The directive's iter-150 plan flagged this as still-wrong post the iter-150 render-fix writer — confirmed by direct comparison.

**Recommended chapter-side action**: dispatch a render-fix follow-up on the pointer chapter to apply the same three-tag substitutions that the canonical render-fix already performed. The corresponding `% NOTE iter-150 render-fix: corrected Stacks Tag from \`<old>\` to \`<new>\`` annotation blocks already in `RigidityKbar.tex` at L2002–2004, L2007–2010, L2030–2033, L2080–2083, and L2086–2089 are the model to copy.

### MAJOR-2 — Iter-150 HYBRID-DEFERRED disposition not reflected in either chapter

The Lean file carries clear, structured "HYBRID-DEFERRED" prose on (S3.pi.1) (L220–242) and (S3.pi.2) (L358–367), and "HYBRID part (B) attempted; consumer-blocked" prose on (S3.sep.1) (L148–179) and (S3.sep.2) (L306–323). The corresponding blueprint blocks contain **no acknowledgement of this disposition**:

- Pointer chapter (`AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` L37–53) lists "Iter-150+ closure strategy" as if (S3.pi.1) is the actively-scheduled path-(b) dominant cost — but per iter-150 plan, (S3.pi.1) and (S3.pi.2) are descoped to upstream-Mathlib-PR work in favour of the $\bar k$-collapse route.
- Canonical chapter `RigidityKbar.tex` has no `% NOTE: iter-150 HYBRID-deferred` on the (S3.pi.\*) blocks (L2037–2091).

A reader (or planner agent) consulting the blueprint without reading the Lean source would still believe (S3.pi.\*) is on the M2.a critical path. The Lean source has already been updated; the blueprint lags.

**Severity: major.** Blueprint adequacy failure of the "current state of play" variety — the chapter is no longer a faithful guide to the project's actual scheduling.

**Recommended chapter-side action**: a one-paragraph `% NOTE iter-150 HYBRID-pivot: (S3.pi.*) deferred indefinitely to upstream-Mathlib-PR work; M2.a consumer pivots to the IsAlgClosed.algebraMap_bijective_of_isIntegral route over `\bar k` once the user gate on adding [IsAlgClosed kbar] to rigidity_over_kbar closes YES. See AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean docstrings (L220-242, L358-367) and analogies/h1cotangent-vanishing-iter150.md § "Consumer reformulation over \bar k".` block, attached to both the (S3.pi.1) and (S3.pi.2) lemma blocks in `RigidityKbar.tex` (and mirrored in the pointer chapter's "Body status" paragraph at L33–37).

## Minor findings

### MINOR-1 — In-Lean docstring Stacks Tags also stale

The Lean source's file-header docstring (L1–80) and the (S3.\*) lemma docstrings still cite the pre-render-fix Stacks Tags:

| line | cited | should be (per render-fix) |
|------|-------|----------------------------|
| L32 (S3.sep.1 bullet) | `0334 + 04QM` | `035U + 04QM` |
| L39 (S3.sep.2 bullet) | `0BJF` | `0BUG` |
| L56 (S3.pi.2 bullet) | `05DH` | `030K` |
| L121–122 (S3.sep.1 docstring body) | `0334 + 04QM` | `035U + 04QM` |

**Severity: minor.** In-Lean documentation only; no compile or correctness impact, and the canonical blueprint already has the corrected tags. The Lean docstrings ought to be brought into alignment when an iter-151+ writer round touches this file for any reason, but it is not blocking.

### MINOR-2 — `Algebra.IsSeparable.of_finite_of_perfectField` helper unblueprinted

The new iter-150 helper (L435–443) is project-private infrastructure (one-liner via `Algebra.IsAlgebraic.isSeparable_of_perfectField`, gated behind `[PerfectField k]`, not on the M2.a critical path until iter-151+ wiring lands). Acceptable as unblueprinted, but mentioning it in the pointer chapter's "Iter-150 HYBRID part (B)" paragraph (alongside the proposed MAJOR-2 note) would help any future planner connect the helper to its iter-150 rationale.

**Severity: minor.** Recommendation: add a one-line bullet `\item \texttt{AlgebraicGeometry...IsSeparable.of\_finite\_of\_perfectField} — iter-150 HYBRID part (B) helper, gated behind \texttt{[PerfectField k]}; not on M2.a critical path; project-private; awaits iter-151+ wiring into \cref{lem:constants_integral_over_base_field}.` to the pointer chapter's helper list.

### MINOR-3 — (S3.pi.1) packaging via `Nonempty`

Already covered in the (S3.pi.1) per-declaration block above; flagged here for severity bookkeeping. The blueprint prose claims the canonical comparison map is iso; the Lean target asserts `Nonempty (...)`. The signature-note docstring on the Lean side acknowledges the packaging. Mathematical content matches.

**Severity: minor.**

## Blueprint adequacy for this file

- **Coverage**: 4/4 substantive `\lean{...}` blocks for the (S3.\*) lemmas exist in the canonical chapter; the pointer chapter enumerates the four lemma names (without `\lean{...}` blocks of its own). 3 unreferenced Lean declarations: `gammaAlgebraMap` + `gammaAlgebra` (acceptable, mentioned in pointer-chapter prose) + new `Algebra.IsSeparable.of_finite_of_perfectField` (acceptable, with MINOR-2 recommendation).
- **Proof-sketch depth**: **adequate** on the canonical chapter side. Each of the four canonical proof blocks gives an explicit closure path with named Mathlib lemmas / Stacks tags. The Lean body's in-source comment plans faithfully formalise these sketches step-for-step. No proof-sketch under-specification detected.
- **Hint precision**: **precise**. The four `\lean{...}` hints pin exactly the correct Mathlib predicates (`Algebra.IsGeometricallyReduced k _`, `Algebra.IsSeparable k _`, `IsPurelyInseparable k _`, the `TensorProduct k _ K ≃ₐ[K] _` packaging). No "loose" hints.
- **Generality**: matches need. No parallel API was written to compensate for blueprint narrowness.
- **Pointer-chapter status**: thin redirector (low information density), redirects to canonical chapter `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition". **This is the right cross-reference target** per directive convention. The pointer chapter's intrinsic content (helper enumeration + body-status paragraph) is correct as a high-level summary, but is stale on (a) iter-150 HYBRID-pivot disposition (MAJOR-2) and (b) three Stacks Tag citations (MAJOR-1).
- **Recommended chapter-side actions**:
  1. **MAJOR-1 fix** — apply the iter-150 render-fix's three Stacks-tag corrections to the pointer chapter (lines 42, 46, 51), with matching `% NOTE iter-150 render-fix: ...` annotation blocks.
  2. **MAJOR-2 fix** — add a `% NOTE iter-150 HYBRID-pivot: ...` block to the (S3.pi.1) and (S3.pi.2) lemma blocks in `RigidityKbar.tex`, mirroring it in the pointer chapter's "Body status" paragraph at L33–37; the chapter should record that (S3.pi.\*) are deferred indefinitely as upstream-Mathlib-PR work pending the user gate on adding `[IsAlgClosed kbar]` to `rigidity_over_kbar`.
  3. **MINOR-2 fix** — add a one-bullet acknowledgement of the new `Algebra.IsSeparable.of_finite_of_perfectField` helper to the pointer chapter's helper list, tied to the MAJOR-2 HYBRID-pivot context.

## Severity summary

- **must-fix-this-iter**: none. The four `sorry` bodies are blueprint-authorised, no signature mismatch with prose, no excuse-comments, no axioms, no weakened-wrong definitions. Iter-150 signature-inflation revert landed cleanly. The pointer chapter is a thin redirector and the canonical chapter has precise hints and adequate proof sketches.
- **major**: two findings, both blueprint-side adequacy.
  - MAJOR-1: pointer-chapter stale Stacks Tags at L42 (0334 → should be 035U), L46 (0BJF → should be 0BUG), L51 (05DH → should be 030K). Confirmed per directive's iter-150 plan flag.
  - MAJOR-2: iter-150 HYBRID-DEFERRED disposition on (S3.pi.\*) and HYBRID-attempted-blocked on (S3.sep.\*) not reflected in either the pointer chapter or `RigidityKbar.tex`; a reader of the blueprint alone would not know that (S3.pi.\*) is descoped to upstream-Mathlib-PR work.
- **minor**: three findings.
  - MINOR-1: in-Lean docstring Stacks Tags at L32/L39/L56/L121–122 still cite the pre-render-fix tags.
  - MINOR-2: new `Algebra.IsSeparable.of_finite_of_perfectField` helper unblueprinted; one-line pointer-chapter bullet recommended.
  - MINOR-3: (S3.pi.1) Lean target uses `Nonempty (... ≃ₐ[K] ...)` packaging while blueprint prose claims the canonical map is iso. Acknowledged in source by a "Signature note" docstring block.

## Overall verdict

The four (S3.\*) Lean signatures match the canonical `RigidityKbar.tex` `\lean{...}` blocks cleanly with no iter-150 signature-inflation residue; the sorries are blueprint-authorised; the new helper `Algebra.IsSeparable.of_finite_of_perfectField` is acceptable project-private iter-150 HYBRID part (B) infrastructure. The non-trivial findings are entirely on the blueprint side: the pointer chapter still cites three pre-render-fix Stacks Tags that the iter-150 render-fix writer corrected only on the canonical chapter, and neither chapter records the iter-150 HYBRID-DEFERRED disposition on (S3.pi.\*); both are major blueprint adequacy issues but not must-fix-this-iter.

— 4 declarations checked, 2 major + 3 minor red flags
