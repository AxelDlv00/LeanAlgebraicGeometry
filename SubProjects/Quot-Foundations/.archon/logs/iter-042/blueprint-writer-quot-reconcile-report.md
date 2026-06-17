# Blueprint Writer Report

## Slug
quot-reconcile

## Status
COMPLETE — all required edits (A 1–3, B 1–4, C G1-core + gap2) made; DAG verified
(0 conflicts, 0 unknown_uses, isolated unchanged at 2 pre-existing nodes).

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### A. Fixed three stale `\lean{}` pin mismatches
- **Revised** `lem:composite_immersion_flocus_basicOpen` — removed the bad pin
  `compositeBasicOpenImmersion_flocus_image` (no such decl); replaced the STALE-PIN note with an
  absorbed-inline NOTE; kept the block as the mathematical record of its two claims (σ-identity +
  image). Added a statement-level `\uses{lem:composite_immersion_range_basicOpen,
  def:gamma_image_ring_equiv, lem:compositeBasicOpenImmersion_image_basicOpen,
  lem:image_basicOpen_eq_inf}` so claim (a)/(b) point at the real split decls (B2/B3). Rewrote the
  proof prose to route the image claim through B2 + B3.
- **Revised** `lem:gamma_image_iso_semilinear_top` — removed the bad pin
  `gamma_image_iso_semilinear_top`; added NOTE "absorbed inline into
  `\cref{lem:section_localization_hfr_aux}` (the `he₁`/`he₂` hypotheses)"; added statement `\uses` for
  the lower-level semilinearity/naturality/ring-equiv lemmas it is built from.
- **Revised** `lem:flocus_section_scalar_tower` — removed the bad pin `flocus_section_scalar_tower`;
  added the same absorbed-inline NOTE; added statement `\uses{lem:composite_immersion_flocus_basicOpen}`.

### B. Added four missing helper blocks (all matched their Lean decls; previously `unmatched_lean`)
- **Added lemma** `\label{lem:image_basicOpen_of_affine}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.image_basicOpen_of_affine}` — image of `D(f')` under an
  open immersion of affines as a `Spec R` basic open of the appIso-transported section. Proof:
  `basicOpen_eq_of_affine` + `Scheme.image_basicOpen`, immersion kept opaque. (Namespace verified:
  `AlgebraicGeometry.Scheme.Modules`, not elsewhere.)
- **Added lemma** `\label{lem:compositeBasicOpenImmersion_image_basicOpen}` /
  `\lean{…compositeBasicOpenImmersion_image_basicOpen}` — instantiation of the above at the concrete
  composite immersion. `\uses{lem:image_basicOpen_of_affine, def:composite_basic_open_immersion}`.
- **Added lemma** `\label{lem:image_basicOpen_eq_inf}` / `\lean{…image_basicOpen_eq_inf}` —
  `j ''ᵁ D(f') = (j ''ᵁ ⊤) ⊓ D(g)` under the transport hypothesis; proof via `Scheme.basicOpen_res`.
  `\uses{lem:image_basicOpen_of_affine}`.
- **Added lemma** `\label{lem:section_localization_hfr_aux}` / `\lean{…section_localization_hfr_aux}`
  — the opaque-`j` proof engine. `\uses{lem:gamma_image_iso_semilinear_top,
  lem:flocus_section_scalar_tower, lem:isLocalizedModule_powers_transport,
  lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ, lem:gamma_pullback_image_iso,
  lem:gamma_pullback_image_iso_hom_semilinear, lem:gamma_pullback_image_iso_hom_naturality,
  def:gamma_image_ring_equiv}` — i.e. it now carries the full assembly that the three A-blocks
  describe. Proof prose records the **load-bearing lesson**: the immersion must stay opaque or the
  closing `whnf` blows past 3.2M heartbeats; abstract `j` closes within 1.6M.

### C. G1-core + gap2 made prover-ready (no `\leanok` added)
- **Revised** `lem:section_localization_hfr_basicOpen` (the wrapper, already `\leanok`) — re-pointed its
  `\uses` (statement + proof) to `{lem:section_localization_hfr_aux,
  lem:pullback_composite_immersion_isIso_fromTildeΓ, lem:composite_immersion_range_basicOpen,
  lem:image_basicOpen_eq_inf, lem:composite_immersion_flocus_basicOpen, def:gamma_image_ring_equiv,
  def:composite_basic_open_immersion}`; dropped the absorbed lemmas (`gamma_image_iso_semilinear_top`,
  `flocus_section_scalar_tower`) and the lower infra now living inside the aux. Slimmed the proof to a
  thin instantiation of the aux (P1 datum, choice of `f'`, opens identifications). Updated its NOTE
  (the core now has its own block).
- **Revised** `lem:qcoh_affine_section_localization` (G1-core) — set the statement `\uses` to
  `{lem:qcoh_affine_isIso_fromTildeΓ, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ,
  lem:isLocalization_basicOpen_mathlib}` per directive. KEPT the `% NOTE: the Lean decl does NOT yet
  exist`. (Proof prose/`\uses` unchanged — it already states the one-line gap1 corollary; see Notes.)
