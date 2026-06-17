# Session 4 (iter-004) — Review Summary

## Metadata
- Iteration: 004 | Session: session_4 | Model: claude-opus-4-8
- Total project sorry: **12 before → 12 after** (composition shifted: FBC 3→4, GF 5→4,
  QuotScheme 4→4 untouched). The flat count masks real progress — see below.
- Lanes dispatched: **FBC-A** (`Cohomology/FlatBaseChange.lean`), **GF-alg**
  (`Picard/FlatteningStratification.lean`). QuotScheme had no prover (blueprint-only QUOT track).
- Build: GREEN (final `lake build` success; 0 errors, sorry/long-line/deprecation warnings only).
- 21 edits, 2 builds, 40 lemma searches, 18 diagnostic checks (from `attempts_raw.jsonl`).

## Headline: 7 obligations newly proved (all axiom-clean), 2 residues isolated

The count-on-paper is flat at 12, but the iter closed **the entire GF L3 chain** (the iter-003
frontier crux) plus the FBC L4-a helper, and **isolated** the two genuine FBC cruxes into named,
independently-attackable sorries. Branches genuinely closed this iter:

- **GF L3 chain — 4 lemmas, all axiom-clean:** `exact_localizedModule_powers_of_shortExact` (L3a),
  `free_localizationAway_of_free_of_eq_mul` (L3b, the 553-effort leaf),
  `free_of_shortExact_of_free_free` (L3c), and the assembly
  `exists_free_localizationAway_of_shortExact` (the iter's primary objective).
- **GF L5 torsion sub-case** proved (`by_cases htors` → torsion branch via L1 torsion base case).
- **FBC L4-a:** `base_change_regroup_linearEquiv` proved axiom-clean (the pure-tensor-algebra core);
  `base_change_mate_generator_trace` (L4-c) proof body closed.

## FBC-A lane (`Cohomology/FlatBaseChange.lean`)

The planner's L4 fine-decomposition. The mathematical core landed; two plumbing/coherence residues
remain.

### `base_change_regroup_linearEquiv` — SOLVED (axiom-clean)
- The blueprint `comm ≪≫ cancelBaseChange ≪≫ comm` core as a standalone `R'`-linear equiv
  `(A ⊗[R] R') ⊗[A] M ≃ₗ[R'] R' ⊗[R] M` on **canonical** instances, `R'` acting through
  `Algebra.TensorProduct.rightAlgebra` (the `includeRight` factor).
- `map_smul'` proved on generators via `TensorProduct.induction_on`; key fact
  `hsmul : r' • ((a⊗s)⊗m) = (a⊗(r'*s))⊗m` from `TensorProduct.smul_tmul'` +
  `algebraMap R' (A⊗[R]R') r' = 1⊗ₜr'` (rfl) + `tmul_mul_tmul`.
- **Key insight:** `cancelBaseChange` is only `B`-linear in the `M`-factor; the needed
  `R'`-linearity (in the base-change factor) is NOT its declared linearity and must be re-proved by
  hand. `lean_verify` → `[propext, Quot.sound]`.
- ⚠ Unmatched `lean_aux` (coverage debt — no blueprint block yet). See recommendations.

### `base_change_mate_regroupEquiv` — PARTIAL (`map_smul'`/`hms` sorry, line 978)
- Object-form `ModuleCat R'` iso in the exact `restrictScalars`/`extendScalars` packaging the
  domain/codomain reads use, built from `g = comm ≫ (congr eT) ≫ cancelBaseChange ≫ comm` (`eT` =
  identity `A`-linear bridge resolving the `Module A (A ⊗[R] R')` diamond).
- **Wall (documented, confirmed not a math gap):** after `TensorProduct.induction_on` strips the
  `restrictScalars` object wrapper, the object `R'`-smul on the bare tensor carrier is opaque to
  every standard smul lemma (`smul_zero`/`smul_add`/`restrictScalars.smul_def`/`ExtendScalars.smul_tmul`
  all fail to match syntactically). The smul **is defeq** to the canonical `rightAlgebra` action
  (`rfl` closes it) — a tactic/instance-matching wall. ~15 `lean_run_code` attempts (`simp made no
  progress`, `rewrite did not find pattern ?a • (?b₁+?b₂)`) confirm the in-file dead-end.
- **Clean closure found:** `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`
  typechecks sorry-free ONLY when `base_change_regroup_linearEquiv` lives in a separately-compiled
  module (the imported type normalizes the diamond; same-file it does not reduce). The prover
  verified this end-to-end in a scratch import. (Lean-auditor noted the "separate module" claim is
  unverifiable from source alone — confirm on first attempt.)

### `base_change_mate_generator_trace_eq` — PARTIAL (sorry, line 1010)
- The genuine mate-unwinding crux: `(domain_read).inv ≫ Γ(α) ≫ (codomain_read).hom = regroupEquiv.inv`
  (sends `r'⊗m ↦ (1⊗r')⊗m`). The 3-step adjoint-mate trace (unit value `m ↦ (1⊗1)⊗m` →
  `f_* = restrictScalars φ` reindex → `(g^* ⊣ g_*)` transpose) is recorded in the docstring but has
  no Mathlib-direct route. Effort-breaker's flagged re-break candidate.

### `base_change_mate_generator_trace` — SOLVED (transitively on the two above)
- `rw [base_change_mate_generator_trace_eq]; infer_instance`. Re-closes the leaf that
  `pushforward_base_change_mate_cancelBaseChange` consumes; that parent's direct proof stays
  sorry-free modulo this transitive chain.

### Deferred (unchanged sorries): `affineBaseChange_pushforward_iso` (1141, per-open
restriction-compatibility, Mathlib-absent), `flatBaseChange_pushforward_isIso` (1163, Čech infra).

