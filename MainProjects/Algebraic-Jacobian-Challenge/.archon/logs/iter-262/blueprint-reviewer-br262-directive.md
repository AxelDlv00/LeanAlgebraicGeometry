# blueprint-reviewer br262 — directive

Whole-blueprint audit (all chapters under `blueprint/src/chapters/`). Standard
per-chapter checklist: complete? correct? Lean targets well-formed? proofs
detailed enough to formalize? Plus your `## Unstarted-phase blueprint proposals`.

This is the mandatory whole-blueprint pass. Do not scope-limit — the cross-chapter
view is the point.

## Active prover focus this iter (gate these especially)

Two files are about to receive prover work, both backed by the consolidated
chapter `Picard_TensorObjSubstrate.tex` (it carries an `% archon:covers` line for
`Picard/TensorObjSubstrate.lean` and `Picard/TensorObjSubstrate/DualInverse.lean`):
1. `Picard/TensorObjSubstrate/DualInverse.lean` — the dual `sliceDualTransport` /
   `dual_restrict_iso` route-2 build.
2. `Picard/TensorObjSubstrate.lean` — D3′ `pullbackTensorMap_restrict` and its Sq1
   sub-lemma `sheafificationCompPullback_comp`.

A blueprint-writer will edit `Picard_TensorObjSubstrate.tex` THIS iter to repair
known drift (the chapter describes `sliceDualTransport` as leg-A-only via
eqToHom-conjugation, but the Lean packages leg A∘B via categorical `.map`; the
`\lean{sliceDualTransport}` tag is missing; the leg-B frictions and the
Sq1 4-term signature / square-interleaving are undocumented). Judge the chapter as
it stands now; I will re-dispatch you scoped to this chapter after the writer for
the fast-path gate clearance.

The engine chapter `Cohomology_CechHigherDirectImage.tex` now has its Lean file
scaffolded (6 decls, builds green) — confirm the chapter is complete+correct for a
prover lane to open on it.

Report HARD-GATE status per chapter, your unstarted-phase proposals, and any
must-fix-this-iter findings.
