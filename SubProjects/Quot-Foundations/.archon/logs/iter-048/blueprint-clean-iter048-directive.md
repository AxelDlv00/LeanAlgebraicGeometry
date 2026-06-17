Clean two chapters edited this iter by blueprint-writers:
- blueprint/src/chapters/Picard_FlatteningStratification.tex (seam-1 decomposed into 1a/1b/1c; G3 expanded; free-epi pin disentangled — new `lem:gf_qcoh_sections_free_epi`)
- blueprint/src/chapters/Picard_SectionGradedRing.tex (`lem:sheafTensorPow_add` proof rewritten to the Analogue-4 bespoke line-bundle route)

Action: strip any Lean tactic syntax / Lean-identifier leakage from prose, remove project-history/iter narrative, ensure each new/edited block has a clean math statement + informal proof, verify SOURCE/SOURCE QUOTE comments are intact and that any inserted Stacks/Mathlib quotes are verbatim from the local reference files (spawn reference-retriever only if a cited quote is missing locally). Do NOT touch `\leanok`/`\mathlibok` markers. Do NOT alter `\lean{}` pins or `\uses{}` edges.
