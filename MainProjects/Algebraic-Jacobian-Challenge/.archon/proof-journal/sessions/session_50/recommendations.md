# Recommendations for the next plan-agent iteration (iter-051)

## Comparison-iso typeclass carrier closed iter-050

**Instance-driven Čech-vs-derived comparison machinery is now in place.** Iter-050 landed four new declarations in `Cohomology/MayerVietoris.lean` `section CoverTotality` (single combined Edit, zero corrective):

1. `class HasCechToHModuleIso F 𝒰 : Prop` (L1094) — `Nonempty`-wrapped carrier capturing the existence of `∀ n, cechCohomology n ≃ₗ[k] HModule' n (⨆ 𝒰)`.
2. `noncomputable def cechToHModuleIso` (L1110) — `Classical.choice`-based extractor on the class field; auto-fires on the `[HasCechToHModuleIso F 𝒰]` instance argument.
3. `theorem subsingleton_HModule_of_hasCechToHModuleIso_top` (L1134) — instance-driven consumer chaining iter-049's `subsingleton_HModule_of_isCechAcyclicCover_top` with the iter-050 extractor.
4. `theorem subsingleton_HModule_of_hasCechToHModuleIso_top_curve` (L1152) — curve specialisation at `F := toModuleKSheaf C` with `(𝒰 := 𝒰)` cover lock-in.

Sorry trajectory `9 → 9`. LOC `1077 → 1165` (+88, vs `+30–50` plan estimate band — overage primarily from multi-paragraph design-rationale docstrings). Kernel-only axioms `[propext, Classical.choice, Quot.sound]` on `cechToHModuleIso`, `subsingleton_HModule_of_hasCechToHModuleIso_top`, `subsingleton_HModule_of_hasCechToHModuleIso_top_curve` (the class itself has no body that expands axioms; no `lean_verify` needed). `Classical.choice` was already in the kernel-only set since iter-048; **no new axiom introduced by iter-050**.

