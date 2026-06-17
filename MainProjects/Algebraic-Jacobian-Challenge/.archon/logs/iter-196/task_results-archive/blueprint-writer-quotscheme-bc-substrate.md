# Blueprint Writer Report

## Slug
quotscheme-bc-substrate

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## LOC delta
+245 lines (1190 → 1435).

## New `\lean{...}` pins introduced
1. `AlgebraicGeometry.Scheme.Modules.baseMap_pullbackComp_apply` — (N1)
   baseMap naturality in the input sheaf.
2. `AlgebraicGeometry.Scheme.Modules.baseMap_pullback_comp_apply` — (N2)
   baseMap composition via `pullbackComp` (used in Stages 3 and 5).
3. `AlgebraicGeometry.Scheme.Modules.baseMap_pullbackCongr_apply` — (N3)
   baseMap transport via `pullbackCongr`.
4. `AlgebraicGeometry.Scheme.Modules.baseMap_inv_step3_open_immersion` —
   (N4) `step3` inversion identity for the open immersion
   `_hU.fromSpec`.

## Structural shape of the new subsection
The new `\subsection{Iter-195 Beck-Chevalley 6-stage decomposition +
(N1)--(N4) substrate}` (label `sec:quot_iter195_bc_substrate`) sits
directly before `\section{Lean encoding}`, after the iter-189
"unbundle pins" subsection. It opens with a two-paragraph framing
explaining (a) that `step1`/`step2` are now Σ-pair components with
`_step1_apply` / `_step2_apply` identities, (b) that the
Beck-Chevalley intertwining now unfolds into 6 stages mirroring the
in-file comment block at
`AlgebraicJacobian/Picard/QuotScheme.lean:999-1037`, (c) that
Stage 1 is iter-195-closed and Stages 2--6 are gated on (N1)--(N4),
(d) the common Mathlib-adjacent source pattern (the project's
`Scheme.Modules.baseMap` ultimately comes from
`pullbackPushforwardAdjunction.unit` — (N1)--(N3) are naturality
squares of that unit at triples of morphisms / module homomorphisms /
propositional equalities, (N4) is the `step3` inversion via
`restrictFunctorIsoPullback`), and (e) honest LOC estimates
(~20--30 LOC each, ~80--120 LOC substrate total — explicitly noting
this is the volume the iter-195 plan-phase estimate missed).

Following the framing, four `\lemma` blocks (each with `\lean{...}`,
`\uses{...}`, statement prose, and `\begin{proof}...\end{proof}`
sketch) introduce (N1)--(N4) as iter-196+ prover targets. Each
proof body is a single paragraph naming the Mathlib-canonical
construction (`pullbackPushforwardAdjunction.unit` naturality;
`Adjunction.comp` unit decomposition; propositional-equality
elimination via `eqToIso_app` and `Eq.mpr`; `restrictFunctorIsoPullback`
inverse identification), plus a `% NOTE (iter-196 plan-phase)` line
recording LOC estimate and prover-target status.

Additionally, the existing `\definition` block for
`def:pullback_app_isoTensor_sigma` (label
`def:pullback_app_isoTensor_sigma`) had its tail proof sketch
(previously a 4-sentence reference to "Beck-Chevalley intertwining;
iter-189+ build via the 5-step Tilde-isoTop route") replaced with an
itemized 6-stage decomposition (`Stage 1` ... `Stage 6`). Each stage
is one math sentence stating the substrate it uses (`_step2_apply`,
(N1)+`_step1_apply`, (N2), (N3), (N2) again, (N4)) by `\cref{...}`,
mirroring exactly the in-file Lean comment block. This is the
"explicit recipe" the iter-196+ prover will follow.

## Cross-references introduced
- New `\cref` targets (forward, intra-chapter): `sec:quot_iter195_bc_substrate`,
  `lem:baseMap_pullbackComp_apply`, `lem:baseMap_pullback_comp_apply`,
  `lem:baseMap_pullbackCongr_apply`, `lem:baseMap_inv_step3_open_immersion`
  — all live in the new subsection.
- `\uses{...}` edges added by the new lemmas: each new `\lemma` and its
  proof `\uses` `def:quot_canonical_basechange_map` and (where natural)
  `lem:pullback_tildeIso`. The (N4) block `\uses`
  `lem:pullback_of_openImmersion_iso_restrict` in both statement and
  proof — all four `\uses` targets exist on disk in the same chapter.
- The revised `def:pullback_app_isoTensor_sigma` body adds intra-chapter
  `\cref`s to the four new lemmas plus `sec:quot_iter195_bc_substrate`,
  and an existing `\cref` to `lem:pullback_of_openImmersion_iso_restrict`
  (Stage 6's `step3` recipe).

## References consulted
- No new `references/<file>.md` files opened. The directive explicitly
  states "This is iter-187/189 mathlib-analogist-verified material …
  No NEW external sources needed; no reference-retriever dispatch
  required." All citations in the new content reference the already-cited
  Mathlib namespaces (`Mathlib.AlgebraicGeometry.Sheaves.Modules.Pullback`,
  `Mathlib.AlgebraicGeometry.OpenImmersion`) and existing intra-chapter
  blueprint labels; no `% SOURCE QUOTE` blocks introduced.

## Macros needed (if any)
None.

## Reference-retriever dispatches
None.

## Notes for Plan Agent
- The existing `def:pullback_app_isoTensor_sigma` block at L871 had a
  slightly unconventional shape (`\begin{definition}` followed by a
  blank line, then `\leanok` on the next line, then `[Σ-pair packaging:
  ...]` on the next) — I preserved that shape and edited only the proof
  sketch tail. Same shape recurs at the two iter-187/189 lemmas
  (`lem:pullback_tildeIso`, `lem:tildeIso_of_isQuasicoherent_isAffineOpen`,
  `lem:pullback_of_openImmersion_iso_restrict`,
  `lem:pushforward_isQuasicoherent`). Cosmetic; not strategy-relevant.
- The pre-existing `\begin{proof}` vs `\end{proof}` count differs by 1
  because of a `\begin{proof}` substring inside a `% NOTE` comment at
  L390 (`% project notation in the \begin{proof} block.`). Real-count
  is balanced (14 vs 14 after my edits). Not strategy-relevant; not my
  introduction.
- The four substrate lemma names suggested by the directive
  (`baseMap_pullbackComp_apply`, `baseMap_pullback_comp_apply`,
  `baseMap_pullbackCongr_apply`, `baseMap_inv_step3_open_immersion`)
  are honored verbatim as `\lean{...}` pins. Note that (N1) is
  semantically "naturality in input sheaf" while its assigned name
  reads "pullbackComp"; (N2) is "composition via pullbackComp" and
  reads similarly. If the iter-196+ prover lands the substrate under
  more descriptive names (e.g. `baseMap_naturality_map_apply` for
  (N1)), a small `\lean{...}` correction pass on this subsection
  would be in order. Flagging because the names appear superficially
  ambiguous; not strategy-modifying.
