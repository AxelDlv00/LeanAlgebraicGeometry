# Blueprint Review Report

## Slug
iter152

## Iteration
152

## Top-level summaries

### Incomplete parts
- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (KDM): the statement block still asserts the **false** implication `D b = 0 ⇒ b ∈ range(algebraMap k B)` for a bare finite-type / standard-smooth `k`-algebra `B`. The iter-151 `% NOTE` correctly flags it false-as-stated, but the surrounding prose (the "Live route (C)" paragraph + the (C.a)–(C.d) itemisation + the superseded (p1)/(p2) chains) still presents (C.d) as a *closable prover target*. The corrected statement — per the committed pivot, add `[IsAlgClosed k]` + `[IsDomain B]` — is **not yet written**. This is the chapter the directive flagged for writer rewrite this iter.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: statement still reads "Let $\bar k$ be a field"; the committed pivot adds `[IsAlgClosed kbar]`. Neither the statement block nor the iter-127 "over-k commitment" paragraph (line 14) reflects the alg-closed setting.
- `RigidityKbar.tex` / `lem:constants_integral_over_base_field`: the proof is written as the path-(b) 4×(S3.*) factorisation + the path-(a) 7-step chain whose substantive gap is step (e) flat-base-change of $\Gamma$. Under `[IsAlgClosed kbar]` the proof **collapses** to steps (c)+(d) (`isField/finite_appTop_of_universallyClosed` + `IsAlgClosed.algebraMap_bijective_of_isIntegral`); step (e) and the (S3.*) decomposition fall off-path. The collapsed proof is not yet written.

