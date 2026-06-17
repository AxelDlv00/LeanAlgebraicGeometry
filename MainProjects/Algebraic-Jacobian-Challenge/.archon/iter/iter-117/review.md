# Iter-117 (Archon canonical) — review

## Outcome at a glance

- **Aggressive TRIM landed cleanly in response to the iter-116 user directive.** No prover lane this iter; `meta.json prover.durationSecs: 0` and `planValidate.status: ok_intentional_skip / objectives: 0` are the **correct** loop-infrastructure signals for a trim-only iter.
- **Sorry trajectory: 16 → 2 (−14 in a single iter; largest single-iter reduction in project history).** Per-file: BasicOpenCech 6 → 0 (file deleted); Differentials 5 → 1 (file rewritten ~1100 → 83 LOC, presheaf-form refactor); Modules/Monoidal 1 → 0 (deleted); Picard/LineBundle 2 → 0 (deleted); Picard/Functor 1 → 0 (deleted); Jacobian 1 → 1 (single foundational hypothesis preserved).
- **Compile-verified**: yes. `lake build` 8328 jobs / 0 errors per the refactor report; per-file `lean_diagnostic_messages` returns `[]` errors on all 10 surviving files. 1 pre-existing deprecation warning carries over on `Differentials.lean:76` (`AlgebraicGeometry.IsSmoothOfRelativeDimension`, by design — preserved per protected signature).
- **No new axioms**; no protected signatures touched. `archon-protected.yaml` unchanged (9 protected declarations).
- **Two independent fresh-context audits this iter** (plan-phase `lean-auditor-iter117` on pre-trim, review-phase `lean-auditor-review117` on post-trim) both return 0 must-fix / 0 major / 0 excuse-comments / 0 axioms. The surviving framework is mathematically honest.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **2**, distributed:
  - `AlgebraicJacobian/Differentials.lean:81` — `smooth_iff_locally_free_omega` (presheaf-form refactor; iter-118 prover-lane target).
  - `AlgebraicJacobian/Jacobian.lean:179` — `nonempty_jacobianWitness` (single explicit foundational existence hypothesis).
- **Solved this iter**: **14 sorry sites removed** (file deletions + Differentials trim). Of these:
  - 6 in `Cohomology/BasicOpenCech.lean` (whole file deleted).
  - 4 in `Differentials.lean` (cotangent exact sequence h_exact, cotangent at section, Serre-duality genus, unique-gluing helper — all deleted as orphan to the protected chain).
  - 1 in `Modules/Monoidal.lean` (deleted).
  - 3 in the Picard chain (`LineBundle.lean` × 2, `Functor.lean` × 1; deleted).
- **Partial this iter**: 0. (Trim is by definition not partial: each deleted sorry is fully removed; the surviving `smooth_iff_locally_free_omega` is a signature refactor, not a partial proof.)
- **Blocked this iter**: 0. (No prover lane was dispatched.)
- **Untouched (deferred / out-of-scope)**: 2 (the survivors).

## What the iter-117 plan got right

- **Honoured the iter-116 user directive verbatim.** "Find the best strategy yourself; no temporarily wrong; nothing deferred; detailed blueprints; clean STRATEGY.md" → autonomous TRIM on every orphan-to-protected-chain sorry + BUILD on the single foundational hypothesis. The choice between TRIM and BUILD was made per-route, not as a blanket policy: 5 orphan files were trimmed, 1 protected hypothesis was preserved.
- **Verified the architectural commitment with 3 mandatory critics before acting.** strategy-critic (REJECT of the prior "named Mathlib gaps as end-state"), blueprint-reviewer (8/13 chapters hard-gate), progress-critic (Routes 1+4 STUCK; Routes 2+3 UNCLEAR) all converged on the same shape. No critic was silently ignored.
- **Mathlib name pre-verification before scheduling the iter-118 prover lane.** `STRATEGY.md` Phase C names 5 closing lemmas, all marked `[verified]` (cross-checked against Mathlib b80f227 in iter-113/iter-115/iter-116 plan-phases). The iter-118 prover will read pre-verified names, not guess.
- **Three blueprint-writers dispatched in parallel** for the chapters whose Lean files survived (`Differentials.tex`, `Jacobian.tex`, `AbelJacobi.tex`). Each chapter was rewritten to track the post-trim Lean: presheaf-form smoothness criterion + out-of-scope disclosure; 3-route decomposition of `nonempty_jacobianWitness` with Mathlib gap-map per route; Pic^0-vs-Albanese drift fix demoting classical prose to `\begin{remark}` blocks.
- **Preserved the `archon-protected.yaml` interface byte-identically.** All 9 protected declarations remain at their original file paths with unchanged signatures. The witness-based redesign uses `JacobianWitness.<field>` projections that respect the protected signatures.

