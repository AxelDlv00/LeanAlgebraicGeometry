# Blueprint-reviewer directive — iter-004 whole-blueprint audit

Audit the WHOLE blueprint at `blueprint/src/` (all chapters `\input` from
`content.tex` / `web.tex`). Produce your standard per-chapter checklist with a
`complete: true|partial|false` and `correct: true|partial|false` verdict for each
chapter, plus the flagged-issues block and any unstarted-phase proposals.

## What changed this iteration (pay attention, but audit everything)

Two chapters were edited by write-capable subagents this iter and then cleaned;
they gate the two active prover lanes, so their verdicts decide the HARD GATE:

1. `Cohomology_FlatBaseChange.tex` — the crux leaf
   `lem:base_change_mate_generator_trace` was effort-broken into a 3-sub-lemma
   `\uses`-chain: `lem:base_change_mate_regroupEquiv` (pure-tensor-algebra bundled
   `R'`-linear iso `(R'⊗_R A)⊗_A M ≅ R'⊗_R M` via `cancelBaseChange` + heterobasic
   `comm`), `lem:base_change_mate_generator_trace_eq` (the conjugate equals
   `regroup⁻¹` — the adjoint-mate generator trace), and the `IsIso` corollary leaf
   (unchanged pin). Also: two thin infrastructure-helper blocks were added
   (`lem:pullbackIsoEquivalenceOfIso`, `lem:pullback_isEquivalence_of_iso`) to
   clear 1-to-1 coverage debt for two already-proved Lean helpers.

2. `Picard_FlatteningStratification.tex` — L4
   `lem:gf_noether_clear_denominators` was re-encoded to an explicit-AlgHom target
   (now carries a `% LEAN SIGNATURE` block); `lem:gf_free_moduleFinite` prose was
   corrected to its true hypotheses; and L3 `lem:gf_splice_shortExact` was
   effort-broken into three sub-lemmas (`…_localized_exact`, `…_free_transport`,
   `…_split`) under a parent assembly.

## Specific questions to answer in your verdict

- Are the two new FBC sub-lemma chains (regroup-equiv / generator-trace-eq /
  IsIso corollary) mathematically sound and detailed enough for a prover to
  formalize each piece independently? Is the parent assembly still correct?
- Is the GF L3 3-sub-lemma decomposition + assembly sound and faithful to the
  Nitsure §4 splicing fact? Is the verbatim source quote correctly carried?
- Is the re-encoded L4 AlgHom target faithful to the Nitsure §4 Noether-with-
  denominators step, and is the `% LEAN SIGNATURE` block adequate to guide the
  prover's re-sign?
- Do the two thin FBC helper blocks have enough to formalize (they are already
  proved in Lean; this is just coverage)?
- For each chapter under active prover work (the two above), state explicitly
  whether it clears `complete: true` AND `correct: true` with no must-fix-this-iter
  finding — that is the gate the plan agent checks before dispatching provers.

Report any must-fix-this-iter findings precisely (chapter + block + the fix).
Do NOT propose `\leanok` edits (sync owns it).
