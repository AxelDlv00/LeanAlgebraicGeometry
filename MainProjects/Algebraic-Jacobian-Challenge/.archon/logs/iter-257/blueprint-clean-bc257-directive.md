# blueprint-clean bc257 — purity gate on the iter-257 edited chapters

Three chapters were edited/created this iter by blueprint-writers. Run your purity pass on each:
strip Lean tactic syntax / Lean-term leakage, remove project-history / per-iteration narrative verbosity,
validate and (if missing) insert source quotes, and ensure the prose is math-only. Do NOT touch
`\leanok`/`\mathlibok` markers.

Chapters:
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — D3′ `lem:pullback_tensor_map_basechange`
   statement+proof were rewritten to the general composition-coherence + 4-square route; the
   `lem:dual_restrict_iso` proof gained a leg-(A) `sliceDualTransport` paragraph. Check these edits for
   Lean leakage (Lean identifiers like `Functor.OplaxMonoidal.comp_δ`, `PresheafOfModules.pullbackComp`,
   `restrictScalarsRingIsoDualEquiv` etc. are acceptable as named-ingredient references in prose, but no
   tactic blocks / `:= by …` / Lean syntax should appear).
2. `blueprint/src/chapters/Picard_LineBundleCoherence.tex` — finiteness-bridge recipe added to
   `lem:lbc_chart_presentation` / `thm:lbc_isFinitePresentation`; a false proof-block `\leanok` was
   removed; two overclaims softened.
3. `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — NEW chapter (Rⁱf_* Čech build).
   Verify the Stacks 02KE–02KH `% SOURCE QUOTE` blocks are verbatim and present; flag any block missing a
   citation.

Write domain includes `references/**` so you may spawn a reference-retriever if a source quote is missing
and must be fetched.
