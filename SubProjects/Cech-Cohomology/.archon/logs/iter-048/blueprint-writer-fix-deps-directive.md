# Blueprint-writer directive — chapter `Cohomology_CechHigherDirectImage.tex`

## Scope
Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. Four structural fixes
to reconcile the blueprint with the Lean that landed in iter-047 (the Route-B keystone
`qcoh_section_isLocalizedModule` + its packaged-iso corollary `qcoh_section_kernel_comparison`,
both axiom-clean). DO NOT touch any `\leanok` markers (the deterministic sync owns them). DO NOT
edit the `lem:qcoh_isIso_fromTildeGamma` block — it is already correct.

## Background (what the Lean actually does)
The lean-vs-blueprint checker (iter-047) confirmed a real DAG error. In Lean:
- `qcoh_section_isLocalizedModule` (the KEYSTONE) is proved **directly** via a new abstract
  algebra lemma `isLocalizedModule_of_exact` (a left-exact-ladder kernel comparison) over the two
  `qcoh_section_equalizer` rows + the per-tile/overlap localizations. It does NOT call
  `qcoh_section_kernel_comparison`.
- `qcoh_section_kernel_comparison` is a **one-liner corollary**: `IsLocalizedModule.iso ρ_f`,
  derived FROM the keystone. Its only real dependency is `qcoh_section_isLocalizedModule` (plus the
  Mathlib `IsLocalizedModule.iso`/`.linearEquiv` anchor).

The blueprint currently has the `\uses` edge reversed (`qcoh_section_isLocalizedModule \uses
qcoh_section_kernel_comparison`) and the two proof blocks describe each other's content. Both blocks
already carry `% NOTE:` comments self-flagging this. No circularity exists in either direction.

## Fix 1 — Author a new node `lem:isLocalizedModule_of_exact` (Archon-original; no external source)
This abstract algebra primitive landed in Lean as `AlgebraicGeometry.isLocalizedModule_of_exact`
(public, axiom-clean). It is the converse of Mathlib's `IsLocalizedModule.map_exact`. Place the new
`\begin{lemma} … \end{lemma}` + `\begin{proof} … \end{proof}` block immediately BEFORE the
`lem:qcoh_section_kernel_comparison` block (so it precedes its consumers). Use:

- `\label{lem:isLocalizedModule_of_exact}`
- `\lean{AlgebraicGeometry.isLocalizedModule_of_exact}`
- `\uses{}` for the statement: empty or only generic Mathlib-algebra anchors if any exist; this is a
  pure diagram chase over `Function.Exact` + `IsLocalizedModule`, no project deps.
- NO `% SOURCE` / `% SOURCE QUOTE` lines — this is a project-bespoke abstract lemma (the descriptor
  says omit the source lines for Archon-original results). It stands on its proof sketch alone.

Statement (project notation): Let `S ⊆ R` be a submonoid and consider a commutative ladder of
`R`-modules
```
   A  --i-->  B  --p-->  C
   |a         |b         |c
   A' --i'--> B' --p'--> C'
```
with both rows left-exact (`i`, `i'` injective and `Function.Exact i p`, `Function.Exact i' p'`),
and suppose the two right-hand verticals `b : B → B'` and `c : C → C'` are localization maps at `S`
(`IsLocalizedModule S b`, `IsLocalizedModule S c`). Then the left vertical `a : A → A'` is a
localization map at `S` (`IsLocalizedModule S a`).

