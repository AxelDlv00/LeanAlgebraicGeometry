# Blueprint Writer Report

## Slug
quot-producer

## Status
COMPLETE — all four tasks done; leandag reports 0 isolated nodes, 0 unknown_uses, 0 conflicts; the
eight already-built Lean decls now match their new blueprint blocks.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### TASK 1 — re-routed the `lem:section_localization_descent` keystone through the basic-open form
- **Revised** `lem:section_localization_descent` (lemma block `\uses`) — replaced
  `lem:section_localization_descent_of_cover` with
  `lem:section_localization_descent_of_basicOpen_cover`, and added
  `lem:section_localization_hfr_basicOpen` + `lem:isLocalizedModule_powers_transport`.
- **Revised** the in-block `% NOTE` lines — now state the consuming chain (basic-open cover form,
  combiner bridges I/II, iso-invariance) is all axiom-clean and the keystone is blocked ONLY on the
  geometric producer `lem:section_localization_hfr_basicOpen`; added the explicit note that the
  general-U `_of_cover` form's `Hfr` is not instantiable for a quasi-coherent `M` (general opens of
  `Spec R_r` need not be quasi-compact) and that the engines only consult `Hfr` at basic opens / their
  products `D(r·r')`.
- **Revised** the proof block — swapped `\uses` to the basic-open form + added the producer +
  combiner; rewrote the prose to demand `Hfr` only at basic opens `D(s) ≤ D(r)` and to delegate the
  geometric construction to `lem:section_localization_hfr_basicOpen`.
- Stacks `lemma-invert-f-sections` SOURCE/SOURCE QUOTE comments left intact.

### TASK 2 — three DAG-unmatched feeder blocks (already proved axiom-clean)
- **Added lemma** `lem:section_localization_descent_of_basicOpen_cover`
  /`\lean{…isLocalizedModule_basicOpen_descent_of_basicOpen_cover}` — basic-open cover form; thin
  wrapper over the cover form; `\uses` the cover form + `descent_surj` + `descent_smul_eq_zero` +
  `map_units_restrict_basicOpen` + the gluing anchors. Keeps the Stacks citation; `% NOTE` records why
  the general-U form's `Hfr` is undischargeable. (placed after the cover-form proof)
- **Added lemma** `lem:isLocalizedModule_powers_transport`
  /`\lean{…isLocalizedModule_powers_transport}` — the combiner of bridges (I)+(II);
  `\uses{lem:isLocalizedModule_ringEquiv_semilinear, lem:isLocalizedModule_restrictScalars_powers_algebraMap}`;
  proof chains (I), rewrites the submonoid via `Submonoid.map_powers` + `σ f' = algebraMap R A f`, then
  descends by (II). (placed after the bridge-II block)
- **Added lemma** `lem:isIso_fromTildeΓ_of_iso` /`\lean{…isIso_fromTildeΓ_of_iso}` — iso-invariance of
  `IsIso fromTildeΓ`; `\uses{lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict}`; one-line essImage
  proof. (placed just before the named descent)

### TASK 3 — new subsection "Section-transport producer for the basic-open Hfr"
TOP lemma + four sub-lemmas, all `\uses`-linked, all intended-name pins (Lean decls do NOT yet exist):
- **Added lemma** `lem:section_localization_hfr_basicOpen` /`\lean{…section_localization_hfr_basicOpen}`
  (TOP) — produces the basic-open `Hfr` datum; full assembly proof feeding the combiner. `\uses` the
  four sub-lemmas + combiner + `isLocalizedModule_restrict_of_isIso_fromTildeΓ` + `isIso_fromTildeΓ_of_iso`
  + `pullback_gamma_top_iso` + `gamma_pullback_image_iso` + `gamma_pullback_image_iso_hom_semilinear`
  + `def:gamma_image_ring_equiv` + P1.
- **Added lemma** (a) `lem:pullback_composite_immersion_isIso_fromTildeΓ` — pseudofunctorial iterated
  pullback iso + P1 transport via 2.3.
- **Added lemma** (b) `lem:composite_immersion_range_basicOpen` — `j.opensRange = D(s)`,
  `j ''ᵁ D(f') = D(f)⊓D(s)`, `σ f' = algebraMap R R_s f`.
