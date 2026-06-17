# Recommendations — after iter-047

## Closest-to-completion / prioritize next

### 1. Build `isIso_fromTildeΓ_of_quasicoherent` (`lem:qcoh_isIso_fromTildeGamma`) — the next critical-path node
The keystone `qcoh_section_isLocalizedModule` is now available. Each `D(f)`-component of `fromTildeΓ`
IS `IsLocalizedModule.lift` of the keystone; combined with the `isIso_fromTildeΓ_iff` (essImage)
basis check this gives the unconditional `qcoh_iso_tilde_sections` (closes 01I8). This is the prover's
own flagged handoff (`task_results/QcohTildeSections.lean.md` §"Next step").
- **WARNING — same diamond:** the `↑R`-Semiring instance diamond WILL recur in the `fromTildeΓ`
  component identification. Do NOT `simp`/`rw` on `LinearMap.pi`/`∘ₗ`/`hom_comp` over `basicOpen`
  sections — use `change`(defeq) + presheaf-abstracted helpers (`res_trans_apply`,
  `presheaf_map_comp₂_apply`) + `refine (…).trans ?_`, exactly as the keystone did.
- **WARNING — `IsLocalizedModule.lift`/`.iso` instance threading:** thread the keystone instance
  explicitly (`@`-application), not via `haveI`/`letI` — TC search fails on the diamond-laden map.

## Blueprint structural fixes (PLANNER domain — `\uses` + prose; not the review agent's to edit)

### 2. [MAJOR] Flip the inverted `\uses` edge (lean-vs-blueprint `qts`, confirmed real)
The blueprint has `lem:qcoh_section_isLocalizedModule \uses lem:qcoh_section_kernel_comparison`; the
Lean dependency is the REVERSE (`kernel_comparison := IsLocalizedModule.iso (qcoh_section_isLocalizedModule …)`).
No circularity (chain is linear), but the DAG edge is backwards.
- Remove `lem:qcoh_section_kernel_comparison` from `lem:qcoh_section_isLocalizedModule`'s `\uses`
  (statement + proof).
- Add `lem:qcoh_section_isLocalizedModule` to `lem:qcoh_section_kernel_comparison`'s `\uses`.
- I left `% NOTE`s on both blocks documenting this; strip them once the edge is flipped.

### 3. [MAJOR] Author a blueprint node for `isLocalizedModule_of_exact` (coverage debt)
Public, substantive, load-bearing primitive consumed directly by the keystone proof — currently
unmatched. Suggested label `lem:isLocalizedModule_of_exact`. Statement: a commutative ladder of
`R`-modules with both rows left-exact and the two right verticals localizations at `S` ⟹ the left
vertical localizes at `S` (the converse of Mathlib's `IsLocalizedModule.map_exact`). Add it to
`lem:qcoh_section_isLocalizedModule`'s `\uses`. It is project-general (good upstream candidate).

### 4. [MINOR] Reconcile the two proof blocks
The long equalizer chase currently written in `lem:qcoh_section_kernel_comparison`'s PROOF block is
what the keystone's Lean proof actually carries out. Move that chase into
`lem:qcoh_section_isLocalizedModule`'s proof block (closing step = `isLocalizedModule_of_exact`), and
shrink `lem:qcoh_section_kernel_comparison`'s proof to "immediate from the keystone via
`IsLocalizedModule.iso`."

### 5. [MINOR] Coverage debt — bundle the 3 private helpers into `\lean{}` lists
`overlap_section_localization`, `overlap_target_eq`, `presheaf_map_comp₂_apply` (all private). Bundle
into the keystone proof block's `\lean{…}` list (or a dedicated note for `overlap_section_localization`,
which is near-substantive — it is `tile_section_localization` for `g = a·b` transported along the
overlap opens identity). `dag-query unmatched` currently = 5: 1 pre-existing dead (`CechAcyclic.affine`)
+ these 4 new (`isLocalizedModule_of_exact` [item 3] + the 3 privates).

## Do NOT re-assign
- `qcoh_section_kernel_comparison`, `qcoh_section_isLocalizedModule` — both SOLVED axiom-clean. Done.
- The tile-lemma chain (`tile_section_localization` et al.) — SOLVED iter-046. Done.

## Reusable proof patterns (for the Knowledge Base / next provers)
- **`↑R`-Semiring diamond:** over `basicOpen` sections, `rw`/`simp` on `LinearMap.pi`/`∘ₗ`/
  `hom_comp`/`comp_apply` fail the syntactic match (CommRingCat CommRing→Semiring vs Ring.toSemiring).
  Use `change`/`convert … using`/`refine (helper).trans ?_` (defeq) + presheaf-abstracted helper
  lemmas; fold thin-cat morphism equalities with `congrArg (… map m …) (Subsingleton.elim _ _)`.
- **`IsLocalizedModule.pi`** (`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`) localizes a finite
  product of localization maps — the b/c verticals of a product equalizer.
- **`isLocalizedModule_of_exact`** (project-local, this iter) — close a localization claim on the
  kernel of a left-exact ladder when the other two verticals localize.

## Style cleanup (LOW, optional — lean-auditor `iter047`)
- `maxHeartbeats` explanatory comments must go AFTER `set_option … in`, not before (linter warns;
  affects line 1068 + pre-existing). `F.val.obj` → `ObjectProperty.obj` deprecation (lines 733/742/759).
