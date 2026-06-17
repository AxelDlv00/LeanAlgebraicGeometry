# Blueprint-writer directive — QUOT chapter (G1-core → Route F + coverage debt + gap1-reduction node)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` — edit ONLY this file.

## Background you must read first
Read `analogies/g1core-affine-descent.md` (written by the mathlib-analogist this iter) — it is the route
map for this rewrite. Summary: the planned **Route E** (explicit finite basic-open cover → local tilde →
flat-localization of a finite equalizer object) is NOT the Mathlib idiom. The shorter, idiomatic **Route F**
realises G1-core as the *module analogue of Mathlib's structure-sheaf lemma* `isLocalization_basicOpen_of_qcqs`
(`Mathlib/AlgebraicGeometry/Morphisms/QuasiSeparated.lean:389`): build the `IsLocalizedModule (powers f)`
witness directly from its **three-field constructor** `⟨map_units, surj, exists_of_eq⟩`
(`Mathlib/Algebra/Module/LocalizedModule/Basic.lean:525`), each field a pointwise existence statement proved
by `compact_open_induction_on` + generic sheaf gluing (module Mayer–Vietoris) — **no equalizer object, no
flatness chaining**. Confirmed: there is no single Mathlib lemma "localization commutes with a finite
equalizer of modules", which is what made Route E expensive.

## Task 1 — rewrite the G1-core proof (`lem:qcoh_affine_section_localization`, ~lines 2595–2640) to Route F
KEEP the statement, the `% SOURCE`/`% SOURCE QUOTE` (Stacks 01HA) lines, and the `\textit{Source: …}` line.
REPLACE the four-step Route-E proof body (the cover-refine → local-tilde → **flat-equalizer** descent) with
the Route-F descent:
- The witness is the three-field `IsLocalizedModule (powers f)` constructor `⟨map_units, surj, exists_of_eq⟩`
  on the restriction `Γ(M,⊤) → Γ(M,D(f))`, mirroring how the qcqs lemma assembles `IsLocalization.Away`.
- **map_units:** the `R`-action of `fⁿ` on `Γ(M,D(f))` factors through the unit `f|_{D(f)} ∈ Γ(𝒪,D(f))`,
  so it is invertible (structure-sheaf fact `RingedSpace.isUnit_res_basicOpen`). Cheap.
- **surj** and **exists_of_eq:** the module analogues of the qcqs lemma's two existence statements
  (`exists_eq_pow_mul_of_isCompact_of_isQuasiSeparated` and the `res_basicOpen_eq_zero` companion), each
  proved by induction over a compact open via `compact_open_induction_on`. The base case uses the local
  identification `M|_{D(g)} ≅ tilde N_g` (from a presentation transported to the basic open, via Mathlib
  `Modules.isIso_fromTildeΓ_of_presentation`) together with the affine tilde localization instance and the
  project's `isLocalizedModule_tilde_restrict`; the inductive step is the **generic module Mayer–Vietoris /
  sheaf-gluing** (`TopCat.Sheaf.isLimitPullbackCone` + `existsUnique_gluing`/`eq_of_locally_eq'`) applied to
  the concrete sheaf `modulesSpecToSheaf.obj M`.
- State explicitly that the only manual core shared with Route E is **step 1**: extracting a *finite
  basic-open tilde cover* from the quasi-coherence datum `M.QuasicoherentData` (refine to the basic-open
  basis, finite subcover by quasi-compactness, transport each presentation across `D(g) ≅ Spec R_g`). This
  is the irreducible core and the prover's first target; Route F sheds Route E's equalizer object and its
  "the gₐ generate the unit ideal" obligation.
Update the proof's `\uses{}` to drop the flat-equalizer dependency and add the Route-F ingredients you
introduce as anchors (see Task 3). Mention `isLocalization_basicOpen_of_qcqs` by name as the structure-sheaf
template (a `\mathlibok` anchor in Task 3).

## Task 2 — coverage-debt blocks for the 4 new QUOT Lean decls (iter-026), + the gap1-reduction node
The iter-026 prover built the downstream glue `G1-core ⟹ gap1 ⟹ keystone` (4 unmatched `lean_aux` nodes).
Add a blueprint block for each (statement, `\label`, `\lean{<exact name>}`, accurate `\uses`, one-to-three
line informal proof). Place them in a new subsection near the gap1 block (`lem:qcoh_affine_isIso_fromTildeΓ`,
~line 2642).

