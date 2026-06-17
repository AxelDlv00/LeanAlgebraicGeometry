# Iter-129 (Archon canonical) — review

## Outcome at a glance

- **Plan-phase-only iter by design** (`planValidate.status: ok_intentional_skip / objectives: 0`; `prover.durationSecs: 0`; `plan.durationSecs: 3415` ≈ 57 min). Iter-129 was scoped as a fix-up + audit iter to absorb the iter-128 review must-fix list; no prover dispatch.
- **Substantive structural change via 1 refactor + 2 blueprint-writers + 1 mathlib-analogist + 3 plan-phase critics + 3 review-phase audits**:
  - `refactor-cotangent-grpobj-fixup-iter129` renamed `AlgebraicGeometry.GrpObj.lieAlgebra` → `cotangentSpaceAtIdentity` and relaxed `[SmoothOfRelativeDimension 1 G.hom]` → `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`. Body unchanged. Docstring rewritten to drop the dualisation convention (file now consistently states the body returns `η_G^* Ω_{G/k}`, the un-dualised cotangent). `Jacobian.lean` file-level header rewritten to enumerate the now-two `sorry`-bodied declarations.
  - `blueprint-writer-rigiditykbar-iter129` rewrote `RigidityKbar.tex` (i.a) block: rename `lem:GrpObj_lieAlgebra` → `lem:GrpObj_cotangentSpace`, add bridge lemma `lem:GrpObj_cotangent_bridge` (iter-130+ Lean target `cotangentSpaceAtIdentity_iso_localRingCotangent`), rewrite rank lemma with 4-step Mathlib-anchored proof, fix phantom `IsRegularLocalRing.cotangentSpace` → `Ideal.IsLocalRing.CotangentSpace`, add inline signature stubs to all three `\lean{...}` hints, update all `\uses{...}` cross-references.
  - `blueprint-writer-orphan-chapters-iter129` deleted 4 orphan chapters (522 lines total): `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`. Zero dangling cross-references in retained chapters. Blueprint chapter count 14 → 10.
  - `mathlib-analogist-lieAlgebra-rank-bridge-iter129` returned **ALIGN_WITH_MATHLIB / critical**: the iter-128 body of `cotangentSpaceAtIdentity` **computes the zero `k`-module** for every smooth proper geometrically irreducible group scheme `G/k` with relative dimension `n ≥ 1` (5-step diagnostic supplied: presheaf pullback at `⊤` collapses to `k` because `Spec k` is single-point; proper geom-integral `G/k` ⇒ `Γ(G, ⊤) = k`; so `φ'.app (op ⊤) : k → k` and `Ω[k/k] = 0`; extendScalars of `0` is `0`). The body must be replaced before iter-130's rank lemma can be stated, let alone proven. Persistent file `analogies/lieAlgebra-rank-bridge.md` written. Replacement (B) — affine-chart base change via `smooth_locally_free_omega` — recommended for iter-130 (200–400 LOC, no new Mathlib gaps). Replacement (A) stalk-side cotangent (500–1000 LOC) and (C) sheafified `Ω` (800–2000 LOC) deferred.
  - `strategy-critic-iter129` CHALLENGE (5 must-fix + 2 alternatives + 5 SOUND); all 5 must-fix addressed via STRATEGY.md edits this iter.
  - `blueprint-reviewer-iter129` 3 must-fix + 4 soon; all 3 must-fix addressed by the two parallel blueprint-writer dispatches.
  - `progress-critic-iter129` 3 UNCLEAR / 0 CHURNING / 0 STUCK — all three UNCLEAR verdicts are healthy (piece (i) is fresh-with-COMPLETE; `rigidity_over_kbar` and `genusZeroWitness` are deliberately dormant).
- **Net sorry change**: 3 → 3 (refactor was signature-only — rename + binder relax, no body churn). Per-file at close:
  - `AlgebraicJacobian/Jacobian.lean:188` — `genusZeroWitness` (iter-127 scaffold; body closure iter-138+).
  - `AlgebraicJacobian/Jacobian.lean:208` — `nonempty_jacobianWitness` (Phase-C OFF-LIMITS; iter-148+).
  - `AlgebraicJacobian/RigidityKbar.lean:75` — `rigidity_over_kbar` (iter-126 scaffold; body iter-144+).
  `AlgebraicJacobian/Cotangent/GrpObj.lean` carries **0** sorries (iter-128 close preserved).
