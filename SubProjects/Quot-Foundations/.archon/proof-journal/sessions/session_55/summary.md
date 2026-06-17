# Session 55 (iter-055) — Summary

## Metadata
- Model: opus. Lanes: 3 (GF / GR-quot / SNAP). Build GREEN all 3 touched files.
- Active sorry (project): **16 → 13** (FLAT 2→1, GRQUOT 6→4, SNAP 0→0; QuotScheme 4, FlatBaseChange 4 untouched).
- Headline closes this iter (all `lean_verify` = `{propext, Classical.choice, Quot.sound}`):
  `Grassmannian.functor` (GR-quot), `gf_common_basicOpen_basis` (FLAT), `relTensorDomainPresheaf` (SNAP).
- sync_leanok: iter 55, sha 6669a45, +1/-0 (Picard_FlatteningStratification). blueprint-doctor: **0 findings**.
- dag-query: gaps=0, unmatched=6 (5 new helpers + `opensTopology` intentional private).

## GR-quot — `Grassmannian.functor` FULLY DROPPED (PRIMARY make-or-break, DONE)
Closed the two functoriality-blocking sorries: `pullbackObjUnitToUnit_comp` (multi-iter keystone) and
`functor.map_comp`. Sorry 6→4.
- **`pullbackObjUnitToUnit_comp`** — transpose the whole equation under the composite pullback–pushforward
  adjunction (`apply comp.homEquiv.injective`); LHS collapses via new helper `homEquiv_conjugateEquiv_app`
  (mate/conjugate compatibility of `Adjunction.homEquiv`), used **term-mode `refine hL.trans ?_`** so the
  opaque `pullbackComp` matches up to defeq; conjugate of `(pullbackComp b a).hom` = `(pushforwardComp b a).inv`
  via `conjugateEquiv_pullbackComp_inv` + `conjugateEquiv_comm` + `Iso.hom_comp_eq_id`; final section identity
  is `rfl` (`pushforwardComp_inv_app_app = 𝟙`).
- **`pullbackFreeIso_comp`** — new helper, mirrors `pullbackFreeIso_id`: `Cofan.IsColimit.hom_ext` over the free
  cofan, per-injection reduces to `pullbackObjUnitToUnit_comp` whiskered by `ιFree`.
- **`functor.map_comp`** — after `pullbackComp.inv.naturality`, whiskers to inverse-form coherence `hstar`
  proved from `pullbackFreeIso_comp` via `rw [← cancel_epi ...]` then `trans 𝟙`.
- **Diamond tactics (IMPORTANT, reusable):** `rw` systematically fails to locate visibly-present
  right-associated sub-composites in this file's category context (even generic categories, even `← Category.assoc`
  on `a≫b≫c`). Workarounds: pure term-mode `calc`/`.trans` with explicit `Category.assoc _ _ _`,
  `whisker_eq`/`eq_whisker`/`congrArg`; append bare `rfl` for defeq-not-syntactic residue; **avoid `set`**
  (metavar-unification conflicts); `pullbackFreeIso φ I .hom` vs `pullbackObjFreeIso φ.toRingCatSheafHom I .hom`
  defeq but block `congrArg` — restate `key_*` with explicit `pullbackFreeIso` types; each pullback shifts base
  ring sheaf Tx↝Ty↝Tz so trailing `ιFree (R := …)` indices differ.
- **`glue` (secondary, NOT started):** descent of sheaves of modules along `Scheme.GlueData`; no Mathlib
  turn-key. Supporting infra (`pullbackBaseChangeTransport`, `glueData_bridge_*`, C1/C2) in place; only
  multi-hundred-line descent body remains. universalQuotient/tautologicalQuotient/represents ride on it.

## FLAT — `gf_common_basicOpen_basis` CLOSED; `genericFlatness` 2→1 (deadline iter-055 MISSED, route-pivot)
- **`gf_common_basicOpen_basis` (was STUCK 2 iters) — RESOLVED axiom-clean.** The whole manual cross-chart
  construction (`b`/`g`/`IsLocalization.surj''`/`basicOpen_mul`) IS packaged in Mathlib as
  `exists_basicOpen_le_affine_inter`: at `x ∈ W ⊓ Wi` it returns `g ∈ Γ(X,W)`, `ḡ ∈ Γ(X,Wi)` with `D g = D ḡ`,
  `x ∈ D g`; containments from `X.basicOpen_le` + the common-open equality.
- **`genericFlatness` — bare sorry → single isolated sorry (L3192).** Witness `V = D(∏ⱼ fⱼ)` constructed
  honestly: finite affine cover of `p⁻¹(U₀)` (`isCompact_iff_finite_and_eq_biUnion_affineOpens`), per-patch
  `genericFlatnessAlgebraic` ⟹ `fᵢ ≠ 0`, `f := ∏ f0 i`, `hf_ne` (`Finset.prod_ne_zero_iff`, domain `A`),
  non-empty via `basicOpen_eq_bot_iff`. Per-`(U,W)` flatness reduced via `gf_section_span_flat_descent` +
  `gf_crossChart_spanning_cover` to per-piece `Module.Flat Γ(S,U) Γ(F, X.basicOpen g)`.
- **The single remaining gap is a genuine Mathlib absence.** Per-piece flatness needs
  `IsBaseChange Γ(S,U) (id : M →ₗ[Γ(S,V)] M)` — i.e. the open immersion `U ↪ V` makes `Γ(S,V) → Γ(S,U)` a
  **flat ring epimorphism** (`R ⊗_{A_f} R ≅ R`). Consumer `gf_flat_of_isBaseChange_id` built and waiting.
  Searched `Module.Flat.of_isLocalizedModule`, `flat_iff_of_isLocalization`, `Module.Flat.isBaseChange`,
  `RingHom.Flat`, `IsOpenImmersion` — none supply it. `gf_base_localization_comparison` only gives flatness, and
  a general affine `U ≤ V` need not be a *basic* open so localization-descent lemmas don't apply.
