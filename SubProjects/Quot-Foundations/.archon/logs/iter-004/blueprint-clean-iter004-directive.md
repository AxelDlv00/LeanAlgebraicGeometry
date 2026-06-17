# Blueprint-clean directive — iter-004 post-writer purity pass

Two chapters received write-capable subagent edits this iteration and must be
cleaned before provers run:

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
   - An effort-breaker split `lem:base_change_mate_generator_trace` into a
     3-sub-lemma chain (`lem:base_change_mate_regroupEquiv`,
     `lem:base_change_mate_generator_trace_eq`, and the `IsIso` corollary leaf).
   - The plan agent added two thin infrastructure-helper blocks
     (`lem:pullbackIsoEquivalenceOfIso`, `lem:pullback_isEquivalence_of_iso`).

2. `blueprint/src/chapters/Picard_FlatteningStratification.tex`
   - A blueprint-writer re-encoded L4 (`lem:gf_noether_clear_denominators`) to an
     explicit-AlgHom target, corrected `lem:gf_free_moduleFinite` prose, and split
     L3 (`lem:gf_splice_shortExact`) into three sub-lemmas + an assembly.

## Scope of this pass

- Strip any Lean tactic syntax / Lean-term leakage from the **prose bodies**
  (the text that renders in the PDF). Keep prose mathematical.
- **PRESERVE** the `% LEAN SIGNATURE` comment blocks (LaTeX comments, do not
  render) on `lem:gf_noether_clear_denominators` and `thm:generic_flatness` —
  these are sanctioned signature anchors, exactly analogous to the existing
  `% LEAN SIGNATURE HEADER`. Do NOT delete them.
- **PRESERVE** every `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` /
  `% NOTE` comment and every `\textit{Source: …}` line verbatim.
- Validate the LaTeX (balanced environments, resolvable `\uses`/`\ref`).
- Do NOT add or remove `\leanok` (the deterministic sync owns it). Do NOT add
  `\mathlibok` except on a genuine confirmed Mathlib anchor.
- If a verbatim source quote is missing where one is needed, you may spawn a
  reference-retriever (references/** is in your write-domain); the Nitsure source
  is at `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`.