**Substantive depth still ahead.** The `IsAffineHModuleVanishing k C (toModuleKSheaf C)` producer chain now stands at:
- iter-047 (foundational Čech infra; closed)
- iter-048 (Čech-side acyclicity carrier + consumer; closed)
- iter-049 (top-supremum HModule transport bridge; closed)
- **iter-050 (comparison-iso typeclass carrier + instance-driven consumers; closed this pass)**
- iter-051+ (Čech-vs-derived comparison theorem — substantive)
- iter-052+ (Čech-side acyclicity *producer* instances for affine basic-open covers — substantive multi-iteration)
- iter-053 (final `IsAffineHModuleVanishing` producer chaining iter-051+/052+ via iter-049's bridge / iter-050's instance-driven consumer / iter-040's class field)

Phase A iterations-remaining held at ~4 (renumbering from prior estimate of ~5: the comparison theorem moves from iter-050 placeholder to iter-051+; the substantive multi-iteration is unchanged).

## Highest-priority track for iter-051

### Track 2A.3 (recommended primary, iter-051 prover lane): the substantive Čech-vs-derived comparison theorem

This is the data argument that **gets wrapped via `⟨⟨the_iso⟩⟩`** into a `HasCechToHModuleIso F 𝒰` instance. Iter-050's design lets the comparison theorem land on its own without re-touching iter-048/049/050.

Construct, as a *theorem* (not a class field), the comparison
```
Scheme.cechCohomology_LinearEquiv_HModule' :
  ∀ (n : ℕ), Scheme.cechCohomology C F 𝒰 n ≃ₗ[k]
                Scheme.HModule' k F n (⨆ i, 𝒰 i)
```
under appropriate hypotheses (acyclicity of the cover, sheaf condition on `F`).

**Plan-agent probe mandate for iter-051**:
1. Search Mathlib for `Cech.toCohomology` / `cechToDerived` / `Cech.isIsoCohomology` / similar — confirm not present at the iter-047/048/049/050 level of generality (over arbitrary `Sheaf J (ModuleCat k)`).
2. Construction strategy options:
   - **(i)** Build via the standard augmentation `F → Č(𝒰, F)` cochain, then take cohomology and identify the result with `HModule'` via the standard derived-functor / Čech-cohomology comparison (the spectral-sequence-collapses-on-acyclic-covers argument).
   - **(ii)** Direct natural-transformation construction via Mathlib's `cechComplexFunctor` augmentation API + the iter-026 short-exact / Mayer–Vietoris machinery for the `n+1`-th step.
3. Probe the chosen body via `lean_run_code` end-to-end before proposing.

**Plausible iter-051 outcomes**:
- **Single-iteration close (~50–100 LOC)** if the augmentation-and-take-homology approach drops in cleanly via existing Mathlib `cechComplexFunctor` API.
- **2-iteration close (~150–250 LOC)** if a project-local naturality lemma or short-exact bridge is needed.
- **3+-iteration close** if the comparison must be built from manual derived-functor unfolding.

Once iter-051 lands the comparison theorem, the iter-051b iteration registers a `HasCechToHModuleIso` instance via `⟨⟨theComparisonTheorem⟩⟩` (one-line) and downstream producers fire automatically.

### Track 2A.4 (queued, iter-052+): `IsCechAcyclicCover` producers for affine basic-open covers

Substantive multi-iteration: produce `IsCechAcyclicCover` instances for basic-open covers of affine schemes by way of Serre's classical computation (the alternating-sum complex of localisations is exact in positive degrees). Mathlib probe required for any pre-existing `Cech.cohomology_basic_open_cover_acyclic`-style theorem; if absent, project-local construction. Likely ~150+ LOC over 2–3 iterations.

### Track 2A.5 (queued, iter-053): the final `IsAffineHModuleVanishing` producer

Chain Track 2A.4 with iter-049's bridge and iter-050's `_curve` consumer to close the H${}^{>0}$ side of the genus-`Module.Finite` ladder.

## Track 2B (alternative warm-up, iter-051 prover lane): finrank corollary of iter-046 producer

A `Module.finrank`-flavoured restatement of iter-046's `instIsHModuleHomFinite_toModuleKSheaf` giving an explicit identity `Module.finrank k (HModule k (toModuleKSheaf C) 0) = Module.finrank k Γ(C, 𝒪_C)`. Plausibly single-iteration ~30–50 LOC. Remains a low-risk warm-up option if iter-051 plan-agent prefers a smaller-surface deliverable.

## Track 2C (alternative, iter-051 prover lane): sharper Mayer–Vietoris LES consumer

Combine iter-029 LES + iter-035 → iter-039 transports + iter-040 + iter-041 + iter-042 + iter-043 consumers + iter-044 Stein input + iter-045 LinearEquiv + iter-046 producer instance into a four-term LES on `HModule k F (n+1)` for the curve case. Plausibly single-iteration ~30–50 LOC.

## Track 2D (off-Archon side track): Mathlib upstream PRs

The five new `CategoryTheory.*` declarations from iter-046 remain pure Mathlib gap-fills. Recommendation unchanged: open Mathlib upstream PRs to merge into `Mathlib/CategoryTheory/Adjunction/Additive.lean` or sibling `Linear.lean`.

## Process discipline notes (iter-050 retro)

### REGRESSION — blueprint-subsection / `\leanok`-pre-mark discipline broke this iteration

For five iterations in a row (iter-045 → iter-049), the plan-agent pre-marked the new declarations' blueprint blocks with `\leanok` on both statement and proof, and the review agent only validated. **Iter-050 broke this streak.** The plan-agent updated `blueprint/lean_decls` (4 entries appended L114–L117 — clear-as-you-go discipline holds) and amended the retrospective paragraph at L1085 to reference four new labels (`def:Scheme_cechToHModuleIso`, `thm:Scheme_subsingleton_HModule_of_hasCechToHModuleIso_top`, `thm:Scheme_subsingleton_HModule_of_hasCechToHModuleIso_top_curve`), **but did not author the `\subsection{Comparison-iso typeclass carrier (iter-050)}` block holding the `\begin{definition}` / `\begin{theorem}` blocks for those labels**.

The review agent flagged this with a `% NOTE:` at L1083 of `Cohomology_MayerVietoris.tex`. **Iter-051 plan-agent should**:

1. **Author the missing iter-050 subsection** in `Cohomology_MayerVietoris.tex` between the `\subsection{Top-supremum HModule transport (iter-049)}` block (L1051–L1081) and the `\subsection{Use in Serre finiteness}` block (L1083). The subsection should have four blocks (matching the four iter-050 declarations):
   - `\begin{definition}\leanok` for `HasCechToHModuleIso` (label `def:Scheme_HasCechToHModuleIso`, `\lean{AlgebraicGeometry.Scheme.HasCechToHModuleIso}`).
   - `\begin{definition}\leanok` for `cechToHModuleIso` (label `def:Scheme_cechToHModuleIso`, `\lean{AlgebraicGeometry.Scheme.cechToHModuleIso}`) + `\begin{proof}\leanok` (extractor body trivially typechecks).
   - `\begin{theorem}\leanok` for `subsingleton_HModule_of_hasCechToHModuleIso_top` (label `thm:Scheme_subsingleton_HModule_of_hasCechToHModuleIso_top`, `\lean{...}`) + `\begin{proof}\leanok`.
   - `\begin{theorem}\leanok` for `subsingleton_HModule_of_hasCechToHModuleIso_top_curve` (label `thm:Scheme_subsingleton_HModule_of_hasCechToHModuleIso_top_curve`, `\lean{...}`) + `\begin{proof}\leanok`.
2. After iter-051's plan-agent authors the subsection (which must happen *before* the iter-051 prover stage runs), the `\ref{...}` references in the L1085 retrospective paragraph will resolve cleanly.
3. Resume the pre-mark discipline going forward.

### Holding disciplines (iter-040 → iter-050)

- **`blueprint/lean_decls` clear-as-you-go discipline holds for the eleventh iteration in a row** (iter-040 → iter-050). Iter-050 plan-agent appended 4 entries (L114–L117), bringing the project total to 119. Continue.
- **Verbatim probe-confirmed body, single combined Edit** — 13 of 16 iterations zero-corrective (iter-035 → iter-050). **Iter-050 = fourth zero-corrective Edit in a row** (iter-047 → iter-048 → iter-049 → iter-050). Continue.
- **`archon-protected.yaml` untouched** for the eleventh iteration in a row. Continue.
- **Single combined Edit for multi-declaration packaging holds** — iter-050 confirms scaling on a heterogeneous quadruple-declaration (`class` + `noncomputable def` + `theorem` + `theorem`) cohort.
- **Cross-file consumer chain landing in a single iteration** — iter-050's bodies all reach across to iter-048's class (in `StructureSheafModuleK.lean`) and iter-049's consumer (also in `MayerVietoris.lean`); no import gymnastics needed.

### LOC overage trend (iter-047 → iter-050)

- iter-047: +54 LOC (vs +30–50 band)
- iter-048: +66 LOC
- iter-049: +53 LOC
- iter-050: +88 LOC ← biggest overage so far

All overages are docstring-driven (multi-paragraph design rationales copied verbatim from PROGRESS.md). Tolerable, since the docstrings carry load-bearing design context. **Plan-agent should consider widening the LOC band to `+50–100` for docstring-heavy iterations going forward** (iter-049 retro recommended `+50–80`; iter-050's +88 suggests the upper bound should be lifted further).

## Targets blocked — do NOT assign in iter-051

- All 8 protected sorries (5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`) — gated on Phase C step 4 (FGA representability), `LineBundle` Mathlib refinement, and `noncomputable` user-decisions. **Plan-agent should NOT assign these.**
- `PicardFunctor.representable` — intentionally deferred. **Plan-agent should NOT assign.**
- All closed scaffold sites in `Cohomology/MayerVietoris.lean` and `Cohomology/StructureSheafModuleK.lean` (iter-006 → iter-050).
- **Folding iter-050's `HasCechToHModuleIso` field type from `Nonempty (∀ n, ...)` to a non-`Nonempty`-wrapped form** — would force a `Type`-valued field on a `Prop`-valued class (forbidden) and break typeclass synthesis. Known dead-end.
- **Promoting iter-050's `cechToHModuleIso` from `noncomputable def` to `def`** — `Classical.choice` is non-constructive, so the `noncomputable` modifier is mandatory. Known dead-end.
- **Promoting iter-050's two `_top` consumers from `theorem` to `instance`** — typeclass synthesis cannot supply the explicit `h` / `hn` arguments at call sites. Known dead-end (mirrors iter-049's known dead-end for the explicit-`compIso` form).

## Reusable proof patterns from iter-050 (for iter-051+ planning)

1. **`Nonempty`-wrapped data field for `Prop`-valued carrier classes** — when the substantive content of a class is a `Type`-valued datum, the `Prop`-valued class can still hold it by wrapping the field in `Nonempty`. Reusable wherever a `Prop`-valued class needs to register the existence of a `Type`-valued construction.
2. **`Classical.choice`-based extractor + auto-firing on instance argument** — a `noncomputable def` whose body is `Classical.choice <ClassName>.<field>` recovers the data behind a `Nonempty`-wrapped class field. The extractor takes only the class as an instance argument; downstream consumer call sites consume the data transparently via typeclass synthesis. `Classical.choice` is already in the project's kernel-only axiom set.
3. **Instance-driven design for substantive comparison machinery** — register the data behind a `Prop`-valued class, supply a `noncomputable def` extractor, write the consumer to take only the class instance. At producer call sites, no explicit data argument needs to be passed. Generalises iter-046's `IsHModuleHomFinite` instance-driven design.
4. **Class + extractor + theorem + `_curve` quadruple-declaration package** — when an instance-driven design lands, the natural cohort is `class IsX … : Prop` + `noncomputable def x_extract` + `theorem consumer_of_isX` + `theorem consumer_of_isX_curve`, all in a single combined Edit.

## Summary

Iter-050 closed the **Čech-vs-derived comparison-iso typeclass carrier + instance-driven consumers**, decoupled cleanly from the substantive iter-051+ comparison theorem via the `Nonempty`-wrapped class field design. **Iter-051 should attack the substantive Čech-vs-derived comparison theorem** as the next genuinely substantive step, with Track 2B (finrank corollary) as the low-risk warm-up alternative. The plan-agent must **also author the missing iter-050 blueprint subsection** in `Cohomology_MayerVietoris.tex` so that the four `\ref{...}` references in the L1085 retrospective paragraph resolve cleanly.