- **Added lemma** (c) `lem:gamma_image_iso_semilinear_top` — upgrades the `D(f')`-level semilinearity to
  the ⊤-level `σ` via naturality of `gammaImageRingEquiv` + the section-transport naturality.
- **Added lemma** (d) `lem:flocus_section_scalar_tower` — the `A`-module + `IsScalarTower R A` instances
  on the f-locus sections.
- Added the `% NOTE` on the alternative three-`gamma_pullback_image_iso` route (the prover picks).

### TASK 4 — five coverage blocks for the gap1-D engines (DAG-unmatched, now matched)
All terse, all under the cover-descent neighbourhood, wired by REAL dependency edges (see note below):
- **Added lemma** `lem:res_comp` /`\lean{…res_comp}`.
- **Added lemma** `lem:iSup_basicOpen_subtype_eq_top` /`\lean{…iSup_basicOpen_subtype_eq_top}`.
- **Added lemma** `lem:descent_overlap_agree` /`\lean{…descent_overlap_agree}` — `\uses{lem:res_comp}`.
- **Added lemma** `lem:descent_surj` /`\lean{…descent_surj}` — `\uses` overlap_agree, res_comp,
  iSup, gluing, eq_of_locally_eq.
- **Added lemma** `lem:descent_smul_eq_zero` /`\lean{…descent_smul_eq_zero}` — `\uses` iSup,
  eq_of_locally_eq, res_comp.

## Cross-references introduced
All new `\uses` targets verified present in this chapter; leandag `unknown_uses` is empty. Notable
forward references (resolve in this same chapter):
- `lem:section_localization_descent` and `lem:section_localization_descent_of_basicOpen_cover` →
  `lem:section_localization_hfr_basicOpen` (the producer, defined later in the chapter).
- `lem:isLocalizedModule_powers_transport` → bridges (I)/(II) (defined earlier).

## Wiring decision (TASK 4)
The directive offered `\uses{lem:section_localization_descent_of_cover}` on the engine blocks as an
anchoring option. I instead wired them by their TRUE mathematical dependencies: the basic-open cover
form `\uses` `descent_surj`/`descent_smul_eq_zero`, which in turn `\uses` `descent_overlap_agree`,
`res_comp`, `iSup_basicOpen_subtype_eq_top`. This keeps every engine in the cover-descent
neighbourhood AND connected (leandag: 0 isolated) without the backwards edge "engine depends on the
full descent". No helper was judged better left private — terse blocks for all five (the edges are
worth more than the brevity).

## References consulted
- `references/summary.md` — index; confirmed the Stacks `lemma-invert-f-sections` (Properties of
  Schemes, "Sections over principal opens") pointer for the descent statement, already cited in the
  existing blocks; no new verbatim quote was needed (the new blocks are project-bespoke / internal
  engine steps and re-use the already-transcribed Stacks quote on the keystone).

## Reference-retriever dispatches
None — no new source material was required (all new blocks are project-internal or descend from the
already-cited Stacks `lemma-invert-f-sections`).

## Macros needed
None — all macros used (`\Spec`, `\mathrm`, `\widetilde`, `\cref`, `\sqcap`, `\simeq_+` via `\simeq_+`)
were already in use in the chapter.

## Notes for Plan Agent
- The four TASK 3 producer decls (`pullback_composite_immersion_isIso_fromTildeΓ`,
  `composite_immersion_range_basicOpen`, `gamma_image_iso_semilinear_top`,
  `flocus_section_scalar_tower`) and the TOP `section_localization_hfr_basicOpen` are intended-name
  pins; they are the `mathlib-build` target for the next prover. leandag counts them as unproved
  blueprint nodes (correct).
- leandag summary after edits: 407 blueprint nodes, 882 edges, 8 isolated PRE-EXISTING nodes elsewhere
  in the project (NONE in the descent/producer neighbourhood — my additions added 0 isolated). 9
  `with_sorry` nodes include the five new producer pins.

## Strategy-modifying findings
None. The chapter now reflects the established strategy (keystone blocked solely on the geometric
producer; everything downstream axiom-clean).
