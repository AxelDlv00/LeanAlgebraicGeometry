# Blueprint Review Report

## Slug
iter153

## Iteration
153

## Top-level summaries

### Citation discipline
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` / `(S3.sep.1)` vs
  `RigidityKbar.tex` / `lem:S3_sep_1_smooth_geometrically_reduced_Gamma`:
  **cross-chapter tag drift** for the "smooth ⇒ Γ geometrically reduced"
  fact. `RigidityKbar.tex` cites Stacks **04QM** (visible `\textit{Source:
  Stacks Tags 035U ... and 04QM}`, L2059), whereas `ChartAlgebraS3.tex`'s
  Source-citations section cites Stacks **056T** (Lemma 33.25.4; visible
  `\textit{Source: Stacks Tags 035U and 056T}`, L159) for the same claim.
  Additionally `ChartAlgebraS3.tex`'s own iter-151 render-fix `% NOTE`
  (L84) states it is "retaining `04QM`", contradicting the 056T actually
  used in the body below it. Both 04QM and 056T are legitimate Stacks tags
  for smooth-over-a-field ⇒ geometrically reduced (not a fabrication), and
  both blocks are the **DESCOPED, off-critical-path** (S3.*) general-over-k
  lemmas — so this does **not** block any active prover route. SOON, not
  must-fix. Recommend the writer pick one tag and align both chapters +
  the stale NOTE.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter for `GrpObj.lean`; defers math content to `RigidityKbar.tex` § Piece (i). `\cref` targets resolve.)

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The β-core consumer's load-bearing target `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` (L525) exists, is `\leanok`, and its statement (exactness of the 2-affine-cover MV sequence for a sheaf of k-modules `𝓕`) is exactly the H⁰-row identification the chart-algebra (β-core) Step 3 invokes. Cross-ref from `RigidityKbar.tex` is sound.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
(The "mathematically false converse" prose at L161 is the intended, correctly-scoped M4 out-of-scope documentation, with an explicit counterexample — not a defect.)

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - over-k → alg-closed + descent reconciliation reads coherently: `thm:nonempty_jacobianWitness` (C.2.f, L420–426) and `def:genusZeroWitness` (L480) both route genus-0 rigidity through `thm:rigidity_over_kbar` over `k̄` and descend via `AlgebraicGeometry.Flat.epi_of_flat_of_surjective` (right-cancel the faithfully-flat surjective epi `p : C_{k̄} → C`). The `C(k)=∅` Brauer–Severi vacuity branch is handled at the Lean type level. Consistent across C.2, ($γ$), and Layer I.
  - Route A coverage PRESENT and adequate (see Multi-route below).
  - All theorem blocks well-cited (Kleiman, with verbatim `% SOURCE QUOTE`); cited file `references/kleiman-picard-src/kleiman-picard.tex` exists on disk.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Internally coherent as a DESCOPED off-critical-path pointer chapter; all four (S3.*) `\cref` targets resolve to real `RigidityKbar.tex` labels; verbatim `% SOURCE QUOTE` blocks are well-formed and the cited files (`stacks-varieties.tex`, `stacks-coherent.tex`, `stacks-fields.tex`) exist.
  - Carries the cross-chapter tag-drift / internal-NOTE inconsistency flagged under Citation discipline (SOON, off-path).

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD-GATE FOCUS — chart-algebra piece (ii) declarations all confirmed complete + correct, alg-closed hypotheses present on BOTH sides:**
    - `lem:constants_integral_over_base_field` (the active prover target this iter): statement carries `[IsAlgClosed k]` (L2278); 3-step proof (integral ⇒ Γ field; finite over k; `IsAlgClosed.algebraMap_bijective_of_isIntegral`) matches the directive's described collapse exactly; each step cites a [verified] Mathlib lemma. Lean signature verified: `ChartAlgebra.lean:469` carries `[Field k] [IsAlgClosed k]`. Pruned `\uses{lem:S3_*}` correctly (no broken refs).
    - `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (KDM): statement now carries `[IsAlgClosed k] [CharZero k] [IsDomain B]` (L2358); the now-TRUE field-of-fractions argument (FT.1–FT.3) is mathematically sound (k alg-closed in Frac(B); ker d_{K/k}=k for separable K/k). The two iter-151 counterexamples (k×k, ℚ(√2)/ℚ) are documented and each killed by one of the joint hypotheses. Residual content (FT.3 separable-extension kernel fact) honestly named with a concrete assembly path. Lean signature verified: `ChartAlgebra.lean:257–258` carries `[Field k] [IsAlgClosed k] [CharZero k]` + `[IsDomain B]`.
    - `lem:chart_algebra_df_zero_factors_through_constant_on_chart`, `lem:chart_algebra_isPushout_of_affine_product`, `lem:Scheme_Over_ext_of_diff_zero`: statements + 5-step / 3-step sketches detailed; alg-closed propagation documented; cross-refs resolve.
  - Citation discipline on chart-algebra blocks is solid: KDM carries verbatim `% SOURCE QUOTE` for Stacks 00T7; (S3.*) blocks carry verbatim quotes for 035U/04QM/0BUG/02KH/030K/09HD; all cited `references/*.tex` files exist.
  - Piece (i) (i.b base-change-of-differentials chain, L508–1843) carries `\notready` markers on several proof blocks — these are Lean-formalization-status markers (piece (i) is the still-open cotangent-triviality pile, NOT the active route), not blueprint-prose gaps; the sketches themselves are extremely detailed. Marker maintenance is owned by review/`sync_leanok`, not a reviewer finding (cf. directive Known issues).

