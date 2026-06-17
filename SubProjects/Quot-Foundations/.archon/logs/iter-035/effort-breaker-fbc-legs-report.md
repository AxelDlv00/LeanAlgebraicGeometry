# Effort Breaker Report

## Slug
fbc-legs

## Target
`lem:base_change_mate_fstar_reindex_legs` (`AlgebraicGeometry.base_change_mate_fstar_reindex_legs`)

## Status
COMPLETE — the conj-1+conj-2 step is re-broken into an atomic `\uses`-linked chain; the target's
proof is now a thin wrapper invoking it. Every gap the old inline conjugate-side proof crossed is
covered by a named sub-lemma. No `.lean` was touched (blueprint only).

## Effort before → after
- target `effort_local`: **3297 → 1220** (and `effort_total` 3297 → 5646, i.e. the cone now carries
  the explicit sub-lemmas instead of one opaque blob).
- sub-lemmas added: **8** (6 build-target lemmas/def + 2 Mathlib anchors).

## Chain added (target ← conj-2a ← {conj-2b, conj-2c, conj-2d} ; conj-2a ← conj-1a ; target ← conj-1b ← conj-1a)
Bottom-up, all in `chapters/Cohomology_FlatBaseChange.tex`, inserted just before the target block:

- **(anchor)** `lem:conjugateEquiv_comp_mathlib` `\mathlibok` — `CategoryTheory.conjugateEquiv_comp`
  (verified present in pinned Mathlib, Mates.lean; exact statement
  `conj α ≫ conj β = conj (β ≫ α)`, `@[reassoc (attr := simp)]`). Lead of the reassoc conjugate
  simp set.
- **(anchor)** `lem:conjugateEquiv_symm_comp_mathlib` `\mathlibok` — `CategoryTheory.conjugateEquiv_symm_comp`
  (verified present). Inverse-direction companion.
- **(conj-1a)** `lem:base_change_mate_codomain_read_legs_conj`
  `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs_conj}` — the codomain read rebuilt
  proof-free, pullback factor taken as `leftAdjointCompIso` of the free legs `e`, `Spec ιA` (square via
  `pushforwardCongr`/`pushforwardComp`), no `hfst/hsnd`. `\uses{pullbackComp_eq_leftAdjointCompIso (conj-0′),
  leftAdjointCompIso_mathlib, conjugateEquiv_leftAdjointCompIso_inv_mathlib, pullback_spec_tilde_iso,
  pushforward_spec_tilde_iso}` (effort ≈ 763).
- **(conj-1b)** `lem:base_change_mate_codomain_read_legs_conj_eq`
  `\lean{…_conj_eq}` — the conjugate-native read equals the leg-parametrised read (hence the concrete
  read at the projection legs), so the green `base_change_mate_fstar_reindex` reduction stays
  defeq-unchanged. `\uses{conj-1a, codomain_read_legs, codomain_read}` (effort ≈ 694).
- **(conj-2b)** `lem:base_change_mate_reindex_conj_pullbackLeg`
  `\lean{…reindex_conj_pullbackLeg}` — the pullback-side leg: conjugate of the inverse composite
  comparison is `e`, conjugate of inverse `pullbackComp` is `pushforwardComp.hom`.
  `\uses{conjugateEquiv_pullbackComp_inv_mathlib, conjugateEquiv_leftAdjointCompIso_inv_mathlib,
  pullbackComp_eq_leftAdjointCompIso}` (effort ≈ 434).
- **(conj-2c)** `lem:base_change_mate_reindex_conj_pushforwardCollapse`
  `\lean{…reindex_conj_pushforwardCollapse}` — pushforward-side collapse of the three transparent
  Γ-coherences. `\uses{gammaMap_pushforwardComp_hom_eq_id, _inv_eq_id, gammaMap_pushforwardCongr_hom}`
  (effort ≈ 416).
- **(conj-2d)** `lem:base_change_mate_reindex_conj_crossLayer`
  `\lean{…reindex_conj_crossLayer}` — the cross-layer `gammaPushforwardIso ψ` transport: F2 unit
  cancels the read's `unit_iso.symm` via `unit_conjugateEquiv_symm` raised one layer by
  `conjugateEquiv_comp`; survivor evaluates to ρ by Seam 1. `\uses{base_change_mate_unit_value,
  unit_conjugateEquiv_symm_mathlib, conjugateEquiv_comp_mathlib, gammaPushforwardIso}` (effort ≈ 768).
- **(conj-2a)** `lem:base_change_mate_fstar_reindex_legs_conj`
  `\lean{…fstar_reindex_legs_conj}` — the leg-reindex coherence on the conjugate side (= ρ), against
  the conjugate-native read. Proof = `conjugateEquiv.injective` + `.surjective` lift + the reassoc
  conjugate simp set, closed by conj-2b/2c/2d. `\uses{conj-1a, conjugateIsoEquiv_mathlib,
  iterated_mateEquiv_conjugateEquiv_mathlib, conjugateEquiv_comp_mathlib, conjugateEquiv_symm_comp_mathlib,
  conj-2b, conj-2c, conj-2d, def:base_change_mate_inner_value}` (effort ≈ 1351).
