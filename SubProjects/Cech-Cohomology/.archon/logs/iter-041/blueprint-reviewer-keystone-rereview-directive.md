# Directive: blueprint-reviewer — scoped fast-path re-review of the keystone chapter

## Scope (fast-path HARD-GATE re-review)
Focus your verdict on `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, specifically the
Route B keystone region. (You always read the whole blueprint; the verdict I need is on this chapter.)

## What changed since your iter-041 must-fix
Your iter-041 audit returned **HARD GATE DOES NOT CLEAR** with one must-fix: the keystone
`lem:qcoh_section_isLocalizedModule` proof's descent step was unjustified — it used
`lem:isLocalizedModule_of_span_cover` whose per-`gⱼ` hypothesis is the abstract
`LocalizedModule(powers gⱼ)Γ(X,F)`, i.e. keystone-at-`gⱼ` (circular), and the `\uses` was incomplete.

A read-only mathlib-analogist consult (`analogies/keystone-descent.md`) confirmed the circularity and
gave the correct non-circular route (sheaf-axiom equalizer localized at `f`, Stacks 01HV(4)). A
blueprint-writer then **re-routed the keystone** and decomposed it into a `\uses`-linked chain of four
new sub-lemmas, and a blueprint-clean pass purified the prose. The new structure:
- `lem:qcoh_section_equalizer` — degree-0/1 sheaf-axiom equalizer for qcoh `F` on a finite cover.
- `lem:localized_module_map_exact_mathlib` (`\mathlibok`, `\lean{IsLocalizedModule.map_exact}`) —
  localization is exact.
- `lem:tile_section_localization` — per cover/overlap element, the tile section restriction localizes
  (from the DONE `lem:section_isLocalizedModule_of_presentation` + B4 + `restrict_obj`).
- `lem:qcoh_section_kernel_comparison` — kernel comparison of the two equalizers ⟹ `Γ(X,F)_f ≅ Γ(D(f),F)`.
- `lem:qcoh_section_isLocalizedModule` (keystone) — now `\uses` the four above; the circular
  `lem:isLocalizedModule_of_span_cover` edge is removed.

## What I need
1. **Is the must-fix resolved?** Does the re-routed keystone proof + the four sub-lemmas constitute a
   complete + correct (textbook-level) NON-CIRCULAR argument? In particular: is the non-circularity
   genuine (the only "sections localize" inputs are on the tiles, where `F` is tilde; the global step is
   F's sheaf axiom + exactness of localization — never an abstract-localized-module identification of
   `Γ(X,F)`)? Are the four sub-lemmas' `\uses` accurate and their informal proofs sufficient to
   formalize?
2. **Verdict for `Cohomology_CechHigherDirectImage.tex`**: complete? correct? any remaining
   must-fix-this-iter? I will dispatch a prover at the two ready sub-lemmas
   (`lem:qcoh_section_equalizer`, `lem:tile_section_localization`) ONLY if this chapter now clears.
3. Note (not blocking this gate, for my backlog): the writer flagged `lem:qcoh_localized_sections`
   (~L5024) as possibly circular by the same old mechanism. Confirm whether it is on any live path to
   01I8 (the keystone does NOT `\uses` it) or an independent/dormant node — so I can schedule a cleanup.