### Proofs lacking detail
- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`: the (C.d) "transfer step" prose (paths S5.a / S5.b) describes closing a goal that is **unprovable as stated** (the iter-151 counterexamples CE1 `B=k×k`, CE2 `k=ℚ,B=ℚ(√2)` satisfy all hypotheses and break the conclusion). The (C.d) Leibniz-chase prose must be rewritten against the corrected `[IsAlgClosed k]`+`[IsDomain B]` signature, under which both counterexamples are excluded (CE1 by `IsDomain`, CE2 by `IsAlgClosed`).

### Multi-route coverage
- Route "M2.a genus-0 rigidity over an arbitrary base field $k$ (iter-127 over-k commitment, no alg-closure)": **now contradicted by the committed pivot.** The whole `RigidityKbar.tex`/`Jacobian.tex`/`AbelJacobi.tex` over-k narrative (no base-change, no Galois descent, `[Field kbar]` only) is reversed by adding `[IsAlgClosed kbar]`. See Strategy-modifying findings.

### Citation discipline
- `Genus.tex` (§ Definition, `% NOTE` before `def:genus`): the NOTE points at `references/hartshorne-ag.md` and `references/stacks-0BUG.md`, **neither of which exists on disk**. This is a `% NOTE` (not a formal `% SOURCE:` block) and `def:genus` is Archon-original, so it is not a hard citation-discipline fail, but the dangling file pointers should be repointed (the genuine Stacks 0BUG source is now bundled in `references/stacks-varieties.tex`, per the ChartAlgebraS3 render-fix notes) or dropped.

(All formal `% SOURCE:`/`% SOURCE QUOTE:` blocks audited — RigidityKbar Stacks 00T7, ChartAlgebraS3 035U/056T/0BUG/02KH/09HD/030K, Jacobian Kleiman — name local files that all exist on disk; quotes are verbatim Stacks/Kleiman English in original notation; visible `\textit{Source:}` pointers match the `% SOURCE:` pointers. No fabrication found.)

## Per-chapter

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: false
- **notes**:
  - `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` is FALSE as stated. Corrected signature must add `[IsAlgClosed k]` + `[IsDomain B]` (directive). Both hypotheses are needed jointly: `IsDomain B` kills CE1 (`B=k×k`), `IsAlgClosed k` kills CE2 (`k=ℚ`). The iter-151 NOTE that "CE2 rules out adding `[IsDomain B]`" only considered the hypotheses one-at-a-time; the joint addition is sound. Statement block + (C.a)–(C.d) + (p1)/(p2)/(BR.*) prose all need rewrite for the corrected setting.
  - `thm:rigidity_over_kbar` must gain `[IsAlgClosed kbar]`. The Lean code does NOT yet carry it (`RigidityKbar.lean:56` is `variable {kbar : Type u} [Field kbar]`); the pivot is committed in strategy but unlanded in code and blueprint.
  - The iter-127 over-k commitment paragraph (line 14) and the §"Use in the project" / C.2.g/(γ) framing now directly contradict the pivot (they assert "no `[IsAlgClosed kbar]`", "Galois descent DROPPED", "$k$-agnostic"). Must be rewritten.
  - `lem:constants_integral_over_base_field` proof collapses under `[IsAlgClosed kbar]` to steps (c)+(d); the path-(b) `\uses{lem:S3_sep_1…, lem:S3_sep_2…, lem:S3_pi_1…, lem:S3_pi_2…}` (proof block, line 2237) and the step-(e) flat-base-change gap become off-path. Rewrite the proof and prune the 4×S3 `\uses`.
  - The four (S3.*) lemmas (`lem:S3_sep_1…` … `lem:S3_pi_2…`) become descoped → recommend marking off-critical-path (NOT removing — see cross-chapter note on cascade risk).
  - Chart-algebra (α) `lem:chart_algebra_isPushout_of_affine_product`, (β-core) `lem:chart_algebra_df_zero_factors_through_constant_on_chart`, and (ii-scheme-lift) `lem:Scheme_Over_ext_of_diff_zero` are internally sound; the (β-core) lemma currently delegates one-line to the FALSE KDM, so its `\leanok`-closed status is parasitic on KDM's residual `sorry`. Once KDM's signature is corrected the consumer must supply `[IsDomain R]` (curve chart, integral) and thread `[IsAlgClosed k]` from the pivot.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Pointer chapter; verbatim Stacks citations are clean and the four `\lean{…}` targets exist in `ChartAlgebraS3.lean`. But the "Body status (iter-149 prover lane)" + "Iter-150+ closure strategy" prose presents the four (S3.*) sub-claims as **active build targets**, which the iter-152 `[IsAlgClosed kbar]` pivot descopes. The chapter already carries an iter-150 HYBRID-DEFERRED note (lines 82–91) descoping (S3.pi.1/2); under the pivot **all four** (S3.sep.1/2 + S3.pi.1/2) leave the M2.a critical path (constants now closes via `IsAlgClosed.algebraMap_bijective_of_isIntegral`).
  - **Recommendation: mark off-critical-path, do NOT remove.** Removing the four `lem:S3_*` labels from `RigidityKbar.tex` would break the `\cref`s here (lines 18–24, 108–225) and the path-(b) `\uses` in the constants proof. Keep them as auditable / upstream-Mathlib-PR record; add an explicit "descoped under iter-152 alg-closed pivot" status line.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `def:genusZeroWitness` proof (and C.2.f/C.2.g/(γ) of `thm:nonempty_jacobianWitness`, and Layer-I prose) repeatedly assert the iter-127 over-k commitment: rigidity established "directly over the base field $k$", "no base-change to $\bar k$", "Galois descent DROPPED", `rigidity_over_kbar` signature "$k$-agnostic". The committed `[IsAlgClosed kbar]` pivot reverses this. All these passages are now stale/contradictory.
  - Consumer-compatibility concern (see Strategy-modifying findings): `genusZeroWitness` invokes `rigidity_over_kbar` over a *general* base field `k`. If `rigidity_over_kbar` now demands `[IsAlgClosed k]`, the genus-0 witness over a non-alg-closed `k` either needs base-change+descent reintroduced or a base-field restriction. This must be resolved before the M2.b prover lane runs.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Prose at lines 82, 87, 89 repeats the now-stale over-k framing for `thm:rigidity_over_kbar` ("signature is $k$-agnostic", "no algebraic-closure … hypothesis", "sub-step C.2.f DROPPED"). Same staleness as `Jacobian.tex`. No active prover lane here (the chapter's three declarations are thin Albanese projections, already closed), so this blocks no prover — but it is a `correct: partial` consistency fix.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Minor: `% NOTE` before `def:genus` cites two `references/*.md` files that do not exist on disk (see Citation discipline). Informational.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

## Cross-chapter notes

- **Over-k framing is stale in three chapters at once.** `RigidityKbar.tex` (line 14, C.2.g, §γ), `Jacobian.tex` (C.2.f/C.2.g/§γ/genusZeroWitness/Layer-I), and `AbelJacobi.tex` (lines 82/87/89) all hard-assert "rigidity over arbitrary $k$, no `[IsAlgClosed]`, Galois descent dropped". The committed pivot adds `[IsAlgClosed kbar]`. A single writer pass should reconcile all three to the alg-closed reading; fixing only `RigidityKbar.tex` leaves `Jacobian.tex`/`AbelJacobi.tex` contradicting it.
- **Prospective broken-ref cascade from descoping.** A whole-blueprint label/ref scan currently shows **zero** broken `\uses`/`\cref`/`\ref` (220 labels, all targets resolve). The risk is prospective: if the writer *removes* the four `lem:S3_*` labels rather than marking them off-path, it will break (a) the path-(b) `\uses{lem:S3_*}` in the `constants_integral_over_base_field` proof block (`RigidityKbar.tex:2237`) and (b) the `\cref`s in `ChartAlgebraS3.tex` (lines 18–24, 108–225). Recommend off-path marking over removal; if removal is chosen, both sites must be updated in the same pass.
- **KDM `\leanok` parasitism.** `lem:chart_algebra_df_zero_factors_through_constant_on_chart` is `\leanok` only because it one-line-delegates to the false KDM (whose body holds a `sorry` at (C.d)). Correcting KDM's signature will force the consumer to supply `[IsDomain R]` + `[IsAlgClosed k]`; the sync_leanok status of the consumer should be re-checked after the rewrite.

## Strategy-modifying findings (if any)

- `RigidityKbar.tex` / `thm:rigidity_over_kbar` × `Jacobian.tex` / `def:genusZeroWitness`: adding `[IsAlgClosed kbar]` to `rigidity_over_kbar` is sound for collapsing the constants lemma and fixing KDM, but it **propagates a base-field hypothesis up the M2 critical path**. `genusZeroWitness` (the M2.b consumer) currently invokes rigidity *directly over the curve's base field $k$* with a supplied $k$-rational point — the explicit purpose of the iter-127 over-k commitment, which was costed at saving 500–900 LOC / 7–13 iter by *avoiding* base-change-and-Galois-descent. Requiring `[IsAlgClosed k]` at the top means the genus-0 witness over a non-alg-closed `k` must EITHER (a) reintroduce base-change to $\bar k$ + Galois descent of morphism equality (un-doing the iter-127 saving), OR (b) restrict the genus-0 M2.b deliverable to an algebraically closed base. STRATEGY.md must record which disposition is taken before any RigidityKbar/ChartAlgebra/ChartAlgebraS3 prover lane is dispatched; the blueprint rewrite of all three over-k chapters depends on that choice.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` is `complete: partial` / `correct: false` and feeds the active KDM + `rigidity_over_kbar` + chart-algebra prover lanes. **HARD GATE: DROP every prover lane whose Lean file maps to `RigidityKbar.tex` this iter** — `RigidityKbar.lean` (`rigidity_over_kbar`), `Cotangent/ChartAlgebra.lean` (KDM, constants, df_zero, ext_of_diff_zero), `Cotangent/ChartAlgebraS3.lean` (the four S3.*). Dispatch the blueprint-writing subagent for `RigidityKbar.tex` with the corrected-KDM-signature + collapsed-constants + alg-closed-`rigidity_over_kbar` + S3-off-path directive.
  - `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` is `correct: partial` (active-prover-named file being descoped). Resolve via off-path marking in the same writer pass.
  - `Jacobian.tex` and `AbelJacobi.tex` are `correct: partial` (stale over-k framing). Must be reconciled in the same writer pass; `Jacobian.tex` additionally carries the strategy-modifying consumer-compatibility question above. Neither blocks a *currently-dispatched* prover lane on its own, but the strategy-modifying finding gates all M2 lanes.
  - Strategy-modifying findings section is non-empty → STRATEGY.md update (base-field disposition for `genusZeroWitness`) precedes any M2 Lean work.

- **soon**:
  - `Genus.tex` `% NOTE` dangling `references/*.md` pointers — repoint or drop (not on any prover's path; `def:genus` already closed).

- **informational**:
  - Low-priority rename `rigidity_over_kbar` → `rigidity_over_k` referenced in several chapters is now moot under the pivot (the `kbar`/alg-closed name is once again accurate); drop the scheduled-rename mentions.

Overall verdict: Blueprint is internally reference-consistent (0 broken refs) but the iter-152 `[IsAlgClosed kbar]` pivot has not landed in prose or code — `RigidityKbar.tex` carries a false KDM statement and stale over-k framing shared with `Jacobian.tex`/`AbelJacobi.tex`, so all M2/RigidityKbar prover lanes must be deferred behind a STRATEGY base-field decision and a writer rewrite this iter.
