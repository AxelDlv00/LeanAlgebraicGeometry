# Lean Audit Report

## Slug
quot-iter043

## Iteration
043

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 4 flagged (stale iter-176/177 references in 4 top-level docstrings)
- **suspect definitions**: 4 flagged (pre-existing `sorry` bodies on the 4 blueprint-pinned declarations)
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (minor orphaned `set...with` name bindings)
- **excuse-comments**: 0
- **notes**:

  **Focus: `isLocalizedModule_basicOpen_of_hP1` (~line 2457)**

  - **Statement honesty**: CLEAN. Hypotheses `hU : IsAffineOpen U`, `hP1 : IsIso (fromTildeΓ ...)`, `f : Γ(X,U)` plus two typeclass parameters for `Module` and `IsScalarTower` are all genuine and non-vacuous. Conclusion `IsLocalizedModule (Submonoid.powers f) (restrictBasicOpenₗ M f)` is the correct gap2 statement. No placeholder hypotheses, no vacuous form.

  - **Proof authenticity**: GENUINE transport. The proof correctly:
    1. Sets `j = hU.fromSpec`, computes `eT : j ''ᵁ ⊤ = U` and `eB : j ''ᵁ D(f) = X.basicOpen f`.
    2. Defines `f_im = σ f` (the section under the gammaImageRingEquiv), proves `hf' : rfl`.
    3. Calls `section_localization_hfr_aux_general M j hP1 f_im f hf'` for the core localization over `A = Γ(X, j ''ᵁ ⊤)`.
    4. Builds ring iso `ρ : Γ(X, j ''ᵁ ⊤) ≃+* Γ(X, U)` via `asIso (X.presheaf.map (eqToHom eT.symm).op)`.
    5. Proves `ρ f_im = f` using the crux `fromSpec_image_top_section_coherence`.
    6. Transports via bridge (I) `isLocalizedModule_of_ringEquiv_semilinear`.
    No defeq abuse, no circular reasoning.

  - **`letI : Module … := Module.compHom …` + `show … from restrictₗ …` idiom** (lines 2475–2481): LEGITIMATE instance plumbing. There is no natural `Module Γ(X, j ''ᵁ ⊤) Γ(M, j ''ᵁ D(f))` instance in scope — the natural module is over `Γ(X, j ''ᵁ D(f))`. The `letI` creates a new restriction-of-scalars instance along `ii.op`, required so that `restrictₗ M ii` has the type `section_localization_hfr_aux_general`'s conclusion expects. The `show … from` coercion forces Lean to pick this `letI`-backed instance. Does NOT weaken or duplicate any prior in-scope instance.

  - **Orphaned `have`/`letI` in `isLocalizedModule_basicOpen_of_hP1`**: Three orphaned `with`-name bindings (minor noise; see minor issues below). All substantive `have`/`letI` bindings are consumed.

  **Focus: `change`/`eqToHom`/`Subsingleton.elim`**

  - **`Subsingleton.elim` uses** (lines 837, 2176, 2302, 2520, 2533): ALL legitimate. Every call resolves a morphism-equality goal in a thin category (`Opens X` or `Over (Opens X)` where morphisms between a fixed pair of opens are unique by the poset structure). No non-defeq goal is silently discharged.

  - **`eqToHom` uses** (lines 2151–2156, 2483–2498, 2300–2305): ALL transport along genuine propositional equalities of opens computed by named lemmas (`image_top_eq_opensRange`, `fromSpec_image_basicOpen`, etc.). The `asIso (X.presheaf.map (eqToHom …).op)` pattern correctly uses the fact that presheaf applied to `eqToHom` of an open equality is an isomorphism (its inverse is `eqToHom` of the symmetric equality). No silent non-defeq goal swap detected.

  - **`change` steps**: All `change` calls unfold definitionally equal terms (e.g. expanding `e₁ (a • x)` to the presheaf-map form, or rewriting a composition as a `≫`). No non-defeq swaps.

  **Focus: `maxHeartbeats` bumps**

  All 7 bump sites are justified:
  - Lines 1100–1102, 1163–1165, 1233–1235, 1252–1254, 1281–1283: `Presentation.map` across the equivalence functor triggers `IsRightAdjoint`/`HasSheafify` synthesis blow-up; comment at lines 1114–1116 cites the same `backward.isDefEq.respectTransparency false` incantation used in Mathlib's own `QuasicoherentData.bind`.
  - Line 2058: comment "Large multi-step assembly (localization combiner + `eqToHom` open-transport); needs headroom." — 1.6M heartbeats for `section_localization_hfr_aux`.
  - Line 2441: same justification for `isLocalizedModule_basicOpen_of_hP1`.

  **Pre-existing `sorry` bodies**

  - `hilbertPolynomial` (line 126), `QuotFunctor` (line 165), `Grassmannian` (line 201), `Grassmannian.representable` (line 228): `sorry` bodies, present since the initial commit (extracted from Algebraic-Jacobian-Challenge). Acknowledged in the module header as "iter-176 file-skeleton" placeholders. None of the gap1/gap2 chain depends on these.

  **Dead helper**

  - `gammaPullbackTopIso` (line 1843): defined and `\leanok`-marked in the blueprint (lem:pullback_gamma_top_iso), but never consumed by any Lean proof in the project. The actual proof chain uses `gammaPullbackImageIso f M ⊤` directly. Minor dead code.

  **Orphaned `set...with` name bindings (minor noise)**

  None affects correctness; all are equation-names from `set...with` that are not subsequently used:
  - `hresdef` (line 472) in `isLocalizedModule_tilde_restrict`
  - `hcomp` (line 629) in `isIso_fromTildeΓ_of_isLocalizedModule_restrict`
  - `hN` (lines 623, 1498) in `isIso_fromTildeΓ_of_isLocalizedModule_restrict` and `descent_surj`
  - `hM'` (line 2086) in `section_localization_hfr_aux`
  - `hA` (lines 2088, 2207) in `section_localization_hfr_aux` and `section_localization_hfr_basicOpen`
  - `hS` (line 2205), `hj` (lines 2206, 2464) in `section_localization_hfr_basicOpen` and `isLocalizedModule_basicOpen_of_hP1`
  - `hii` (line 2474), `hρ` (line 2485) in `isLocalizedModule_basicOpen_of_hP1`

  **Stale iter-number comments**

  The four main-goal docstrings contain "iter-177+" / "iter-176" references (lines 119–121, 156–159, 195–196, 216–224). These are iteration numbers from the pre-extraction project (Algebraic-Jacobian-Challenge uses a different counter). Since the current project is at iter-043, these numbers are meaningless. The bodies ARE `sorry` as stated, so the comments are not actively misleading about correctness, but they do mislead about timeline.

