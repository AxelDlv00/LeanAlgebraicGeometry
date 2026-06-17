# Recommendations for iter-020 (from session_19 review)

## Closest-to-completion targets — prioritise

### 1. QUOT `subquotient_base_eventuallyZero` `iSupIndep` leaf — THE single hole gating the whole keystone chain
This is now the **sole** `sorry` between the project and a fully-proved
`gradedModule_hilbertSeries_rational` (SNAP-S2). Everything else in the Stacks 00K1 induction is assembled
axiom-clean. Highest leverage in the project.
- **Do NOT retry route (a)** (build a κ-linear detector `Φ : Q →ₗ[κ] M⧸N'` out of the
  `MvPolynomial (Fin 0) κ`-quotient `Q` via `Submodule.liftQ`) — it has a scalar-ring clash (`liftQ`
  produces an `S`-semilinear map; the target is only a κ-module). The prover already burned an attempt here.
- **Route (b) (recommended)**: dfinsupp destructuring of `⨆ j≠n range (ψ j)`
  (`Submodule.mem_iSup_iff_exists_dfinsupp`) + take the degree-`n` homogeneous component directly, staying
  inside `Q`'s fixed κ-structure (no outgoing map); use homogeneity of `N'` (`D.hN'`). Finish with
  `Submodule.finite_ne_bot_of_iSupIndep` [verified].
- If route (b) resists, **effort-break** this one lemma (it is a frontier leaf; deps all done).

### 2. GF L4 finiteness leaf `exists_localizationAway_finite_mvPolynomial` (line 754)
Injectivity + all scaffolding are CLOSED; only `hfin : Module.Finite A_g[X] B_g` remains. Needs a
**blueprint-writer Step-3 round first** (the chapter's L4 sketch is adequate per the checker but the
`g0→g0*g1` witness-refinement + per-coefficient clearing recipe should be pinned), then a `prove` pass.
- Recipe: refine witness to `g := g0 * g1` (`g1 ≠ 0` clearing `K[X]`-coefficients of the monic
  integral-dependence equations of generators `σ`; fold `gf_clear_one_denominator`), pull each cleared
  monic relation back through injective `ν` so each `σᵢ` is integral over `im φ`, then
  `Algebra.finite_adjoin_of_finite_of_isIntegral` [verified] since `Algebra.adjoin A_g (algebraMap '' σ) = ⊤`.
- All injectivity scaffolding transfers verbatim to `g0*g1` (the unit only needs `g0 ∣ g`).

## Blocked / do-NOT-retry without a structural change

### 3. FBC `base_change_mate_fstar_reindex_legs` assembly — leg-lock, 6th consecutive iter unmoved
**Do NOT dispatch another standalone fine-grained helper round** and **do NOT re-attempt the whole goal.**
The blueprint is adequate (checker confirmed) and decomposition has now been tried; the wall is the
post-`subst` leg-lock at the **matching** stage, not a missing lemma. The corrective is a **refactor**:
restate the assembly so the `g'`-unit is rewritten via a `g'`-parametrised lemma BEFORE `subst` (`g'` still
a free local → matches syntactically), THEN state+prove `_eCancel`/`_affineUnit`/`_innerMatch` inline
against the now-determined goal. The 2 closed sub-lemmas (`_unitExpand`, `_gammaDistribute`) are reusable
inputs. If a progress-critic re-fires CHURNING on FBC next iter without this refactor, treat it as STUCK.
- Reusable tactic note for whoever takes FBC: prefer **term-mode** combinators
  (`congrArg`/`.trans`/`F.map_comp` as terms) over `rw`/`simp` for any composition/functoriality/iso-cancel
  step — the `X.Modules` instance diamond defeats tactic-mode matching but term mode unifies up to defeq.

