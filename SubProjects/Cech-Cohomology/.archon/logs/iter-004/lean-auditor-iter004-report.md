# Lean Audit Report

## Slug
iter004

## Iteration
004

## Scope
- files audited: 1 (per directive — `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`)
- files skipped (per directive): all other `.lean` files — directive scoped to this file only

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged (minor, style-level)
- **excuse-comments**: 0 flagged
- **notes**:
  - **[CLEAR]** All 5 new declarations are sorry-free and axiom-clean (only `propext`, `Classical.choice`, `Quot.sound` — confirmed via `lean_verify` on each).
  - **[CLEAR]** No build errors. Two Lean style-linter warnings for long lines at lines 322 and 346 (both inside the `/-! -/` strategy comment block, not in code).
  - **[CLEAR]** `[IsRightAcyclic J]` is genuinely consumed in `rightDerivedShiftIsoOfSplitResolutionSES`: the body calls `G.isZero_homology_mapHomologicalComplex_of_isRightAcyclic I_J k` (and `I_J (k+1)`), both of which require `[G.IsRightAcyclic J]`. Without it the body does not typecheck.
  - **[CLEAR]** `splits` is genuinely consumed: the body calls `shortExact_map_mapHomologicalComplex_of_degreewise_splitting splits G` as its first step; without `splits` the `hSG` have statement cannot be obtained and `δIso` cannot be applied.
  - **[CLEAR]** `mono_biprod_lift_factorThru_of_exact` proof is logically sound: postcompose `hx` with `biprod.fst/snd` → extract the two component equations → cancel `γ` (`[Mono γ]`) to kill `x ≫ S.g` → use `hS.lift` to factor through kernel → cancel `α` (`[Mono α]`) to conclude the lift is zero → rewrite back. All steps have standard Mathlib backing (`Preadditive.mono_iff_cancel_zero`, `Injective.comp_factorThru`, `ShortComplex.Exact.lift_f`).
  - **[CLEAR]** The `by simp` at line 167 proves `ComplexShape.up ℕ |>.Rel (k+1) (k+2)`, which unfolds to `k+2 = k+1+1`. `simp` closes this; it compiles without error.
  - **[MINOR]** Line 141-152 (docstring of `rightDerivedShiftIsoOfSplitResolutionSES`): claims "Given a short exact sequence `0 → A → J → Z → 0`" as context, but no object-level SES is among the declaration's hypotheses. `A`, `J`, `Z` are unrelated objects; only the complex-level chain maps `φ`, `ψ` and the `splits` data connect them. The statement is strictly more general than a dimension-shift across a SES with acyclic middle — it holds for any three independent injective resolutions with a split complex-level SES between them. See Flagged Issues §1.
  - **[MINOR]** Lines 282-287 (inside `/-! -/` comment, code fence labeled "Output type (suggested):"): the suggested signature `def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜) ...` has dead implicit parameters `{A B C : 𝒜}` — these names appear in the argument list but nowhere in the type (the body uses `ses.X₁`, `ses.X₂`, `ses.X₃`). The signature is inside a comment and labeled "suggested", so it is not a real declaration, but the dead parameters could mislead the prover when implementing. See Flagged Issues §2.
  - **[CLEAR]** The large strategy comment block (lines 197–347) accurately represents the current file state: it names all four "done" declarations as present and axiom-clean, and correctly identifies three unformalized TARGETs (ofShortExact, rightDerivedShiftIsoOfAcyclic, rightDerivedIsoOfAcyclicResolution) that do NOT appear as actual Lean stubs. No false claims about formalization status.
  - **[CLEAR]** The module-level docstring (lines 19–34) is forward-looking ("will be constructed by the prover") about the three missing declarations — not a false completeness claim.
  - **[CLEAR]** No excuse-comments of the form "temporary / wrong but works / TODO replace". The `-- Note: ...` comment at line 92-93 explains matching convention, not a code deficiency.
  - **[CLEAR]** `isoRightDerivedObj` direction confirmed via hover (line 114): iso goes `(G.rightDerived n).obj J ≅ H^n(G(I.cocomplex))`. The chain composition in `rightDerivedShiftIsoOfSplitResolutionSES` (forward `I_Z` iso, then `δIso`, then reversed `I_A` iso) is correctly typed.
  - **[CLEAR]** `omit [HasInjectiveResolutions 𝒜] in` is used correctly on `shortExact_of_degreewise_splitting`, `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`, and `mono_biprod_lift_factorThru_of_exact` — all three are pure abstract-category statements that do not require injective resolutions.
  - **[CLEAR]** `Functor.IsRightAcyclic.ofInjective` (line 89-93): proof body `Functor.isZero_rightDerived_obj_injective_succ G k J` exactly matches the class field type. Instance is sound and priority 100 is a sensible default.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `AcyclicResolution.lean:141-152` — Docstring for `rightDerivedShiftIsoOfSplitResolutionSES` refers to "a short exact sequence `0 → A → J → Z → 0`" as given context, but no object-level SES appears in the hypotheses. The declaration is strictly more general: it works for any three independent injective resolutions with a complex-level split SES between them, regardless of whether the objects `A`, `J`, `Z` are related by a SES. The misleading framing could cause a reader to think this theorem is weaker than it is, or to believe there is a hidden SES hypothesis.

- `AcyclicResolution.lean:282-287` — Inside the `/-! -/` strategy comment, the suggested signature for `InjectiveResolution.ofShortExact` has unused implicit parameters `{A B C : 𝒜}` that do not appear in the type. The type uses `ses.X₁`, `ses.X₂`, `ses.X₃`. The dead parameters are likely a copy-paste artifact from an earlier drafting style. Suggested fix for the comment: either remove `{A B C : 𝒜}` from the suggestion, or replace the body with `ses.X₁`, `ses.X₂`, `ses.X₃` consistently referenced as `A`, `B`, `C`.

- `AcyclicResolution.lean:322,346` — Lean style linter flags two long lines (>100 chars) inside the strategy comment block. Not a code quality issue, but these suppress-able warnings will appear on every build until addressed or linted-out.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3 (documentation mismatch in docstring; dead parameters in suggested comment signature; style linter warnings on comment lines)
- **excuse-comments**: 0

Overall verdict: The five new declarations are mathematically sound, axiom-clean, and genuinely non-vacuous; the strategy comment block is accurate about what is and is not formalized; no must-fix or major issues found.
