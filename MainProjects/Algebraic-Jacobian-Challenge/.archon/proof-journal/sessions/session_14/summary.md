# Session 28 — Iter-018 Prover Round (Path-2 Mayer-Vietoris LES Composition-is-Zero Lemma `HModule'_toBiprod_fromBiprod`)

## Metadata

- **Archon iteration**: 018 (canonical) — Path-2 Mayer-Vietoris LES *composition-is-zero* lemma (the third of three LES building blocks; the first two — `HModule'_toBiprod` / `HModule'_fromBiprod` — landed iter-017). Connecting hom `δ` plus LES sequence + exactness deferred to iter-019+.
- **Session number**: 28 (prover-round counter — sessions 22 / 23 / 24 / 25 / 26 / 27 / 28 cover iter-012 / iter-013 / iter-014 / iter-015 / iter-016 / iter-017 / iter-018 respectively).
- **Stage**: prover (single-lane, on `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`).
- **Sorry count before this session**: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`).
- **Sorry count after this session**: 9 (unchanged at the project level — same distribution; the iter-018 plan trajectory was `9 → 10 → 9` but the refactor sub-phase did not produce a separate `:= by sorry` site, so the project-level count never lifted to 10. The new lemma was added with its closure proof in a single Edit.).
- **Targets attempted**: 1 (`AlgebraicGeometry.Scheme.HModule'_toBiprod_fromBiprod`).
- **Targets solved**: 1.
- **First-edit closure rate**: 100% (extends the streak to **twelve** consecutive prover rounds — sessions 12, 13, 14, 15, 20, 21, 22, 24, 25, 26, 27, 28).
- **New `axiom` declarations**: 0.
- **Files edited**: 1 (`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`).
- **Pre-processed events** (`attempts_raw.jsonl`): 16 events — 1 Edit (combined refactor scaffold + closure proof for the iter-018 lemma into one `old_text`/`new_text` pair, post-iter-017 anchor — the `noncomputable def HModule'_fromBiprod ... biprod.desc ... S.f₁₃.op)` block was the anchor; the new `@[reassoc (attr := simp)] lemma HModule'_toBiprod_fromBiprod ...` was inserted immediately after), 3 diagnostic checks (all clean — `success: true, items: [], failed_dependencies: []`), 1 `lean_verify` axiom check on the new lemma (kernel-only — `[propext, Classical.choice, Quot.sound]`), 1 `lean_run_code` smoke probe (`success: true, diagnostics: []` — confirms both the iter-016 per-fiber `rfl` compatibility and a direct application of the new lemma typecheck end-to-end), 1 task-result write, 1 file read, 7 incidental tool / search / shell calls. No goal-state queries (the body was probe-confirmed by the iter-018 plan agent and dropped in verbatim).

## Targets

### Target 1 — `AlgebraicGeometry.Scheme.HModule'_toBiprod_fromBiprod`

**File**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, lines 357 (docstring start) – 389 (closure body).
**Status**: SOLVED (first-edit, verbatim probe-confirmed body).
**Significance**: The third Mayer-Vietoris LES building block — the composition-is-zero relation `HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0`. Direct mirror of Mathlib's `GrothendieckTopology.MayerVietorisSquare.toBiprod_fromBiprod` (file `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean`, L72–75) for the `ModuleCat k` flavor. Together with iter-017's `toBiprod` and `fromBiprod`, this completes the *zero-composition* pillar of the eventual six-term Mayer-Vietoris LES exactness theorem (the other zero-composition lemma, `δ ≫ toBiprod = 0`, is queued for iter-020+ once `δ` itself lands iter-019+). The `@[reassoc (attr := simp)]` attribute is load-bearing: it generates the post-composition variant `… ≫ HModule'_toBiprod_fromBiprod ≫ Z = 0 ≫ Z = 0` and registers the lemma as a `simp` lemma — both are required by downstream Mayer-Vietoris LES exactness arguments.

#### Goal at the would-be sorry site (post-iter-018-refactor, expected)

