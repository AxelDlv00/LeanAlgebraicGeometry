# Blueprint Writer Report

## Slug
ftthree-route

## Status
COMPLETE — the KDM proof block now presents the iter-154 verified single-element /
perfect-field / Jacobi–Zariski `H1Cotangent` route (FT.1)–(FT.3) as its live,
primary, physically-first content; the transcendence-basis sketch, the (C.a)–(C.c)
polynomial-ring helpers, and the (p1)/(p2) explorations are demoted to a clearly
marked auditable historical record off the critical path.

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made
- **Revised** intro of the KDM proof block (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`)
  — replaced the iter-152 "Corrected argument" paragraph (which framed (C.a)–(C.c)
  as "valid and reusable") with a "Live route (iter-154, verified Mathlib assembly)"
  lead paragraph: reverse inclusion = `Derivation.map_algebraMap`; forward direction =
  the (FT.1)–(FT.3) route; states the route is a self-contained Mathlib assembly verified
  by compilation, explicitly *overturns* the iter-149–153 "Mathlib gap / bright-line STOP"
  verdict, and flags (C.a)–(C.c)/(p1)/(p2) as historical-only. Notes only `[IsDomain B]`
  + `[FiniteType k B]` are actually consumed.
- **Rewrote** the (FT.1)–(FT.3) itemized list into the verified three-step single-element
  route, each step naming its `[verified]` Mathlib lemma:
  - (FT.1) push to `K = Frac B` via `IsFractionRing` + `KaehlerDifferential.map_D` (`_hFunct`);
  - (FT.2) contradiction route: transcendence ⇒ `IsFractionRing.lift` embeds `F := RatFunc k`;
    `PerfectField.ofCharZero` + `EssFiniteType.comp`/`.of_comp` ⇒ `FormallySmooth.of_perfectField`
    ⇒ `instSubsingletonH1CotangentOfFormallySmooth` ⇒ `H1Cotangent.exact_δ_mapBaseChange`
    gives `mapBaseChange` injective; `mapBaseChange_tmul`+`map_D`+`one_smul` then
    `FaithfullyFlat.one_tmul_eq_zero_iff` ⇒ `D_F b = 0`, contradicting (FT.3);
  - (FT.3) base case `D_{Frac(k[X])} X ≠ 0` (`FormallyEtale.of_isLocalization` +
    `isLocalizedModule_map` + `IsLocalizedModule.eq_zero_iff` + `polynomialEquiv_D` +
    `nonZeroDivisors.coe_ne_zero`); closer via `adjoin.finiteDimensional` +
    `IsIntegral.of_finite` + `IsAlgClosed.algebraMap_bijective_of_isIntegral`.
  - Mathematical spine taken from the 8 verified `example` blocks in
    `analogies/ftthree-kernel-iter154.md`; translated to project notation, no Lean tactic syntax.
- **Replaced** the `% NOTE (iter-152, residual content)` block (abandoned
  separating-transcendence-basis assembly) with a `% NOTE (iter-154, live route)`
  recording (a) the route compiles end-to-end, (b) the transcendence-basis route is
  DISCARDED (no `IsTranscendenceBasis`-keyed freeness-of-Ω lemma in Mathlib), (c) the
  `_mvPoly_*` (C.a)–(C.c) helpers are now DEAD code.
- **Reordered + demoted** the (C.a)–(C.c) polynomial-ring layer: physically moved it to
  *below* the (FT) list under a "--- Historical record (NOT on the critical path …) ---"
  heading, reframed its header to "Superseded polynomial-ring layer (C.a)–(C.c) — DEAD code",
  and tagged each sub-step "(now DEAD)". Technical content preserved verbatim for auditability.
- **Revised** the (p2) and (p1) superseded-path headers — replaced the stale
  "live route (C)/(BR.5′)" pointers with "the live single-element / `H^1`-cotangent
  (FT.1)–(FT.3) route above" and added "off the critical path" framing.
- **Revised** the "Closure end state and ordering" paragraph — live proof is now stated as
  the (FT.1)–(FT.3) self-contained Mathlib assembly; all three of (C.a)–(C.c)/(p1)/(p2)
  marked provenance-only; corrected the residual-content claim (only the ~20 LOC base case
  is genuinely new; no Archon theory gap remains).
- **Revised** the "Signature-vs-proof reconciliation" paragraph — relabeled as
  "historical, pertains to the demoted (p1)/(p2) records" and noted the live (FT) route
  carries no chart-of-proper-curve hidden dependency.
- **Added** an `\emph{Mathlib status (live route)}` paragraph enumerating every `[verified]`
  live-route Mathlib lemma with its module path (sourced from the analogist citation table);
  renamed the pre-existing status paragraph to "(historical (p1)/(p2) records)".
- **Pruned** the proof-block `\uses{...}` (was
  `lem:chart_algebra_isPushout_of_affine_product, lem:KaehlerDifferential_constants_in_chart_of_proper_curve`)
  — replaced with an explanatory `% iter-154` comment: the live route is a self-contained
  Mathlib assembly depending on no blueprint label; the two `\cref`s to those labels now
  survive only inside the demoted historical records (a `\cref` creates no `\uses` edge).

## Cross-references introduced
- No new `\uses{...}` edges (the live route is a self-contained Mathlib assembly).
- Kept an informational `\cref{lem:constants_integral_over_base_field}` in the (FT.3) closer
  ("the same Mathlib lemma the project already invokes") — that label exists in this chapter
  (verified). This is an informational cross-reference, not a dependency.
- The demoted (p1.f) record still `\cref`s `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  and (p1)/Mathlib-status `\cref`s `lem:chart_algebra_isPushout_of_affine_product`; both labels
  exist; no `\uses` edge is created from the demoted prose.

## References consulted
- `analogies/ftthree-kernel-iter154.md` — the verified route, the 8 compiling `example`
  blocks, and the full Mathlib citation table (module paths). This is the source of truth
  for the live (FT.1)–(FT.3) rewrite and the live-route Mathlib-status enumeration.
- (No external-literature reference files were opened: the live route is an Archon-original
  Mathlib assembly, so per the directive NO `% SOURCE QUOTE:` blocks were invented for it.
  The pre-existing Stacks Tag 00T7 quote backing the historical (p1) standard-smooth⇒Ω-free
  citation was left untouched.)

## Macros needed (if any)
- None. All commands used (`\xrightarrow`, `\otimes`, `\hookrightarrow`, `\operatorname`,
  `\medskip`, `\noindent`) are already used elsewhere in this chapter (verified via grep).

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **Statement-block `\uses` (line ~2335) still points at dead machinery.** The KDM
  *theorem statement* block carries
  `\uses{lem:chart_algebra_isPushout_of_affine_product, lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`.
  Directive item 4 scoped the `\uses` task to the *proof block*, which I pruned; I left the
  statement-block `\uses` untouched to avoid touching the statement and to avoid
  orphaning those lemmas in the dependency graph without your sign-off. If you want the
  graph to reflect the self-contained live route, prune the statement-block `\uses` too —
  but first confirm whether `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  has any other live `\uses` consumer (it may be orphaned by the pruning, since its only
  remaining references in this chapter are `\cref`s inside the demoted (p1.f) record).
- **Dead Lean code to remove.** The analogist + this rewrite both flag the `_mvPoly_*`
  private helpers (`_mvPoly_coeff_pderiv_at_shifted`, `_mvPoly_mem_range_C_of_pderiv_eq_zero`,
  `_mvPoly_mem_range_C_of_D_eq_zero`) in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
  as DEAD under the live route. The `_hFunct` reduction (map_D functoriality) is still
  reused by (FT.1) and should be kept. A doctor/cleanup pass should confirm before deletion.
- **`ChartAlgebraS3.lean` orphan** (per MEMORY) is unrelated to this chapter and untouched.

## Strategy-modifying findings
- None. The rewrite reflects the analogist's verified route, which *resolves* (rather than
  changes) the strategy: the iter-149–153 "Mathlib gap / bright-line STOP" on FT.3 is
  overturned, and the KDM signature/hypotheses are unchanged. The prover can now formalize
  the recipe directly. (If STRATEGY.md still records the FT.3 bright-line as active, it
  should be updated to reflect the lift — but that is a STRATEGY.md edit, not a chapter
  content change, so I flag rather than act.)
