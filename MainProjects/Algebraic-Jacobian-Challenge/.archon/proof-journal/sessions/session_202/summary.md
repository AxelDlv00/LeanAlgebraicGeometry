# Session 202 (iter-202) — review summary

## Metadata

- **Iteration / session**: 202.
- **Sorry trajectory**: 78 → **83** (net **+5**). Breakdown:
  - Lane AB: **−1** (closed `auslander_buchsbaum_formula_succ_pd` body).
  - Lane WD: 0 (2 new decls added fully-proven; pre-existing file sorries untouched).
  - Lane COE: 0 (4 axiom-clean substrate bridges added; 3 pre-existing sorries unchanged).
  - Lane TS: **+6** (new scaffold file `Picard/TensorObjSubstrate.lean`, typed-sorry stubs **by design**).
  - Net +5 is driven **entirely** by the intentional TS scaffold; the substantive
    proof movement this iter is the AB top-level closure.
- **Axioms**: 0 project axioms (22nd consecutive zero-axiom build). All new
  declarations + the now-closed AB formula verify `{propext, Classical.choice, Quot.sound}`.
- **Build**: `lake build` GREEN; 4/4 prover lanes `done` (per `meta.json`).
- **Targets attempted**: 4 lanes — AB-Path-B-Close, WD-A4a-Sub-build-3,
  COE-Step-B-Bridges, TS-Scaffold.

## Headline

**The 16+-iteration Lane AB gap is CLOSED.** `RingTheory.auslander_buchsbaum_formula`
is now fully axiom-clean — the first genuine top-level theorem closure in many
iters (iters 199/200/201 were all net-0 substrate-only). This is the iter's
realistic-band target, met.

## Per-target detail

### Lane AB — `auslander_buchsbaum_formula_succ_pd` — SOLVED (axiom-clean)

HARD BAR MET. Body closed via `induction k generalizing M`; 4 new axiom-clean
helpers landed; 3 `private` removals done.

- **Inductive step (`pd M = k+2`)**: minimal surjection `f : R^n ↠ M`;
  `projectiveDimension_ker_eq_of_surjection` gives `pd(ker f)=k+1` exactly
  (squeeze: `projectiveDimension_le_iff` upper + `projectiveDimension_ge_iff`
  contrapositive lower); IH on `ker f`; `depth_ses_ineqs_of_surjection_finite_localRing`
  for parts (2)(3) of `depth_of_short_exact`; arithmetic combine via
  `enat_ab_inductive_combine`.
- **Base case (`pd M = 1`, Path B matrix-collapse)**: `ker f` projective ⟹ free
  (`free_of_flat_of_isLocalRing`); basis `φ : R^k ≃ₗ ker f` via
  `Module.finBasis...equivFun.symm`; `k ≥ 1` by subsingleton contradiction;
  SES `0 → R^k →[A] R^n →[f] M → 0` with `A`'s entries in `𝔪 = Ann κ`.
  Direction (B) `1 + depth M ≤ depth R`: `exists_ne_zero_ext_of_depth_eq` →
  nonzero `α : Ext^D(κ,R^k)`; matrix-collapse helper kills `α.comp(mk₀(ofHom A))`;
  sub-case `D=0` contradiction via `postcomp_mk₀_injective_of_mono`; sub-case
  `D=D'+1` uses `covariant_sequence_exact₁` to transport to nonzero `Ext^{D'}(κ,M)`,
  then `Order.add_one_le_of_lt`.

**Key Lean lessons (added to Knowledge Base):**
- `ℕ∞ = WithTop ℕ` has **no** `IsStrictOrderedRing` instance — reduce
  `min`/`sub`/`+` facts to `ℕ` disjunctions via `Nat.cast_*` and finish with `omega`.
- Use `by gcongr` (not `add_le_add_right`) for monotone `+1` on `ℕ∞`.
- `ShortComplex.mk … zero` goal: `rw [← ModuleCat.ofHom_comp, show f ∘ₗ A = 0 …]; rfl`
  (not `simp` — "made no progress").
- After `induction k generalizing M`, the IH consumes only the `pd` hypothesis.
- **Namespace caveat for iter-203**: the two promoted helpers are
  `RingTheory.CohenMacaulay.isDomain_of_regularLocal` and
  `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`
  (NOT bare `RingTheory.…`). Lane COE Step A1 must use fully-qualified names.

### Lane WD — `order_eq_order_restrict` — SOLVED (axiom-clean)

HARD BAR MET (both steps). `functionFieldIso_compat` (morphism-level
`stalkSpecializes` naturality) + `order_eq_order_restrict` (the order-on-curve
naturality across the function-field iso) both closed axiom-clean. File-local
sorry count unchanged.

