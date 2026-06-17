# AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Summary
- **Declarations added (6):** `isLocalizedModule_of_exact`, `overlap_target_eq` (private),
  `presheaf_map_comp₂_apply` (private), `overlap_section_localization` (private),
  `qcoh_section_isLocalizedModule` (**the Route B KEYSTONE**), `qcoh_section_kernel_comparison`
  (**the objective**).
- **Declarations blocked:** 0.
- **sorry count:** 0 → 0 (file stays 0-sorry). Project inline-sorry unchanged (the 2 frozen/superseded).
- **New import:** `Mathlib.RingTheory.TensorProduct.IsBaseChangePi` (for `IsLocalizedModule.pi`).
- **All 6 new decls `#print axioms` = {propext, Classical.choice, Quot.sound}.** Full `lake env lean`
  build of the project succeeds (8332 jobs, only pre-existing style warnings).

**This iteration met AND exceeded the objective.** The objective was `qcoh_section_kernel_comparison`;
I built it *and* the stretch keystone `qcoh_section_isLocalizedModule` in the same lane, *and* the
genuinely reusable abstract algebra lemma `isLocalizedModule_of_exact` that powers both.

## `isLocalizedModule_of_exact` (line ~1187)
- **Statement:** abstract kernel comparison. Given a commutative ladder of `R`-modules
  `A→B→C` / `A'→B'→C'` with both rows left-exact (`i`,`i'` injective + `Function.Exact i p`,
  `Function.Exact i' p'`) and the two right verticals `b`,`c` localizations at `S`, the left vertical
  `a` is a localization at `S`.
- **Approach:** direct diagram chase of the three `IsLocalizedModule` clauses. `map_units` (surj part)
  needs `c`'s `map_units` + exactness; `surj` needs `c`'s `exists_of_eq`; `exists_of_eq` needs `b` only.
  Built elementwise smul-bijectivity helpers from `Module.End.isUnit_iff` + `Module.algebraMap_end_apply`;
  threaded `Submonoid.smul_def`/`coe_mul` for the submonoid-vs-`R` smul. **RESOLVED — axiom-clean.**
- **Reuse note:** this is the converse of Mathlib's `IsLocalizedModule.map_exact`; genuinely
  project-general (not Spec-specific). Good candidate to upstream.

## `overlap_section_localization` (private, line ~1287)
- **Statement:** for qcoh `F`, `f a b : R`, `D(a) ⊆ U` with `F.over U` presented: the restriction
  `Γ(D(a)⊓D(b),F) → Γ(D(af)⊓D(bf),F)` is `IsLocalizedModule (powers f)`.
- **Approach:** `tile_section_localization` for `g = a·b`, transported along the overlap opens
  identities `D(a·b)=D(a)⊓D(b)` (`basicOpen_mul`) and `D((a·b)·f)=D(af)⊓D(bf)` (`overlap_target_eq`)
  via `mapIso (eqToIso …)` + `of_linearEquiv`/`of_linearEquiv_right`. **RESOLVED — axiom-clean.**
- **Dead-end warning (cost ~1h):** the map-equality `keyB` folding `eqTgt ∘ₗ μ₀ ∘ₗ eqSrc` into the
  target restriction does **NOT** close via `rw [← ModuleCat.hom_comp, …]` nor `rw [← ModuleCat.comp_apply]`.
  A `↑R`-Semiring **instance diamond** (`basicOpen` pulls in `CommRingCat`'s CommRing→Semiright path;
  `ModuleCat.hom_comp`/`comp_apply` use `Ring.toSemiring`) makes the `∘ₗ`/`ConcreteCategory.hom`
  patterns fail to match syntactically. FIX: a generic helper `presheaf_map_comp₂_apply` (presheaf
  **abstracted as a parameter**, like `res_trans_apply`) where `← ModuleCat.comp_apply` matches
  cleanly, applied via `refine (presheaf_map_comp₂_apply … x).trans ?_` so unification (defeq)
  absorbs the diamond. Do NOT retry the inline `hom_comp` fold.

## `qcoh_section_isLocalizedModule` (line ~1349) — the KEYSTONE
- **Statement:** `IsLocalizedModule (powers f) ρ_f`, `ρ_f : Γ(⊤,F) → Γ(D(f),F)` — exactly what the
  `D(f)`-component of `fromTildeΓ` consumes (same shape as `section_isLocalizedModule_of_presentation`,
  but unconditional for qcoh `F`).
- **Approach (the blueprint sheaf-axiom equalizer route):**
  1. `qcoh_finite_presentation_cover F` → finite `{gⱼ}`, `span = ⊤`, presentation per cover member.
  2. Two covers indexed by `ULift.{u} (Fin n)` (needed: `qcoh_section_equalizer`'s `ι : Type u`,
     `Fin n : Type 0`): `U1 i = D(gᵢ)` at `W=⊤`, `U2 i = D(gᵢf)` at `W=D(f)`. Covering facts via
     `PrimeSpectrum.iSup_basicOpen_eq_top_iff` (+ ULift reindex) and the `⊓`-distributes argument.
  3. Two `qcoh_section_equalizer` instances give the left-exact rows (inj + `Function.Exact`).
  4. Verticals `b`,`c` = `IsLocalizedModule.pi` of `tile_section_localization` /
     `overlap_section_localization`.
  5. `isLocalizedModule_of_exact` with the two commuting squares `sq1`,`sq2`.