---

## Must-fix-this-iter

Per strict auditor rules (`:= sorry` on substantive claims):

- `AlgebraicJacobian/Picard/QuotScheme.lean:126` — `hilbertPolynomial` body is `:= sorry`. Why must-fix: sorry on a non-trivial load-bearing declaration (blueprint-pinned). **Note: pre-existing from initial commit; not new this iter; no current downstream proof depends on it.**
- `AlgebraicJacobian/Picard/QuotScheme.lean:165` — `QuotFunctor` body is `:= sorry`. Why must-fix: same rule. **Pre-existing; not new this iter.**
- `AlgebraicJacobian/Picard/QuotScheme.lean:201` — `Grassmannian` body is `:= sorry`. Why must-fix: same rule. **Pre-existing; not new this iter.**
- `AlgebraicJacobian/Picard/QuotScheme.lean:228` — `Grassmannian.representable` body is `:= sorry`. Why must-fix: same rule. **Pre-existing; not new this iter.**

*Auditor note: all four are acknowledged scaffolding in the module header ("iter-176 file-skeleton … body is a typed sorry"). They were present before this iteration and have not changed. The audit flags them per the strict must-fix rule but they represent the project's not-yet-proven main goals, not regressions or new holes.*

---

## Major

- `AlgebraicJacobian/Picard/QuotScheme.lean:1843` — `gammaPullbackTopIso` is defined, `\leanok`-marked in the blueprint, but never consumed by any Lean proof in this project (confirmed by project-wide grep). The proof chain uses `gammaPullbackImageIso f M ⊤` directly. Dead helper accumulating in the file.