## GF-alg lane (`Picard/FlatteningStratification.lean`)

### L3 chain — fully closed (4 lemmas, axiom-clean)
- **L3a** `exact_localizedModule_powers_of_shortExact`: `LocalizedModule.map_injective` /
  `map_surjective` / `map_exact` on `restrictScalars A` of `i`, `q`. `map_exact` is defeq to
  `LocalizedModule.map S`, applies directly.
- **L3b** `free_localizationAway_of_free_of_eq_mul` (the hard 553-effort leaf): `N_f` is the
  localisation of `N_{f'}` at the image of `f''`; free transports via base-change cancellation.
  Chain: `IsLocalization.Away.awayToAwayLeft` (after `rw [mul_comm]`) → `Module.compHom` →
  `Commute.isUnit_mul_iff` (f' acts invertibly) → `IsLocalizedModule.lift` →
  `LinearMap.extendScalarsOfIsLocalization` → `IsBaseChange.of_comp` → `.free`.
  **Dead-end avoided:** the converse of `IsLocalization.Away.mul'` is NOT in Mathlib;
  `IsBaseChange.of_comp` sidesteps it.
- **L3c** `free_of_shortExact_of_free_free`: 3 lines — `Module.projective_lifting_property` →
  `Function.Exact.splitSurjectiveEquiv` → `Module.Free.of_equiv`.
- **L3 assembly** `exists_free_localizationAway_of_shortExact`: witness `f' * f''`; L3b twice, L3a, L3c.

### L4 `exists_localizationAway_finite_mvPolynomial` — RE-SIGNED + PARTIAL
- Re-signed to the AlgHom form (cleaner than iter-003's 3-anonymous-instance version). First attempt
  omitted the `(_ : Algebra A_g B_g)` binder → `failed to synthesize Algebra (Localization.Away g)
  (Localization.Away (algebraMap A B g))`; re-added as the 3rd existential (genuine elaboration
  requirement, NOT a math change — auditor confirmed honest).
- Step 1 (Noether normalisation over `K = FractionRing A` via `exists_finite_inj_algHom_of_fg`)
  compiles. **Step 2 (denominator clearing) is the Mathlib-absent residue** (sorry, line 445).
- ⚠ The blueprint `% LEAN SIGNATURE` block is **stale** — claims that binder was removed. `% NOTE`
  added this review; planner must update the block.

### L5 `exists_free_localizationAway_polynomial` — PARTIAL
- `d=0` (pre-existing) + `d≥1` torsion sub-case (NEW, `by_cases htors` → `exists_free_localizationAway_of_torsion`).
  Genuine content (auditor-confirmed). The non-torsion generic-rank dévissage is the residue (sorry,
  line 495). **Structural flag:** the current skeleton uses a `rcases` case-split with no IH in scope;
  filling the sorry requires restructuring to strong induction on `d` (universally-quantified `N`).

### Deferred: `genericFlatnessAlgebraic` (562, prime-filtration assembly), `genericFlatness` (629, geo).

## Review subagent findings (full reports linked in recommendations.md)
- **lean-auditor** `iter004`: 0 must-fix / 3 major / 6 minor / 0 excuse-comments. Confirmed every
  sorry is honest; the L3 lemmas, L4-a helper, and re-signed L4 signature are genuine/improved.
- **lean-vs-blueprint-checker** `fbc`: faithful, 0 must-fix, 1 major (sync_leanok proof-block gap),
  2 minor (helper coverage debt; affine-reduction not isolated).
- **lean-vs-blueprint-checker** `gf`: faithful all 12 decls, 0 must-fix, 1 major (stale L4
  `% LEAN SIGNATURE` block — addressed with `% NOTE` this review).

## Key patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Re-prove R'-linearity by hand for `cancelBaseChange`:** it is only `B`-linear in the `M`-factor;
  base-change-factor linearity must be re-bundled via `TensorProduct.induction_on` + `rightAlgebra`.
- **Same-file ModuleCat instance-diamond non-reduction:** a `restrictScalars∘extendScalars` carrier
  diamond that is defeq but won't reduce same-file DOES reduce when the helper is in a separately
  compiled (imported) module. Candidate idiom for the whole project when an instance diamond blocks
  `toModuleIso` packaging.
- **`IsBaseChange.of_comp` for localization towers:** sidesteps Mathlib-absent converse-localization
  lemmas (`IsLocalization.Away.mul'` converse) when transporting freeness across `A_{f'} → A_{f'f''}`.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_noether_clear_denominators`: added `% NOTE:`
  flagging the stale `% LEAN SIGNATURE` block (omits the `Algebra A_g B_g` binder the landed Lean
  retains; planner to update prose).
- No `\mathlibok` added (provers used Mathlib lemmas inside proofs, not as re-export anchors).
- No `\lean{...}` corrections (all new-decl pins matched the blueprint per both checkers).
- No stale `\notready` to strip (none present in active chapters).
- `\leanok` NOT touched (sync_leanok ran for iter-004: +12 / −19; see notes).

## Notes (LOW)
- `sync_leanok-state.json` records iter=4, added 12 / removed 19. The fbc checker reports ~19
  fully-proved lemmas lack PROOF-block `\leanok` (statement blocks are marked). This is a
  deterministic-sync concern outside the review agent's `\leanok` domain — surfaced for the planner
  to investigate, not papered over here.
- Pervasive stale parent-project iter-number references (`iter-173`…`iter-241` from
  *Algebraic-Jacobian-Challenge*) across all four `.lean` files — harmless, cosmetic.
