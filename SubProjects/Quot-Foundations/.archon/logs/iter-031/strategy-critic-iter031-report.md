# Strategy Critic Report

## Slug
iter031

## Iteration
031

## Routes audited

### Route: FBC (affine lemma direct-on-sections + H⁰-equalizer globalization)

- **Goal-alignment**: PASS — proving `g^* f_* F ≅ f'_* g'^* F` for i=0 via Stacks 02KH part 2 is exactly the parent cone's `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PASS — the affine identity is the algebra regrouping `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (`regroupEquiv`, done) read through the proved tilde dictionaries. Trivial mathematics; the content is real and correct. Globalization via the H⁰ sheaf-condition equalizer `∏Γ(Uᵢ) ⇉ ∏Γ(Uᵢⱼ)` preserved by a flat `−⊗B` is the standard Čech-free route and is sound.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The FBC-A row carries `OVER_BUDGET 13×`, `STUCK by sorry-count (4 for 3 rounds)`, and yet `Iters left: 1` / `ACTIVE (final round)`. The "one assembly splice from done" framing is the classic almost-done trap on a sub-route that has not closed across many rounds.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none on the math; `conjugateEquiv_counit_symm` is reported proven and the residual is plumbing, not a missing lemma.
- **Effort honesty**: under-counted — `Iters left: 1` is not credible given the row is OVER_BUDGET 13× with a sorry count flat at 4 for three rounds. The mathematics is a one-line regrouping; the cost lives entirely in fighting the `X.Modules` instance diamond by term-mode congruence splicing. A "1" here is a velocity-fiction, not an estimate.
- **Parallelism under-exploited**: no — FBC-B is correctly sequenced after FBC-A; QUOT/GF run in parallel.
- **Verdict**: CHALLENGE — the *route's mathematics* is sound, but the chosen *Lean realization* (prove the sheaf iso on global sections, then reconcile against `X.Modules` via term-mode `congrArg`/`Functor.congr_map` splices because `rw`/`simp`/`erw` are "CONCLUSIVELY DEAD") is exhibiting local-minimum behaviour. The planner must either (a) re-encode FBC-A so the load-bearing iso lives entirely in plain `ModuleCat` (where the regroup iso already is) and is transported across the tilde equivalence exactly once — keeping the `X.Modules` diamond out of the proof term — or (b) stop re-dating `Iters left: 1` and honour the escalation valve. Pushing "the same 3 ≤30-LOC clean-term lemmas + one splice" for a fourth round without an encoding change is not a plan.

### Route: GF (generic flatness — algebraic core done, geometric wrap)

- **Goal-alignment**: PASS — geometric `genericFlatness` over the parent's re-signed `[IsQuasicoherent]`+`[IsFiniteType]` interface is the cone node.
- **Mathematical soundness**: PASS — pass to an affine open `Spec A` of the integral base (A noetherian domain), cover the quasi-compact preimage by finitely many finite-type affines `W_j`, apply the done algebraic core per patch for `f_j ≠ 0`, intersect to `V = D(∏ f_j)` (nonempty since the base is irreducible), conclude flatness from per-patch freeness via flat-locality. Each step is standard (Stacks 052A/051R; Nitsure §4). The `[IsIntegral S]`+`[QuasiCompact p]` hypotheses are correctly flagged as *required else false* — the strategy is not hiding the missing-hypothesis trap here.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — G1 bottoms at gap1, which is a genuine shared keystone the strategy commits to building (QUOT-side), not a deferral to upstream.
- **Phantom prerequisites**: none — `Module.flat_of_isLocalized_maximal` VERIFIED (see Prerequisite verification).
- **Effort honesty**: reasonable.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND.

### Route: QUOT (Hilbert poly / Quot functor / Grassmannian defs; gap1 keystone)

