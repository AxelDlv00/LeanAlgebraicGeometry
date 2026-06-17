# Recommendations — next plan iter (post iter-042)

## HIGH — verify the sync_leanok anomaly self-heals (3 clean decls lost `\leanok` this iter)
lean-vs-blueprint-checker `qts` (M-1) flagged, and review **independently verified** via `lean_verify`,
that three `\lean{}`-pinned declarations are axiom-clean (`{propext, Classical.choice, Quot.sound}`) yet
carry **no `\leanok`** in `Cohomology_CechHigherDirectImage.tex`:
- `lem:isLocalizedModule_of_span_cover` → `AlgebraicGeometry.isLocalizedModule_of_span_cover`
- `lem:qcoh_finite_presentation_cover` → `AlgebraicGeometry.qcoh_finite_presentation_cover`
- `lem:qcoh_section_equalizer` → `AlgebraicGeometry.qcoh_section_equalizer` (iter-041 sync HAD added these;
  this iter's sync `2a2ff23` shows +2/−2 — the −2 stripped them)

**Likely root cause:** the prover added `import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen` to
`QcohTildeSections.lean` this iter; at sync time the dependency olean was likely stale/unbuilt, so
`sync_leanok`'s `lake env lean` verification of the chapter's decls transiently failed and the script
correctly (per its inputs) stripped the markers. This is the same stale-olean class the prover hit on
`tile_section_localization`. The Lean is clean now (build green, all three verify axiom-clean).

**Action (planner):** this is self-healing — the deterministic `sync_leanok` re-runs between prover and
review every iter; on the current green tree it should re-add all three `\leanok` next iter. Just CONFIRM
it did (`grep -A2 'label{lem:qcoh_section_equalizer}'`). If it does NOT re-add them next iter, there is a
real sync/build-order bug to investigate (ensure `lake build` of the full import closure precedes sync).
Review did NOT touch `\leanok` (deterministic-sync domain). No prover work needed for this item.

## HIGH — closest-to-completion target: build Sub-lemma B, then assemble `tile_section_localization`
`tile_section_localization` (last keystone leaf) is one honest lemma away. Its descent skeleton is built and
correct; the single missing ingredient is **Sub-lemma B `lem:tile_section_comparison`** — the natural
`R_g`-linear isomorphism `Γ_{R_g}(V, F_{(g)}) ≅ Γ_R(ι ''ᵁ V, F)` intertwining the restriction maps,
~100–150 LOC from `StructureSheaf.globalSectionsIso` bookkeeping. Both reviewers confirm the blueprint
sketch for `lem:tile_section_comparison` is accurate and adequate (a genuine non-rfl construction), and the
deferred-note comment in the Lean file is honest. **Dispatch a prover on Sub-lemma B** (the blueprint block
is gate-clear), then assemble via the existing skeleton:
`section_isLocalizedModule_of_presentation` (over `R_g`) → transport across Sub-lemma B →
`isLocalizedModule_powers_restrictScalars_of_algebraMap` → `tile_image_opens_identities` (the leaf landed
this iter). The blueprint should grow a `\lean{}` pin for `lem:tile_section_comparison` once it lands; mark
`lem:tile_section_localization`'s pin (`AlgebraicGeometry.tile_section_localization`) once the assembly lands.

## DO-NOT-RETRY — the definitional-collapse route for `tile_section_localization`
The naive "carriers defeq + scalar coherence `rfl` + base-ring descent" route is **dead** and was exhausted
this iter: the tile section is `ModuleCat ↑(Localization.Away g)` and the F-side section is `ModuleCat ↑R`
— **not even the same type**. No `inferInstanceAs`/`letI`, `noncomputable def`,
`backward.isDefEq.respectTransparency false`, or `synthInstance.maxHeartbeats` up to 2e6 makes it `rfl`.
Do NOT re-dispatch the tile lemma without the honest Sub-lemma B first. (project memory
`keystone-tile-reconciliation-not-rfl`, now kernel-confirmed.)

## DO-NOT-TRUST — `lean_run_code`/LSP for cross-ring tile-section defeqs
The prover's definitional-collapse attempt *compiled* under `lean_run_code`/LSP (stale `.olean` artifacts)
but failed a clean `lake env lean`. Provers working tile/cross-ring section defeqs must confirm any
defeq/instance claim with a full `lake env lean` on a minimal external file, never `lean_run_code`/LSP alone.
(Added to PROJECT_STATUS Knowledge Base.)

## Reusable proof pattern discovered (added to Knowledge Base)
- **`Scheme.Hom.comp_image` staging** for collapsing iterated open images, + the affine basic-open image
  recipe (`specAwayToSpec_eq` → `PrimeSpectrum.comap` → `localization_away_comap_range` /
  `comap_basicOpen` / `algebraMap_isUnit` / `basicOpen_mul`). See `tile_image_opens_identities`.

## Coverage debt (leandag unmatched = 1)
- `AlgebraicGeometry.CechAcyclic.affine` — still unmatched (dead/superseded; protected
  `CechHigherDirectImage.lean` design comments reference it; clear at the P5b assembly rework). Sole node.
- `AlgebraicGeometry.tile_image_opens_identities` — CLEARED this iter (review added the `\lean{}` pin to
  the existing `lem:tile_image_opens_identities` block).

## Reviewer reports (full detail)
- lean-auditor `iter042`: SOUND — 15 files audited, 0 must-fix, 0 major (2 pre-authorized sorries), 2 minor
  (planning block comments in `FreePresheafComplex.lean` ~45–100, `PresheafCech.lean` ~34–196 — low-priority
  cleanup, no wrong code). `.archon/task_results/lean-auditor-iter042.md`.
- lean-vs-blueprint-checker `qts`: clean — no must-fix, M-1 (above) major, 2 minor (both informational).
  `.archon/task_results/lean-vs-blueprint-checker-qts.md`.

## LOW (optional cleanup, not blocking)
- The two large planning/strategy block comments in `FreePresheafComplex.lean` and `PresheafCech.lean` are
  development artifacts retained in production code. Harmless; trim opportunistically.
