# Lean ↔ Blueprint Check Report

## Slug
differentials-review123

## Iteration
123

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean` (537 lines, 12 declarations)
- Blueprint: `blueprint/src/chapters/Differentials.tex` (286 lines, 7 `\lean{...}`-tagged blocks)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (def:relative_kaehler_presheaf, L15)
- **Lean target exists**: yes (Differentials.lean:51)
- **Signature matches**: yes — `(f : X ⟶ S) : X.PresheafOfModules`, built via `pullbackPushforwardAdjunction` + `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`, exactly the construction the prose specifies.
- **Proof follows sketch**: N/A (definition)
- **notes**: Body matches the chapter's "pair $f^{-1}_\mathrm{psh}\struct{S}$ with $\struct{X}$ via the adjunction-transpose of $f^\sharp$" description verbatim.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler}` (lem:relative_kaehler_presheaf_obj, L24)
- **Lean target exists**: yes (Differentials.lean:60)
- **Signature matches**: yes — equality of section type with the Kähler differential of the ring-hom obtained from the adjunction transpose at `op V`.
- **Proof follows sketch**: yes — proof is `rfl`, matching the chapter's "by definition of `relativeDifferentials'`; the identification is by `rfl` after unfolding" sketch.
- **notes**: Clean, direct match.

### `\lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}` (thm:smooth_locally_free_omega, L51)
- **Lean target exists**: yes (Differentials.lean:516)
- **Signature matches**: yes — `[SmoothOfRelativeDimension n f]` hypothesis (matching the chapter's note rem:smooth_class_naming about deprecated `IsSmoothOfRelativeDimension`), output exists ∃-pack of `(U, V, e)` with `Module.Free` ∧ `Module.rank … = n` over the appLE algebra structure.
- **Proof follows sketch**: yes — Lean uses `exists_isStandardSmoothOfRelativeDimension` (an alternative API to the `mk_iff` route the chapter prose names, but the same mathematical content); applies `IsStandardSmoothOfRelativeDimension.isStandardSmooth`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` matching Steps 2/3/4 of the chapter sketch. `Nontrivial V` discharged via `Nonempty V` from `hxV` (different but equivalent to chapter Step 4.5 via `component_nontrivial`).
- **notes**: minor — chapter Step 1 prose pins `smoothOfRelativeDimension_iff` (the `mk_iff`-generated unfolding); Lean uses `exists_isStandardSmoothOfRelativeDimension` (a downstream existence packager). Same result, different API entry point. Chapter Step 4.5 names `Scheme.component_nontrivial`; Lean derives `Nontrivial Γ(X, V)` via `Nonempty V` and instance synthesis. Both API-style drift, not semantic.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE}` (thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE, L116)
- **Lean target exists**: yes (Differentials.lean:427)
- **Signature matches**: yes — `LinearEquiv` over `Γ(X, V)` between the presheaf section and `CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e)`, matching the chapter's `≃ₗ[B]` framing.
- **Proof follows sketch**: yes — Lean's M1.e assembly:
  - Names `Acolim` and `φV` (the adjunction-transpose evaluated at `op V`).
  - Pulls `IsLocalization` instance from `appLE_isLocalization` (the M1.b lemma).
  - Builds `IsScalarTower Γ(S, U) Acolim Γ(X, V)` from `appLE_colimRingHom_comp_φV` (the L116 factorisation lemma).
  - Returns `.symm` of the M1.d tower-cancellation equivalence `kaehler_quotient_localization_iso`.
  This is a faithful realization of the chapter's M1.e "combine rfl + M1.d iso `.symm`" sketch.
- **notes**: Body is structurally clean; uses the project-local helper `appLE_colimRingHom_comp_φV` (Differentials.lean:116), which is the factorisation identity that the chapter implicitly relies on but does not name. See blueprint adequacy section below.

### `\lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}` (lem:appLE_isLocalization, L157)
- **Lean target exists**: yes (Differentials.lean:282)
- **Signature matches**: yes — `IsLocalization (appLE_unitSubmonoid f hU hV e) A_colim` under the `appLE_colimAlgebra f e` algebra structure, matching the chapter's `IsLocalization M A_colim` claim.
- **Proof follows sketch**: **partial** — iter-123 prover landed Steps 1 (forward map via `IsLocalization.lift`) and 4 (reduction via `IsLocalization.isLocalization_of_algEquiv`) inside the body (L302–331). Steps 2 (cofinality / backward map) and 3 (inverse identities) are packaged into a single residual `sorry` at L362 on a `Localization M ≃ₐ[Γ(S, U)] A_colim`. Step 0 is delegated to `isUnit_appLE_unitSubmonoid_in_colim` (closed iter-122; see below). The body's strategy comments (L290–L301 prelude + L322–L361 residual scaffolding) faithfully restate the chapter's Step 0–4 plan, with the residual sorry tightly scoped to the AlgEquiv construction.
- **notes**: The `\leanok` marker on the chapter's proof block (L164) is currently misaligned with the file state (1 `sorry` remains), but this is `sync_leanok`'s responsibility — flagged for informational record only.

### `\lean{AlgebraicGeometry.Scheme.kaehler_localization_subsingleton}` (lem:kaehler_localization_subsingleton, L193)
- **Lean target exists**: yes (Differentials.lean:372)
- **Signature matches**: yes — `Subsingleton (Ω[L⁄A])` from `IsLocalization M L`.
- **Proof follows sketch**: yes — `letI` of `FormallyUnramified.of_isLocalization` followed by `FormallyUnramified.subsingleton_kaehlerDifferential`. Exactly the chapter's two-line re-export.
- **notes**: Faithful match. The Lean uses `letI` (instance) where the chapter prose says `haveI`; semantically identical.

### `\lean{AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso}` (lem:kaehler_quotient_localization_iso, L207)
- **Lean target exists**: yes (Differentials.lean:388)
- **Signature matches**: yes — `Ω[B⁄A] ≃ₗ[B] Ω[B⁄L]` under `IsLocalization M L` and the `IsScalarTower A L B`.
- **Proof follows sketch**: yes — Lean uses `LinearEquiv.ofBijective (KaehlerDifferential.map A L B B)` with injectivity from `exact_mapBaseChange_map` (chapter's "exact sequence has zero LHS") + surjectivity from `map_surjective`. The `Subsingleton (TensorProduct L B (Ω[L⁄A]))` argument (Lean L400–409) is the formal version of the chapter's "tensoring against a subsingleton gives zero" claim.
- **notes**: Direct, faithful formalization of the chapter's exact-sequence argument.

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` at Differentials.lean:362: one residual `sorry` on a `Localization M ≃ₐ[Γ(S, U)] A_colim`. **Severity: not a red flag** — this is the in-flight M1.b prover target; the blueprint at lem:appLE_isLocalization explicitly identifies it as "the heart of the bridge" and the iter-123 prover landed Steps 1 and 4 of the four-step plan, with Steps 2–3 explicitly scoped into this single AlgEquiv hole. The body has 30+ lines of strategy comments delineating the cofinality + basic-open-cover work that closes the sorry, and the residual is tightly scoped (one term, not a placeholder for a substantive lemma the chapter claims is proved elsewhere).