## Cross-chapter notes

- `RigidityKbar.tex` (`lem:S3_sep_1`, Tag 04QM) vs `ChartAlgebraS3.tex` ((S3.sep.1), Tag 056T): same smooth ⇒ geometrically-reduced fact cited under two different (both valid) Stacks tags; see Citation discipline. Off-path, SOON.
- Broken-cross-reference sweep across all 12 chapters: CLEAN. The only `\uses`/`\cref`/`\ref` tokens without a matching `\label` (`ex:jac`, `rmk:Ablsch`, `cohomology-lemma-base-change-map-flat-case`, `lem:S3_*`) are all inside verbatim `% SOURCE QUOTE` text or `%`-comments, not live blueprint refs. The dependency graph is intact.

## Multi-route coverage

- **Route C (M2 critical path) — chart-algebra piece (ii) over `[IsAlgClosed kbar]`**: PASS. Covered in `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition" (L1844–2515). All five declaration blocks present, alg-closed hypotheses on statements + Lean signatures, sketches prover-ready. The active target `constants_integral_over_base_field` is `complete: true / correct: true`.
- **Route A (M3 off-critical-path) — Picard scheme via FGA**: PASS (coverage check only). Covered in `Jacobian.tex` § Route A (`thm:nonempty_jacobianWitness`, sub-steps A.1–A.4, L321–350) with per-sub-step Mathlib-gap inventory, and packaged as `def:positiveGenusWitness` (L492–520). References `kleiman-picard.md`/`.tex` and `nitsure-hilbert-quot.md` back it; both files exist on disk. No prover work required this iter.

## Severity summary

Severity summary: **HARD GATE CLEARS** — no must-fix-this-iter findings.

- **must-fix-this-iter**: none. Every chapter is `complete: true / correct: true`; no MISSING route; no broken `\uses`; no citation-discipline finding on a block feeding the active prover route (`constants_integral_over_base_field` is Archon-assembled from named [verified] Mathlib lemmas, not a source translation, so it correctly omits `% SOURCE QUOTE`).
- **soon**: cross-chapter Stacks-tag drift (04QM vs 056T) for the DESCOPED off-path (S3.sep.1) lemma, plus the contradictory iter-151 `% NOTE` in `ChartAlgebraS3.tex`. Resolve by aligning both chapters on one tag; does not block any prover.
- **informational**: piece (i) `\notready` markers reflect open Lean formalization of the off-route cotangent-triviality pile, managed by review/`sync_leanok`.

Overall verdict: The iter-152 `[IsAlgClosed]` pivot is faithfully reflected in `RigidityKbar.tex` — the chart-algebra piece (ii) declarations (notably the active target `constants_integral_over_base_field` and the now-TRUE KDM) carry the alg-closed hypotheses on both blueprint and Lean sides with sound, prover-ready sketches — so the HARD GATE for dispatching a prover on `Cotangent/ChartAlgebra.lean` against `RigidityKbar.tex` CLEARS.
