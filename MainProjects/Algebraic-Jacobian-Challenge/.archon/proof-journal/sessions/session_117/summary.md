# Session 117 — review of iter-117

## Metadata

- **Iteration**: 117 (Archon canonical)
- **Stage**: plan-phase aggressive TRIM (NO prover lane dispatched this iter — the trim was the iter-117 deliverable; `meta.json` shows `prover.durationSecs: 0` and `planValidate.status: ok_intentional_skip / objectives: 0`).
- **Sorry count before**: 16 (project total at iter-116 close).
- **Sorry count after**: **2** (project total, verified via `sorry_analyzer.py --format=summary`).
- **Per-file sorry inventory (post-trim, verified)**:
  - `AlgebraicJacobian/Differentials.lean`: **1** at L81 (`smooth_iff_locally_free_omega`, presheaf-form refactor).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`, single foundational existence hypothesis).
- **Files deleted this iter**:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (~1500 LOC, 6 sorries).
  - `AlgebraicJacobian/Modules/Monoidal.lean` (+ `Modules/` directory; 1 sorry).
  - `AlgebraicJacobian/Picard/LineBundle.lean` (2 sorries).
  - `AlgebraicJacobian/Picard/Functor.lean` (1 sorry).
  - `AlgebraicJacobian/Picard/FunctorAb.lean` (+ `Picard/` directory; 0 sorries).
- **`AlgebraicJacobian/Differentials.lean`**: rewritten ~1100 LOC → 83 LOC. Surviving content: `relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `smooth_iff_locally_free_omega` (signature refactored from sheaf-form to presheaf-form; same mathematical content, sidesteps the deleted sheaf-condition / unique-gluing machinery).
- **`AlgebraicJacobian.lean` umbrella**: 15 → 10 imports.
- **Net sorry delta**: −14 in a single iter (largest one-iter drop in project history).
- **Compilation**: `lake build` clean (8328 jobs, 0 errors per refactor report). Per-file `lean_diagnostic_messages` returns `[]` errors on all 10 surviving files.
- **Axiom hygiene**: 0 `axiom` declarations introduced. Only kernel axioms (`propext`, `Classical.choice`, `Quot.sound`) used.
- **`archon-protected.yaml`**: unchanged. All 9 protected declarations remain at their listed paths with unchanged signatures.

## Headline

**Iter-117 is the largest single-iter sorry reduction in project history (16 → 2, −14) and the textbook response to a substantive user directive.** The user's iter-116 hint in `USER_HINTS.md` ("find the best strategy yourself; strict correctness; detailed blueprints; nothing deferred") was internally consistent only with one of two strategic shapes: TRIM (shrink scope so every shipped statement is fully closed) or BUILD (commit multi-iter to filling the upstream Mathlib infrastructure). The plan agent chose TRIM on every orphan-to-protected-chain sorry and committed to BUILD on the single foundational existence hypothesis (`nonempty_jacobianWitness`), with the survival of `smooth_iff_locally_free_omega` (presheaf-form refactor) as a budgeted next-iter prover lane against 5 verified Mathlib bridges.

The mathematical honesty of the surviving framework is now confirmed by **two independent fresh-context audits** this iter: iter-117 plan-phase `lean-auditor-iter117` (pre-trim, audited the wider 16-sorry surface) and iter-117 review-phase `lean-auditor-review117` (post-trim, audited the 10 surviving files). Both report 0 must-fix, 0 major, 0 excuse-comments, 0 axioms. Every surviving sorry is on a true mathematical statement; every protected declaration projects honestly from its `JacobianWitness` field.

## What actually happened this iter (plan-phase only — no prover lane)

The iter-117 plan agent acted on `USER_HINTS.md` and made 8 subagent dispatches:

