# Session 7 (iter-007) — Review Summary

## Metadata
- **Iteration / session:** iter-007 / session_7
- **Lane this iter:** QUOT-defs frontier (NEW third lane), split across two files —
  `Picard/GrassmannianCells.lean` and `Picard/QuotScheme.lean`. FBC and GF were
  intentionally NOT dispatched this iter (their cruxes are mid-decomposition; iter-008
  prover dispatch is the committed follow-up).
- **Sorry count:** GrassmannianCells `affineChart` was filled (the file's only stub →
  0 sorry); QuotScheme unchanged at 4 typed stubs (hilbertPolynomial, QuotFunctor,
  Grassmannian, representable — left untouched per objectives). **No new sorry
  introduced.** Total project sorry: net −1 (affineChart closed).
- **Build:** GREEN. `dag-query gaps` = 0; blueprint-doctor CLEAN (no orphans, no broken
  refs, no axioms).
- **Reviewers:** lean-auditor + 2 lean-vs-blueprint-checkers — **0 must-fix-this-iter**
  across all three. 3 axiom-clean declarations landed ({propext, Classical.choice,
  Quot.sound} only — no sorryAx, no unauthorized axioms).

## Targets attempted (5)

### 1. `affineChart` (GrassmannianCells.lean) — SOLVED, axiom-clean
- **Approach:** direct fill of the typed `sorry` with the blueprint recipe.
- **Code:** `AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`
- **Insight:** `Spec : CommRingCat ⥤ Scheme` applied to `CommRingCat.of (MvPolynomial …)`
  cleanly; the free-entry index type `Fin d × {q : Fin r // q ∉ I}` has cardinality
  `d·#(Fin r \ I) = d(r−d)` when `#I = d`, matching `𝔸^{d(r−d)}_ℤ` non-canonically as the
  blueprint specifies. Verified: `lean_diagnostic_messages` `[]`; `lean_verify`
  axiom-clean.
- **Checker (grcells):** PASS — exact formalization of the blueprint recipe. Two MINOR
  carryovers (below).

### 2. `SheafOfModules.IsLocallyFreeOfRank` (QuotScheme.lean) — SOLVED, axiom-clean
- **Approach:** `Prop`-valued predicate. `M` is locally free of rank `d` iff `X` has an
  open cover `U : ι → X.Opens` with `⨆ U i = ⊤` and each restriction
  `(Scheme.Modules.pullback (U i).ι).obj M` is `Nonempty`-isomorphic to
  `SheafOfModules.free (R := (U i).toScheme.ringCatSheaf) (ULift (Fin d))`.
- **Universe insight (reusable):** `free` needs `Type u`, so `Fin d` is `ULift.{u}`-lifted;
  covering opens kept in universe `u` via `X.Opens` to AVOID the `Scheme.OpenCover`
  two-universe inference failure. The prover tried the `Scheme.OpenCover` formulation first
  and abandoned it (universe-inference failure) — **do not retry that route.**
- **Checker (quot):** matches `def:is_locally_free_of_rank`; predicate is substantive
  (non-vacuous both directions). sync_leanok added `\leanok`.

### 3. `Module.annihilator_isLocalizedModule_eq_map` (QuotScheme.lean) — SOLVED, axiom-clean
- **Statement:** for `[Module.Finite R M]`, `IsLocalization S Rₚ`, `IsLocalizedModule S f`:
  `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)`, i.e.
  `Ann(S⁻¹M) = (Ann M)·S⁻¹R`. **Missing from Mathlib.**
- **Proof:** `le_antisymm`.
  - `⊇`: image of an annihilator element annihilates `Mₚ` (`mk'_smul_mk'`, `mk'_one`,
    `mk'_zero`).
  - `⊆`: write `y = mk' a s`; each spanning generator `m` gives `∃ uₘ∈S, uₘ•a•m=0`
    (`mk'_eq_zero` + `eq_zero_iff`); take `U = ∏ uₘ` over the spanning finset
    (`Module.Finite.fg_top`); `U·a ∈ Ann R M` (inline `Submodule.span_induction` helper);
    then `mk' a s = algebraMap(U·a)·mk' 1 (U·s) ∈ map`.
- **Gotcha (reusable):** `IsLocalization.mk'_surjective` / `IsLocalizedModule.mk'_surjective`
  return a `match`/`Function.uncurry` form — `dsimp only [Function.uncurry]` after
  `obtain ⟨⟨a,s⟩, rfl⟩`. `Module.Finite` is genuinely required (false without it).
