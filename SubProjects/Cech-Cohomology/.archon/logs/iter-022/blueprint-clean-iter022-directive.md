# Blueprint-clean directive — iter-022

A blueprint-writer round just edited `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(decomposed `lem:section_cech_coface_match` into a new abstract-unfold sub-lemma
`lem:section_cech_objd_apply`, recast `lem:section_cech_ab_exact` to precursor+ladder form, wired
the five coverage-debt `\lean{}` decls). Run the standard purity pass on the WHOLE chapter:

- Strip any Lean-tactic leakage / typeclass-strategy notes / project-history phrasing the writer may
  have introduced in the new/edited blocks (`lem:section_cech_objd_apply`,
  `lem:section_cech_coface_match`, `lem:section_cech_ab_exact`, `lem:section_cech_product_equiv`).
  Keep Mathlib *lemma-name* references inside `\lean{}`/prose where they name the canonical
  mathematical operation (that is allowed), but remove tactic strings and "iter-N"/"the prover"
  narrative.
- Verify the tilde-bridge prose in `lem:section_cech_coface_match` reads as timeless mathematics
  (a per-coordinate localisation isomorphism + naturality square), not as an implementation TODO.
- Citation discipline: the localisation-of-sections facts cite Stacks 01HV/01I8 already present in
  this chapter. If any new block lacks a `% SOURCE QUOTE` that the chapter's convention requires,
  insert the verbatim quote from `references/stacks-schemes.tex` (tag 01HV) — do NOT fabricate.
- Do NOT touch `\leanok`. Do NOT alter the FreePresheafComplex / P4 / P5 blocks beyond purity.