IMPORTANT — do NOT re-point gap1's `\lean{}` (the iter-026 prover's suggestion to re-point it was checked
and REJECTED by the lean-vs-blueprint checker: gap1's target `isIso_fromTildeΓ_of_isQuasicoherent` takes
`[IsQuasicoherent M]`, whereas the new reduction takes an explicit per-basic-open localization hypothesis —
different signatures). Instead add a **new** node for the reduction:

1. `AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict` (public) — **the G1-assemble step**:
   given `H : ∀ f, IsLocalizedModule (powers f) (restriction Γ(M,⊤)→Γ(M,D(f)))`, conclude
   `IsIso M.fromTildeΓ`. Proof: on each `D(f)` the component of `modulesSpecToSheaf.map M.fromTildeΓ`
   intertwines two localizations of `N = Γ(M,⊤)` at `powers f` (source via `tilde.toOpen`, target by `H`),
   hence is the canonical localization iso; upgrade basis-wise iso to a sheaf iso; `modulesSpecToSheaf`
   fully faithful reflects to `IsIso M.fromTildeΓ`. `\uses` the two private helpers (below) +
   `lem:isLocalizedModule_tilde_restrict`. **Then gap1's proof becomes: feed G1-core
   (`lem:qcoh_affine_section_localization`) as `H` into this reduction** — update
   `lem:qcoh_affine_isIso_fromTildeΓ`'s proof `\uses{}` to include this new node.
2. `AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (public) — the iff characterization
   `IsIso M.fromTildeΓ ↔ ∀ f, IsLocalizedModule (powers f) (restriction)`. `\uses` node 1 (reverse) +
   existing `isLocalizedModule_restrict_of_isIso_fromTildeΓ` (forward).
3. `AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen` (private) — iso on the basic-open basis ⟹ iso of
   sheaves of `R`-modules on `Spec R`. `\uses` (anchors) `PrimeSpectrum.isBasis_basic_opens`,
   `stalkFunctor_map_injective_of_isBasis`, `isIso_of_stalkFunctor_map_iso`.
4. `AlgebraicGeometry.bijective_comp_of_localizations` (private) — a map intertwining two localizations of
   one module is bijective. `\uses` (anchor) `IsLocalizedModule.linearEquiv`, `linearMap_ext`.

## Task 3 — `\mathlibok` Mathlib-dependency anchors for the Route-F ingredients
Author anchor blocks (statement in project notation, `\lean{}` naming the real Mathlib decl, marked
`\mathlibok`) for the load-bearing Mathlib decls Route F relies on, so the route's reliance stays visible
and the DAG treats them as done:
- `AlgebraicGeometry.isLocalization_basicOpen_of_qcqs` (the structure-sheaf template).
- `IsLocalizedModule` three-field constructor / `Module.End` units (`isUnit_res_basicOpen` analogue) — name
  the Mathlib decls in `analogies/g1core-affine-descent.md` (`RingedSpace.isUnit_res_basicOpen`,
  `LocalizedModule/Basic.lean:525`).
- `AlgebraicGeometry.Modules.isIso_fromTildeΓ_of_presentation`, the affine tilde instance (`Tilde.lean:115`).
- `compact_open_induction_on`, `TopCat.Sheaf.isLimitPullbackCone`, `existsUnique_gluing` /
  `eq_of_locally_eq'`.
Mark `\mathlibok` ONLY on these genuine Mathlib anchors — never on the project's own to-be-proved decls.
Do NOT add `\leanok` to anything.

## Citation discipline
G1-core's Stacks 01HA `% SOURCE QUOTE` is already present — keep it. The new bridge blocks (Task 2) are
Archon-original Lean realizations — no external source quote needed. The `\mathlibok` anchors (Task 3) name
Mathlib decls in `\lean{}`; no external prose source. Do NOT invent any `% SOURCE` you have not read. If
you find you need a Stacks/Mathlib passage you don't have locally, you may spawn a reference-retriever
(your `references/**` write-domain authorizes it) — but Route F is fully specified in
`analogies/g1core-affine-descent.md`, so this should not be necessary.

## Out of scope
The 4 protected stubs; the SNAP/annihilator/Grassmannian-representable nodes; the FBC/GR chapters.
