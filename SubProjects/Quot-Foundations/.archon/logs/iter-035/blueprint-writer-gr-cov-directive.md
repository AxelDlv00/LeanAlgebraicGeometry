# Blueprint-writer directive — GR coverage debt (iter-035)

## Chapter
`blueprint/src/chapters/Picard_GrassmannianCells.tex` (covers `AlgebraicJacobian/Picard/GrassmannianCells.lean`).

## Task
Six prover-created Lean declarations landed axiom-clean in iter-034 (the `Grassmannian.isSeparated`
keystone assembly) but have NO blueprint block — they are isolated `lean_aux` nodes the dependency graph
cannot see. Restore the 1-to-1 Lean↔blueprint correspondence: add ONE `\begin{lemma}`/`\begin{definition}`
block per declaration, each with `\label{}`, `\lean{<exact name>}`, an accurate `\uses{}` reflecting what
the Lean proof actually consumes, and at least a one-line informal proof. These are project-bespoke
infrastructure (Nitsure §1 Grassmannian construction context) — no external SOURCE QUOTE required unless
you find the natural citation; a short project-internal justification suffices.

Place the new blocks in the separatedness section (near `\label{sec:gr_separated}` / `lem:gr_separated`,
~L1873–1965), since they are the assembly machinery for that keystone.

## The six declarations (exact Lean names + intended \uses)
1. `AlgebraicGeometry.Grassmannian.toSpecZ` (def) — the structure morphism `scheme d r ⟶ Spec ℤ`,
   `= specZIsTerminal.from`. `\uses{def:gr_glued_scheme}`. One-line: Spec ℤ is terminal in `Scheme.{0}`,
   so `toSpecZ` is the unique terminal map.
2. `AlgebraicGeometry.Grassmannian.ι_toSpecZ` (lemma) — `ι i ≫ toSpecZ = Spec.map (algebraMap ℤ R^I)`.
   `\uses{def:gr_glued_scheme}` (+ the `toSpecZ` block). Proof: both sides are maps into the terminal
   `Spec ℤ`, equal by terminal-hom uniqueness (`IsTerminal.hom_ext`).
3. `AlgebraicGeometry.Grassmannian.pullbackιIso_inv_fst` (lemma) — first projection leg of the source iso
   `e₂` (`pullbackιIso`): `(pullbackιIso …).inv ≫ pr₁ = chartIncl I J`. `\uses{def:gr_pullbackιIso}`.
   Proof: `IsLimit.conePointUniqueUpToIso_inv_comp` against the `vPullbackCone` fst leg.
4. `AlgebraicGeometry.Grassmannian.pullbackιIso_inv_snd` (lemma) — second projection leg:
   `(pullbackιIso …).inv ≫ pr₂ = chartTransition I J ≫ chartIncl J I`. Same `\uses` + proof as (3) on the
   snd leg.
5. `AlgebraicGeometry.Grassmannian.chartTransition_comp_chartIncl` (lemma) —
   `chartTransition I J ≫ chartIncl J I = Spec.map θ̃_{I,J}`. `\uses{def:gr_transition}` (and the
   transition-pre def if present). Proof: unfold the localized transition map; `IsLocalization.Away.lift_comp`.
6. `AlgebraicGeometry.Grassmannian.isSeparatedToSpecZ` (lemma) — `IsSeparated (toSpecZ d r)`, the
   morphism-form of `lem:gr_separated` (the Proj-template per-patch closed-immersion computation).
   `\uses{lem:gr_diagonalRingMap_surjective, def:gr_diagonalRingMap, def:gr_pullbackιIso}` plus the five
   blocks above. Proof (one paragraph): cover the diagonal pullback by patch products
   (`openCoverOfLeftRight`); per patch `(i,j)` the restricted diagonal is `Spec δ_{I,J}`, a closed
   immersion because `diagonalRingMap` is surjective (`lem:gr_diagonalRingMap_surjective`); source iso
   `e₂ = pullbackιIso`, target iso via `pullbackSpecIso`. This is essentially the proof already written
   for `lem:gr_separated`; you may state `isSeparatedToSpecZ` as the morphism-form and have
   `lem:gr_separated` `\uses` it. Wire `lem:gr_separated`'s `\uses` to include `lem:gr_separated_toSpecZ`
   (or whatever label you give this block).

## Constraints
- Do NOT add `\leanok` (the deterministic sync phase owns it).
- Do NOT touch any other chapter.
- Keep each block tight; the dependency edges are the point.
- If a `\uses` target label does not exist (e.g. you reference `def:gr_transition_pre` and it's absent),
  use the closest existing label and note the gap in a `% NOTE:` comment rather than inventing a label.
- Verify the exact `def:`/`lem:` labels for `def:gr_glued_scheme`, `def:gr_pullbackιIso`,
  `def:gr_diagonalRingMap`, `lem:gr_diagonalRingMap_surjective`, `def:gr_transition` exist in the chapter
  before wiring `\uses` to them (grep the chapter).
