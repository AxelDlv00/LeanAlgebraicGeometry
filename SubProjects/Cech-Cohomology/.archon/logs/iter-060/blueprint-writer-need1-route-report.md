# Blueprint Writer Report

## Slug
need1-route

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task 1 — hjt rewritten to the corepresentability route
- **Rewrote** `lem:jshriek_transport_along_iso` (`\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}`).
  - Statement+proof `\uses{}` now `def:jshriek_ou, lem:sectionsFunctorCorepIso,
    lem:compCoyonedaIso_mathlib, lem:coyoneda_fullyFaithful_mathlib` (dropped the three obsolete lemmas).
  - Proof replaced with the 3-step corepresentability chain: (1) `compCoyonedaIso` on `Φ`'s adjunction,
    (2) `sectionsFunctorCorepIso` whiskered to types, (3) the `Φ.inverse ∘ sectionsFunctor V =
    sectionsFunctor(φ.inv⁻¹V)` definitional relabel, then reflect via `coyoneda` full faithfulness.
    Removed the "unfold + chase three commutations / deep adjunction-mate" framing entirely.
  - Statement target object changed from `j_!\mathcal{O}_{\varphi.hom''V}` to
    `j_!\mathcal{O}_{\varphi.inv^{-1}V}` (matches the Lean target `jShriekOU (φ.inv ⁻¹ᵁ V)`), with an
    "i.e. the image open of \(V\) in \(Y\)" clause so it stays consistent with the consumer's `V'`.
  - Kept the `\lean{}` pin and `% NOTE: build target` comment.
- **Added Mathlib anchor** `lem:compCoyonedaIso_mathlib` (`\lean{CategoryTheory.Adjunction.compCoyonedaIso}`, `\mathlibok`).
- **Added Mathlib anchor** `lem:coyoneda_fullyFaithful_mathlib` (`\lean{CategoryTheory.Coyoneda.fullyFaithful}`, `\mathlibok`).
- **Did NOT add a `sectionsFunctorCorepIso` block** — the directive asked for it as a helper anchor, but it
  already exists in this chapter at `\label{lem:sectionsFunctorCorepIso}`
  (`\lean{AlgebraicGeometry.sectionsFunctorCorepIso}`, with proof). Adding a second block would duplicate
  the label and break the DAG. hjt now `\uses{}` the existing block.

### Task 2 — deleted three obsolete sub-lemma blocks
- **Removed** `lem:pushforward_commutes_free`, `lem:pushforward_commutes_sheafify`,
  `lem:yoneda_transport_along_homeo` (full lemma+proof environments). Verified by grep that no
  `\uses{}`/`\ref{}` to these labels remains anywhere in the chapter (or any sibling chapter).

### Task 3 — hqc rewritten to the `of_coversTop`/R1 route
- **Rewrote** `lem:pushforward_iso_preserves_qcoh` proof to the `QuasicoherentData` transport: extract
  local datum (`nonempty_quasicoherentData`), image cover, `of_coversTop`, per-member transport via
  `pushforwardPushforwardEquivalence` + `Presentation.map` + the R1 comparison iso + `Presentation.ofIsIso`.
  Statement+proof `\uses{}` updated to `lem:pushforward_commutes_restriction,
  lem:pushforwardPushforwardEquivalence_mathlib, lem:presentation_map_mathlib,
  lem:isQuasicoherent_of_coversTop_mathlib, lem:nonempty_quasicoherentData_mathlib,
  lem:presentation_ofIsIso_mathlib, lem:isAffineOpen_image_of_iso_mathlib`. Kept the
  `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source}` Stacks block verbatim and the `\lean{}` pin.
- **Added R1 lemma** `lem:pushforward_commutes_restriction`
  (`\lean{AlgebraicGeometry.pushforward_commutes_restriction}`, build-target, `% NOTE`) — the comparison
  iso `e_i.functor.obj(H.over V) ≅ (Φ_*H).over V'`. `\uses{lem:pushforwardPushforwardEquivalence_mathlib,
  lem:restrict_obj_mathlib}`; proof = the open-by-open section identification (restriction-of-objects
  identity), framed as the open-restriction analogue of the `bind` per-piece transport.
- **Added Mathlib anchor** `lem:isQuasicoherent_of_coversTop_mathlib`
  (`\lean{SheafOfModules.IsQuasicoherent.of_coversTop}`, `\mathlibok`).
- **Added Mathlib anchor** `lem:nonempty_quasicoherentData_mathlib`
  (`\lean{SheafOfModules.IsQuasicoherent.nonempty_quasicoherentData}`, `\mathlibok`).
- **Did NOT add a separate generic `isQuasicoherent_pushforwardEquivOfIso` engine.** The existing
  `pushforward_iso_preserves_qcoh` statement is already generic in `φ : X ≅ Y` (the consumer
  `modules_isoSpec_ext_transport` instantiates at `isoSpec`), so the of_coversTop skeleton lives directly
  in its proof — no extra indirection needed. The `\lean{}` pin stays on the consumer.

## Cross-references introduced
- hjt `\uses{lem:sectionsFunctorCorepIso}` — exists in this chapter (line ~8923).
- hjt `\uses{lem:compCoyonedaIso_mathlib, lem:coyoneda_fullyFaithful_mathlib}` — both added this round.
- hqc `\uses{lem:pushforward_commutes_restriction}` — added this round (R1).
- hqc `\uses{lem:isQuasicoherent_of_coversTop_mathlib, lem:nonempty_quasicoherentData_mathlib}` — added.
- hqc `\uses{lem:presentation_map_mathlib, lem:presentation_ofIsIso_mathlib,
  lem:pushforwardPushforwardEquivalence_mathlib, lem:isAffineOpen_image_of_iso_mathlib}` — pre-existing anchors.
- R1 `\uses{lem:pushforwardPushforwardEquivalence_mathlib, lem:restrict_obj_mathlib}` — pre-existing anchors.

## leandag verification
`leandag build --json`: `unknown_uses: []`, `conflicts: []`. Isolated = 1, which is a single pre-existing
`lean_aux` node (a Lean decl with no blueprint match) — not introduced by this round; all blocks I added
or rewrote are wired into the graph. LaTeX environments balanced (lemma 205/205, proof 151/151,
enumerate 15/15, begin/end 423/423).

## References consulted
- No new external references read this round. The hqc `% SOURCE QUOTE` Stacks block was preserved
  verbatim from the prior revision (already on disk; not re-fabricated). The route is project/Mathlib
  infrastructure, not new external theory, so no reference-retriever was dispatched.

## Macros needed (if any)
- None new. `\restriction` (used in R1/hqc for `X.Modules ⇂ V`) is already provided in
  `blueprint/src/macros/common.tex`.

## Notes for Plan Agent
- The consumer `lem:modules_isoSpec_ext_transport` (out of scope) still writes the image open as
  `V' = \varphi.\mathrm{hom}\,{''}\,V`, whereas the rewritten hjt now writes `\varphi.\mathrm{inv}^{-1}V`.
  These denote the same open and hjt carries an "i.e. the image open" clarifier, so no error — but if a
  later pass wants uniform notation, the consumer is the place to harmonise.
- `lem:sectionsFunctorCorepIso` already carries `\leanok` in its statement (sync-managed). hjt now leans
  on it as a project-built corepresentability iso, consistent with the analogy file (it is built in
  `OpenImmersionPushforward.lean`).
- Three build-target `\lean{}` pins remain unbuilt this iter (prover's job): hjt
  `jShriekOU_transport_along_iso`, R1 `pushforward_commutes_restriction`, hqc
  `pushforward_iso_preserves_qcoh`.

## Strategy-modifying findings
None.
