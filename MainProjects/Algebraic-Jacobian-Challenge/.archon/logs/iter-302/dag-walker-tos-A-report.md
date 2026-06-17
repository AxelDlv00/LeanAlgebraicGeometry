# DAG Walker Report

## Slug
tos-A

## Seed
lem:tensorobj_inverse_invertible (`AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`)

## Status
COMPLETE — all 25 assigned isolated lean-aux helpers now have their own `\label`'d
blueprint block, an accurate `\uses{}` read off the Lean body, and a proof note
(one-line "proved directly in Lean" for the 24 sorry-free; a full informal proof for
the single `sorry`-bodied node). All 25 are non-isolated and 0 `\uses` edges are broken.

## Cone before → after
- isolated lean-aux nodes (this cluster): 25 → 0
- broken `\uses` (project-wide `unknown_uses`): 0 → 0
- graph conflicts/cycles: 0 → 0 (one transient self-introduced 2-cycle
  `sheaf_unit_comp_pushforward_pullbackcomp_inv ↔ sheafificationcomppullback_comp`
  was caught and removed before finalizing)
- project-wide unmatched lean_aux: 50 → 44 (the −6 net reflects that my 25 matched
  while sibling-walker clusters — DualInverse `dualUnitRingSwap*`, `extendScalars`,
  `picMul/picInv`, etc. — remain; all 25 of *my* targets are confirmed matched)
- blocks added: 25;  `\uses` edges added/fixed into consumers: 10 consumer blocks
  (statement + proof) re-wired

## Blocks added (all in `chapters/Picard_TensorObjSubstrate.tex`, new
`\section{Substrate helper declarations (wired lean-aux blocks)}` plus consumer wiring)

Sorry-free (one-line "proved directly in Lean" note + Lean-body `\uses`):
- `def:tensorobjisoofiso` ← `tensorObjIsoOfIso` — `\uses{def:scheme_modules_tensorobj}`
- `def:tensorobj_unit_self_iso` ← `tensorObj_unit_iso` (𝒪⊗𝒪≅𝒪)
- `def:tensorobj_middlefour` ← `tensorObj_middleFour`
- `def:restrict_iso_unit_of_le` ← `restrictIsoUnitOfLE`
- `lem:topresheaf_map_hommk` ← `toPresheaf_map_homMk`
- `lem:isiso_pbu_of_final` ← `isIso_pbu_of_final`
- `def:pullback_obj_unit_to_unit_iso` ← `pullbackObjUnitToUnitIso`
- `lem:pullback_obj_unit_to_unit_iso_hom` ← `pullbackObjUnitToUnitIso_hom`
- `def:sheafify_tensor_unit_iso` ← `sheafifyTensorUnitIso`
- `lem:sheafify_tensor_unit_iso_hom_eq` ← `sheafifyTensorUnitIso_hom_eq`
- `lem:sheafify_tensor_unit_iso_hom_eq_prime` ← `sheafifyTensorUnitIso_hom_eq'`
- `def:sheafify_unit_iso` ← `sheafifyUnitIso`
- `def:pullback_val_iso` ← `pullbackValIso`
- `def:pullback0` ← `pullback0`
- `def:pullback0_adjunction` ← `pullback0Adjunction`
- `lem:isiso_sheafify_tensorhom_pullbackvaliso` ← `isIso_sheafify_tensorHom_pullbackValIso`
- `lem:w_of_isiso_sheafification` ← `W_of_isIso_sheafification`
- `lem:isiso_sheafifydelta_unitpair_of_isiso_sheafifyeta` ← `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`
- `lem:isiso_pullbacktensormap_unitpair_of_isiso_sheafifyeta` ← `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`
- `lem:toringcatsheafhom_comp_hom_reconcile` ← `toRingCatSheafHom_comp_hom_reconcile`
- `lem:pullbackcomp_delta` ← `pullbackComp_δ`
- `lem:sheaf_unit_comp_pushforward_pullbackcomp_inv` ← `sheaf_unit_comp_pushforward_pullbackComp_inv`
- `lem:sheafificationcomppullback_comp` ← `sheafificationCompPullback_comp`
- `lem:pullback_sheafify_unit_eta_triangle` ← `pullbackSheafifyUnitEtaTriangle`

∞ node — real informal proof written:
- `lem:sheafificationcomppullback_comp_tail` ← `sheafificationCompPullback_comp_tail`
  (`sorry`-bodied in Lean). Wrote the full mate-calculus sketch: it is the
  sheafification-laden twin of the unit coherence `lem:pullbackObjUnitToUnit_comp`,
  one sheafification layer up; because the adjunctions are *composite* (presheaf
  pullback–pushforward `.comp` sheafification) the coherence is genuine mate calculus,
  not a reflexivity. The sketch gives the ordered steps (a) strip the
  `restrictScalars(𝟙)` wrapper, (b) distribute the RHS sheaf composite under `forget`
  confined to the RHS, (c) recover the two sub-comparison factors R₁/R₅ as composite-
  adjunction units via the P-general uniqueness-of-left-adjoints brick
  `lem:leftadjointuniq_app_unit_eta_general`, (d) slide `pushforwardComp` past them by
  naturality, (e) reassemble `B_{h∘f}.unit` via `comp_unit_app` + `unit_naturality`;
  isolates the single non-mechanical bridge (the definitional
  `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget`, reducing to
  `Iso.inv_hom_id`/unit-coherence at the unit presheaf) and records the verified-circular
  warning against re-transposing the whole tail. Provenance line:
  *Source: internal categorical construction; no external reference.*
  `\uses{lem:sheafification_comp_pullback_eq_leftadjointuniq,
  lem:leftadjointuniq_app_unit_eta_general, lem:pullbackObjUnitToUnit_comp}`.

