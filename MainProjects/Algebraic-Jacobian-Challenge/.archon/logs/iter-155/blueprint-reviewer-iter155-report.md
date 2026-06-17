# Blueprint Review Report

## Slug
iter155

## Iteration
155

## Top-level summaries

### Incomplete parts
- `RigidityKbar.tex` / `thm:rigidity_over_kbar` (T2, the M2.a keystone — active prover target): the proof decomposition (§"Proof decomposition", C.2.b–C.2.e) **does not establish `df = 0`** for the morphism `f : C → A`, and does not wire the chart-algebra piece (ii) declarations (`ext_of_diff_zero` / `df_zero_factors_through_constant_on_chart`) into the rigidity body at all. C.2.c defers the substantive (1-dimensional image) case to C.2.d, and C.2.d says verbatim "Both routes require Mathlib infrastructure not currently present." There is no present-material path from the hypotheses to the `df = 0` (equivalently `df = dg`) input that `ext_of_diff_zero` consumes. **T2 is NOT prover-ready** (see the dedicated note below).
- `RigidityKbar.tex` / `lem:Scheme_Over_ext_of_diff_zero` (T1, active prover target — the substantive β-chain refinement): the Steps 1–3 recipe has two load-bearing hand-waves and one stale-helper invocation; the substantive refinement is **NOT prover-ready** (the current Lean decl compiles only as a thin `ext_of_eqOnOpen` wrapper). Details below.
- `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart`: the blueprint states a rich 5-step theorem (chart pair `(W,V)`, `f`, `A`, `df = 0`, two-chart Čech) but the **actual Lean signature is a one-line delegate to KDM** taking only `(k, C-typeclasses, B, b, hDb : D b = 0)`. The 5-step proof is explicitly aspirational ("Iter-149+ refinement plan"). A prover sent to the substantive form is formalizing against a signature the present decl does not have.