- **`sq1`/`sq2` (the functoriality squares) — KEY TECHNIQUE:** the same `↑R`-Semiright diamond makes
  `LinearMap.pi_apply`/`simp`/`rw` **fail to reduce** `(LinearMap.pi f) x i`. FIX: `change` (which
  reduces by **defeq**, immune to the diamond) to the explicit nested-restriction form, then
  `res_trans_apply` (presheaf functoriality) folds both routes; `sq2` additionally `map_sub` to
  distribute the overlap differential before 4× `res_trans_apply`. **RESOLVED — axiom-clean** (under
  `set_option maxHeartbeats 1000000`).

## `qcoh_section_kernel_comparison` (line ~1442) — the objective
- **Statement (blueprint form):** the canonical localisation lift `Γ(X,F)_f → Γ(D(f),F)` is an iso,
  packaged as `LocalizedModule (powers f) Γ(⊤,F) ≃ₗ[R] Γ(D(f),F)`.
- **Approach:** `IsLocalizedModule.iso (powers f) ρ_f`, the keystone supplying the instance (threaded
  via `@IsLocalizedModule.iso … (qcoh_section_isLocalizedModule F f)` — `haveI`/`letI` would not be
  found by instance synthesis due to the same diamond on the map's `homOfLE` proof). **RESOLVED.**
- **NOTE for planner/blueprint:** I built the keystone **directly** via the abstract kernel comparison,
  and derived `qcoh_section_kernel_comparison` *from* the keystone. This **inverts** the blueprint's
  `\uses` direction (blueprint has `qcoh_section_isLocalizedModule` `\uses lem:qcoh_section_kernel_comparison`).
  Both are equivalent; recommend the reviewer flip the `\uses` edge so the DAG matches the Lean
  dependency (kernel_comparison now depends on isLocalizedModule, not vice-versa). No new circularity —
  the keystone's only "sections-localise" inputs are the per-tile lemmas (non-circularity hinge intact).

## Needs blueprint entry
All 6 new decls are infrastructure with no blueprint block yet (will show in `archon dag-query unmatched`):
1. **`isLocalizedModule_of_exact`** — abstract kernel comparison (left-exact ladder + 2 localized
   verticals ⟹ 3rd vertical localized). Relies on: `Module.End.isUnit_iff`, `Module.algebraMap_end_apply`,
   `IsLocalizedModule` clause API, `Function.Exact`. **No blueprint node exists** — needs one
   (it is the lemma the kernel-comparison proof `\uses`).
2. **`overlap_target_eq`** (private) — `D((a·b)·f)=D(af)⊓D(bf)`. Bundle into a related `\lean{…}` list.
3. **`presheaf_map_comp₂_apply`** (private) — pointwise triple-restriction fold. Bundle into a `\lean{…}` list.
4. **`overlap_section_localization`** (private) — per-overlap section localisation. Bundle into the
   `lem:qcoh_section_kernel_comparison` proof's `\lean{…}` or a dedicated node; its proof relies on
   `tile_section_localization` + the two opens identities.
5. **`qcoh_section_isLocalizedModule`** — already pinned `\lean{AlgebraicGeometry.qcoh_section_isLocalizedModule}`;
   now LANDED. Proof relies on: `qcoh_finite_presentation_cover`, `qcoh_section_equalizer`,
   `tile_section_localization`, `overlap_section_localization`, `isLocalizedModule_of_exact`,
   `IsLocalizedModule.pi`. **Update `\uses` to drop `lem:qcoh_section_kernel_comparison` and add
   `isLocalizedModule_of_exact` + the overlap lemma.**
6. **`qcoh_section_kernel_comparison`** — already pinned; now LANDED (as the derived iso form).
   `\uses{lem:qcoh_section_isLocalizedModule}` (+ `IsLocalizedModule.iso` mathlib anchor).

## Why I stopped
**Real progress — 6 axiom-clean declarations added, all building project-wide:**
- `isLocalizedModule_of_exact` (~line 1187), `overlap_target_eq` (~1276), `presheaf_map_comp₂_apply`
  (~1283), `overlap_section_localization` (~1289), `qcoh_section_isLocalizedModule` (~1352),
  `qcoh_section_kernel_comparison` (~1444).

I stopped because **the assigned objective is fully met and exceeded** — both the kernel comparison
and the keystone are closed axiom-clean, and the only remaining work in the file's lane (the Route B
assembly `isIso_fromTildeΓ_of_quasicoherent` and the downstream `qcoh_iso_tilde_sections` upgrade) is
the *next* planned objective per PROGRESS "Next iter plan", which consumes `qcoh_section_isLocalizedModule`
as the `IsLocalizedModule.lift` input — a clean handoff point. Nothing is blocked.

## Next step (handoff for next iter, per PROGRESS plan §2)
Build `isIso_fromTildeΓ_of_quasicoherent` (`lem:qcoh_isIso_fromTildeGamma`): each `D(f)`-component of
`fromTildeΓ` IS `IsLocalizedModule.lift` of `qcoh_section_isLocalizedModule` (now available) + the
`isIso_fromTildeΓ_iff` (essImage) basis check ⟹ unconditional `qcoh_iso_tilde_sections`. Watch for the
same `↑R`-Semiright instance diamond — use `change`/defeq + presheaf-abstracted helpers, not
`simp`/`rw` on `LinearMap.pi`/`∘ₗ` over `basicOpen` sections.
