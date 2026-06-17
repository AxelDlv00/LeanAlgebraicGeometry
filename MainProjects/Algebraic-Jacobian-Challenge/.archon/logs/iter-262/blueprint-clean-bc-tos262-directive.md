# blueprint-clean bc-tos262 — directive

Purity gate on ONE chapter just edited by a blueprint-writer + a plan-agent
correction: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.

The edits this iter touched two proof sketches:
1. `lem:dual_restrict_iso` / the new `lem:slice_dual_transport` block — rewrote the
   `sliceDualTransport` description (combined leg A∘B; leg-A via categorical `.map`;
   leg-B `inv (ε (restrictScalars g))` at the CommRingCat level; added the `\lean`
   hint).
2. `lem:pullback_tensor_map_basechange` (D3′) — updated the Sq1/Sq4 status (Sq1
   `sheafificationCompPullback_comp` is the immediate open target; Sq4 reduces to
   Sq1 and is not yet built), added the square-interleaving note, dropped a stale
   `\uses`.

Your job: strip any Lean-tactic leakage, project-history/iter narrative, or
excess verbosity that crept into these two sketches; verify the math reads as
textbook prose; confirm no `% SOURCE`/citation block was damaged; keep all
`\lean{}`/`\uses{}`/`\label{}` and the `% archon:covers` line intact. Do NOT add
or remove `\leanok`/`\mathlibok`. Do NOT touch any other chapter or any block
outside the two named sketches. If you find a missing source quote on a block that
feeds an active prover lane, you may spawn a reference-retriever (write-domain
authorizes `references/**`).