## `\uses` edges added/fixed (the completeness fixes)
Consumers re-wired so the new helpers are in their `\uses` (statement + proof), matching
the Lean bodies' real invoked declarations:
- `lem:pullback_tensor_map` now `\uses` `def:sheafify_tensor_unit_iso`, `def:pullback_val_iso`
  (its Lean body builds the comparison from exactly those bricks; previously named only in prose).
- `lem:isiso_pullbacktensormap_of_sheafifydelta` now `\uses` `lem:isiso_sheafify_tensorhom_pullbackvaliso`
  (the factored top-level iso it invokes).
- `lem:pullback_unit_iso` now `\uses` `def:pullback_obj_unit_to_unit_iso`.
- `lem:sheafify_tensor_unit_iso_natural` now `\uses` `def:sheafify_tensor_unit_iso`,
  `lem:sheafify_tensor_unit_iso_hom_eq_prime`.
- `lem:pullback_val_iso_natural` now `\uses{def:pullback_val_iso}` (had no `\uses`).
- `lem:eta_bridge_unit_square` now `\uses` `def:sheafify_unit_iso`, `def:pullback_val_iso`,
  `lem:pullback_sheafify_unit_eta_triangle`.
- `lem:pullback_lan_decomposition` now `\uses` `def:pullback0`, `def:pullback0_adjunction`.
- `lem:pullback_tensor_map_basechange` (D3′) now `\uses` `def:tensorobjisoofiso`,
  `lem:toringcatsheafhom_comp_hom_reconcile`, `lem:pullbackcomp_delta`,
  `lem:sheafificationcomppullback_comp`, `def:pullback_val_iso`, `def:sheafify_tensor_unit_iso`
  (every one named in its Sq1–Sq4 proof prose; now real edges).
- `lem:tensorobj_isoclass_commgroup` (the Picard group law) now `\uses`
  `def:tensorobjisoofiso`, `def:tensorobj_unit_self_iso`, `def:tensorobj_middlefour`
  (the bricks its `picMul`/`IsInvertible.tensorObj`/`isInvertible_unit` invoke).
- `lem:tensorobj_inverse_invertible` (seed) proof now `\uses{lem:topresheaf_map_hommk}`
  (the round-trip identity used by its gluing-descent Step A).

Internal cluster edges (new block → new/existing block), all read from Lean bodies, form a
DAG: F→G, H→F, J→I, K→{I,J}, O→N, P→{M,…}, Q→isiso_sheafification_map_of_W, R→{Q,…},
S→{R,…}, C→{A, tensorobj_assoc_iso, tensorobj_comm_iso}, W→{leftadjointuniq-eq, V, X},
M→sheafification_comp_pullback_eq_leftadjointuniq, U→{oplax, lax}.

## Could not complete (genuine gaps — strategy items)
- `lem:sheafificationcomppullback_comp_tail` remains `sorry` in **Lean** (the residual tail
  of D3′ Sq1). It now has a finite-effort informal proof (no longer ∞), but the Lean closure
  is the genuine open obligation: the single non-mechanical bridge is the
  composite-adjunction unit recovery (step (c)) wrapped across the presheaf↔sheaf pushforward
  boundary — the project's notes (in-file + memory `ts271-d3-tail-whiskerright-device`) flag
  the `conjugateEquiv_whiskerRight` device as de-risked, with ~40–60 LOC of mate-calculus
  wiring remaining. This is the last brick of D3′ (`pullbackTensorMap_restrict`), itself the
  base-change input to the locally-trivial pullback–tensor iso `IsInvertible.pullback`.

## Notes for dispatcher
- **Reachability of the seed's *statement* cone.** None of the 25 lie in the directed
  *statement*-`\uses` ancestor set of `lem:tensorobj_inverse_invertible`, and this is the
  honest mathematical structure, not a wiring gap: in the actual development these helpers
  are **siblings** of the seed, not its ancestors. The group-law bricks
  (`tensorObjIsoOfIso`, `tensorObj_unit_iso`, `tensorObj_middleFour`) feed
  `lem:tensorobj_isoclass_commgroup`, which is *downstream* of the seed (the group law
  *consumes* the seed's inverse-existence). The pullback-monoidality bricks feed
  `lem:pullback_tensor_map_basechange → lem:pullback_tensor_iso_loctriv →
  lem:isinvertible_pullback`, a parallel subtree culminating in the chapter goal, not in
  the seed. The only helper genuinely on a path *into* the seed is
  `lem:topresheaf_map_hommk` (the seed's gluing descent), now wired into the seed's proof
  `\uses`. I deliberately did **not** fabricate false statement edges to force the other 24
  into the seed's cone; non-isolation (the measurable end-state) is achieved for all 25, and
  every edge added reflects a real Lean dependency.
- `leandag` exposes no `web` subcommand here; `leanblueprint web` (the proof-edge acyclicity
  check) was not run in-loop. The directed-graph `leandag build` reports `conflicts: []`,
  `unknown_uses: []`, and the cluster's statement+proof edges are acyclic by construction
  (verified the one self-introduced 2-cycle was removed). Recommend the normal
  `leanblueprint web` pass confirm EXIT 0.
- Out of scope and untouched (sibling walkers): the change-of-rings/μ + Pic cluster and
  `DualInverse.lean`; no protected chapter edited.