- **Compile-verified**: yes. `lake build`: ✓ 8330/8330 jobs. Only the three carry-over `declaration uses sorry` warnings on `Jacobian.lean:188`, `Jacobian.lean:208`, `RigidityKbar.lean:75` (plus 2 pre-existing long-line linter warnings on `Jacobian.lean:231` and `AbelJacobi.lean:22`).
- **No new axioms.** `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` returns `{propext, Classical.choice, Quot.sound}` — kernel-only, no `sorryAx`. `archon-protected.yaml` unchanged (9 protected declarations).
- **Stage**: stays at `prover` for iter-130. Per iter-129 plan + analogist verdict, the iter-130 mandatory prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean` must **swap the `cotangentSpaceAtIdentity` body to Replacement (B)** (affine-chart base change) BEFORE any rank-lemma dispatch. The iter-128 body is provably zero against the target class.
- **Meta**: `meta.json planValidate.status: ok_intentional_skip / objectives: 0`; `prover.durationSecs: 0`; `plan.durationSecs: 3415`. 7 plan-phase subagent dispatches + 3 review-phase audits (lean-auditor + 2 lean-vs-blueprint-checkers).

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **3**, distributed:
  - `AlgebraicJacobian/Jacobian.lean:188` — `genusZeroWitness` (iter-127 scaffold; unchanged this iter).
  - `AlgebraicJacobian/Jacobian.lean:208` — `nonempty_jacobianWitness` (OFF-LIMITS; iter-148+; unchanged).
  - `AlgebraicJacobian/RigidityKbar.lean:75` — `rigidity_over_kbar` (iter-126 scaffold; body iter-144+; unchanged).
- **Solved this iter**: 0 (no prover lane).
- **Partial this iter**: 0 (no prover lane).
- **Blocked this iter**: 0 (no prover lane; no STUCK from progress-critic).
- **Untouched (off-limits / off-prover-lane)**: 3 (the three sorry sites above; all recognised non-prover-lane work this iter).

## Critical iter-129 discovery (mathlib-analogist)

The single most consequential finding this iter is **out of band** of the
plan-phase HARD GATE / refactor / blueprint-writer apparatus: the iter-128
body of `cotangentSpaceAtIdentity` (formerly `lieAlgebra`) is
**mathematically degenerate** — it computes the zero `k`-module for every
smooth proper geometrically irreducible `G/k` with relative dimension
`n ≥ 1`, i.e. for **every consumer in the target class**. The 5-step
diagnostic:

1. `(relativeDifferentialsPresheaf G.hom).obj (op ⊤) = CommRingCat.KaehlerDifferential (φ'.app (op ⊤))` by `rfl`.
2. `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op ⊤)` is a colimit over `{V : Opens(Spec k) | f.base(⊤) ⊆ V}`. Since `Spec k` is single-point, the diagram collapses to `Γ(Spec k, ⊤) ≅ k`.
3. Smooth + proper + geometrically irreducible ⇒ geometrically integral ⇒ `Γ(G, ⊤) = k` (Stacks 0BUG; in Mathlib as `AlgebraicGeometry.isField_of_universallyClosed`).
4. So `φ'.app (op ⊤) : k → k`, the structure map (essentially identity). By `KaehlerDifferential.subsingleton_of_surjective`, `Ω[k/k] = 0`.
5. `(ModuleCat.extendScalars ψ.hom).obj 0 = 0`.

The strategy-critic-iter129 had flagged this concern abstractly under its
M2 CHALLENGE "hidden presheaf-vs-sheaf bridge re-enters via the deferred
rank lemma"; the mathlib-analogist sharpened that abstract concern to a
**concrete vacuity claim** with a Mathlib-named diagnostic chain.

This is exactly the failure mode the iter-128 review-phase
lean-vs-blueprint-checker anticipated when it flagged the "bridge gap"
between the evaluate-then-extend-scalars Lean body and the
`𝔪/𝔪²` stalk presentation of the blueprint proof: there *is no*
canonical bridge — the presheaf-side global sections of a non-affine
scheme genuinely differ from the sheaf-side, and for proper geom-integral
`G` the difference is total annihilation of `Ω` rather than a finite
discrepancy.

**Status**: the iter-128 body is kernel-clean and `lean_verify`-clean,
but proves a vacuous claim (it is `ModuleCat k` of `0`, not the
mathematical cotangent space at the identity). The strategy-critic's
CHALLENGE was correct in substance and is now resolved by the iter-130
prover lane staging (body swap to Replacement (B)).

## Iter-129 plan-phase outputs (load-bearing this iter)

### `refactor-cotangent-grpobj-fixup-iter129` → COMPLETE (0 sorry change)

- `AlgebraicGeometry.GrpObj.lieAlgebra` → `cotangentSpaceAtIdentity` rename. Signature `[SmoothOfRelativeDimension 1 G.hom]` → `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`. Body verbatim from iter-128 (5 lines, `let ηleft / ψ / M`, then `(ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))`).
- File-level docstring rewritten to drop the dualisation framing — file now consistently states the body returns `η_G^* Ω_{G/k}` (the cotangent, $\mathfrak g^\vee$); the Lie algebra `𝔤 = \mathrm{Hom}_k(\cdot, k)` is recovered externally.
- `Jacobian.lean` file-level header rewritten: new 2-sorry inventory enumerates `genusZeroWitness` (iter-127, body closure iter-138+) and `nonempty_jacobianWitness` (OFF-LIMITS, iter-148+). Bullet list of file contents now includes `genusZeroWitness`.
- Project sorry count unchanged (refactor was signature/header-only).
- Verification trail: `lake build` ✓ 8330/8330; `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` ✓ kernel-only.
- Caveat from the refactor agent's report: line-number drift in `Jacobian.lean` (the 2 sorries moved from 174 → 188 and 197 → 208 because the new header expanded by ~14 lines).

### `blueprint-writer-rigiditykbar-iter129` → COMPLETE (chapter substantially rewritten)

- (i.a) lemma renamed: `lem:GrpObj_lieAlgebra` → `lem:GrpObj_cotangentSpace`; `\lean{...}` hint updated to `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`; inline signature stub added pinning `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`; encoding note rewritten to pin the un-dualised convention.
- New bridge lemma `lem:GrpObj_cotangent_bridge` added between (i.a) and the rank lemma. Lean target: `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent` (iter-130+ build target). Statement: canonical $k$-linear iso `cotangentSpaceAtIdentity G ≅ Ideal.IsLocalRing.CotangentSpace (Scheme.stalk G.left ...)`. Proof: 2-step decomposition (localisation kills relative differentials + Stacks 02G1 identification).
- Rank lemma `lem:GrpObj_lieAlgebra_finrank` rewritten with 4-step Mathlib-anchored proof (`Ideal.IsLocalRing.CotangentSpace`; smooth ⇒ `IsRegularLocalRing` of dim `n`; cotangent rank = Krull dim for regular local; cross-check via `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` + project's `smooth_locally_free_omega`). `\lean{...}` hint updated to `cotangentSpaceAtIdentity_finrank_eq` (iter-130+ build target).
- Phantom `IsRegularLocalRing.cotangentSpace` (which doesn't exist in Mathlib `b80f227`) replaced everywhere by the verified `Ideal.IsLocalRing.CotangentSpace`.
- All `\uses{lem:GrpObj_lieAlgebra}` sites updated to `\uses{lem:GrpObj_cotangentSpace}`; `lem:GrpObj_lieAlgebra_finrank` label preserved per directive.
- Writer's caveat: bridge framing is closer to Replacement (A) canonical stalk-side, while the iter-130 prover lane will implement Replacement (B) chart-side. Chapter prose may need iter-131+ alignment if the discrepancy bites a future reader.

### `blueprint-writer-orphan-chapters-iter129` → COMPLETE (4 chapters / 522 LOC deleted)

- Deleted `Modules_Monoidal.tex` (148 LOC), `Picard_LineBundle.tex` (189 LOC), `Picard_Functor.tex` (89 LOC), `Picard_FunctorAb.tex` (96 LOC).
- `content.tex` `\input{...}` lines for the four chapters were already absent (had been removed in an earlier iter, leaving the chapter files as orphans).
- Two greps over retained chapters confirm zero dangling `\ref{...}` / `\uses{...}` to deleted labels.
- Pre-existing `Jacobian.tex` prose narrating "Route A — Picard scheme" as motivation (line 255) stands on its own — no broken links.

### `mathlib-analogist-lieAlgebra-rank-bridge-iter129` → CRITICAL discovery + ALIGN_WITH_MATHLIB

See "Critical iter-129 discovery" above. Headline outputs:
- **Decision 1**: iter-128 body computes zero for the target class. The rank lemma `finrank cotangentSpaceAtIdentity = n` is provably false against this body for `n ≥ 1`. Verdict: ALIGN_WITH_MATHLIB / must-fix-this-iter (body swap before iter-130 rank lemma).
- **Decision 2**: Replacement (B) — affine-chart base change via `smooth_locally_free_omega` + `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` — chosen for iter-130. Estimated 200–400 LOC. Tradeoff: non-canonical (depends on chart choice via `Classical.choice`); acceptable for the single live consumer (rigidity-over-`k̄`, which only needs existence of a rank-`n` `k`-module).
- **Decision 3**: iter-130+ rank-lemma closure chain has 7 Mathlib pieces, all verified or expected (see persistent file `analogies/lieAlgebra-rank-bridge.md`).
- **Decision 4**: standalone scheme-level cotangent sheaf (Replacement C) NOT activated — Replacement (B) gives the same rank lemma at much lower cost.

Persistent file `analogies/lieAlgebra-rank-bridge.md` (189 LOC) documents the rationale for future iters.

### Plan-phase critics

| Subagent | Slug | Verdict | This-iter response |
|---|---|---|---|
| `strategy-critic` | iter129 | CHALLENGE (5 must-fix + 2 alternatives + 5 SOUND) | All 5 must-fix addressed via STRATEGY.md edits (signature relax; rank-lemma bridge; revert trigger retarget; ℙ¹ rigidity hedge; standalone-cotangent-sheaf trigger engaged via analogist dispatch). |
| `blueprint-reviewer` | iter129 | 3 must-fix + 4 soon | All 3 must-fix landed (RigidityKbar must-fix bundle + orphan chapters deleted). |
| `progress-critic` | iter129 | 3 UNCLEAR / 0 CHURNING / 0 STUCK | All three UNCLEAR are healthy; no corrective needed. Iter-129 refactor lane is the right structural response to iter-128 must-fix list (per the critic's own note). |

## Review-phase audits

### `lean-auditor-review129` → dispatched in review phase

See `.archon/task_results/lean-auditor-review129.md` for the per-file checklist. Focus areas: `Cotangent/GrpObj.lean` post-rename (docstring/body coherence); `Jacobian.lean` post-header-rewrite; `RigidityKbar.lean` for any drift since iter-126 scaffold.

### `lean-vs-blueprint-checker-cotangent-grpobj-review129` → 0 must-fix / 1 major / 2 minor

Per-file Lean vs blueprint check on `AlgebraicJacobian/Cotangent/GrpObj.lean` ↔ `RigidityKbar.tex`. Both files were edited this iter by independent parallel subagents. The signature/stub side aligns character-for-character. The **major** finding (per the directive's explicit "flag this drift" instruction): the iter-129 writer pass frames the iter-128 body as the **canonically-correct realisation** of `η_G^* Ω_{G/k}` (proof line 115: "*realises*"; statement line 141: "the left-hand side is the iter-128 evaluate-then-extend-scalars Lean body" without hedge) and the new `lem:GrpObj_cotangent_bridge` as a **tautological identification** of two equal-by-construction objects (proof line 160). Both framings are positively wrong if the iter-128 body is mathematically degenerate (per the parallel mathlib-analogist finding). Recommended chapter-side actions: replace "*realises*" with "*currently encodes*", drop "tautological", hedge "iter-128 placeholder Lean body (scheduled for iter-130 replacement)". Recommended Lean-side action (minor): add forward-reference to `cotangentSpaceAtIdentity_iso_localRingCotangent` in the docstring at `Cotangent/GrpObj.lean:62-101`. Optional minor: add `\notready` to `lem:GrpObj_cotangent_bridge` for consistency with the rank lemma. All folded into iter-130 recommendations. Full report at `.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review129.md`.

### `lean-vs-blueprint-checker-jacobian-review129` → 0 must-fix / 0 major / 2 minor (PASS)

Per-file Lean vs blueprint check on `AlgebraicJacobian/Jacobian.lean` ↔ `Jacobian.tex`. Header block in `Jacobian.lean` was rewritten this iter (refactor lane); the chapter is at its iter-127 state. All 14 `\lean{...}` blocks resolve cleanly to declarations in the file with matching signatures. The only minor findings are 2 stale line references in `Jacobian.tex:398/410` pointing at pre-iter-129-header file positions (`geometricallyIrreducible_id_Spec` now at L134–140, was L120–126; `genusZeroWitness` now at L188–192, was L174–178). Low-priority editorial cleanup; defer to iter-131. Full report at `.archon/task_results/lean-vs-blueprint-checker-jacobian-review129.md`.

## Blueprint marker updates (manual, this iter)

None this iter (manual `\mathlibok` / `\lean{...}` rename / `% NOTE` / `\notready` cleanup). The blueprint-writer-rigiditykbar-iter129 dispatch handled all `\lean{...}` macro updates needed for the rename. The deterministic `sync_leanok` phase handles `\leanok` markers automatically; if it ran between the prover and me, its commit will appear separately as `archon[129/marker-sync]`.

(One observation that future iters may want to address but is NOT in my marker-update domain: the rank lemma's `\lean{...}` hint now points to `cotangentSpaceAtIdentity_finrank_eq`, an iter-130+ build target with no Lean counterpart yet — this is intentional per the chapter's "iter-130+ build target" framing, and `sync_leanok` will leave the proof block alone until the Lean lands.)

## TO_USER.md

Left empty. The iter-129 outcome is a structural fix-up iter with three healthy UNCLEAR progress-critic verdicts and no user-facing blocker. The critical mathlib-analogist discovery (iter-128 body computes zero) is fully absorbed by the iter-130 staged prover lane on body swap; no user input required. `USER_HINTS.md` is empty entering iter-130, consistent with the iter-129 plan's "no fallback needed" framing.

## Knowledge Base additions (this iter)

Three new Proof Patterns / soundness lessons folded into `PROJECT_STATUS.md § Knowledge Base`:

1. **Presheaf-pullback at top open of `Spec k` collapses to `k`** — `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op ⊤)` is the pointwise left Kan extension colimit over `{V : Opens(Spec k) | f.base(⊤) ⊆ V}`. Since `Spec k` is single-point, the indexing diagram is `{V = ⊤}` and the colimit collapses to `Γ(Spec k, ⊤) ≅ k`. **Consequence**: evaluating a presheaf-of-modules pullback along a `Spec k → X` morphism at the top open of `X` loses **all** information except the `k`-side structure map.
2. **Kernel-clean ≠ mathematically correct** — `lean_verify` returning kernel-only axioms means the *proof* uses only allowed axioms; it does NOT mean the *statement* is mathematically meaningful. The iter-128 body of `cotangentSpaceAtIdentity` is kernel-clean but produces the zero `k`-module for every consumer (when the math claims it should be rank-`n`). **Lesson**: a mathlib-analogist consult must be triggered when a new definition's construction differs structurally from the blueprint sketch (here: evaluate-first vs `𝔪/𝔪²` stalk), even if the Lean body type-checks.
3. **`Ideal.IsLocalRing.CotangentSpace` is the verified Mathlib name** — defined as `(maximalIdeal R).Cotangent` in `Mathlib.RingTheory.Ideal.Cotangent`. The name `IsRegularLocalRing.cotangentSpace` (which the strategy + blueprint prose referenced earlier) does NOT exist; replace any future references.

## Recommendations summary

Per `recommendations.md` (full detail there), the iter-130 plan-phase lead is:
- **Mandatory prover lane**: swap `cotangentSpaceAtIdentity` body to Replacement (B) via affine-chart base change.
- Lane size: 200–400 LOC; expected to close in 1–2 prover iters per analogist's Mathlib closure chain.
- HARD GATE: iter-130 mandatory blueprint-reviewer must green-light first; the iter-129 RigidityKbar writer pass addressed the iter-128 review's blocking items, but the iter-129+ chapter-vs-Lean coherence depends on the iter-130 body adoption (Replacement B is chart-side; the chapter's new bridge lemma is closer to Replacement A canonical stalk-side).
- If body swap closes early, optional Wave 2: scaffold + close `cotangentSpaceAtIdentity_finrank_eq` (rank lemma; additional 50–100 LOC).

## Meta-pattern verdict

Per `progress-critic-iter129`: piece (i) is UNCLEAR (1 iter of COMPLETE
data + 1 iter of structural fix-up; the fix-up is not duplicate helper
churn). The iter-130 prover lane on body swap is the next data point.
**If iter-130 body-swap closes**, piece (i) flips to CONVERGING (substantive
COMPLETE close on a new body, plus the iter-128 close on the
now-superseded body). **If iter-130 returns PARTIAL/INCOMPLETE**, the
analogist's closure chain has a Mathlib gap the iter-129 verification
did not catch — escalate.

Iter-128 (prover) → iter-129 (plan-only) → iter-130 (prover-staged). The
META-PATTERN tripwire (3 consecutive plan-phase-only iters) is far from
re-firing; iter-130 must also be plan-phase-only to begin tracking
toward it (i.e. the tripwire would need iter-130 + iter-131 + iter-132
all plan-only).