### Excuse-comments
None. All comments in the file are strategy/algorithm descriptions, not "TODO: replace with real def" or "wrong but works for now" excuses.

### Axioms / Classical.choice on non-trivial claims
None. The file uses no `axiom` and no manual `Classical.choice` on substantive claims.

## Unreferenced declarations (informational)

The file contains five Lean declarations not pinned by any `\lean{...}` in the chapter:

1. **`AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid`** (L78) — the submonoid $M$ of "good" elements that the chapter defines in §sec:bridge M1.a (L132–136). Substantive named declaration; the chapter introduces it as a named object ($M$) but does not pin the Lean name. **Recommend adding a `\lean{...}` reference.** Severity: minor.

2. **`AlgebraicGeometry.IsAffineOpen.appLE_colimRingHom`** (L97) — the canonical ring map $A \to A_\mathrm{colim}$. The chapter refers to it as "the canonical ring homomorphism $A \to A_\mathrm{colim}$" (L159, lem:appLE_isLocalization prose) without pinning a Lean name. Helper-shaped but visible in the chapter's argument. Severity: minor.

3. **`AlgebraicGeometry.IsAffineOpen.appLE_colimAlgebra`** (L106) — the `Algebra Γ(S, U) A_colim` structure transported from `appLE_colimRingHom`. The chapter's M1.b prose treats the algebra structure implicitly; this is plumbing. Severity: minor.