```lean
@[reassoc (attr := simp)]
lemma HModule'_toBiprod_fromBiprod
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt (Sheaf J (ModuleCat.{u} k))]
    (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) :
    HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0 := by
  sorry
```

The signature (frozen by `REFACTOR_DIRECTIVE.md` §3 / PROGRESS.md "Probe-confirmed signature") declares the iter-018 lemma with the same ambient typeclass stack as iter-014–iter-017 (`HasWeakSheafify J (Type u)`, `HasSheafify J (ModuleCat.{u} k)`, `HasExt (Sheaf J (ModuleCat.{u} k))`). `J` is implicit because it is constrained by `S : J.MayerVietorisSquare`; `S`, `F`, `n` are explicit. The conclusion is an equality in the morphism set `(... ).obj (op S.X₄) ⟶ (... ).obj (op S.X₁)` of `AddCommGrpCat`-valued cohomology fibers.

#### Attempt 1 (succeeded)

- **Strategy**: Adopt the probe-confirmed `simp only`-block proof verbatim from `REFACTOR_DIRECTIVE.md` §7 / PROGRESS.md "Probe-confirmed proof body". The body is the seven-rewrite `simp only` set
  `[HModule'_toBiprod, HModule'_fromBiprod, biprod.lift_desc, Preadditive.comp_neg, ← sub_eq_add_neg, sub_eq_zero, ← Functor.map_comp, ← op_comp, S.toSquare.fac]`,
  exact mirror of Mathlib's `MayerVietorisSquare.toBiprod_fromBiprod` proof (file `MayerVietoris.lean` L74–75). Each rewrite step is value-category-agnostic, so the proof transfers verbatim from `Sheaf J AddCommGrpCat` (Mathlib) to `Sheaf J (ModuleCat k)` (our setting).