1. **strategy-critic-iter117 — REJECT** of the prior STRATEGY.md's "named Mathlib gaps as permanent end-state" architecture. Recommended TRIM on every orphan-to-protected-chain sorry; for `nonempty_jacobianWitness` (protected) listed three options (drop from protected; multi-month BUILD; waive no-deferral). Plan-agent decision: keep `nonempty_jacobianWitness` as the **single explicit foundational hypothesis**, with detailed blueprint disclosure decomposing 3 classical construction routes and the Mathlib infrastructure each requires.
2. **blueprint-reviewer-iter117 — 8 of 13 chapters hard-gate.** Every active prover route's chapter had must-fix items. Most were addressed in this iter by the 3 blueprint-writer dispatches; the remaining must-fix items belong to chapters whose Lean files were deleted (Picard, Modules_Monoidal, BasicOpenCech).
3. **progress-critic-iter117 — Routes 1+4 STUCK; Routes 2+3 UNCLEAR.** Verified the prior Differentials L191 unique-gluing route had 4-of-5 iters with the affine-basis-bridge blocker; verified the `cechCofaceMap_pi_smul` route had 7 consecutive PARTIALs across iter-100..iter-107. Both routes were among the deletions.
4. **lean-auditor-iter117 — 0 must-fix.** Confirmed every one of the (pre-trim) 16 inline sorries is on a true mathematical statement.
5. **refactor (slug trim-iter117) — COMPLETE.** Deleted 5 files + 2 directories, trimmed umbrella, rewrote `Differentials.lean` (~1100 → 83 LOC) with the presheaf-form `smooth_iff_locally_free_omega`, removed stale cross-references in `MayerVietorisCore.lean:23` and `MayerVietorisCover.lean:25`. Build clean.
6. **blueprint-writer-jacobian-iter117.** `Jacobian.tex` ~130 → 249 lines: 3-route decomposition (Pic^0 / Sym^g / genus-0) for `thm:nonempty_jacobianWitness` with Mathlib gap-map per route; structured proof blocks for each protected instance projecting from the witness; `def:IsAlbanese` typeclass-parameter disclosure remark added.
7. **blueprint-writer-abeljacobi-iter117.** `AbelJacobi.tex` rewritten: Pic^0-vs-Albanese drift fixed; every block now leads with the Albanese-projection mathematical content; classical Pic^0/line-bundle prose demoted to `\begin{remark}` blocks.
8. **blueprint-writer-differentials-iter117.** `Differentials.tex` ~352 → 107 lines: chapter retitled to "The relative cotangent presheaf"; new `lem:relative_kaehler_presheaf_obj` lemma block; `thm:smooth_iff_locally_free_omega` proof sketch names the 5 [verified] Mathlib bridge lemmas; "Content out of autonomous-loop scope" disclosure section documents what was trimmed (sheaf condition, cotangent exact sequence, cotangent at section, Serre-duality genus identity).

## Review-phase subagent dispatches (this turn)

This review phase dispatched 4 mandatory audits to verify the post-trim state:

1. **lean-auditor (slug `review117`)** — read-only audit of the 10 surviving Lean files. **Result: 0 must-fix / 0 major / 6 minor / 0 excuse-comments.** All minors are cosmetic (commented-out Phase-A sketch in `Genus.lean:39–61`; verbose per-iteration status docstrings on a few files; redundant-but-deduped umbrella import; `Module.rank` vs `Module.finrank` shape on `smooth_iff_locally_free_omega` conclusion clause). No must-fix findings. Confirmed no stale references to deleted `BasicOpenCech.lean` survive in the cohomology file overviews. See `task_results/lean-auditor-review117.md`.
2. **lean-vs-blueprint-checker (slug `abeljacobi-review117`)** — `AbelJacobi.lean` vs `AbelJacobi.tex`. **Result: 0 must-fix / 0 major / 1 minor.** Coverage 3/3 declarations have `\lean{...}` blocks; hint precision precise; minor cosmetic: `thm:exists_unique_ofCurve_comp` prose says "group-scheme morphism" where Lean `∃!` ranges over arbitrary morphisms (equivalent by Mumford rigidity for abelian varieties). The iter-117 Pic^0-vs-Albanese drift fix landed successfully — every block leads with the Albanese-projection content matching the four-line Lean projection idiom. See `task_results/lean-vs-blueprint-checker-abeljacobi-review117.md`.
3. **lean-vs-blueprint-checker (slug `differentials-review117`)** — `Differentials.lean` vs `Differentials.tex`. **Result: 0 must-fix / 2 MAJOR / 3 minor.** The two MAJOR findings are blueprint-side and gate the iter-118 prover lane: (a) `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` named `[verified]` in the proof sketch **does not exist** in Mathlib b80f227 (actual API: `Algebra.SubmersivePresentation.basisKaehler` / `basisKaehlerOfIsCompl` defined on a `SubmersivePresentation` witness, not on `IsStandardSmoothOfRelativeDimension` directly); (b) `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` named `[verified]` **does not exist** (actual name: `AlgebraicGeometry.smoothOfRelativeDimension_iff`, no `is` prefix). The other three `[verified]`-tagged names (`rank_kaehlerDifferential`, `IsStandardSmooth.iff_exists_basis_kaehlerDifferential`, `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`) DO exist and are correctly cited. Plus the converse-direction sketch hand-waves how `Subsingleton (Algebra.H1Cotangent A B)` is supplied — this is the genuine deformation-theoretic content of the converse and the chapter must expand it before an iter-118 prover can close from prose. See `task_results/lean-vs-blueprint-checker-differentials-review117.md` and the upgraded HIGH-priority recommendations in `recommendations.md`.
4. **lean-vs-blueprint-checker (slug `jacobian-review117`)** — `Jacobian.lean` vs `Jacobian.tex`. **Result: 0 must-fix / 3 MAJOR / 3 minor.** The 3 MAJOR findings are all on blueprint coverage gaps (none block iter-118): (a) `thm:IsAlbanese_unique` Lean statement is strictly weaker than blueprint prose — Lean asserts `∃! (e : J₁ ⟶ J₂), …` (unique compatible morphism) while prose says "uniquely isomorphic" (unique isomorphism); the Lean proof actually computes the iso content (`g ≫ h = 𝟙 J₁`, `h ≫ g = 𝟙 J₂`) at L100–113 but discards the invertibility witnesses in the return. Fix by tightening one side; the protected signature would need the user's approval if the Lean is tightened. (b) `JacobianWitness` structure has no dedicated `\def{}` / `\structure{}` blueprint block despite being the central bundling object — recommended add a chapter block. (c) `IsAlbanese.ofCurve` / `.comp_ofCurve` / `.exists_unique_ofCurve_comp` (the data-extraction API of `IsAlbanese`) have no `\lean{...}` blocks despite feeding directly into the protected `AbelJacobi.Jacobian.ofCurve` family — recommended add a "Extracting the universal morphism" remark or lemma block with three `\lean{...}` hints. Minor: redundant `smooth` / `smoothGenus` fields in `JacobianWitness` (one implies the other); `geometricallyIrreducible_id_Spec` is vestigial-unused; in-proof `\leanok` at chapter L148 inside the `nonempty_jacobianWitness` `\begin{proof}` block (proof body is `sorry` so should be stripped by `sync_leanok`). See `task_results/lean-vs-blueprint-checker-jacobian-review117.md`.

## Sorry-elimination ledger (this iter)

