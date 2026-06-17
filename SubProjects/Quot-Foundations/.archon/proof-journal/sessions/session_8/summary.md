# Session 8 (iter-008) — Summary

## Metadata
- **Iteration / session:** iter-008 / session_8
- **Model:** claude-opus-4-8 (provers)
- **Build:** GREEN — `lean_diagnostic_messages` reports 0 errors on both edited files (only `sorry` warnings + deprecation/lint warnings).
- **Sorry count (per actual tactic-site `sorry`):**
  - FlatBaseChange.lean: 4 → **5** (net +1; map_smul' split into 2 zero-branches, but its substantive generator computation is now PROVEN)
  - FlatteningStratification.lean: 4 → **5** (net +1; 2 new axiom-clean lemmas + 1 new `sorry`-bodied `gf_torsion_reindex`)
  - GrassmannianCells.lean: 0 → 0 (assigned lane delivered NO edits)
  - QuotScheme.lean: 4 → 4 (deferred, untouched)
- **Targets attempted:** FBC `map_smul'` + `generator_trace_eq`; GF `gf_generic_rank_ses`, `gf_clear_one_denominator`, `gf_torsion_reindex`, `exists_free_localizationAway_polynomial` (L5), `exists_localizationAway_finite_mvPolynomial` (L4, untouched); GrassmannianCells `gr_transition` (no output).
- **Net:** 2 declarations PROVED axiom-clean; 1 load-bearing structural restructure (L5 base-domain induction); 1 substantive proof (FBC map_smul' generator computation, 2 trivial residue sorries). Sorry count flat-to-+1 per file but with genuine forward movement — NOT churn.

## FBC — `base_change_mate_regroupEquiv` `map_smul'` (the iter-006 "load-bearing" target)

**Result: PARTIAL — the substantive content is RESOLVED.** This is the first iter to execute
route (a) end-to-end on the generator (prior iters 006/007 only documented it as blocked, and the
iter-004/006 "separate-module one-liner" was definitively refuted). The `tmul.tmul` leaf, the outer
`add`, and the inner `tmul.add` branches all compile. Only the two `zero` branches (`r' • 0 = 0`)
remain `sorry` (lines 951, 960). Axiom footprint: `sorryAx` + the standard three; no new axioms.

**The unlock (key insight):** the object `R'`-smul `r' • z` is *defeq* to the `A ⊗[R] R'`-module
smul `includeRight r' • z`, but the opaque `_aux_3`/`_aux_5` `Module R'` instances make plain `rw`
fail by **keyed-instance mismatch**. `erw [ModuleCat.ExtendScalars.smul_tmul]` matches up to defeq
and fires. The sequence of failed→working attempts (full list in `milestones.jsonl`):
- `rw [TensorProduct.smul_tmul', …]` → "Did not find an occurrence of the pattern" (wrong keyed instance).
- `rw [ModuleCat.ExtendScalars.smul_tmul, …]` → still "Did not find ?s • ?s' ⊗ₜ ?m" (plain `rw`).
- `erw [ModuleCat.ExtendScalars.smul_tmul]` → **fires.** Then `show` both sides as
  `(comm_R) ((cancelBaseChange …) (m ⊗ₜ[A] (a ⊗ₜ[R] t)))` (the `eT` bridge drops by defeq) and close
  with `rw [cancelBaseChange_tmul, cancelBaseChange_tmul, comm_tmul, comm_tmul, smul_tmul', smul_eq_mul]`
  — both sides become `(r' * s) ⊗ₜ (a • m)`.
- `add` nodes need `erw` (not `rw`) for the same keyed-instance reason.

**Residual dead-end (the two `zero` branches):** `r' • 0 = 0` needs `SMulZeroClass ↑R'` on the
`extendScalars`/`restrictScalars` carrier. Through the opaque object `Module ↑R'` instances this is
**neither typeclass-synthesizable** (`simp [smul_zero]`/`erw [smul_zero]` → "failed to synthesize
SMulZeroClass") **nor keyed-matchable** (`rw [smul_zero]` finds no occurrence). `letI`/`haveI`
re-supply through `inferInstanceAs` compiles to a fresh opaque `_aux` TC still ignores; the
`.toDistribMulAction` projection variant times out `whnf` (200k heartbeats).

**Documented fix (route (b)):** retype `g`'s domain/codomain at the genuine iso objects
`(restrictScalars includeRight).obj ((extendScalars …).obj M)` / `(extendScalars ψ).obj …` (whose
`R'`-modules are *transparent*), removing the opaque `letI instLHS`/`instRHS`. Then both `zero`
branches close by plain `simp [smul_zero, map_zero]` and the working `tmul`/`add` branches carry
over unchanged. **Do NOT re-issue the refuted one-liner** (`exact LinearEquiv.toModuleIso …`).

> Side note: lean-auditor flagged the iter-006 NOTE at `FlatBaseChange.lean:851-853` (claiming the
> one-liner closes `map_smul'` once `RegroupHelper.lean` is imported). That NOTE describes the
> **refuted** path (Knowledge Base, "Separately-compiled-module trick — DISPROVEN"). The auditor has
> no strategy context so reads it as a live suggestion; it is not. The correct fix is route (b).

## FBC — `base_change_mate_generator_trace_eq` — BLOCKED (blueprint under-specified)

Not attempted. The `ext x` reduction was committed pre-iter-008; closing the per-generator identity
needs the three sub-lemmas `base_change_mate_unit_value` / `_fstar_reindex` / `_gstar_transpose`,
which **do not exist in the Lean file** because the blueprint gives them prose + `\lean{}` hints but
**no `% LEAN SIGNATURE` block**. The prover correctly declined to fabricate the Lean types for
adjunction-unit/pseudofunctor-reindex/transpose-on-elements (banned hollow-decl risk). Confirmed by
the FBC lean-vs-blueprint-checker as a **major blueprint-side under-specification**. I added a
consolidated `% NOTE` over the three blocks; the plan agent must author the `% LEAN SIGNATURE`s.

## GF — two axiom-clean closures + the load-bearing L5 restructure

- **`gf_generic_rank_ses` — PROVED, axiom-clean** (verified `[propext, Classical.choice, Quot.sound]`).
  The generic-rank SES `0→P_d^{⊕m}→N→T→0`. `m = finrank K NK` over `K = FractionRing P_d`; lift a
  `K`-basis along `ℓ = mkLinearMap` with units (`LinearIndependent.units_smul`), restrict scalars
  (`IsFractionRing.injective`, `LinearIndependent.of_comp`) to get `LinearIndependent P_d v`;
  `φ := Fintype.linearCombination`; cokernel torsion via `IsLocalization.exist_integer_multiples` +
  `IsLocalizedModule.eq_zero_iff` (the clean kernel handle), `Submodule.Quotient.mk_smul` bridging
  the `↥(P_d)⁰`- and `P_d`-actions.
- **`gf_clear_one_denominator` — PROVED, axiom-clean.** `g` = common denominator from
  `exist_integer_multiples` over `p.support`; the `A_g → K` map encoded as
  `IsLocalization.map (FractionRing A) (RingHom.id A) hle` (NOT the blueprint's literal
  `algebraMap (Localization.Away g) (FractionRing A)`, which has no canonical `Algebra` instance);
  coefficientwise via `MvPolynomial.ext`. Dead-end avoided: `rw [← hunit.unit_spec]` → "motive not
  type correct"; use `Units.inv_mul` then `rwa [hunit.unit_spec]`.
- **`exists_free_localizationAway_polynomial` (L5) — PARTIAL, load-bearing restructure landed.** The
  induction is now `Nat.strong_induction_on generalizing A N` — the IH genuinely quantifies over the
  **base domain `A`** at every `m < d` (verified via `lean_goal`), fixing the named iter-006 root
  cause (the reindex changes base to `A_g`). Base `d=0` + torsion subcase compile; the non-torsion
  step extracts the SES via `gf_generic_rank_ses` (real consumption, typechecks). One inner `sorry`
  remains, blocked only on `gf_torsion_reindex` + motive plumbing on `N ⧸ range φ`, the `A_g → A`
  witness descent, and the L3 splice.
  - **Signature change (FLAGGED):** `(A : Type*) (N : Type*)` → shared universe `(A N : Type u)`.
    Forced: `LocalizedModule S M : Type (max u_R u_M)`, so the reindexed module escapes `N`'s
    universe; a universe-bumping self-recursion is only well-formed when `A`, `N` share a universe
    (and the geometric target lives in `Type u`). I recorded this as a `% NOTE` on
    `lem:gf_polynomial_core`.
- **`gf_torsion_reindex` — created, `sorry` (Mathlib-absent).** Single-variable Nagata
  change-of-variables + division algorithm + leading-coeff denominator-clear over `MvPolynomial`.
  `Submodule.annihilator_top_inter_nonZeroDivisors` gives the first step (`0 ≠ F ∈ Ann_{P_d}(T)`);
  the variable-elimination is the hard residue. Next-iter effort-break = a standalone `MvPolynomial`
  single-variable elimination helper, reusable by L5b and L4 Step 2 (the shared engine).
- **L4 `exists_localizationAway_finite_mvPolynomial` — unchanged `sorry`.** `gf_clear_one_denominator`
  now exists for Step 2's Finset-fold, but the Noether-normalisation descent (`K → A_g`) remains.

## GrassmannianCells lane — NO OUTPUT (surface to planner)

The plan dispatched a third lane (`gr_transition`: Cramer-inverse `transitionMap` + cocycle), but
`attempts_raw.jsonl` `files_edited` lists **only** FlatBaseChange + FlatteningStratification, and no
`task_result` was written for GrassmannianCells. The file is unchanged (0 real sorries, 1 stale
docstring at ~line 57-59). The lane appears ~20× in `provers-combined.jsonl` (reads/searches) but
delivered nothing committed. The planner should account for this in iter-009 (re-dispatch the
gate-cleared frontier node, or de-scope it relative to the FBC/GF deep lanes).

## `\leanok` / sync discrepancy (HIGH — for the planner)

The GF chapter `Picard_FlatteningStratification.tex` currently carries **zero `\leanok` markers**,
yet `gf_generic_rank_ses` and `gf_clear_one_denominator` verify axiom-clean, and the entire
iter-004 L3 chain (lines 105–408) is still `sorry`-free. `sync_leanok-state.json` (iter 8, sha
`c97d3dd`) records `removed: 12, added: 1` across the GF + QuotScheme chapters — i.e. sync stripped
the GF chapter's `\leanok` (including the closed L3 chain). The current working tree is GREEN and
the decls verify clean, so this is a **sync-timing artifact** (sync evidently ran against an
intermediate non-green tree — note sha `c97d3dd` is not present in this repo's `git log`), not
laundering and not a math regression. I cannot touch `\leanok` (sync's domain). **A clean
`sync_leanok` re-run on the current green tree should restore the GF `\leanok` markers**; if it does
not, the `\lean{}` pins or sync inputs need inspection. Surfaced in `recommendations.md`.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_polynomial_core`: added `% NOTE` recording the
  iter-008 shared-universe `(A N : Type u)` signature (load-bearing; gf-checker major + prover flag).
- `Picard_FlatteningStratification.tex`, `lem:gf_clear_one_denominator`: added `% NOTE` recording
  that the Lean encodes the `A_g → K` map via `IsLocalization.map …` (no canonical `Algebra`
  instance for the literal `algebraMap (Localization.Away g) (FractionRing A)`) — gf-checker minor.
- `Cohomology_FlatBaseChange.tex`, mate-trace section (above `lem:base_change_mate_unit_value`):
  added a consolidated `% NOTE` flagging that the three mate-trace sub-lemmas lack `% LEAN SIGNATURE`
  blocks and the plan agent must author them before the next FBC dispatch (fbc-checker major).
- No `\mathlibok` added (no Mathlib re-export decls landed this iter). No `\lean{}` renames (no decl
  renamed — L5 kept its name). No stale `\notready` found.

## Review subagents (all three highly-recommended dispatched; both `.lean` files were edited)
- **lean-auditor `iter008`** (whole project): SOUND — 7 files, 0 critical / 3 major / 4 minor, **0
  must-fix**. All `sorry`s honest scaffolding; no excuse-comments; no weakened defs. Majors: 22
  deprecated `CategoryTheory.Sheaf.val` sites in FBC; stale `GrassmannianCells.lean:57-59` docstring;
  the FBC:851-853 NOTE (the refuted one-liner — see side note above). Confirmed the `map_smul'`
  tactic chain sound, the two GF lemmas sound, and the `Type u` universe change correct.
  Report: `task_results/lean-auditor-iter008.md`.
- **lean-vs-blueprint-checker `fbc-iter008`**: faithful (27 decls match), **major blueprint-side**:
  the 3 mate-trace sub-lemmas need `% LEAN SIGNATURE` blocks; precision gap on
  `affineBaseChange_pushforward_iso` ("definitional plus naturalities" vs the Lean's "multi-hundred-LOC
  build"). 0 fake bodies. Report: `task_results/lean-vs-blueprint-checker-fbc-iter008.md`.
- **lean-vs-blueprint-checker `gf-iter008`**: faithful (18 decls), 0 red flags. Major (blueprint):
  `lem:gf_polynomial_core` needed the shared-universe `% NOTE` (added). Minor: `gf_clear_one_denominator`
  spec-comment imprecision (added `% NOTE`). Confirmed both new lemmas axiom-clean.
  Report: `task_results/lean-vs-blueprint-checker-gf-iter008.md`.

## Graph health
- `archon dag-query gaps` = 0; `archon dag-query unmatched` = 0 (no coverage debt — all new decls
  already have blueprint blocks). blueprint-doctor: CLEAN (no orphan chapters, no broken refs/uses,
  no axioms).

## Notes (LOW)
- Deprecation: 22 `CategoryTheory.Sheaf.val` sites in FBC (use `ObjectProperty.obj`) — cosmetic,
  clear when the file is next owned by a prover (review cannot edit `.lean`).
- 1 cosmetic `simpa`/unused-`id_eq`-simp-arg lint in the GF/FBC edits — harmless.
