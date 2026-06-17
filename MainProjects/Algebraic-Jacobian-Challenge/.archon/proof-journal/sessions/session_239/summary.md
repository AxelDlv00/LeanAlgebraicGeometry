# Session 239 (iter-239) — review

## Metadata
- **Iteration / session:** 239.
- **Two prover lanes, both `partial`/`blocked`** — no canonical sorry eliminated.
  - `Cohomology/FlatBaseChange.lean` [prove, engine] — **partial.** 2 new axiom-clean bricks; `hloc` still open.
  - `Picard/TensorObjSubstrate.lean` [mathlib-build, A.1.c substrate] — **blocked.** 1 axiom-clean brick; the 3 named targets structurally impossible under the dispatched recipe.
- **Per-file sorry deltas:**
  - FlatBaseChange: 2 → 3 (real `sorry` tokens at L572, L604, L626). The net +1 sits in the **new** blueprint-pinned decl `pushforward_spec_tilde_iso` (the `\lean{}` pin was previously dangling); the two pre-existing sorries (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) were left untouched as directed.
  - TensorObjSubstrate: 2 → 2 (real `sorry` at L715 `exists_tensorObj_inverse`, L1005 PicSharp scaffold — both untouched). The blocked targets were left **absent** (no sorry added) per the no-sorry-pin invariant.
- **Build:** GREEN on both files (`lake env lean` exit 0; only `Sheaf.val` deprecations + `sorry`/long-line warnings).
- **Axioms re-verified first-hand (review agent):** `gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`, `sheafifyTensorUnitIso` all `{propext, Classical.choice, Quot.sound}`. The `sheafifyTensorUnitIso` source-scan "opaque" flag (L488) is a comment word, not an axiom dependency — confirmed by reading the line. **No laundering.**
- **sync_leanok:** iter 239, sha `b336dd06`, **+0 / −9**, `Cohomology_FlatBaseChange.tex` only. The 9 removals are the script correctly retracting `\leanok` from the FlatBaseChange chapter as the `hloc`/`affineBaseChange` route remained open (the new `pushforward_spec_tilde_iso` pin resolves to a sorry-bearing decl → no `\leanok`, correct).
- **Blueprint-doctor:** CLEAN (no orphan chapters, no broken `\ref`/`\uses`, no new `axiom`).

## Lane 1 — `Cohomology/FlatBaseChange.lean` (engine, `pushforward_spec_tilde_iso` / `hloc`)

### What landed (axiom-clean, both reusable)
1. **`gammaPushforwardIsoAt`** — the open-indexed generalization of `gammaPushforwardIso`:
   `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))` for *any* open `U`. This is exactly
   blueprint movement (1) `e_{D(a)}`. Proof = `gammaPushforwardIso`'s body with `op ⊤ → op U / op V`;
   it typechecks because `modulesSpecToSheaf` restricts scalars uniformly at the top open, so the same
   `restrictScalarsComp'App` ×2 + `eqToIso(globalSectionsIso_hom_comp_specMap_appTop)` reconciliation
   works verbatim at any `U`.
2. **`tildeRestriction_isLocalizedModule`** — the `R'`-side input: `Γ(M^~,⊤) → Γ(M^~,D b)` (read in
   `ModuleCat R'`) is `IsLocalizedModule (powers b)`. Proof: `tilde.toOpen M ⊤` is a localization at
   `powers 1` (via `basicOpen_one`), hence bijective; the triangle `tilde.toOpen_res` +
   `LinearEquiv.eq_comp_toLinearMap_symm` + `IsLocalizedModule.of_linearEquiv_right` transport the known
   `powers b`-localization `tilde.toOpen M (basicOpen b)` onto the restriction.