- **Goal-alignment**: PASS — defs route to the parent's `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`. One watch-item below on definitional canonicity.
- **Mathematical soundness**: PARTIAL — two genuine soundness watch-items, both *acknowledged but fenced*, not hidden:
  1. **Canonicity of `Φ_s`** (Open Q1). Defining the Hilbert polynomial as the polynomial agreeing with `m ↦ dim_{κ(s)} Γ(X_s, F_s⊗L_s^m)` for `m≫0` from a *chosen* graded presentation is only well-defined once presentation-independence (equivalently, the Serre `m≫0` agreement with the intrinsic Euler characteristic χ) is proved. Until then `Grassmannian := QuotFunctor (𝟙 S) V Φ_d` references a possibly-non-canonical `Φ_d`. The strategy correctly gates every S1 prover on this decision, so no false def gets built prematurely — but the decision is deferred "until gap1 lands," which is a real (if bounded) sequencing bet.
  2. **Degree-1 generation hypothesis.** The chosen rationality engine (`gradedModule_hilbertSeries_rational`, Stacks 00K1) requires `S₊` generated in degree 1. The geometric encoding via `L_s^{⊗m}` therefore silently needs `L_s` *very ample / the section algebra standard-graded*, not merely ample. For the intended Proj-S-with-O(1) application this holds by construction, but the `def:hilbert_polynomial` signature should carry the standard-graded/very-ample hypothesis explicitly or it admits ample-but-not-degree-1 counterexamples where the polynomiality route does not apply.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — gap1, SheafOfModules tensor powers, and rank-`r` local-freeness are all owned with project-side sub-builds, not punted upstream.