Proof sketch (one short paragraph, mathematical — NO Lean tactics): verify the three
`IsLocalizedModule` clauses for `a` by diagram chase. (i) `map_units`: for `s ∈ S`, `s • -` on `A'`
is bijective because it is bijective on `B'` (from `b`'s `map_units`) and `A'` is the kernel of
`p'` (left-exactness), which `s • -` preserves; surjectivity onto `A'` uses exactness of the bottom
row to descend a preimage from `B'`. (ii) `surj` (every element of `A'` is `s⁻¹ • a(x)`): lift along
`b`'s surjectivity to get `B`, clear the `C`-component using `c`'s `exists_of_eq`, then use top-row
exactness to find the preimage in `A`. (iii) `exists_of_eq`: descends from `b`'s `exists_of_eq`
using injectivity of `i`. Conclude `IsLocalizedModule S a`.

## Fix 2 — Flip the `\uses` edges
- In `lem:qcoh_section_isLocalizedModule` (BOTH the statement `\uses{}` near \label and the proof
  `\uses{}`): **remove** `lem:qcoh_section_kernel_comparison`; **add** `lem:isLocalizedModule_of_exact`.
  Keep `lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer,
  lem:localized_module_map_exact_mathlib, lem:tile_section_localization,
  lem:section_isLocalizedModule_of_presentation`.
- In `lem:qcoh_section_kernel_comparison` (BOTH statement and proof `\uses{}`): **replace** the
  current dep list with just `lem:qcoh_section_isLocalizedModule` plus the Mathlib anchor for the
  packaged iso. A `lem:isLocalizedModule_linearEquiv_mathlib` anchor already exists (line ~3900,
  `\lean{IsLocalizedModule.linearEquiv}`) — use it; the Lean uses `IsLocalizedModule.iso`, which is
  the same packaging idiom, so that anchor is the correct reference.

## Fix 3 — Reconcile the two proof blocks (the equalizer chase belongs to the keystone)
- Move the full equalizer→localize→match→kernels chase (currently in the
  `lem:qcoh_section_kernel_comparison` PROOF block) into the `lem:qcoh_section_isLocalizedModule`
  PROOF block, naming `isLocalizedModule_of_exact` (Lemma~\ref{lem:isLocalizedModule_of_exact}) as
  the closing step that passes the two left-exact rows + the two localized verticals to the abstract
  kernel comparison. The keystone proof currently delegates to `kernel_comparison`; rewrite it to
  carry the chase itself.
- Make the `lem:qcoh_section_kernel_comparison` PROOF block a one-liner: "Immediate from the keystone
  Lemma~\ref{lem:qcoh_section_isLocalizedModule}: package the localization map `ρ_f` as a linear
  equivalence via `IsLocalizedModule.iso` (Lemma~\ref{lem:isLocalizedModule_linearEquiv_mathlib})."
- Update / remove the now-stale `% NOTE:` comments on both blocks so they describe the corrected
  state (the inversion is fixed; the chase now lives in the keystone block).

## Fix 4 — Coverage note for `overlap_section_localization` + bundle the bookkeeping privates
Three private Lean helpers landed iter-047 with no blueprint entry:
- `AlgebraicGeometry.overlap_section_localization` — near-substantive: the per-overlap version of
  `tile_section_localization` (for `g = a·b`, transported along `D(a·b)=D(a)⊓D(b)` and
  `D((a·b)·f)=D(a·f)⊓D(b·f)`), consumed directly by the keystone. Give it a SHORT one-paragraph node
  `\label{lem:overlap_section_localization}` `\lean{AlgebraicGeometry.overlap_section_localization}`
  `\uses{lem:tile_section_localization}` (Archon-derived corollary; no external source), and add
  `lem:overlap_section_localization` to the keystone's proof `\uses`.
- `AlgebraicGeometry.overlap_target_eq` and `AlgebraicGeometry.presheaf_map_comp₂_apply` — pure
  bookkeeping (a `basicOpen` lattice identity and a triple-presheaf-map fold). Bundle each into the
  `\lean{...}` list of a related node (e.g. append them to the `\lean{}` of
  `lem:overlap_section_localization`, whose proof uses both) so `archon dag-query unmatched` clears.

## Verification (for your report)
List the exact `\uses{}` lists you set on `lem:qcoh_section_isLocalizedModule` and
`lem:qcoh_section_kernel_comparison` after the flip, and the `\lean{...}` lists where you bundled
the three private helpers. Confirm `lem:isLocalizedModule_of_exact` and
`lem:overlap_section_localization` each have a statement, proof, `\label`, `\lean`, and `\uses`.
Do not add `\leanok`.