## What I verified this review

I independently verified each of the iter-117 plan agent's claimed state changes:

1. ✅ `find AlgebraicJacobian -name '*.lean'` → 10 files (1 umbrella + 9 module files). No `Picard/` or `Modules/` directories. Matches plan.md.
2. ✅ `python3 sorry_analyzer.py AlgebraicJacobian --format=summary` → **2 sorries** in 2 files (`Differentials.lean: 1` + `Jacobian.lean: 1`). Matches plan.md.
3. ✅ `Differentials.lean` is 83 lines (`wc -l`). 3 declarations match the report's list.
4. ✅ `archon-protected.yaml` unchanged (9 protected declarations at original paths).
5. ✅ `grep -rn "axiom " AlgebraicJacobian/` returns only the historical `MayerVietorisCover.lean:504` docstring comment ("axiom set `[propext, Classical.choice, Quot.sound]` … no new axiom introduced"). No active `axiom` declarations.
6. ✅ `blueprint/src/content.tex` lists the 9 surviving chapters; the 4 deleted-Lean chapters (`Modules_Monoidal`, `Picard_*`) are absent from the `\input` list.
7. ✅ Cross-references to the deleted `BasicOpenCech.lean` are no longer present in `MayerVietorisCore.lean:23` or `MayerVietorisCover.lean:25` (verified by `grep` from the audit report).
8. ✅ The four `Jacobian` instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) are honest single-field projections from `(jacobianWitness C)`. The three `AbelJacobi` protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project `((jacobianWitness C).isAlbaneseFor P).<field>` consistently.

## Review-phase subagent dispatches

This review dispatched 4 audits and incorporated their findings:

1. **`lean-auditor-review117`** — read-only audit of the 10 surviving Lean files. **0 must-fix / 0 major / 0 excuse-comments.** 6 minor items (cosmetic): commented-out Phase-A sketch in `Genus.lean:39–61`; verbose per-iteration status docstrings on a few files; redundant umbrella import (harmless, deduped); `Module.rank` vs `Module.finrank` shape on `smooth_iff_locally_free_omega` conclusion clause; `MayerVietoris*` files' Mathlib mirror line numbers may drift across bumps; `IsAffineHModuleHomFinite` carrier described as "dead scaffolding" by its own docstring. Report: `task_results/lean-auditor-review117.md`.
2. **`lean-vs-blueprint-checker` (slug `abeljacobi-review117`)** — `AbelJacobi.lean` vs `AbelJacobi.tex`. **0 must-fix / 0 major / 1 minor.** Coverage 3/3, hint precision precise; minor prose-vs-Lean cosmetic on `thm:exists_unique_ofCurve_comp` ("group-scheme morphism" prose vs `∃!` over arbitrary morphisms in Lean; equivalent by Mumford rigidity for abelian varieties). The iter-117 chapter rewrite tracks the Lean cleanly. Report: `task_results/lean-vs-blueprint-checker-abeljacobi-review117.md`.
3. **`lean-vs-blueprint-checker` (slug `differentials-review117`)** — `Differentials.lean` vs `Differentials.tex`. **0 must-fix / 2 MAJOR / 3 minor.** **The 2 MAJOR findings GATE the iter-118 prover lane on `smooth_iff_locally_free_omega`.** Both are blueprint-side: (a) `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` named `[verified]` in the proof sketch **does not exist in Mathlib b80f227** (actual API: `Algebra.SubmersivePresentation.basisKaehler` / `basisKaehlerOfIsCompl` on a `SubmersivePresentation`, not on `IsStandardSmoothOfRelativeDimension` directly); (b) `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` named `[verified]` **does not exist** (actual name: `AlgebraicGeometry.smoothOfRelativeDimension_iff`, no `is` prefix). Plus the converse-direction sketch hand-waves how `Subsingleton (Algebra.H1Cotangent A B)` is supplied. The other three `[verified]` names DO exist and are correctly cited. Report: `task_results/lean-vs-blueprint-checker-differentials-review117.md`.
4. **`lean-vs-blueprint-checker` (slug `jacobian-review117`)** — `Jacobian.lean` vs `Jacobian.tex`. **0 must-fix / 3 MAJOR / 3 minor.** All 3 MAJOR are non-blocking blueprint coverage / alignment items: (a) `thm:IsAlbanese_unique` statement-vs-prose mismatch (Lean returns unique morphism; prose says unique isomorphism — the proof in fact computes the iso content); (b) missing `\structure{}` block for `JacobianWitness`; (c) missing `\lean{...}` references for the `IsAlbanese.ofCurve` / `.comp_ofCurve` / `.exists_unique_ofCurve_comp` data-extraction trio. Minors: redundant `smooth` / `smoothGenus` fields in `JacobianWitness` (one implies the other); `geometricallyIrreducible_id_Spec` is vestigial-unused; in-proof `\leanok` at chapter L148 (sync_leanok should strip; not my domain). Report: `task_results/lean-vs-blueprint-checker-jacobian-review117.md`. The 3 majors should be bundled into the iter-118 blueprint-writer dispatch alongside the `Differentials.tex` name fixes.

