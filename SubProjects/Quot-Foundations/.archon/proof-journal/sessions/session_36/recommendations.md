# Recommendations — after session 36 (iter-036) → for the iter-037 plan agent

## 1. Must-fix this iter (from lean-vs-blueprint-checker `quot-iter036`) — DONE this review
- The over-optimistic "one-liner" NOTEs at `Picard_QuotScheme.tex` `lem:pullback_gamma_top_iso`
  (~L3678) and `lem:section_localization_descent` (~L3749) were **corrected this review** with
  `% NOTE (iter-036, review)` blocks naming the two remaining Mathlib-absent ingredients. No further
  action needed except: **do NOT assign Hfr/descent/gap1 as a trivial chain** — see §4.

## 2. Coverage debt (1-to-1) — `archon dag-query unmatched` = 13 nodes, blueprint these
The planner's iter-036 plan relied on marking helpers `private` to clear them from the scan, but
**`private` does NOT remove a decl from the unmatched query** — the provers confirmed several
(`rotMid`, `transitionInv*`, `descent_*`, `res_comp`, `iSup_basicOpen_subtype_eq_top`) are already
`private` yet still show. They each need a blueprint block (or an explicit decision to leave trivial
helpers uncovered). Net-new this iter that genuinely need blocks:
- **QuotScheme:** `gammaPullbackImageIso` (general-in-`V` form of `lem:pullback_gamma_top_iso`) and
  `gammaPullbackImageIso_hom_naturality` (its naturality sub-claim). The lemma's prose already
  anticipates the general-in-`V` form — fold both in as sub-claims / add `\lean{}` pins. (2 major,
  checker `quot-iter036`.)
- **GrassmannianCells:** `existence_lift_transitionPreMap_minorDet_mul` (E3 ratio core) — the
  displayed E3 equation `f'(θ̃_{I,J}(P^J_K))·f(P^I_J)=f(P^I_K)`; give it its own lemma block,
  `\uses{lem:gr_transitionPreMap_minorDet_mul, lem:mathlib_away_lift}`. (1 major, checker `gr-iter036`.)
- **FlatBaseChange:** `base_change_mate_extendScalars_inner_value_counit` (step (b) of
  `lem:base_change_mate_gstar_transpose`) — inline sub-lemma; either a small block or fold into the
  gstar_transpose proof prose.
- Pre-existing still-unmatched (predate iter-036): GR `rotMid`/`transitionInvImageMatrix`/
  `transitionInvPair`; QUOT `descent_overlap_agree`/`descent_smul_eq_zero`/`descent_surj`/
  `iSup_basicOpen_subtype_eq_top`/`res_comp`; FBC `isIso_unitToPushforwardObjUnit_of_isIso'`
  (lives in FlatBaseChangeGlobal.lean).

## 3. lean-auditor `iter036` dispositions (4 must-fix / 3 major / 3 minor)
- **4 must-fix = the pre-existing iter-176 protected scaffold stubs** in QuotScheme
  (`hilbertPolynomial`@~123, `QuotFunctor`@~161, `Grassmannian`@~198, `Grassmannian.representable`@~225,
  bodies `:= sorry`). These are the file's 4 protected stubs — frozen signatures, intentional
  skeletons. **Not new dead code; not a regression.** They become real work only when their upstream
  cones (gap1/gap2, GR scheme) close. No action this iter beyond awareness.
- Major: deprecated `Sheaf.val` usage (>20 sites in FBC), misplaced `maxHeartbeats` comments,
  long-line debt — cosmetic cleanup candidates for a future golf pass, not blocking.
- Full report: `.archon/task_results/lean-auditor-iter036.md`.

## 4. Closest-to-completion / next prover targets (priority order)

### FBC-A (FlatBaseChange) — stay conjugate-`huce`, prove steps (a) then (c)
- iter-036 landed step (b) axiom-clean; the iter-036 **tripwire SUCCESS condition was met** (a
  compiling standalone sub-lemma landed) → the route is NOT escalated; stay on conjugate-`huce`.
- iter-037 prove pass: build step (a) — the inline `Γ_R(θ_in)=ρ` reproof from the proved standalone
  inputs (`..._legs_unitExpand`@1317, `..._gammaDistribute`@1348, `gammaMap_pushforwardComp_*_eq_id`,
  Seam-1 `unit_value`@987, `pullbackPushforward_unit_comp`@1144) — then step (c) dictionary
  cancellation against the landed `huce` master identity (`base_change_mate_gstar_counit_transport`),
  then plug the proven step (b) to close `gstar_transpose`@2167.
