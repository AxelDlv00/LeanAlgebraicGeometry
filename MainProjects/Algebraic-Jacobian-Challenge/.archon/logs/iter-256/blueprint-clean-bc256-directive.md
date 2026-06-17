# Blueprint-clean directive — iter-256

Purity gate on `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, which was just edited by
blueprint-writer bw256 (two proof-sketch refinements: `lem:sheafofmodules_hom_of_local_compat`
sub-step (c) smul-bridge expansion; `lem:dual_restrict_iso` Step-4 H1 + Leg(A)/(B) restructure).

Tasks:
- Strip any Lean tactic syntax / code leakage that may have crept into the two edited proof blocks
  (the math may name Mathlib lemmas as tools — that is allowed — but no tactic strings, no
  `by`/`erw`/`refine` blocks, no Lean term syntax).
- Verify every `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` comment on the two edited
  blocks is intact and that the verbatim quotes still match their cited sources (do NOT invent or
  re-derive quotes; if a quote is absent for an Archon-original sub-step, that is correct — leave it).
- Do NOT touch any `\leanok`/`\mathlibok` marker. Do NOT re-introduce any `\leanok` inside a
  `\uses{...}` list (the planner removed six such corruptions this iter).
- Confirm `\uses{...}` lists are well-formed (every argument a label token).
- Scope: ONLY `Picard_TensorObjSubstrate.tex`. Do not edit other chapters.