- **Target `lem:base_change_mate_fstar_reindex_legs` proof rewritten** (this is the directive's
  "conj-2e — assemble"): thin wrapper — instantiate conj-2a, bridge codomain read by conj-1b.
  `\uses{base_change_mate_fstar_reindex_legs_conj (conj-2a), base_change_mate_codomain_read_legs_conj_eq
  (conj-1b), base_change_mate_codomain_read_legs, def:base_change_mate_inner_value}`.

The isolated `\mathlibok` anchor `lem:iterated_mateEquiv_conjugateEquiv_mathlib` (Beck–Chevalley
"iterated mate = conjugate") is now consumed by conj-2a's `\uses{}` — it is the abstract certificate
that the comparison is a conjugate — so it is no longer orphaned.

## Deviation from the directive's literal 7-way split (documented)
The directive listed conj-2a ("restate") and conj-2e ("assemble") as two items with disjoint `\uses`.
A statement and its own proof cannot be two separate DAG nodes, so I realized them as:
**conj-2a = the bulk conjugate identity** (`…_legs_conj`, which carries the `injective`/`surjective`
discharge consuming conj-2b/2c/2d + the reassoc simp set) and **the target proof = the thin wrapper**
(instantiate conj-2a, bridge by conj-1b). The resulting `\uses` cone is identical to the directive's
intent (conj-2b/2c/2d, conj-1a, conjugateIsoEquiv, the simp set, and conj-1b all in the target's
ancestor set — verified). This is the standard effort-breaker shape (bulk lemma + target wrapper) and
keeps every node "one mathematical claim".

## Still hard (re-break candidates)
- `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a, effort ≈ 1351) is the heaviest remaining
  node — it is the `injective`-lift + `surjective`-free-variable + reassoc-simp-set close that
  *orchestrates* conj-2b/2c/2d. It is now genuinely one move (the conjugate-lift idiom from
  `analogies/fbc-mate-reencode.md` L70–77 / `leftAdjointCompNatTrans_assoc`-style one-`simp` close),
  with all three legs pre-proven. If the prover still cannot close it in one attempt, re-dispatch the
  breaker on conj-2a alone, splitting the `surjective`-lift bookkeeping (the `obtain ⟨τ, rfl⟩` per
  transformation) from the final reassoc-simp close.

## Could not decompose (strategy items)
None. Every conjugate lemma the chain needs has a Mathlib or project home:
- reassoc conjugate **composition** simp lemmas: `CategoryTheory.conjugateEquiv_comp` /
  `_symm_comp` — verified present, now anchored.
- the **whiskering/associator** members of that simp set (`conjugateEquiv_whiskerLeft/Right`,
  `conjugateEquiv_associator_hom` cited in `fbc-mate-reencode.md`) did **not** resolve under those exact
  `CategoryTheory.*` names in local search, so I did **not** invent `\mathlibok` labels for them; they
  are referenced in prose only (as "the conjugation whiskering and associator coherences of the same
  Mathlib family"). If conj-2a's prover needs them as named `\uses` anchors, confirm their real Mathlib
  names (they live in the same Mates.lean / Bicategory.Adjunction.Mate family) and anchor then — this is
  a minor follow-up, not a blocker.

## References consulted
- `analogies/fbc-mate-reencode.md` — the conjugate-side recipe (Top suggestion, L128–146) and the
  `leftAdjointCompIso` / `conjugateEquiv_pullbackComp_inv` / `unit_conjugateEquiv_symm` analogues that
  the chain cuts along. (No `references/**` source needed: the chain is bespoke adjoint-mate calculus
  over already-proved dictionaries + the conj-0 foundation, so no `% SOURCE` citation applies, matching
  the existing iii-* lemmas.)

## Notes for dispatcher
- `\lean{}` names I assigned by convention (the prover creates these decls — none exist yet):
  `AlgebraicGeometry.base_change_mate_codomain_read_legs_conj` (a `def`/`noncomputable def`, modeled on
  the existing `base_change_mate_codomain_read_legs` def, Lean L1254), `…_conj_eq`,
  `…_reindex_conj_pullbackLeg`, `…_reindex_conj_pushforwardCollapse`, `…_reindex_conj_crossLayer`,
  `…_fstar_reindex_legs_conj`.
- conj-1a should be cut as a `def` (it builds an iso object), the rest as `theorem`/`lemma`.
- The existing `_legs` Lean body (FlatBaseChange.lean L1425–1539) ends in `sorry`; do NOT edit it as
  part of this break — the prover replaces it per the rewritten blueprint proof. The superseded
  direct-on-sections wrappers (`…_legs_unitExpand`/`…_gammaDistribute`/`…_link_distributeCollapse`)
  keep their NOTEs and are untouched.
- `\leanok` was NOT added anywhere (sync_leanok's job). `\mathlibok` added only on the two verified
  Mathlib conjugate-composition anchors.

## Return
COMPLETE — `_legs` re-expressed as the conj-1a..conj-2a chain + thin wrapper; effort 3297 → 1220, 8
nodes added, DAG clean (no broken `\uses`, braces/environments balanced), `iterated_mateEquiv` anchor
de-orphaned.