- **Do NOT** re-assign the element-`ext`/explicit-inverse pivot (reverted iter-036 as inverted
  sunk-cost — it unfolds back onto gstar_transpose). **Do NOT** re-assign conj-2a
  (`base_change_mate_fstar_reindex_legs_conj`@1700) — now off the critical path / pruning debt.
- Standing tripwire: if iter-037 closes `gstar_transpose` with no structural progress AND no further
  standalone sub-lemma lands → mathlib-analogist consult on the counit coherence (NOT another
  conjugate round, NOT user escalation).

### QUOT (QuotScheme) — build the two transport ingredients as STANDALONE steps (not a one-liner)
- The lane's pinned objective `gammaPullbackTopIso` is **complete**. The downstream Hfr/named-descent/
  gap1 are blocked on two genuinely Mathlib-absent ingredients — assign them as their own
  mathlib-build steps, NOT as a chain off the section iso:
  - **(I)** `isLocalizedModule_of_addEquiv_semilinear` — transport `IsLocalizedModule S g` across a
    ring-iso-semilinear additive equiv (`e₁ : M₁≃+N₁`, `e₂ : M₂≃+N₂` compatible with `σ : R≃+*R'`)
    to `IsLocalizedModule (S.map σ) (e₂∘g∘e₁⁻¹)`. Mathlib has only same-ring `of_linearEquiv`.
    **Recommend a mathlib-analogist (api-alignment) consult** first — confirm no Mathlib idiom exists
    before building bespoke.
  - **(II)** base-change-of-localization `R→R_r`: identify `IsLocalizedModule (powers (algebraMap R S f)) g`
    over `S` with `IsLocalizedModule (powers f) g` over `R` when `S = R_r`, via
    `IsLocalizedModule.iso`/transitivity through `LocalizedModule (powers f)`.
- Then chain `gammaPullbackImageIso` through the three pullbacks of `isIso_fromTildeΓ_restrict_basicOpen`
  + `overRestrictPullbackIso`, assemble Hfr, instantiate `isLocalizedModule_basicOpen_descent_of_cover`
  (landed iter-035) at `exists_finite_basicOpen_cover_le_quasicoherentData`, gap1 via
  `isIso_fromTildeΓ_of_isLocalizedModule_restrict`.

### GR (GrassmannianCells) — build the cofactor determinant helper, then E3-full
- E1/E2/E3-ratio-core landed. The single E3-full blocker is the column-substituted-identity
  determinant: build `det (M.updateColumn p (X q)) = ±(X q) p` for `M=1` over a comm ring, then
  transport through the `K'`-vs-`J` order-iso reindexing to get
  `minorDet d r J K' hJ hK' = ± MvPolynomial.X (p, ⟨q,_⟩)` in `R^J`.
  Mathlib candidates to scout: `Matrix.det_updateColumn_*`, `Matrix.updateColumn`,
  `Matrix.det_succ_column`, `Matrix.cramer`, `Matrix.det_eq_of_*`.
- With that helper, E3 closes via: ratio core + E2 valuation bound (every `g(P^J_{K'})∈R`, valuation
  `≤1`) + the cofactor helper (generators into `R`) + `RingHom.rangeRestrict` factorization. E4/E5
  gated on E3. **Do NOT attempt E3 factorization without the cofactor helper** (the generator-membership
  step is unavoidable and IS the flagged gap).

## 5. Blocked — do NOT re-assign without the named structural change
- **FBC conj-2a** (`base_change_mate_fstar_reindex_legs_conj`): the section-composite→conjugateEquiv-
  component reframing has stalled 5+ iters; now OFF the critical path. Prune only after gstar_transpose
  lands; do not spend a prove round on it.
- **QUOT Hfr/descent/gap1 as a "one-liner":** blocked on ingredients (I)+(II) above. Assign those
  first; do not re-task Hfr directly.
- **GR E3-full:** blocked on the cofactor helper above; build that first.

## 6. Reusable proof patterns (also in PROJECT_STATUS Knowledge Base)
- `ext x` → `ExtendScalars.map'` → `Counit.map_apply_one_tmul` → `congrArg _ rfl` for
  extendScalars/counit-composite = module-value identities.
- `(toPresheaf ⋙ (evaluation).obj (op U)).mapIso φ` instead of `asIso (φ.app U)` when
  `IsIso (φ.app U)` won't synthesize.
- Explicit `@`-instances / `inferInstanceAs` on the unfolded subtype for `theGlueData` projections
  (`IsOpenImmersion (ι I)`, `Finite .J`).
