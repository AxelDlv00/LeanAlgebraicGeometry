# Recommendations — next plan iter (post iter-044)

## 0. HEADLINE — QUOT gap2 CLOSED. Open GF-G1 now.
`isLocalizedModule_basicOpen` is proved axiom-clean. The previously gap2-gated **GF-G1**
(`gf_qcoh_fintype_finite_sections`, frontier node, effort 1273, in `FlatteningStratification.lean`) is now
unblocked. Per the iter-042/043 plans this needs `FlatteningStratification.lean` to **import
`QuotScheme.lean`** (verified absent). Recommended iter-045 lane 1: add the import (refactor) + dispatch
GF-G1 prover. This is a direct application of gap2 — should be a short lane.

## 1. Blueprint coverage debt — 2 unmatched lean_aux nodes (planner authors prose)
Both are genuine new QUOT helpers with NO blueprint block (leandag `unmatched`=2). You write informal
prose; add `\lean{}` blocks:
- **`AlgebraicGeometry.Scheme.Modules.pullbackOpenImmersionUnitIso`** (QuotScheme.lean:2586). Deps:
  `IsOpenMap.adjunction`, `final_of_isRightAdjoint`, `SheafOfModules.pullbackObjUnitToUnit` (iso under
  `Final`). Generalizes `pullbackSchemeIsoUnitIso` (`def:pullback_scheme_iso_unit_iso`) from isos to open
  immersions. Slot a sibling block next to it; add to `\uses` of `def:presentation_pullback_iota_preimage`.
- **`AlgebraicGeometry.Scheme.Modules.pullbackPreimageιIso`** (QuotScheme.lean:2603). Deps:
  `Scheme.Modules.pullbackComp`/`pullbackCongr` (pseudofunctoriality), `Scheme.Hom.resLE_comp_ι`. It is the
  geometric square inside L3's `def:presentation_pullback_iota_preimage` proof. Own `def:` block or fold
  into that `\uses`.

## 2. Blueprint cleanup — stale `\uses` (planner)
`def:over_restrict_unit_iso_inv` `\uses{...lem:isIso_unitToPushforwardObjUnit_of_isIso...}` is stale — the
Lean proof took the equivalence-transport route and never touches that lemma. Drop the stale entry; the
real deps are `overRestrictEquiv`, `overRestrictUnitIso`, `Equivalence.unitIso`.

## 3. FBC `_legs_conj` — DO NOT re-dispatch a bare conjugate round without the named ingredients
8-iter wall (037–044). iter-044 landed verified `adjL`/`hunitL` (partial) but did not close. The next
prover must build, in order: **`adjR`** (the `extendRestrictScalarsAdj inclA`-based composite whose
`R₂.map(((conjugateEquiv adjL adjR).symm β).app M)` matches `read_param`'s 6-iso chain) + **comparison
`β`** (analogue of conj-2d's `gammaPushforwardNatIso`), then `(conjugateEquiv adjL adjR).injective`
discharged by the PROVEN legs conj-2b (`base_change_mate_reindex_conj_pullbackLeg` @1625), conj-2c
(`…pushforwardCollapse` @1736), conj-2d (`…crossLayer` @1652) via `conjugateEquiv_symm_comp`/whiskering.
Full recipe: `analogies/fbc-composite-mate-recognition.md` + the iter-044 FBC task_result "Next ingredient".
**DEAD ENDS (do not retry):** (a) positional collapse of factor-3 by `rw`/`simp`/`conv`/`change`/`erw`
(instance-path divergence — even a char-identical `have h3` fails); (b) `pullbackPushforward_unit_comp`
(shape mismatch); (c) monolithic depth-5 β (the 037–041 trap); (d) `sections_direct`/affine-tilde-transport
bypass (illusory — collapses to this same keystone; `% NOTE:` added to blueprint this phase).
**Escalation:** if iter-045 builds `adjR`+`β` and STILL cannot close, the factored-conjugate route is
exhausted in-loop → escalate to the user (TO_USER already flags this as the longest-running blocker).
No LLM API key in env (`archon-informal-agent.py` unavailable) — a user-supplied `adjR`/`β` sketch would
be the cheapest unblock.

## 4. Closest-to-completion / ready frontier (leandag)
gaps=0; frontier=7 ready nodes. After GF-G1, candidates: `lem:base_changed_equalizer_diagram`,
`lem:flat_base_change_reduce_global_sections`, `def:sectionGradedRing`,
`lem:composite_immersion_flocus_basicOpen`, `lem:gamma_image_iso_semilinear_top`. Pick per the HARD GATE
(blueprint-reviewer must clear the chapter first).

## 5. Minor / LOW (no action required this iter)
- Historical iter-039/041 status comments in FBC proof body @1808–1811 — prune when the enclosing sorry
  closes (lean-auditor minor).
- `adjL`/`hunitL` not yet syntactically consumed by the `sorry` @1891 — expected for scaffolding; will be
  consumed when the keystone closes.

## NOT to re-assign
- FBC `sections_direct` / affine-tilde-transport (illusory — recorded in blueprint `% NOTE:`).
- The 4 protected iter-176 QuotScheme stubs (frozen signatures, out of scope).
