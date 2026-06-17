# Blueprint-clean directive — GF chapter, iter-015

**Chapter to clean (ONLY this file):** `blueprint/src/chapters/Picard_FlatteningStratification.tex`

A blueprint-writer round just (1) expanded the proof of `lem:gf_torsion_reindex` with a
"Localisation transport" sub-step and (2) added blueprint blocks for 5 new
`AlgebraicGeometry.GenericFreeness.*` helper declarations (folded into ~3 lemma blocks with `\lean{}`
pins).

Clean this chapter for blueprint purity:

- Strip raw Lean/tactic syntax leakage from the **visible prose** (the rendered math should read as
  mathematics, not Lean). Mathlib lemma *names* that the writer cited as "what the formalization
  required" (e.g. `IsLocalization.ringEquivOfRingEquiv`, `LinearEquiv.extendScalarsOfIsLocalization`,
  `IsLocalizedModule.linearEquiv`, `OreLocalization`) may be retained ONLY inside `%`-LaTeX comments
  or a clearly-marked implementation note; if they appear in rendered body text, move them to a
  comment or rephrase the sentence to name the mathematical operation instead.
- PRESERVE all `\label{}`, `\lean{}`, `\uses{}`, and `\mathlibok` markers exactly — do NOT remove or
  rename them, and do NOT add `\leanok` (the deterministic sync_leanok phase owns it).
- PRESERVE the `% SOURCE` / `% SOURCE QUOTE PROOF` citation comments (Nitsure §4) verbatim.
- Remove project-history verbosity / per-iter narrative if any leaked into the new blocks.
- Do NOT alter the load-bearing statements of any lemma; this is a purity pass only.

Out of scope: every other chapter, all `.lean` files.
