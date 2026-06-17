# Blueprint Reviewer iter191 directive

## Mandate

Whole-blueprint audit. Per-chapter checklist of completeness +
correctness. Critical pushback on overconfident proof sketches.

Read every file in `blueprint/src/chapters/`. Use the
`% archon:covers` declarations near each chapter top to determine
which Lean files each chapter blueprints (the consolidated mapping
takes precedence over the 1:1 slug). For each chapter return:
- `complete: true | partial | false` — whether every declaration the
  Lean file requires is present in the chapter.
- `correct: true | partial | false` — whether the proof sketches are
  mathematically sound and detailed enough to formalize.
- `must-fix-this-iter` findings: items that block prover dispatch on
  the chapter's Lean files THIS iter.

The HARD GATE the plan agent applies: a chapter with
`complete: true ∧ correct: true ∧ no must-fix` is cleared for
downstream prover work. Anything else gates the corresponding
files.

## Iter-190 plan-phase + prover-phase landings to verify

Confirm these landings are reflected correctly in the chapters
(and find anything broken):

1. **`RiemannRoch_H1Vanishing.tex`** — NEW chapter (560 lines)
   landed iter-190 plan-phase via writer
   `rr-h1vanishing-skeleton`. Contains 8 `\lean{...}` pins for
   the flasque-resolution substrate (Hartshorne III.1-2 + II.1)
   + the 6 SOURCE QUOTE blocks. Verify completeness +
   correctness; verify the `\label{chap:RR_H1Vanishing}` resolves
   the prior broken cref from `RRFormula.tex`. Note: the Lean
   file `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` does NOT
   yet exist (blueprint-doctor iter-190 flagged the
   `% archon:covers` line). This iter-191 we plan a file-skeleton
   prover dispatch to scaffold it.

2. **`RiemannRoch_WeilDivisor.tex` §6 Positive part** — added
   iter-190 plan-phase. Two blocks:
   - `def:WeilDivisor_positivePart` (~5 LOC; `D ⊔ 0` lattice
     form).
   - `lem:degree_positivePart_principal_eq_finrank`
     (Hartshorne II.6.9 specialised to `D = [∞]`).
   Verify: iter-190 prover landed the public Lean def as
   `Finsupp.mapRange (fun n : ℤ => n ⊔ 0)` (NOT the
   `D ⊔ 0` lattice form per chapter). The chapter prose says
   "lattice form `D ⊔ 0`" but the Lean uses `mapRange`. These
   are mathematically equal but the prover-task-result flagged a
   blueprint↔Lean mismatch. Should the chapter be updated to
   reflect the `mapRange` form, or is the lattice-form prose still
   correct as an abstract mathematical description?
   ALSO: the Lean `degree_positivePart_principal_eq_finrank`
   pin landed in **existential form** for soundness
   (`∃ t halg, ...`) instead of the chapter's equational phrasing.
   Flag as a must-fix mismatch — either the chapter or the Lean
   needs to align.

3. **`Picard_QuotScheme.tex` iter-189 unbundle pins** — added
   iter-190 plan-phase:
   - `lem:tildeIso_of_isQuasicoherent_isAffineOpen` (Stacks 01I8).
   - `lem:pullback_of_openImmersion_iso_restrict` (Stacks 01HH-style
     transport).
   Verify content + verify the iter-190 prover output (PARTIAL on
   `pullback_of_openImmersion_iso_restrict` — AddEquiv chain closed,
   ring-identity + restrictScalars-unfold residual) is consistent
   with the chapter's pin signatures.

4. **`RiemannRoch_RationalCurveIso.tex` iter-190 Pin 2 corrective**
   — added iter-190 plan-phase: NOTE block recording the
   structural-conflict diagnosis (theorem false-as-stated under
   iter-187 body of `Hom.poleDivisor` because principal divisor has
   degree 0 on a complete nonsingular curve) and the Pin 2
   corrective Option (a) (refactor `Hom.poleDivisor` to use
   `positivePart`). Verify the NOTE is up-to-date with what iter-190
   prover actually landed (`Hom.poleDivisor` body refactored;
   `Hom.poleDivisor_degree_eq_finrank` body closes via the new
   file-local typed-sorry pin `degree_positivePart_principal_localParameterAtInfty_eq_finrank`).

## Unstarted-phase chapters

Per the strategy:
- A.3.iii–vi `Pic⁰_{C/k}` AV wrap (tangent iso, smoothness,
  properness, geom-irreducibility) — slated for a new
  `Picard_Pic0AbelianVariety.tex`. iter-191 plan-phase will dispatch
  the blueprint-writer if HIGH priority.
- A.4.d divisor-map Albanese UP — `Albanese_AlbaneseUP.tex` exists
  but carries the old Sym^g content (pre-pivot). Rewrite deferred
  iter-191+ plan-phase.

Surface any unstarted-phase chapters that have become BLOCKING for
active prover work this iter; surface any chapter outline you
recommend the blueprint-writer use for them.

## Files currently in iter-191 prover objectives (to gate)

These are the chapters the HARD GATE must clear for iter-191 prover
dispatch:

- `RiemannRoch_RationalCurveIso.tex` (Lane I corrective-fix + Pin 3
  Step 2 continued)
- `RiemannRoch_WeilDivisor.tex` (Lane I positivePart body owed)
- `Albanese_AuslanderBuchsbaum.tex` (Lane G continued)
- `Picard_QuotScheme.tex` (Lane F Step 3 residual close)
- `Genus0BaseObjects_Cross01Substrate.tex` + Genus0BaseObjects_*.tex
  cluster (Lane B consumers in `GmScaling.lean`)
- `AbelianVarietyRigidity.tex` (Lane E continued)
- `RiemannRoch_H1Vanishing.tex` (file-skeleton scaffold for new
  H1Vanishing.lean)
- (gated; iter-191 not dispatched but stating intent for next)
  `Albanese_CodimOneExtension.tex` (Lane M↓ Option (a) Stacks 00TT
  scaffolding pipeline)

Return your verdict per chapter. The plan agent reads the per-
chapter checklist and uses it to gate prover work this iter.