4. **`AlgebraicGeometry.IsAffineOpen.appLE_colimRingHom_comp_φV`** (L116) — factorisation lemma `(appLE_colimRingHom f e) ≫ φV = f.appLE U V e`. Crucially used by `relativeDifferentialsPresheaf_equiv_kaehler_appLE` (L478) to establish the `IsScalarTower` instance needed for M1.d. The chapter implicitly relies on this identity in M1.e but does not pin or name it. **This is the most notable unreferenced declaration — it carries the cocone-leg triangle identity that bridges M1.b and M1.d.** Severity: minor (could be promoted to a chapter block, but no semantic claim is broken).

5. **`AlgebraicGeometry.IsAffineOpen.isUnit_appLE_unitSubmonoid_in_colim`** (L164) — the Step 0 helper extracted as a top-level theorem (closed iter-122; full proof body L171–267). The chapter currently inlines Step 0 inside the proof of lem:appLE_isLocalization (L167) without a `\lean{...}` pointer to this declaration. **Recommend adding a `\lean{...}` sub-block or restructuring lem:appLE_isLocalization to expose Step 0 as a separate lemma.** Severity: minor (the directive explicitly flagged this as a documentation-drift candidate; it is genuine drift, but downstream provers can still navigate from the inlined Step 0 prose to the theorem name by greppable convention).

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough detail to formalize this file correctly?

- **Coverage**: 7/12 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 5 declarations, of which 3 are pure plumbing helpers (`appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`), 1 is the named submonoid $M$ from chapter prose (`appLE_unitSubmonoid`, minor), and 1 is the iter-122 Step 0 extraction (`isUnit_appLE_unitSubmonoid_in_colim`, minor — see directive item 3).

- **Proof-sketch depth**: **adequate**. The chapter's Step 0–4 plan for lem:appLE_isLocalization is detailed enough that the iter-123 prover landed Steps 1 and 4 directly, and scoped Steps 2–3 into a single AlgEquiv hole with a clear closure plan (cofinality + basic-open-cover + `IsLocalization.map` + `IsColimit.hom_ext`). The chapter names the relevant Mathlib lemmas (`isLocalization_basicOpen`, `IsLocalization.lift`, `IsLocalization.ringHom_ext`, `IsLocalization.of_le` / `isLocalization_of_algEquiv`) and the supporting analogist file (`analogies/relative-differentials-presheaf-bridge.md`). The iter-124 prover has a concrete plan to follow.

