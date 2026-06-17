# Strategy critique — iter-081

Fresh-eyes critique of the global strategy. Read ONLY these inputs:
- `STRATEGY.md` (verbatim — the current arc).
- `references/summary.md` (the reference index).
- The blueprint chapter titles below (topic-per-chapter, for landscape only — do NOT audit math here):
  - Cohomology_FlatBaseChange — Flat base change for the pushforward of a qc sheaf (i=0)
  - Cohomology_RegroupHelper — Regrouping iso for the affine base-change tensor tower
  - Picard_FlatteningStratification — Flattening stratification of a coherent sheaf (generic flatness)
  - Picard_GlueDescent — Effective descent: restriction of the glued sheaf to a chart
  - Picard_GrassmannianCells — The Grassmannian over ℤ (charts/cocycle/glue/proper)
  - Picard_GrassmannianQuot — Tautological quotient + universal property of Gr
  - Picard_QuotScheme — The Quot scheme (Hilbert poly, Quot functor, representability)
  - Picard_RelativeSpec — Relative Spec
  - Picard_SectionGradedRing — Section graded ring infra: tensor powers + graded sections

Do NOT read iter sidecars, task_pending/done, prover task results, review reports, or PROGRESS.md.

## Project goal (one paragraph)
Close the sorry-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman, "The Picard scheme", FGA §4): flat base change for
i=0 pushforward (FBC), generic flatness (GF, done), and the Quot/Grassmannian foundations (QUOT) —
Hilbert polynomial, Quot functor, Grassmannian scheme, and its representability. End-state: zero
project sorry + kernel-only axioms, with names/labels matching the parent so the work merges back.

## What changed since you last ran (iter-079)
Only a status-cell refresh of the SNAP row (the `sectionsMul_assoc_unit` design was corrected — it is
4 cast-mediated component equalities, not one declaration; assembly infra now lives in
SectionGradedRing.lean). No route swap, no phase add/remove. The FBC route swap (mate keystone →
DIRECT H⁰-equalizer, Q2) was adopted and resolved iter-079.

## Focus questions
- Is FBC-B DIRECT (Stacks 02KH.2 finite-equalizer route) still the right primary route to the two named
  goal legs, given the module core is done 0-sorry and the only remaining step is the per-chart 01I9
  identification + assembly? Is abandoning the mate keystone sound?
- Are the four ACTIVE rows (FBC-B, GR-quot endgame, SNAP assembly) ordered/scoped sensibly, or is any a
  disguised dead end?
- Open Q1 (SNAP H⁰ `Φ_s` vs χ) and Q3/Q4 (standard-graded fence, RelativeSpec tag pin) — any unsound
  assumption that would burn budget?
