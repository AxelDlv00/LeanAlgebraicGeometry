# Session 47 (iter-047) — Route B keystone LANDED axiom-clean

## Metadata
- **Sorry count:** project inline-sorry 2 → 2 (no regression; both frozen/superseded:
  `CechHigherDirectImage.lean:679` protected main theorem, `CechAcyclic.lean:110` dead `affine`).
  Prover file `QcohTildeSections.lean` is 0-sorry.
- **Targets attempted:** `qcoh_section_kernel_comparison` (the objective) — SOLVED, plus the stretch
  keystone `qcoh_section_isLocalizedModule` — SOLVED, plus the reusable abstract primitive
  `isLocalizedModule_of_exact` and two private helpers. **6 axiom-clean decls added, 0 blocked.**
- **Build:** GREEN. `lake env lean` full project build (8332 jobs, exit 0, only pre-existing style
  warnings). Review re-verified first-hand: `#print axioms` on both `qcoh_section_isLocalizedModule`
  and `qcoh_section_kernel_comparison` = `{propext, Classical.choice, Quot.sound}`. No `sorryAx`.
- **New import:** `Mathlib.RingTheory.TensorProduct.IsBaseChangePi` (for `IsLocalizedModule.pi`).
- **Lanes planned 1, ran 1** (`mathlib-build`). Objective met AND exceeded in the same lane.

## Headline
After the 041→046 tile-lemma decomposition closed its last leaf (`tile_section_localization`,
iter-046), iter-047 assembled the **Route B keystone `qcoh_section_isLocalizedModule`** — the single
load-bearing input of Route B (01I8): for quasi-coherent `F` on `Spec R` and `f ∈ R`, the
section-restriction `ρ_f : Γ(X,F) → Γ(D(f),F)` exhibits `Γ(D(f),F)` as the localization of `Γ(X,F)`
at the powers of `f`. The objective `qcoh_section_kernel_comparison` is its packaged-iso corollary.
This is the first time the keystone itself is closed; everything downstream (the `fromTildeΓ`
`D(f)`-component → `qcoh_iso_tilde_sections` → 02KG tops → P5a → P5b) now consumes a real lemma.

## Targets

### `qcoh_section_isLocalizedModule` (KEYSTONE) — SOLVED
Sheaf-axiom equalizer route (Stacks 01HV(4)/01I8), localised at `f`, in degrees 0/1:
1. `qcoh_finite_presentation_cover F` → finite `{gⱼ}` (`ULift.{u}(Fin n)`-indexed), `span = ⊤`,
   presentation per cover member.
2. Two `qcoh_section_equalizer` instances: `U1 i = D(gᵢ)` at `W=⊤`; `U2 i = D(gᵢf)` at `W=D(f)`
   (covering facts via `PrimeSpectrum.iSup_basicOpen_eq_top_iff` + ULift reindex). These give the
   two left-exact rows (inj + `Function.Exact`).
3. Verticals `b`,`c` = `IsLocalizedModule.pi` of `tile_section_localization` (cover terms) /
   `overlap_section_localization` (overlap terms).
4. Closed via the new abstract `isLocalizedModule_of_exact` + the two functoriality squares `sq1`,`sq2`.

**Key technique — the `↑R`-Semiring instance diamond:** `rw`/`simp` on `LinearMap.pi`/`∘ₗ`/`hom_comp`
over `basicOpen` sections FAILS ("did not find the pattern") because `basicOpen` pulls in
`CommRingCat`'s CommRing→Semiring path while `ModuleCat.hom_comp`/`comp_apply` use `Ring.toSemiring`
— the two are defeq but not syntactically equal. **Fix:** `change` reduces the `LinearMap.pi`
applications by *defeq* (immune to the diamond), then `res_trans_apply` (presheaf functoriality) folds
both composites; `sq2` additionally distributes `map_sub`. Under `set_option maxHeartbeats 1000000`
(justified: the `change` defeq + per-tile `IsLocalizedModule.pi` synthesis over `ULift(Fin n)`).

### `qcoh_section_kernel_comparison` (objective) — SOLVED
`LocalizedModule (powers f) Γ(⊤,F) ≃ₗ[R] Γ(D(f),F)` via `IsLocalizedModule.iso`. The instance could
not be threaded via `haveI`/`letI` (TC search fails on the `homOfLE`-laden, diamond-bearing map
expression); resolved by explicit `@IsLocalizedModule.iso _ _ … (qcoh_section_isLocalizedModule F f)`
(10 underscores). Auditor: sound, no instance gap bypassed; minor fragility vs future Mathlib bumps.

