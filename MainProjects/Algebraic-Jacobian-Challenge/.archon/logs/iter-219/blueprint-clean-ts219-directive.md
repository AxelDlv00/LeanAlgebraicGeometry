# Blueprint Clean Directive

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the only file to clean).

## Why now
A blueprint-writer round (ts219dual) just edited this chapter: it reframed the
`lem:tensorobj_inverse_invertible` proof as infrastructure-blocked, added a route-mismatch note
to `lem:tensorobj_assoc_iso`, retracted inaccurate "removed in iter-218" superseded comments, and
APPENDED a new section `\label{sec:tensorobj_dual_infra}` decomposing the sheaf internal-hom build
(5 sub-step blocks + 2 remarks, sourced from `references/stacks-modules.tex`).

## Focus
1. **Strip Lean leakage & project history** across the chapter — especially residual `iter-NNN`
   tags, "route (d)/(e)", "our failed route", status-by-iteration phrasing. The chapter must read
   as a timeless mathematical document. (The new `sec:tensorobj_dual_infra` section and the EDIT-1/2
   reframings are the freshest content — check them, but also sweep the older blocks.)
2. **Verbosity trim** — the chapter is ~2300+ lines and has accumulated conversational status
   prose over many iters. Trim redundant/conversational passages that serve no mathematical purpose,
   while KEEPING: the infrastructure-blocked framing on `lem:tensorobj_inverse_invertible` (that is
   mathematically meaningful — it states the dependency), and the full new dual-infra section.
3. **Citation discipline** — verify the new section's blocks (`def:presheaf_internal_hom`,
   `def:presheaf_dual`, `lem:internal_hom_eval`, `lem:internal_hom_isSheaf`,
   `lem:dual_isLocallyTrivial`) each carry a `% SOURCE:` + verbatim `% SOURCE QUOTE:` where they
   derive from `references/stacks-modules.tex` (the writer reported sourcing them from there at
   L3500–3524, L4207–4211). Open `references/stacks-modules.tex` and confirm the quotes are verbatim
   and the line pointers are accurate; fix any paraphrase. Project-bespoke specialisations (e.g.
   `def:presheaf_dual`) may stand without an external quote.
4. **LaTeX** — confirm `\uses{}`/`\label{}`/`\cref{}` are well-formed and resolve within the chapter.

## Out of scope
- Do NOT touch any other chapter.
- Do NOT add/remove `\leanok`/`\mathlibok` markers.
- Do NOT remove the new dual-infra section or the infrastructure-blocked framing.
- `references/**` is in your write-domain so you may spawn a reference-retriever if a needed source
  is genuinely missing — but the writer reported `stacks-modules.tex` is already on disk, so retrieval
  is likely unnecessary.