- **Code tried** (`Edit` event, `attempts_raw.jsonl` log line 5, file `StructureSheafModuleK.lean`, inserted block at L357–L389 — combining the directive's scaffold and the probe-confirmed proof into one Edit; `old_text` was the trailing portion of the iter-017 `HModule'_fromBiprod` definition + `\n\nend AlgebraicGeometry.Scheme`, `new_text` appended the new docstring + `@[reassoc (attr := simp)] lemma HModule'_toBiprod_fromBiprod ...` block before the same `end AlgebraicGeometry.Scheme`):

  ```lean
  /-- Phase A step 6 *Path 2* (iter-018): the third Mayer-Vietoris LES building
  block on the `ModuleCat k` side — the composition-is-zero lemma asserting
  `HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0`. … -/
  @[reassoc (attr := simp)]
  lemma HModule'_toBiprod_fromBiprod
      (k : Type u) [Field k]
      {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
      [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
      [HasExt (Sheaf J (ModuleCat.{u} k))]
      (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) :
      HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0 := by
    simp only [HModule'_toBiprod, HModule'_fromBiprod, biprod.lift_desc,
      Preadditive.comp_neg, ← sub_eq_add_neg, sub_eq_zero,
      ← Functor.map_comp, ← op_comp, S.toSquare.fac]
  ```

- **Lean error**: none. `lean_diagnostic_messages` on the post-edit file (log line 7) returns `{success: true, items: [], failed_dependencies: []}` — zero errors, zero warnings.
- **Goal before**: term-position
  `⊢ HModule'_toBiprod k S F n ≫ HModule'_fromBiprod k S F n = 0`
  under the binders `(k : Type u) [Field k] {C : Type v} [Category C] {J : GrothendieckTopology C} [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))] (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ)`.
- **Goal after**: closed by the seven-step `simp only` block — every rewrite cancels into the canonical zero on the alternating-sum-of-restrictions side.
- **Result**: success.
- **Insight**: The seven `simp only` lemmas form an *exhaustive* rewrite chain that mechanically reduces the LHS to zero:
  1. `HModule'_toBiprod` / `HModule'_fromBiprod` — unfold to expose the `biprod.lift` / `biprod.desc` shape.
  2. `biprod.lift_desc` — apply the biproduct universal property: `biprod.lift a b ≫ biprod.desc c d = a ≫ c + b ≫ d`.
  3. `Preadditive.comp_neg` — push the negation in `fromBiprod`'s second argument through the composition: `a ≫ (-b) = -(a ≫ b)`.
  4. `← sub_eq_add_neg` — fold `a + (-b)` back to `a - b`.
  5. `sub_eq_zero` — convert `a - b = 0` to `a = b` in the ambient `AddCommGroup`.
  6. `← Functor.map_comp`, `← op_comp` — fuse the consecutive applications of `(... ).map`, swapping morphism order under `op`.
  7. `S.toSquare.fac` — close by the Mayer-Vietoris square's pullback factorisation `S.f₁₂ ≫ S.f₂₄ = S.f₁₃ ≫ S.f₃₄`.

  The unqualified short names `HModule'_toBiprod` / `HModule'_fromBiprod` resolve via `namespace AlgebraicGeometry.Scheme`; `biprod.lift_desc` resolves via file-level `open Limits`; `Preadditive.comp_neg`, `sub_eq_add_neg`, `sub_eq_zero`, `Functor.map_comp`, `op_comp`, `S.toSquare.fac` are all standard Mathlib spellings. No `open Preadditive`, `open Sub`, or auxiliary instance synthesis annotation is needed; the `Preadditive` instance on `AddCommGrpCat` is auto-resolved through the `Cᵒᵖ ⥤ AddCommGrpCat` morphism category. The `S.toSquare.fac` step in particular is value-category-agnostic — `MayerVietorisSquare.toSquare` is the underlying `PullbackSquare` in any presheaf category, and `PullbackSquare.fac` is the formal commutativity property; both transfer cleanly from Mathlib's `Sheaf J AddCommGrpCat` setting to our `Sheaf J (ModuleCat k)` setting.

#### Verification

- **Compilation** (`lean_diagnostic_messages` on `Cohomology/StructureSheafModuleK.lean`, log line 7): `{success: true, items: [], failed_dependencies: []}` — clean post-edit. The transient `git diff archon-protected.yaml` `success: false` at log line 11 is a Bash output-encoding artifact (the file is empty modification → empty stdout, parsed by the dispatcher as failure); the immediate re-run at log line 12 returned the empty diff cleanly.
- **Axioms (`HModule'_toBiprod_fromBiprod`)** (`lean_verify` log line 8): `{axioms: ["propext", "Classical.choice", "Quot.sound"], warnings: []}` — only standard kernel axioms. **No new `axiom` declarations**, no `sorryAx`.
- **Per-fiber `rfl` compatibility re-probe + new-lemma typecheck smoke** (`lean_run_code`, log line 15): `{success: true, diagnostics: []}` — the iter-016 compatibility relation `((HModule'_cohomologyPresheaf k F n).obj (Opposite.op X) : Type u) = HModule' k F n X` continues to hold by `rfl` after the iter-018 addition, AND a direct application of `Scheme.HModule'_toBiprod_fromBiprod k S F n` typechecks. The compatibility relation is what will let the iter-019+ LES sequence identify the LES carriers with the iter-014 `HModule'`.
- **Sorry count** (sorry-analyzer, log line 10): `9 total across 3 file(s)` — 5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`, 1 in `Picard/Functor.lean`. **`Cohomology/StructureSheafModuleK.lean` does not appear in the list** (the comment-hits in the file are not counted as active sorries). Matches the iter-018 directive's intended end-state exactly.
- **`Genus.lean`** (`lean_diagnostic_messages` log lines 9, 13: clean `success: true, items: [], failed_dependencies: []` on both): the iter-011 honest closure of `AlgebraicGeometry.genus` remains intact.
- **`archon-protected.yaml`** (`git diff` at log line 11+12): empty diff. Untouched.
- **Forbidden shortcuts**: none used. The proof is the genuine Mathlib `simp only` set, not a `decide`-bypass, not a `Iso.refl _ ≫ _ = 0` shortcut, not an `IsZero` cheat on the LES diagram (LES sequence is iter-020+ work, untouched here), no `axiom`, no signature change, no protected-declaration touch, no new file. The negation in `HModule'_fromBiprod`'s second branch is preserved (the prover did not silently drop the sign — that would still let the proof go through but would invalidate the eventual `δ ≫ toBiprod = 0` exactness, which depends on the alternating-sum convention).

## File-level verification (post-prover-round)

- **Sorry count**: `9 total across 3 file(s)` — 5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`, 1 in `Picard/Functor.lean`. Matches expectation.
- **`Cohomology/StructureSheafModuleK.lean`**: zero sorries, zero errors, zero warnings; ~426 LOC after this iteration (iter-017: ~392 LOC; +34 LOC for iter-018's lemma including its docstring and the `@[reassoc (attr := simp)]` attribute line). The iter-006 `toModuleKSheaf` chain, iter-009 `HModule`, iter-010 `HModule_zero_linearEquiv`, iter-012 `cechCochain_OC` / `cechCohomology_OC`, iter-014 `HModule'`, iter-015 `HModule'_zero_linearEquiv`, iter-016 `HModule'_cohomologyPresheafFunctor` / `HModule'_cohomologyPresheaf`, iter-017 `HModule'_toBiprod` / `HModule'_fromBiprod`, and iter-018 `HModule'_toBiprod_fromBiprod` all coexist cleanly. **The file is now ~26 LOC over the ~400 LOC threshold flagged in PROGRESS.md / iter-016 recommendations for splitting into a separate `Cohomology/MayerVietoris.lean` file** — the iter-019 plan agent should consider scoping a refactor split before iter-020+ adds the LES sequence + exactness theorem (which together will likely add 80–120 LOC).
- **`Genus.lean`**: clean (iter-011 honest closure intact).
- **`archon-protected.yaml`**: untouched.
- **Forbidden shortcuts**: none used.

## Process note: refactor sub-phase collapsed into the prover Edit (fourth consecutive occurrence — sessions 25 + 26 + 27 + 28)

The iter-018 plan called for two sub-phases in sequence: refactor (insert the `:= by sorry` scaffold for the new lemma, taking the project-level sorry count `9 → 10`) followed by prover (replace the `sorry` with the probe-confirmed proof body, taking the count back to `9`). In practice — exactly as in iter-015 / iter-016 / iter-017 — the refactor agent did not run / did not write `task_results/refactor.md`; the prover started against the post-iter-017 file (no scaffolded `:= by sorry` site) and chose to combine the refactor's intended insertion with the closure into a single `Edit` (one `old_text` / `new_text` pair appending the directive's docstring + `@[reassoc (attr := simp)]`-attributed lemma + proof block before the closing `end AlgebraicGeometry.Scheme`). The end-state matches `REFACTOR_DIRECTIVE.md` §3 verbatim; the project-level sorry count went `9 → 9` directly, never reaching the transient 10.