- **Revised** `lem:qcoh_section_localization_basicOpen` (gap2) — added
  `\uses{lem:qcoh_affine_section_localization}` (statement + proof); rewrote part (2) of the proof as
  the **gap-2 transport**: `U` affine ⇒ `U ≅ Spec Γ(X,U)`, push `M|_U` to a quasi-coherent `M'` on
  that affine, apply G1-core, transport the `IsLocalizedModule` property back. KEPT its future NOTE.
  Flagged the one genuinely-new ingredient explicitly (see Notes / Strategy).

## Cross-references introduced
- A1 → `lem:compositeBasicOpenImmersion_image_basicOpen`, `lem:image_basicOpen_eq_inf` (new B2/B3) —
  both exist in this chapter (added this session). Verified via leandag.
- B2/B3 → `lem:image_basicOpen_of_affine` (new B1) — verified.
- B4 (aux) → `lem:gamma_image_iso_semilinear_top`, `lem:flocus_section_scalar_tower` (A2/A3) and the
  six infra lemmas — all verified present.
- wrapper → `lem:section_localization_hfr_aux` (new B4) — verified.
- gap2 → `lem:qcoh_affine_section_localization` (G1-core) — verified.
- All `\uses` resolve (`leandag`: `unknown_uses: []`, `conflicts: []`).

## References consulted
None opened this session — this was a Lean↔blueprint reconciliation of project-bespoke
implementation helpers (no external `% SOURCE` blocks added or altered). The existing Stacks/Hartshorne
citation comments on `lem:qcoh_affine_section_localization` and `lem:qcoh_section_localization_basicOpen`
were left verbatim and untouched.

## Macros needed (if any)
None. All notation (`\Spec`, `\Gamma`, `''^{U}`, `\Gamma\Spec\text{-iso}`, `\sqcap`, etc.) is already
in use elsewhere in the chapter.

## Notes for Plan Agent
- **G1-core `\uses` divergence (minor, applied as directed).** The directive's specified third
  dependency `lem:isLocalization_basicOpen_mathlib` is a *background* fact (the ring localization
  `IsLocalization.Away f`), not a step in the one-line Lean proof, which is literally
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ M.fromTildeΓ (isIso_fromTildeΓ_of_isQuasicoherent hqc)`
  — only gap1 + the affine engine are load-bearing. I applied the directive's set verbatim on the
  STATEMENT block and left the PROOF block's `\uses` (gap1 + affine engine +
  `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`, the latter cited only for the interderivability
  remark). No cycle results (the iff lemma does not depend back on G1-core). Prover can close G1-core
  in one line.
- **gap2 proof is single-chart transport, NOT cover-and-glue.** The directive sketched "cover X by
  affine opens `Spec A_i`, apply G1-core on each, glue". But the blueprint *statement* already fixes
  `U` affine, so the correct and minimal argument reduces to the single chart `Spec Γ(X,U)` — there is
  no second cover of `X` and no nested-gluing ("infinite onion") risk. I wrote the single-chart
  transport and said so explicitly in the prose. The **one genuinely new ingredient** the prover must
  build (no Mathlib lemma packages it): transport of the `IsLocalizedModule` predicate across the
  affine iso `φ : U ≅ Spec Γ(X,U)` (carrying `M|_U` to the quasi-coherent `M'` and `D(f)` to the
  standard `D(f)`). This is a single affine-isomorphism transport — flagged in the proof body.
- **`compositeBasicOpenImmersion_image_basicOpen` is unused by any Lean proof.** Per the iter-041
  checker and my grep, the Lean decl `compositeBasicOpenImmersion_image_basicOpen` (line 2038) is
  defined but never invoked in the Lean file — the wrapper `section_localization_hfr_basicOpen` calls
  `image_basicOpen_eq_inf` directly. In the blueprint I wired it as a dependency of the math-record
  block A1 (`lem:composite_immersion_flocus_basicOpen`) so it is not a dead-end DAG node, but the
  underlying Lean decl is dead code; the planner may want a prover to either delete it or route the
  wrapper through it for consistency.
- The two project-wide isolated nodes (`lem:annihilator_localization_eq_map` /
  `lem:modules_annihilator_ideal_le` and `lem:gr_det_one_updateCol`) are pre-existing and out of scope
  per the directive.

## Strategy-modifying findings
None that block work, but one to record for STRATEGY.md tracking: the gap2 keystone
(`lem:qcoh_section_localization_basicOpen`) does **not** require an affine-cover gluing apparatus as
the strategy framing suggested — because the statement fixes `U` affine, gap2 is exactly G1-core on
the single chart `Spec Γ(X,U)` plus a one-shot `IsLocalizedModule`-across-affine-iso transport. If the
strategy intends a general (non-affine `U`) keystone, the statement would need to change and a genuine
cover-and-glue would re-enter; as currently stated, no new gluing lemma is needed.
