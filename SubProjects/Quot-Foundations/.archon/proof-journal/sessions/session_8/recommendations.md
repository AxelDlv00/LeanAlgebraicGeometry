# Recommendations for iter-009 (from session_8 review)

## CRITICAL / HIGH

1. **FBC: author `% LEAN SIGNATURE` blocks for the 3 mate-trace sub-lemmas BEFORE re-dispatching the
   FBC `generator_trace_eq` lane.** `lem:base_change_mate_unit_value`,
   `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose` have prose + `\lean{}`
   hints but no signature pin — the iter-008 prover correctly refused to guess types for
   adjunction-unit / pseudofunctor-reindex / transpose-on-elements. Both the FBC checker (major) and
   the prover task_result flag this. **Action:** dispatch a blueprint-writer scoped to
   `Cohomology_FlatBaseChange.tex` to author the three `% LEAN SIGNATURE` blocks (mathematician-pinned
   types), then the HARD-GATE re-review, then the prover. A `% NOTE` flagging the gap is already in the
   chapter. Without the signatures, `base_change_mate_generator_trace_eq` (line 1028) cannot proceed.

2. **`\leanok` sync discrepancy on the GF chapter — confirm a clean `sync_leanok` re-run restores it.**
   `Picard_FlatteningStratification.tex` has **zero `\leanok`** despite `gf_generic_rank_ses` +
   `gf_clear_one_denominator` being verified axiom-clean and the iter-004 L3 chain still `sorry`-free
   (sync recorded `removed: 12, added: 1`, sha `c97d3dd` not in this repo's git log → it ran against an
   intermediate non-green tree). The current tree is GREEN. The review agent cannot touch `\leanok`.
   **Action:** the next iter's deterministic `sync_leanok` should restore the GF markers; if it does
   not, inspect the `\lean{}` pins / sync inputs. This matters because the DAG's "done" status and the
   HARD GATE both read `\leanok` — a falsely-empty GF chapter will mis-report progress.

3. **GrassmannianCells lane delivered NO output this iter — decide its iter-009 disposition.** The
   `gr_transition` lane (Cramer-inverse `transitionMap` + cocycle) was dispatched but committed no
   edits and wrote no task_result; the file is unchanged. `def:gr_transition` is a gate-cleared
   frontier node with its only `\uses` dep (`def:gr_affine_chart`) landed iter-007 — so it *is* ready.
   **Action:** either re-dispatch it as a clean parallel lane, or de-prioritise it explicitly so it
   doesn't silently consume budget again. Do not leave it as an unowned assigned lane.

## Closest-to-completion (prioritize)

- **FBC `base_change_mate_regroupEquiv` `map_smul'` — deploy route (b).** Only the two `r' • 0 = 0`
  zero-branches remain; the substantive generator computation is proven. Route (b) = retype `g`'s
  domain/codomain at the genuine iso objects `(restrictScalars includeRight).obj ((extendScalars …).obj M)`
  / `(extendScalars ψ).obj …` so the `R'`-module is **transparent**; then `simp [smul_zero, map_zero]`
  closes both branches and the `tmul`/`add` branches carry over. This is a refactor of the `g`
  construction (likely a small `refactor`-subagent or prover task on the existing decl). **Do NOT
  re-issue the refuted one-liner `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`**
  (Knowledge Base: DISPROVEN iter-006). Also: the stale iter-006 NOTE at `FlatBaseChange.lean:851-853`
  still advertises that refuted one-liner — the next prover owning the file should delete/correct it
  (auditor major; review cannot edit `.lean`).

- **GF L5 `exists_free_localizationAway_polynomial` — close once `gf_torsion_reindex` lands.** The
  base-domain-generalizing strong induction is in place (the load-bearing advance); the single inner
  `sorry` is gated only on `gf_torsion_reindex` + motive plumbing + the L3 splice. Sequence: land
  the reindex engine first (below), then this closes.

## Promising approaches needing more work

- **GF `gf_torsion_reindex` — effort-break into the shared single-variable elimination engine.** The
  Mathlib-absent core is single-variable Nagata change-of-variables + division-algorithm +
  leading-coeff denominator-clear over `MvPolynomial`. **Action:** dispatch an effort-breaker on
  `lem:gf_torsion_reindex` to split out a standalone `MvPolynomial` single-variable elimination helper
  (`F` monic in `X_d` up to leading coeff `g`; after inverting `g`, `A_g[X]/(F)` finite over
  `A_g[X_{<d}]` by division algorithm). This same engine is what L4 Step 2 needs — build once, reuse
  twice (the chapter `% NOTE`s already flag the sharing). First step exists:
  `Submodule.annihilator_top_inter_nonZeroDivisors`.

