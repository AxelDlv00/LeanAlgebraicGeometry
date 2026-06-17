# Blueprint-writer directive — GR coverage debt (slug: gr-cov)

Chapter: `blueprint/src/chapters/Picard_GrassmannianCells.tex` (ONLY this file).

## Context

The iter-031 GR-glue prover built the glued Grassmannian scheme axiom-clean. Three NEW public Lean
declarations have no blueprint block (coverage debt — they show as `lean_aux`/unmatched). Add a
blueprint block for each, restoring the 1-to-1 Lean↔blueprint correspondence. These are
**project-bespoke** results (no external source) — omit `% SOURCE`/`% SOURCE QUOTE` lines; the blocks
stand on their statement + a short informal proof. Place each block at the mathematically natural
location (see hints). Do NOT add `\leanok` (the sync phase manages it).

## Blocks to add

1. **`def:gr_the_glue_data`** — `\lean{AlgebraicGeometry.Grassmannian.theGlueData}`
   - Statement: the `Scheme.GlueData` bundle indexed by `{I : Finset (Fin r) // I.card = d}`, with
     `U := affineChart`, `V := chartOverlap`, `f := chartIncl`, `t := chartTransition`,
     `t' := chartTransition'`, `t_id`, `t_fac` (`lem:gr_chartTransition'_fac`), and the `cocycle`
     field (`chartTransition'_cocycle`). `f_mono`/`f_hasPullback` discharged by instance synthesis.
   - `\uses{def:gr_glued_scheme}` is wrong direction — instead `def:gr_glued_scheme` should `\uses` this.
     Set this block's `\uses{def:gr_affine_chart, def:gr_chart_overlap, def:gr_transition,
     lem:gr_chartTransition'_fac, lem:gr_chartTransition'_cocycle}` (use the actual existing labels for
     charts/overlaps/transition — grep the chapter to confirm their label names).
   - One-line proof: assembling the named fields into the `Scheme.GlueData` record.
   - Location: immediately BEFORE `def:gr_glued_scheme` (§"The glued Grassmannian scheme"). Then ensure
     `def:gr_glued_scheme`'s `\uses` includes `def:gr_the_glue_data`.

2. **`lem:gr_chartTransition'_cocycle`** — `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_cocycle}`
   - Statement: the scheme-level cocycle coherence `t'_{I,J,K} ≫ t'_{J,K,I} ≫ t'_{K,I,J} = 𝟙` (the
     `cocycle` field of the GlueData), the categorical realisation of the ring identity Φ = id.
   - `\uses{lem:gr_cocycle_phi_id, def:gr_transition}` (and the chart-transition' label).
   - Proof: cancel the two internal `awayPullbackIso` conjugating pairs (`Iso.inv_hom_id_assoc`), collapse
     the six `Spec.map`s into `Spec.map (ofHom Φ)`, apply `cocyclePhiId` (Φ = id) to get `𝟙`.
   - Location: between `lem:gr_chartTransition'_fac` and `lem:gr_cocycle_phi_id` (sibling of `_fac`).

3. **`lem:gr_awayMulCommEquiv_comp_awayInclLeft`** — `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv_comp_awayInclLeft}`
   - Statement: the order-swap identity `swap_{x,y} ∘ ι^L_{x,y} = ι^R_{y,x}` as ring maps
     `R[1/x] → R[1/(yx)]`.
   - `\uses{}` for the relevant order-swap / inclusion definitions in the chapter (grep for the
     `awayInclLeft`/`awayMulCommEquiv`/`awayInclRight` blocks; if those helpers have no blocks either,
     a light `\uses{}` to the localization-away set-up section is acceptable).
   - Proof: `IsLocalization.ringHom_ext` on `Submonoid.powers x`, then both sides agree on
     `algebraMap` (via `awayInclLeft_comp_algebraMap` / `awayMulCommEquiv_comp_algebraMap` /
     `awayInclRight_comp_algebraMap`).
   - Location: the order-swap / localization-away subsection (near `def:gr_transition` set-up).

## Out of scope
- The 3 private helpers (`rotMid`, `transitionInvImageMatrix`, `transitionInvPair`) — they stay private,
  no blocks needed.
- The 9 pre-existing private-pin declarations — that is a Lean-side de-privatization handled by the prover
  lane, NOT a blueprint edit. Do not touch those pins.
- `lem:gr_separated` / `lem:gr_proper` already exist and are complete — do not edit them.
- Any stale `% NOTE` cleanup is the review agent's job — leave NOTEs alone.

Confirm each new block's `\uses{}` references an existing label (grep first). Report any label you had
to invent.