- `AlgebraicJacobian/Picard/QuotScheme.lean:119–224` — Four docstrings contain "iter-177+" / "iter-176 file-skeleton" references from the pre-extraction project. These iteration numbers are meaningless in Quot-Foundations (current iter is 043) and mislead future readers about project progress.

---

## Minor

- `AlgebraicJacobian/Picard/QuotScheme.lean:472` — `with hresdef` in `isLocalizedModule_tilde_restrict`: the equation name `hresdef` is never referenced. Orphaned.
- `AlgebraicJacobian/Picard/QuotScheme.lean:623` — `with hN` in `isIso_fromTildeΓ_of_isLocalizedModule_restrict`: equation name `hN` unused.
- `AlgebraicJacobian/Picard/QuotScheme.lean:629` — `with hcomp` in `isIso_fromTildeΓ_of_isLocalizedModule_restrict`: equation name `hcomp` unused (proof uses `hcompose` from a separate `have`, not `hcomp`).
- `AlgebraicJacobian/Picard/QuotScheme.lean:1498` — `with hN` in `descent_surj`: equation name `hN` unused.
- `AlgebraicJacobian/Picard/QuotScheme.lean:2086` — `with hM'` in `section_localization_hfr_aux`: equation name `hM'` unused.
- `AlgebraicJacobian/Picard/QuotScheme.lean:2088,2207` — `with hA` in `section_localization_hfr_aux` and `section_localization_hfr_basicOpen`: equation name `hA` unused in both.
- `AlgebraicJacobian/Picard/QuotScheme.lean:2205` — `with hS` in `section_localization_hfr_basicOpen`: equation name `hS` unused.
- `AlgebraicJacobian/Picard/QuotScheme.lean:2206,2464` — `with hj` in `section_localization_hfr_basicOpen` and `isLocalizedModule_basicOpen_of_hP1`: equation name `hj` unused in both.
- `AlgebraicJacobian/Picard/QuotScheme.lean:2474` — `with hii` in `isLocalizedModule_basicOpen_of_hP1`: equation name `hii` unused.
- `AlgebraicJacobian/Picard/QuotScheme.lean:2485` — `with hρ` in `isLocalizedModule_basicOpen_of_hP1`: equation name `hρ` unused (proof uses `hρf` from a later `have`, not `hρ`).

---

## Excuse-comments (always called out separately)

None found. No declaration in this file carries a comment of the form "temporary", "placeholder", "wrong but works", "TODO replace", etc. The module header's "iter-176 file-skeleton the body is a typed sorry" is a workflow status note, not an excuse-comment — it accurately describes the body and does not promise an incorrect definition.

---

## Severity summary

- **must-fix-this-iter**: 4 — pre-existing `sorry` bodies on the 4 blueprint-pinned declarations (not new this iter; no downstream chain blocked)
- **major**: 2 — `gammaPullbackTopIso` dead helper; stale iter-176/177 docstring comments
- **minor**: 10 — orphaned `set...with` equation names across the file
- **excuse-comments**: 0

Overall verdict: The new `isLocalizedModule_basicOpen_of_hP1` declaration and its proof are clean — honest statement, genuine transport, no defeq abuse, no suspect instance manipulation, no orphaned bindings. The file's Lean quality is high for its size. The 4 must-fix items are pre-existing scaffold `sorry`s, not new holes; the major items are housekeeping (dead helper + stale iter numbers) carried over from extraction.