- **Coverage debt:** this is an unmatched `lean_aux` (no blueprint block). It is the
  ALGEBRA half of `def:modules_annihilator`'s `map_ideal_basicOpen` coherence. Planner
  must blueprint it — see `recommendations.md`.

### 4. `Scheme.Modules.annihilator` (`def:modules_annihilator`) — BLOCKED
- **Blocker:** missing QCoh→`IsLocalizedModule` bridge. `Scheme.IdealSheafData` is the
  right vehicle (`ideal U := Module.annihilator Γ(X,U) (M.val.obj (op U.1))`), but the
  `map_ideal_basicOpen` coherence field needs three facts: (1) `Γ(X,D(f)) =
  IsLocalization.Away f` — **EXISTS** (`IsAffineOpen.isLocalization_basicOpen`); (2)
  `M(U)` finitely generated — needs a finite-type hypothesis on `M`; (3) section
  restriction `M(U)→M(D(f))` is `IsLocalizedModule (powers f)` — **MISSING** for general
  `X.Modules` (only the Spec-specific `ModuleCat.Tilde` carries it).
- **Dead end:** `map_ideal_basicOpen` is FALSE for a general sheaf of modules; the def's
  signature must carry quasicoherence + finite-type.
- Engine lemma (#3) now supplies the algebra half. `% NOTE:` added to the blueprint block.

### 5. `sectionGradedRing` (`def:sectionGradedRing`) — BLOCKED
- **Blocker:** no tensor/monoidal structure on `SheafOfModules` at the pin.
  `MonoidalCategoryStruct X.Modules` fails to synthesize; no SheafOfModules/
  PresheafOfModules tensor lemmas exist, so the tensor power `L^{⊗m}` cannot be named.
- **Dead end:** do NOT define `L^{⊗m}` ad hoc; it needs the full monoidal scaffolding.
  `% NOTE:` added to the blueprint block.

## Reviewer findings (0 must-fix; majors/minors → recommendations.md)
- **lean-auditor `iter007`** (`task_results/lean-auditor-iter007.md`): 0 critical / 1
  major / 3 minor. MAJOR: stale docstring on `GrassmannianCells.lean:59` ("the body is a
  typed `sorry`") contradicts the now-filled body. All 4 QuotScheme stubs confirmed honest
  typed scaffolding; both new decls verified sorry-free; no parallel Mathlib API; no
  excuse-comments / axioms.
- **lean-vs-blueprint-checker `grcells-iter007`** (`task_results/…-grcells-iter007.md`):
  PASS, 0 must-fix, 2 minor — stale docstring (same as above); `(I : Finset (Fin r))`
  does not enforce the blueprint's `#I = d` precondition (def is more general than the
  blueprint states).
- **lean-vs-blueprint-checker `quot-iter007`** (`task_results/…-quot-iter007.md`):
  0 must-fix, 2 major — (i) `Grassmannian.representable` Lean statement is strictly
  weaker than the blueprint (drops smooth/projective/relative-dimension/tautological-
  quotient/Plücker — intentional iter-177+ skeleton, but a formal mismatch); (ii) the
  missing blueprint block for `annihilator_isLocalizedModule_eq_map` is a coverage gap.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `def:modules_annihilator`: added `% NOTE:` recording the
  iter-007 blocker (missing QCoh→IsLocalizedModule bridge; algebra engine landed).
- `Picard_QuotScheme.tex`, `def:sectionGradedRing`: added `% NOTE:` recording the
  iter-007 blocker (no tensor/monoidal structure on SheafOfModules at the pin).
- (No `\mathlibok` added — all 3 landed declarations are project-local, none are Mathlib
  re-exports. No `\lean{...}` renames — both filled decls match their blueprint hints. No
  stale `\notready` found. `\leanok` on `affineChart` + `is_locally_free_of_rank` was
  applied by the deterministic sync_leanok, not by me.)

## Notes (LOW)
- The `\leanok` on the STATEMENT blocks of `def:quot_functor`, `def:grassmannian`,
  `thm:grassmannian_representable` is legitimate (statement-level `\leanok` = "declaration
  formalized, ≥ a sorry present"); sync_leanok ran at iter-007 (deterministic verdict) —
  not headline laundering.

## Recommendations
See `recommendations.md`. Headline: iter-008 must dispatch FBC + GF provers (the committed
follow-up); restore the coverage debt (`annihilator_isLocalizedModule_eq_map`); the two
QUOT-defs blockers (annihilator bridge, SheafOfModules monoidal) are genuine
Mathlib-infra builds needing blueprint decomposition, not proof retries.