This is the **fourth consecutive occurrence** of the same collapse (sessions 25, 26, 27, 28). The pattern is now firmly established for narrow probe-confirmed scaffold rounds in unprotected territory whether the round adds one declaration (iter-015, iter-018) or two paired declarations (iter-016, iter-017). PROGRESS.md (this iteration) pre-authorised the collapse, so the iter-018 occurrence is not a deviation from the directive — it is a planned compression. The substantive end-state is correct in all four sessions; only the bookkeeping lag is at issue. Strongly worth raising with the user — see `recommendations.md`.

## Key findings / proof patterns (this session)

- **Twelve-consecutive-round 100% first-edit closure streak** (sessions 12, 13, 14, 15, 20, 21, 22, 24, 25, 26, 27, 28). Probe-confirmed bodies for definitional-equality / single-Mathlib-application closures continue to land verbatim; the streak now generalises uniformly across one-declaration `def` rounds, paired `def` rounds, paired `def`+`abbrev` rounds, and now lemma rounds with multi-step `simp only` proofs.
- **`simp only [...]`-block proofs that are verbatim transfers from a Mathlib analog are first-class candidates for the "probe + adopt" pattern** (added this session, novel). Pattern: when Mathlib has the same lemma in an `AddCommGrpCat`-flavored category and our target is a `ModuleCat k`-flavored category, *and* every rewrite step in Mathlib's `simp only` set is value-category-agnostic (preadditive structure, biproduct universal property, contravariant functoriality, opposite-category arithmetic, structural equality lemmas like `S.toSquare.fac`), the proof transfers byte-for-byte with no change. Verifying value-category-agnosticity at the per-rewrite level is the plan-agent's probe job; the prover's job is to adopt verbatim. This is a substantial generalisation of the iter-014 / iter-015 / iter-016 / iter-017 "single-call term-mode" pattern to multi-step `by`-mode tactical proofs.
- **`@[reassoc (attr := simp)]` attribute is the canonical Mathlib idiom for composition-is-zero / composition-equals-X lemmas in categorical-cohomology setups** (added this session). The attribute is load-bearing: `@[reassoc]` automatically generates the post-composition variant `f ≫ g ≫ Z = h ≫ Z` (mathematically the same statement, syntactically the form needed when chaining further compositions), and `(attr := simp)` registers the lemma as a `simp`-set member. Both are needed by downstream LES exactness arguments. Not specifying `(attr := simp)` would leave the `simp` registration to a separate `attribute [simp] HModule'_toBiprod_fromBiprod` declaration; not specifying `@[reassoc]` would leave the post-composition form for a manual `Category.assoc`-rewriting argument at every callsite. Mathlib uniformly uses the combined form for LES building blocks of this shape (cf. `MayerVietoris.lean` L72).
- **`MayerVietorisSquare.toSquare`-dot accessor `.fac` resolves verbatim to `PullbackSquare.fac`** (added this session). The Mathlib structure `GrothendieckTopology.MayerVietorisSquare` has a field `toSquare : J.PullbackSquare`, and `PullbackSquare.fac` is the formal commutativity property `f₁ ≫ g₁ = f₂ ≫ g₂` of the four square edges. Together with dot-notation, `S.toSquare.fac` resolves verbatim with no qualification needed. The `simp` rewrite uses this to close the `← Functor.map_comp ← op_comp`-fused application: after the fusion, the LHS reads `(... ).map (S.f₁₂ ≫ S.f₂₄).op` and the RHS reads `(... ).map (S.f₁₃ ≫ S.f₃₄).op`, and `S.toSquare.fac` rewrites the morphism inside the `op` to make the two sides equal.
- **`← sub_eq_add_neg` + `sub_eq_zero` is the canonical 2-step pattern for closing "additive-inverse pair vanishes" goals in preadditive categories** (added this session). Pattern: when a goal is `a ≫ c + b ≫ (-d) = 0` (after `biprod.lift_desc` + `Preadditive.comp_neg`), apply `← sub_eq_add_neg` to fold to `a ≫ c - b ≫ d = 0`, then `sub_eq_zero` to convert to `a ≫ c = b ≫ d`, then close by the structural equality (in this case `S.toSquare.fac`-via-functoriality). The order matters: `← sub_eq_add_neg` reduces the addition-of-negation back to subtraction so that `sub_eq_zero` (which is stated for subtraction) applies; reversing the two steps would leave `add_eq_zero` (which would still close via `Preadditive.add_eq_zero_iff_eq_neg` but is more verbose).
- **Per-fiber `rfl` compatibility through paired `def` + `abbrev` survives the iter-018 addition** (re-confirmed this session). The compatibility relation `((HModule'_cohomologyPresheaf k F n).obj (op X) : Type u) = HModule' k F n X` continues to hold by `rfl` after the iter-018 lemma was added (the iter-016 abbrev wrapping is unchanged). The smoke probe at `attempts_raw.jsonl` log line 15 explicitly verified this AND the type-correctness of a direct application of the new lemma in one combined `lean_run_code` snippet.
- **Refactor + prover sub-phase collapse is now a *recurring four-times-in-a-row* execution mode** (sessions 25, 26, 27, 28). For narrow probe-confirmed scaffold rounds in unprotected territory — whether single-declaration or paired-declaration, whether `def` / `abbrev` / `lemma`-flavored — a single prover Edit can satisfy both phases. The dispatcher / plan agent should consider standardising this for future probe-confirmed rounds; the bookkeeping lag (no `task_results/refactor.md`) is now four-times-in-a-row a non-issue substantively. PROGRESS.md and `REFACTOR_DIRECTIVE.md` continue to pre-authorise this collapse explicitly.
- **Plan-agent `lean_run_code` probe correctness rate is 100% on twelve consecutive rounds** (sessions 12, 13, 14, 15, 20, 21, 22, 24, 25, 26, 27, 28). For narrow-scope rounds with single-Mathlib-call closures or value-category-agnostic `simp only`-block proofs, "adopt and verify" with no mid-edit budget is correct.