- **Phantom prerequisites**: none on spot-check — `Polynomial.existsUnique_hilbertPoly` VERIFIED (CharZero, matches the strategy's `[CharZero]` note); `Scheme.Modules.restrictFunctor`/`pullback` claimed-existing and consistent with the `SheafOfModules`-over-a-site framework that `SheafOfModules.IsQuasicoherent` lives in.
- **Effort honesty**: reasonable for QUOT-defs; see GR/repr note below.
- **Parallelism under-exploited**: no — all four QUOT files import only Mathlib and are flagged parallel-authorable.
- **Verdict**: SOUND — proceed, but carry the two watch-items (canonicity + degree-1 generation) into the def signatures so the foundation is not laid on an under-hypothesised `Φ_s`.

### Route: gap1 decomposition (C bridge → P1 → D descent → assembly)

- **Goal-alignment**: PASS — `IsQuasicoherent M → IsIso M.fromTildeΓ` on `Spec R` is the keystone bottom shared by GF-G1 and the QUOT annihilator.
- **Mathematical soundness**: PASS — the canonical content of "a quasi-coherent sheaf on an affine is the tilde of its sections" IS the section-localization fact `Γ(D(f), M) = Γ(Spec R, M)_f` (Stacks 01HA / Hartshorne II.5.3); checking `fromTildeΓ` on the basic-open basis where both sides are the localization is the textbook proof. (D) targets a true lemma; (C) `overRestrictIso` is a framework artifact of the `SheafOfModules`-over-`J.over X` site, not extra mathematical content. The decomposition is the right canonical skeleton.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: `SheafOfModules.IsQuasicoherent` / `QuasicoherentData` VERIFIED to exist (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`); the leansearch for a ready-made `ModuleCat R ≌ Qcoh(Spec R)` equivalence returned only the abstract predicate, confirming the strategy's claim that the full descent is genuinely absent in this framework (no phantom short-circuit).
- **Effort honesty**: reasonable.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND — see Alternative routes for one Mathlib-framework consideration that could cheapen it, but the chosen route is canonically correct.

### Route: GR (cells done; glue + quot + repr)

- **Goal-alignment**: PASS — terminates at `thm:grassmannian_representable`.
- **Mathematical soundness**: PASS — cocycle gluing (`Scheme.GlueData`), tautological rank-`d` quotient, functor-of-points ⟹ `RepresentableBy` via a strengthened `thm:relative_spec_univ` are the standard Nitsure §5 construction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none flagged; `Scheme.GlueData`/`Multicoequalizer` exist in Mathlib.
- **Effort honesty**: under-counted (mild) — GR-glue at `~120–320` LOC bundles "glued scheme → separated → **proper**." Properness of the Grassmannian is not a corollary of separatedness; it needs the valuative criterion or projectivity, which is substantial. Either properness is genuinely required downstream (then ~320 LOC is light and it deserves its own row) or it is not required by `thm:grassmannian_representable` (then drop it from the GR-glue cell). As written it reads as a free rider on a separatedness lemma.
- **Parallelism under-exploited**: no — GR-glue is self-contained with no keystone dependency.
- **Verdict**: SOUND — with the effort caveat that "→ separated → proper" understates the properness obligation.

## Format compliance

- **Size**: 127 lines / 13297 bytes — lines within budget; **bytes ~11% over** the ~12 KB budget (marginal).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order. (The `## References index` / `## Blueprint chapters` headings visible in the directive are the critic-protocol's appended context, NOT in the on-disk file.)
- **Per-iter narrative detected**: yes — pervasive in the `## Phases & estimations` Risks cells and the gap1 paragraph. Representative verbatim: `"keyed-rewriting CONCLUSIVELY DEAD vs X.Modules diamond (iter-029). iter-030 passed the step-(iii) distribution wall ... OVER_BUDGET 13× (entered iter-018); progress-critic FIRM iter-032 user-escalation if _legs not closed this round — do NOT re-date"`; `"iter-029/030 NO-OUTPUT root-caused ... fixed in iter-031 wording"`; `"step 1 ... DONE axiom-clean iter-030"`. Per-iter history belongs in `iter/iter-NNN/plan.md`, never in STRATEGY.md.
- **Accumulation detected**: no completed phase is stranded in the active table; `## Completed` is 6 rows (within bound). The accumulation problem here is *prose-history inside table cells*, not a stale row.
- **Table discipline**: FAIL — `## Phases & estimations` Risks cells are multi-line prose paragraphs (FBC-A, QUOT-defs, GR-glue each run 4–6 lines of narrative), violating "one short line per cell."
- **Format verdict**: NON-COMPLIANT — the per-iter narrative is the corrosive violation: it bleeds the planner's iter-by-iter momentum into the strategy document every cycle, which is exactly what the fresh-context discipline exists to prevent. Restructure in place this iter: strip all `iter-NNN` references and `OVER_BUDGET N×` / `STUCK (4 for 3 rounds)` / `do NOT re-date` editorializing from the table; move that history to `iter/iter-031/plan.md`; compress each Risks cell to one line.

## Alternative routes (suggested)

### Alternative: realize gap1 against the concrete `Mathlib.AlgebraicGeometry.Modules.Tilde` Spec development rather than the abstract `SheafOfModules`-over-a-site framework

- **What it looks like**: Mathlib's older `Spec`-side tilde development already proves the stalk-is-localization and section-over-basic-open facts for `M~` on `Spec R` concretely. If the QUOT predicates could consume gap1 through that concrete development (then bridge once to the `SheafOfModules` `IsQuasicoherent` packaging), the keystone descent (D) might be largely a re-export rather than a from-scratch sheaf-equalizer build.
- **Why it might be cheaper or sounder**: the project is currently building the section-localization descent inside the abstract `SheafOfModules R` over `J.over X` framework, where even *stating* the restriction to `D(f)` needs the `(C) overRestrictIso` slice-site bridge with `respectTransparency false` to tame synthInstance timeouts. The concrete `Spec` framework has the section-localization fact closer to the surface.
- **What the current strategy may have rejected**: likely the parent cone fixes the `SheafOfModules.IsQuasicoherent` encoding for relative sheaves over an arbitrary base (Quot/Grassmannian need it), so a one-time bridge from the concrete `Spec` tilde to the abstract framework may be unavoidable regardless — in which case this alternative only helps if that bridge is cheaper than the in-framework descent. Worth a half-iter scoping before committing the full in-framework (D).
- **Severity of the omission**: minor.

### Alternative: re-encode FBC-A as a `ModuleCat`-level natural iso transported once

- **What it looks like**: establish the natural iso of functors `ModuleCat R → ModuleCat R'` (restrict-then-basechange vs basechange-then-restrict — pure `TensorProduct` commutation, already essentially `regroupEquiv`) entirely in `ModuleCat`, then transport across the proved tilde dictionaries in a single `Iso` application, never letting the `X.Modules` instance diamond enter the proof term.
- **Why it might be cheaper or sounder**: it confines the diamond to one transport step instead of threading term-mode `congrArg` splices through "3 wrapper lemmas + assembly." The repeated failure of `rw`/`simp`/`erw` is the symptom of doing congruence *inside* the diamonded `X.Modules` category; doing it in plain `ModuleCat` sidesteps that.
- **What the current strategy may have rejected**: the strategy did push `regroupEquiv` to `ModuleCat` already, but apparently still glues it to the sheaf maps inside the diamonded category. The alternative is to defer all gluing to a single post-hoc transport.
- **Severity of the omission**: major — this is the difference between closing FBC-A and a 14th over-budget round.

## Sunk-cost flags

- `ACTIVE (final round)` + `Iters left: 1` on a row simultaneously labelled `OVER_BUDGET 13× (entered iter-018)` and `STUCK by sorry-count (4 for 3 rounds)` — Why this is sunk-cost: the estimate is set by how close the route *feels* ("one assembly splice") rather than by its realized non-convergence over many rounds; the residual lemma list has reportedly not shrunk the sorry count. Recommendation: re-estimate on the merits (an unchanged sorry count across 3 rounds is evidence the encoding, not the lemma list, is the blocker) and adopt the `ModuleCat`-transport re-encoding above instead of re-dating `1`.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`; requires `[Field F] [CharZero F]`, consistent with the strategy's `[CharZero]` note).
- `Module.flat_of_isLocalized_maximal`: VERIFIED (`Mathlib.RingTheory.Flat.Localization`).
- `SheafOfModules.IsQuasicoherent` / `SheafOfModules.QuasicoherentData`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`) — confirms gap1 lives in the abstract site framework and that no ready `ModuleCat R ≌ Qcoh(Spec R)` equivalence exists there to short-circuit it.

## Must-fix-this-iter

- Route FBC: CHALLENGE — the direct-on-sections mathematics is sound, but `Iters left: 1` on a 13× over-budget, sorry-flat-at-4 row is a dishonest estimate. Either adopt the `ModuleCat`-level transport re-encoding (confine the `X.Modules` diamond to one step) or re-estimate honestly and trigger the escalation; do not re-date `1` for a fourth round without an encoding change.
- Route QUOT: CHALLENGE (definitional soundness) — carry the **degree-1-generation / very-ample** hypothesis explicitly in `def:hilbert_polynomial` (the Stacks-00K1 rationality engine needs `S₊` generated in degree 1; ample-only is insufficient), and confirm the Open-Q1 canonicity decision is genuinely fenced (no S1 prover may run before `Φ_s` presentation-independence is settled).
- Format: NON-COMPLIANT — strip all per-iter narrative (`iter-NNN`, `OVER_BUDGET 13×`, `STUCK (4 for 3 rounds)`, `do NOT re-date`, `fixed in iter-031 wording`) from the Risks cells and gap1 paragraph; compress each Phases-table cell to one short line; move the history to `iter/iter-031/plan.md`. Trim ~1.3 KB to get back under the 12 KB budget.

## Overall verdict

The strategy is mathematically well-aligned with its canonical skeleton: the FBC affine lemma is the correct Stacks 02KH regrouping, generic flatness wraps a done axiom-clean algebraic core with the integral+quasi-compact hypotheses correctly flagged as required-else-false, and the gap1 keystone is decomposed along the genuinely canonical section-localization line (Stacks 01HA) with no phantom prerequisites — all four spot-checked Mathlib names VERIFIED. No infrastructure-deferral findings: every hard prerequisite (gap1, SheafOfModules tensor powers, rank-`r` local-freeness) is owned with a project-side sub-build rather than punted upstream, and parallelism across the independent QUOT/GF/GR leaves is exploited, not serialized. The two live concerns are (1) FBC-A, where sound mathematics is trapped in a sunk-cost Lean encoding — `Iters left: 1` is not credible against a 13× over-budget, sorry-flat-at-4 history, and a `ModuleCat`-level transport re-encoding should replace the in-diamond term-mode splicing; and (2) the `def:hilbert_polynomial` definition, which must carry the degree-1-generation hypothesis its rationality engine requires and keep the Open-Q1 canonicity decision fenced ahead of any S1 prover. Finally, the document is NON-COMPLIANT on format: pervasive per-iter narrative in the Phases table bleeds planner momentum into the strategy every cycle and must be restructured in place this iter.