- **Hint precision**: **loose on one point**. At L175, the chapter says "implies `IsLocalization M A_colim` via `IsLocalization.of_le` … more directly via `IsLocalization.isLocalization_of_algEquiv` or `IsLocalization.of_ringEquiv`." This hedge is **misleading**: the planner verified (and the Lean confirms at L331) that an `AlgEquiv` is required — `IsLocalization.of_ringEquiv` would not give the `IsScalarTower`-compatible algebra structure needed for downstream M1.d, and `IsLocalization.of_le` is a structurally different pattern (relating localizations at $M \subseteq N$, not equiv-based). Similarly, the framing at L165 ("two-direction `IsLocalization.of_le` pattern") is stale — the actual Lean uses the equiv-based route. **Recommend tightening the prose** to pin `IsLocalization.isLocalization_of_algEquiv` as the lemma, removing the `of_ringEquiv` / `of_le` hedge. Severity: minor (does not break the prover's path; the Lean already uses the right lemma).

- **Generality**: **matches need**. The chapter does not over- or under-specify; the `\lean{...}` targets all sit at the granularity the project consumes.

- **Recommended chapter-side actions**:
  - **(minor)** Add `\lean{AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid}` to the M1.a definition of $M$ in §sec:bridge (around L134).
  - **(minor)** Add a `\lean{AlgebraicGeometry.IsAffineOpen.isUnit_appLE_unitSubmonoid_in_colim}` sub-block to Step 0 of the lem:appLE_isLocalization proof body (L167), or restructure Step 0 into its own `\begin{lemma}` block referencing this declaration. This reflects that the iter-122 work elevated Step 0 from inline prose to a top-level theorem.
  - **(minor)** At L175, tighten the closure-lemma hedge: drop `IsLocalization.of_ringEquiv` and `IsLocalization.of_le` from the alternatives, naming `IsLocalization.isLocalization_of_algEquiv` as the lemma actually used (with the AlgEquiv input documented). Similarly remove the "two-direction `IsLocalization.of_le` pattern" framing at L165 if it would mislead a fresh reader; the actual pattern is "build the forward `IsLocalization.lift` map, build a backward map, package as `AlgEquiv`, conclude via `isLocalization_of_algEquiv`."
  - **(minor)** Consider a `\lean{...}` reference to `appLE_colimRingHom_comp_φV` somewhere in the M1.e proof of thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE, since this factorisation identity is what establishes the `IsScalarTower` instance used to invoke M1.d.

## Severity summary

- **must-fix-this-iter**: none. The single residual `sorry` at Differentials.lean:362 is the in-flight M1.b prover target explicitly authorized by the chapter (which marks lem:appLE_isLocalization as "the heart of the bridge" and the remaining open work item). No placeholder bodies, no axioms, no excuse-comments, no signature mismatches. The chapter's `\leanok` markers may be temporarily misaligned with file state, but that is `sync_leanok`'s job to reconcile, not a checker finding.

- **major**: none.

- **minor**:
  1. `appLE_unitSubmonoid` (the named submonoid $M$) has no `\lean{...}` reference in §sec:bridge M1.a.
  2. `isUnit_appLE_unitSubmonoid_in_colim` (the iter-122 Step 0 helper) is now a top-level theorem but the chapter still inlines Step 0; no `\lean{...}` sub-block.
  3. Chapter L165 + L175 hedge between `IsLocalization.of_le` / `isLocalization_of_algEquiv` / `of_ringEquiv` is stale and could mislead — the planner-verified lemma is `isLocalization_of_algEquiv` (`AlgEquiv` is required, not `RingEquiv`).
  4. `appLE_colimRingHom_comp_φV` (factorisation lemma carrying the cocone-leg triangle identity that bridges M1.b → M1.e) is unreferenced; could be elevated to a `\lean{...}` block in the M1.e proof or a small adjacent lemma.

- **cosmetic**:
  - Chapter Step 1 of thm:smooth_locally_free_omega names `smoothOfRelativeDimension_iff` (the `mk_iff` form) but the Lean uses `exists_isStandardSmoothOfRelativeDimension` (a downstream existence form). Same mathematical content; the prose could note both API entry points.
  - Chapter Step 4.5 names `component_nontrivial`; Lean derives `Nontrivial Γ(X, V)` via `Nonempty V` from `hxV` and instance synthesis. Equivalent.

Overall verdict: **Lean follows the blueprint faithfully; chapter is adequate for the iter-124 prover to close the M1.b residual sorry, with four small documentation-drift items recommended for the chapter side (none blocking).**