### `isLocalizedModule_of_exact` — SOLVED (reusable, project-general)
Abstract left-exact-ladder kernel comparison: commutative `A→B→C` / `A'→B'→C'` with both rows
left-exact and the two right verticals localizations at `S` ⟹ the left vertical is a localization at
`S`. Direct diagram chase of the three `IsLocalizedModule` clauses (`map_units` via `c`'s units +
exactness; `surj` via `c.exists_of_eq` + `hp`; `exists_of_eq` via `b`). The **converse** of Mathlib's
`IsLocalizedModule.map_exact` — a genuine upstream candidate. Not Spec-specific.

### `overlap_section_localization`, `overlap_target_eq`, `presheaf_map_comp₂_apply` (private helpers) — SOLVED
Per-overlap localization (`tile_section_localization` for `g = a·b` transported along the overlap
opens identities) + its two supporting lemmas. **Dead-end warning (~1h):** the `keyB` map-fold does
NOT close via inline `rw [← ModuleCat.hom_comp/comp_apply]` (same diamond); fix is the
presheaf-abstracted `presheaf_map_comp₂_apply` applied via `refine (… x).trans ?_` so defeq absorbs
the diamond. `overlap_target_eq` needs explicit `le_antisymm` (8 `inf_le_*` chains), NOT
`inf_inf_inf_comm`/`inf_idem` (pattern absent on the basic-open lattice).

## Key findings / patterns
- **The `↑R`-Semiring diamond → `change`(defeq) + presheaf-abstracted helpers.** The single recurring
  obstruction of this whole route. `rw`/`simp` on `LinearMap.pi`/`∘ₗ`/`hom_comp`/`comp_apply` over
  `basicOpen` sections silently fails the syntactic match; defeq tactics (`change`, `convert … using`,
  `refine (helper).trans`) and presheaf-abstracted lemmas (like `res_trans_apply`) cut through it.
  The next-iter `fromTildeΓ` assembly will hit the same wall — apply the recipe there.
- **Thin-cat morphism equalities close via `congrArg (… map m …) (Subsingleton.elim _ _)`** — the
  documented SAFE form (lean-auditor confirmed these are genuine, NOT the spurious-rfl kernel trap).
- **`IsLocalizedModule.iso` instance on a diamond-laden map must be `@`-threaded**, not `haveI`'d.

## Soundness (independently confirmed)
- Review's first-hand `lean_verify` on both headline decls = axiom-clean (the stale-olean / LSP-accept
  ≠ kernel-accept discipline: the prover's build is a real `lake env lean` exit-0 kernel build).
- **lean-auditor `iter047`** (`task_results/lean-auditor-iter047.md`): 0 must-fix, 0 major; explicitly
  confirmed every `change`/`Subsingleton.elim`/`@`-thread is genuine, NOT the kernel-soundness trap;
  `maxHeartbeats` justified. 4 minor (style/robustness, below).
- **lean-vs-blueprint `qts`** (`task_results/lean-vs-blueprint-checker-qts.md`): both `\lean{}`-pinned
  statements match blueprint, pins correct; 2 major BLUEPRINT-side items (planner domain — see recs).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_section_isLocalizedModule`: replaced the stale
  `% NOTE: to-build` with a LANDED note (axiom-clean iter-047; built via `isLocalizedModule_of_exact`;
  records that the `\uses` on `lem:qcoh_section_kernel_comparison` is INVERTED vs Lean — planner flip).
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_section_kernel_comparison`: added a `% NOTE` —
  Lean decl is the one-liner packaged-iso form; the equalizer-chase prose in this proof block actually
  describes the keystone's Lean proof; planner realign `\uses` direction.
- No `\leanok` touched (sync owns it; +6 this iter, genuine). No `\mathlibok` (the new public decls are
  project theorems, not Mathlib re-exports). No `\lean{}` rename (both pins already correct).

## Notes (LOW)
- 4 minor style/robustness items from lean-auditor: `F.val.obj` deprecation (pre-existing, lines
  733/742/759); `maxHeartbeats` explanatory-comment placement before rather than after `set_option`
  (linter warnings, line 1068 new this iter + pre-existing); `@`-with-10-underscores fragility (line
  1451); `change`-coupling to `LinearMap.pi` elaboration form (1418–1438). None affect correctness.

## Recommendations for next session
See `recommendations.md`. Headline: build `isIso_fromTildeΓ_of_quasicoherent` consuming the keystone
via `IsLocalizedModule.lift` (clean handoff). Planner must also flip the `\uses` edge and author a
blueprint node for `isLocalizedModule_of_exact` (coverage debt).