## Recommendations for next session

See `recommendations.md` for the actionable briefing for the iter-019 plan agent. Headline: with the *zero-composition* pillar of the eventual six-term Mayer-Vietoris LES exactness theorem now in place (`toBiprod ≫ fromBiprod = 0`), the leading priority for iter-019 is **the connecting hom `δ` infrastructure** — specifically the `Sheaf J (ModuleCat k)`-flavored analog of Mathlib's `MayerVietorisSquare.shortComplex_shortExact` (built from `AddCommGrpCat.free`-yoneda; the `ModuleCat k` flavour requires `ModuleCat.free k`-yoneda + an `isPushoutModuleCatFreeSheaf`-analog). Estimated 15–25 LOC of new infrastructure plus 5–10 LOC of glue per the iter-018 plan-agent's deferral analysis (blueprint remark "Why δ is iter-019+ and not iter-018"). Iter-020+ then assembles `δ` itself + the LES sequence + the `Ext.contravariantSequence` iso + the exactness theorem. The 8 remaining protected sorries plus the deferred `representable` are all gated behind multi-iteration upstream work; do not assign as direct prover objectives.

## Blueprint markers updated

- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_toBiprod_fromBiprod` (lemma block at L594–604): added `\leanok` to the statement block (after the `\lean{AlgebraicGeometry.Scheme.HModule'_toBiprod_fromBiprod}` line) — the Lean lemma exists at `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` L379–L389 with the directive's signature and the file compiles cleanly (`lean_diagnostic_messages` returns `{success: true, items: [], failed_dependencies: []}`).
- `Cohomology_StructureSheafModuleK.tex`, proof block of `lem:Scheme_HModule_prime_toBiprod_fromBiprod` (proof block at L606–622): added `\leanok` (immediately after `\begin{proof}`, before the `\uses{...}` line) — the proof body is the honest seven-step `simp only` block (no `sorry`), kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`), `@[reassoc (attr := simp)]`-attributed.
- The `Why δ is iter-019+ and not iter-018` block (L624–638) is a `\begin{remark}` block; per the marker vocabulary in `CLAUDE.md`, `\leanok` is reserved for theorems / lemmas / definitions, not remarks. No marker added; the sub-step's substantive verification is captured in the lemma + proof block markers above and in this summary.
- No `\lean{...}` macro renames required this session — the prover round did not rename or move any declaration; the `\lean{AlgebraicGeometry.Scheme.HModule'_toBiprod_fromBiprod}` macro matches the directive verbatim.
- No stale `\notready` markers anywhere in the blueprint chapters (verified via grep — no hits across all of `blueprint/src/chapters/`).
- The `(iter-013)` and earlier iteration labels inside `Cohomology_StructureSheafModuleK.tex` are residual plan-agent / informal-prose drift from earlier iterations; the new iter-018 section title `(iter-018)` matches the canonical iteration. Not the review agent's surface to rewrite earlier mismatches.
