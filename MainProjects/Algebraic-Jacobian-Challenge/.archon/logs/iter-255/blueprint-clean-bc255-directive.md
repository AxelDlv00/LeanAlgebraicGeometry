# Blueprint-clean directive — bc255

Two chapters were edited/created this iter. Clean both (strip any Lean tactic syntax / Lean-identifier
leakage from prose, remove project-history verbosity, validate that every `% SOURCE:` /
`% SOURCE QUOTE:` is byte-intact against its named local source, ensure macros used are defined):

1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — edited by bw255-d1: the proofs of
   `lem:pullback_tensor_map_natural` (D1′) and `lem:sheafify_tensor_unit_iso_natural` were rewritten in
   mathematical prose to reflect the verified iter-255 proof routes (a carrier-spelling type-ascription
   device for D1′; a `tensorHom`-pin categorical route for the unit-iso naturality). Confirm NO Lean
   tactic blocks leaked in; the prose should describe the mathematics, not the tactics.

2. `blueprint/src/chapters/Picard_LineBundleCoherence.tex` — NEW chapter (bw255-eng) for
   `IsLocallyTrivial ⟹ IsFinitePresentation` (C1–C4 + corollary). Verify the verbatim Stacks quotes
   (§17.25 invertible modules / Lemma 0B8M; §17.11 finite presentation; §17.14 finite locally free)
   are byte-intact against `references/stacks-modules.tex`. Authorize `references/**` for a
   reference-retriever child only if a quote cannot be validated against the local file.

Do NOT add/remove `\leanok`/`\mathlibok`. Do NOT alter statements or `\lean{}`/`\uses{}` pins.
