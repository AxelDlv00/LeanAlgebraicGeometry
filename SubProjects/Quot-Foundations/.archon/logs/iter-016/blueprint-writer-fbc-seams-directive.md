# Blueprint-writer directive — FBC Seam 2 / Seam 3 mechanism (iter-016)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (edit ONLY this file).

## Goal
Expand the proof sketches of `lem:base_change_mate_fstar_reindex` (Seam 2, ~line 1386)
and `lem:base_change_mate_gstar_transpose` (Seam 3, ~line 1465) so they name the
*formalization mechanism* that the iter-014 Seam-1 proof established and that the
iter-015 prover validated for Seam 2 — without which the prover churns at the exact
coherence gap it already reached. The blocks already carry correct statements, source
quotes, and LEAN SIGNATURE comments; you are enriching the PROOF prose + adding a
`% RECIPE:` comment block with the validated mechanism. Do NOT change the statements,
`\lean{}` pins, `\label{}`s, or `\uses{}` sets. Do NOT add or remove `\leanok`.

## Mechanism to fold in — Seam 2 (`lem:base_change_mate_fstar_reindex`)
The iter-015 prover landed the leg-identification scaffold and LSP-validated this route
(record it as a `% RECIPE (iter-015, LSP-validated):` comment immediately after the
existing LEAN SIGNATURE comment, and reflect its mathematical content in the proof prose):
- The generic-square legs `g' = pullback.fst`, `f' = pullback.snd` are identified with
  `Spec(ιA)`, `Spec(ιR')` via `pullback_fst_snd_specMap_tensor`.
- The `(g')`-unit factor is related to the affine `Spec(ιA)`-unit through the conjugate
  (mate) calculus: `Scheme.Modules.conjugateEquiv_pullbackComp_inv` identifies
  `(pushforwardComp e.hom (Spec ιA)).hom` with `conjugateEquiv ((adj (Spec ιA)).comp
  (adj e.hom)) (adj g') (pullbackComp …).inv` (here `e = pullbackSpecIso`), and
  `CategoryTheory.unit_conjugateEquiv` / `unit_conjugateEquiv_symm` (the unit-across-
  conjugate coherence — the SAME idiom that closed Seam 1 in iter-014) transports the
  `g'`-unit to the `Spec(ιA)`-unit.
- The two `pushforwardComp` factors and the `pushforwardCongr` factor are TRANSPARENT on
  global sections (`pushforwardComp_hom_app_app`/`_inv_app_app = 𝟙`,
  `pushforwardCongr_hom_app_app = presheaf.map (eqToHom …).op`), i.e. on `Γ` they are
  `restrictScalars`-identity / `eqToHom` repackaging carrying no substantive content.
- The `Spec(ιA)`-unit's `Γ_A`-value is then Seam 1 (`base_change_mate_unit_value`,
  proven iter-014) = the algebraic unit `η_M`. Reconcile the RHS via
  `base_change_mate_codomain_read`, landing on `base_change_mate_inner_value` (= `ρ`).
- DEAD END to record (so the next prover avoids it): naive `rw`/`simp` with the leg
  equalities `hfst`/`hsnd` on the `Γ`-split goal fails ("motive is not type correct") —
  the legs occur inside the dependent `pushforwardCongr` proof term; the reindex MUST go
  through the abstract conjugate calculus, never by `rw` on the bare legs.

## Mechanism to fold in — Seam 3 (`lem:base_change_mate_gstar_transpose`)
Record as a `% RECIPE:` comment + proof prose:
- Seam 3 is the pullback-side companion of Seam 2: it is the `extendScalars ψ` (base
  change along ψ) of Seam 2's inner value. Crux distinct from Seam 2.
- After the counit factorization (`Adjunction.homEquiv_counit`) splits the base-change
  map, conjugate `Γ(g^*(θ_in)) ≫ Γ(ε_g)` by `Θ_src` (`base_change_mate_domain_read`) /
  `Θ_tgt` (`base_change_mate_codomain_read`). `Θ_src` already bakes in
  `pullback_spec_tilde_iso ψ`, which reads `g^* = (Spec ψ)^*` of a tilde as
  `extendScalars ψ`; the residual is the counit-triangle / dictionary naturality giving
  `extendScalars ψ ∘ ρ`.
- Both sides are `R'`-linear, so the final identification is `regroupEquiv.inv` checked
  on generators (`regroupEquiv` is fully proven; `lem:base_change_mate_regroupEquiv`).

## Style
- Mathlib lemma names go in `% comment` lines (a `% RECIPE:` block), NOT in the rendered
  prose. The rendered `\begin{proof}…\end{proof}` prose stays mathematical (the argument
  structure: leg identification, unit transport via the mate/conjugate calculus, collapse
  of the transparent coherences, reduction to Seam 1, codomain reconciliation).
- This is the documented "Mathlib-absent mate-unwinding over the generic pullback square";
  keep the existing source quotes intact.

## Out of scope
- `flatBaseChange_pushforward_isIso` (FBC-B), `affineBaseChange_pushforward_iso`.
- Any statement/pin/`\uses`/marker change.