**Key Lean lessons:**
- Plain `rw [TopCat.Presheaf.germ_stalkSpecializes]` FAILS ("pattern not found")
  on a terminal `germ ≫ stalkSpecializes` even when syntactically present; use
  the **term-mode** `(germ_stalkSpecializes _ _ _).trans (…).symm` (unifies via
  expected type) or the `_assoc` variant.
- `(stalkCongr e).hom = stalkSpecializes e.ge` is `rfl` (no Mathlib lemma); make
  a local `have hcongr := by intros; rfl`.
- `h_compat` discharges by defeq: `commRingCatIsoToRingEquiv x = e.hom.hom x` is
  `rfl`; `algebraMap (stalk x) functionField = (stalkSpecializes …).hom` is defeq
  up to proof-irrelevant `∈ univ` witnesses → `exact happ` closes it.

### Lane COE — Step B bridges — PARTIAL (HARD BAR met & exceeded)

3 of 4 sub-bridges axiom-clean (`exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension`,
`isLocalization_atPrime_stalk_of_affineOpen`, `gammaSpecField_ringEquiv` +
helper `open_eq_top_of_subsingleton`). B.d (regular-stalk close) genuinely gated
— **not a search failure**:
- Step A1 fenced behind the iter-202 AB `private`→public promotions (not yet
  cross-file visible this iter → iter-203 work).
- Closed-point residue-field route is provably **inapplicable** at a general
  codim-1 point `z` (residue field is transc-deg-1 over `kbar`, not `kbar`).
- Stacks 00OE smooth-algebra Krull-dim formula still open (~200-300 LOC).
- No-sorry invariant forbade adding a sorried skeleton.

**Lean lesson:** `Algebra.IsStandardSmoothOfRelativeDimension.out` fixes
`ix sx : Type` (Type 0) — state re-exports with `Type` exactly, not `Type*`
(else `Exists.{2}` vs `Exists.{u+1}` universe mismatch).

### Lane TS — `Picard/TensorObjSubstrate.lean` scaffold — PARTIAL (by design)

New file created GREEN with 4 blueprint-pinned typed-sorry stubs + supporting
helpers + import in `AlgebraicJacobian.lean`. HARD BAR met. `addCommGroup_via_tensorObj`
deliberately a `def` (not global `instance`) to avoid a diamond with the existing
`PicSharp.addCommGroup` typed-sorry instance in `RelPicFunctor.lean:235`.
`lem:pullback_compatible_with_tensorobj` (Piece 3d) intentionally NOT stubbed.

## Conditional pre-commitments — status

- The iter-202 plan agent's progress-critic pre-commitment ("if iter-202 ends
  with 0 net sorry movement across all 4 lanes → user escalation in iter-203")
  **did NOT fire**: Lane AB closed a top-level theorem, Lane WD met its HARD BAR.
- The AB user-escalation trigger ("if `_succ_pd` body returns PARTIAL") **did NOT
  fire** — the body closed. Discharged.

## Blueprint markers updated (manual)

- `Albanese_AuslanderBuchsbaum.tex`, `lem:auslander_buchsbaum_formula_succ_pd`:
  removed the stale iter-199/200/201 `% NOTE` chain requesting `private` removal
  (now RESOLVED — `private` dropped, body closed); replaced with a one-line
  iter-202 RESOLVED note.
- `Albanese_CodimOneExtension.tex`, `subsec:stage6_iib_substrate_iter200` (Step A1
  recipe): corrected 6 wrong Lean declaration names (`\lean{...}` correction
  domain) — `RingTheory.isDomain_of_regularLocal` →
  `RingTheory.CohenMacaulay.isDomain_of_regularLocal` and
  `RingTheory.regularLocal_quotient_isRegularLocal_of_notMemSq` →
  `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`
  (the bare names do not resolve; resolves a coe-iter202 **must-fix** that would
  have broken the iter-203 prover recipe). Added a `% NOTE` flagging the now-stale
  "currently private" prose for the plan agent.

(All `\leanok` additions — 11 this iter — are the deterministic `sync_leanok`
pass, not manual; see `sync_leanok-state.json`.)

## Subagent findings

See `recommendations.md` for actioned CRITICAL/HIGH/MEDIUM items. Reports:
- `task_results/lean-auditor-iter202.md`
- `task_results/lean-vs-blueprint-checker-{ab,coe,wd,ts}-iter202.md`

## Blueprint doctor

No structural findings (all chapters `\input`'d, all `\ref`/`\uses` resolve, no
new axioms). See `logs/iter-202/blueprint-doctor.md`.

## Recommendations for next session

See `recommendations.md`. Headline: Lane AB is DONE; iter-203 Lane COE Step A1
can now consume the promoted `RingTheory.CohenMacaulay.*` helpers (fully-qualified);
plan agent should add `\lean{...}` blocks for the 2 new WD declarations.
