# Blueprint review — iter-047 (whole blueprint)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). Standard per-chapter
completeness + correctness checklist + your unstarted-phase proposals.

## This iter's HARD-GATE focus (verdict gates prover dispatch THIS iter)
Two chapters were (re)written iter-046 and need a fresh complete+correct verdict before
provers run on their Lean files this iter:

1. **`Picard_FlatteningStratification.tex`** — GF G1 finite-type base case, effort-broken into
   3 seams: `lem:gf_finiteType_affine_finite_cover_generated` (cover extraction),
   `lem:gf_affine_qcoh_Gamma_epi` (Γ-epi descent via gap1/gap2 exact-functor transport — NOT
   stalkwise), `lem:gf_qcoh_finite_sections_globally_generated` (free-surjection assembly),
   plus `lem:gf_qcoh_fintype_finite_sections` (G1 assembly) and helper coverage-debt blocks.
   Verify: each seam has a complete informal proof, correct math (the Γ-epi descent must NOT
   rely on a false bare stalkwise-epi⟹global-epi step — it routes through affine-qcoh
   exactness of Γ / Stacks 01PB), and accurate `\uses{}`. Are the Lean targets well-formed
   (faithful signatures: qcoh + finite-type hypotheses present)?

2. **`Picard_SectionGradedRing.tex`** — SNAP section-graded-ring infra (3 layers: sheaf tensor
   powers → lax-monoidal Γ → DirectSum graded assembly; `\mathlibok` anchors). Verify the
   layer decomposition is complete enough to scaffold a Lean file, the `\mathlibok` anchors
   name real Mathlib decls, and the frontier node `def:sheafTensorObj` is buildable.

## Also verify (corrected iter-047)
3. **`Picard_QuotScheme.tex`** `lem:modules_annihilator_ideal` + new `lem:annihilator_map_basicOpen`:
   I rewrote the statement to GLOBAL finiteness `∀ V, Module.Finite Γ(X,V) Γ(F,V)` and the proof
   to the `ofIdeals_ideal` assembly argument (removed the false "section = infimum of comaps");
   added a dedicated `lem:annihilator_map_basicOpen` block. Confirm these now match the Lean.

Report per-chapter `complete: true|partial|false`, `correct: true|partial|false`, must-fix-this-iter
items, and unstarted-phase proposals. Whole-blueprint view required — do not scope-limit.