- **Counterexample (gap is real):** "`M` flat/`A_f` + tower `A_f→R→M` ⟹ `M` flat/`R`" is FALSE in general
  (`A_f=k`, `R=k[x]`, `M=k[x]/(x)`); holds only because `A_f→R` is a flat epimorphism. Handoff:
  `informal/gf_openImmersion_isBaseChange.md`.

## SNAP — `relTensorDomainPresheaf` (Step-1 brick) CLOSED + apex CommRing-routing de-risked
- **`relTensorDomainPresheaf` (axiom-clean):** objectwise ℤ-tensor domain presheaf `U ↦ Γ(U,P) ⊗_ℤ Γ(U,Q)` as
  `(Opens X)ᵒᵖ ⥤ Ab`, restriction = ℤ-tensor of underlying restriction maps; functor laws by
  `TensorProduct.induction_on`. Needed `open scoped TensorProduct` at file top. Fixed 2 unused-var warnings
  via `omit [...]` — file now warning-free.
- **KEY de-risk (was the central unknown):** apex CommRing routing. `CommRing ↑(X.ringCatSheaf.obj.obj U)` is
  NOT synthesizable (RingCat carrier only `Ring`). RESOLVED: `Monoidal.lean` L31 supplies
  `CommRing ((R ⋙ forget₂ _ RingCat).obj X)` for `R : Cᵒᵖ ⥤ CommRingCat`. So phrase apex with the
  `R ⋙ forget₂` form (= file-local `MonoidalPresheaf X`); `tensorObj_obj` then matches the objectwise
  `RelativeTensorCoequalizer.cofork` with no instance diamond. **Do NOT** hand-roll `inferInstanceAs (CommRing …)`
  on the ringCatSheaf carrier (Module-instance diamond).
- **Blocked next brick `T` (triple-tensor presheaf):** 200k-heartbeat `whnf` timeout on naive
  element-induction functor laws (perf wall, not math gap). Feasible but heavy ~150-line build; needs
  `maxHeartbeats` headroom + explicit `simp only` lists (not bare `simp; rfl`), or build `T` by re-using
  `relTensorDomainPresheaf` twice. Crux `isIso_sheafification_whiskerRight_unit` last sub-brick =
  ℤ-whiskered-row inversion via abelian presheaf stalks (`TopCat.Presheaf.stalk` EXISTS; module-sheaf stalks do
  not; `GrothendieckTopology.W.monoidal` is Day-convolution, does NOT apply pointwise).

## Reviewer dispositions (full reports in logs/iter-055/)
- **lean-auditor `iter055`** (0 must-fix / 1 major / 3 minor): all 3 headline closes genuine sorry-free
  axiom-clean; 5 remaining sorries honest+documented. MAJOR (prover/refactor — `.lean`, review can't edit):
  stale `glue` section docblock GrassmannianQuot ~L170-173 says C1/C2 cocycle hyps "remain to be added" but
  both `_hC1`/`_hC2` ARE in the signature. Minors: `represents` NOTE still lists now-closed `functor` as a dep
  (~L844); stale iter-018/021 refs in FLAT ~L538-540; fragile `simp; rfl` in SNAP L461/465.
- **lvb `flat-iter055`** (0 must-fix / 4 major / 3 minor): 3 stale `\lean{}` pins → non-existent decls
  (`gf_section_localization_flat_descent`, `gf_flat_locality_assembly`, `gf_stalk_flat_over_base`) — I added
  `% NOTE:` to each. Major #1 = `gf_base_localization_comparison` IsLocalization-prose vs Module.Flat-Lean
  (pre-existing iter-054 NOTE in place). Coverage debt: `gf_section_span_flat_descent`, `gf_flat_of_isBaseChange_id`.
- **lvb `grquot-iter055`** (0 must-fix / 3 major coverage / minor): `pullbackFreeIso_comp` +
  `homEquiv_conjugateEquiv_app` unblueprinted (both substantive, used in `functor.map_comp`); proof sketch for
  `pullbackObjUnitToUnit_comp` under-specifies the mate-compatibility step.
- **lvb `snap-iter055`** (0 must-fix): 22 `\leanok` blocks faithful+axiom-free; 7 correctly unmarked (deferred
  chain). Coverage debt: `relTensorDomainPresheaf`. Minor: 9 private decls referenced by qualified `\lean{}`.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_stalk_flat_over_base`: added `% NOTE:` (iter-055) — pinned Lean
  decl does not exist; stalk route blocked by absent `SheafOfModules.stalk`; realised route is source-span descent.
- `Picard_FlatteningStratification.tex`, `lem:gf_section_localization_flat_descent`: added `% NOTE:` (iter-055) —
  decl does not exist; split into `gf_section_localization_twoleg` + new `gf_section_span_flat_descent`.
- `Picard_FlatteningStratification.tex`, `lem:gf_flat_locality_assembly`: added `% NOTE:` (iter-055) — decl does
  not exist as standalone; encoded in `genericFlatness` proof body over span-descent + spanning cover.
- No `\leanok` overrides (sync ran iter-055, sha 6669a45, +1). No `\mathlibok` (all new helpers project-proved).

## Notes (LOW)
- SNAP `simp; rfl` on `TensorProduct.induction_on` tmul case (L461/465) is fragile if simp normal form shifts.
- FLAT `@[reducible]` on `pullbackModuleAddEquiv` (L1358) is a deliberate perf trade-off (IsScalarTower synth).