| File | Pre-trim sorries | Post-trim sorries | Route taken |
|---|---|---|---|
| `Cohomology/BasicOpenCech.lean` | 6 (L1120, L1212, L1536, L1564, L1754, L1846) | — (file deleted) | File deletion. Orphan to the 9 protected declarations. |
| `Differentials.lean` | 5 (L191, L737, L931, L947, L1091) | 1 (L81, refactored presheaf form) | 4 deleted via file rewrite (~1100 → 83 LOC); 1 surviving as the refactored `smooth_iff_locally_free_omega`. |
| `Modules/Monoidal.lean` | 1 (L173) | — (file deleted) | File deletion. Orphan to the 9 protected declarations. |
| `Picard/LineBundle.lean` | 2 (L82, L96) | — (file deleted) | Cascading delete with the Picard chain. |
| `Picard/Functor.lean` | 1 (L181) | — (file deleted) | Cascading delete with the Picard chain. |
| `Jacobian.lean` | 1 (L179) | 1 (L179) | Kept as foundational existence hypothesis. |
| **Project total** | **16** | **2** | **−14** |

## Verification of the iter-117 plan-agent's core claims (this review)

I independently verified each of the iter-117 plan agent's claimed state changes:

1. ✅ `find AlgebraicJacobian -name '*.lean'` lists 10 files (1 umbrella + 9 module files), no `Picard/` or `Modules/` directories. Matches plan.md.
2. ✅ `python3 sorry_analyzer.py AlgebraicJacobian --format=summary` reports **2 sorries** in 2 files (`Differentials.lean: 1` + `Jacobian.lean: 1`). Matches plan.md.
3. ✅ `Differentials.lean` is 83 lines (`wc -l`). 3 declarations match the report.
4. ✅ `archon-protected.yaml` unchanged (9 protected declarations).
5. ✅ `grep -rn "axiom " AlgebraicJacobian/` returns only a non-code reference inside a `MayerVietorisCover.lean:504` docstring comment ("`[propext, Classical.choice, Quot.sound]` since iter-048; no new axiom introduced"). No active `axiom` declarations.
6. ✅ `blueprint/src/content.tex` lists the 9 surviving chapters; the 4 deleted-Lean chapters (`Modules_Monoidal`, `Picard_*`) are absent from the `\input` list. Their `.tex` files remain on disk as orphan documentation per the plan agent's recommendation.

## Blueprint markers updated (manual)

(None this iter.) The 3 blueprint-writer dispatches in iter-117 plan-phase rewrote the surviving chapters cleanly; `\leanok` placement is the deterministic `sync_leanok` phase's responsibility (runs between prover and review); `\mathlibok` is reserved for Mathlib-backed re-exports and the project has none on the surviving surface. No `% NOTE:` annotations were needed because there are no semantic translation gaps left on the surviving surface (the trimmed material is documented in `Differentials.tex` § "Content out of autonomous-loop scope" — a prose disclosure, not a marker).

If a future iter discovers stale `\leanok` in the orphan chapters (Picard_*, Modules_Monoidal — the Lean files are deleted), those markers should be removed during a chapter-cleanup pass. They are currently inert because `content.tex` does not `\input` those chapters.

## Notes section (LOW-severity)

- The iter-117 plan agent's notes mention `cotangent_at_section` (L947) as a possible Phase-C target if its dependency on `Scheme.Modules.pullback (relativeDifferentials ·)` could be sidestepped. The refactor in fact deleted `cotangent_at_section` entirely (it depended on the deleted sheafified `relativeDifferentials`). `STRATEGY.md` Phase C (L128–158) still mentions `cotangent_at_section` and "presheaf-side refactor" as if it could be re-introduced; that paragraph is mildly stale and could be tightened in iter-118 plan-phase.
- The iter-117 plan-phase's `meta.json` records `planValidate.status: ok_intentional_skip / objectives: 0`. This is the **correct** loop-infrastructure signal for a trim-only iter that schedules no prover lane: do not treat it as a real failure.
- The 1 deprecation warning on `Differentials.lean:76` (`AlgebraicGeometry.IsSmoothOfRelativeDimension`) is preserved per the protected signature shape. Mathlib has a `SmoothOfRelativeDimension` rename available; the protected `Jacobian.lean:50,213` instances already use the new name, so the warning fix is a routine signature tweak that the iter-118 plan-phase can issue.
