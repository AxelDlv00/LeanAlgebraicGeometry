# Blueprint review — iter-015 (whole blueprint)

Audit the WHOLE blueprint under `blueprint/src/chapters/`. Produce your standard per-chapter
checklist (complete? correct? Lean targets well-formulated? proofs detailed enough to formalize?)
plus the unstarted-phase proposals section.

## Context (what changed since your last full pass at iter-012)

- **iter-013** wired all 44 prover-generated helpers into the blueprint (1-to-1 Lean↔tex was complete).
- **iter-014** prover round closed two targets and added a new subsection:
  - FBC `lem:base_change_mate_unit_value` (Seam 1) CLOSED.
  - GF `lem:gf_torsion_reindex` CLOSED, introducing 5 new `AlgebraicGeometry.GenericFreeness.*`
    transport helpers (NOT yet blueprinted — coverage debt this iter is clearing).
  - QUOT: a new subsection `subsec:gradedModuleApi` (Picard_QuotScheme.tex line ~753) was authored by
    a blueprint-writer + blueprint-clean pass. **This subsection has NOT been through a
    blueprint-review yet — give it close scrutiny.** It contains 6 Mathlib dependency anchors
    (`\mathlibok`) and the project blocks G1–G5 + D5 (`AlgebraicGeometry.GradedModule.*`), all
    `\uses`-linked into `lem:gradedHilbertSerre_rational`.

## Live prover lanes this iter (your verdict GATES each)

The plan intends to dispatch provers on these files THIS iter; your per-chapter verdict is the hard
gate for each:

1. **Picard_QuotScheme.tex** (`subsec:gradedModuleApi`) — backs `Picard/QuotScheme.lean`, a
   `mathlib-build` lane on the G1→G2→G5→G3→G4 building blocks. Confirm: are the G1–G5/D5 statements
   precise enough to formalize? Are the `\lean{}` pins to `AlgebraicGeometry.GradedModule.*`
   (decls that DO NOT yet exist — this is a build/scaffold lane) well-formed? Is the
   `[Module.Finite κ (𝒜 1)]` / degree-1-generation hypothesis question (chapter line ~432 NOTE)
   resolved or does it block the assembly `lem:gradedHilbertSerre_rational`?
2. **Cohomology_FlatBaseChange.tex** — backs `FlatBaseChange.lean`, the FBC Seam 2/3 cascade. Confirm
   `lem:base_change_mate_fstar_reindex` and `…_gstar_transpose` proof sketches are detailed enough.
3. **Picard_FlatteningStratification.tex** — backs `FlatteningStratification.lean`, the GF L5
   `lem:gf_polynomial_core` lane. A blueprint-writer + blueprint-clean round LANDED THIS ITER: it
   expanded the `lem:gf_torsion_reindex` proof with a "Localisation transport" sub-step and added 3
   new helper lemma blocks (`lem:gf_pullback_module_transport`, `lem:gf_finite_of_quotient_ringequiv`,
   `lem:gf_islocalizedmodule_restrictscalars`; 5 `\lean{}` pins to `AlgebraicGeometry.GenericFreeness.*`).
   Confirm: are the new helper blocks well-formed (statements, pins, `\uses`)? Is the L5
   `lem:gf_polynomial_core` 5-step proof sketch detailed enough to formalize the assembly?

## Output

Your standard report: per-chapter complete/correct verdicts, must-fix-this-iter items, and the
unstarted-phase proposals. Be explicit about whether each of the three gated chapters above is
`complete: true / correct: true` so the planner can apply the HARD GATE.