- **GF L4 `exists_localizationAway_finite_mvPolynomial` — effort-break the Noether-normalisation
  descent.** `gf_clear_one_denominator` (now proved) supplies the per-equation denominator-clearing
  primitive; the remaining residue is the module-finiteness descent `K → A_g` (lift `b̄_j ∈ B_K` to
  `b_j ∈ B`). Break it as its own lemma before re-dispatching.

## Blocked — do NOT re-assign without a structural change

- **FBC `map_smul'` via the separate-module one-liner** — DISPROVEN iter-006; the carriers are
  different *types*, not a reducibility diamond. Use route (b) (transparent `Module R'` instance).
- **FBC `generator_trace_eq` monolithic** — blocked on the 3 sub-lemma signatures (item 1 above); do
  not re-dispatch the assembly until they exist.
- **`gf_torsion_reindex` monolithic** — Mathlib-absent; must be effort-broken (above), not re-thrown
  as one `sorry`.
- **`genericFlatnessAlgebraic` dévissage assembly** — do NOT wire the prime-filtration induction
  until L4/L5 leaves close; it would just relocate the sorry (Knowledge Base).
- **`affineBaseChange_pushforward_iso` / `flatBaseChange_pushforward_isIso`** — gated on the FBC mate
  lemma + Čech/equalizer infra; keep deferred. The FBC checker noted a precision gap on the former
  ("definitional plus naturalities" vs the Lean's "multi-hundred-LOC build") — if it is ever
  re-opened, the affine-reduction step needs a named sub-lemma with a `% LEAN SIGNATURE`, not the
  current thin prose.

## QUOT-A (deferred lane — gate it next iter)

The plan prepared `Picard_QuotScheme.tex` this iter (blueprint-writer + clean: added
`lem:annihilator_localization_eq_map`, the `lem:qcoh_section_localization_basicOpen` QCoh→
`IsLocalizedModule` bridge, a `\mathlibok` anchor, and re-wired `def:modules_annihilator`). Per the
plan, QUOT-A receives the **mandatory blueprint-reviewer** next iter before any prover runs on it.
Honor that gate — the chapter changed, so a fresh `complete + correct` verdict is required before
`QuotScheme.lean` re-enters objectives.

## Reusable proof patterns discovered this iter (also added to PROJECT_STATUS Knowledge Base)

- **`erw` past opaque-instance keyed mismatch.** When a smul/linearity rewrite lemma is the *right*
  lemma but `rw` reports "Did not find an occurrence of the pattern" because the module instance is an
  opaque `inferInstanceAs`/`letI` aux-def, `erw` matches up to defeq and fires (`erw
  [ModuleCat.ExtendScalars.smul_tmul]`). For the final leaf, a `show` of both sides in the
  transparent form (letting identity-bridges like `eT` drop by defeq) then a plain `rw` chain closes
  it. The residual `smul_zero`/`smul_add` on the *same* opaque carrier still fail (synthesis, not
  keying) — that is the transparent-instance wall, not fixable by `erw`.
- **Generic-rank SES over a polynomial domain (Nitsure §4).** `m = finrank (FractionRing P) (S⁻¹N)`;
  lift a `K`-basis along `IsLocalizedModule.mkLinearMap` with units (`IsLocalization.map_units` +
  `LinearIndependent.units_smul`), descend independence via `IsFractionRing.injective` +
  `LinearIndependent.of_comp`, `φ := Fintype.linearCombination`, cokernel torsion via
  `IsLocalization.exist_integer_multiples` + `IsLocalizedModule.eq_zero_iff` (the kernel handle).
- **`IsLocalization.map` for non-canonical localization-to-fraction-field maps.** When the literal
  `algebraMap (Localization.Away g) (FractionRing A)` has no `Algebra` instance, encode the same map
  as `IsLocalization.map (FractionRing A) (RingHom.id A) hle` with
  `hle : powers g ≤ comap id (nonZeroDivisors A)` (`Submonoid.powers_le`).
- **Base-domain-generalizing strong induction.** When a reindex step changes the base ring
  (`A → A_g`), the IH must generalize `A` too: `Nat.strong_induction_on generalizing A N`, with a
  shared universe `(A N : Type u)` because `LocalizedModule S M : Type (max u_R u_M)`.