### 4. QUOT `sectionGraded*` / `hilbertPolynomialOfSectionModule` (SNAP-S1/S3) — blocked on a registered gap
5 chapter pins (`sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`,
`Scheme.hilbertPolynomialOfSectionModule`) are absent from Lean, blocked by the tensor-product-of-sheaves
infrastructure gap the chapter `% NOTE:` already acknowledges. Not actionable as a prover lane until that
infra lands; do not dispatch.

## Blueprint coverage debt (planner: author blocks; review does not write prose)
`archon dag-query unmatched` → **18 unmatched `lean_aux` nodes** (1-to-1 correspondence missing). All in
`namespace AlgebraicGeometry.GradedModule` unless noted:
- **GF**: `GenericFreeness.isLocalization_lift_injective` — reusable: `IsLocalization.lift hg` injective
  when `g` sends `M` to units and both `algebraMap R S` and `g` injective. Uses
  `IsLocalization.lift_injective_iff`, `Function.Injective.eq_iff`.
- **QUOT (keystone-chain helpers, all proved axiom-clean)**: `lastVarAlgHom` (+ `_X_castSucc`, `_X_last`,
  `_C`, `_rename_castSucc`, `_surjective`, instance `lastVarAlgHom_ringHomSurjective`);
  `polyEndHom_mem_of_stable`; `polyEndHom_lastVar_sub_mem`; `polyQuot_finite_of_le_numerator`;
  `polyQuot_finite_of_le_denominator`; `ker_stable_full`; `coker_stable_full`;
  `SubquotientDatum.ker`; `SubquotientDatum.coker`; `finrank_comap_subtype` (carried from iter-018, still
  private/unblueprinted — decide block-or-leave).
- **QUOT (proved, sorry-free)**: also fold a block for `subquotient_base_eventuallyZero` once its leaf
  closes (currently `lean_aux`, carries the residual sorry).
- **Blueprint prose reconciliation**: the existing pin `lem:graded_subquotient_finite_transfer` now names
  the abstract single-pair σ-transfer (`subquotient_finite_transfer`), not the K,C-specific phrasing — the
  writer should adjust the prose to match the landed statement.

## Blueprint-vs-Lean discrepancies for the planner (NOT prover lanes)

### 5. GF — 11 `private` decls carry public `\lean{…}` pins (MAJOR, lvb-checker)
`T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`,
`leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`.
All proved + axiom-clean but invisible to `sync_leanok` (cannot resolve `private` names) → the dashboard
under-reports 11 decls. **Fix: a `refactor` de-`private` pass** (these are infrastructure helpers, not API
that needs hiding), OR drop the pins. Recurring debt (flagged in iter-018 too) — resolve it now.

### 6. QUOT — `Grassmannian.representable` weakened signature (must-fix, lvb-checker)
The protected file-skeleton stub's signature is weaker than the full representability claim (acknowledged
by the chapter's own `% NOTE:`). The frozen signature must be strengthened or split before the claim can be
considered formalized. This is a **frozen/protected signature** decision — surface to the user (it is in
`TO_USER.md` already, see Step 7) / planner; review cannot edit `.lean` or the protected signature.
Loose signatures on `hilbertPolynomial`/`QuotFunctor` (missing proper-support hypothesis) are the same
class — to tighten when their bodies land.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Term-mode escape from a spurious `X.Modules` instance diamond** — see FBC above.
- **σ-semilinear `Module.Finite` transfer on defeq quotient carriers** via `liftQ` + `induction_on`
  `map_smul'` + `Module.Finite.of_surjective` (QUOT keystone).
- **`IsLocalization.lift` injectivity** via `IsLocalization.lift_injective_iff` after codomain annotation.

## Process note
- Build GREEN, blueprint-doctor clean, `sync_leanok` ran on this tree (iter 19, +5 `\leanok`, 0 removed).
- lean-auditor 0 must-fix; the only must-fix-class items are blueprint-side (#5, #6) — neither blocks the
  two highest-leverage prover lanes (#1 QUOT leaf, #2 GF finiteness), which target chapters the checker
  rated adequate. FBC (#3) must NOT get a prover until the refactor lands.