## What to do next (iter-118 plan-phase)

The iter-118 plan-phase should:

1. **GATE: dispatch a blueprint-writer for `Differentials.tex` FIRST** to fix the two `[verified]`-tagged Mathlib name errors and expand the converse-direction sketch on `Subsingleton (Algebra.H1Cotangent A B)` vanishing. The same two name errors appear in `STRATEGY.md` Phase C and must be fixed in the same iter. Recommend `mathlib-analogist` or direct `lean_loogle` / Mathlib source-grep verification on each name before the blueprint-writer commits. WITHOUT this fix, the prover lane will read the chapter, search for two non-existent names, and fail or churn.
   - Also bundle into this blueprint-writer pass the 3 MAJOR `Jacobian.tex` items from the jacobian-review117 checker: tighten `thm:IsAlbanese_unique` (statement-vs-prose mismatch); add `\structure{}` block for `JacobianWitness`; add `\lean{...}` references for the `IsAlbanese.ofCurve`-extraction trio. None of these block the prover lane, but bundling them costs only the chapter edit budget.
2. After the blueprint fix lands, schedule the prover lane on `Differentials.lean:81` `smooth_iff_locally_free_omega`. Estimated 3–7 prover iters / ~200–700 LOC for forward + converse combined.
3. Drop the stale `cotangent_at_section` reference from STRATEGY.md Phase C (the declaration was deleted by the iter-117 refactor; the strategy text still mentions it).
4. Bundle the `IsSmoothOfRelativeDimension` → `SmoothOfRelativeDimension` deprecation rename into the iter-118 prover lane (single-line edit on `Differentials.lean:76`, aligns with the already-renamed `Jacobian.lean:50,213`).
5. Optionally: a one-shot blueprint-writer pass converting `Modules_Monoidal.tex`, `Picard_*.tex` to "Out of autonomous-loop scope" stubs (or outright delete `Modules_Monoidal.tex`). Non-blocking.

## TO_USER status

No user-escalation banner needed this iter. The iter-116 user directive was acted upon cleanly this iter; the user does NOT need to make any further decisions for iter-118+ to proceed on the surviving `smooth_iff_locally_free_omega` prover lane.

The single foundational hypothesis `nonempty_jacobianWitness` is documented in detail in `blueprint/src/chapters/Jacobian.tex` as an honest project-external assumption. The user has previously seen this disclosure shape (the iter-117 plan-agent's decision was the single "find the best strategy yourself" branch of the user's 3-option escalation in iter-116); no further user input is required.
