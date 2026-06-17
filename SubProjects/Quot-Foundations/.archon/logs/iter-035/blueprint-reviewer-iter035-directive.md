# Blueprint Reviewer — iter-035 (whole-blueprint HARD GATE)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) as you always do — the cross-chapter view is
the point. Produce your standard per-chapter completeness + correctness checklist and the
unstarted-phase proposals section.

## Why now

Three chapters were edited this iteration and feed the prover lanes proposed for dispatch. Apply the
HARD-GATE verdict (complete + correct + no must-fix) with particular care to the blocks that a prover
will directly formalize this iter:

1. **`Cohomology_FlatBaseChange.tex`** — an effort-breaker atomized the leg-reindex coherence
   `lem:base_change_mate_fstar_reindex_legs` into a `\uses`-linked conjugate-side chain:
   `base_change_mate_codomain_read_legs_conj` (def), `…_conj_eq`, `…_reindex_conj_pullbackLeg`,
   `…_reindex_conj_pushforwardCollapse`, `…_reindex_conj_crossLayer`, `…_fstar_reindex_legs_conj`, plus
   the target's rewritten thin-wrapper proof and two Mathlib anchors (`lem:conjugateEquiv_comp_mathlib`,
   `lem:conjugateEquiv_symm_comp_mathlib`). **This is the high-stakes edit** — a prover formalizes this
   chain. Check: is each sub-lemma a single well-formed mathematical claim with an informal proof a
   prover can follow? Are the `\uses{}` edges accurate (do the cited dependencies actually supply what
   each step needs)? Is the chain's composition sound (do conj-2b/2c/2d + conj-1a/1b genuinely combine
   to give the target)? A coverage writer also added an FBC-B globalization subsection (`def:fbcb_*` /
   `lem:fbcb_*`) and two conj-0 blocks — these back already-landed Lean, lower stakes.

2. **`Picard_QuotScheme.tex`** — the gap1 keystone D `lem:section_localization_descent`
   (`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent`, the decl does NOT yet exist —
   a prover BUILDS it this iter) is sourced to Stacks `lemma-invert-f-sections` / Hartshorne II.5.3. Check
   its statement is faithful to the source, its proof sketch (finite sheaf equalizer over the basic-open
   cover + flatness of localization) is detailed enough to formalize, and its `\uses{}` are satisfiable.
   Six coverage blocks for `Scheme.Modules` presentation/pullback infra were added (back already-landed
   Lean). Note the cosmetic Stacks-tag inconsistency on the DOWNSTREAM block
   `lem:qcoh_section_localization_basicOpen` (cites "01HA" while the keystone D cites
   `lemma-invert-f-sections` — same source lines L2152–2170); flag if you consider it must-fix, else minor.

3. **`Picard_GrassmannianCells.tex`** — the properness keystone `lem:gr_proper`
   (`AlgebraicGeometry.Grassmannian.isProper`, decl does NOT yet exist — a prover BUILDS it this iter) is
   sourced to Nitsure §1 "Properness" (valuative criterion). Check the proof sketch is detailed enough to
   formalize (valuative criterion: separated DONE; the existence part — selecting which chart the
   valuation's closed point lands in — is the real content; qcqs side conditions). Six separatedness
   coverage blocks were added (back already-landed Lean).

## What I will do with your verdict

For each of the three chapters: if your verdict is complete + correct with no must-fix touching it, the
corresponding file enters this iter's prover objectives. If a chapter is partial/false on either axis or
carries a must-fix, that file is dropped this iter and a blueprint-writer is dispatched against your
specific findings. Be precise about which blocks (by `\label`) are inadequate so I can target a writer.