### Attempt trail (from `attempts_raw.jsonl`)
- **Building `tildeRestriction_isLocalizedModule`** hit three carrier/rewrite walls before closing:
  - `PrimeSpectrum.basicOpen_one ▸ inferInstance` → *"rewrite failed: Did not find pattern ⊤"*; then
    `simpa only [basicOpen_one]` → *"typeclass instance problem is stuck CommSemiring ?m"*. **Fix:**
    `have h := inferInstance; rw [PrimeSpectrum.basicOpen_one] at h; exact h` (`▸`/`simpa` do not rewrite
    inside the dependent `tilde.toOpen M (basicOpen 1)`).
  - Pointwise `LinearMap.comp_apply`/`comp_assoc`/`simp [coe_comp]` on `(f ∘ₗ ↑e) x` with `f` a
    CommRingCat-coerced `ModuleCat.Hom.hom` → no fire (`∘ₗ` won't unify the `∘ₛₗ` pattern). **Fix:**
    rewrite the *equation* via `LinearEquiv.eq_comp_toLinearMap_symm`, then `of_linearEquiv_right`. Closed.
- **Discharging `hloc(a)`** (the residual after `pushforward_spec_tilde_iso_of_isLocalizedModule φ M`):
  `letI : Module R (R'-section) := Module.compHom _ φ.hom` → *"failed to synthesize Module ↑R
  ↑(Γ(M^~,⊤))"* — the `compHom` `R`-action is not consumed by `LinearMap.restrictScalars R` and clashes
  with the `modulesSpecToSheaf`-supplied `R`-action. Left a **documented typed `sorry`** with the full
  `of_linearEquiv` decomposition in-code. **4th recurrence of the Module-R / smul carrier wall.**

### Blocker (named, recurring)
`hloc(a)` needs an `R`-action on the `R'`-side sections via restriction along `φ`, plus the naturality
square `e₂.hom ∘ ρ = (restrictScalars φ σ) ∘ e₁.hom`. The square cannot be proved without unfolding
`gammaPushforwardIsoAt` and invoking naturality of `ModuleCat.restrictScalarsComp'App` in its module
argument (Mathlib-absent, ~30–50 LOC by hand). The `affineBaseChange_pushforward_iso` hard commitment
(carried since iter-237, re-fired through the iter-238 corrective) is **again not met** — but real recovery:
two genuinely-needed bricks landed and `hloc` is now the single, sharply-localized residual.

## Lane 2 — `Picard/TensorObjSubstrate.lean` (A.1.c substrate, `IsInvertible.pullback`)

### What landed (axiom-clean, reusable)
- **`sheafifyTensorUnitIso`** (private, L884): `a(P⊗ₚQ) ≅ a((aP).val ⊗ₚ (aQ).val)` where
  `a = PresheafOfModules.sheafification (𝟙 𝒪_X)`. Same technique as `tensorObj_assoc_iso`: whisker the
  sheafification unit `η` on each side (both `J.W` via `W_toSheafify` + `W_whisker{Left,Right}_of_W`,
  flatness-free), `a` inverts `J.W` maps via `isIso_sheafification_map_of_W`, compose the two `asIso`s.
  This is the RHS reconciliation the eventual `pullbackTensorIso` will consume.
  - Gotchas: statement must use `PresheafOfModules.Monoidal.tensorObj (R := X.presheaf)` explicitly
    (else `(aP).val` fails `MonoidalCategoryStruct` synth); left-whisker object given explicitly
    `(a.obj P).val ◁ η.app Q`; keep the `letI instMS` `Sheaf.val` bridge.

### The wall (verified live — the plan-agent recipe is structurally impossible)
- `Scheme.Modules.pullback f = SheafOfModules.pullback f.toRingCatSheafHom`, and the underlying
  `PresheafOfModules.pullback φ.hom`, are **both `(pushforward _).leftAdjoint`** — abstract left adjoints
  with **no sectionwise and no stalkwise formula** in the pinned Mathlib (grep of
  `ModuleCat/{Presheaf,Sheaf}/` finds no `pullback_obj` / `pullbackObjIso` / `pullback…Monoidal`).
- The dispatched recipe ("presheaf pullback is strong-monoidal sectionwise via `(extendScalars f).Monoidal`;
  assemble the sectionwise tensorators `μ`") **cannot typecheck** — there is no sectionwise `(pullback φ).obj`
  to attach the `extendScalars` tensorator to.
- `Adjunction.leftAdjointOplaxMonoidal` yields the comparison map `δ : f^*(A⊗B) ⟶ f^*A ⊗ f^*B` for free
  from `pushforward` lax-monoidal — but only at the PRESHEAF level (no `MonoidalCategory (SheafOfModules …)`);
  proving `IsIso δ` reduces back to the same missing sectionwise identification.
- `SheafOfModules.pullbackObjUnitToUnit` is an iso only under `F.Final` (open immersions); false for general `f`.

### Attempt trail
- Built `sheafifyTensorUnitIso` (closed).
- Drafted `pullbackUnitIso` via `isIso_of_isIso_restrict (pullbackObjUnitToUnit f)`; probed per-chart goal
  `IsIso ((restrictFunctor V.ι).map (pullbackObjUnitToUnit …))` — needs Mathlib-absent naturality of
  `pullbackObjUnitToUnit` against `pullbackComp`/`restrictFunctorIsoPullback`. **Removed the draft** (with
  its single probe `sorry`) to honor the no-sorry invariant. The 3 named targets were left **absent**, with
  a concrete in-file HANDOFF pivot block.

## Tooling note (carried)
The informal agent is **unavailable**: `MOONSHOT_API_KEY` returns HTTP 401 (invalid auth) — same as
iter-234/236; no other provider key set. Both provers' analyses are Mathlib-source-derived. This blocks the
"external sketch when stuck" affordance; flagged in TO_USER and recommendations.

## Blueprint markers updated (manual)
- None. No `\notready`/`\mathlibok` present in either active chapter; the new bricks are project-local proofs
  (not Mathlib re-exports → no `\mathlibok`); no prover renamed a plan-pinned declaration; the
  `pushforward_spec_tilde_iso` pin now resolves to an existing sorry-bearing decl (correctly carries no
  `\leanok` after sync). The 3 blocked pullback blocks (`lem:pullback_tensor_iso`/`pullback_unit_iso`/
  `isinvertible_pullback`) have no Lean declaration yet → stay unmarked (correct).
- Note for the plan agent (NOT a marker action): the two new project-local decls `gammaPushforwardIsoAt`
  and `tildeRestriction_isLocalizedModule` are unpinned; the plan agent may want to add `\lean{}` blocks.

## Key findings / patterns
- `∘ₗ` does not unify the `∘ₛₗ` pattern on CommRingCat-coerced `ModuleCat.Hom.hom`; rewrite the equation
  via `LinearEquiv.eq_comp_toLinearMap_symm` instead of pointwise.
- `▸`/`simpa [basicOpen_one]` do not rewrite inside a dependent `tilde.toOpen M (basicOpen 1)`; use
  `have h := inferInstance; rw [basicOpen_one] at h; exact h`.
- `letI : Module R (R'-module) := Module.compHom _ φ.hom` is **not** consumed by `LinearMap.restrictScalars R`
  — the live carrier wall (now in its 4th recurrence; see recommendations).
- Abstract-left-adjoint pullback (`(pushforward).leftAdjoint`) has no sectionwise/stalkwise formula: any
  recipe phrased "sectionwise via `extendScalars`" is structurally impossible; the route is local-chart-finality
  via `isIso_of_isIso_restrict`, or a FLAT-restricted variant.

## Subagent reports (this iter)
Three review subagents dispatched (`.lean` files were modified → both highly-recommended review subagents apply):
- **`lean-auditor-ts239`** (`task_results/lean-auditor-ts239.md`): the three new decls
  (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`, `sheafifyTensorUnitIso`) confirmed genuine,
  non-vacuous, axiom-clean; `pushforward_spec_tilde_iso` skeleton real with a single documented `sorry`. MAJOR:
  stale `tensorObj_assoc_iso` docstring + file STATUS block (route-(e) claim; carried from iter-238, unfixed).
  Its "must-fix"/"excuse-comment" calls on the open sorries (`affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) are the known
  tracked targets, not new laundering.
- **`lean-vs-blueprint-checker-flatbasechange`**: 11/13 pinned decls faithful; 4 major (2 unpinned new decls;
  blueprint movement (2) misdirection; carrier-wall obstacle absent from sketch). 0 must-fix.
- **`lean-vs-blueprint-checker-tensorobjsubstrate`**: MUST-FIX — `sec:tensorobj_pullback_monoidality` proof
  sketch is unformalizable (sectionwise pullback formula absent in Mathlib).

All HIGH/MAJOR/MUST-FIX findings are landed at the top of `recommendations.md` (CRITICAL/MAJOR/MEDIUM sections).

LOW / informational (notes only): both lvb checkers observed several sorry-free decls whose blueprint statement
blocks lack `\leanok` (FlatBaseChange `lem:pushforward_spec_tilde_iso` statement; TensorObjSubstrate
`tensorObj_unit_iso`, `isIso_of_isIso_restrict`, `homMk`, `dual`). `\leanok` is the deterministic
`sync_leanok` script's domain (it ran this iter, sha `b336dd06`, touching only the FlatBaseChange chapter), NOT
the review agent's — I did not touch any `\leanok`. If these are genuinely sorry-free + compiling, the next sync
should add them; flagged here only so the plan agent can confirm the script resolved every `\lean{}` name.

## Recommendations
See `recommendations.md` — top items: (1) FlatBaseChange `hloc` is on its armed reversing signal (do NOT
re-expand the blueprint a 5th time; pivot to `gammaPushforwardIsoAt`-naturality OR the tower route OR a
scheme-level `IsQuasicoherent`-of-affine-pushforward criterion); (2) `IsInvertible.pullback` recipe is dead —
do NOT re-dispatch the sectionwise-`extendScalars` recipe; run a mathlib-analogist / strategy-critic pass on
the FLAT-restricted alternative before committing prover effort; (3) provision a working informal-agent key.
