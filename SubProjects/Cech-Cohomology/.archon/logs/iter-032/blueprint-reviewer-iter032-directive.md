# Blueprint-reviewer directive — iter-032

Whole-blueprint audit (all chapters under `blueprint/src/chapters/`). Per-chapter completeness +
correctness checklist + the HARD GATE verdict the planner uses to decide prover dispatch.

This iter the consolidated chapter `Cohomology_CechHigherDirectImage.tex` received targeted edits:
- **P1 decomposition:** `lem:qcoh_localized_sections` proof/`\uses` rewritten to consume two NEW sub-lemmas
  `lem:isQuasicoherent_restrict_basicOpen` (P1a, blueprint-only/project-to-build) and
  `lem:isLocalizedModule_of_span_cover` (P1b, pure algebra, dispatch-ready).
- **`lem:tilde_preserves_kernels`:** informal proof added (was a leandag ∞-source).
- **Coverage debt:** 9 CechBridge `…Fam` helpers bundled into existing `\lean{}` lists.

Focus the gate on the files about to receive provers THIS iter:
1. **`AffineSerreVanishing.lean`** — the cover-system chain (`standard_cover_cofinal`,
   `toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing`, `affineCoverSystem`, discharging
   `injective_acyclic` via the family form `injective_cech_acyclic`). Confirm the relevant blocks
   (`lem:standard_cover_cofinal`, `lem:to_sheaf_preserves_epi`, `lem:affine_surj_of_vanishing`,
   `def:affine_cover_system`, `def:basis_cov_system`, `lem:affine_faces_mem`, `lem:cover_datum_bridge`) are
   FORMALIZE-READY (statements precise, `\uses` acyclic, proofs detailed enough).
2. **`QcohTildeSections.lean`** — specifically **P1b `lem:isLocalizedModule_of_span_cover`**: is the pinned
   statement (R comm ring; `g : M →ₗ[R] N`; `f : R`; `s : Fin n → R` with `span(range s)=⊤`; per-`j`
   hypothesis that the `powers s_j`-localised map `g_{s_j}` is `IsLocalizedModule (powers f)`; conclusion
   `IsLocalizedModule (powers f) g`) correct, self-contained, and FORMALIZE-READY? Is the partition-of-unity
   proof sketch adequate to formalize the three `IsLocalizedModule.mk` fields?

For both files: report `complete:` / `correct:` per the covering chapter and name any must-fix-this-iter item.
P1a and `tilde_preserves_kernels` are NOT dispatched this iter (project-to-build, `% NOTE`-flagged) — verify
they are well-formed but they do not gate this iter's dispatch.