### Proofs lacking detail
- `RigidityKbar.tex` / `lem:Scheme_Over_ext_of_diff_zero`, Step 1: "the K\"ahler-derivation additivity ... lifted to the scheme level via the same functorial chain used in `lem:GrpObj_mulRight_globalises`" — `mulRight_globalises_cotangent` was **EXCISED from the Lean tree iter-145** (confirmed `GrpObj.lean:624` "iter-145 EXCISE"; the blueprint block `lem:GrpObj_mulRight_globalises` is `\notready`). The load-bearing scheme-level Kähler-additivity lift therefore points at a deleted declaration with no present replacement named.
- `RigidityKbar.tex` / `lem:Scheme_Over_ext_of_diff_zero`, Step 2: the chart-by-chart sheaf-assembly globalisation is hand-waved — "such chart pairs exist by quasi-compactness ... chart-uniform existence is automatic from the smoothness of `A.hom`", and "Assembling chart-by-chart via sheaf compatibility, the scheme-morphism `h` factors through `Spec k` globally" name no lemma for the per-chart `B → k → R` ⟹ global-factor-through-`Spec k` step.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`, C.2.c (image-dimension dichotomy): "the set-theoretic image is an irreducible closed subset (continuous image of an irreducible space under a proper map) of dimension at most 1" names **no Mathlib infrastructure** for (i) image-of-proper-map-is-closed, (ii) irreducibility of the image, (iii) scheme dimension, or (iv) the dimension dichotomy. These are prose hand-waves; the prover has nothing to instantiate.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter; lists closed piece (i.a) trio + orphan iter-134–136 helpers, all `iter-146+ cleanup candidates`. No inbound-cref hazard.)

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pointer chapter for the DESCOPED (S3.*) sub-claims. **Safe to delete/demote** (focus area 2): its only labels — `chap:cotangent-chartalgebra-s3` and `sec:chartalgebras3-source-citations` — have **zero inbound `\cref`/`\uses` from any other chapter** (grep across all 12 chapters returns only the definitions themselves). The four (S3.*) lemma labels it discusses are defined in `RigidityKbar.tex`, not here, so no cref cascade breaks on deletion.
  - Citation discipline is clean: all `% SOURCE:` parentheticals name bundled files that exist (`references/stacks-varieties.tex`, `stacks-coherent.tex`, `stacks-fields.tex`); quotes are verbatim Stacks (original notation/language).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.
(57 declaration blocks, all `\leanok`; no `\notready`/sorry. `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`, cited by RigidityKbar Step 3, resolves here at L525.)

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
(47 declaration blocks, all `\leanok`.)

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
(`thm:smooth_locally_free_omega` — consumed by KDM/piece-(i) chart route — is fully step-wise backed with named, [verified] Mathlib lemmas; converse honestly documented as out-of-scope with explicit counterexample.)

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
(`thm:GrpObj_eq_of_eqOnOpen` / `ext_of_eqOnOpen` — the C.2.b reduction target — is well-supported with three named derived instances and the `ext_of_isDominant_of_isSeparated'` closure.)

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The deferred foundational gap `thm:nonempty_jacobianWitness` (Routes A/B/C) is thorough and honestly flagged. The genus-0 arm `def:genusZeroWitness` routes through `thm:rigidity_over_kbar` over `k̄` then descends via `Flat.epi_of_flat_of_surjective`; the descent step (C.2.f) is concrete and well-named.
  - **Observation (feeds the cross-chapter note below):** Jacobian.tex C.2.d's *cotangent route* is the only place the blueprint articulates HOW `df = 0` arises — via `Ω_{A/k̄}` triviality + `H⁰(P¹, Ω) = H⁰(O(−2)) = 0`. Both are explicitly Mathlib gaps there; the chart-algebra pivot in RigidityKbar.tex descoped the global `Ω_A`-triviality input (piece (i) `omega_free`) without replacing the `df = 0` *source*. See cross-chapter note.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **T2 `thm:rigidity_over_kbar` not prover-ready — `df = 0` is not supplied from present material (directive's central question, answered explicitly):** classically the 1-dim-image case is ruled out by `df = 0`, which requires `Ω_{A/k̄}` global triviality (piece (i) `omega_free`/`omega_rank_eq_dim` — **DESCOPED iter-144**, see §"Iter-144 chart-algebra pivot") plus `H⁰(C, Ω_{C/k}) = 0`. The chart-algebra piece (ii) supplies only the *converse-style* implication "`df = 0` ⟹ factors through `Spec k`" (`df_zero_factors`, `ext_of_diff_zero`); it never produces `df = 0` itself. Per-chart standard-smooth freeness of `Ω_{B/k}` (B a chart of A) is local freeness, NOT the translation-invariant global triviality needed to identify `f*Ω_A ≅ O_C^g` and reduce `df` to global sections of `Ω_C`. The proof decomposition (C.2.b–C.2.e) does not bridge this and does not wire `ext_of_diff_zero` into the rigidity body. **A prover sent at the `sorry` body of `rigidity_over_kbar` has no present path.**
  - **T1 `lem:Scheme_Over_ext_of_diff_zero` substantive refinement not prover-ready:** (a) Step 1's scheme-level Kähler-additivity lift cites the **deleted** `lem:GrpObj_mulRight_globalises` (`mulRight_globalises_cotangent` excised `GrpObj.lean:624`); (b) Step 2's chart-by-chart globalisation is hand-waved with no named lemma; (c) Step 2 invokes `df_zero_factors_through_constant_on_chart` "consuming the global Step 3 of its proof here", but that helper's **actual Lean signature** is a thin KDM wrapper that takes neither `f`, `A`, `df = 0`, nor chart pairs and does no Čech globalisation. The current Lean `ext_of_diff_zero` compiles only as a thin `ext_of_eqOnOpen` renaming (no `df` used), so the blueprint *statement* (df=dg + genus-0 + group-scheme hyps, L2521–2529) also diverges from the Lean signature (eqOnOpen-direct, `IsSeparated`+`IsReduced`+`GeometricallyIrreducible`).
  - **C.2.c image-dimension dichotomy names no Mathlib infrastructure** (image-of-proper-map closed/irreducible, scheme dimension, dichotomy) — prose hand-wave (directive's explicit ask: confirmed not named/present).
  - KDM (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`) and `lem:constants_integral_over_base_field` are CLOSED and axiom-clean per directive — NOT re-audited. The live (FT.1)–(FT.3) route prose for KDM is exemplary (every lemma named + [verified]).
  - Off-path `\notready` blocks (piece (i.b) bundled-route: base-change-of-differentials helpers, inverse-direction derivation/morphism, `omega_free`/`omega_rank_eq_dim`) are intentionally parked under the iter-144 descope; not a defect, but they are the bulk of the chapter's `partial` content.
  - **`% archon:covers` is absent project-wide** (see cross-chapter note): `ChartAlgebra.lean` (which holds the active targets KDM/constants/`df_zero_factors`/`ext_of_diff_zero`) maps by 1:1 slug to a nonexistent `AlgebraicJacobian_Cotangent_ChartAlgebra.tex`; its blueprint content actually lives in this chapter. The HARD-GATE mapping for those files is implicit, not declared.

## Cross-chapter notes

- **The `df = 0` sourcing gap is shared between `Jacobian.tex` (C.2.d) and `RigidityKbar.tex`.** Jacobian.tex C.2.d is the only articulation of how `df = 0` is obtained (Ω_A triviality + `H⁰(C,Ω)=0`), and flags both as Mathlib gaps. RigidityKbar.tex's chart-algebra route descoped the global Ω_A-triviality piece (i) and built only "`df = 0` ⟹ constant" (piece (ii)). Net effect across the two chapters: the keystone input `df = 0` for `rigidity_over_kbar` is produced by **neither** chapter from present material. Whichever chapter hosts the fix, the assembly that yields `df = 0` (or an alternative keystone avoiding it) must be written before T2 is prover-dispatchable.
- **`% archon:covers` markers are absent in every chapter** (grep returns no matches). The directive's Routes treat `RigidityKbar.tex` as the consolidated backing for both `RigidityKbar.lean` and `ChartAlgebra.lean`, but no chapter declares `% archon:covers ... ChartAlgebra.lean ...`. Recommend the plan agent treat `RigidityKbar.tex` as the gating chapter C for both `.lean` files this iter (it is, regardless), and consider asking a writer to add the `% archon:covers` line so the HARD-GATE file→chapter map is explicit rather than convention-derived. (`blueprint-doctor` would otherwise flag `ChartAlgebra.lean` as orphaned.)
- Stale `\uses{}` at the KDM **statement** block (L2340: `lem:chart_algebra_isPushout_of_affine_product` + `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`) — both point at real labels (not broken), but the live (FT) route consumes neither; the proof block's `\uses` was pruned iter-154 while the statement block's was not. **Known issue per directive** (writer prune queued SOON); not re-classified as broken-uses.

## Strategy-modifying findings (if any)

- `RigidityKbar.tex` / `thm:rigidity_over_kbar` vs the iter-144 chart-algebra pivot scoping: the pivot descoped the **global** group-scheme cotangent-triviality input (piece (i) `omega_free`) and replaced it with per-chart standard-smooth Ω freeness, while building piece (ii) as "`df = 0` ⟹ constant". As scoped, the chart-algebra pile **cannot close `rigidity_over_kbar`**, because nothing produces the `df = 0` premise that piece (ii) consumes (per-chart local freeness ≠ global `f*Ω_A ≅ O_C^g`). The plan agent must decide one of: (a) re-activate a minimal global/translation-invariant `Ω_A`-triviality statement + an explicit `H⁰(C, Ω_{C/k}) = 0` chart-Čech computation to manufacture `df = 0`, wiring it into the `rigidity_over_kbar` body; (b) adopt the dual-abelian-variety keystone route instead; or (c) explicitly record `rigidity_over_kbar` as gated/not-prover-ready and keep T2 off the prover queue. This is a scoping decision above a single-chapter rewrite, hence flagged here. (The blueprint already honestly states C.2.d "requires Mathlib infrastructure not currently present", so this is an acknowledged gap being surfaced for a scoping call, not a hidden contradiction.)

## Severity summary

- **must-fix-this-iter:**
  - `RigidityKbar.tex` is `complete: partial` AND `correct: partial`, and it is the gating chapter C for both active prover targets `RigidityKbar.lean::rigidity_over_kbar` (T2) and `ChartAlgebra.lean::ext_of_diff_zero` (T1, substantive form). Per the HARD GATE, **both T1 and T2 must be DROPPED from this iter's objectives** and a blueprint-writing subagent dispatched against `RigidityKbar.tex` targeting: (1) the missing `df = 0` assembly / keystone wiring for `rigidity_over_kbar` (C.2.c + C.2.d); (2) Step 1's deleted-`mulRight_globalises` citation and Step 2's hand-waved globalisation in `ext_of_diff_zero`; (3) the statement-vs-Lean signature divergence on `ext_of_diff_zero` and `df_zero_factors_through_constant_on_chart`.
  - The Strategy-modifying finding above is non-empty → a STRATEGY.md scoping decision on the `df = 0` source should precede the writer round (or be folded into the writer directive).
- **soon:**
  - `% archon:covers` markers absent project-wide; add one on `RigidityKbar.tex` for `ChartAlgebra.lean` to make the gate mapping explicit.
  - `thm:rigidity_over_kbar` carries `% SOURCE:` Mumford (II §4) with **no `% SOURCE QUOTE:`** (honestly disclosed as paywalled/not bundled). Normally a must-fix for an active prover route, but T2 is being deferred for the more fundamental `df = 0` reason, so this is moot this iter; resolve (retrieve Mumford or accept the disclosure) before T2 is eventually dispatched.
  - Stale KDM statement-block `\uses{}` (L2340) prune — known.
  - `ChartAlgebraS3.tex` deletion / `GrpObj.tex` orphan-helper cleanup are safe whenever the plan wants them (no cref cascade).

Overall verdict: 11 of 12 chapters clear (complete+correct); `RigidityKbar.tex` is `partial/partial` and gates both active prover targets — neither T1 (substantive `ext_of_diff_zero` refinement) nor T2 (`rigidity_over_kbar` body) is prover-ready this iter, the decisive blocker being that no present material supplies the `df = 0` keystone input.
